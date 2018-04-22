# [ModelManager.jl](@id ModelManager.jl)

using CoreExtended
using FileManager
using JLGEngine

using ..GraphicsManager
using ..StorageManager
using ..MeshManager

const Mesh = MeshManager.Typ

```
type Model <: JLGEngine.IComponent
	id::Symbol
	name::String

	enabled::Bool
	linked::Bool
	loaded ::Bool

	source::FileSource

	meshes::Dict{Symbol, Mesh}
	group::StorageGroup
	mainStorage::StorageGroup

	Model(id=:_) = (g=StorageGroup(); new(id, "",true,false,false,FileSource(),Dict(),g,g))
end
```

```
setMainBuffer(this::Model, storage::StorageGroup) = this.mainStorage = storage
```

```
getMainBuffer(this::Model) = this.mainStorage
```

```
link(this::Model) = StorageManager.link(this.group)
```

```
function init(this::Model)
end
```

```
function upload(this::Model)
	if this.loaded return end
	prepare(this::Model,this.meshes[:DEFAULT])
	StorageManager.upload(this.group)
	this.loaded=true
end
```

```
function unload(this::Model)
	if !this.loaded return end
	# ....
	this.loaded=false
end
```

```
function resets()
	GRAPHICSDRIVER().resetBuffers()
end
```

```
function getGroup(this::Model, k::Symbol)
	r = nothing
	if k == :VERTEX || k == :UV || k == :NORMAL
		r = StorageManager.getGroup(this.group.list[:VB].list[:VBO],k)
	elseif  k == :INDEX
		r = StorageManager.getGroup(this.group.list[:IB].list[:IBO],k)
	end
	r
	#StorageManager.getData(getMainBuffer(this),k)
end
```

```
function getData(this::Model, k::Symbol)
	r = getGroup(this,k)
	if r != nothing r=r.data end #StorageManager.getValues
	r
end
```

```
function getBuffer(this::Model, k::Symbol)
	#.....
end
```

include("ModelManager/MeshFabric.jl")
