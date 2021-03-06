using MatrixMath

const MeshDataPlaneQuad = rotr90flipdim2(Float32[
	-1 -1 0 0	# upleft
	1 -1 0 0	# upright
	1 1 0 0	# downright
	-1 1 0 0	# downleft
])

const MeshDataPlaneVertex = rotr90flipdim2(Float32[
	-1.0 -1.0 0.0 1.0 0.0
	1.0 -1.0 0.0 0.0 0.0
	1.0 1.0 0.0 0.0 1.0
	1.0 1.0 0.0 0.0 1.0
	-1.0 1.0 0.0 1.0 1.0
	-1.0 -1.0 0.0 1.0 1.0

	-1.0 -1.0 0.0 1.0 0.0
	1.0 -1.0 0.0 0.0 0.0
	-1.0 1.0 0.0 1.0 1.0
	1.0 -1.0 0.0 0.0 0.0
	1.0 1.0 0.0 0.0 1.0
	-1.0 1.0 0.0 1.0 1.0
])

const MeshDataCube = Float32[
	#  X, Y, Z, U, V
	# Bottom
	-1.0, -1.0, -1.0, 0.0, 0.0,
	1.0, -1.0, -1.0, 1.0, 0.0,
	-1.0, -1.0, 1.0, 0.0, 1.0,
	1.0, -1.0, -1.0, 1.0, 0.0,
	1.0, -1.0, 1.0, 1.0, 1.0,
	-1.0, -1.0, 1.0, 0.0, 1.0,

	# Top
	-1.0, 1.0, -1.0, 0.0, 0.0,
	-1.0, 1.0, 1.0, 0.0, 1.0,
	1.0, 1.0, -1.0, 1.0, 0.0,
	1.0, 1.0, -1.0, 1.0, 0.0,
	-1.0, 1.0, 1.0, 0.0, 1.0,
	1.0, 1.0, 1.0, 1.0, 1.0,

	# Front
	-1.0, -1.0, 1.0, 1.0, 0.0,
	1.0, -1.0, 1.0, 0.0, 0.0,
	-1.0, 1.0, 1.0, 1.0, 1.0,
	1.0, -1.0, 1.0, 0.0, 0.0,
	1.0, 1.0, 1.0, 0.0, 1.0,
	-1.0, 1.0, 1.0, 1.0, 1.0,

	# Back
	-1.0, -1.0, -1.0, 0.0, 0.0,
	-1.0, 1.0, -1.0, 0.0, 1.0,
	1.0, -1.0, -1.0, 1.0, 0.0,
	1.0, -1.0, -1.0, 1.0, 0.0,
	-1.0, 1.0, -1.0, 0.0, 1.0,
	1.0, 1.0, -1.0, 1.0, 1.0,

	# Left
	-1.0, -1.0, 1.0, 0.0, 1.0,
	-1.0, 1.0, -1.0, 1.0, 0.0,
	-1.0, -1.0, -1.0, 0.0, 0.0,
	-1.0, -1.0, 1.0, 0.0, 1.0,
	-1.0, 1.0, 1.0, 1.0, 1.0,
	-1.0, 1.0, -1.0, 1.0, 0.0,

	# Right
	1.0, -1.0, 1.0, 1.0, 1.0,
	1.0, -1.0, -1.0, 1.0, 0.0,
	1.0, 1.0, -1.0, 0.0, 0.0,
	1.0, -1.0, 1.0, 1.0, 1.0,
	1.0, 1.0, -1.0, 0.0, 0.0,
	1.0, 1.0, 1.0, 0.0, 1.0,
]

function createPlaneData(wdetail::Integer, hdetail::Integer)
	texture_scale = true

	W = wdetail < 1 ? 1 : wdetail
	H = hdetail < 1 ? 1 : hdetail

	MW = W + 1
	MH = H + 1

	dW = 1.f0 / W
	dH = 1.f0 / H

	s = false

	vertices=Vec3f[]
	normals=Vec3f[]
	uvs=Vec2f[]
	indicies=UInt32[]

	for h=0:H
		hs = H - h - 1
		V = h * dH

		for w=0:W
			ws = W - w - 1
			U = w * dW

			v = Vec3f(-1 + U * 2, -1 + V * 2, 0) # vec3(-cos(theta) * sin(phi),-cos(phi),0);
			uv = texture_scale ? Vec2f(V, U) : Vec2f(h, w)

			push!(vertices, v)
			push!(normals, Vec3f(0,0,1))
			push!(uvs, MatrixMath.rotate(uv - Vec2f(1,0), 3.14f0*-0.5f0))

			if h < H && w < W
				if !s
					push!(indicies, w + (hs + 1) * MW) # top left
					push!(indicies, w + hs * MW) # left
					push!(indicies, w + 1 + (hs + 1) * MW) # top right
					push!(indicies, w + 1 + hs * MW) # right
				else
					push!(indicies, ws + 1 + (hs + 1) * MW) # top right
					push!(indicies, ws + 1 + hs * MW) # right
					push!(indicies, ws + (hs + 1) * MW) # top left
					push!(indicies, ws + hs * MW) # left
				end

				#push!(indicies, w + h * MW); # left
				#push!(indicies, w + 1 + h * MW) # right
				#push!(indicies, w + (h + 1) * MW) # top left
				#push!(indicies, w + 1 + (h + 1) * MW) # top right
				#push!(indicies, w + (h + 1) * MW) # top left
				#push!(indicies, w + 1 + h * MW) # right
			end
		end

		if h < H
			if !s push!(indicies, W + hs * MW) #top right
			else push!(indicies, hs * MW) # top left
			end
			s = !s
		end
	end

	(:TRIANGLE_STRIP, vertices, normals, uvs, indicies)
end

function createCubeDataSimple()
	const vd = Vec3f[
		Vec3f(-1, -1, 0),
		Vec3f(1, -1, 0),
		Vec3f(1, 1, 0),
		Vec3f(1, 1, 0),
		Vec3f(-1, 1, 0),
		Vec3f(-1, -1, 0),

		Vec3f(-1, -1, 0),
		Vec3f(1, -1, 0),
		Vec3f(-1, 1, 0),
		Vec3f(1, -1, 0),
		Vec3f(1, 1, 0),
		Vec3f(-1, 1, 0),
	]

	len = length(vd)
	vertices=zeros(Vec3f, len)
	normals=zeros(Vec3f, 0)
	uvs=zeros(Vec2f, 0)
	indicies=zeros(UInt32, 0)

	i=0
	for v in vd; i+=1; vertices[i]=v end
	#for v in vd; i+=1; vertices[i]=v end

	(:TRIANGLES, vertices, normals, uvs, indicies)
end

function createCubeData()
		v = [
			Vec3f(-1, -1, -1), Vec3f(1, -1, -1), Vec3f(-1, 1, -1), Vec3f(1, 1, -1),
			Vec3f(-1, -1, 1), Vec3f(1, -1, 1), Vec3f(-1, 1, 1), Vec3f(1, 1, 1)
		]

		n = zeros(Vec3f, 8)
		for ni=1:length(n) n[ni] = normalize(v[ni]) end

		uv = [ Vec2f(0, 1), Vec2f(1, 1), Vec2f(0, 0), Vec2f(1, 0)	]

		const i = UInt32[
			0, 1, 2, 3, # back (0, 1, 2, 3)
			4, 5, 6, 7, # front (4, 5, 6, 7)
			0, 4, 2, 6, # left (8, 9, 10, 11)
			1, 5, 3, 7, # right (12, 13, 14, 15)
			0, 1, 4, 5, # bottom (16, 17, 18, 19)
			2, 3, 6, 7  # top (20, 21, 22, 23)
		]

		const u = UInt32[
			0, 1, 2, 3, # back (0, 1, 2, 3)
			0, 1, 2, 3, # front (4, 5, 6, 7)
			0, 1, 2, 3, # left (8, 9, 10, 11)
			0, 1, 2, 3, # right (12, 13, 14, 15)
			0, 1, 2, 3, # bottom (16, 17, 18, 19)
			0, 1, 2, 3  # top (20, 21, 22, 23)
		]

		const C = UInt32[ #36
			0 + 1, 0 + 0, 0 + 2, 0 + 2, 0 + 3, 0 + 1, # back (1, 0, 2, 2, 3, 1)
			4 + 0, 4 + 1, 4 + 3, 4 + 3, 4 + 2, 4 + 0, # front (4, 5, 7, 7, 6, 4)
			8 + 0, 5 + 4, 9 + 2, 9 + 2, 8 + 2, 8 + 0, # left (0, 4, 6, 6, 2, 0)
			12 + 1, 12 + 0, 12 + 2, 12 + 2, 12 + 3, 12 + 1, # right (5, 1, 3, 3, 7, 5)
			16 + 0, 16 + 1, 16 + 3, 16 + 3, 16 + 2, 16 + 0, # bottom (0, 1, 5, 5, 4, 0)
			20 + 1, 20 + 0, 20 + 2, 20 + 2, 20 + 3, 20 + 1 # top (3, 2, 6, 6, 7, 3)
		]

		const C2 = UInt32[ 	#35
			17, 19, 16, 18,		# bottom
			9, 11, 8, 10,			# left
			20, 0,						# skip
			0, 2, 1, 3,				# back
			14, 2,						# skip
			20, 22, 21, 23,		# top
			15, 13, 14, 12,		# right
			1, 5,							# skip
			5, 7, 4, 6,				# front
		]

		Ilen=length(i)
		Clen=length(C)

		vertices=zeros(Vec3f, Ilen)
		normals=zeros(Vec3f, Ilen)
		uvs=zeros(Vec2f, Ilen)
		indicies=zeros(UInt32, Clen)

		uvi = UInt32(0)
		for vi = 1:Ilen
			uvi+=1
			if uvi>3 uvi = 0 end
			index = i[vi] + 1

			vertices[vi] = v[index] + 1
			normals[vi] = n[index] + 1
			uvs[vi] = uv[u[vi] + 1] + 1
		end

		#uvi = UInt32(0)
		for vi=1:Clen
			#uvi+=1
			indicies[vi] = C[vi] + 1 #index
		end

		#shape->setType(DRAWS::draw_TRIANGLE_STRIP);
		(:TRIANGLE_STRIP, vertices, normals, uvs, indicies)
end

#=
createCubeData2(wdetail::Integer, hdetail::Integer)
	clearVAO();
	_uint_ index_count = 36; // 14

	if (index_count == 14) shape->setType(DRAWS::draw_TRIANGLE_STRIP);
	#else shape->setType(DRAWS::draw_TRIANGLES);

	_uint W = 1; // wdetail < 1 ? 1 : wdetail;
	_uint H = 1; //hdetail < 1 ? 1 : hdetail;
	_uint L = 1;

	_float dW = 1.f / W;
	_float dH = 1.f / H;
	_float dL = 1.f / L;

	_uint MW = W + 1;
	_uint MH = H + 1;
	_uint ML = L + 1;

	_int neg = 0;

	for (_uint d = 0; d < ML; ++d)
	{
		_float D = d * dL;
		++neg;

		for (_uint h = 0; h < MH; ++h)
		{
			_float V = h * dH;

			for (_uint w = 0; w < MW; ++w)
			{
				_float U = w * dW;

				_float x = -1 + U * 2;
				_float y = -1 + V * 2;
				_float z = -1 + D * 2;

				vec3 v = vec3(x, y, z);
				vec3 n = glm::normalize(v);
				vec2 uv = vec2(sin(U), V);

				shape->addPosition(v);
				shape->addNormal(n);
				shape->addTexcoord(uv);
			}
		}
	}

	_uint_* arr = NULL;

	if (index_count == 36)
	{
		_uint_ C[36] =
		{
			4, 5, 7, 7, 6, 4, // front side
			1, 0, 2, 2, 3, 1, // back side
			0, 4, 6, 6, 2, 0, // left side
			5, 1, 3, 3, 7, 5, // right side
			0, 1, 5, 5, 4, 0, // down side
			3, 2, 6, 6, 7, 3  // up side
		};

		arr = C;
	}
	else if (index_count == 14)
	{
		_uint_ C[14] =
		{
			1, 5, 0, 4, 6, 5, 7,
			3, 6, 2, 0, 3, 1, 5
		};

		arr = C;
	}

	_uint MWH = MW * MH;
	_uint x = 0; _uint y = 0; _uint z = 0;

	for (; z < L; ++z)
	{
		_uint b = (z + 0) * MWH; _uint f = (z + 1) * MWH;

		for (y = 0; y < H; ++y)
		{
			_uint d = (y + 0) * MW; _uint u = (y + 1) * MW;
			_uint db = d + b; _uint ub = u + b;
			_uint df = d + f; _uint uf = u + f;

			for (x = 0; x < W; ++x)
			{
				_uint l = (x + 0); _uint r = (x + 1);

				_uint ldb = l + db; _uint lub = l + ub; _uint ldf = l + df; _uint luf = l + uf;
				_uint rdb = r + db; _uint rub = r + ub; _uint rdf = r + df;  _uint ruf = r + uf;

				_uint I[8] = { ldb, rdb, lub, rub, ldf, rdf, luf, ruf };

				if (arr) for (_uint i = 0; i < index_count; ++i)
					shape->addIndex(I[arr[i]]);
			}
		}
	}
end

createTerrain(wdetail::Integer, hdetail::Integer)
	clearVAO();

	#srand(static_cast<unsigned int>(time(0))); # initialize random seed:

#	for (_uint i = 0; i < 60; ++i)
#		for (_uint j = 0; j < 60; ++j)
#			_float v1 = (_float)((sin((random(1000))*3.14f)));
#			_float v2 = (_float)((sin((random(1000))*3.14f)));
#			//_DEBUG_MESSAGE("Radom Numbers: %f, %f", v1, v2);
#			Gradient[i][j][0] = v1;
#			Gradient[i][j][1] = v2;
#		end
#	end

	generateTerrain();

	_uint W = wdetail < 1 ? 1 : wdetail;
	_uint H = hdetail < 1 ? 1 : hdetail;

	_float dW = 1.f / W;
	_float dH = 1.f / H;

	_uint MW = W + 1;
	_uint MH = H + 1;

	for (_uint h = 0; h < MH; ++h)
		_float V = h * dH;

		for (_uint w = 0; w < MW; ++w)
			_float U = w * dW;

			_float x = -1 + U * 2; // -cos(theta) * sin(phi);
			_float y = -1 + V * 2; // -cos(phi);

			vec3 v(x, y, terrain[w][h]);

			shape->addPosition(v);
			shape->addNormal(glm::normalize(v));
			shape->addTexcoord(glm::rotate(vec2(V, U), 3.14f*-.5f));

			if (h < H && w < W)
				shape->addIndex(w + h * MW);
				shape->addIndex(w + 1 + h * MW);
				shape->addIndex(w + (h + 1) * MW);
				shape->addIndex(w + 1 + (h + 1) * MW);
			end
		end
	end
end
=#

function addTriangle(list::Dict{Symbol,Any}, id::Integer, index::Integer, v::Vec3f)
	ids = list[:IDS]
	position = list[:VERTICES]
	normal = list[:NORMALS]
	texcoord = list[:UVS]

	position[ids[1]] = v
	ids[1]+=1

	n = normalize(v)

	normal[ids[2]] = n
	ids[2]+=1

	x = 1 + n[1]
	z = 1 + n[3]

	if z < 1 x = 4 + -x end
	#if ids[4] < x ids[4] = x end
	#if !(x < 0 && z < 0) x = z = 2 end

	#n2 = normalize(uid * 0.5f0)
	#if z > .5f x = mx end

	texcoord[ids[3]] = Vec2f(x * 0.25f0, 0.5f0 + n[2] * -0.5f0)
	ids[3]+=1
end

function addTriangle(list::Dict{Symbol,Any}, id::Integer, v::Array{Vec3f,1})
	for i=1:length(v) addTriangle(list, id, i, v[i]) end
end

function subdivide(list::Dict{Symbol,Any}, id::Integer, depth::Integer, v::Array{Vec3f,1})
	if depth <= 0
		addTriangle(list, id, v)
		return
	end

	v1 = v[1]
	v2 = v[2]
	v3 = v[3]

	v12 =  normalize(v1 + v2)
	v23 =  normalize(v2 + v3)
	v31 =  normalize(v3 + v1)

	#matrix 3x4 vec3f
	vs = [
		[v1, v12, v31],
		[v2, v23, v12],
		[v3, v31, v23],
		[v12, v23, v31]
	]

	#index=1+(i-1) * 3
	#vs = [v1,v2,v3,v12]

	depth = depth - 1

	for i=1:length(vs)
		subdivide(list, id, depth, vs[i])
	end
end

function computeVAO(list::Dict{Symbol,Any}, sides::Integer, depth::Integer, points::Array{Vec3f,1}, indices::Array{Vec3u,1})
	if depth>8
		error("VAO depth should not be larger than 8! Computer will freeze!")
		return
	end

	# Compute and store vertices
	numVertices = sides * 3 #/ sides *  points for one vertex
	VAOSize = numVertices * 3 * Integer(4^depth) # *(x,y,z)

	println("size: $sides*3=$numVertices*3=$(numVertices*3)*4^$depth=$VAOSize")

	list[:IDS] = [1,1,1,0]
	list[:VERTICES] = fill(zeros(Vec3f),VAOSize)
	list[:NORMALS] = fill(zeros(Vec3f),VAOSize)
	list[:UVS] = fill(zeros(Vec2f),VAOSize)
	#list[:INDICIES] = fill(UInt32(0),(numP - 1) * (numSides + 1) * 6)

	for i=1:sides
		vs = [ points[1+indices[i][1]], points[1+indices[i][2]], points[1+indices[i][3]] ]
		subdivide(list, i, depth, vs)
	end
end

function createTetrahedronSphere(depth::Integer)
	X = 0.525731112119133606f0; # sin(inc * 6.362117953f0); // 0.61803399f0,0.6662394341f0,6.362117953f0
	Z = 0.850650808352039932f0; # 1.61803399f0; // cos(0.0f0);

	list = Dict{Symbol,Any}()

	points = [
		Vec3f(X, 0, -Z), Vec3f(-X, 0, -Z), Vec3f(X, 0, Z), Vec3f(-X, 0, Z),
		Vec3f(0, -Z, -X), Vec3f(0, -Z, X), Vec3f(0, Z, -X), Vec3f(0, Z, X),
		Vec3f(-Z, -X, 0), Vec3f(Z, -X, 0), Vec3f(-Z, X, 0), Vec3f(Z, X, 0),
	]

	indices = [
		Vec3u(0, 4, 1), Vec3u(0, 9, 4), Vec3u(9, 5, 4), Vec3u(4, 5, 8), Vec3u(4, 8, 1),
		Vec3u(8, 10, 1), Vec3u(8, 3, 10), Vec3u(5, 3, 8), Vec3u(5, 2, 3), Vec3u(2, 7, 3),
		Vec3u(7, 10, 3), Vec3u(7, 6, 10), Vec3u(7, 11, 6), Vec3u(11, 0, 6), Vec3u(0, 1, 6),
		Vec3u(6, 1, 10), Vec3u(9, 0, 11), Vec3u(9, 11, 2), Vec3u(9, 2, 5), Vec3u(7, 2, 11)
	]

	computeVAO(list, 20, depth, points, indices)

	#(:TRIANGLES, list[:VERTICES], list[:NORMALS], list[:UVS], UInt32[])
	(:TRIANGLES, list[:VERTICES], [], [], [])
end
