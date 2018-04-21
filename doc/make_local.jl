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
  build     = joinpath(@__DIR__, "../docs"),
  modules   = [App],
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
  #=
  pages = Any[ # Compat: `Any` for 0.4 compat
      "Home" => "index.md",
      "Manual" => Any[
          "manual/install.md",
          "manual/start.md",
          "manual/szene.md",
          "manual/algorithm.md",
          "manual/build.md",
          "manual/optimization.md",
          "manual/references.md",
      ],
      "Source Files" => Any[
          "files/JuliaOpenGL.md",
          "files/build.md",
          "files/camera.md",
          "files/chunk.md",
          "files/compileAndLink.md",
          "files/cubeData.md",
          "files/frustum.md",
          "files/lib_math.md",
          "files/lib_opengl.md",
          "files/lib_time.md",
          "files/lib_window.md",
          "files/libs.md",
          "files/matrix.md",
          "files/shader.md",
          "files/test.md",
          "files/texture.md",
          "files/vector.md",
      ],
  ],
  =#
)

deploydocs(
  deps   = Deps.pip("mkdocs", "python-markdown-math"), #, "curl"
  repo = "https://github.com/Gilga/JGE.git",
  branch = "gh-pages",
  julia  = "0.6.2",
)

info("Docs done.")