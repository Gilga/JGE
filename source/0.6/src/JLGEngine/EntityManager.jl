module EntityManager

export Entity

using ..Management
using CoreExtended
using MatrixMath
using JLGEngine

type Entity <: JLGEngine.IComponent
	id::Symbol
	enabled::Bool

  position::Vec3f
  rotation::Vec3f
	scaling::Vec3f

	Entity(id=:_) = new(id,true,zeros(Vec3f),zeros(Vec3f),ones(Vec3f))
end

# preset for manager: includes code here
#presetManager(Entity)
m=Management.presetManager(Entity)

end #EntityManager
