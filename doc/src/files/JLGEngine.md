# [JLGEngine.jl](@id JLGEngine.jl)

include("CoreExtended.jl")
include("TimeManager.jl")
include("LoggerManager.jl")

include("RessourceManager.jl")
include("FileManager.jl")
include("Environment.jl")
include("JLScriptManager.jl")
include("WindowManager.jl")

include("MatrixMath.jl")

```
module JLGEngine
using CoreExtended
```

```
abstract type IComponent end

include(dir*"GraphicsManager.jl")
include(dir*"LibGL/LibGL.jl")

include(dir*"Management.jl")
include(dir*"StorageManager.jl")
include(dir*"MeshManager.jl")
include(dir*"ModelManager.jl")
include(dir*"ShaderManager.jl")
include(dir*"TransformManager.jl")
include(dir*"EntityManager.jl")
include(dir*"CameraManager.jl")
include(dir*"TextureManager.jl")
include(dir*"GameObjectManager.jl")
include(dir*"RenderManager.jl")

using .GraphicsManager

# set api references```

```
function init()
    GraphicsManager.setGraphicsDriver(LibGL)
    ShaderManager.init()
    StorageManager.init()
		TextureManager.init()
end
```
