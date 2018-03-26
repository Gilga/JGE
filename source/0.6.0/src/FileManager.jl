module FileManager

using FileIO
#using SignalManager
using Reactive

export FileSource
export FileSourcePart
export splitFileName
export fileGetContents
export readFileSource
export watchFileUpdate
export registerFileUpdate
export runOnFileUpdate

type FileSource
  path  ::String
	cache ::String
	
  FileSource(path="") = new(path,"")
end

type FileSourcePart
	source ::FileSource
  range  ::UnitRange{Int64}
	cache ::String
	
	FileSourcePart(source::FileSource,range=range(1,stat(source.path).size)) = new(source,range,"")
end

type FileUpdateEntry
  source::FileSource
  OnUpdate::Function
	args::Tuple
	editedTime::Float64

  FileUpdateEntry(source::FileSource, OnUpdate::Function, args) = new(source, OnUpdate, args, 0)
end

function getCache(source::FileSource)
	if source.cache == ""
		reload(source)
	end
	source.cache
end

reload(source::FileSource) = (source.cache=fileGetContents(source.path))

FILES_TO_UPDATE = Dict{String, FileUpdateEntry}()

readFileSource(path::String) = FileSource(path,fileGetContents(path))

function splitFileName(path::String)
  (dir, filename) = splitdir(path) #splitdrive
  (name, ext) = splitext(filename)
  (addDirSlash(dir),name,ext)
end

function waitForFileReady(path::String, func::Function, tryCount=100, tryWait=0.1)
	result=false
	for i = 1:tryCount

		#try reading file
		if stat(path).size > 0
			open(path) do file
				 result=func(file)
			end
			if result break end
		end

		Libc.systemsleep(tryWait) #wait
	end
	result
end

function fileGetContents(path::String, tryCount=100, tryWait=0.1)
	content=nothing
	waitForFileReady(path,(x)->(content=readstring(x); content != nothing),tryCount,tryWait)
	content
end

addDirSlash(path::String) = string(path,(path != "" && path[length(path)] != '/') ? "/" : "")

registerFileUpdate(source::FileSource, OnUpdate::Function, args...) = FILES_TO_UPDATE[source.path]=FileUpdateEntry(source,OnUpdate,(source, args...))
unregisterFileUpdate(source::FileSource) = delete!(FILES_TO_UPDATE, source.path)

runOnFileUpdate(threshold=0.01) = for (key,entry) in FILES_TO_UPDATE
	time_edited = mtime(entry.source.path)
	edited = time_edited - entry.editedTime
	#if edited!=0
	#println(entry.source.path,": ",time_edited)
	#end
	if edited > threshold  #!isapprox(0.0, entry.editedTime - time_edited)
		#println("Time: ", entry.editedTime, " == ", time_edited)
		entry.OnUpdate(entry.args...)
		entry.editedTime=time_edited
	end
end

#reads from the file and updates the source whenever the file gets edited
function watchFileUpdate(path::String, OnUpdate::Function)
  preserve(map( isUpdated(query(path)) ) do _unused OnUpdate(path) end)
  #map( isUpdated(query(path))) do _unused OnUpdate(path) end
end

watchFileUpdate(path::FileSource, OnUpdate::Function) = watchFileUpdate(o.path, OnUpdate)

function isUpdated(file::File, tickrate=0.001)
  fn = filename(file)
  ticks=fpswhen(Signal(true), 1.0/tickrate)
  file_edited=foldp((false, mtime(fn)), ticks) do v0, v1
    time_edited = mtime(fn)
    (!isapprox(0.0, v0[2] - time_edited), time_edited)
  end
  filter(identity, true, map(first, file_edited))
end

end # FileManager
