# [GameObjectManager.jl](@id GameObjectManager.jl)

using CoreExtended
using JLGEngine
using ..Management

```
IComponent = JLGEngine.IComponent
```

```
type GameObject <: IComponent
	id::Symbol
	enabled::Bool
	components::SortedDict{Symbol, IComponent}
	
	#transform::Transform

	GameObject(id=:_) = new(id,true,SortedDict{Symbol, IComponent}(Forward))
end
```

```
setComponent(this::GameObject, c::IComponent) = (this.components[k] = c; c.gameObject=this)
```

```
getComponent(this::GameObject, T::DataType) = getComponents(this, T).first
```

```
function getComponents(this::GameObject, T::DataType)
	components = SortedDict{Symbol, IComponent}(Forward)
	for (k,v) in this.components
		if typeof(v) == T
			components[k] = v
		end
	end
	components
end
```
