type Object
	enabled::Bool
	obj::Any
end

type Group
	enabled::Bool
	objs::Dict{Symbol,Any}
end


# compiled after start, for faster loop?
#RenderProcess()
