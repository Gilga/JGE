module MeshManager

using CoreExtended
using FileManager

using ..StorageManager

""" TODO """
type Mesh
	typ::Symbol
	vertices::StorageGroup
	normals::StorageGroup
	uvs::StorageGroup
	indicies::StorageGroup

	function Mesh()
		this=new(:_)
		clear(this)
	end
end

""" TODO """
function clear(mesh::Mesh)
	mesh.vertices = StorageManager.StorageGroup(:DATA, :VERTEX)
	mesh.uvs = StorageManager.StorageGroup(:DATA, :UV)
	mesh.normals = StorageManager.StorageGroup(:DATA, :NORMAL)
	mesh.indicies = StorageManager.StorageGroup(:DATA, :INDEX)
	mesh
end

# preset for manager: includes code here
presetManager(Mesh)

""" TODO """
isEmpty(mesh::Mesh) = isEmptyVertices(mesh) && isEmptyUVs(mesh) && isEmptyNormals(mesh) && isEmptyIndicies(mesh)

""" TODO """
isEmptyVertices(mesh::Mesh) = length(mesh.vertices.data.values) == 0

""" TODO """
isEmptyUVs(mesh::Mesh) = length(mesh.uvs.data.values) == 0

""" TODO """
isEmptyNormals(mesh::Mesh) = length(mesh.normals.data.values) == 0

""" TODO """
isEmptyIndicies(mesh::Mesh) = length(mesh.indicies.data.values) == 0

#MeshManager.addPosition(mesh::Mesh, Vec3f pos)
#MeshManager.addNormal(mesh::Mesh, Vec3f pos)
#MeshManager.addUV(mesh::Mesh, Vec2f pos)
#MeshManager.addIndex(mesh::Mesh, Vec3f pos)

""" TODO """
function update(mesh::Mesh, typ::Symbol, values::AbstractArray, elems=0)
	mesh.typ = typ
	if length(values)>0	StorageManager.setValues(mesh.vertices, values, elems, :TRIANGLES) end
	mesh
end

""" TODO """
function update(mesh::Mesh, typ::Symbol, f::Function)
	data = f()
	mesh.typ = typ

	drawtyp	= data[1]
	vertices = data[2]
	normals	= data[3]
	uvs = data[4]
	indicies = data[5]

	if length(vertices)>0 StorageManager.setValues(mesh.vertices, vertices, 3, drawtyp) end
	if length(uvs)>0 StorageManager.setValues(mesh.uvs, uvs, 2, drawtyp) end
	if length(normals)>0 StorageManager.setValues(mesh.normals, normals, 3, drawtyp) end
	if length(indicies)>0	StorageManager.setValues(mesh.indicies, indicies, 1, drawtyp)	end

	mesh
end

end #MeshManager
