# [GL/TextureManager.jl](@id GL-TextureManager.jl)

using ModernGL
using Images
using Colors
using FileIO
using MatrixMath

using JLGEngine.GraphicsManager
using ..GLLists
using ..GLDebugControl
using ..GLExtendedFunctions

```
type GLTextureBlock
	anchor::Array{GLuint,1}
	
	GLTextureBlock() = new(GLuint[1])
end
```

```
type GLTexture
	anchor::Array{GLuint,1}
	id::GLuint
	typ::GLenum
	
	GLTexture() = new(GLuint[1],0,GL_TEXTURE_2D)
end
```

```
function create()
	this = GLTexture()
	glGenTextures(1, this.anchor)
	this.id = this.anchor[1]
	this
end
```

```
bind(this::GLTexture) = glBindTexture(this.typ, this.id)
```

```
function load(this::GLTexture, file::AbstractString)
	img = Images.load(file)
	sz = size(img)
	width = sz[1] #1
	height = sz[2] #1
	a = channelview(img)
	a = reinterpret.(vec(a))
	#a = [0xFF, 0xFF, 0xFF, 0xFF]
	internalformat = GL_RGBA8
	format = GL_RGBA
	typ = GL_UNSIGNED_BYTE
	
	glActiveTexture(GL_TEXTURE0)
	glBindTexture(this.typ, this.id)
	glTexParameteri(this.typ, GL_TEXTURE_MIN_FILTER, GL_NEAREST) #GL_LINEAR
	glTexParameteri(this.typ, GL_TEXTURE_MAG_FILTER, GL_NEAREST) #GL_LINEAR
	glTexParameteri(this.typ, GL_TEXTURE_WRAP_S, GL_REPEAT) #GL_CLAMP_TO_EDGE)
	glTexParameteri(this.typ, GL_TEXTURE_WRAP_T, GL_REPEAT) #GL_CLAMP_TO_EDGE)
	glTexImage2D(this.typ, 0, internalformat, width, height, 0, format, typ, pointer(a))
	#glGenerateMipmap(this.typ)
end
```
