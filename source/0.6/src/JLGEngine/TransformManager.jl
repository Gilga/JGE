module TransformManager

export Transform

using ..Management
using CoreExtended
using MatrixMath

""" TODO """
type Transform
	id::Symbol
	enabled::Bool

  position::Vec3f
  rotation::Vec3f
	scaling::Vec3f

	Transform(id=:_) = new(id,true,zeros(Vec3f),zeros(Vec3f),ones(Vec3f))
end

# preset for manager: includes code here
#presetManager(Transform)
m=Management.presetManager(Transform)

end #TransformManager
