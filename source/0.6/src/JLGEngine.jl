include("CoreExtended.jl")
include("TimeManager.jl")
include("LoggerManager.jl")

include("RessourceManager.jl")
include("FileManager.jl")
include("Environment.jl")
include("JLScriptManager.jl")
include("WindowManager.jl")

include("MatrixMath.jl")

""" TODO """
module JLGEngine

const ENGINE = JLGEngine

using CoreExtended

dir="JLGEngine/"

#=
dir=dirname(Base.@__FILE__)*"/JLGEngine/"

# search
searchdir(path,key) = filter(x->contains(x,key), readdir(path))
print("search:"); @time fileNames=searchdir(dir,".jl")

# sort
order=createSortedDict(Integer,Array{String,1})
print("sort:"); @time for fileName in fileNames
    path=dir*fileName
    #println("found(\"$fileName\")")
	open(path) do file
		content=readstring(file)
        id=1
         for x in eachmatch(r"using\s+(\w+)\.(\w+)", content)
             #f=x.captures[1]
             #order[id]=f
             #println(x.captures[2])
             id+=1
         end
         if haskey(order,id) push!(order[id],fileName) else order[id]=[fileName] end
	end
    println("-------------------")
    #include(path);
end

println("D: $order")

# include
ex=:()
print("prepare:"); @time for (_,a) in order
    for fileName in a
        println("include(\"$fileName\")")
        ex=:($(ex.args...); include($(dir*fileName)))
        #include(dir*fileName)
    end
end

print("include"); @time eval(ex)
println("---------------");
=#

""" TODO """
abstract type IComponent end

include(dir*"GraphicsManager.jl")
include(dir*"LibGL/LibGL.jl")

include(dir*"Management.jl")
include(dir*"StorageManager.jl")
include(dir*"MeshManager.jl")
include(dir*"ModelManager.jl")
include(dir*"ShaderManager.jl")
include(dir*"TransformManager.jl")
include(dir*"EntityManager.jl")
include(dir*"CameraManager.jl")
include(dir*"TextureManager.jl")
include(dir*"GameObjectManager.jl")
include(dir*"RenderManager.jl")

using .GraphicsManager

# set api references
""" TODO """
function init()
    GraphicsManager.setGraphicsDriver(LibGL)
    ShaderManager.init()
    StorageManager.init()
		TextureManager.init()
end

end #JLGEngine
