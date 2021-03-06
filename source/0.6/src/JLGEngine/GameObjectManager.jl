module GameObjectManager

export IGameObject
export GameObject

using CoreExtended
using JLGEngine
using ..Management

""" TODO """
IComponent = JLGEngine.IComponent

""" TODO """
type GameObject <: IComponent
	id::Symbol
	enabled::Bool
	components::SortedDict{Symbol, IComponent}
	
	#transform::Transform

	GameObject(id=:_) = new(id,true,SortedDict{Symbol, IComponent}(Forward))
end

""" TODO """
setComponent(this::GameObject, c::IComponent) = (this.components[k] = c; c.gameObject=this)

""" TODO """
getComponent(this::GameObject, T::DataType) = getComponents(this, T).first

""" TODO """
function getComponents(this::GameObject, T::DataType)
	components = SortedDict{Symbol, IComponent}(Forward)
	for (k,v) in this.components
		if typeof(v) == T
			components[k] = v
		end
	end
	components
end

#addComponent(this::GameObject, c::Transform) = (setComponent(this,c); this.transform=c)

# preset for manager: includes code here
#presetManager(GameObject)
m=Management.presetManager(GameObject)

end #GameObjectManager
