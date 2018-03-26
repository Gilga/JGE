#ENV["JULIA_NUM_THREADS"] = "4"
#julia = joinpath(JULIA_HOME, "julia")
#start = abspath(dirname(@__FILE__),"includes.jl")
#run(`$julia $start`)

#include("App-0.6.1/main.jl")
include("test/example_gl.jl")
#include("test/macro.jl")
#include("test/threads.jl")
#include("test/tasks.jl")

#App.watchFileUpdate("C:/Users/Mario/Desktop/Desktop/vulian/shaders/frag.glsl", (file::AbstractString) -> (println("watchFileUpdate: ", file)))
#println(Base.LOAD_CACHE_PATH[1])
#RessourceManager.SetWorkingDir()
#App.watchFileUpdate("C:/Users/Mario/Desktop/Desktop/vulian/shaders/frag.glsl", (file::AbstractString) -> (println("OnUpdate: ", file)))
#App.watchFileUpdate("C:/Users/Mario/Desktop/Desktop/vulian/shaders/vert.glsl", (file::AbstractString) -> (println("OnUpdate: ", file)))
#App.checkFilesUpdate()
#loop()

