# [GraphicsManager.jl](@id GraphicsManager.jl)

using FileManager
using FileIO.query

```
abstract type IGraphicsReference end
```

```
abstract type IGraphicsData <: IGraphicsReference end
```

```
abstract type IGraphicsShaderProgram <: IGraphicsReference end
```

```
abstract type IGraphicsShader <: IGraphicsReference end
```

```
abstract type IGraphicsShaderProperty <: IGraphicsReference end

export AbstractGraphicsReference
export AbstractGraphicsData
export AbstractGraphicsShaderProgram
export AbstractGraphicsShader
export AbstractGraphicsShaderProperty
```

```
AbstractGraphicsReference = Union{Void,IGraphicsReference}
```

```
AbstractGraphicsData = Union{Void,IGraphicsData}
```

```
AbstractGraphicsShaderProgram = Union{Void,IGraphicsShaderProgram}
```

```
AbstractGraphicsShader = Union{Void,IGraphicsShader}
```

```
AbstractGraphicsShaderProperty = Union{Void,IGraphicsShaderProperty}
```

```
type Manager
	handle ::Any
	Manager() = new()
end

MANAGER = Manager()
```

```
setGraphicsDriver(o::Any) = (MANAGER.handle = o)
```

```
getGraphicsDriver() = MANAGER.handle
```

```
GRAPHICSDRIVER() = getGraphicsDriver()
```