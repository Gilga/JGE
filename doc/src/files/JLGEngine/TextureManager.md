# [TextureManager.jl](@id TextureManager.jl)

using CoreExtended
using MatrixMath
using FileManager
using JLGEngine
using ..GraphicsManager

```
type Texture <: JLGEngine.IComponent
	id::Symbol
	enabled::Bool
	
	source::FileSource
	api::Any
	
	Texture(id=:_) = new(id,true,FileSource(),nothing)
end

API = nothing
```

```
function init()
	global API = GRAPHICSDRIVER().TextureManager
end
```

```
function init(this::Texture)
	this.api = API.create()
end
```

```
load(this::Texture, path::String) = (this.source.path=path; API.load(this.api, this.source.path))
```

```
bind(this::Texture) =	API.bind(api)
```