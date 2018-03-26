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

shaderPrograms = Dict{Symbol,ShaderProgram}()

listWatchShaderProgram = []

#listShaderProgramListener = createSortedDict(Dict{String,Function})
#listenOnShaderProgramUpdate(id::Symbol, t::Tuple) = listenOnShaderProgramUpdate(id, Dict{String,Function}(t))
#listenOnShaderProgramUpdate(id::Symbol, d::Dict{String,Function}) = listShaderProgramListener[id]=d
#notlistenOnShaderPropertyUpdate(id::Symbol) = (listShaderProgramListener[id]=nothing)

listenReload(this::AbstractGraphicsShaderProgram, f::Function) =
	registerFileUpdate(this.source, (source::FileSource,p) -> push!(listWatchShaderProgram, (p,f)), this)


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

function reload(program::AbstractGraphicsShaderProgram)
	if program == nothing return end

	clear(program)

	if printError("Before readShadersFromSource") end

	println("[ readShadersFromSource ]")
	readShadersFromSource(program)
	println("---------------------------------------")
	println("[ setUp ]")
	setUp(program)
	println("---------------------------------------")

	#programID = program.id
	#getProgramInfo(program)
	#getAttributesInfo(program)
	#getUniformsInfo(program)

	if isValid(program)
		#glUseProgram(program.id)
		println("[ findActiveRessources ]")
		findActiveRessources(program)
		println("---------------------------------------")
		println("[ findShaderProperties ]")
		findShaderProperties(program)
		println("---------------------------------------")
	end
	link()
	#useLinkedShaderProgram() # switch back to linked shader
end

#createShaderProgram
function create(k::Symbol, path::String, listen::Union{Void,Function}=nothing)
	if !haskey(shaderPrograms,k)
		p = ShaderProgram()
		p.source.path=path
		shaderPrograms[k]=p
		if listen != nothing listenReload(p, listen) end
	else
		p = shaderPrograms[k]
		#p.source.path=path
	end
	p
end

function createShader(program::ShaderProgram, typ::Symbol, file::FileSourcePart)
	s=Shader(typ, file)
	program.shaders[typ]=s
	s
end

current = nothing
getCurrent() = current
setCurrent(this::AbstractGraphicsShaderProgram) = global current = this

function reset()
	unlink()
end

getSource(this::AbstractGraphicsShaderProgram) = this.source
clear(this::AbstractGraphicsShaderProgram) = this.shaders = Dict()

hasShader(this::AbstractGraphicsShaderProgram, id::Symbol) = haskey(this.shaders,id)
isValid(this::AbstractGraphicsShaderProgram) = this != nothing && isa(this,ShaderProgram) && this.created && this.bound
isLinked(this::AbstractGraphicsShaderProgram) =	isValid(this) && this == getCurrent()

unlink() = (setCurrent(nothing); glUseProgram(0))

function link()
	this=getCurrent()
	if isValid(this) link(this) else unlink() end
end

function linkTo(this::AbstractGraphicsShaderProgram)
	other=getCurrent()
	if other == this return end
	setCurrent(this)
	link()
end

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
	if !isValid(this) return false end
	glUseProgram(this.id)
	hasNoError()
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

#(create(this) && compileAll(this) && link(this, true) && cleanAll(this))
reset(this::ShaderProgram) = (unlink(); clearList(this) && delete(this))
compile(this::ShaderProgram) = invokeList(this.shaders, (s)->(create(s) && compile(s)))
detach(this::ShaderProgram) = (shader_ids = glGetAttachedShaders(this.id); foreach(glDetachShader, shader_ids); true)
attach(this::ShaderProgram) = invokeList(this.shaders, attach, this.id)
clearList(this::ShaderProgram) = invokeList(this.shaders, delete)

function clear(program::ShaderProgram)
	program.properties = Dict{String, ShaderProperty}()
end

function render(buffer, data)
	program=getCurrent()
	if !isLinked(program) return end
	if !buffer.linked return end

	mode = data.mode
	if hasShader(program,:TESS_CONTROL) ||  hasShader(program,:TESS_EVALUATION)
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
