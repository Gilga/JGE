module RenderManager

export RenderObject

using CoreExtended

using ..GraphicsManager
using ..StorageManager
using ..ModelManager
using ..CameraManager
using ..EntityManager
using ..ShaderManager

const Entity=EntityManager.Typ
const Model=ModelManager.Typ
const Camera=CameraManager.Typ

render = ()->nothing # render whole szene
OnPreRender = ()->nothing
OnPostRender = ()->nothing

function setOnRender(f1::Function, f2::Function)
	global OnPreRender = f1
	global OnPostRender = f2
end

type RenderObject
	id::Symbol
	order::Symbol
	enabled::Bool
	entity::Entity
	model::Model
	camera::Camera
	shaderProgram::AbstractGraphicsShaderProgram
	modes::Dict{Symbol,Any}
	setModes::Function
	RenderObject(id=:_) = new(id,:_,true,nothing,nothing,nothing,nothing,Dict(),()->nothing)
end

function link(this::RenderObject)
	ModelManager.linkTo(this.model)
	ShaderManager.linkTo(this.shaderProgram)
	this.camera.entity=this.entity
	CameraManager.update(this.camera)
end

function register(this::RenderObject, createEntity=true, createModel=false, createShaderProgram=false, createCamera=false)
	this.entity = createEntity ? EntityManager.create(this.id) : EntityManager.getCurrent()
	this.model = createModel ? ModelManager.create(this.id) : ModelManager.getCurrent()
	this.camera = createCamera ? CameraManager.create(this.id) : CameraManager.getCurrent()
	this.shaderProgram = ShaderManager.getCurrent()
	#RenderManager.createShaderProgram(:FG, "shaders/default.glsl")
end

function update()
	ShaderManager.watchShaderReload(RenderManager.reload)
end

function init(this::RenderObject)
	setMode(this, :POLYGONMODE,[:FRONT_AND_BACK,:FILL])
end

function reload()
	#all=Expr(:block,:())

	sortedList=createSortedDict(RenderObject)

	order=0
	for (k,this) in list
		order+=1
		ex=:()
		for (k,v) in this.modes
			ex=:($(ex.args...); $(GRAPHICSDRIVER().getMode(k,v).args...);)
		end

		this.setModes=()->eval(:(function(); $(ex.args...); end;))

		if this.order == :_ this.order=Symbol(order) end
		if !haskey(sortedList,this.order) sortedList[this.order]=this; end
	end

	global render = stabilize(eval(:(function();
		for (_,this) in $sortedList;
			if !this.enabled; continue; end;
				setCurrent(this);
				link(); # shaderprogram, model, texture, ...
				getShaderProperties(this); 	# set propberties
				this.setModes();
				$OnPreRender();
				renderModel(this);
				$OnPostRender();
			end;
	end;)))
end

function start()
	reset()
end

function resets()
	ModelManager.reset()
	ShaderManager.reset()
end

function unlinks()
	ModelManager.unlink()
	ShaderManager.unlink()
end

# preset for manager: includes code here
presetManager(RenderManager,RenderObject)

function copy(l::RenderObject,r::RenderObject)
	l.model = r.model
	l.camera = r.camera
	l.entity = r.entity
	l.shaderProgram = r.shaderProgram
end

function unlink(typ::DataType)
	#obj = typ == Camera ? EMPTY_CAMERA : (typ == Model ? EMPTY_MODEL : (typ == Model ? nothing : nothing))
	if obj != nothing link(obj) end
end

function link(ent::Entity)
	this = getCurrent()
	this.entity = ent
end

function link(camera::Camera)
	this = getCurrent()
	this.camera = camera
end

function link(model::Model)
	this = getCurrent()
	this.model = model
end

function link(program::AbstractGraphicsShaderProgram)
	this = getCurrent()
	this.shaderProgram = program
end

is(id::Symbol) = RenderManager.getCurrent().id == id
isEntity(id::Symbol) = RenderManager.getCurrent().entity.id == id
isModel(id::Symbol) = RenderManager.getCurrent().model.id == id
isCamera(id::Symbol) = RenderManager.getCurrent().camera.id == id

getMVP() = RenderManager.getCurrent().camera.mvpMat

getData(k::Symbol) = ModelManager.getData(getCurrent().model,k)

function init()
	ShaderManager.setListenerOnShaderPropertyUpdate(:OnShaderPropertyUpdateAttributes, (
		"iVertex" => () ->  getData(:VERTEX)
		,"iUV" => () -> (d=getData(:UV); d != nothing ? d : getData(:VERTEX))
		,"iNormal" => () -> (d=getData(:NORMAL); d != nothing ? d : getData(:VERTEX))
		)
	)
end

function getShaderProperties(this::RenderObject)
	ShaderManager.getShaderProperties(this.shaderProgram, ModelManager.getMainBuffer(this.model).data)
end

setRenderMode(this::RenderObject, mode::Symbol) = GRAPHICSDRIVER().update(ModelManager.getGroup(this.model,:VERTEX).data, mode)
setMode(this::RenderObject, mode::Symbol, value::Any) = this.modes[mode]=value

setRenderMode(mode::Symbol) = setRenderMode(getCurrent(), mode)
setMode(mode::Symbol, value::Any) = GRAPHICSDRIVER().setMode(mode,value)

function renderModel(this::RenderObject)
	model=this.model
	buffer=ModelManager.getMainBuffer(model)
	if model.enabled && ModelManager.isLinked(model) && buffer != nothing && buffer.data != nothing && (data=StorageManager.getData(buffer, 1)) != nothing
		ShaderManager.render(buffer.data, data)
	end
end

end #RenderManager
