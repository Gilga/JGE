module RessourceManager

export PATHS

export SetWorkingDir
export AddPath
export GetPath
export RessourcePath
export CurrentDay

PATHS = Dict{Any,Any}(:ROOT => "")

SetWorkingDir() = (PATHS[:ROOT] = string(dirname(Base.source_path()),"/"))
RessourcePath(path::AbstractString) = (!in(':',path) ? path = string(PATHS[:ROOT], path, path[length(path)] != '/' ? "/" : "") : path)
AddPath(id::Any, path::AbstractString) = PATHS[id] = RessourcePath(path)
GetPath(key::Any) = PATHS[haskey(PATHS, key) ? key : :ROOT]
CurrentDay() = replace(replace(string(Dates.now()),":","-"),"T","_")

SetWorkingDir()
end # RessourceManager
