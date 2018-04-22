# [CameraManager.jl](@id CameraManager.jl)

using CoreExtended
using MatrixMath
using JLGEngine

using ..TransformManager

const Transform = TransformManager.Typ

```
type Camera <: JLGEngine.IComponent
	id::Symbol
	transform::Transform

	ortho::Bool
	fov::Float32
	ratio::Float32
	depth::Vec2f

  viewport::Vec4f

  viewMat::Mat4x4f
  projectionMat::Mat4x4f
	modelMat::Mat4x4f

	translateMat::Mat4x4f
	rotationMat::Mat4x4f
	scalingMat::Mat4x4f

	mvpMat::Mat4x4f

	Camera(id=:_) = new(id,nothing,false,0,0,Vec2f(0,1),zeros(Vec4f),IMat4x4f,IMat4x4f,IMat4x4f,IMat4x4f,IMat4x4f,IMat4x4f,IMat4x4f)
end
```

```
function init(this::Camera)
	this.transform=TransformManager.create(this.id)
end
```

```
function zoom(this::Camera, zf::Float32)
	this.transform.scaling = ones(Vec3f) * (1+zoom*0.01f0)
end
```

```
function updateTranslation(this::Camera)
	this.translateMat = MatrixMath.translationmatrix(this.transform.position)
end
```

```
function updateRotation(this::Camera)
	this.rotationMat = MatrixMath.computeRotation(this.transform.rotation)
end
```

```
function updateScaling(this::Camera)
	this.scalingMat = MatrixMath.scalingmatrix(this.transform.scaling)
end
```

```
function updateView(this::Camera)
	updateTranslation(this)
	updateRotation(this)
	updateScaling(this)
	this.viewMat = this.rotationMat * this.translateMat * this.scalingMat
end
```

```
function setRatio(this::Camera, ratio::Float32)
	this.ratio=ratio
end
```

```
function setPerspective(this::Camera, fov::Float32,ratio::Float32,near::Float32,far::Float32, ortho=false) #(60.0f0, Float32(windowsize[1]/windowsize[2]), 0.1f0, 10.0f0)
	this.fov=fov
	this.ratio=ratio
	this.depth=Vec2f(near,far)
	this.ortho=ortho
end
```

```
function updateProjection(this::Camera)
	if !this.ortho this.projectionMat = MatrixMath.perspectiveprojection(this.fov, this.ratio, this.depth[1], this.depth[2])
	else this.projectionMat = MatrixMath.orthographicprojection(this.fov, this.ratio, this.depth[1], this.depth[2])
	end
end
```

```
function updateMVP(this::Camera)
	this.mvpMat = this.projectionMat * this.viewMat * this.modelMat
end
```

```
function updateModel(this::Camera, transform::Transform)
	if transform == nothing return end
	this.modelMat = MatrixMath.translationmatrix(transform.position) * MatrixMath.computeRotation(transform.rotation) * MatrixMath.scalingmatrix(transform.scaling)
end
```

```
function update(this::Camera, transform::Transform)
	updateProjection(this)
	updateView(this)
	updateModel(this, transform)
	updateMVP(this)
end
```
