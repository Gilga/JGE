push!(LOAD_PATH,"../source/0.6/src/")

# install packages
info("Install Packages...")
Pkg.init()
cp(joinpath(@__DIR__, "REQUIRE"), Pkg.dir("REQUIRE"); remove_destination = true)
Pkg.update()
Pkg.resolve()
info("Packages done.")

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
  html_prettyurls = true,
  #html_canonical = "https://gilga.github.io/JGE/",
)

deploydocs(
  deps   = Deps.pip("mkdocs", "python-markdown-math"), #, "curl"
  repo = "https://github.com/Gilga/JGE.git",
  branch = "gh-pages",
  julia  = "0.6.2",
)

info("Docs done.")