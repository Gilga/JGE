# [GLExtendedFunctions.jl](@id GLExtendedFunctions.jl)

using MatrixMath
using ModernGL

```
function glGetActiveUniform(program::GLuint, index::Integer)
    actualLength   = GLsizei[1]
    uniformSize    = GLint[1]
    typ            = GLenum[1]
    maxcharsize    = glGetProgramiv(program, GL_ACTIVE_UNIFORM_MAX_LENGTH)
    name           = Vector{GLchar}(maxcharsize)

    glGetActiveUniform(program, index, maxcharsize, actualLength, uniformSize, typ, name)

    actualLength[1] <= 0 &&  error("No active uniform at given index. Index: ", index)

    uname = unsafe_string(pointer(name), actualLength[1])
    uname = Symbol(replace(uname, r"\[\d*\]", "")) # replace array brackets. This is not really a good solution.
    (uname, typ[1], uniformSize[1])
end
```

```
function glGetActiveAttrib(program::GLuint, index::Integer)
    actualLength   = GLsizei[1]
    attributeSize  = GLint[1]
    typ            = GLenum[1]
    maxcharsize    = glGetProgramiv(program, GL_ACTIVE_ATTRIBUTE_MAX_LENGTH)
    name           = Vector{GLchar}(maxcharsize)

    glGetActiveAttrib(program, index, maxcharsize, actualLength, attributeSize, typ, name)

    actualLength[1] <= 0 && error("No active uniform at given index. Index: ", index)

    uname = unsafe_string(pointer(name), actualLength[1])
    uname = Symbol(replace(uname, r"\[\d*\]", "")) # replace array brackets. This is not really a good solution.
    (uname, typ[1], attributeSize[1])
end
```

```
function glGetActiveUniformsiv(program::GLuint, index::Integer, variable::GLenum)
    result = Ref{GLint}(-1)
		#glGetActiveUniformBlockiv(program, index, variable, result)
    result[]
end
```

## display information for a program's attributes
```
function getAttributesInfo(program::GLuint)
	# how many attribs?
	@show activeAttr = glGetProgramiv(program, GL_ACTIVE_ATTRIBUTES)
	# get location and type for each attrib
	for i=0:activeAttr-1
		@show name, typ, siz = glGetActiveAttrib(program,	i)
		@show loc = glGetAttribLocation(program, name)
	end
end
```

## display info for all active uniforms in a program
```
function getUniformsInfo(program::GLuint)
	# Get uniforms info (not in named blocks)
	@show activeUnif = glGetProgramiv(program, GL_ACTIVE_UNIFORMS)

	for i=0:activeUnif-1
		@show index = glGetActiveUniformsiv(program, i, GL_UNIFORM_BLOCK_INDEX)
		if (index == -1)
			@show name 		     = glGetActiveUniformName(program, i)
			@show uniType 	   	 = glGetActiveUniformsiv(program, i, GL_UNIFORM_TYPE)

			@show uniSize 	   	 = glGetActiveUniformsiv(program, i, GL_UNIFORM_SIZE)
			@show uniArrayStride = glGetActiveUniformsiv(program, i, GL_UNIFORM_ARRAY_STRIDE)

			auxSize = 0
			if (uniArrayStride > 0)
				@show auxSize = uniArrayStride * uniSize
			else
				@show auxSize = spGLSLTypeSize[uniType]
			end
		end
	end
	# Get named blocks info
	@show count = glGetProgramiv(program, GL_ACTIVE_UNIFORM_BLOCKS)

	for i=0:count-1
		# Get blocks name
		@show name 	 		 = glGetActiveUniformBlockName(program, i)
		@show dataSize 		 = glGetActiveUniformBlockiv(program, i, GL_UNIFORM_BLOCK_DATA_SIZE)

		@show index 	 		 = glGetActiveUniformBlockiv(program, i,  GL_UNIFORM_BLOCK_BINDING)
		@show binding_point 	 = glGetIntegeri_v(GL_UNIFORM_BUFFER_BINDING, index)

		@show activeUnif   	 = glGetActiveUniformBlockiv(program, i, GL_UNIFORM_BLOCK_ACTIVE_UNIFORMS)

		indices = zeros(GLuint, activeUnif)
		glGetActiveUniformBlockiv(program, i, GL_UNIFORM_BLOCK_ACTIVE_UNIFORM_INDICES, indices)
		@show indices
		for ubindex in indices
			@show name 		   = glGetActiveUniformName(program, ubindex)
			@show uniType 	   = glGetActiveUniformsiv(program, ubindex, GL_UNIFORM_TYPE)
			@show uniOffset    = glGetActiveUniformsiv(program, ubindex, GL_UNIFORM_OFFSET)
			@show uniSize 	   = glGetActiveUniformsiv(program, ubindex, GL_UNIFORM_SIZE)
			@show uniMatStride = glGetActiveUniformsiv(program, ubindex, GL_UNIFORM_MATRIX_STRIDE)
		end
	end
end
```

## display the values for a uniform in a named block```
```
function getUniformInBlockInfo(program::GLuint, blockName, uniName)
	@show index = glGetUniformBlockIndex(program, blockName)
	if (index == GL_INVALID_INDEX)
		println("$uniName is not a valid uniform name in block $blockName")
	end
	@show bindIndex 		= glGetActiveUniformBlockiv(program, index, GL_UNIFORM_BLOCK_BINDING)
	@show bufferIndex 	= glGetIntegeri_v(GL_UNIFORM_BUFFER_BINDING, bindIndex)
	@show uniIndex 			= glGetUniformIndices(program, uniName)

	@show uniType 			= glGetActiveUniformsiv(program, uniIndex, GL_UNIFORM_TYPE)
	@show uniOffset 		= glGetActiveUniformsiv(program, uniIndex, GL_UNIFORM_OFFSET)
	@show uniSize 			= glGetActiveUniformsiv(program, uniIndex, GL_UNIFORM_SIZE)
	@show uniArrayStride 	= glGetActiveUniformsiv(program, uniIndex, GL_UNIFORM_ARRAY_STRIDE)
	@show uniMatStride 		= glGetActiveUniformsiv(program, uniIndex, GL_UNIFORM_MATRIX_STRIDE)
end
```

## display program's information
```
function getProgramInfo(program::GLuint)
	# check if name is really a program
	@show program
	# Get the shader's name
	@show shaders = glGetAttachedShaders(program)
	for shader in shaders
		@show info = GLENUM(convert(GLenum, glGetShaderiv(shader, GL_SHADER_TYPE))).name
	end
	# Get program info
	@show info = glGetProgramiv(program, GL_PROGRAM_SEPARABLE)
	@show info = glGetProgramiv(program, GL_PROGRAM_BINARY_RETRIEVABLE_HINT)
	@show info = glGetProgramiv(program, GL_LINK_STATUS)
	@show info = glGetProgramiv(program, GL_VALIDATE_STATUS)
	@show info = glGetProgramiv(program, GL_DELETE_STATUS)
	@show info = glGetProgramiv(program, GL_ACTIVE_ATTRIBUTES)
	@show info = glGetProgramiv(program, GL_ACTIVE_UNIFORMS)
	@show info = glGetProgramiv(program, GL_ACTIVE_UNIFORM_BLOCKS)
	@show info = glGetProgramiv(program, GL_ACTIVE_ATOMIC_COUNTER_BUFFERS)
	@show info = glGetProgramiv(program, GL_TRANSFORM_FEEDBACK_BUFFER_MODE)
	@show info = glGetProgramiv(program, GL_TRANSFORM_FEEDBACK_VARYINGS)
end
```

```
glSwitch(id::Symbol, on::Bool) = (option = Options[id]; on ? glEnable(option) : glDisable(option))
#glDepthMask(on)
```

```
glShaderSource(shaderID::GLuint, source::String) = (shadercode=Vector{UInt8}(string(source,"\x00")); glShaderSource(shaderID, 1, Ptr{UInt8}[pointer(shadercode)], Ref{GLint}(length(shadercode))))
```

```
function glGetShaderSource(shaderID::GLuint)
	len = Ref(GLint(0))
	glGetShaderiv(shaderID, GL_SHADER_SOURCE_LENGTH, len)
	len=len.x

	if len <= 0 return "" end
	println(len)

	sourceLen = len
	source = zeros(GLchar,len)
	len = zeros(GLsizei,1)
	glGetShaderSource(shaderID, sourceLen, pointer(len), pointer(source)) #(shader::GLuint, bufSize::GLsizei, length::Ptr{GLsizei}, source::Ptr{GLchar})::Void

	source=convert(String, source[1:sourceLen-1])
	println(source)
	chomp(readline())
end
```

```
function glCompile(shaderID::GLuint, source::String)
	glShaderSource(shaderID, source)
	glCompileShader(shaderID)
end
```

```
glGetShaderiv(shaderID::GLuint, variable::GLenum) = (result = Ref{GLint}(-1); glGetShaderiv(shaderID, variable, result); result[])
```

```
glGetProgramiv(programID::GLuint, variable::GLenum) = (result = Ref{GLint}(-1); glGetProgramiv(programID, variable, result); result[])
```

```
function glGetAttachedShaders(program::GLuint)
    shader_count   = glGetProgramiv(program, GL_ATTACHED_SHADERS)
    length_written = GLsizei[0]
    shaders        = zeros(GLuint, shader_count)

    glGetAttachedShaders(program, shader_count, length_written, shaders)
    shaders[1:first(length_written)]
end
```

```
function getValByRef(f::Function, arg)
	ref = Ref(arg)
	f(ref)
	ref.x
end
```

```
glString(name::GLenum) = unsafe_string(glGetString(name))
```

```
glString(name::GLenum, index::GLuint) = unsafe_string(glGetStringi(name,index))
```

```
glGetIntegerv(name::GLenum) = getValByRef((r)->glGetIntegerv(name,r), GLint(-1))
```

```
glGetInteger64v(name::GLenum) = getValByRef((r)->glGetInteger64v(name,r), GLint64(-1))
```

```
glGetBooleanv(name::GLenum) = getValByRef((r)->glGetBooleanv(name,r), GLboolean(false))
```

```
glGetFloatv(name::GLenum) = getValByRef((r)->glGetFloatv(name,r), GLfloat(-1))
```

```
glGetDoublev(name::GLenum) = getValByRef((r)->glGetDoublev(name,r), GLdouble(-1))
```

```
glGetIntegeri_v(name::GLenum, index::GLuint) = getValByRef((r)->glGetIntegeri_v(name,r), GLint(-1))
```

```
glGetInteger64i_v(name::GLenum, index::GLuint) = getValByRef((r)->glGetInteger64i_v(name,r), GLint64(-1))
```

```
glGetBooleani_v(name::GLenum, index::GLuint) = getValByRef((r)->glGetBooleani_v(name,r), GLboolean(false))
```

```
glGetFloati_v(name::GLenum, index::GLuint) = getValByRef((r)->glGetFloati_v(name,r), GLfloat(-1))
```

```
glGetDoublei_v(name::GLenum, index::GLuint) = getValByRef((r)->glGetDoublei_v(name,r), GLdouble(-1))
```

```
function glGet(typ::DataType, name::GLenum)

	fn = nothing
	ti = typeof(index)

	if typ == GLboolean fn = glGetBooleanv
	elseif typ == GLint fn = glGetIntegerv
	elseif typ == GLint64 fn = glGetInteger64v
	elseif typ == GLfloat fn = glGetFloatv
	elseif typ == GLdouble fn = glGetDoublev
	end

	if fn != nothing return fn(name) end #getValByRef((r)->(fn)(name,r), typ(-1))	end
	nothing
end
```

```
function glGet(typ::DataType, name::GLenum, index::GLuint)

	fn = nothing
	ti = typeof(index)

	if typ == GLboolean fn = glGetBooleani_v
	elseif typ == GLint fn = glGetIntegeri_v
	elseif typ == GLint64 fn = glGetInteger64i_v
	elseif typ == GLfloat fn = glGetFloati_v
	elseif typ == GLdouble fn = glGetDoublei_v
	end

	if fn != nothing return fn(name,index) end #getValByRef((r)->(fn)(name,index,r), typ(-1))	end
	nothing
end
```

```
setFragLocation(id::GLuint, name::String, colorNumber=GLuint(0)) = glFragLocation(id, name, colorNumber)
```

```
glFragLocation(id::GLuint, name::String, colorNumber::GLuint) = glBindFragDataLocation(id, colorNumber, pointer(string(name,"\x00")))
```

```
glAttribLocation(id::GLuint, name::String) = glGetAttribLocation(id, pointer(string(name,"\x00")))
```

```
glUniformLocation(id::GLuint, name::String) = glGetUniformLocation(id, pointer(string(name,"\x00")))
```

```
glUniform(location::GLint, value::Bool) = glUniform1ui(location, GLuint(value?1:0))
glUniform(location::GLint, value::UInt32) = glUniform1ui(location, GLuint(value))
glUniform(location::GLint, value::UInt64) = glUniform1ui(location, GLuint(value))
glUniform(location::GLint, value::Int32) = glUniform1i(location, GLint(value))
glUniform(location::GLint, value::Int64) = glUniform1i(location, GLint(value))
glUniform(location::GLint, value::Float32) = glUniform1f(location, GLfloat(value))
glUniform(location::GLint, value::Float64) = glUniform1d(location, GLdouble(value))
glUniform(location::GLint, value::Array{Float32,1}) = glUniform1fv(location, length(value), pointer(value))
glUniform(location::GLint, value::Array{Float64,1}) = glUniform1dv(location, length(value), pointer(value))
#glUniform(location::GLint, value::Array{Vec{2, Float32},1}) = glUniform2fv(location, length(value), pointer(value))
#glUniform(location::GLint, value::Array{Vec{3, Float32},1}) = glUniform3fv(location, length(value), pointer(value))
#glUniform(location::GLint, value::Array{Vec{4, Float32},1}) = glUniform4fv(location, length(value), pointer(value))
glUniform(location::GLint, value::Vec2f) = glUniform2fv(location, 1, pointer(convert(Array, value)))
glUniform(location::GLint, value::Vec3f) = glUniform3fv(location, 1, pointer(convert(Array, value)))
glUniform(location::GLint, value::Vec4f) = glUniform4fv(location, 1, pointer(convert(Array, value)))
glUniform(location::GLint, value::Mat2x2f, transpose=false) = glUniformMatrix2fv(location, 1, transpose, pointer(convert(Array, value)))
glUniform(location::GLint, value::Mat3x3f, transpose=false) = glUniformMatrix3fv(location, 1, transpose, pointer(convert(Array, value)))
glUniform(location::GLint, value::Mat4x4f, transpose=false) = glUniformMatrix4fv(location, 1, transpose, pointer(convert(Array, value)))
```

