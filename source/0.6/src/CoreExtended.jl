module CoreExtended

export debug

global _debug = false

""" TODO """
debug(msg::String) = if _debug info(msg) end

# -------------------------------------------------------------

export EMPTY_FUNCTION

""" TODO """
const EMPTY_FUNCTION = () -> nothing

export iscallable

""" TODO """
iscallable(f) = !isempty(methods(f))

# -------------------------------------------------------------

export invoke
export stabilize
export execute
export exists

#method_exists(Symbol(script.mod, :OnRender))
""" TODO """
exists(m::Module, s::Symbol) = isdefined(m,s) #&& iscallable(catchException(()->eval(e)))

""" TODO """
execute(m::Module, s::Symbol, args...) = isdefined(m,s) ? execute(:($m.$s),args...) : nothing #(if isdefined(m,s) return execute(eval(m,s),args...); end; nothing)
#execute(o::Any, s::Symbol, args...) = isdefined(o,s) ? execute(:($o.$s),args...) : nothing

""" TODO """
execute(e::Expr, args...) = execute(catchException(()->eval(e)),args...)

""" TODO """
execute(f::Function, args...) = iscallable(f) ? invoke(f,args...) : nothing
#execute(f::Function, args...) = (debug("execute function("*string(args...)*")"); if iscallable(f) return invoke(f, args...); end; nothing)

""" TODO """
execute(t::Tuple{Bool,Any}, args...) = execute(t[1]?t[2]:nothing,args...)

""" TODO """
execute(r::Any, args...) = (debug("result "*string(typeof(r))); r)

""" TODO """
execute(r::Void, args...) = (warn("Cannot execute nothing"); r)

""" TODO """
function invoke(f::Function, args...)
	result = nothing
	catchException(()	-> result = @eval $f($(args...)))
	result
end

""" TODO """
stabilize(f::Function) = (args...) -> invoke(f, args...)

# -------------------------------------------------------------

export AbstractObjectReference
export EMPTY_OBJECT

""" TODO """
abstract type AbstractObjectReference end

""" TODO """
type EmptyObject <: AbstractObjectReference
	EmptyObject() = new() 
end

""" TODO """
const EMPTY_OBJECT = EmptyObject()

# -------------------------------------------------------------

import DataStructures
using DataStructures.SortedDict
using DataStructures.Forward
export SortedDict
export Forward #Base.Order.ForwardOrdering

# -------------------------------------------------------------

export catchException
export linkToException

#Base.show_backtrace(STDOUT,backtrace())

""" TODO """
OnException = (x)->nothing

""" TODO """
function linkToException(f::Function)
	global OnException = f
end

""" TODO """
function backTraceException(ex::Exception)
	println("--- [ BACKTRACE ] ---")
	Base.showerror(STDERR, ex, catch_backtrace())
	println("\n---------------------")
end

""" TODO """
function catchException(f::Function, exf=OnException)
	try return f()
	catch ex exf(ex)
	end
	nothing
end

linkToException(backTraceException)

# -------------------------------------------------------------

export hasVal
export replace
export update

""" TODO """
function hasVal(a::AbstractArray, getindex::Function)
	i=0; for v in a
		i+=1
		if getindex(v) return (i,v) end
	end
	#found=find(f,a)
	(0,nothing)
end

""" TODO """
function replace(a::AbstractArray, f::Function, v::Any)
	found=hasVal(f,a)
	if found[1] == 0 push!(a, v)
	else a[found[1]]=v
	end
end

#found=find(x -> x.name == p.name,program.properties)
#!haskey() push!(program.properties, p)

""" TODO """
function update(a::AbstractArray, getindex::Function, f::Function)
	found=hasVal(getindex,a)
	if found[1] == 0 push!(a, f((false,nothing)))
	else a[found[1]]=f((true,found[2]))
	end
end

""" TODO """
function update(dict::Dict, index::Any, f::Function)
	v=nothing
	try
		v=(true,dict[index])
	catch error
		if isa(error, KeyError) v=(false,nothing) end
	end
	if v != nothing dict[index]=f(v) end
end

# -------------------------------------------------------------

#obsolete
export presetManager
#obsolete
""" TODO """
function presetManager(T::DataType, S=T)
	mod=T.name.module
	#mname=Base.replace(string(S),r"\..*","")
	#mod=Module(Symbol(mname))
	#typ="EMPTY_"*uppercase(Base.replace(string(S),r"[^\.]+\.",""))
	reset = isdefined(mod,:resets) ? mod.resets : ()->nothing
	link = isdefined(mod,:link) ? mod.link : (x)->nothing
	unlink = isdefined(mod,:unlinks) ? mod.unlinks : ()->nothing
	
	eval(mod,
		Expr(:toplevel,
			:(
				const Typ = Union{Void,$T};
				list = SortedDict{Symbol, $S}(Forward);
			
				function create(k::Symbol);
					if !haskey(list,k);
						e=$S(k);
						list[k]=e;
						setSelected(e);
						if isdefined($mod,:init) init(e) end;
					else
						e=list[k];
						setSelected(e);
					end;
					e;
				end;
			
				selected = nothing;
				getSelected() = selected;
				setSelected(obj::Typ) = global selected = obj;
				
				get(k::Symbol) = list[k];
				set(k::Symbol, obj::Typ) = (list[k] = obj);
	
				function reset();
					unlink();
					$reset();
				end;

				isInvalid(obj::Typ) = obj == nothing || !isa(obj,$S);
				isLinked(obj::Typ) =	!isInvalid(obj) && obj == getSelected();

				function unlink() setSelected(nothing); $unlink(); end;

				function link();
					obj=getSelected();
					if !isInvalid(obj); $link(obj) else unlink() end;
				end;

				function linkTo(obj::Typ);
					other=getSelected();
					if other == obj return end;
					setSelected(obj);
					link();
				end;
			)
		)
	)
end

end # CoreExtended