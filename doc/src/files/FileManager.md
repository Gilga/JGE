# [FileManager.jl](@id FileManager.jl)

using [FileIO.jl](https://github.com/JuliaIO/FileIO.jl)

```@docs
FileManager.FileSource
```

```@docs
FileManager.FileSourcePart
```

```@docs
FileManager.FileUpdateEntry
```

```@docs
FileManager.getCache(source::FileManager.FileSource)
```

```@docs
FileManager.reload(source::FileManager.FileSource)
```

```@docs
FileManager.readFileSource(path::String)
```

```@docs
FileManager.splitFileName(path::String)
```

```@docs
FileManager.waitForFileReady(path::String, func::Function, tryCount=100, tryWait=0.1)
```

```@docs
FileManager.fileGetContents(path::String, tryCount=100, tryWait=0.1)
```

```@docs
FileManager.addDirSlash(path::String)
```

```@docs
FileManager.registerFileUpdate(source::FileManager.FileSource, OnUpdate::Function, args...)
```

```@docs
FileManager.unregisterFileUpdate(source::FileManager.FileSource)
```

```@docs
FileManager.runOnFileUpdate(threshold=0.01)
```

```@docs
FileManager.watchFileUpdate(path::String, OnUpdate::Function)
```

```@docs
FileManager.watchFileUpdate(path::FileManager.FileSource, OnUpdate::Function)
```

```@docs
FileManager.isUpdated(file::FileIO.File, tickrate=0.001)
```
