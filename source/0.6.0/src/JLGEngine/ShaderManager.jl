module ShaderManager

using CoreExtended
using FileManager
using JLGEngine

using ..GraphicsManager

API = nothing

function init()
	global API = GRAPHICSDRIVER().ShaderManager
end

type ShaderProgram <: JLGEngine.IComponent
	id::Symbol
	obj::AbstractGraphicsShaderProgram
	ShaderProgram(id=:_) = new(id,API.createShaderProgram())
	ShaderProgram(obj::AbstractGraphicsShaderProgram) = new(:_,obj)
end

function init(this::ShaderProgram)
end

function resets()
	API.reset()
end

function unlinks()
	API.unlink()
end

function link(this::ShaderProgram)
	API.link(this.obj)
end

# preset for manager: includes code here
presetManager(ShaderProgram)

listWatchShaderProgram = []

listenReload(this::ShaderProgram, f::Function) =
	registerFileUpdate(API.getSource(this.obj), (source::FileSource,p) -> push!(listWatchShaderProgram, (p,f)), this)

function watchShaderReload(OnReload=()->nothing)
	global listWatchShaderProgram
	count=length(listWatchShaderProgram)
	if count != 0
		println("Reload Shaders ($count)...")
		for t in listWatchShaderProgram
			p = t[1]
			f = t[2]
			reload(p)
			if isa(f, Function) execute(f,p) end
		end
		listWatchShaderProgram = []
		OnReload()
	end
end

function create(name::Symbol, path::String, listen::Union{Void,Function}=nothing)
	exists = haskey(list,name)
	this = create(name)
	if !exists
		API.setPath(this.obj, path)
		if listen != nothing listenReload(this, listen) end
	end
	this
end

setListenerOnShaderPropertyUpdate(name::Symbol, listen::Tuple) = API.setListenerOnShaderPropertyUpdate(name, listen)

getShaderProperties(program::ShaderProgram, buffer::AbstractGraphicsData) = API.getShaderProperties(program.obj, buffer)
render(program::ShaderProgram, buffer::AbstractGraphicsData, data::AbstractGraphicsData) = API.render(program.obj, buffer, data)

#watchShaderReload(f::Function) = API.watchShaderReload(f)
reload(program::ShaderProgram) = API.reload(program.obj)

end #ShaderManager
