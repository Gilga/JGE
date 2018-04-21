module GLDebugControl

export printError
export checkError
export hasError
export hasNoError
export getInfoLog
export validate

using ModernGL

using ..GLLists

""" TODO """
function printError(title=nothing)
 result=false
	while (err = checkError())[1]
		if typeof(title) == String
			err=err[2]
			errstr = haskey(LIST_ERROR,err) ? LIST_ERROR[err] : ""
			warn("OpenGL Error! $(title): $(errstr)")
		end
		if !result result=true end
	end
	result
end

""" TODO """
function checkError()
	err = glGetError()
	(err != GL_NO_ERROR, err)
end

""" TODO """
hasError() = checkError()[1]

""" TODO """
hasNoError() = !hasError()

""" TODO """
function getInfoLog(s::Symbol, id::GLuint)
	len = zeros(GLint,1)
	LIST_STATUS[s][:STATE](id, GL_INFO_LOG_LENGTH, len)
	len = len[]
	#log := strings.Repeat("\x00", int(logLength+1))
	#d[::INFO](id, logLength, nil, glStr(log))
	#glGetShaderInfoLog(id, logLength, nil, gl.Str(log))
	#glGetProgramInfoLog(id, logLength, nil, gl.Str(log))

	if len > 0
		buffer = zeros(GLchar, len)
		sizei = zeros(GLsizei,1)
		LIST_STATUS[s][:INFO](id, len, sizei, buffer)
		len = sizei[]
		unsafe_string(pointer(buffer),len) # bytestring(pointer(buffer), len)
	else
		""
	end
end

""" TODO """
validate(s::Symbol, id::GLuint, status::GLenum) = (result = zeros(GLint,1); LIST_STATUS[s][:STATE](id, status, result); result[] == GL_TRUE)

end #GLDebugControl
