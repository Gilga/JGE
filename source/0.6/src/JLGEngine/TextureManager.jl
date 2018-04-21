module TextureManager

export Texture

using CoreExtended
using MatrixMath
using FileManager
using JLGEngine

using ..GraphicsManager

""" TODO """
type Texture <: JLGEngine.IComponent
	id::Symbol
	enabled::Bool
	
	source::FileSource
	api::Any
	
	Texture(id=:_) = new(id,true,FileSource(),nothing)
end

API = nothing

""" TODO """
function init()
	global API = GRAPHICSDRIVER().TextureManager
end

""" TODO """
function init(this::Texture)
	this.api = API.create()
end

# preset for manager: includes code here
presetManager(Texture)

""" TODO """
load(this::Texture, path::String) = (this.source.path=path; API.load(this.api, this.source.path))

""" TODO """
bind(this::Texture) =	API.bind(api)

end #TextureManager