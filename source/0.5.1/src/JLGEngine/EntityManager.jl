module EntityManager

export Entity

using CoreExtended
using MatrixMath

type Entity
	id::Symbol
	enabled::Bool

  position::Vec3f
  rotation::Vec3f
	scaling::Vec3f

	Entity(id=:_) = new(id,true,zeros(Vec3f),zeros(Vec3f),ones(Vec3f))
end

# preset for manager: includes code here
presetManager(EntityManager,Entity)

end #EntityManager
