l=length(ARGS)

buildscript="BuildExecutable/src/build_executable.jl"

default_version=string(VERSION)

i=1
version=l<i?default_version:ARGS[i];i+=1
name=l<i?"app":ARGS[i];i+=1
tdir=l<i?"build":ARGS[i];i+=1
sdir=l<i?"source":ARGS[i];i+=1
script=l<i?"main.jl":ARGS[i];i+=1

debug = false
julia = replace(abspath(joinpath(JULIA_HOME, debug ? "julia-debug" : "julia")), default_version,version)

path = replace(dirname(Base.source_path()),"\\","/")

targetdir_build=joinpath(path,tdir)
targetdir_version=joinpath(targetdir_build,version)
targetdir_project=joinpath(targetdir_version,name)
targetdir = targetdir_project

sourcedir=replace(version,r"[.][0-9]+$","")
sourcescript=joinpath(path,"$sdir/$sourcedir/",script)
buildscriptpath=buildscript

## -------------------------------------------------------------------------------

if !isfile(julia * (is_windows() ? ".exe" : "")) error("'$julia' not found.") end

# find buildscript...
if !isfile(buildscriptpath)
  buildscriptpath=joinpath(path,buildscript)
  if !isfile(buildscriptpath)
    current = path
    prev = current
    found=false
    for i=1:10
      current=abspath(joinpath(current,"../"))
      buildscriptpath=joinpath(current,buildscript)
      if isfile(buildscriptpath) found=true; break end
      if current == prev break end #dublicate, sp break
      prev = current
    end
  end
  if !found error("'$buildscript' not found.") end
end

if !isfile(sourcescript) error("'$sourcescript' not found.") end

if !isdir(targetdir_build) mkdir(targetdir_build) end
if !isdir(targetdir_version) mkdir(targetdir_version) end
if !isdir(targetdir_project) mkdir(targetdir_project) end

if !isdir(targetdir_build) error("'$targetdir_build' failed to create.") end
if !isdir(targetdir_version) error("'$targetdir_version' failed to create.") end
if !isdir(targetdir_project) error("'$targetdir_project' failed to create.") end

cmd=`$julia $buildscriptpath --force "$name" $sourcescript $targetdir`

info(cmd)
run(cmd)
