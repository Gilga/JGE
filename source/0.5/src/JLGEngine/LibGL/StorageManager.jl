module StorageManager #GLStorageManager

export GLStorageData
export GLStorage
export GLStorageBlock

using ModernGL
using MatrixMath

using JLGEngine.GraphicsManager
using ..GLLists
using ..GLDebugControl
using ..GLExtendedFunctions

type GLStorageData <: IGraphicsData
	id::GLuint  # GL
	dtyp::DataType
	typ::GLenum
	flags::GLuint
	mode::GLenum

	offset::GLuint
	count::GLuint
	size::GLsizei
	values::AbstractArray
	valuesPtr::Ptr{Void}

	elements::GLint
	elementsCount::GLsizei
	elementsSize::GLsizei

	uploaded::Bool

	GLStorageData() = new(0,Float32,GL_FLOAT,0,GL_TRIANGLES,0,0,0,[],C_NULL,0,0,0,false)
end

type GLStorage <: IGraphicsData
	linked::Bool
	id::GLuint  # bind point
	size::GLsizei
	count::GLuint
	typ::GLenum
	mode::GLuint
	GLStorage(typ=GL_ARRAY_BUFFER) = new(false,0,0,0,typ,GL_STATIC_DRAW)
end

type GLStorageBlock <: IGraphicsData
	created::Bool
	isarray::Bool
	anchor::Array{GLuint,1}
	count::GLuint
	GLStorageBlock(isarray::Bool) = new(false, isarray, GLuint[0], 0)
end

linkedArray = nothing
linkedBuffers = Dict{GLenum,AbstractGraphicsData}()

function unbindStorages()
	# unbind
	for (s,k) in LIST_BUFFER bind(false, k, GLuint(0), nothing) end
  bind(true, GLenum(0), GLuint(0), nothing)
end

function create(typ::Symbol, id::Symbol)
	r = nothing
	if typ == :DATA
		r=GLStorageData()
	elseif typ == :STORAGE
		r=GLStorage(haskey(LIST_BUFFER, id) ? LIST_BUFFER[id] : 0)
	elseif typ == :BLOCK
		r= GLStorageBlock(id == :ARRAY_BLOCK)
	end
	r
end

getValues(this::GLStorageData) = this.values

function setValues(this::GLStorageData, values::AbstractArray, elems::Integer, mode = :TRIANGLES)
	this.uploaded = false

	# convert to one dim valid array
	v=MatrixMath.convertMatrixToArray(values)
	values=v[1]
	elems=elems == 0 ? v[2] : elems

	this.values = values
	this.count = length(this.values)
	this.size = sizeof(this.values)
	this.dtyp = typeof(this.values[1])
	this.valuesPtr = pointer(this.values)
	this.typ = LIST_TYPE[this.dtyp]
	this.mode = LIST_DRAW_MODE[mode]

	n=this.count/elems
	 #check if number becomes fractional
	if modf(n)[1]>0
		warn("element number does not match up with data count! instruction aborted.")
		return
	end

	this.elements=elems
	this.elementsSize=elems*sizeof(this.dtyp)
	this.elementsCount=n

	println("setValues:done.")
end

function prepare(block::GLStorageBlock, storage::GLStorage, this::GLStorageData)
	storage.count += 1
	this.id=storage.count
	this.offset = storage.size
	storage.size += this.size
end

function prepare(block::GLStorageBlock, this::GLStorage)
	block.count += 1
	this.id=block.count
	this.count=0
end

function prepare(this::GLStorageBlock)
	this.count=0
end

function init(this::GLStorageBlock)
	if this.created return end
	this.anchor=zeros(GLuint,this.count)
	if this.isarray	glGenVertexArrays(this.count, this.anchor)
	else glGenBuffers(this.count, this.anchor)
	end
	this.created=true
end

function clean(this::GLStorageBlock)
	if !this.created return end
	this.anchor=zeros(GLuint,this.count)
	if this.isarray	glDeleteVertexArrays(this.count, this.anchor)
	else glDeleteBuffers(this.count, this.anchor)
	end
	this.created=false
end

function bind(isarray::Bool, k::GLenum, v::GLuint, s::AbstractGraphicsData)
	global linkedBuffers
	global linkedArray
	if isarray
		glBindVertexArray(v)
		if linkedArray != nothing linkedArray.linked = false end
		if s != nothing s.linked = true end
		linkedArray = s
	else
		glBindBuffer(k,v)
		if haskey(linkedBuffers,k)
			prev = linkedBuffers[k]
			if prev != nothing prev.linked = false end
			if s != nothing s.linked = true end
		end
		linkedBuffers[k] = s
	end
end

bind(block::GLStorageBlock, this::GLStorage, on=true) = bind(block.isarray, this.typ, GLuint(on ? block.anchor[this.id] : 0), on ? this : nothing)

upload(xs::Array{Any,1}) = for x in xs upload(x[1], x[2], x[3]) end

function upload(block::GLStorageBlock, this::GLStorage, data::GLStorageData)
	if block.isarray return end
	bind(block,this)
	uploadData(block, this, data) # offsets etc.
	bind(block,this,false)
end

function uploadData(block::GLStorageBlock, this::GLStorage, data::GLStorageData)
	if block.isarray || this.typ == 0 return end # || data.uploaded

	if data.id == 1
			size=GLsizeiptr(data.size)
			values=data.valuesPtr

			if this.size > data.size
				values = C_NULL
				size = this.size
			end

			println("Data Upload: $(this.typ), $(data.id) , $(size) bytes")
			glBufferData(this.typ, size, values, this.mode)
	end

	if this.size > data.size
		#location = data.id-1
		#normalized = GL_FALSE #GLboolean(data.flags & GL_VERTEX_ATTRIB_ARRAY_NORMALIZED != GL_VERTEX_ATTRIB_ARRAY_NORMALIZED)
		#stride = 0 #data.elementsSize #Vertex.SIZE * 4
		#offset = C_NULL #data.offset == 0 ? C_NULL : GLintptr[data.offset]

		#glEnableVertexAttribArray(location)
		#glVertexAttribPointer(location, data.elements, data.typ, normalized, stride, offset)

		println("Data Sub Upload: $(this.typ), $(data.size) bytes, offset:$(data.offset)")
		glBufferSubData(this.typ, GLintptr(data.offset), GLsizeiptr(data.size), data.valuesPtr)
	end

	data.uploaded = true
end

update(this::GLStorageData, mode::Symbol) = this.mode = LIST_DRAW_MODE[mode]

end #GLStorageManager
