module GraphicsManager

using FileManager
using FileIO.query

export IGraphicsReference
export IGraphicsData
export IGraphicsShaderProgram
export IGraphicsShader
export IGraphicsShaderProperty

""" TODO """
abstract type IGraphicsReference end

""" TODO """
abstract type IGraphicsData <: IGraphicsReference end

""" TODO """
abstract type IGraphicsShaderProgram <: IGraphicsReference end

""" TODO """
abstract type IGraphicsShader <: IGraphicsReference end

""" TODO """
abstract type IGraphicsShaderProperty <: IGraphicsReference end

export AbstractGraphicsReference
export AbstractGraphicsData
export AbstractGraphicsShaderProgram
export AbstractGraphicsShader
export AbstractGraphicsShaderProperty

""" TODO """
AbstractGraphicsReference = Union{Void,IGraphicsReference}

""" TODO """
AbstractGraphicsData = Union{Void,IGraphicsData}

""" TODO """
AbstractGraphicsShaderProgram = Union{Void,IGraphicsShaderProgram}

""" TODO """
AbstractGraphicsShader = Union{Void,IGraphicsShader}

""" TODO """
AbstractGraphicsShaderProperty = Union{Void,IGraphicsShaderProperty}

""" TODO """
type Manager
	handle ::Any
	Manager() = new()
end

MANAGER = Manager()

""" TODO """
setGraphicsDriver(o::Any) = (MANAGER.handle = o)

""" TODO """
getGraphicsDriver() = MANAGER.handle

""" TODO """
GRAPHICSDRIVER() = getGraphicsDriver()

export GRAPHICSDRIVER

end #GraphicsManager
