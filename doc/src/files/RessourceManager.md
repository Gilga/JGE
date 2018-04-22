# [RessourceManager.jl](@id RessourceManager.jl)


```
SetWorkingDir() = (PATHS[:ROOT] = string(dirname(Base.source_path()),"/"))
```

```
RessourcePath(path::AbstractString) = (!in(':',path) ? path = string(PATHS[:ROOT], path, path[length(path)] != '/' ? "/" : "") : path)
```

```
AddPath(id::Any, path::AbstractString) = PATHS[id] = RessourcePath(path)
```

```
GetPath(key::Any)
```

```
CurrentDay()
```
