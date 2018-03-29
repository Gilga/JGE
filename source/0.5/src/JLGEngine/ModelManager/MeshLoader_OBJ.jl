#struct Vertex { union { struct { _float x, y, z; }; _float pos[3]; }; };

type ShapeCoordinates
	#std::string& name
	positions::AVec3f
	normals::AVec3f
	texcoords::AVec2f
	origin::Vec3f
	scale::Vec3f

	ShapeCoordinates() = new(AVec3f(),AVec3f(),AVec1f(),Vec3f(),Vec3f())
	ShapeCoordinates(positions,normals,texcoords,origin,scale) = new(positions,normals,texcoords,origin,scale)
end

type VertexIndex
	v::Integer
	vt::Integer
	vn::Integer

	VertexIndex() = new(0,0,0)
	VertexIndex(a::Integer) = new(a,a,a)
	VertexIndex(v::Integer, vn::Integer, vt::Integer) = new(v,vt,vn)
end

const AVertexIndex = Array{VertexIndex,1}
const AAVertexIndex = Array{AVertexIndex,1}

function clear(shape::ShapeCoordinates)
	shape.positions = AVec3f()
	shape.normals = AVec3f()
	shape.texcoords = AVec1f()
	shape.origin = Vec3f()
	shape.scale = Vec3f()
end

# for std::map
function operator<(a::VertexIndex, b::VertexIndex)
	if a.v != b.v return (a.v < b.v) end
	if a.vn != b.vn return (a.vn < b.vn) end
	if a.vt != b.vt return (a.vt < b.vt) end
	false
end

isSpace(_char_ c) = (c == ' ') || (c == '\t')
isNewLine(_char_ c) = (c == '\r') || (c == '\n') || (c == '\0')

function getOrigin(min_BBOX::Vec3f, max_BBOX::Vec3f, scale::Float32)
	(max_BBOX + min_BBOX) * Vec3f(scale * 0.5f)
end

function getScale(min_BBOX::Vec3f, max_BBOX::Vec3f)
	size = max_BBOX - min_BBOX
	scale_value = size.x > size.z ? size.x : size.z
	scale_value = scale_value > size.y ? scale_value : size.y
	if scale_value > 0 scale_value = 1 / scale_value end
	scale_value
end

function parseFloat(token::String)
	token += strspn(token, " \t")
	f = (Float32)atof(token)
	token += strcspn(token, " \t\r")
	f
end

function parsevec(token::String, count::Number)
	a = zeros(count)
	for i=1:count a[i] = parseFloat(token) end
	Vec{count, Float32}(a)
end

# Make index zero-base, and also support relative index.
function fixIndex(idx::Integer, n::Integer)
	if idx > 0 i = idx - 1
	else if idx == 0  i = 0
	else i = n + idx # negative value = relative
	end
	i
end

# Parse triples: i, i/j/k, i//k, i/j
function parseTriple(token::String, vsize::Integer, vnsize::Integer, vtsize::Integer)
	vi = VertexIndex(-1)

	vi.v = fixIndex(atoi(token), vsize)
	token += strcspn(token, "/ \t\r");
	if token[0] != '/' return vi end
	++token;

	# i//k
	if token[0] == '/'
		++token
		vi.vn = fixIndex(atoi(token), vnsize)
		token += strcspn(token, "/ \t\r")
		return vi
	end

	# i/j/k or i/j
	vi.vt = fixIndex(atoi(token), vtsize)
	token += strcspn(token, "/ \t\r")
	if (token[0] != '/') return vi; else ++token;  # skip '/'
	vi.vn = fixIndex(atoi(token), vnsize)
	token += strcspn(token, "/ \t\r")
	vi
end

function updateVertex(vi::VertexIndex, vCache::Dict{VertexIndex, _uint},
	coord::ShapeCoordinates, shape::Mesh)

	idx = 0

	it = vCache.find(vi)

	if it != vCache.end() return it->second end

	if vi.v >= length(coord.position)
		error("_DEBUG_BREAK_IF(((_uint)(vi.v) >= (_uint)(coord.positions.size())))")
		return
	end

	shape->addPosition(coord.positions[vi.v] * coord.scale - coord.origin)

	if vi.vn >= 0
		shape->addNormal(coord.normals[vi.vn])
	end

	if vi.vt >= 0
		shape->addTexcoord(coord.texcoords[vi.vt])
	end

	idx = shape->getPositionSize() - 1
	vCache[vi] = idx

	idx;
end

function parseIndicies(
	std::map<VertexIndex, _uint> vCache,
	const std::vector<std::vector<VertexIndex> >& group,
	#const int material_id,
	#const std::string &name,
	#bool clearCache,
	ShapeCoordinates in,
	shape::Mesh)

	clear(shape) # remove old

	if empty(group) return false end

	# Flatten vertices and indices
	for i=0:(group.size()-1)
		face = group[i]

		i0 = face[0]
		i1 = VertexIndex(-1)
		i2 = face[1]

		npolys = length(face)

		# Polygon -> triangle fan conversion
		for k=2:(npolys-1)
			i1 = i2
			i2 = face[k]

			v0 = updateVertex(i0, vCache, in, shape)
			v1 = updateVertex(i1, vCache, in, shape)
			v2 = updateVertex(i2, vCache, in, shape)

			addIndex(shape,v0)
			addIndex(shape,v1)
			addIndex(shape,v2)

			#shape.material_ids.push_back(material_id);
		end
	end

	#shape.name = name;
	#if (clearCache)	vCache.clear();

	true;

end

function parseIndicies(tmp_vi::Array{Array{VertexIndex,1},1},tmp::ShapeCoordinates,shape::Mesh)

	clear(shape) # remove old

	ig = 0
	iCount = length(tmp_vi)
	vCount = length(tmp.positions)
	vnCount = length(tmp.normals)
	vtCount = length(tmp.texcoords)

	if !iCount
		error("No index coordinates! (tmp)")
		return false
	end

	if !vCount
		error("No vertex coordinates! (tmp)")
		return false
	end

	# For each vertex of each triangle
	for (AAVertexIndex::iterator it = tmp_vi.begin(); it < tmp_vi.end(); ++it, ++ig)
		for (AVertexIndex::iterator jt = (*it).begin(); jt < (*it).end(); ++jt)
			vi = jt
			iv = vi.v
			ivn = vi.vn
			ivt = vi.vt

			if iv == -1
				error("Invalid index for vertex coordinates! %u (%d = -1).", ig, iv)
				return false
			else
				if iv < vCount
					addPosition(shape,*(tmp.positions.begin() + iv))
				else
					error("Missmatch count of vertex coordinates! %u (%d >= %u).", ig, iv, vCount)
					return false
				end
			end

			if ivn > -1
				if ivn < vnCount
					addNormal(shape,*(tmp.normals.begin() + ivn))
				else
					error("Missmatch count of normal coordinates! %u (%d = -1 or >= %u).", ig, ivn, vnCount)
					return false
				end
			end

			if ivt > -1
				if ivt < vtCount
					addTexcoord(shape,*(tmp.texcoords.begin() + ivt))
				else
					error("Missmatch count of texture coordinates! %u (%d = -1 or >= %u).", ig, ivt, vtCount)
					return false
				end
			end
		end
	end

	vCount = length(shape.positions)
	vnCount = length(shape.normals)
	vtCount = length(shape.texcoords)

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

function loadOBJ(path::String, shape::Mesh)
	println("Load OBJ file $path...");

	tmp_v = AVec3f()
	tmp_vn = AVec3f()
	tmp_vt = AVec2f()
	tmp_g = AAVertexIndex()

	std::filebuf fb
	std::filebuf* fb_result = fb.open(path, std::ios::in)

	if fb_result == C_NULL
		error("Cannot open file $path!")
		return false
	end

	std::istream is(&fb)
	maxchars = 8192
	buf = zeros(Arrray{Char,1},maxchars)
	vertexCache = Dict{VertexIndex,UInt32}()

	min_BBOX = zeros(Vec3f)
	max_BBOX = zeros(Vec3f)

	while is.peek() != -1
		is.getline(&buf[0], maxchars)
		std::string linebuf(&buf[0])
		size = linebuf.size()
		id = size - 1

		# trim '\r\n', '\n'
		if size > 0 && linebuf[id] == '\n' linebuf.erase(id)
			size = linebuf.size()
			id = size - 1
		end

		if size > 0 && linebuf[id] == '\r' linebuf.erase(id)
			size = linebuf.size()
			id = size - 1
		end

		if empty(linebuf) continue end

		token = linebuf.c_str()
		token += strspn(token, " \t")
		if !token error("!token") end

		first = linebuf[0]
		second = linebuf[1]
		third = linebuf[2]

		if first == '\0' continue # empty line
		elseif first == '#' continue  # comment line

		elseif first == 'v' && isSpace(second)
			token += 2
			v = parsevec3(token)

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
			token += 3
			push!(tmp_vn,parsevec3(token))
			continue

		elseif first == 'v' && second == 't' && isSpace(third)
			token += 3
			push!(tmp_vt,parsevec2(token))
			continue

		elseif first == 'f' && isSpace(second)
			token += 2
			token += strspn(token, " \t")

			group = Array{VertexIndex,1}()
			while !isNewLine(token[0])
				vi = parseTriple(token, tmp_v.size() / 3, tmp_vn.size() / 3, tmp_vt.size() / 2)
				push!(group,vi)
				n = strspn(token, " \t\r")
				token += n
			end

			push!(tmp_g,group)

			continue
		end
	end
	close(fb)

	scale_value = getScale(min_BBOX, max_BBOX)
	coord = ShapeCoordinates( tmp_v, tmp_vn, tmp_vt, getOrigin(min_BBOX, max_BBOX, scale_value), Vec3f(scale_value) )

	result = parseIndicies(vertexCache, tmp_g, coord, shape) # parseIndicies(tmp_g, in, shape);
	clear(tmp_g)

	if result println("Finsihed loading OBJ file $path.") end

	result
end
