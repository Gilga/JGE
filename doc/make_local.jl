push!(LOAD_PATH,"../source/0.6/src/")

# include package
info("Include all...")
try
  include("../source/0.6/src/App.jl")
catch e # do not exit this run!
  warn(e)
end
info("Include done.")

info("Create Docs...")
using Documenter, App

makedocs(
  build     = joinpath(@__DIR__, "../build/docs"),
  modules   = [CoreExtended,TimeManager,LoggerManager,RessourceManager,FileManager,Environment,JLScriptManager,WindowManager,MatrixMath,JLGEngine,App],
  clean     = true,
  doctest   = true, # :fix
  #linkcheck = true,
  strict    = false,
  checkdocs = :none,
  format    = :html, #:latex 
  sitename  = "JGE",
  authors   = "Gilga",
  #analytics = "UA-89508993-1",
  #html_prettyurls = true,
  #html_canonical = "https://gilga.github.io/JGE/",

  pages = Any[ # Compat: `Any` for 0.4 compat
      "Home" => "index.md",
      "Manual" => Any[
          "manual/start.md",
      ],
      "Source Files" => Any[
          "files/App.md",
          "files/CoreExtended.md",
          "files/Environment.md",
          "files/FileManager.md",
          "files/JLScriptManager.md",
          "files/LoggerManager.md",
          "files/MatrixMath.md",
          "files/RessourceManager.md",
          "files/ThreadFunctions.md",
          "files/ThreadManager.md",
          "files/TimeManager.md",
          "files/WindowManager.md",
          "files/JLGEngine.md",
          "files/JLGEngine/CameraManager.md",
          "files/JLGEngine/ChunkManager.md",
          "files/JLGEngine/EntityManager.md",
          "files/JLGEngine/GameObjectManager.md",
          "files/JLGEngine/GraphicsManager.md",
          "files/JLGEngine/Management.md",
          "files/JLGEngine/MeshManager.md",
          "files/JLGEngine/ModelManager.md",
          "files/JLGEngine/RenderManager.md",
          "files/JLGEngine/ShaderManager.md",
          "files/JLGEngine/StorageManager.md",
          "files/JLGEngine/SzeneManager.md",
          "files/JLGEngine/TextureManager.md",
          "files/JLGEngine/TransformManager.md",
          "files/JLGEngine/ModelManager/MeshData.md",
          "files/JLGEngine/ModelManager/MeshFabric.md",
          "files/JLGEngine/ModelManager/MeshLoader_OBJ.md",
          "files/JLGEngine/LibGL/LibGL.md",
          "files/JLGEngine/LibGL/GLDebugControl.md",
          "files/JLGEngine/LibGL/GLExtendedFunctions.md",
          "files/JLGEngine/LibGL/GLLists.md",
          "files/JLGEngine/LibGL/GLSLParser.md",
          "files/JLGEngine/LibGL/GLSLRessources.md",
          "files/JLGEngine/LibGL/ShaderManager.md",
          "files/JLGEngine/LibGL/StorageManager.md",
          "files/JLGEngine/LibGL/TextureManager.md",
      ],
  ],
)

deploydocs(
  deps   = Deps.pip("mkdocs", "python-markdown-math"), #, "curl"
  repo = "https://github.com/Gilga/JGE.git",
  branch = "gh-pages",
  julia  = "0.6.2",
)

info("Docs done.")