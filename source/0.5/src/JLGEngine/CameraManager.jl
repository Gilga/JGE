module CameraManager

export Camera

using CoreExtended
using MatrixMath

using ..EntityManager

const Entity = EntityManager.Typ

type Camera
	id::Symbol
	entity::Entity

	fov::Float32
	ratio::Float32
	depth::Vec2f

  viewport::Vec4f

  position::Vec3f
  rotation::Vec3f #quat
	scaling::Vec3f

  viewMat::Mat4x4f
  projectionMat::Mat4x4f
	modelMat::Mat4x4f

	translateMat::Mat4x4f
	rotationMat::Mat4x4f
	scalingMat::Mat4x4f

	mvpMat::Mat4x4f

	Camera(id=:_) = new(id,nothing, 0,0,Vec2f(0,1),zeros(Vec4f),zeros(Vec3f),zeros(Vec3f),ones(Vec3f),IMat4x4f,IMat4x4f,IMat4x4f,IMat4x4f,IMat4x4f,IMat4x4f,IMat4x4f)
end

# preset for manager: includes code here
presetManager(CameraManager,Camera)

function zoom(this::Camera, zf::Float32)
	this.scaling = ones(Vec3f) * (1+zoom*0.01f0)
end

function updateTranslation(this::Camera)
	this.translateMat = MatrixMath.translationmatrix(this.position)
end

function updateRotation(this::Camera)
	this.rotationMat = MatrixMath.computeRotation(this.rotation)
end

function updateScaling(this::Camera)
	this.scalingMat = MatrixMath.scalingmatrix(this.scaling)
end

function updateView(this::Camera)
	updateTranslation(this)
	updateRotation(this)
	updateScaling(this)
	this.viewMat = this.rotationMat * this.translateMat * this.scalingMat
end

function setPerspective(this::Camera, fov::Float32,ratio::Float32,near::Float32,far::Float32) #(60.0f0, Float32(windowsize[1]/windowsize[2]), 0.1f0, 10.0f0)
	this.fov=fov
	this.ratio=ratio
	this.depth=Vec2f(near,far)
end

function updateProjection(this::Camera)
	this.projectionMat = MatrixMath.perspectiveprojection(this.fov, this.ratio, this.depth[1], this.depth[2])
end

function updateMVP(this::Camera)
	this.mvpMat = this.projectionMat * this.viewMat * this.modelMat
end

function updateModel(this::Camera)
	if this.entity == nothing return end
	this.modelMat = MatrixMath.translationmatrix(this.entity.position) * MatrixMath.computeRotation(this.entity.rotation) * MatrixMath.scalingmatrix(this.entity.scaling)
end

function update(this::Camera)
	updateProjection(this)
	updateView(this)
	updateModel(this)
	updateMVP(this)
end

end #CameraManager
