module RenderManager

export Renderer

using CoreExtended

using ..GraphicsManager
using ..StorageManager
using ..ModelManager
using ..CameraManager
using ..TransformManager
using ..ShaderManager
using ..TextureManager
using ..GameObjectManager

const Transform=TransformManager.Typ
const Model=ModelManager.Typ
const Camera=CameraManager.Typ
const Texture=TextureManager.Typ
const ShaderProgram=ShaderManager.Typ

const DEFAULT_FUNCTION = ()->nothing

OnPreDraw = DEFAULT_FUNCTION
OnPostDraw = DEFAULT_FUNCTION
OnPreRender = DEFAULT_FUNCTION
OnPostRender = DEFAULT_FUNCTION
OnRender = DEFAULT_FUNCTION

function setOnDraw(f1::Union{Void,Function}, f2::Union{Void,Function})
	global OnPreDraw = f1 != nothing ? f1 : DEFAULT_FUNCTION
	global OnPostDraw = f2 != nothing ? f2 : DEFAULT_FUNCTION
end

function setOnRender(f1::Union{Void,Function}, f2::Union{Void,Function}, f3::Union{Void,Function})
	global OnPreRender = f1 != nothing ? f1 : DEFAULT_FUNCTION
	global OnPostRender = f2 != nothing ? f2 : DEFAULT_FUNCTION
	global OnRender = f3 != nothing ? f3 : DEFAULT_FUNCTION
end

type RenderGroup
	enabled::Bool
	transform::Transform
	model::Model
	shaderProgram::ShaderProgram
	textures::Dict{Symbol,Texture}
	modes::Dict{Symbol,Any}
end

type RenderGroups
	enabled::Bool
	camera::Camera
	groups::SortedDict{Symbol,RenderGroup}
end

type Renderer
	id::Symbol
	#gameObject::GameObject
	
	order::Symbol
	enabled::Bool
	transform::Transform
	model::Model
	camera::Camera
	shaderProgram::ShaderProgram
	textures::Dict{Symbol,Texture}
	modes::Dict{Symbol,Any}
	setModes::Function
	
	function Renderer(id=:_)
		#obj=GameObjectManager.create(id)
		this=new(id,:_,true,nothing,nothing,nothing,nothing,Dict(),Dict(),()->nothing)
		#GameObjectManager.setComponent(obj,this)
		this
	end
end

function link(this::Renderer)
	ModelManager.linkTo(this.model)
	ShaderManager.linkTo(this.shaderProgram)
	CameraManager.update(this.camera, this.transform)
end

#createTransform(this::Renderer) = this.transform = TransformManager.create(this.id)
#createModel(this::Renderer) = this.model = ModelManager.create(this.id)
#createCamera(this::Renderer) = this.camera = CameraManager.create(this.id)

function register(this::Renderer)
	this.model = ModelManager.getSelected()
	this.camera = CameraManager.getSelected()
	this.shaderProgram = ShaderManager.getSelected()
	#RenderManager.createShaderProgram(:FG, "shaders/default.glsl")
end

function addTexture(this::Renderer, path::String)
	id=Symbol(path)
	texture = TextureManager.create(id)
	this.textures[id] = texture
	TextureManager.load(texture, path)
	texture
end

function update()
	ShaderManager.watchShaderReload(RenderManager.reload)
end

function init(this::Renderer)
	setMode(this, :POLYGONMODE,[:FRONT_AND_BACK,:FILL])
	this.transform=TransformManager.create(this.id)
end

function render()
	OnPreRender()
	OnRender()
	OnPostRender()
end

function render(this::Renderer)
	if !this.enabled return end
	setSelected(this)
	link() # shaderprogram, model, texture, ...
	getShaderProperties(this) 	# set propberties
	#this.setModes()
	OnPreDraw()
	draw(this)
	OnPostDraw()
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
presetManager(Renderer)

useSortedList = false
renderSortedList(use::Bool) = (global useSortedList = use)

renderDefault() = for (_,this) in list; render(this); end
renderAll = DEFAULT_FUNCTION

function start()
	reset()
	RenderManager.reload()
	
	# shader reload
	for (k,this) in list
		if this.shaderProgram != nothing ShaderManager.reload(this.shaderProgram) end
	end
end

function reload()
	if !useSortedList
		renderAll = stabilize(renderDefault)
	else
		#all=Expr(:block,:())

		sortedList=SortedDict{Symbol, Array{Renderer,1}}(Forward)

		order=0
		for (k,this) in list
			order+=1
			ex=:()
			for (k,v) in this.modes
				ex=:($(ex.args...); $(GRAPHICSDRIVER().getMode(k,v).args...);)
			end

			this.setModes=()->nothing #eval(:(function(); $(ex.args...); end;))

			if this.order == :_ this.order=Symbol(order) end
			if !haskey(sortedList,this.order) sortedList[this.order]=Array{Renderer,1}(); end
			push!(sortedList[this.order], this)
		end

		global renderAll = stabilize(eval(:(function();
			for (_,a) in $sortedList; for this in a; render(this); end; end;
		end;)))
		println("sortedList generated.")
	end
	
	global OnRender = OnRender != DEFAULT_FUNCTION ? OnRender : renderAll
end

function copy(l::Renderer,r::Renderer)
	l.model = r.model
	l.camera = r.camera
	l.transform = r.transform
	l.shaderProgram = r.shaderProgram
end

function unlink(typ::DataType)
	#obj = typ == Camera ? EMPTY_CAMERA : (typ == Model ? EMPTY_MODEL : (typ == Model ? nothing : nothing))
	if obj != nothing link(obj) end
end

function link(ent::Transform)
	this = getSelected()
	this.transform = ent
end

function link(camera::Camera)
	this = getSelected()
	this.camera = camera
end

function link(model::Model)
	this = getSelected()
	this.model = model
end

function link(program::ShaderProgram)
	this = getSelected()
	this.shaderProgram = program
end

is(id::Symbol) = RenderManager.getSelected().id == id
isTransform(id::Symbol) = RenderManager.getSelected().transform.id == id
isModel(id::Symbol) = RenderManager.getSelected().model.id == id
isCamera(id::Symbol) = RenderManager.getSelected().camera.id == id

getMVP() = RenderManager.getSelected().camera.mvpMat

getData(k::Symbol) = ModelManager.getData(getSelected().model,k)

function init()
	ShaderManager.setListenerOnShaderPropertyUpdate(:OnShaderPropertyUpdateAttributes, (
		"iVertex" => () ->  getData(:VERTEX)
		,"iUV" => () -> (d=getData(:UV); d != nothing ? d : getData(:VERTEX))
		,"iNormal" => () -> (d=getData(:NORMAL); d != nothing ? d : getData(:VERTEX))
		)
	)
end

function getShaderProperties(this::Renderer)
	ShaderManager.getShaderProperties(this.shaderProgram, ModelManager.getMainBuffer(this.model).data)
end

setRenderMode(this::Renderer, mode::Symbol) = GRAPHICSDRIVER().update(ModelManager.getGroup(this.model,:VERTEX).data, mode)
setMode(this::Renderer, mode::Symbol, value::Any) = this.modes[mode]=value

setRenderMode(mode::Symbol) = setRenderMode(getSelected(), mode)
setMode(mode::Symbol, value::Any) = GRAPHICSDRIVER().setMode(mode,value)

function draw(this::Renderer)
	model=this.model
	buffer=ModelManager.getMainBuffer(model)
	if model.enabled && ModelManager.isLinked(model) && buffer != nothing && buffer.data != nothing && (data=StorageManager.getData(buffer, 1)) != nothing
		ShaderManager.render(this.shaderProgram, buffer.data, data)
	end
end

end #RenderManager
