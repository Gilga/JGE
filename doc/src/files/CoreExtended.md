# [CoreExtended.jl](@id CoreExtended.jl)

const EMPTY_FUNCTION = () -> nothing

iscallable(f) = !isempty(methods(f))

```
exists(m::Module, s::Symbol) = isdefined(m,s) #&& iscallable(catchException(()->eval(e)))
execute(m::Module, s::Symbol, args...) = isdefined(m,s) ? execute(:($m.$s),args...) : nothing #(if isdefined(m,s) return execute(eval(m,s),args...); end; nothing)
#execute(o::Any, s::Symbol, args...) = isdefined(o,s) ? execute(:($o.$s),args...) : nothing
execute(e::Expr, args...) = execute(catchException(()->eval(e)),args...)
execute(f::Function, args...) = iscallable(f) ? invoke(f,args...) : nothing
#execute(f::Function, args...) = (debug("execute function("*string(args...)*")"); if iscallable(f) return invoke(f, args...); end; nothing)
execute(t::Tuple{Bool,Any}, args...) = execute(t[1]?t[2]:nothing,args...)
execute(r::Any, args...) = (debug("result "*string(typeof(r))); r)
execute(r::Void, args...) = (warn("Cannot execute nothing"); r)
```

```
function invoke(f::Function, args...)
	result = nothing
	catchException(()	-> result = @eval $f($(args...)))
	result
end
```

```
stabilize(f::Function) = (args...) -> invoke(f, args...)
```

```
abstract type AbstractObjectReference end
```

```
type EmptyObject <: AbstractObjectReference
	EmptyObject() = new() 
end
```

```
const EMPTY_OBJECT = EmptyObject()
```

```
OnException = (x)->nothing
```

```
function linkToException(f::Function)
	global OnException = f
end
```

```
function backTraceException(ex::Exception)
	println("--- [ BACKTRACE ] ---")
	Base.showerror(STDERR, ex, catch_backtrace())
	println("\n---------------------")
end
```

```
function catchException(f::Function, exf=OnException)
	try return f()
	catch ex exf(ex)
	end
	nothing
end
```

```
function hasVal(a::AbstractArray, getindex::Function)
	i=0; for v in a
		i+=1
		if getindex(v) return (i,v) end
	end
	#found=find(f,a)
	(0,nothing)
end
```

```
function replace(a::AbstractArray, f::Function, v::Any)
	found=hasVal(f,a)
	if found[1] == 0 push!(a, v)
	else a[found[1]]=v
	end
end
```

```
function update(a::AbstractArray, getindex::Function, f::Function)
	found=hasVal(getindex,a)
	if found[1] == 0 push!(a, f((false,nothing)))
	else a[found[1]]=f((true,found[2]))
	end
end
```

```
function update(dict::Dict, index::Any, f::Function)
	v=nothing
	try
		v=(true,dict[index])
	catch error
		if isa(error, KeyError) v=(false,nothing) end
	end
	if v != nothing dict[index]=f(v) end
end
```

# obsolete
```
export presetManager
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
```