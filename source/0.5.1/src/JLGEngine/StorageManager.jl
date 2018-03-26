module StorageManager

export StorageGroup

using ..GraphicsManager

API = nothing

type StorageGroup
	id::Symbol
	data::AbstractGraphicsData
	list::Dict{Symbol,StorageGroup}
	StorageGroup() = new(:_, nothing, Dict())
	StorageGroup(typ::Symbol, subtyp::Symbol,id=:_) = new(id, API.create(typ,subtyp),Dict())
end

function init()
	global API = GRAPHICSDRIVER().StorageManager
end

create(this::StorageGroup, id::Symbol, typ::Symbol, subtyp::Symbol) = haskey(this.list, id) ? this.list[id] : this.list[id]=StorageGroup(typ, subtyp, id)
link(this::StorageGroup, child::StorageGroup, id::Symbol) = (child.id=id;this.list[id]=child)

clean(this::StorageGroup) = API.clean(this.data)

getGroup(this::StorageGroup, id::Symbol) = haskey(this.list, id) ? this.list[id] : nothing

getData(this::StorageGroup, id::Symbol) = haskey(this.list, id) ? this.list[id].data : nothing
function getData(this::StorageGroup, id::Integer)
	c=collect(keys(this.list))
	v=length(c)>=id ? get(this.list,c[id],nothing) : nothing
	if v != nothing v=v.data end
	v
end

getValues(this::StorageGroup) = API.getValues(this.data)
setValues(this::StorageGroup, values::AbstractArray, elems::Integer, mode=:TRIANGLES) = API.setValues(this.data, values, elems, mode)

function link(this::StorageGroup, on=true)
	for (k,block) in this.list
		for (k,storage) in block.list
			link(block, storage, on)
		end
	end
end

link(block::StorageGroup, storage::StorageGroup, on=true) = API.bind(block.data,storage.data,on)

upload(block::StorageGroup, storage::StorageGroup, data::StorageGroup) = API.upload(block.data, storage.data, data.data)

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
