using ModernGL
using GLFW

function openglerrorcallback(source::GLenum, typ::GLenum,
        id::GLuint, severity::GLenum,
        length::GLsizei, message::Ptr{GLchar},
        userParam::Ptr{Void}
    )

	msgtyp = (typ == GL_DEBUG_TYPE_ERROR) ? "error" : "info"

	message = """
________________________________________________________________

 [ OpenGL $(msgtyp) ]
 source: $(GLENUM(source).name) :: type: $(GLENUM(typ).name)
 $(unsafe_string(message, length))
________________________________________________________________
    """

	if typ == GL_DEBUG_TYPE_ERROR
		println(message)
	end
    nothing
end

global const _openglerrorcallback = cfunction(
    openglerrorcallback, Void,
    (GLenum, GLenum, GLuint, GLenum, GLsizei, Ptr{GLchar}, Ptr{Void})
)

const vert = """
#version 420
in vec2 position;
void main(){
	gl_Position = vec4(position, 0, 1.0);
}
"""
const frag = """
#version 420
out vec4 outColor;
void main() {
	outColor = vec4(1.0, 0.0, 0.0, 1.0);
}
"""

ShaderSource(shaderID::GLuint, source::AbstractString) = (shadercode=Vector{UInt8}(string(source,"\x00")); glShaderSource(shaderID, 1, Ptr{UInt8}[pointer(shadercode)], Ref{GLint}(length(shadercode))))

function main()
    println("---------------------------------------------------------------------")
    println("[ Start Program ]\n")
    versioninfo()
    println("---------------------------------------------------------------------")

    ### window
    debugging=true
    size=[800,600]

    GLFW.WindowHint(GLFW.SAMPLES, 4)
    GLFW.WindowHint(GLFW.CONTEXT_VERSION_MAJOR, 3)
    GLFW.WindowHint(GLFW.CONTEXT_VERSION_MINOR, 3)

    window = GLFW.CreateWindow(size[1], size[2], "Julia GLFW Window")
    GLFW.MakeContextCurrent(window)

    #GLFW.OpenWindowHint( GLFW.OPENGL_VERSION_MAJOR, 3 )
    #GLFW.OpenWindowHint( GLFW.OPENGL_VERSION_MINOR, 2 )
    GLFW.WindowHint(GLFW.OPENGL_FORWARD_COMPAT, true)
    GLFW.WindowHint(GLFW.OPENGL_PROFILE, GLFW.OPENGL_CORE_PROFILE)

    if (debugging && ModernGL.isavailable(:glDebugMessageCallbackARB))
    	GLFW.WindowHint(GLFW.OPENGL_DEBUG_CONTEXT, true) #glEnable(GL_DEBUG_OUTPUT_SYNCHRONOUS);
    	glDebugMessageCallbackARB(_openglerrorcallback, C_NULL)
    	println("OpenGL Debug Message enabled.")
    end

    ### shaders

    const vert_id = glCreateShader(GL_VERTEX_SHADER)
    const frag_id = glCreateShader(GL_FRAGMENT_SHADER)

    ShaderSource(vert_id, vert)
    ShaderSource(frag_id, frag)

    glCompileShader(vert_id)
    glCompileShader(frag_id)

    const p_id = glCreateProgram()

    glAttachShader(p_id, vert_id)
    glAttachShader(p_id, frag_id)

    glLinkProgram(p_id)

    glDetachShader(p_id, vert_id)
    glDetachShader(p_id, frag_id)

    glDeleteShader(vert_id)
    glDeleteShader(frag_id)

    glUseProgram(p_id)

    ### vertices

    const vao = Ref(GLuint(0))
    const vbo = Ref(GLuint(0))
    vertices = NTuple{3, Float32}[(-1,-1,0), (1,-1,0), (0, 1, 1)]

    glBindFragDataLocation(p_id, 0, "outColor")

    glGenVertexArrays(1, vao)
    glBindVertexArray(vao[])

    glGenBuffers(1, vbo)
    glBindBuffer(GL_ARRAY_BUFFER, vbo[])
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW)

    vertAttrib = glGetAttribLocation(p_id, "position")

    if vertAttrib >= 0
    	glEnableVertexAttribArray(vertAttrib)
    	glVertexAttribPointer(0, length(vertices), GL_FLOAT, GL_FALSE, 0, C_NULL)
    end

    #####

    glEnable(GL_DEPTH_TEST)
    glDepthFunc(GL_LESS)
    glClearColor(1.0, 1.0, 1.0, 1.0)

    while !GLFW.WindowShouldClose(window)
    	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
    	glDrawArrays(GL_TRIANGLES, 0, length(vertices))
    	GLFW.SwapBuffers(window)   # Swap front and back buffers
    	GLFW.PollEvents()   # Poll for and process events
    end
    GLFW.Terminate()

    #glUseProgram(0)
    #glDeleteProgram(p_id)
end
