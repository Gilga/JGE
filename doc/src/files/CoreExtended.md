# [CoreExtended.jl](@id CoreExtended.jl)

* [Execute](#Execute-1)
* [Debug](#Debug-1)
* [Function](#Function-1)
* [Object](#Object-1)
* [Preset](#Preset-1)

## Execute
```@docs
CoreExtended.execute(m::Module, s::Symbol, args...)
```

```@docs
CoreExtended.execute(e::Expr, args...)
```

```@docs
CoreExtended.execute(f::Function, args...)
```

```@docs
CoreExtended.execute(t::Tuple{Bool,Any}, args...)
```

```@docs
CoreExtended.execute(r::Any, args...)
```

```@docs
CoreExtended.execute(r::Void, args...)
```

## Debug

```@docs
CoreExtended.exists(m::Module, s::Symbol)
```

```@docs
CoreExtended.debug(msg::String)
```

```@docs
CoreExtended.iscallable(f)
```

## Function

```@docs
CoreExtended.invoke(f::Function, args...)
```

```@docs
CoreExtended.stabilize(f::Function)
```

## Object

```@docs
CoreExtended.AbstractObjectReference
```

```@docs
CoreExtended.EmptyObject 
```

```@docs
CoreExtended.EMPTY_OBJECT
```

```@docs
CoreExtended.EMPTY_FUNCTION
```

## Update
```@docs
CoreExtended.hasVal(a::AbstractArray, getindex::Function)
```

```@docs
CoreExtended.replace(a::AbstractArray, f::Function, v::Any)
```

```@docs
CoreExtended.update(a::AbstractArray, getindex::Function, f::Function)
```

```@docs
CoreExtended.update(dict::Dict, index::Any, f::Function)
```

## Exception
```@docs
CoreExtended.OnException
```

```@docs
CoreExtended.linkToException
```

```@docs
CoreExtended.backTraceException(ex::Exception)
```

```@docs
CoreExtended.catchException(f::Function, exf=OnException)
```

## Preset
(Obsolete)
```@docs
CoreExtended.presetManager(T::DataType, S=T)
```