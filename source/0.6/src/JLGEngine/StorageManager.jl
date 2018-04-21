module StorageManager

export StorageGroup

using ..GraphicsManager

API = nothing

""" TODO """
type StorageGroup
	id::Symbol
	data::AbstractGraphicsData
	list::ObjectIdDict #Dict{Symbol,StorageGroup}
	StorageGroup() = new(:_, nothing, ObjectIdDict())
	StorageGroup(typ::Symbol, subtyp::Symbol,id=:_) = new(id, API.create(typ,subtyp),ObjectIdDict())
end

""" TODO """
function init()
	global API = GRAPHICSDRIVER().StorageManager
end

""" TODO """
function create(this::StorageGroup, id::Symbol, typ::Symbol, subtyp::Symbol)
	println("Create $id $typ $subtyp")
	haskey(this.list, id) ? this.list[id] : this.list[id]=StorageGroup(typ, subtyp, id)
end

""" TODO """
link(this::StorageGroup, child::StorageGroup, id::Symbol) = (child.id=id;this.list[id]=child)

""" TODO """
clean(this::StorageGroup) = API.clean(this.data)

""" TODO """
getGroup(this::StorageGroup, id::Symbol) = haskey(this.list, id) ? this.list[id] : nothing

""" TODO """
getData(this::StorageGroup, id::Symbol) = haskey(this.list, id) ? this.list[id].data : nothing
function getData(this::StorageGroup, id::Integer)
	c=collect(keys(this.list))
	v=length(c)>=id ? get(this.list,c[id],nothing) : nothing
	if v != nothing v=v.data end
	v
end

""" TODO """
getValues(this::StorageGroup) = API.getValues(this.data)

""" TODO """
setValues(this::StorageGroup, values::AbstractArray, elems::Integer, mode=:TRIANGLES) = API.setValues(this.data, values, elems, mode)

""" TODO """
function link(this::StorageGroup, on=true)
	for (k,block) in this.list
		for (k,storage) in block.list
			link(block, storage, on)
		end
	end
end

""" TODO """
link(block::StorageGroup, storage::StorageGroup, on=true) = API.bind(block.data,storage.data,on)

""" TODO """
upload(block::StorageGroup, storage::StorageGroup, data::StorageGroup) = API.upload(block.data, storage.data, data.data)

""" TODO """
function upload(this::StorageGroup)
	uploads=[]
	for (kb,block) in this.list
		API.prepare(block.data)
		for (ks,storage) in block.list
			API.prepare(block.data, storage.data)
			for (kd,data) in storage.list
				API.prepare(block.data, storage.data, data.data)
				push!(uploads,[block.data, storage.data, data.data])
			end
		end
		API.init(block.data)
	end

	API.upload(uploads)
end

end #StorageManager
