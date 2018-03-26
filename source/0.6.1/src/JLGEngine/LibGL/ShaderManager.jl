module ShaderManager #GLShaderManager

export ShaderProperty
export ShaderProgram
export Shader

using CoreExtended
using ModernGL
using FileManager

using JLGEngine.GraphicsManager
using ..GLLists
using ..GLDebugControl
using ..GLExtendedFunctions

type ShaderProperty <: IGraphicsShaderProperty
	enabled::Bool
	linked::Bool

	name::String
	typname::String
	category::String

	typ::DataType
	elements::Int32

	categoryid::Int32
	typid::Int32
	location::Int32 #GLuint
	offset::Int32

	arrayStride::Int32
	matrixStride::Int32
	topSize::Int32
	topStride::Int32

	size::UInt32
	code::UInt32

	index::Int32
	binding::Int32
	id::UInt32

	data::Any
	update::Function

	properties::Dict{String, ShaderProperty}

	ShaderProperty() = new(true,false,"","","",Void,0,-1,-1,-1,0,-1,-1,-1,-1,0,0,-1,-1,0,nothing,()->nothing,Dict{String,ShaderProperty}())
end

# Shader
type Shader <: IGraphicsShader
	enabled ::Bool
	created ::Bool

	typ			::Symbol
	file 		::FileSourcePart
	cache		::String

	id      ::GLuint # GL
	typid   ::GLuint # GL

	Shader(typ::Symbol, source::FileSource) = Shader(typ, FileSourcePart(source))
  Shader(typ::Symbol, file::FileSourcePart)	= new(true,false,typ,file,"",0,0)
end

# ShaderProgram
type ShaderProgram <: IGraphicsShaderProgram
	id			::GLuint

	enabled	::Bool
	created ::Bool
	linked	::Bool
	bound		::Bool

	source	::FileSource
	shaders ::Dict{Symbol,Shader}
	properties ::Dict{String, ShaderProperty}

	ShaderProgram() = new(0,true,false,false,false,FileSource(),Dict(),Dict())
end

#listShaderProgramListener = createSortedDict(Dict{String,Function})
#listenOnShaderProgramUpdate(id::Symbol, t::Tuple) = listenOnShaderProgramUpdate(id, Dict{String,Function}(t))
#listenOnShaderProgramUpdate(id::Symbol, d::Dict{String,Function}) = listShaderProgramListener[id]=d
#notlistenOnShaderPropertyUpdate(id::Symbol) = (listShaderProgramListener[id]=nothing)

link(this::Shader, p::AbstractGraphicsShaderProgram) = (this.program = p; true)

function compile(this::Shader)
	println("compile: ", this.typ);
	f = this.file
	glGetShaderSource(this.id)
	cache = f.cache #source.cache #FileManager.getCache(f.source)

	if cache == ""
		warn("OpenGL Error! Compile shader '$(f.source.path)': Failed loading content!")
		return false
	end

	#cache = cache[f.range]
	#println(f.source.path, " ", f.range, ":(",length(cache), ")\n--------------------------\n", cache,"\n--------------------------\n")

	glCompile(this.id,cache)
	r = validate(:SHADER, this.id, GL_COMPILE_STATUS)
	if !r
		warn("OpenGL Error! Compile shader '$(f.source.path)': $(getInfoLog(:SHADER, this.id))")
		glCompile(this.id,this.cache)
		r = validate(:SHADER, this.id, GL_COMPILE_STATUS)
		if !r
			warn("OpenGL Error! Compile shader cache '$(f.source.path)': $(getInfoLog(:SHADER, this.id))")
		end
	else
		this.cache = cache
	end
	r
end

function reload(this::AbstractGraphicsShaderProgram)
	if this == nothing return end

	clear(this)

	if printError("Before readShadersFromSource") end

	println("[ readShadersFromSource ]")
	readShadersFromSource(this)
	println("---------------------------------------")
	println("[ setUp ]")
	setUp(this)
	println("---------------------------------------")

	#programID = this.id
	#getProgramInfo(this)
	#getAttributesInfo(this)
	#getUniformsInfo(this)

	if isValid(this)
		#glUseProgram(this.id)
		println("[ findActiveRessources ]")
		findActiveRessources(this)
		println("---------------------------------------")
		println("[ findShaderProperties ]")
		findShaderProperties(this)
		println("---------------------------------------")
	end
	link(this)
	#useLinkedShaderProgram() # switch back to linked shader
end

createShaderProgram() = ShaderProgram()
createShader(program::ShaderProgram, typ::Symbol, file::FileSourcePart) = (this=Shader(typ, file); program.shaders[typ]=this; this)

getSource(this::AbstractGraphicsShaderProgram) = this.source
setPath(this::AbstractGraphicsShaderProgram, path::String) = (this.source.path = path)

clear(this::AbstractGraphicsShaderProgram) = this.shaders = Dict()

hasShader(this::AbstractGraphicsShaderProgram, id::Symbol) = haskey(this.shaders,id)

linked = nothing
unlink() = link(nothing)
#isValid(this::ShaderProgram) = this.created && this.bound
isValid(this::AbstractGraphicsShaderProgram) = this != nothing && isa(this,ShaderProgram) && this.created && this.bound
isLinked(this::AbstractGraphicsShaderProgram) =	isValid(this) && this == linked

function create(this::Shader)
	if this.created return true end
	this.created = true
	println("create: ", this.typ);
	this.typid = LIST_SHADER[this.typ][:TYPE]
	this.id = glCreateShader(this.typid)
	hasNoError()
end

function delete(this::Shader)
	if !this.created return true end
	println("delete: ", this.typ);
	glDeleteShader(this.id)
	this.created = false
	hasNoError()
end

attach(this::Shader, programID::GLuint) = (println("attach: ", this.typ); glAttachShader(programID, this.id); hasNoError())
detach(this::Shader, programID::GLuint) = (println("detach: ", this.typ); glDetachShader(programID, this.id); hasNoError())

function link(this::AbstractGraphicsShaderProgram)
	global linked
	if linked == this return end
	linked = this
	result = isValid(this)
	id = 0
	if result	id = this.id end
	glUseProgram(id)
	if result	result=hasNoError() end
	result
end

function create(this::ShaderProgram)
	if this.created return true end
	this.created = true
	this.id = glCreateProgram()
	hasNoError()
end

function delete(this::ShaderProgram)
	if !this.created return true end
	this.created = false
	unlink()
	glDeleteProgram(this.id)
	hasNoError()
end

function bind(this::ShaderProgram)
	glLinkProgram(this.id)
  #result = validate(:PROGRAM, this.id, GL_LINK_STATUS)
	#if !result	warn("OpenGL Error! Link ShaderProgram $(this.id): $(getInfoLog(:PROGRAM, this.id))")	end
	#result
	#this.bound=result
	#result
	this.bound=hasNoError()
end

function setUp(this::ShaderProgram)
	result = (
	(reset(this) ? true : true) &&
	(create(this) && detach(this) && compile(this) && attach(this) && bind(this) && clearList(this))
	) ? true : (reset(this) ? false : false)
	#if !result warn("OpenGL Error! SetUp ShaderProgram $(this.id): $(getInfoLog(:PROGRAM, this.id))") end
	result
end

function invokeList(list::Dict, f::Function, args...)
	if length(list) <= 0 return false end;
	for (k,e) in list
		if !f(e,args...) return false end
	end
	true
end

reset() = unlink()
#(create(this) && compileAll(this) && link(this, true) && cleanAll(this))
reset(this::ShaderProgram) = (unlink(); clearList(this) && delete(this))
compile(this::ShaderProgram) = invokeList(this.shaders, (s)->(create(s) && compile(s)))
detach(this::ShaderProgram) = (shader_ids = glGetAttachedShaders(this.id); foreach(glDetachShader, shader_ids); true)
attach(this::ShaderProgram) = invokeList(this.shaders, attach, this.id)
clearList(this::ShaderProgram) = invokeList(this.shaders, delete)
clear(this::ShaderProgram) = (this.properties = Dict{String, ShaderProperty}())

function render(this::ShaderProgram, buffer, data)
	if !isLinked(this) return end
	if !buffer.linked return end

	mode = data.mode
	if hasShader(this,:TESS_CONTROL) ||  hasShader(this,:TESS_EVALUATION)
		mode=GL_PATCHES
	end

	if buffer.typ == GL_ELEMENT_ARRAY_BUFFER
		glDrawElements(mode, data.elementsCount, data.typ, C_NULL)
	else
		glDrawArrays(mode, 0, data.elementsCount) #first::GLint
	end
end

include("GLSLParser.jl")

end #GLShaderManager
