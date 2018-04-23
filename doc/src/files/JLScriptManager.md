# [JLScriptManager.jl](@id JLScriptManager.jl)

## using 
* [CoreExtended](@ref CoreExtended.jl)
* [FileManager.FileSource](@ref FileManager.jl)

```@docs
JLScriptManager.JLComponent
```

```@docs
JLScriptManager.JLInvalidComponent
```

```@docs
JLScriptManager.JL_INVALID_COMPONENT
```

```@docs
JLScriptManager.JLStateListComponent
```

```@docs
JLScriptManager.JLScriptFunction
```

```@docs
JLScriptManager.JLScript(id::Symbol)
```

```@docs
JLScriptManager.JLScript(id::Symbol, source::FileManager.FileSource)
```

```@docs
JLScriptManager.loop(f::Function)
```

```@docs
JLScriptManager.listen(this::JLScriptManager.JLScript, k::Symbol, f::Function)
```

```@docs
JLScriptManager.run(this::JLScriptManager.JLScript, args...)
```

```
(this::JLScript)(s::Symbol, args...) = CoreExtended.execute(this.mod,s,args...)
```

```@docs
JLScriptManager.exists(this::JLScriptManager.JLScript, s::Symbol)
```

```@docs
JLScriptManager.execute(this::JLScriptManager.JLScript, compile_args=[], args...)
```

```@docs
JLScriptManager.execute(f::JLScriptManager.JLScriptFunction, args...)
```

```@docs
JLScriptManager.compile(this::JLScriptManager.JLScript, args...)
```

```@docs
JLScriptManager.cleanCode(code::String)
```

```@docs
JLScriptManager.eval(this::JLScriptManager.JLScript, args...)
```
