# [LibGL.jl](@id LibGL.jl)

import DataStructures

using ModernGL

using CoreExtended
using FileManager

include("GLLists.jl")
include("GLDebugControl.jl")
include("GLExtendedFunctions.jl")
include("StorageManager.jl")
include("ShaderManager.jl")
include("TextureManager.jl")

using JLGEngine.GraphicsManager
using .GLLists
using .GLExtendedFunctions

```
hasDuplicates(msg) = (for (i,j) in zip(msg,lastMessage) if i != j return false end end; true)
```

```
function openglerrorcallback(
                source::GLenum, typ::GLenum,
                id::GLuint, severity::GLenum,
                len::GLsizei, message::Ptr{GLchar},
                userParam::Ptr{Void}
            )

		msg = (source, typ, id, severity, len)
		if hasDuplicates(msg) return end # ignore duplicates
		global lastMessage = msg

		#source = GL_DEBUG_SOURCE_API, GL_DEBUG_SOURCE_WINDOW_SYSTEM_, GL_DEBUG_SOURCE_SHADER_COMPILER, GL_DEBUG_SOURCE_THIRD_PARTY, GL_DEBUG_SOURCE_APPLICATION, GL_DEBUG_SOURCE_OTHER, GL_DONT_CARE
		#typ = GL_DEBUG_TYPE_ERROR, GL_DEBUG_TYPE_DEPRECATED_BEHAVIOR, GL_DEBUG_TYPE_UNDEFINED_BEHAVIOR, GL_DEBUG_TYPE_PORTABILITY, GL_DEBUG_TYPE_PERFORMANCE, GL_DEBUG_TYPE_MARKER, GL_DEBUG_TYPE_PUSH_GROUP, GL_DEBUG_TYPE_POP_GROUP, or GL_DEBUG_TYPE_OTHER, GL_DONT_CARE
		#severity = GL_DEBUG_SEVERITY_LOW, GL_DEBUG_SEVERITY_MEDIUM, or GL_DEBUG_SEVERITY_HIGH, GL_DONT_CARE
    errormessage = 	"\n"*
                    " __OPENGL________________________________________________________\n"*
                    "|\n"*
                    #"| type: $(GLENUM(typ).name) :: id: $(GLENUM(id).name)\n"*
										#"| source: $(GLENUM(source).name) :: severity: $(GLENUM(severity).name)\n"*
										(userParam != C_NULL ? "| UserParam : NOT NULL\n" : "")*
                    (len > 0 ? "| "*ascii(unsafe_string(message, len))*"\n" : "")*
										(haskey(LIST_ERROR,id) ? "| "*LIST_ERROR[id]*"\n" : "")*
                    "|________________________________________________________________\n"
    #if typ == GL_DEBUG_TYPE_ERROR
				warn(errormessage)
    #end
    nothing
end
```

```
const _openglerrorcallback = cfunction(openglerrorcallback, Void,
                                        (GLenum, GLenum,
                                        GLuint, GLenum,
                                        GLsizei, Ptr{GLchar},
                                        Ptr{Void}))
```

```
function SetDebugging(debug::Bool)
  if debug SetErrorCallBack() end
end
```

```
function SetErrorCallBack()
  @static if is_apple()
			warn("OpenGL debug message callback not available on osx")
			return
  end
	flags = getValByRef((ref) -> glGetIntegerv(GL_CONTEXT_FLAGS, ref), GLint(0))
  if (flags & GL_CONTEXT_FLAG_DEBUG_BIT) != 0
		glEnable(GL_DEBUG_OUTPUT)
		glEnable(GL_DEBUG_OUTPUT_SYNCHRONOUS)
		glDebugMessageCallbackARB(_openglerrorcallback, C_NULL)
	end
end
```

```
function init()
	SetErrorCallBack()
end
```

```
GetVersion(key::Symbol) = haskey(LIST_INFO,key) ? string("OpenGL ",glString(LIST_INFO[key])) : ""
```

```
function getMode(key::Symbol, value::Any)
	global MOD
	if key == :POLYGONMODE
		k=eval(Symbol(PREFIX,value[1]))
		v=eval(Symbol(PREFIX,value[2]))
		:($MOD.glPolygonMode($k,$v);)
	else
		:()
	end
end
```

```
function resetBuffers()	StorageManager.unbindStorages() end
```

```
function resetRegisters()
	#StorageManager.unbindStorages()
	ShaderManager.reset()
end
```
