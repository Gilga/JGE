using ..StorageManager

shaderAttributes = []
listListenerOnShaderPropertyUpdate = SortedDict{Symbol, Dict{String,Function}}()

""" TODO """
setListenerOnShaderPropertyUpdate(id::Symbol, t::Tuple) = setListenerOnShaderPropertyUpdate(id, Dict{String,Function}(t))

""" TODO """
setListenerOnShaderPropertyUpdate(id::Symbol, d::Dict{String,Function}) = listListenerOnShaderPropertyUpdate[id]=d
removeListenerOnShaderPropertyUpdate(id::Symbol) = (listListenerOnShaderPropertyUpdate[id]=nothing)

""" TODO """
setShaderPropberty(program::AbstractGraphicsShaderProgram, name::String, args...) = program != nothing ? glUniform(glUniformLocation(program.id, name), args...) : nothing

""" TODO """
isAttribute(x) = (x == GL_PROGRAM_INPUT || x == GL_PROGRAM_OUTPUT)

""" TODO """
isUniform(x) = (x == GL_UNIFORM || x == GL_UNIFORM_BLOCK || x == GL_SHADER_STORAGE_BLOCK)

""" TODO """
function setVertexAttribArray(program::GLuint, prop::ShaderProperty)
	if prop.location < 0 || prop.data == nothing || !isa(prop.data, GLStorageData) return end
	glEnableVertexAttribArray(prop.location)
	glVertexAttribPointer(prop.location, prop.elements, prop.data.typ,
			GLboolean(prop.data.flags & GL_VERTEX_ATTRIB_ARRAY_NORMALIZED != GL_VERTEX_ATTRIB_ARRAY_NORMALIZED),
			prop.data.elementsSize, prop.offset == 0 ? C_NULL : GLuint[prop.offset]) #gl.PtrOffset(0)
	#glDisableVertexAttribArray(prop.location)
end

""" TODO """
function findShaderProperties(program::AbstractGraphicsShaderProgram)
	if program == nothing return end
	for (id,list) in listListenerOnShaderPropertyUpdate
		for (name,f) in list if haskey(program.properties,name) program.properties[name].update=f end	end
	end
end

""" TODO """
function getShaderProperties(program::AbstractGraphicsShaderProgram, buffer::AbstractGraphicsData)
	if isLinked(program) && buffer != nothing && isa(buffer, GLStorage) && buffer.linked
		for (_,p) in program.properties
			c = p.categoryid
			data = p.update()
			if data != nothing
				p.data = data
				if isAttribute(c)
					if p.location == -1 p.location = glAttribLocation(program.id, p.name) end
					if c == GL_PROGRAM_INPUT setVertexAttribArray(program.id, p)
					else setFragLocation(program.id, p.name)
					end
				elseif isUniform(c)
					if p.location == -1 p.location = glUniformLocation(program.id, p.name) end
					if c == GL_UNIFORM  glUniform(p.location, p.data) end
				end
			end
		end
	end
end

""" TODO """
function findShaderProperty(program::AbstractGraphicsShaderProgram, line::String)
	if program == nothing return end
	m = match(r"\s*(\w+)\s+(\w+)\s+(\w+)\s*\;", line)
	if m != nothing
		m=m.captures
		c=m[1]
		t=m[2]

		# [mat/vec] without type => float
		mt = match(r"^((mat[2-4](\x[2-4])?)|(vec))[2-4]$", t)
		if mt != nothing t=string(t,"f") end

		#GL_UNIFORM_BLOCK
		ci = (c == "in" ? GL_PROGRAM_INPUT : (c == "out" ? GL_PROGRAM_OUTPUT : (c == "uniform" ? GL_UNIFORM : GL_BUFFER_VARIABLE)))

		p = ShaderProperty()
		p.name = m[3]
		p.category=c
		p.typname=t
		p.categoryid = ci
		for (key, value) in LIST_TYPE_STRING if p.typname == value p.typid=key;	break end end
		for (key, value) in LIST_TYPE if p.typid == value p.typ=key;	break end end
		p.elements = haskey(LIST_TYPE_ELEMENTS, p.typid) ?  LIST_TYPE_ELEMENTS[p.typid] : 1

		# set offset
		if isAttribute(p.categoryid)
			offset=0
			for v in shaderAttributes
				offset+=v.offset+v.elements*sizeof(v.typ)
			end
			p.offset = offset
			push!(shaderAttributes, p)
		end

		#p.size=size
		CoreExtended.update(program.properties,p.name,
		function(x)
			if !x[1] return p end
			p=x[2]
			if isAttribute(ci) && isAttribute(p.categoryid)
				p.categoryid = -1 # custom type
				p.category="shared"
			end
			p
		end)
	end
end

""" TODO """
function findActiveRessources(program::AbstractGraphicsShaderProgram)
	if program == nothing return end
	if printError("Before findActiveRessources") return end

	programID = program.id

	attributeMap = []
	uniformMap = []
	uniformBlockMap = []
	matrixMap = []

	#if !program.linked
		#program.shaders_count = 0
		#program.shaderParts = false
		#return
	#end

	const properties = GLenum[ GL_PROGRAM_INPUT, GL_PROGRAM_OUTPUT, GL_UNIFORM, GL_UNIFORM_BLOCK, GL_SHADER_STORAGE_BLOCK ]
	const NAMES = String[ "IN Attributes", "OUT Attributes", "Uniforms", "Uniform Blocks", "Storage Blocks" ]
	const TOTAL = length(properties)
	COUNT = zeros(GLint, TOTAL)

	#println("Version: ",glString(GL_VERSION))
	#println("MJ: ",glGet(GLint,GL_MAJOR_VERSION))
	#println("MN: ",glGet(GLint, GL_MINOR_VERSION))
	println("\n[ SHADER RESOURCES ]\n")

	#@show activeUnif = glGetProgramiv(programID, GL_ACTIVE_UNIFORMS)

	for i = 1:TOTAL
		# glGetProgramInterfaceiv usable since gl version 4.3
		# breaks when using intel gpu ..?
		count = getValByRef((ref) -> glGetProgramInterfaceiv(programID, properties[i], GL_ACTIVE_RESOURCES, ref), COUNT[i])

		if printError("glGetProgramInterfaceiv") return end

		if count > 0 COUNT[i] = count end
	end

	#@printf("%s : %d\n", NAMES[i], count)
	#println()

	for i = 1:TOTAL
		count =  GLuint(COUNT[i])
		if count <= 0 continue end
		println("  [ $(NAMES[i]) ] ($(count))")
		category=properties[i]
		addProperties(program, category, count)
		#if category != GL_UNIFORM_BLOCK addProperties(program, category, count)
		#else addShaderPropertyBlocks(category, count)
		#end
		println()
	end

	println("[/ SHADER RESOURCES ]\n")
end

# TODO: CHECK
#=
function addShaderPropertyBlocks(program::AbstractGraphicsShaderProgram, category::GLenum, count::GLuint)
	if program == nothing return end
	if printError("Before addShaderPropertyBlocks") return end
	if count <= 0 return end

	programID = program.id

	if category != GL_UNIFORM_BLOCK && category != GL_SHADER_STORAGE_BLOCK return end #_DEBUG_BREAK_IF

	const b_NAME = 1
	const b_VARS = 2
	const b_BINDS = 3
	const b_SIZE = 4

	const properties	= GLenum[ GL_NAME_LENGTH, GL_NUM_ACTIVE_VARIABLES, GL_BUFFER_BINDING, GL_BUFFER_DATA_SIZE ]
	const activeProp = GLenum[ GL_ACTIVE_VARIABLES ]

	const TOTAL = length(properties)

	block = nothing
	pcount = 0

	values = zeros(GLint, TOTAL)

	nameData = GLchar[0]

	for tmpId = 1:count

		values = getValByRef((ref) -> glGetProgramResourceiv(programID, category, tmpId, TOTAL, pointer(properties), TOTAL * sizeof(GLenum), C_NULL, ref), values)

		if printError("glGetProgramResourceiv") return end

		if err len = 255
		else
			len = length(values) >= p_NAME ? values[p_NAME] : 0
			if len < 0 len = 0 end
		end

		nameData = zeros(GLchar,len)
		nameData = getValByRef((ref) -> glGetProgramResourceName(programID, category, tmpId, length(nameData), C_NULL, ref), nameData)

		if printError("glGetProgramResourceName") name = "Unknown"
		else name = convert(String, nameData[1:len-1])
		end

		size = values[b_SIZE]
		index = glGetProgramResourceIndex(programID, category, pointer(name)) # TODO

		if printError("glGetProgramResourceIndex") index = -1	end

		binding = values[b_BINDS]

		#GL_INVALID_ENUM; GL_INVALID_INDEX
		block = ShaderProperty()
		block.categoryid=category
		block.name = name
		block.index=index
		block.binding=binding
		block.size=size

		#link(block, program)

		@printf("  - %d. [%d] %s <%d>\n", index, binding, name, size)

		pcount = values[b_VARS]
		#if !pcount continue end
		#addProperties(program, category == GL_UNIFORM_BLOCK ? GL_UNIFORM : GL_BUFFER_VARIABLE, pcount, block)
		#add(block)
	end
end
=#

""" TODO """
function addProperties(program::AbstractGraphicsShaderProgram, category::GLenum, count::GLuint, block=nothing) #ShaderProperty
	if program == nothing return end
	if printError("Before addProperties") return end
	if count <= 0 return end

	programID = program.id

	const p_INDEX = 1
	const p_NAME = 2
	const p_TYPE = 3
	const p_ARRAYSIZE = 4
	const p_LOCATION = 5
	const p_OFFSET = 6
	const p_ARRAY = 7
	const p_MATRIX = 8
	const p_TOPARRAYSIZE = 9
	const p_TOPARRAYSTRIDE = 10

	const GL_LOCATION_COMPONENT = convert(GLenum, 0x934A)

	const aplist = GLenum[ GL_LOCATION_COMPONENT,	GL_NAME_LENGTH, GL_TYPE, GL_ARRAY_SIZE, GL_LOCATION ]
	const uplist = GLenum[ GL_BLOCK_INDEX, 				GL_NAME_LENGTH, GL_TYPE, GL_ARRAY_SIZE, GL_LOCATION, GL_OFFSET, GL_ARRAY_STRIDE, GL_MATRIX_STRIDE ]
	const bplist = GLenum[ GL_BLOCK_INDEX,				GL_NAME_LENGTH, GL_TYPE, GL_ARRAY_SIZE,	GL_LOCATION, GL_OFFSET, GL_ARRAY_STRIDE, GL_MATRIX_STRIDE, GL_TOP_LEVEL_ARRAY_SIZE, GL_TOP_LEVEL_ARRAY_STRIDE ]
	const splist = GLenum[ GL_BLOCK_INDEX,				GL_NAME_LENGTH, GL_TYPE, GL_BUFFER_DATA_SIZE, GL_BUFFER_BINDING, GL_NUM_ACTIVE_VARIABLES ]

	#GL_IS_ROW_MAJOR, GL_ATOMIC_COUNTER_BUFFER_INDEX, GL_REFERENCED_BY_VERTEX_SHADER, GL_REFERENCED_BY_TESS_CONTROL_SHADER,
	#GL_REFERENCED_BY_TESS_EVALUATION_SHADER, GL_REFERENCED_BY_GEOMETRY_SHADER, GL_REFERENCED_BY_FRAGMENT_SHADER, GL_REFERENCED_BY_COMPUTE_SHADER

	const CATEGORIES = Dict{GLenum,Tuple{String,Array{GLenum,1}}}(
		GL_PROGRAM_OUTPUT		=> ("Output", aplist),
		GL_PROGRAM_INPUT		=> ("Input", aplist),
		GL_UNIFORM					=> ("Uniform", uplist),
		GL_BUFFER_VARIABLE	=> ("Buffer", bplist),
		GL_UNIFORM_BLOCK		=> ("UniformBlock", splist),
	)

	if !haskey(CATEGORIES, category)
		println("ERROR: UNKNOWN TYPE") #_DEBUG_BREAK_IF
		return
	end

	t=CATEGORIES[category]
	category_name = t[1]
	properties = t[2]
	TOTAL = length(properties)
	BUFSIZE = TOTAL * sizeof(GLenum)

	values = zeros(GLint,TOTAL)
	nameData = GLchar[0]

	categoryID = category
	name = ""
	len = 0

	PTR = pointer(properties)

	for i = 1:count
		tmpId=i-1

		values = getValByRef((ref) -> glGetProgramResourceiv(programID, category, tmpId, TOTAL, PTR, BUFSIZE, C_NULL, ref), values)

		err = printError("glGetProgramResourceiv")

		if err len = 255
		else
			len = length(values) >= p_NAME ? values[p_NAME] : 0
			if len < 0 len = 0 end
		end

		nameData = zeros(GLchar,len)
		nameData = getValByRef((ref) -> glGetProgramResourceName(programID, category, tmpId, length(nameData), C_NULL, ref), nameData)

		if printError("glGetProgramResourceName") name = "Unknown"
		else name = convert(String, nameData[1:len-1])
		end

		# debugging
		if err
			warn("An error did occur for variable $name [$category_name] ($tmpId)!")

			pdummy = GLenum[1]; dummy = GLint[1]
			for tId = 1:TOTAL
				pdummy[1] = properties[tId]
				#VideoDriver<GLEW>::Shader<Ressource>::get(programID, categoryID, tmpId, GLint(1), pdummy, dummy)
				dummy = getValByRef((ref) -> glGetProgramResourceiv(programID, category, tmpId, 1, pointer(pdummy), 1 * sizeof(GLenum), C_NULL, ref), dummy)
				if hasError() @printf("Parameter %d (%d) failed.\n", tId, pdummy[1]) end
			end
			continue
		end

		# ------------------------------------
		hasBlock = block != nothing

		if category == GL_UNIFORM
			if hasBlock || values[p_INDEX] == -1 pindex = tmpId
			else continue
			end
		elseif category == GL_BUFFER_VARIABLE pindex = tmpId
		else pindex = values[p_INDEX]
		end

		index = glGetProgramResourceIndex(programID, category, pointer(name)) # TODO
		if printError("glGetProgramResourceIndex") index = -1	end

		typ = values[p_TYPE]
		type_name = LIST_TYPE_STRING[typ]
		location = category != GL_BUFFER_VARIABLE ? values[p_LOCATION] : values[p_INDEX]
		binding = length(values)>= GL_LOCATION ? values[GL_LOCATION] : -1
		arrSize = values[p_ARRAYSIZE]
		size = arrSize

		prop = ShaderProperty()
		prop.index = index
		prop.name = name
		prop.categoryid=category
		prop.typid=typ
		prop.location=location
		prop.binding = binding
		prop.size=size

		#if typ == GL_FLOAT_MAT4 prop.code = MATRICES::getCode(name)

		#GL_TRANSPOSE_MODELVIEW_MATRIX
		#GL_TRANSPOSE_PROJECTION_MATRIX
		#GL_TRANSPOSE_TEXTURE_MATRIX
		#GL_TRANSPOSE_COLOR_MATRIX

		if category == GL_UNIFORM || category == GL_BUFFER_VARIABLE

			auxSize = 0
			arrayStride = values[p_ARRAY]
			matrixStride = values[p_MATRIX]

			prop.offset=values[p_OFFSET]
			prop.arrayStride=arrayStride
			prop.matrixStride=values[p_MATRIX]

			if category == GL_BUFFER_VARIABLE
				prop.topSize=values[p_TOPARRAYSIZE]
				prop.topStride=values[p_TOPARRAYSTRIDE]
			end

			if arrayStride > 0
				size = arrayStride * arrSize

			elseif matrixStride > 0

				if (typ == GL_FLOAT_MAT2) || (typ == GL_FLOAT_MAT2x3) || (typ == GL_FLOAT_MAT2x4) || (typ == GL_DOUBLE_MAT2) || (typ == GL_DOUBLE_MAT2x3) || (typ == GL_DOUBLE_MAT2x4)
					auxSize = 2
				elseif (typ == GL_FLOAT_MAT3) || (typ == GL_FLOAT_MAT3x2) || (typ == GL_FLOAT_MAT3x4) || (typ == GL_DOUBLE_MAT3) || (typ == GL_DOUBLE_MAT3x2) || (typ == GL_DOUBLE_MAT3x4)
					auxSize = 3
				elseif (typ == GL_FLOAT_MAT4) || (typ == GL_FLOAT_MAT4x2) || (typ == GL_FLOAT_MAT4x3) || (typ == GL_DOUBLE_MAT4) || (typ == GL_DOUBLE_MAT4x2) || (typ == GL_DOUBLE_MAT4x3)
					auxSize = 4
				end

				auxSize *= matrixStride
				size = auxSize
			end

			#if (location != -1 && type == GL_SAMPLER_2D)
			#glUniform1i(location, 0); // Set our sampler to user Texture Unit 0
			#driver->printError("glUniform1i DiffuseMap");
			#end
		end

		prop.size=size

		if size == 0
			@printf("  %s%d. [%d] %s %s <%d>\n", hasBlock ? "\t- " : "",	pindex, location, name, type_name, size)
		else
			@printf("  %s%d. [%d] %s %s (%d) <%d>\n", hasBlock ? "\t- " : "", pindex, location, name, type_name, prop.offset, size);
		end

		pcount = length(values)>= p_OFFSET ? values[p_OFFSET] : 0 # vars

		if pcount > 0 && (category == GL_UNIFORM_BLOCK || category == GL_ATOMIC_COUNTER_BUFFER || category == GL_SHADER_STORAGE_BLOCK || category == GL_TRANSFORM_FEEDBACK_BUFFER)
			addProperties(program, category == GL_UNIFORM_BLOCK ? GL_UNIFORM : GL_BUFFER_VARIABLE, pcount, prop)
		end

		if hasBlock && !haskey(block.properties, prop.name) block.properties[prop.name]=prop
		elseif !haskey(program.properties, prop.name) program.properties[prop.name]=prop
		end

	end
end
