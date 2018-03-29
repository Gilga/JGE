module Management

using CoreExtended

abstract type IManagerReference end

list = SortedDict{Symbol, IManagerReference}(Forward)

type Manager{T} <: IManagerReference
	list::SortedDict{Symbol, T}
	selected::Union{Void,T}
	
	create::Function
	remove::Function
	init::Function
	reset::Function
	link::Function
	unlink::Function
	
	Manager{T}() where T = new(
		SortedDict{Symbol, T}(Forward),
		nothing,
		(id::Symbol) -> T(id),
		(obj::T) -> nothing,
		(obj::T) -> nothing,
		() -> nothing,
		(obj::T) -> nothing,
		() -> nothing
	)
end

function presetManager(T::DataType)
	m=createManager(T)
	
	eval(T.name.module,Expr(:toplevel,:(
		m=Management.list[Symbol($(T.name))];
		const Typ = Management.getType(m);

		create(k) = Management.create(m,k);
		getSelected() = Management.getSelected(m);
		setSelected(o) = Management.setSelected(m,o);

		get(k) =  Management.get(m,k);
		set(k,o) = Management.set(m,k,o);
		del(k) = Management.del(m,k);

		reset() = Management.reset(m);

		isInvalid(o) = Management.isInvalid(m,o);
		isLinked(o) = Management.isLinked(m,o);

		link() = Management.link(m);
		unlink() = Management.unlink(m);

		select(o) = Management.select(m,o);
	)))
	
	m
end

function createManager(T::DataType)
	k = Symbol(T.name)
	if !haskey(list,k)
		e=Manager{T}()
		list[k]=e
	else
		e=list[k]
	end
	e
end

function create{T}(m::Manager{T}, k::Symbol)
	if !haskey(m.list,k)
		e=m.create(k)
		m.list[k]=e
		setSelected(m,e)
		m.init(e)
	else
		e=m.list[k]
		setSelected(m,e)
	end
	e
end

getSelected{T}(m::Manager{T}) = m.selected
setSelected{T}(m::Manager{T}, obj::Union{Void,T}) = (m.selected = obj)
getType{T}(m::Manager{T}) = Union{Void,T}

get{T}(m::Manager{T}, k::Symbol) = m.list[k]
set{T}(m::Manager{T}, k::Symbol, obj::Union{Void,T}) = (m.list[k] = obj)

function del{T}(m::Manager{T}, k::Symbol)
	obj=get(m,k)
	selected=getSelected(m)
	if selected == obj unlink() end
	m.remove(obj)
	set(m,k,nothing)
end

function reset{T}(m::Manager{T})
	unlink(m)
	m.reset()
end;

isInvalid{T}(m::Manager{T}, obj::Union{Void,T}) = obj == nothing
isLinked{T}(m::Manager{T}, obj::Union{Void,T}) =	!isInvalid(m,obj) && obj == getSelected(m)

unlink{T}(m::Manager{T}) = (setSelected(m,nothing); m.unlink())

function link{T}(m::Manager{T})
	obj=getSelected(m)
	if !isInvalid(m,obj) m.link(obj)
	else unlink()
	end
end

function select{T}(m::Manager{T}, obj::Union{Void,T})
	other=getSelected(m)
	if other == obj return end
	setSelected(m,obj)
	link(m)
end

end #Management
