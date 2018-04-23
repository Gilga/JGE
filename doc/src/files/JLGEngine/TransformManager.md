# [TransformManager.jl](@id TransformManager.jl)

using ..Management
using CoreExtended
using MatrixMath

```
type Transform
	id::Symbol
	enabled::Bool

  position::Vec3f
  rotation::Vec3f
	scaling::Vec3f

	Transform(id=:_) = new(id,true,zeros(Vec3f),zeros(Vec3f),ones(Vec3f))
end
```