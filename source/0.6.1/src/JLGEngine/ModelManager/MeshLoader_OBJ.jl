#struct Vertex { union { struct { _float x, y, z; }; _float pos[3]; }; };

type ShapeCoordinates
	#std::string& name
	positions::AVec3f
	normals::AVec3f
	texcoords::AVec2f
	indicies::AIndex
	origin::Vec3f
	scale::Vec3f

	ShapeCoordinates() = new(AVec3f(),AVec3f(),AVec1f(),AIndex(),Vec3f(),Vec3f())
	ShapeCoordinates(positions,normals,texcoords,indicies,origin,scale) = new(positions,normals,texcoords,indicies,origin,scale)
end

type VertexIndex
	v::Integer
	vt::Integer
	vn::Integer

	VertexIndex() = new(0,0,0)
	VertexIndex(a::Integer) = new(a,a,a)
	VertexIndex(v::Integer, vn::Integer, vt::Integer) = new(v,vt,vn)
end

AVertexIndex = Array{VertexIndex,1}
AAVertexIndex = Array{AVertexIndex,1}
AGroupIndex = Array{Array{Array{Integer,1},1},1}

function clear(sc::ShapeCoordinates)
	sc.positions = AVec3f()
	sc.normals = AVec3f()
	sc.texcoords = AVec1f()
	sc.indicies = AIndex()
	sc.origin = Vec3f()
	sc.scale = Vec3f()
end

# for std::map
function isSmaller(a::VertexIndex, b::VertexIndex)
	if a.v != b.v return (a.v < b.v) end
	if a.vn != b.vn return (a.vn < b.vn) end
	if a.vt != b.vt return (a.vt < b.vt) end
	false
end

isSpace(c::Char) = (c == ' ') || (c == '\t')
isNewLine(c::Char) = (c == '\r') || (c == '\n') || (c == '\0')

function getOrigin(min_BBOX::Vec3f, max_BBOX::Vec3f, scale::Number)
	(max_BBOX + min_BBOX) * (scale * 0.5f0)
end

function getScale(min_BBOX::Vec3f, max_BBOX::Vec3f)
	size = max_BBOX - min_BBOX
	println("size: ",size)
	scale_value = size.x > size.z ? size.x : size.z
	println("1scale_value: ",scale_value)
	scale_value = scale_value > size.y ? scale_value : size.y
	println("2scale_value: ",scale_value)
	scale_value = abs(scale_value)
	println("3scale_value: ",scale_value)
	if scale_value > 1 scale_value = 1 / scale_value
	#if scale_value > 0 && scale_value < 1 scale_value = scale_value
	else scale_value = 1
	end
	scale_value
end

#function parseval(T::DataType, str::String, start=1)
#	t = search(str, r"[\+\-]?[0-9]+(\.[0-9]+)?", start)
#	
##	v = 0
#	try
#		v = parse(T, str[t.start:t.stop])
##	catch(e)
#	end
#	
#	(v, t.stop)
#end

function parseVal(T::DataType, str::AbstractString, default=T(0))
	try
		return parse(T, str)
	catch(e)
	end
	default
end

#for m in eachmatch(Regex("([0-9]+) ([0-9]+) ([0-9]+)"),"1 2 3s") println(m.captures) end
function parseArray(T::DataType, str::AbstractString)
	a = Array{T,1}()
	m = matchall(Regex("(^|(?<=\\s))[+-]?([0-9]+[.])?[0-9]+([eE][-+]?[0-9]+)?((?=\\s)|\$)"),str) # only valid: (space?)(number)(space?)
	#for x in m push!(a, parseval(T, x)) end
	map(x->parseVal(T,x),m)
end

function parseVec(linenr::Number, str::AbstractString, count::Number)
	if count < 1 error("count < 1") end

	a = parseArray(Float32, str)
	len = length(a)
	
	if len != count	warn(linenr, ": missmatch count: required=$count != found=$(length(a)) ", str)	end

	# on count missmatch: just read until max(count) reachted
	v = zeros(Float32,count)
	for i=1:(len>=count ? count : len) v[i]=a[i] end
	
	result = nothing
	if count == 1 result = Vec1f(v)
	elseif count == 2 result = Vec2f(v)
	elseif count == 3 result = Vec3f(v)
	elseif count == 4 result = Vec4f(v)
	else result = Vec{count, Float32}(v)
	end
	result
end

# Make index zero-base, and also support relative index.
function parseIndex(str::AbstractString, n::Integer)
	#a = parseArray(Integer, str)
	i = parseVal(Int, str, -1) #length(a)>0 ? a[1] : 0
	#if idx >= 0 i = idx
	#else i = n + idx # negative value = relative
	#end
	i
end

has(str::AbstractString, index::Integer, c::Char) = index>0 && index<=length(str) && str[index] == c

# Parse triples: i, i/j/k, i//k, i/j
function parseTriple(line::AbstractString, vsize::Integer, vnsize::Integer, vtsize::Integer)
	vi = VertexIndex()

	tmp = line
	vi.v = parseIndex(tmp, vsize)
	token = search(tmp, r"[/\s]").start
	if !has(line,token,'/') return vi end
	token+=1

	# i//k
	if has(line,token,'/')
		token+=1
		tmp = line[token:end]
		vi.vn = parseIndex(tmp, vnsize)
		token = search(tmp, r"/\s").start
		return vi
	end

	# i/j/k or i/j
	tmp = line[token:end]
	vi.vt = parseIndex(tmp, vtsize)
	token = search(tmp, r"[/\s]").start
	
	if !has(line,token,'/') return vi
	else token+=1  # skip '/'
	end
	
	tmp = line[token:end]
	vi.vn = parseIndex(tmp, vnsize)
	token = search(tmp, r"[/\s]").start
	vi
end

function updateVertex2(vi::VertexIndex, vCache::Dict{VertexIndex, Integer}, coord::ShapeCoordinates, cache::ShapeCoordinates)
	if haskey(vCache, vi) return vCache[vi] end

	if vi.v > 0 && vi.v > length(coord.positions)
		error("$(vi.v) > $(length(coord.positions))")
		return 0
	end

	v = coord.positions[vi.v]
	println("push position ", v)
	push!(cache.positions, v) #MatrixMath.scale(v,coord.scale) - coord.origin)

	if vi.vn > 0
		v = coord.normals[vi.vn]
		println("push normal ", v)
		push!(cache.normals, v)
	end

	if vi.vt > 0
		v = coord.texcoords[vi.vt]
		println("push texcoord ", v)
		push!(cache.texcoords, v)
	end

	idx = length(cache.positions)
	vCache[vi] = idx
	idx
end

const MinUInt32 = UInt32(0)
const MaxUInt32 = UInt32(2^32 - 1)

correctVec(v::Vec3f, tmp::ShapeCoordinates) = MatrixMath.scale(v, tmp.scale) #MatrixMath.scale(v, tmp.scale) - tmp.origin

function parseAll(
	vCache::Dict{VertexIndex,Integer},
	groups::AGroupIndex,
	#const int material_id,
	#const std::string &name,
	#bool clearCache,
	tmp::ShapeCoordinates,
	cache::ShapeCoordinates)
	
	clear(cache) # remove old

	cache.positions = map(x->correctVec(x, tmp),tmp.positions)
	cache.normals = tmp.normals
	cache.texcoords = tmp.texcoords
	
	for gs in groups
		for g in gs
			for index in g
				index += -1 #fix: index in file starts with 1 (not 0)
				index = index < MinUInt32 || index > MaxUInt32 ? MaxUInt32 : index
				push!(cache.indicies, UInt32(index))
				break # take only vertex indicies
			end
		end
	end

	# Flatten vertices and indices
	#=
	if length(group) < 1
		warn("group: $(length(group))")
		return false
	end
	
	println("indicies group $(length(group))")
	for i=1:length(group)
		face = group[i]

		i0 = face[1]
		i1 = VertexIndex()
		i2 = face[2]

		npolys = length(face)

		# Polygon -> triangle fan conversion
		for k=3:npolys
			i1 = i2
			i2 = face[k]

			v0 = updateVertex(i0, vCache, sc, cache)
			v1 = updateVertex(i1, vCache, sc, cache)
			v2 = updateVertex(i2, vCache, sc, cache)

			println("push index ", v0); push!(cache.indicies, v0)
			println("push index ", v1); push!(cache.indicies, v1)
			println("push index ", v2); push!(cache.indicies, v2)
		end
	end
	=#

	true
end

function parseIndicies(tmp_vi::AAVertexIndex,tmp::ShapeCoordinates, cache::ShapeCoordinates)

	clear(cache) # remove old

	ig = 0
	iCount = length(tmp_vi)
	vCount = length(tmp.positions)
	vnCount = length(tmp.normals)
	vtCount = length(tmp.texcoords)

	if !iCount warn("No index coordinates! $tmp")	end

	if !vCount
		error("No vertex coordinates! $tmp")
		return false
	end

	# For each vertex of each triangle
	for it in tmp_vi
		ig+=1
		for jt in it
			vi = jt
			iv = vi.v
			ivn = vi.vn
			ivt = vi.vt

			if iv > 0
				if iv <= vCount
					push!(cache.positions, tmp.positions[iv])
				else
					error("Missmatch count of vertex coordinates! $ig ($iv <= 0 or >= $vCount).")
					return false
				end
			end

			if ivn > 0
				if ivn <= vnCount
					push!(cache.normals, tmp.normals[ivn])
				else
					error("Missmatch count of normal coordinates! $ig ($ivn <= 0 or >= $vnCount).")
					return false
				end
			end

			if ivt > 0
				if ivt <= vtCount
					push!(cache.texcoords, tmp.texcoords[ivt])
				else
					error("Missmatch count of texture coordinates! $ig ($ivt <= 0 or >= $vtCount).")
					return false
				end
			end
		end
	end

	vCount = length(cache.positions)
	vnCount = length(cache.normals)
	vtCount = length(cache.texcoords)

	if !vCount
		error("No vertex coordinates!")
		return false
	end

	if vnCount > 0 && vCount != vnCount
		error("Missmatch count of vertex and normal coordinates! ($vCount != $vnCount).")
		return false
	end

	if vtCount > 0 && vCount != vtCount
		error("Missmatch count of vertex and texture coordinates! ($vCount != $vtCount).")
		return false
	end

	true
end

function loadOBJ(path::String, mesh::Mesh)
	println("Load OBJ file $path...");

	tmp_v = AVec3f()
	tmp_vn = AVec3f()
	tmp_vt = AVec2f()
	tmp_g = AGroupIndex()

	vertexCache = Dict{VertexIndex,Integer}()

	min_BBOX = zeros(Vec3f)
	max_BBOX = zeros(Vec3f)

	linenr = 0
	warn(string("read ", path))
	open(path) do file
		content=readstring(file)
		content=Base.replace(content, "\r", "")
		content=Base.replace(content, "\\\n", "") #remove broken lines
		#content=string(content,'\0')
		open(x -> println(x, content), string(path, ".cleaned"), "w+")
		for line in split(content,r"\n")
			linenr += 1
			line = lstrip(line)
			len = length(line) #+remove r
			id = len

			if len == 0 || line == "" continue end
			
			token = search(line, r"\s+").start
			if token <= 0
				#error(string(linenr, ": invalid token = ", token))
				warn(string(linenr, ": no separator -> skip"))
				continue
			end
			
			#println(string(linenr, ": search..."))

			first = line[1]
			second = len > 1 ? line[2] : ""
			third = len > 2 ? line[3] : ""

			if first == '\0' || first == '#' continue # skip line

			elseif first == 'v' && isSpace(second)
				part = line[token:end]
				#warn(string(linenr, ": ", line))
				v = parseVec(linenr, part, 3)

				# set bounding box
				if v.x < min_BBOX.x min_BBOX.x = v.x end
				if v.y < min_BBOX.y min_BBOX.y = v.y end
				if v.z < min_BBOX.z min_BBOX.z = v.z end
				if v.x > max_BBOX.x max_BBOX.x = v.x end
				if v.y > max_BBOX.y max_BBOX.y = v.y end
				if v.z > max_BBOX.z max_BBOX.z = v.z end

				push!(tmp_v,v)
				continue

			elseif first == 'v' && second == 'n' && isSpace(third)
				part = line[token:end]
				#warn(string(linenr, ": ", line))
				v = parseVec(linenr, part, 3)
				#push!(tmp_vn, v)
				continue

			elseif first == 'v' && second == 't' && isSpace(third)
				part = line[token:end]
				#warn(string(linenr, ": ", line))
				v = parseVec(linenr, part, 2)
				#push!(tmp_vt,v)
				continue

			elseif first == 'f' && isSpace(second)

				token += 1
				part = line[token:end]
				#warn(string(linenr, ": ", line))
				
				group = map((p)->map(function(x)
					v=parseVal(UInt32,x, -1)
					#println(linenr, ": index ", part, " => ", v)
					v
				end,split(p, r"/")),split(part, r"\s+"))
				
				#if j>0
				#	println("=> ", vi)
				#	push!(group,vi)
				#end
				
				#max = length(a) #search(line[token:end],r"[\n]").start
				#for i=1:max
				#	part = line[token:end]
				#	vi = parseTriple(part, Integer(round(length(tmp_v) / 3)), Integer(round(length(tmp_vn) / 3)), Integer(round(length(tmp_vt) / 2)))
				#	println(linenr, ": index ", part, " => ", vi)
				#	push!(group,vi)
				#	n = search(part, r"[ \t]").start
				#	token += n
				#end

				push!(tmp_g, group)
			end
		end
	end

	scale_value = getScale(min_BBOX, max_BBOX)
	println("scale_value: ",scale_value)
	tmp_sc = ShapeCoordinates( tmp_v, tmp_vn, tmp_vt, AIndex(), getOrigin(min_BBOX, max_BBOX, scale_value), Vec3f(scale_value) )
	cache = ShapeCoordinates()
	result = parseAll(vertexCache, tmp_g, tmp_sc, cache)

	if result
		#println("positions $(length(cache.positions)): ", cache.positions)
		#println("normals $(length(cache.normals)): ", cache.normals)			
		#println("texcoords $(length(cache.texcoords)): ", cache.texcoords)
		#println("indicies $(length(cache.indicies)). ", cache.indicies)
		
		MeshManager.update(mesh, :MODEL, ()->(:TRIANGLES, cache.positions,cache.normals,cache.texcoords,cache.indicies))
		#shape.material_ids.push_back(material_id);
		#shape.name = name;
		#if (clearCache)	vCache.clear();
		println("Finsihed loading OBJ file $path.")
	end

	result
end
