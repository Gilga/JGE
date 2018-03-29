include("MeshData.jl")
include("MeshLoader_OBJ.jl")

function createMesh(this::Model, id::Symbol)
	if !haskey(this.meshes, id)
		mesh = MeshManager.Mesh()
		this.meshes[id]=mesh
	else
		mesh=this.meshes[id]
	end
	mesh
end

function addMesh(this::Model, typ::Symbol)
	mesh=createMesh(this, :DEFAULT)
	if MeshManager.isEmpty(mesh)
		update(mesh, typ, this.source.path)
	end
	upload(this)
	mesh
end

function update(mesh::Mesh, typ::Symbol, path::String)
	if typ == :PLANE
		MeshManager.update(mesh, typ, MeshDataPlaneQuad)
	elseif typ == :CUBE
		MeshManager.update(mesh, typ, MeshDataCube, 5)
	elseif typ == :CUBE2
		MeshManager.update(mesh,typ, createCubeDataTest)
	elseif typ == :IPLANE
		MeshManager.update(mesh, typ, ()->createPlaneData(5,5))
	elseif typ == :ICOSPHERE
		MeshManager.update(mesh, typ, ()->createTetrahedronSphere(1))
	elseif typ == :MODEL
		if !loadOBJ(path, mesh)	warn(string("Failed loading mesh file ", path))	end
	end
end

function prepare(this::Model, mesh::Mesh)
	vlen=length(mesh.vertices.data.values)
	uvlen=length(mesh.uvs.data.values)
	nlen=length(mesh.normals.data.values)
	ilen=length(mesh.indicies.data.values)

	if vlen>0 || uvlen>0 || nlen>0
		va=StorageManager.create(this.group, :VA, :BLOCK, :ARRAY_BLOCK)
		vao=StorageManager.create(va, :VAO, :STORAGE, :ARRAY)

		vb=StorageManager.create(this.group, :VB, :BLOCK, :BUFFER_BLOCK)
		vbo=StorageManager.create(vb, :VBO, :STORAGE, :ARRAY_BUFFER)

		if vlen>0	StorageManager.link(vbo, mesh.vertices, :VERTEX) end
		if uvlen>0 StorageManager.link(vbo, mesh.uvs, :UV) end
		if nlen>0	StorageManager.link(vbo, mesh.normals, :NORMAL)	end
		if ilen==0 setMainBuffer(this,vbo) end
	end

	if ilen>0
		ib=StorageManager.create(this.group, :IB, :BLOCK, :INDEX_BLOCK)
		ibo=StorageManager.create(ib, :IBO, :STORAGE, :ELEMENT_ARRAY_BUFFER)
		StorageManager.link(ibo, mesh.indicies, :INDEX)
		setMainBuffer(this,ibo)
	end
end
