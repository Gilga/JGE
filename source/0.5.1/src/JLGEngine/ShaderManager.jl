module ShaderManager

using ..GraphicsManager

API = nothing

function init()
	global API = GRAPHICSDRIVER().ShaderManager
end

create(name::Symbol, path::String, listen::Union{Void,Function}=nothing) = API.create(name, path, listen)

setListenerOnShaderPropertyUpdate(name::Symbol, listen::Tuple) = API.setListenerOnShaderPropertyUpdate(name, listen)

getShaderProperties(program::AbstractGraphicsShaderProgram, buffer::AbstractGraphicsData) = API.getShaderProperties(program, buffer)
render(buffer::AbstractGraphicsData, data::AbstractGraphicsData) = API.render(buffer, data)

watchShaderReload(f::Function) = API.watchShaderReload(f)
linkTo(program) = API.linkTo(program)

getCurrent() = API.getCurrent()
reset() = API.reset()
unlink() = API.unlink()

end #ShaderManager
