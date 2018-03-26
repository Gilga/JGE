module CoreExtended

export debug

global _debug = false
debug(msg::String) = if _debug info(msg) end

# -------------------------------------------------------------

export EMPTY_FUNCTION
const EMPTY_FUNCTION = () -> nothing

export iscallable

iscallable(f) = !isempty(methods(f))

# -------------------------------------------------------------

export invoke
export stabilize
export execute

execute(m::Module, s::Symbol, args...) = isdefined(m,s) ? execute(:($m.$s),args...) : nothing #(if isdefined(m,s) return execute(eval(m,s),args...); end; nothing)
#execute(o::Any, s::Symbol, args...) = isdefined(o,s) ? execute(:($o.$s),args...) : nothing
execute(e::Expr, args...) = execute(catchException(()->eval(e)),args...)
execute(f::Function, args...) = iscallable(f) ? invoke(f,args...) : nothing
#execute(f::Function, args...) = (debug("execute function("*string(args...)*")"); if iscallable(f) return invoke(f, args...); end; nothing)
execute(t::Tuple{Bool,Any}, args...) = execute(t[1]?t[2]:nothing,args...)
execute(r::Any, args...) = (debug("result "*string(typeof(r))); r)
execute(r::Void, args...) = (warn("Cannot execute nothing"); r)

function invoke(f::Function, args...)
	result = nothing
	catchException(()	-> result = f(args...)) #@eval 
	result
end

stabilize(f::Function) = (args...) -> invoke(f, args...)

# -------------------------------------------------------------

export AbstractObjectReference
export EMPTY_OBJECT

abstract AbstractObjectReference

type EmptyObject <: AbstractObjectReference
	EmptyObject() = new() 
end

const EMPTY_OBJECT = EmptyObject()

# -------------------------------------------------------------

export createSortedDict

import DataStructures
using DataStructures.SortedDict
export SortedDict

SortedDict(K, D, Ord=Base.Order.ForwardOrdering) = SortedDict{K,D,Ord}
SortedDict(D) = SortedDict{Symbol,D,Base.Order.ForwardOrdering}

createSortedDict(K, D, Ord=Base.Order.ForwardOrdering) = SortedDict(K,D,Ord)()
createSortedDict(D) = SortedDict(D)()
# -------------------------------------------------------------

export catchException
export linkToException

#Base.show_backtrace(STDOUT,backtrace())

OnException = (x)->nothing

function linkToException(f::Function)
	global OnException = f
end

function backTraceException(ex::Exception)
	println("--- [ BACKTRACE ] ---")
	Base.showerror(STDERR, ex, catch_backtrace())
	println("\n---------------------")
end

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

function hasVal(a::AbstractArray, getindex::Function)
	i=0; for v in a
		i+=1
		if getindex(v) return (i,v) end
	end
	#found=find(f,a)
	(0,nothing)
end

function replace(a::AbstractArray, f::Function, v::Any)
	found=hasVal(f,a)
	if found[1] == 0 push!(a, v)
	else a[found[1]]=v
	end
end

#found=find(x -> x.name == p.name,program.properties)
#!haskey() push!(program.properties, p)

function update(a::AbstractArray, getindex::Function, f::Function)
	found=hasVal(getindex,a)
	if found[1] == 0 push!(a, f((false,nothing)))
	else a[found[1]]=f((true,found[2]))
	end
end

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

export presetManager

presetManager(mod::Module,T::DataType) = presetManager(mod,T,T)

function presetManager(mod::Module,T::DataType, S::DataType)
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
				list = createSortedDict($S);
			
				function create(k::Symbol);
					if !haskey(list,k);
						e=$S(k);
						list[k]=e;
						setCurrent(e);
						if isdefined($mod,:init) init(e) end;
					else
						e=list[k];
						setCurrent(e);
					end;
					e;
				end;
			
				current = nothing;
				getCurrent() = current;
				setCurrent(obj::Typ) = global current = obj;
				#setCurrent(obj::Symbol) = setCurrent(create(obj));

				function reset();
					unlink();
					$reset();
				end;

				isInvalid(obj::Typ) = obj == nothing || !isa(obj,$S);
				isLinked(obj::Typ) =	!isInvalid(obj) && obj == getCurrent();

				function unlink() setCurrent(nothing); $unlink(); end;

				function link();
					obj=getCurrent();
					if !isInvalid(obj); $link(obj) else unlink() end;
				end;

				function linkTo(obj::Typ);
					other=getCurrent();
					if other == obj return end;
					setCurrent(obj);
					link();
				end;
			)
		)
	)
end

end # CoreExtended