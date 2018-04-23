var documenterSearchIndex = {"docs": [

{
    "location": "index.html#",
    "page": "Home",
    "title": "Home",
    "category": "page",
    "text": ""
},

{
    "location": "index.html#JGE-1",
    "page": "Home",
    "title": "JGE",
    "category": "section",
    "text": "Julia Graphics EngineStart"
},

{
    "location": "manual/start.html#",
    "page": "Start",
    "title": "Start",
    "category": "page",
    "text": ""
},

{
    "location": "manual/start.html#start-1",
    "page": "Start",
    "title": "Start",
    "category": "section",
    "text": "Design Pattern\nSzene\nScript Manager"
},

{
    "location": "manual/start.html#Design-Pattern-1",
    "page": "Start",
    "title": "Design Pattern",
    "category": "section",
    "text": "The Graphics Engine holds manages many objects like Shader, Camera, Mesh, Texture, etc. For each object an Manager Module exists for organisation and optimization. Manager Modules should hold more or less same structure. This structure can be given by a prototype.Design Pattern like Object Inhertance can be done with component-based design. Julia design is mostly modul and function based. Normally this design is sufficient enough for small projects but for bigger project like this graphics engine project we have to rethink how to design our project without the use of design pattern like OOP in Java.This Graphics Engine project is still experimental. I did\'nt found the ideal design structure for all cases yet. Some of my implementations are not the best solutions so there is still a room for improvement.The main problem lies in performance. We have to avoid performance restrictions through our design as best as we can. I split this project into two because i wanted to drawn many objects with good performance.My other project is called JuliaOpenGL. I created this to achieve good performance for this \"render many blocks\" issue. In the future i want to merge this project into the graphics engine project. I think thats the best way to improve large projects over time such as these without messing up your code to much."
},

{
    "location": "manual/start.html#Szene-1",
    "page": "Start",
    "title": "Szene",
    "category": "section",
    "text": "The Renderszene itself and its objects is managed by the RenderManager.jl which creates Render Objects which holds all references to Transformations, Mesh datas, textures and more. Those objects are just reference containers with some optional opengl parameters."
},

{
    "location": "manual/start.html#Script-Manager-1",
    "page": "Start",
    "title": "Script Manager",
    "category": "section",
    "text": "There is single szene called input.jl in scripts directory. Here you can move camera, create objects, sets properties and more. The script will be loaded automatically when you saved the file. Everything will be rebuilt right from the startScript will be managed by JLScriptManager.jl. This manager creates callbacks for events before compiling the script. You can get events on both ways from App to sctipt or other way round. For Example OnKey() Event comes from the WindowManager.jl but will be defined in the script to catch the keyboard values. We could define a custom function in a script which will be parsed and its reference will be saved to be accessible for the App.This example calls event OnUpdate which represents the call from App to script.script(:OnUpdate)This example allows the function printSomething() to be called from the script. It represents the call from script to App.list=Dict{Symbol,Function}(:printSomething = ()->println(\"Hey!\"),...)"
},

{
    "location": "files/App.html#",
    "page": "App.jl",
    "title": "App.jl",
    "category": "page",
    "text": ""
},

{
    "location": "files/App.html#App.jl-1",
    "page": "App.jl",
    "title": "App.jl",
    "category": "section",
    "text": "Uses libraries\nUses Core files\nUses Engine files\nCode\nLoop\nTimer\nCreate Script\nReload Script\nRun Script"
},

{
    "location": "files/App.html#Uses-libraries-1",
    "page": "App.jl",
    "title": "Uses libraries",
    "category": "section",
    "text": "Images\nImageMagick\nQuaternions\nMustache\nModernGL\nReactive\nFixedPointNumbers\nColorTypes\nCompat\nFileIO"
},

{
    "location": "files/App.html#Uses-Core-files-1",
    "page": "App.jl",
    "title": "Uses Core files",
    "category": "section",
    "text": "CoreExtended.jl\nTimeManager.jl\nLoggerManager.jl (importall)\nRessourceManager.jl\nFileManager.jl\nEnvironment.jl\nJLScriptManager.jl\nWindowManager.jl\nMatrixMath.jl"
},

{
    "location": "files/App.html#Uses-Engine-files-1",
    "page": "App.jl",
    "title": "Uses Engine files",
    "category": "section",
    "text": "JLGEngine.jl (include)\nGraphicsManager.jl\nLibGL.jl\nRenderManager.jl"
},

{
    "location": "files/App.html#App.ScriptRefs",
    "page": "App.jl",
    "title": "App.ScriptRefs",
    "category": "type",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/App.html#App.ScriptState",
    "page": "App.jl",
    "title": "App.ScriptState",
    "category": "type",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/App.html#App.start-Tuple{}",
    "page": "App.jl",
    "title": "App.start",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/App.html#Code-1",
    "page": "App.jl",
    "title": "Code",
    "category": "section",
    "text": "App.ScriptRefsApp.ScriptStateApp.start()"
},

{
    "location": "files/App.html#Loop-1",
    "page": "App.jl",
    "title": "Loop",
    "category": "section",
    "text": "WindowManager.loop(WINDOW, function()\r\n  Libc.systemsleep(programTick)\r\n  runOnFileUpdate()\r\n  JLScriptManager.loop(run)\r\nend)"
},

{
    "location": "files/App.html#Timer-1",
    "page": "App.jl",
    "title": "Timer",
    "category": "section",
    "text": "function tickUpdate(script::JLScript)\r\n  script.state.currentTime = currentTime(script.state.startTime)\r\n  script.state.ticks+=1\r\n  if OnTime(1.0,script.state.ticksTime)\r\n    script.state.ticksTotal=script.state.ticks\r\n    script.state.ticks=0\r\n  end\r\nend"
},

{
    "location": "files/App.html#Create-Script-1",
    "page": "App.jl",
    "title": "Create Script",
    "category": "section",
    "text": "function create(id::Symbol,path::String)\r\n  script = JLScript(id, FileSource(path))\r\n  script.state = ScriptState()\r\n  script.objref = ScriptRefs()\r\n  script.objref.WINDOW = WINDOW\r\n  script.objref.GD = GRAPHICSDRIVER()\r\n\r\n  WindowManager.setListener(WINDOW,script.id,(args...)->script(args...))\r\n\r\n  list=Dict{Symbol,Function}(\r\n     :scriptTime => () -> script.state.currentTime\r\n    ,:OnTick => function(tick::Real)\r\n      m=modf(tick)\r\n      t=m[1]>0?1/m[1]:0\r\n      g=m[2]>0?(TimeManager.now() % m[2]) :0\r\n      println(m,\" | \", t,\" | \",g,\" | \",script.state.ticks/script.state.ticksTotal)\r\n      g < 1 && (script.state.ticksTotal==0?true:(script.state.ticks/script.state.ticksTotal == t))\r\n    end\r\n    ,:reload => function()\r\n      println(\"Reload Script...\")\r\n      programTick=0.1\r\n      RenderManager.reset()\r\n      GRAPHICSDRIVER().resetRegisters()\r\n      reload(script)\r\n    end\r\n    ,:setProgramTick => (tick::Real) -> programTick = tick\r\n    ,:setRenderUpdate => (turn::Bool) -> script.state.isRenderOn = turn\r\n  )\r\n\r\n  script.extern = merge(script.extern,list)\r\n\r\n  registerFileUpdate(script.source, (source::FileSource) -> list[:reload]())\r\nend\r\n\r\ncreate(:input, \"scripts/input.jl\")"
},

{
    "location": "files/App.html#Reload-Script-1",
    "page": "App.jl",
    "title": "Reload Script",
    "category": "section",
    "text": "function reload(script::JLScript)\r\n  script.state.isRunning=false\r\n  script.state.isRenderRunOnce=false\r\n  script.state.isRenderOn=true\r\n  \r\n  JLScriptManager.run(script)\r\n\r\n  if !script.state.isInitalized\r\n    script(:OnInit)\r\n    \r\n    OnRender=JLScriptManager.exists(script,:OnRender) ? () -> script(:OnRender) : nothing\r\n    RenderManager.setOnRender(() -> script(:OnPreRender),() -> script(:OnPostRender),OnRender)\r\n    RenderManager.setOnDraw(() -> script(:OnPreDraw),() -> script(:OnPostDraw))\r\n    \r\n    script.state.isInitalized=true\r\n  end\r\n  \r\n  script(:OnReload)\r\nend"
},

{
    "location": "files/App.html#Run-Script-1",
    "page": "App.jl",
    "title": "Run Script",
    "category": "section",
    "text": "function run(script::JLScript)   if !script.state.isRunning     script(:OnStart)     RenderManager.start()     script.state.isRunning=true   endtickUpdate(script)   script(:OnUpdate)   RenderManager.update()if script.state.isRenderOn     RenderManager.render()     if !script.state.isRenderRunOnce script.state.isRenderRunOnce=true end   end end ```"
},

{
    "location": "files/CoreExtended.html#",
    "page": "CoreExtended.jl",
    "title": "CoreExtended.jl",
    "category": "page",
    "text": ""
},

{
    "location": "files/CoreExtended.html#CoreExtended.jl-1",
    "page": "CoreExtended.jl",
    "title": "CoreExtended.jl",
    "category": "section",
    "text": "Execute\nDebug\nFunction\nObject\nPreset"
},

{
    "location": "files/CoreExtended.html#CoreExtended.execute-Tuple{Module,Symbol,Vararg{Any,N} where N}",
    "page": "CoreExtended.jl",
    "title": "CoreExtended.execute",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/CoreExtended.html#CoreExtended.execute-Tuple{Expr,Vararg{Any,N} where N}",
    "page": "CoreExtended.jl",
    "title": "CoreExtended.execute",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/CoreExtended.html#CoreExtended.execute-Tuple{Function,Vararg{Any,N} where N}",
    "page": "CoreExtended.jl",
    "title": "CoreExtended.execute",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/CoreExtended.html#CoreExtended.execute-Tuple{Tuple{Bool,Any},Vararg{Any,N} where N}",
    "page": "CoreExtended.jl",
    "title": "CoreExtended.execute",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/CoreExtended.html#CoreExtended.execute-Tuple{Any,Vararg{Any,N} where N}",
    "page": "CoreExtended.jl",
    "title": "CoreExtended.execute",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/CoreExtended.html#CoreExtended.execute-Tuple{Void,Vararg{Any,N} where N}",
    "page": "CoreExtended.jl",
    "title": "CoreExtended.execute",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/CoreExtended.html#Execute-1",
    "page": "CoreExtended.jl",
    "title": "Execute",
    "category": "section",
    "text": "CoreExtended.execute(m::Module, s::Symbol, args...)CoreExtended.execute(e::Expr, args...)CoreExtended.execute(f::Function, args...)CoreExtended.execute(t::Tuple{Bool,Any}, args...)CoreExtended.execute(r::Any, args...)CoreExtended.execute(r::Void, args...)"
},

{
    "location": "files/CoreExtended.html#CoreExtended.exists-Tuple{Module,Symbol}",
    "page": "CoreExtended.jl",
    "title": "CoreExtended.exists",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/CoreExtended.html#CoreExtended.debug-Tuple{String}",
    "page": "CoreExtended.jl",
    "title": "CoreExtended.debug",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/CoreExtended.html#CoreExtended.iscallable-Tuple{Any}",
    "page": "CoreExtended.jl",
    "title": "CoreExtended.iscallable",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/CoreExtended.html#Debug-1",
    "page": "CoreExtended.jl",
    "title": "Debug",
    "category": "section",
    "text": "CoreExtended.exists(m::Module, s::Symbol)CoreExtended.debug(msg::String)CoreExtended.iscallable(f)"
},

{
    "location": "files/CoreExtended.html#CoreExtended.invoke-Tuple{Function,Vararg{Any,N} where N}",
    "page": "CoreExtended.jl",
    "title": "CoreExtended.invoke",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/CoreExtended.html#CoreExtended.stabilize-Tuple{Function}",
    "page": "CoreExtended.jl",
    "title": "CoreExtended.stabilize",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/CoreExtended.html#Function-1",
    "page": "CoreExtended.jl",
    "title": "Function",
    "category": "section",
    "text": "CoreExtended.invoke(f::Function, args...)CoreExtended.stabilize(f::Function)"
},

{
    "location": "files/CoreExtended.html#CoreExtended.AbstractObjectReference",
    "page": "CoreExtended.jl",
    "title": "CoreExtended.AbstractObjectReference",
    "category": "type",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/CoreExtended.html#CoreExtended.EmptyObject",
    "page": "CoreExtended.jl",
    "title": "CoreExtended.EmptyObject",
    "category": "type",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/CoreExtended.html#CoreExtended.EMPTY_OBJECT",
    "page": "CoreExtended.jl",
    "title": "CoreExtended.EMPTY_OBJECT",
    "category": "constant",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/CoreExtended.html#CoreExtended.EMPTY_FUNCTION",
    "page": "CoreExtended.jl",
    "title": "CoreExtended.EMPTY_FUNCTION",
    "category": "function",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/CoreExtended.html#Object-1",
    "page": "CoreExtended.jl",
    "title": "Object",
    "category": "section",
    "text": "CoreExtended.AbstractObjectReferenceCoreExtended.EmptyObject CoreExtended.EMPTY_OBJECTCoreExtended.EMPTY_FUNCTION"
},

{
    "location": "files/CoreExtended.html#CoreExtended.hasVal-Tuple{AbstractArray,Function}",
    "page": "CoreExtended.jl",
    "title": "CoreExtended.hasVal",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/CoreExtended.html#CoreExtended.replace-Tuple{AbstractArray,Function,Any}",
    "page": "CoreExtended.jl",
    "title": "CoreExtended.replace",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/CoreExtended.html#CoreExtended.update-Tuple{AbstractArray,Function,Function}",
    "page": "CoreExtended.jl",
    "title": "CoreExtended.update",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/CoreExtended.html#CoreExtended.update-Tuple{Dict,Any,Function}",
    "page": "CoreExtended.jl",
    "title": "CoreExtended.update",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/CoreExtended.html#Update-1",
    "page": "CoreExtended.jl",
    "title": "Update",
    "category": "section",
    "text": "CoreExtended.hasVal(a::AbstractArray, getindex::Function)CoreExtended.replace(a::AbstractArray, f::Function, v::Any)CoreExtended.update(a::AbstractArray, getindex::Function, f::Function)CoreExtended.update(dict::Dict, index::Any, f::Function)"
},

{
    "location": "files/CoreExtended.html#CoreExtended.OnException",
    "page": "CoreExtended.jl",
    "title": "CoreExtended.OnException",
    "category": "function",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/CoreExtended.html#CoreExtended.linkToException",
    "page": "CoreExtended.jl",
    "title": "CoreExtended.linkToException",
    "category": "function",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/CoreExtended.html#CoreExtended.backTraceException-Tuple{Exception}",
    "page": "CoreExtended.jl",
    "title": "CoreExtended.backTraceException",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/CoreExtended.html#CoreExtended.catchException",
    "page": "CoreExtended.jl",
    "title": "CoreExtended.catchException",
    "category": "function",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/CoreExtended.html#Exception-1",
    "page": "CoreExtended.jl",
    "title": "Exception",
    "category": "section",
    "text": "CoreExtended.OnExceptionCoreExtended.linkToExceptionCoreExtended.backTraceException(ex::Exception)CoreExtended.catchException(f::Function, exf=OnException)"
},

{
    "location": "files/CoreExtended.html#CoreExtended.presetManager",
    "page": "CoreExtended.jl",
    "title": "CoreExtended.presetManager",
    "category": "function",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/CoreExtended.html#Preset-1",
    "page": "CoreExtended.jl",
    "title": "Preset",
    "category": "section",
    "text": "(Obsolete)CoreExtended.presetManager(T::DataType, S=T)"
},

{
    "location": "files/Environment.html#",
    "page": "Environment.jl",
    "title": "Environment.jl",
    "category": "page",
    "text": ""
},

{
    "location": "files/Environment.html#Environment.jl-1",
    "page": "Environment.jl",
    "title": "Environment.jl",
    "category": "section",
    "text": ""
},

{
    "location": "files/FileManager.html#",
    "page": "FileManager.jl",
    "title": "FileManager.jl",
    "category": "page",
    "text": ""
},

{
    "location": "files/FileManager.html#FileManager.FileSource",
    "page": "FileManager.jl",
    "title": "FileManager.FileSource",
    "category": "type",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/FileManager.html#FileManager.FileSourcePart",
    "page": "FileManager.jl",
    "title": "FileManager.FileSourcePart",
    "category": "type",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/FileManager.html#FileManager.FileUpdateEntry",
    "page": "FileManager.jl",
    "title": "FileManager.FileUpdateEntry",
    "category": "type",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/FileManager.html#FileManager.getCache-Tuple{FileManager.FileSource}",
    "page": "FileManager.jl",
    "title": "FileManager.getCache",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/FileManager.html#FileManager.reload-Tuple{FileManager.FileSource}",
    "page": "FileManager.jl",
    "title": "FileManager.reload",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/FileManager.html#FileManager.readFileSource-Tuple{String}",
    "page": "FileManager.jl",
    "title": "FileManager.readFileSource",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/FileManager.html#FileManager.splitFileName-Tuple{String}",
    "page": "FileManager.jl",
    "title": "FileManager.splitFileName",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/FileManager.html#FileManager.waitForFileReady",
    "page": "FileManager.jl",
    "title": "FileManager.waitForFileReady",
    "category": "function",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/FileManager.html#FileManager.fileGetContents",
    "page": "FileManager.jl",
    "title": "FileManager.fileGetContents",
    "category": "function",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/FileManager.html#FileManager.addDirSlash-Tuple{String}",
    "page": "FileManager.jl",
    "title": "FileManager.addDirSlash",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/FileManager.html#FileManager.registerFileUpdate-Tuple{FileManager.FileSource,Function,Vararg{Any,N} where N}",
    "page": "FileManager.jl",
    "title": "FileManager.registerFileUpdate",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/FileManager.html#FileManager.unregisterFileUpdate-Tuple{FileManager.FileSource}",
    "page": "FileManager.jl",
    "title": "FileManager.unregisterFileUpdate",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/FileManager.html#FileManager.runOnFileUpdate",
    "page": "FileManager.jl",
    "title": "FileManager.runOnFileUpdate",
    "category": "function",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/FileManager.html#FileManager.watchFileUpdate-Tuple{String,Function}",
    "page": "FileManager.jl",
    "title": "FileManager.watchFileUpdate",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/FileManager.html#FileManager.watchFileUpdate-Tuple{FileManager.FileSource,Function}",
    "page": "FileManager.jl",
    "title": "FileManager.watchFileUpdate",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/FileManager.html#FileManager.isUpdated",
    "page": "FileManager.jl",
    "title": "FileManager.isUpdated",
    "category": "function",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/FileManager.html#FileManager.jl-1",
    "page": "FileManager.jl",
    "title": "FileManager.jl",
    "category": "section",
    "text": "using FileIO.jlFileManager.FileSourceFileManager.FileSourcePartFileManager.FileUpdateEntryFileManager.getCache(source::FileManager.FileSource)FileManager.reload(source::FileManager.FileSource)FileManager.readFileSource(path::String)FileManager.splitFileName(path::String)FileManager.waitForFileReady(path::String, func::Function, tryCount=100, tryWait=0.1)FileManager.fileGetContents(path::String, tryCount=100, tryWait=0.1)FileManager.addDirSlash(path::String)FileManager.registerFileUpdate(source::FileManager.FileSource, OnUpdate::Function, args...)FileManager.unregisterFileUpdate(source::FileManager.FileSource)FileManager.runOnFileUpdate(threshold=0.01)FileManager.watchFileUpdate(path::String, OnUpdate::Function)FileManager.watchFileUpdate(path::FileManager.FileSource, OnUpdate::Function)FileManager.isUpdated(file::FileIO.File, tickrate=0.001)"
},

{
    "location": "files/JLScriptManager.html#",
    "page": "JLScriptManager.jl",
    "title": "JLScriptManager.jl",
    "category": "page",
    "text": ""
},

{
    "location": "files/JLScriptManager.html#JLScriptManager.jl-1",
    "page": "JLScriptManager.jl",
    "title": "JLScriptManager.jl",
    "category": "section",
    "text": ""
},

{
    "location": "files/JLScriptManager.html#JLScriptManager.JLComponent",
    "page": "JLScriptManager.jl",
    "title": "JLScriptManager.JLComponent",
    "category": "type",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/JLScriptManager.html#JLScriptManager.JLInvalidComponent",
    "page": "JLScriptManager.jl",
    "title": "JLScriptManager.JLInvalidComponent",
    "category": "type",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/JLScriptManager.html#JLScriptManager.JL_INVALID_COMPONENT",
    "page": "JLScriptManager.jl",
    "title": "JLScriptManager.JL_INVALID_COMPONENT",
    "category": "constant",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/JLScriptManager.html#JLScriptManager.JLStateListComponent",
    "page": "JLScriptManager.jl",
    "title": "JLScriptManager.JLStateListComponent",
    "category": "type",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/JLScriptManager.html#JLScriptManager.JLScriptFunction",
    "page": "JLScriptManager.jl",
    "title": "JLScriptManager.JLScriptFunction",
    "category": "type",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/JLScriptManager.html#JLScriptManager.JLScript-Tuple{Symbol}",
    "page": "JLScriptManager.jl",
    "title": "JLScriptManager.JLScript",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/JLScriptManager.html#JLScriptManager.JLScript-Tuple{Symbol,FileManager.FileSource}",
    "page": "JLScriptManager.jl",
    "title": "JLScriptManager.JLScript",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/JLScriptManager.html#JLScriptManager.loop-Tuple{Function}",
    "page": "JLScriptManager.jl",
    "title": "JLScriptManager.loop",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/JLScriptManager.html#JLScriptManager.listen-Tuple{JLScriptManager.JLScript,Symbol,Function}",
    "page": "JLScriptManager.jl",
    "title": "JLScriptManager.listen",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/JLScriptManager.html#JLScriptManager.run-Tuple{JLScriptManager.JLScript,Vararg{Any,N} where N}",
    "page": "JLScriptManager.jl",
    "title": "JLScriptManager.run",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/JLScriptManager.html#JLScriptManager.exists-Tuple{JLScriptManager.JLScript,Symbol}",
    "page": "JLScriptManager.jl",
    "title": "JLScriptManager.exists",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/JLScriptManager.html#JLScriptManager.execute",
    "page": "JLScriptManager.jl",
    "title": "JLScriptManager.execute",
    "category": "function",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/JLScriptManager.html#JLScriptManager.execute-Tuple{JLScriptManager.JLScriptFunction,Vararg{Any,N} where N}",
    "page": "JLScriptManager.jl",
    "title": "JLScriptManager.execute",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/JLScriptManager.html#JLScriptManager.compile-Tuple{JLScriptManager.JLScript,Vararg{Any,N} where N}",
    "page": "JLScriptManager.jl",
    "title": "JLScriptManager.compile",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/JLScriptManager.html#JLScriptManager.cleanCode-Tuple{String}",
    "page": "JLScriptManager.jl",
    "title": "JLScriptManager.cleanCode",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/JLScriptManager.html#JLScriptManager.eval-Tuple{JLScriptManager.JLScript,Vararg{Any,N} where N}",
    "page": "JLScriptManager.jl",
    "title": "JLScriptManager.eval",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/JLScriptManager.html#using-1",
    "page": "JLScriptManager.jl",
    "title": "using",
    "category": "section",
    "text": "CoreExtended\nFileManager.FileSourceJLScriptManager.JLComponentJLScriptManager.JLInvalidComponentJLScriptManager.JL_INVALID_COMPONENTJLScriptManager.JLStateListComponentJLScriptManager.JLScriptFunctionJLScriptManager.JLScript(id::Symbol)JLScriptManager.JLScript(id::Symbol, source::FileManager.FileSource)JLScriptManager.loop(f::Function)JLScriptManager.listen(this::JLScriptManager.JLScript, k::Symbol, f::Function)JLScriptManager.run(this::JLScriptManager.JLScript, args...)(this::JLScript)(s::Symbol, args...) = CoreExtended.execute(this.mod,s,args...)JLScriptManager.exists(this::JLScriptManager.JLScript, s::Symbol)JLScriptManager.execute(this::JLScriptManager.JLScript, compile_args=[], args...)JLScriptManager.execute(f::JLScriptManager.JLScriptFunction, args...)JLScriptManager.compile(this::JLScriptManager.JLScript, args...)JLScriptManager.cleanCode(code::String)JLScriptManager.eval(this::JLScriptManager.JLScript, args...)"
},

{
    "location": "files/LoggerManager.html#",
    "page": "LoggerManager.jl",
    "title": "LoggerManager.jl",
    "category": "page",
    "text": ""
},

{
    "location": "files/LoggerManager.html#LoggerManager.jl-1",
    "page": "LoggerManager.jl",
    "title": "LoggerManager.jl",
    "category": "section",
    "text": ""
},

{
    "location": "files/LoggerManager.html#import-1",
    "page": "LoggerManager.jl",
    "title": "import",
    "category": "section",
    "text": "Base.print\nBase.println\nBase.warn\nBase.error"
},

{
    "location": "files/LoggerManager.html#export-1",
    "page": "LoggerManager.jl",
    "title": "export",
    "category": "section",
    "text": "LOGGER_OUT\nLOGGER_ERROR\nprint\nprintf\nprintln\ninfo\nwarn\nerror"
},

{
    "location": "files/LoggerManager.html#LoggerManager.logException-Tuple{Exception}",
    "page": "LoggerManager.jl",
    "title": "LoggerManager.logException",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/LoggerManager.html#LoggerManager.@printf-Tuple",
    "page": "LoggerManager.jl",
    "title": "LoggerManager.@printf",
    "category": "macro",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/LoggerManager.html#using-1",
    "page": "LoggerManager.jl",
    "title": "using",
    "category": "section",
    "text": "Suppressor.jl\nTimeManager.jl\nCoreExtended.jlLoggerManager.logException(ex::Exception)LoggerManager.@printf(xs...)"
},

{
    "location": "files/LoggerManager.html#Files-1",
    "page": "LoggerManager.jl",
    "title": "Files",
    "category": "section",
    "text": "LOGGER_OUT = \"out.log\"\r\nLOGGER_ERROR = \"error.log\""
},

{
    "location": "files/LoggerManager.html#Overwrite-1",
    "page": "LoggerManager.jl",
    "title": "Overwrite",
    "category": "section",
    "text": "@suppress begin print(xs...) = open(f -> (print(f, xs...); print(STDOUT, xs...)), LOGGER_OUT, \"a+\") end\r\n@suppress begin println(xs...) = open(f -> (println(f, programTimeStr(), \" \", xs...); println(STDOUT, xs...)), LOGGER_OUT, \"a+\") end\r\n@suppress begin info(xs...) = open(f -> (info(f, programTimeStr(), \" \", xs...); info(STDOUT, xs...)), LOGGER_OUT, \"a+\") end\r\n@suppress begin error(xs...) = open(f -> (error(f, programTimeStr(),\" \", xs...); error(STDERR, xs...)), LOGGER_ERROR, \"a+\") end\r\n@suppress begin warn(xs...) = open(f -> (warn(f, programTimeStr(),\" \", xs...); warn(STDERR, xs...)), LOGGER_ERROR, \"a+\") end"
},

{
    "location": "files/MatrixMath.html#",
    "page": "MatrixMath.jl",
    "title": "MatrixMath.jl",
    "category": "page",
    "text": ""
},

{
    "location": "files/MatrixMath.html#MatrixMath.jl-1",
    "page": "MatrixMath.jl",
    "title": "MatrixMath.jl",
    "category": "section",
    "text": "Imports, Exports, Uses\nConversion\nValues\nVector, Vector Operations, Vector Types\nMatrix, Matrix Types, Matrix Values\nView Matrix, Frustum Matrix, LookAt Matrix\nPerspective Projection Matrix, Orthographic Projection Matrix\nTranslation Matrix, Rotation Matrix, Scaling Matrix\nFunctions"
},

{
    "location": "files/MatrixMath.html#Imports-1",
    "page": "MatrixMath.jl",
    "title": "Imports",
    "category": "section",
    "text": "Base: +, -, *, /, \\, ^, %, normalize "
},

{
    "location": "files/MatrixMath.html#Exports-1",
    "page": "MatrixMath.jl",
    "title": "Exports",
    "category": "section",
    "text": "array, avec, scale, rotr90flipdim2\nVec, Mat, AIndex\nVec1f, Vec2f, Vec3f, Vec4f,\nVec1i, Vec2i, Vec3i, Vec4i\nVec1u, Vec2u, Vec3u, Vec4u\nAVec1f, AVec2f, AVec3f, AVec4f\nMat1x1f, Mat1x2f, Mat1x3f, Mat1x4f\nMat2x1f, Mat2x2f, Mat2x3f, Mat2x4f\nMat3x1f, Mat3x2f, Mat3x3f, Mat3x4f\nMat4x1f, Mat4x2f, Mat4x3f, Mat4x4f\nIMat1x1f, IMat2x2f, IMat3x3f, IMat4x4f"
},

{
    "location": "files/MatrixMath.html#Uses-1",
    "page": "MatrixMath.jl",
    "title": "Uses",
    "category": "section",
    "text": "StaticArrays\nQuaternions"
},

{
    "location": "files/MatrixMath.html#Conversion-1",
    "page": "MatrixMath.jl",
    "title": "Conversion",
    "category": "section",
    "text": "converts to normal arrayarray(x::AbstractArray) = convert(array(typeof(x)),vec(x))\r\narray{T<:AbstractArray}(::Type{T}) = Array{array(eltype(T)),1};\r\narray{T}(::Type{T}) = T;converts to one-dim normal array (faster than using vcat(x...) only! you need to convert into normal array first!)avec(x::AbstractArray) = vcat(array(x)...)"
},

{
    "location": "files/MatrixMath.html#Values-1",
    "page": "MatrixMath.jl",
    "title": "Values",
    "category": "section",
    "text": "AIndex = Array{UInt32,1}"
},

{
    "location": "files/MatrixMath.html#Vector-1",
    "page": "MatrixMath.jl",
    "title": "Vector",
    "category": "section",
    "text": "Vec = SVectormutable  struct Vec1{T} <: FieldVector{1, T}\r\n		x::T\r\nendmutable  struct Vec2{T} <: FieldVector{2, T}\r\n		x::T\r\n		y::T\r\nendmutable  struct Vec3{T} <: FieldVector{3, T}\r\n		x::T\r\n		y::T\r\n		z::T\r\nendmutable struct Vec4{T} <: FieldVector{4, T}\r\n		x::T\r\n		y::T\r\n		z::T\r\n		w::T\r\nendVec1{T}() where T = Vec1{T}(0)\r\nVec1{T}(v::T) where T = Vec1{T}(v)\r\nVec1{T}(v::Number) where T<:Number = Vec1{T}(v)\r\n#Vec1{T}(v::Vec1{T}) where T = Vec1{T}(v.x)Vec2{T}() where T = Vec2{T}(0,0)\r\nVec2{T}(v::T) where T = Vec2{T}(v,v)\r\nVec2{T}(v::Number) where T<:Number = Vec2{T}(v,v)Vec3{T}() where T = Vec3{T}(0,0,0)\r\nVec3{T}(v::T) where T = Vec3{T}(v,v,v)\r\nVec3{T}(v::Number) where T<:Number = Vec3{T}(v,v,v)Vec4{T}() where T = Vec4{T}(0,0,0,0)\r\nVec4{T}(v::T) where T = Vec4{T}(v,v,v,v)\r\nVec4{T}(v::Number) where T<:Number = Vec4{T}(v,v,v,v)"
},

{
    "location": "files/MatrixMath.html#Vector-Operations-1",
    "page": "MatrixMath.jl",
    "title": "Vector Operations",
    "category": "section",
    "text": "+{T}(a::Vec2{T}, b::Vec2{T}) = Vec2(SVector(a)+SVector(b))\r\n+{T}(a::Vec3{T}, b::Vec3{T}) = Vec3(SVector(a)+SVector(b))\r\n-{T}(a::Vec2{T}, b::Vec2{T}) = Vec2(SVector(a)+SVector(b))\r\n-{T}(a::Vec3{T}, b::Vec3{T}) = Vec3(SVector(a)+SVector(b))normalize{T}(v::Vec2{T}) = Vec2(normalize(SVector(v)))\r\nnormalize{T}(v::Vec3{T}) = Vec3(normalize(SVector(v)))function operator{N, T}(op::Function,a::SVector{N, T}, b::SVector{N, T})\r\n	m = zeros(T,N,N)\r\n	for ai=1:N\r\n		for bi=1:N\r\n			r = op(a[ai],b[bi])\r\n			if !isa(r,T) r = round(r) end # fix: round(Int / Int = Float)\r\n			m[ai,bi]=r\r\n		end\r\n	end\r\n	SMatrix{N,N,T,N*N}(m) #* ones(SVector{N, T})\r\nend\r\n\r\nfunction operator2{N, T}(op::Function,a::SVector{N, T}, b::SVector{N, T})\r\n	v = zeros(T,N)\r\n	for ai=1:N\r\n		r = op(a[ai],b[ai])\r\n		if !isa(r,T) r = round(r) end # fix: round(Int / Int = Float)\r\n		v[ai]=r\r\n	end\r\n	SVector(v...)\r\nendoperations*{N, T}(a::SVector{N, T}, b::SVector{N, T}) = operator(*,a,b)\r\n/{N, T}(a::SVector{N, T}, b::SVector{N, T}) = operator(/,a,b)\r\n\\{N, T}(a::SVector{N, T}, b::SVector{N, T}) = operator(\\,a,b)\r\n^{N, T}(a::SVector{N, T}, b::SVector{N, T}) = operator(^,a,b)\r\n%{N, T}(a::SVector{N, T}, b::SVector{N, T}) = operator(%,a,b)scale{N, T}(a::SVector{N, T}, b::SVector{N, T}) = operator2(*,a,b)\r\nscale{T}(a::Vec2{T}, b::Vec2{T}) = Vec2(scale(SVector(a),SVector(b)))\r\nscale{T}(a::Vec3{T}, b::Vec3{T}) = Vec3(scale(SVector(a),SVector(b)))"
},

{
    "location": "files/MatrixMath.html#Vector-Types-1",
    "page": "MatrixMath.jl",
    "title": "Vector Types",
    "category": "section",
    "text": "Vec1f = Vec1{Float32}\r\nVec2f = Vec2{Float32}\r\nVec3f = Vec3{Float32}\r\nVec4f = Vec4{Float32}Vec1i = Vec2{Int32}\r\nVec2i = Vec2{Int32}\r\nVec3i = Vec3{Int32}\r\nVec4i = Vec4{Int32}Vec1u = Vec1{UInt32}\r\nVec2u = Vec2{UInt32}\r\nVec3u = Vec3{UInt32}\r\nVec4u = Vec4{UInt32}AVec1f = Array{Vec1f,1}\r\nAVec2f = Array{Vec2f,1}\r\nAVec3f = Array{Vec3f,1}\r\nAVec4f = Array{Vec4f,1}"
},

{
    "location": "files/MatrixMath.html#Matrix-1",
    "page": "MatrixMath.jl",
    "title": "Matrix",
    "category": "section",
    "text": "Mat = SMatrixMat1x1{T} = SMatrix{1,1,T,1}\r\nMat1x2{T} = SMatrix{1,2,T,2}\r\nMat1x3{T} = SMatrix{1,3,T,3}\r\nMat1x4{T} = SMatrix{1,4,T,4}Mat2x1{T} = SMatrix{2,1,T,2}\r\nMat2x2{T} = SMatrix{2,2,T,4}\r\nMat2x3{T} = SMatrix{2,3,T,6}\r\nMat2x4{T} = SMatrix{2,4,T,8}Mat3x1{T} = SMatrix{3,1,T,3}\r\nMat3x2{T} = SMatrix{3,2,T,6}\r\nMat3x3{T} = SMatrix{3,3,T,9}\r\nMat3x4{T} = SMatrix{3,4,T,12}Mat4x1{T} = SMatrix{4,1,T,4}\r\nMat4x2{T} = SMatrix{4,2,T,8}\r\nMat4x3{T} = SMatrix{4,3,T,12}\r\nMat4x4{T} = SMatrix{4,4,T,16}"
},

{
    "location": "files/MatrixMath.html#Matrix-Types-1",
    "page": "MatrixMath.jl",
    "title": "Matrix Types",
    "category": "section",
    "text": "Mat1x1f = Mat1x1{Float32}\r\nMat1x2f = Mat1x2{Float32}\r\nMat1x3f = Mat1x3{Float32}\r\nMat1x4f = Mat1x4{Float32}Mat2x1f = Mat2x1{Float32}\r\nMat2x2f = Mat2x2{Float32}\r\nMat2x3f = Mat2x3{Float32}\r\nMat2x4f = Mat2x4{Float32}Mat3x1f = Mat3x1{Float32}\r\nMat3x2f = Mat3x2{Float32}\r\nMat3x3f = Mat3x3{Float32}\r\nMat3x4f = Mat3x4{Float32}Mat4x1f = Mat4x1{Float32}\r\nMat4x2f = Mat4x2{Float32}\r\nMat4x3f = Mat4x3{Float32}\r\nMat4x4f = Mat4x4{Float32}"
},

{
    "location": "files/MatrixMath.html#Matrix-Values-1",
    "page": "MatrixMath.jl",
    "title": "Matrix Values",
    "category": "section",
    "text": "const IMat1x1f = @SMatrix [\r\n	1f0;\r\n]const IMat2x2f = @SMatrix [\r\n	1f0 0 ;\r\n	0 1f0 ;\r\n]const IMat3x3f = @SMatrix [\r\n	1f0 0 0 ;\r\n	0 1f0 0 ;\r\n	0 0 1f0 ;\r\n]const IMat4x4f = @SMatrix [\r\n	1f0 0 0 0 ;\r\n	0 1f0 0 0 ;\r\n	0 0 1f0 0 ;\r\n	0 0 0 1f0 ;\r\n]"
},

{
    "location": "files/MatrixMath.html#View-Matrix-1",
    "page": "MatrixMath.jl",
    "title": "View Matrix",
    "category": "section",
    "text": "function FPSViewRH(eye::Any, yaw::Float32, pitch::Float32)\r\n    # If the pitch and yaw angles are in degrees,\r\n    # they need to be converted to radians. Here\r\n    # I assume the values are already converted to radians.\r\n    cosPitch = cos(pitch)\r\n    sinPitch = sin(pitch)\r\n    cosYaw = cos(yaw)\r\n    sinYaw = sin(yaw)\r\n\r\n    xaxis = Vec3f( cosYaw, 0, -sinYaw )\r\n    yaxis = Vec3f( sinYaw * sinPitch, cosPitch, cosYaw * sinPitch )\r\n    zaxis = Vec3f( sinYaw * cosPitch, -sinPitch, cosPitch * cosYaw )\r\n\r\n    # Create a 4x4 view matrix from the right, up, forward and eye position vectors\r\n    Mat{4,4,Float32}([\r\n      xaxis[1] yaxis[1] zaxis[1] -dot(xaxis,eye)*0;\r\n      xaxis[2] yaxis[2] zaxis[2] -dot(yaxis,eye)*0;\r\n      xaxis[3] yaxis[3] zaxis[3] -dot(zaxis,eye)*0;\r\n      -dot(xaxis,eye) -dot(yaxis,eye) -dot(zaxis,eye) 1;\r\n    ])\r\nend"
},

{
    "location": "files/MatrixMath.html#Frustum-Matrix-1",
    "page": "MatrixMath.jl",
    "title": "Frustum Matrix",
    "category": "section",
    "text": "function frustum{T}(left::T, right::T, bottom::T, top::T, znear::T, zfar::T)\r\n    (right == left || bottom == top || znear == zfar) && return eye(Mat4x4{T})\r\n    Mat4x4{T}([\r\n        2*znear/(right-left) 0 0 0;\r\n        0 2*znear/(top-bottom) 0 0;\r\n        (right+left)/(right-left) (top+bottom)/(top-bottom) (-(zfar+znear)/(zfar-znear)) -(2*znear*zfar) / (zfar-znear);\r\n        0 0 -1 0\r\n    ])\r\nend"
},

{
    "location": "files/MatrixMath.html#LookAt-Matrix-1",
    "page": "MatrixMath.jl",
    "title": "LookAt Matrix",
    "category": "section",
    "text": "function lookat{T}(eye::Vec3{T}, lookAt::Vec3{T}, up::Vec3{T})\r\n    zaxis  = normalize(eye-lookAt)\r\n    xaxis  = normalize(cross(up,    zaxis))\r\n    yaxis  = normalize(cross(zaxis, xaxis))\r\n    Mat4x4{T}([\r\n        xaxis[1] yaxis[1] zaxis[1] 0;\r\n        xaxis[2] yaxis[2] zaxis[2] 0;\r\n        xaxis[3] yaxis[3] zaxis[3] 0;\r\n        -dot(xaxis,eye) -dot(yaxis,eye) -dot(zaxis,eye) 1\r\n    ])\r\nend"
},

{
    "location": "files/MatrixMath.html#Perspective-Projection-Matrix-1",
    "page": "MatrixMath.jl",
    "title": "Perspective Projection Matrix",
    "category": "section",
    "text": "function perspectiveprojection{T}(fovy::T, aspect::T, znear::T, zfar::T)\r\n		(znear == zfar) && error(\"znear ($znear) must be different from tfar ($zfar)\")\r\n\r\n		t = tan(fovy * 0.5)\r\n    h = T(tan(fovy * pi / 360) * znear)\r\n    w = T(h * aspect)\r\n\r\n		left = -w\r\n		right = w\r\n		bottom = -h\r\n		top = h\r\n\r\n		frustum(-w, w, -h, h, znear, zfar)\r\nend"
},

{
    "location": "files/MatrixMath.html#Orthographic-Projection-Matrix-1",
    "page": "MatrixMath.jl",
    "title": "Orthographic Projection Matrix",
    "category": "section",
    "text": "function orthographicprojection{T}(fovy::T, aspect::T, znear::T, zfar::T)\r\n		(znear == zfar) && error(\"znear ($znear) must be different from tfar ($zfar)\")\r\n	\r\n		t = tan(fovy * 0.5)\r\n    h = T(tan(fovy * pi / 360) * znear)\r\n    w = T(h * aspect)\r\n\r\n		left = -w\r\n		right = w\r\n		bottom = -h\r\n		top = h\r\n\r\n		orthographicprojection(-w, w, -h, h, znear, zfar)\r\nendfunction orthographicprojection{T}(left::T,right::T,bottom::T,top::T,znear::T,zfar::T)\r\n    (right==left || bottom==top || znear==zfar) && return eye(Mat4x4{T})\r\n    Mat4x4{T}([\r\n        2/(right-left) 0 0 0;\r\n        0 2/(top-bottom) 0 0;\r\n        0 0 -2/(zfar-znear) 0;\r\n				-(right+left)/(right-left) -(top+bottom)/(top-bottom) -(zfar+znear)/(zfar-znear) 1;\r\n    ])\r\nend"
},

{
    "location": "files/MatrixMath.html#Translation-Matrix-1",
    "page": "MatrixMath.jl",
    "title": "Translation Matrix",
    "category": "section",
    "text": "function translationmatrix{T}(t::Vec3{T})\r\n    Mat4x4{T}([\r\n        1 0 0 t[1];\r\n        0 1 0 t[2];\r\n        0 0 1 t[3];\r\n				0 0 0 1;\r\n    ])\r\nendfunction inverse_translationmatrix{T}(t::Vec3{T})\r\n    Mat4x4{T}([\r\n        1 0 0 0;\r\n        0 1 0 0;\r\n        0 0 1 0;\r\n				t[1] t[2] t[3] 1;\r\n    ])\r\nend"
},

{
    "location": "files/MatrixMath.html#Rotation-Matrix-1",
    "page": "MatrixMath.jl",
    "title": "Rotation Matrix",
    "category": "section",
    "text": "function rotationmatrix{T}(t::Vec3{T})\r\n    Mat4x4{T}([\r\n        1 0 0 0;\r\n        0 1 0 0;\r\n        0 0 1 0;\r\n				t[1] t[2] t[3] 1;\r\n    ])\r\nendfunction rotationmatrix4{T}(q::Quaternions.Quaternion{T})\r\n    sx, sy, sz = 2q.s*q.v1,  2q.s*q.v2,   2q.s*q.v3\r\n    xx, xy, xz = 2q.v1^2,    2q.v1*q.v2,  2q.v1*q.v3\r\n    yy, yz, zz = 2q.v2^2,    2q.v2*q.v3,  2q.v3^2\r\n    Mat4x4{T}([\r\n        1-(yy+zz)	xy+sz				xz-sy				0;\r\n        xy-sz				1-(xx+zz)	yz+sx				0;\r\n        xz+sy				yz-sx				1-(xx+yy)	0;\r\n        0 0 0 1\r\n    ])\r\nend"
},

{
    "location": "files/MatrixMath.html#Scaling-Matrix-1",
    "page": "MatrixMath.jl",
    "title": "Scaling Matrix",
    "category": "section",
    "text": "function scalingmatrix{T}(t::Vec3{T})\r\n    Mat4x4{T}([\r\n        t[2] 0 0 0;\r\n        0 t[2] 0 0;\r\n        0 0 t[3] 0;\r\n				0 0 0 1;\r\n    ])\r\nend"
},

{
    "location": "files/MatrixMath.html#Functions-1",
    "page": "MatrixMath.jl",
    "title": "Functions",
    "category": "section",
    "text": "rotr90flipdim2(x::AbstractArray) = flipdim(rotr90(x),2)function convertMatrixToArray(values::AbstractArray)\r\n	dims=ndims(values)\r\n	elems=dims > 1 ? size(values)[dims] : 1\r\n	values=avec(values) #wow! < 0.05 sec for > 1000 vertices!\r\n	#print(\"vcat: \"); @time v=vcat(values...) #end # convert to one dimensional array\r\n	#print(\"convert: \"); @time c=convert(Array{typeof(v[1]),1},v)\r\n	(values, elems)\r\nendrotate{T}(angle::T, axis::Vec3{T}) = rotationmatrix4(Quaternions.qrotation(convert(Array, axis), angle))rotate{T}(v::Vec2{T}, angle::T) = Vec2{T}(v[1] * cos(angle) - v[2] * sin(angle), v[1] * sin(angle) + v[1] * cos(angle))forwardVector4{T}(m::Mat4x4{T}) = Vec3{T}(m[3,1],m[3,2],m[3,3])rightVector4{T}(m::Mat4x4{T}) = Vec3{T}(m[1,1],m[1,2],m[1,3])upVector4{T}(m::Mat4x4{T}) = Vec3{T}(m[2,1],m[2,2],m[2,3])function computeRotation{T}(rot::Vec3{T})\r\n	dirBackwards= Vec3{T}(-1,0,0)\r\n	dirRight = Vec3{T}(0,0,1)\r\n	dirUp = Vec3{T}(0,1,0) #cross(dirRight, dirBackwards)\r\n\r\n	q = Quaternions.qrotation(convert(Array, dirRight), rot[3]) *\r\n	Quaternions.qrotation(convert(Array, dirUp), rot[1]) *\r\n	Quaternions.qrotation(convert(Array, dirBackwards), rot[2])\r\n\r\n	rotationmatrix4(q)\r\nend"
},

{
    "location": "files/RessourceManager.html#",
    "page": "RessourceManager.jl",
    "title": "RessourceManager.jl",
    "category": "page",
    "text": ""
},

{
    "location": "files/RessourceManager.html#RessourceManager.SetWorkingDir-Tuple{}",
    "page": "RessourceManager.jl",
    "title": "RessourceManager.SetWorkingDir",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/RessourceManager.html#RessourceManager.RessourcePath-Tuple{AbstractString}",
    "page": "RessourceManager.jl",
    "title": "RessourceManager.RessourcePath",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/RessourceManager.html#RessourceManager.AddPath-Tuple{Any,AbstractString}",
    "page": "RessourceManager.jl",
    "title": "RessourceManager.AddPath",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/RessourceManager.html#RessourceManager.GetPath-Tuple{Any}",
    "page": "RessourceManager.jl",
    "title": "RessourceManager.GetPath",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/RessourceManager.html#RessourceManager.CurrentDay-Tuple{}",
    "page": "RessourceManager.jl",
    "title": "RessourceManager.CurrentDay",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/RessourceManager.html#RessourceManager.jl-1",
    "page": "RessourceManager.jl",
    "title": "RessourceManager.jl",
    "category": "section",
    "text": "RessourceManager.SetWorkingDir()RessourceManager.RessourcePath(path::AbstractString)RessourceManager.AddPath(id::Any, path::AbstractString)RessourceManager.GetPath(key::Any)RessourceManager.CurrentDay()"
},

{
    "location": "files/ThreadFunctions.html#",
    "page": "ThreadFunctions.jl",
    "title": "ThreadFunctions.jl",
    "category": "page",
    "text": ""
},

{
    "location": "files/ThreadFunctions.html#ThreadFunctions.jl-1",
    "page": "ThreadFunctions.jl",
    "title": "ThreadFunctions.jl",
    "category": "section",
    "text": "thread_println(t::ThreadManager.Thread, msg) = ThreadManager.safe_call(t, (x) -> print(msg))thread_push(t::ThreadManager.Thread, a, e) = ThreadManager.safe_call(t, (x) -> push!(a, e))thread_sleep(sec::Real) = Libc.systemsleep(sec)thread_init(p::Tuple{String,Function}) = function(t::ThreadManager.Thread)\r\n	thread_println(t, LogManager.logMsg(:Debug, p[1], \"start\"))\r\n	p[2](t)\r\nend"
},

{
    "location": "files/ThreadManager.html#",
    "page": "ThreadManager.jl",
    "title": "ThreadManager.jl",
    "category": "page",
    "text": ""
},

{
    "location": "files/ThreadManager.html#ThreadManager.Thread",
    "page": "ThreadManager.jl",
    "title": "ThreadManager.Thread",
    "category": "type",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/ThreadManager.html#ThreadManager.safe_call-Tuple{ThreadManager.Thread,Function}",
    "page": "ThreadManager.jl",
    "title": "ThreadManager.safe_call",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/ThreadManager.html#ThreadManager.reset-Tuple{}",
    "page": "ThreadManager.jl",
    "title": "ThreadManager.reset",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/ThreadManager.html#ThreadManager.run",
    "page": "ThreadManager.jl",
    "title": "ThreadManager.run",
    "category": "function",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/ThreadManager.html#ThreadManager.jl-1",
    "page": "ThreadManager.jl",
    "title": "ThreadManager.jl",
    "category": "section",
    "text": "ThreadManager.ThreadThreadManager.safe_call(t::ThreadManager.Thread, f::Function)ThreadManager.reset()ThreadManager.run(a = Function[])"
},

{
    "location": "files/TimeManager.html#",
    "page": "TimeManager.jl",
    "title": "TimeManager.jl",
    "category": "page",
    "text": ""
},

{
    "location": "files/TimeManager.html#TimeManager.now-Tuple{}",
    "page": "TimeManager.jl",
    "title": "TimeManager.now",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/TimeManager.html#TimeManager.programStartTime",
    "page": "TimeManager.jl",
    "title": "TimeManager.programStartTime",
    "category": "constant",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/TimeManager.html#TimeManager.currentTime-Tuple{Real}",
    "page": "TimeManager.jl",
    "title": "TimeManager.currentTime",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/TimeManager.html#TimeManager.programTime-Tuple{}",
    "page": "TimeManager.jl",
    "title": "TimeManager.programTime",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/TimeManager.html#TimeManager.programTimeStr-Tuple{}",
    "page": "TimeManager.jl",
    "title": "TimeManager.programTimeStr",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/TimeManager.html#TimeManager.OnTime-Tuple{Float64,Base.RefValue{Float64}}",
    "page": "TimeManager.jl",
    "title": "TimeManager.OnTime",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/TimeManager.html#TimeManager.jl-1",
    "page": "TimeManager.jl",
    "title": "TimeManager.jl",
    "category": "section",
    "text": "TimeManager.now()TimeManager.programStartTimeTimeManager.currentTime(startTime::Real)TimeManager.programTime()TimeManager.programTimeStr()TimeManager.OnTime(milisec::Float64, prevTime::Base.RefValue{Float64})"
},

{
    "location": "files/WindowManager.html#",
    "page": "WindowManager.jl",
    "title": "WindowManager.jl",
    "category": "page",
    "text": ""
},

{
    "location": "files/WindowManager.html#WindowManager.jl-1",
    "page": "WindowManager.jl",
    "title": "WindowManager.jl",
    "category": "section",
    "text": ""
},

{
    "location": "files/WindowManager.html#WindowManager.WindowHandler",
    "page": "WindowManager.jl",
    "title": "WindowManager.WindowHandler",
    "category": "type",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/WindowManager.html#WindowManager.getWindowHandler-Tuple{}",
    "page": "WindowManager.jl",
    "title": "WindowManager.getWindowHandler",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/WindowManager.html#WindowManager.setWindowHandler-Tuple{WindowManager.WindowHandler}",
    "page": "WindowManager.jl",
    "title": "WindowManager.setWindowHandler",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/WindowManager.html#WindowManager.terminate-Tuple{}",
    "page": "WindowManager.jl",
    "title": "WindowManager.terminate",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/WindowManager.html#WindowManager.setListener-Tuple{WindowManager.WindowHandler,Symbol,Function}",
    "page": "WindowManager.jl",
    "title": "WindowManager.setListener",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/WindowManager.html#WindowManager.OnWindowResize-Tuple{GLFW.Window,Number,Number}",
    "page": "WindowManager.jl",
    "title": "WindowManager.OnWindowResize",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/WindowManager.html#WindowManager.OnWindowIconify-Tuple{GLFW.Window,Number}",
    "page": "WindowManager.jl",
    "title": "WindowManager.OnWindowIconify",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/WindowManager.html#WindowManager.OnWindowClose-Tuple{GLFW.Window}",
    "page": "WindowManager.jl",
    "title": "WindowManager.OnWindowClose",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/WindowManager.html#WindowManager.OnWindowFocus-Tuple{GLFW.Window,Number}",
    "page": "WindowManager.jl",
    "title": "WindowManager.OnWindowFocus",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/WindowManager.html#WindowManager.OnWindowRefresh-Tuple{GLFW.Window}",
    "page": "WindowManager.jl",
    "title": "WindowManager.OnWindowRefresh",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/WindowManager.html#WindowManager.OnFramebufferResize-Tuple{GLFW.Window,Number,Number}",
    "page": "WindowManager.jl",
    "title": "WindowManager.OnFramebufferResize",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/WindowManager.html#WindowManager.OnCursorEnter-Tuple{GLFW.Window,Number}",
    "page": "WindowManager.jl",
    "title": "WindowManager.OnCursorEnter",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/WindowManager.html#WindowManager.OnDroppedFiles-Tuple{GLFW.Window,AbstractArray}",
    "page": "WindowManager.jl",
    "title": "WindowManager.OnDroppedFiles",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/WindowManager.html#WindowManager.OnWindowPos-Tuple{GLFW.Window,Number,Number}",
    "page": "WindowManager.jl",
    "title": "WindowManager.OnWindowPos",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/WindowManager.html#WindowManager.OnCursorPos-Tuple{GLFW.Window,Number,Number}",
    "page": "WindowManager.jl",
    "title": "WindowManager.OnCursorPos",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/WindowManager.html#WindowManager.OnScroll-Tuple{GLFW.Window,Number,Number}",
    "page": "WindowManager.jl",
    "title": "WindowManager.OnScroll",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/WindowManager.html#WindowManager.OnCharMods-Tuple{GLFW.Window,Char,Number}",
    "page": "WindowManager.jl",
    "title": "WindowManager.OnCharMods",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/WindowManager.html#WindowManager.OnUpdateEvents-Tuple{}",
    "page": "WindowManager.jl",
    "title": "WindowManager.OnUpdateEvents",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/WindowManager.html#WindowManager.OnKey-Tuple{GLFW.Window,Number,Number,Number,Number}",
    "page": "WindowManager.jl",
    "title": "WindowManager.OnKey",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/WindowManager.html#WindowManager.OnMouseKey-Tuple{GLFW.Window,Number,Number,Number}",
    "page": "WindowManager.jl",
    "title": "WindowManager.OnMouseKey",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/WindowManager.html#WindowManager.OnUnicodeChar-Tuple{GLFW.Window,Char}",
    "page": "WindowManager.jl",
    "title": "WindowManager.OnUnicodeChar",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/WindowManager.html#WindowManager.ShowError-Tuple{Bool}",
    "page": "WindowManager.jl",
    "title": "WindowManager.ShowError",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/WindowManager.html#WindowManager.OnEvent-Tuple{WindowManager.WindowHandler,Symbol,Vararg{Any,N} where N}",
    "page": "WindowManager.jl",
    "title": "WindowManager.OnEvent",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/WindowManager.html#WindowManager.title-Tuple{WindowManager.WindowHandler,String}",
    "page": "WindowManager.jl",
    "title": "WindowManager.title",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/WindowManager.html#WindowManager.cursor-Tuple{WindowManager.WindowHandler,Symbol}",
    "page": "WindowManager.jl",
    "title": "WindowManager.cursor",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/WindowManager.html#WindowManager.fullscreen-Tuple{WindowManager.WindowHandler,Bool}",
    "page": "WindowManager.jl",
    "title": "WindowManager.fullscreen",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/WindowManager.html#WindowManager.SetWindowMonitor-Tuple{GLFW.Window,GLFW.Monitor,Any,Any,Any,Any,Any}",
    "page": "WindowManager.jl",
    "title": "WindowManager.SetWindowMonitor",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/WindowManager.html#WindowManager.open",
    "page": "WindowManager.jl",
    "title": "WindowManager.open",
    "category": "function",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/WindowManager.html#WindowManager.isClosing-Tuple{GLFW.Window}",
    "page": "WindowManager.jl",
    "title": "WindowManager.isClosing",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/WindowManager.html#WindowManager.create-Tuple{AbstractString,Tuple{Number,Number}}",
    "page": "WindowManager.jl",
    "title": "WindowManager.create",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/WindowManager.html#WindowManager.close-Tuple{WindowManager.WindowHandler}",
    "page": "WindowManager.jl",
    "title": "WindowManager.close",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/WindowManager.html#WindowManager.swap-Tuple{WindowManager.WindowHandler}",
    "page": "WindowManager.jl",
    "title": "WindowManager.swap",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/WindowManager.html#WindowManager.update-Tuple{WindowManager.WindowHandler}",
    "page": "WindowManager.jl",
    "title": "WindowManager.update",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/WindowManager.html#WindowManager.loop-Tuple{WindowManager.WindowHandler,Function}",
    "page": "WindowManager.jl",
    "title": "WindowManager.loop",
    "category": "method",
    "text": "Loop until the user closes the window \n\n\n\n"
},

{
    "location": "files/WindowManager.html#import-1",
    "page": "WindowManager.jl",
    "title": "import",
    "category": "section",
    "text": "GLFW.jl - Docs here\nGLFW.WindowWindowManager.WindowHandlerWindowManager.getWindowHandler()WindowManager.setWindowHandler(this::WindowManager.WindowHandler)WindowManager.terminate()WindowManager.setListener(this::WindowManager.WindowHandler, key::Symbol, listener::Function)WindowManager.OnWindowResize(window::WindowManager.Window, width::Number, height::Number)WindowManager.OnWindowIconify(window::WindowManager.Window, iconified::Number)WindowManager.OnWindowClose(window::WindowManager.Window)WindowManager.OnWindowFocus(window::WindowManager.Window, focused::Number)WindowManager.OnWindowRefresh(window::WindowManager.Window)WindowManager.OnFramebufferResize(window::WindowManager.Window, width::Number, height::Number)WindowManager.OnCursorEnter(window::WindowManager.Window, entered::Number)WindowManager.OnDroppedFiles(window::WindowManager.Window, files::AbstractArray)WindowManager.OnWindowPos(window::WindowManager.Window, x::Number, y::Number)WindowManager.OnCursorPos(window::WindowManager.Window, x::Number, y::Number)WindowManager.OnScroll(window::WindowManager.Window, x::Number, y::Number)WindowManager.OnCharMods(window::WindowManager.Window, code::Char, mods::Number)WindowManager.OnUpdateEvents()WindowManager.OnKey(window::WindowManager.Window, key::Number, scancode::Number, action::Number, mods::Number)WindowManager.OnMouseKey(window::WindowManager.Window, key::Number, action::Number, mods::Number)WindowManager.OnUnicodeChar(window::WindowManager.Window, unicode::Char)WindowManager.ShowError(debugging::Bool)WindowManager.OnEvent(this::WindowManager.WindowHandler, eventName::Symbol, args...)WindowManager.title(this::WindowManager.WindowHandler, name::String)WindowManager.cursor(this::WindowManager.WindowHandler, mode::Symbol)WindowManager.fullscreen(this::WindowManager.WindowHandler, full::Bool)WindowManager.SetWindowMonitor(window::WindowManager.Window, monitor::GLFW.Monitor, xpos, ypos, width, height, refreshRate)WindowManager.open(this::WindowManager.WindowHandler, windowhints=[])WindowManager.isClosing(this::WindowManager.Window)WindowManager.create(name::AbstractString, size::Tuple{Number,Number})WindowManager.close(this::WindowManager.WindowHandler)WindowManager.swap(this::WindowManager.WindowHandler)WindowManager.update(this::WindowManager.WindowHandler)WindowManager.loop(this::WindowManager.WindowHandler, repeat::Function)"
},

{
    "location": "files/JLGEngine.html#",
    "page": "JLGEngine.jl",
    "title": "JLGEngine.jl",
    "category": "page",
    "text": ""
},

{
    "location": "files/JLGEngine.html#JLGEngine.jl-1",
    "page": "JLGEngine.jl",
    "title": "JLGEngine.jl",
    "category": "section",
    "text": "Includes Core files\nIncludes Engine files\nCode"
},

{
    "location": "files/JLGEngine.html#Includes-Core-files-1",
    "page": "JLGEngine.jl",
    "title": "Includes Core files",
    "category": "section",
    "text": "CoreExtended.jl\nTimeManager.jl\nLoggerManager.jl\nRessourceManager.jl\nFileManager.jl\nEnvironment.jl\nJLScriptManager.jl\nWindowManager.jl\nMatrixMath.jl"
},

{
    "location": "files/JLGEngine.html#Includes-Engine-files-1",
    "page": "JLGEngine.jl",
    "title": "Includes Engine files",
    "category": "section",
    "text": "LibGL.jl\nGraphicsManager.jl\nManagement.jl\nStorageManager.jl\nMeshManager.jl\nModelManager.jl\nShaderManager.jl\nTransformManager.jl\nEntityManager.jl\nCameraManager.jl\nTextureManager.jl\nGameObjectManager.jl\nRenderManager.jl"
},

{
    "location": "files/JLGEngine.html#JLGEngine.IComponent",
    "page": "JLGEngine.jl",
    "title": "JLGEngine.IComponent",
    "category": "type",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/JLGEngine.html#JLGEngine.init-Tuple{}",
    "page": "JLGEngine.jl",
    "title": "JLGEngine.init",
    "category": "method",
    "text": "TODO \n\n\n\n"
},

{
    "location": "files/JLGEngine.html#Code-1",
    "page": "JLGEngine.jl",
    "title": "Code",
    "category": "section",
    "text": "JLGEngine.IComponentJLGEngine.init()"
},

{
    "location": "files/JLGEngine/CameraManager.html#",
    "page": "CameraManager.jl",
    "title": "CameraManager.jl",
    "category": "page",
    "text": ""
},

{
    "location": "files/JLGEngine/CameraManager.html#CameraManager.jl-1",
    "page": "CameraManager.jl",
    "title": "CameraManager.jl",
    "category": "section",
    "text": "using CoreExtended using MatrixMath using JLGEngineusing ..TransformManagerconst Transform = TransformManager.Typtype Camera <: JLGEngine.IComponent\r\n	id::Symbol\r\n	transform::Transform\r\n\r\n	ortho::Bool\r\n	fov::Float32\r\n	ratio::Float32\r\n	depth::Vec2f\r\n\r\n  viewport::Vec4f\r\n\r\n  viewMat::Mat4x4f\r\n  projectionMat::Mat4x4f\r\n	modelMat::Mat4x4f\r\n\r\n	translateMat::Mat4x4f\r\n	rotationMat::Mat4x4f\r\n	scalingMat::Mat4x4f\r\n\r\n	mvpMat::Mat4x4f\r\n\r\n	Camera(id=:_) = new(id,nothing,false,0,0,Vec2f(0,1),zeros(Vec4f),IMat4x4f,IMat4x4f,IMat4x4f,IMat4x4f,IMat4x4f,IMat4x4f,IMat4x4f)\r\nendfunction init(this::Camera)\r\n	this.transform=TransformManager.create(this.id)\r\nendfunction zoom(this::Camera, zf::Float32)\r\n	this.transform.scaling = ones(Vec3f) * (1+zoom*0.01f0)\r\nendfunction updateTranslation(this::Camera)\r\n	this.translateMat = MatrixMath.translationmatrix(this.transform.position)\r\nendfunction updateRotation(this::Camera)\r\n	this.rotationMat = MatrixMath.computeRotation(this.transform.rotation)\r\nendfunction updateScaling(this::Camera)\r\n	this.scalingMat = MatrixMath.scalingmatrix(this.transform.scaling)\r\nendfunction updateView(this::Camera)\r\n	updateTranslation(this)\r\n	updateRotation(this)\r\n	updateScaling(this)\r\n	this.viewMat = this.rotationMat * this.translateMat * this.scalingMat\r\nendfunction setRatio(this::Camera, ratio::Float32)\r\n	this.ratio=ratio\r\nendfunction setPerspective(this::Camera, fov::Float32,ratio::Float32,near::Float32,far::Float32, ortho=false) #(60.0f0, Float32(windowsize[1]/windowsize[2]), 0.1f0, 10.0f0)\r\n	this.fov=fov\r\n	this.ratio=ratio\r\n	this.depth=Vec2f(near,far)\r\n	this.ortho=ortho\r\nendfunction updateProjection(this::Camera)\r\n	if !this.ortho this.projectionMat = MatrixMath.perspectiveprojection(this.fov, this.ratio, this.depth[1], this.depth[2])\r\n	else this.projectionMat = MatrixMath.orthographicprojection(this.fov, this.ratio, this.depth[1], this.depth[2])\r\n	end\r\nendfunction updateMVP(this::Camera)\r\n	this.mvpMat = this.projectionMat * this.viewMat * this.modelMat\r\nendfunction updateModel(this::Camera, transform::Transform)\r\n	if transform == nothing return end\r\n	this.modelMat = MatrixMath.translationmatrix(transform.position) * MatrixMath.computeRotation(transform.rotation) * MatrixMath.scalingmatrix(transform.scaling)\r\nendfunction update(this::Camera, transform::Transform)\r\n	updateProjection(this)\r\n	updateView(this)\r\n	updateModel(this, transform)\r\n	updateMVP(this)\r\nend"
},

{
    "location": "files/JLGEngine/ChunkManager.html#",
    "page": "ChunkManager.jl",
    "title": "ChunkManager.jl",
    "category": "page",
    "text": ""
},

{
    "location": "files/JLGEngine/ChunkManager.html#ChunkManager.jl-1",
    "page": "ChunkManager.jl",
    "title": "ChunkManager.jl",
    "category": "section",
    "text": ""
},

{
    "location": "files/JLGEngine/EntityManager.html#",
    "page": "EntityManager.jl",
    "title": "EntityManager.jl",
    "category": "page",
    "text": ""
},

{
    "location": "files/JLGEngine/EntityManager.html#EntityManager.jl-1",
    "page": "EntityManager.jl",
    "title": "EntityManager.jl",
    "category": "section",
    "text": "using ..Management using CoreExtended using MatrixMath using JLGEnginetype Entity <: JLGEngine.IComponent\r\n	id::Symbol\r\n	enabled::Bool\r\n\r\n  position::Vec3f\r\n  rotation::Vec3f\r\n	scaling::Vec3f\r\n\r\n	Entity(id=:_) = new(id,true,zeros(Vec3f),zeros(Vec3f),ones(Vec3f))\r\nend"
},

{
    "location": "files/JLGEngine/GameObjectManager.html#",
    "page": "GameObjectManager.jl",
    "title": "GameObjectManager.jl",
    "category": "page",
    "text": ""
},

{
    "location": "files/JLGEngine/GameObjectManager.html#GameObjectManager.jl-1",
    "page": "GameObjectManager.jl",
    "title": "GameObjectManager.jl",
    "category": "section",
    "text": "using CoreExtended using JLGEngine using ..ManagementIComponent = JLGEngine.IComponenttype GameObject <: IComponent\r\n	id::Symbol\r\n	enabled::Bool\r\n	components::SortedDict{Symbol, IComponent}\r\n	\r\n	#transform::Transform\r\n\r\n	GameObject(id=:_) = new(id,true,SortedDict{Symbol, IComponent}(Forward))\r\nendsetComponent(this::GameObject, c::IComponent) = (this.components[k] = c; c.gameObject=this)getComponent(this::GameObject, T::DataType) = getComponents(this, T).firstfunction getComponents(this::GameObject, T::DataType)\r\n	components = SortedDict{Symbol, IComponent}(Forward)\r\n	for (k,v) in this.components\r\n		if typeof(v) == T\r\n			components[k] = v\r\n		end\r\n	end\r\n	components\r\nend"
},

{
    "location": "files/JLGEngine/GraphicsManager.html#",
    "page": "GraphicsManager.jl",
    "title": "GraphicsManager.jl",
    "category": "page",
    "text": ""
},

{
    "location": "files/JLGEngine/GraphicsManager.html#GraphicsManager.jl-1",
    "page": "GraphicsManager.jl",
    "title": "GraphicsManager.jl",
    "category": "section",
    "text": "using FileManager using FileIO.queryabstract type IGraphicsReference endabstract type IGraphicsData <: IGraphicsReference endabstract type IGraphicsShaderProgram <: IGraphicsReference endabstract type IGraphicsShader <: IGraphicsReference endabstract type IGraphicsShaderProperty <: IGraphicsReference end\r\n\r\nexport AbstractGraphicsReference\r\nexport AbstractGraphicsData\r\nexport AbstractGraphicsShaderProgram\r\nexport AbstractGraphicsShader\r\nexport AbstractGraphicsShaderPropertyAbstractGraphicsReference = Union{Void,IGraphicsReference}AbstractGraphicsData = Union{Void,IGraphicsData}AbstractGraphicsShaderProgram = Union{Void,IGraphicsShaderProgram}AbstractGraphicsShader = Union{Void,IGraphicsShader}AbstractGraphicsShaderProperty = Union{Void,IGraphicsShaderProperty}type Manager\r\n	handle ::Any\r\n	Manager() = new()\r\nend\r\n\r\nMANAGER = Manager()setGraphicsDriver(o::Any) = (MANAGER.handle = o)getGraphicsDriver() = MANAGER.handleGRAPHICSDRIVER() = getGraphicsDriver()"
},

{
    "location": "files/JLGEngine/Management.html#",
    "page": "Management.jl",
    "title": "Management.jl",
    "category": "page",
    "text": ""
},

{
    "location": "files/JLGEngine/Management.html#Management.jl-1",
    "page": "Management.jl",
    "title": "Management.jl",
    "category": "section",
    "text": "using CoreExtendedabstract type IManagerReference endtype Manager{T} <: IManagerReference\r\n	list::SortedDict{Symbol, T}\r\n	selected::Union{Void,T}\r\n	\r\n	create::Function\r\n	remove::Function\r\n	init::Function\r\n	reset::Function\r\n	link::Function\r\n	unlink::Function\r\n	\r\n	Manager{T}() where T = new(\r\n		SortedDict{Symbol, T}(Forward),\r\n		nothing,\r\n		(id::Symbol) -> T(id),\r\n		(obj::T) -> nothing,\r\n		(obj::T) -> nothing,\r\n		() -> nothing,\r\n		(obj::T) -> nothing,\r\n		() -> nothing\r\n	)\r\nendfunction presetManager(T::DataType)\r\n	m=createManager(T)\r\n	\r\n	eval(T.name.module,Expr(:toplevel,:(\r\n		m=Management.list[Symbol($(T.name))];\r\n		const Typ = Management.getType(m);\r\n\r\n		create(k) = Management.create(m,k);\r\n		getSelected() = Management.getSelected(m);\r\n		setSelected(o) = Management.setSelected(m,o);\r\n\r\n		get(k) =  Management.get(m,k);\r\n		set(k,o) = Management.set(m,k,o);\r\n		del(k) = Management.del(m,k);\r\n\r\n		reset() = Management.reset(m);\r\n\r\n		isInvalid(o) = Management.isInvalid(m,o);\r\n		isLinked(o) = Management.isLinked(m,o);\r\n\r\n		link() = Management.link(m);\r\n		unlink() = Management.unlink(m);\r\n\r\n		select(o) = Management.select(m,o);\r\n	)))\r\n	\r\n	m\r\nendfunction createManager(T::DataType)\r\n	k = Symbol(T.name)\r\n	if !haskey(list,k)\r\n		e=Manager{T}()\r\n		list[k]=e\r\n	else\r\n		e=list[k]\r\n	end\r\n	e\r\nendfunction create{T}(m::Manager{T}, k::Symbol)\r\n	if !haskey(m.list,k)\r\n		e=m.create(k)\r\n		m.list[k]=e\r\n		setSelected(m,e)\r\n		m.init(e)\r\n	else\r\n		e=m.list[k]\r\n		setSelected(m,e)\r\n	end\r\n	e\r\nendgetSelected{T}(m::Manager{T}) = m.selectedsetSelected{T}(m::Manager{T}, obj::Union{Void,T}) = (m.selected = obj)getType{T}(m::Manager{T}) = Union{Void,T}get{T}(m::Manager{T}, k::Symbol) = m.list[k]set{T}(m::Manager{T}, k::Symbol, obj::Union{Void,T}) = (m.list[k] = obj)function del{T}(m::Manager{T}, k::Symbol)\r\n	obj=get(m,k)\r\n	selected=getSelected(m)\r\n	if selected == obj unlink() end\r\n	m.remove(obj)\r\n	set(m,k,nothing)\r\nendfunction reset{T}(m::Manager{T})\r\n	unlink(m)\r\n	m.reset()\r\nend;isInvalid{T}(m::Manager{T}, obj::Union{Void,T}) = obj == nothingisLinked{T}(m::Manager{T}, obj::Union{Void,T}) =	!isInvalid(m,obj) && obj == getSelected(m)unlink{T}(m::Manager{T}) = (setSelected(m,nothing); m.unlink())function link{T}(m::Manager{T})\r\n	obj=getSelected(m)\r\n	if !isInvalid(m,obj) m.link(obj)\r\n	else unlink()\r\n	end\r\nendfunction select{T}(m::Manager{T}, obj::Union{Void,T})\r\n	other=getSelected(m)\r\n	if other == obj return end\r\n	setSelected(m,obj)\r\n	link(m)\r\nend"
},

{
    "location": "files/JLGEngine/MeshManager.html#",
    "page": "MeshManager.jl",
    "title": "MeshManager.jl",
    "category": "page",
    "text": ""
},

{
    "location": "files/JLGEngine/MeshManager.html#MeshManager.jl-1",
    "page": "MeshManager.jl",
    "title": "MeshManager.jl",
    "category": "section",
    "text": "using CoreExtended using FileManager using ..StorageManagertype Mesh\r\n	typ::Symbol\r\n	vertices::StorageGroup\r\n	normals::StorageGroup\r\n	uvs::StorageGroup\r\n	indicies::StorageGroup\r\n\r\n	function Mesh()\r\n		this=new(:_)\r\n		clear(this)\r\n	end\r\nendfunction clear(mesh::Mesh)\r\n	mesh.vertices = StorageManager.StorageGroup(:DATA, :VERTEX)\r\n	mesh.uvs = StorageManager.StorageGroup(:DATA, :UV)\r\n	mesh.normals = StorageManager.StorageGroup(:DATA, :NORMAL)\r\n	mesh.indicies = StorageManager.StorageGroup(:DATA, :INDEX)\r\n	mesh\r\nendisEmpty(mesh::Mesh) = isEmptyVertices(mesh) && isEmptyUVs(mesh) && isEmptyNormals(mesh) && isEmptyIndicies(mesh)isEmptyVertices(mesh::Mesh) = length(mesh.vertices.data.values) == 0isEmptyUVs(mesh::Mesh) = length(mesh.uvs.data.values) == 0isEmptyNormals(mesh::Mesh) = length(mesh.normals.data.values) == 0isEmptyIndicies(mesh::Mesh) = length(mesh.indicies.data.values) == 0function update(mesh::Mesh, typ::Symbol, values::AbstractArray, elems=0)\r\n	mesh.typ = typ\r\n	if length(values)>0	StorageManager.setValues(mesh.vertices, values, elems, :TRIANGLES) end\r\n	mesh\r\nendfunction update(mesh::Mesh, typ::Symbol, f::Function)\r\n	data = f()\r\n	mesh.typ = typ\r\n\r\n	drawtyp	= data[1]\r\n	vertices = data[2]\r\n	normals	= data[3]\r\n	uvs = data[4]\r\n	indicies = data[5]\r\n\r\n	if length(vertices)>0 StorageManager.setValues(mesh.vertices, vertices, 3, drawtyp) end\r\n	if length(uvs)>0 StorageManager.setValues(mesh.uvs, uvs, 2, drawtyp) end\r\n	if length(normals)>0 StorageManager.setValues(mesh.normals, normals, 3, drawtyp) end\r\n	if length(indicies)>0	StorageManager.setValues(mesh.indicies, indicies, 1, drawtyp)	end\r\n\r\n	mesh\r\nend"
},

{
    "location": "files/JLGEngine/ModelManager.html#",
    "page": "ModelManager.jl",
    "title": "ModelManager.jl",
    "category": "page",
    "text": ""
},

{
    "location": "files/JLGEngine/ModelManager.html#ModelManager.jl-1",
    "page": "ModelManager.jl",
    "title": "ModelManager.jl",
    "category": "section",
    "text": "using CoreExtended using FileManager using JLGEngineusing ..GraphicsManager using ..StorageManager using ..MeshManagerconst Mesh = MeshManager.Typtype Model <: JLGEngine.IComponent\r\n	id::Symbol\r\n	name::String\r\n\r\n	enabled::Bool\r\n	linked::Bool\r\n	loaded ::Bool\r\n\r\n	source::FileSource\r\n\r\n	meshes::Dict{Symbol, Mesh}\r\n	group::StorageGroup\r\n	mainStorage::StorageGroup\r\n\r\n	Model(id=:_) = (g=StorageGroup(); new(id, \"\",true,false,false,FileSource(),Dict(),g,g))\r\nendsetMainBuffer(this::Model, storage::StorageGroup) = this.mainStorage = storagegetMainBuffer(this::Model) = this.mainStoragelink(this::Model) = StorageManager.link(this.group)function init(this::Model)\r\nendfunction upload(this::Model)\r\n	if this.loaded return end\r\n	prepare(this::Model,this.meshes[:DEFAULT])\r\n	StorageManager.upload(this.group)\r\n	this.loaded=true\r\nendfunction unload(this::Model)\r\n	if !this.loaded return end\r\n	# ....\r\n	this.loaded=false\r\nendfunction resets()\r\n	GRAPHICSDRIVER().resetBuffers()\r\nendfunction getGroup(this::Model, k::Symbol)\r\n	r = nothing\r\n	if k == :VERTEX || k == :UV || k == :NORMAL\r\n		r = StorageManager.getGroup(this.group.list[:VB].list[:VBO],k)\r\n	elseif  k == :INDEX\r\n		r = StorageManager.getGroup(this.group.list[:IB].list[:IBO],k)\r\n	end\r\n	r\r\n	#StorageManager.getData(getMainBuffer(this),k)\r\nendfunction getData(this::Model, k::Symbol)\r\n	r = getGroup(this,k)\r\n	if r != nothing r=r.data end #StorageManager.getValues\r\n	r\r\nendfunction getBuffer(this::Model, k::Symbol)\r\n	#.....\r\nendinclude(\"ModelManager/MeshFabric.jl\")"
},

{
    "location": "files/JLGEngine/RenderManager.html#",
    "page": "RenderManager.jl",
    "title": "RenderManager.jl",
    "category": "page",
    "text": ""
},

{
    "location": "files/JLGEngine/RenderManager.html#RenderManager.jl-1",
    "page": "RenderManager.jl",
    "title": "RenderManager.jl",
    "category": "section",
    "text": "using CoreExtended using ..GraphicsManager using ..StorageManager using ..ModelManager using ..CameraManager using ..TransformManager using ..ShaderManager using ..TextureManager using ..GameObjectManagerconst Transform=TransformManager.Typ const Model=ModelManager.Typ const Camera=CameraManager.Typ const Texture=TextureManager.Typ const ShaderProgram=ShaderManager.Typconst DEFAULT_FUNCTION = ()->nothingOnPreDraw = DEFAULT_FUNCTIONOnPostDraw = DEFAULT_FUNCTIONOnPreRender = DEFAULT_FUNCTIONOnPostRender = DEFAULT_FUNCTIONOnRender = DEFAULT_FUNCTIONfunction setOnDraw(f1::Union{Void,Function}, f2::Union{Void,Function})\r\n	global OnPreDraw = f1 != nothing ? f1 : DEFAULT_FUNCTION\r\n	global OnPostDraw = f2 != nothing ? f2 : DEFAULT_FUNCTION\r\nendfunction setOnRender(f1::Union{Void,Function}, f2::Union{Void,Function}, f3::Union{Void,Function})\r\n	global OnPreRender = f1 != nothing ? f1 : DEFAULT_FUNCTION\r\n	global OnPostRender = f2 != nothing ? f2 : DEFAULT_FUNCTION\r\n	global OnRender = f3 != nothing ? f3 : DEFAULT_FUNCTION\r\nendtype RenderGroup\r\n	enabled::Bool\r\n	transform::Transform\r\n	model::Model\r\n	shaderProgram::ShaderProgram\r\n	textures::Dict{Symbol,Texture}\r\n	modes::Dict{Symbol,Any}\r\nendtype RenderGroups\r\n	enabled::Bool\r\n	camera::Camera\r\n	groups::SortedDict{Symbol,RenderGroup}\r\nendtype Renderer\r\n	id::Symbol\r\n	#gameObject::GameObject\r\n	\r\n	order::Symbol\r\n	enabled::Bool\r\n	transform::Transform\r\n	model::Model\r\n	camera::Camera\r\n	shaderProgram::ShaderProgram\r\n	textures::Dict{Symbol,Texture}\r\n	modes::Dict{Symbol,Any}\r\n	setModes::Function\r\n	\r\n	function Renderer(id=:_)\r\n		#obj=GameObjectManager.create(id)\r\n		this=new(id,:_,true,nothing,nothing,nothing,nothing,Dict(),Dict(),()->nothing)\r\n		#GameObjectManager.setComponent(obj,this)\r\n		this\r\n	end\r\nendfunction link(this::Renderer)\r\n	ModelManager.linkTo(this.model)\r\n	ShaderManager.linkTo(this.shaderProgram)\r\n	if this.camera != nothing CameraManager.update(this.camera, this.transform) end\r\nendfunction register(this::Renderer)\r\n	this.model = ModelManager.getSelected()\r\n	this.camera = CameraManager.getSelected()\r\n	this.shaderProgram = ShaderManager.getSelected()\r\n	#RenderManager.createShaderProgram(:FG, \"shaders/default.glsl\")\r\nendfunction addTexture(this::Renderer, path::String)\r\n	id=Symbol(path)\r\n	texture = TextureManager.create(id)\r\n	this.textures[id] = texture\r\n	TextureManager.load(texture, path)\r\n	texture\r\nendfunction update()\r\n	ShaderManager.watchShaderReload(RenderManager.reload)\r\nendfunction init(this::Renderer)\r\n	setMode(this, :POLYGONMODE,[:FRONT_AND_BACK,:FILL])\r\n	this.transform=TransformManager.create(this.id)\r\nendfunction render()\r\n	OnPreRender()\r\n	OnRender()\r\n	OnPostRender()\r\nendfunction render(this::Renderer)\r\n	if !this.enabled return end\r\n	setSelected(this)\r\n	link() # shaderprogram, model, texture, ...\r\n	getShaderProperties(this) 	# set propberties\r\n	#this.setModes()\r\n	OnPreDraw()\r\n	draw(this)\r\n	OnPostDraw()\r\nendfunction resets()\r\n	ModelManager.reset()\r\n	ShaderManager.reset()\r\nendfunction unlinks()\r\n	ModelManager.unlink()\r\n	ShaderManager.unlink()\r\nend\r\n\r\n# preset for manager: includes code here\r\npresetManager(Renderer)\r\n\r\nuseSortedList = false\r\nrenderSortedList(use::Bool) = (global useSortedList = use)renderDefault() = for (_,this) in list; render(this); endrenderAll = DEFAULT_FUNCTIONfunction start()\r\n	reset()\r\n	RenderManager.reload()\r\n	\r\n	# shader reload\r\n	for (k,this) in list\r\n		if this.shaderProgram != nothing ShaderManager.reload(this.shaderProgram) end\r\n	end\r\nendfunction reload()\r\n	if !useSortedList\r\n		renderAll = stabilize(renderDefault)\r\n	else\r\n		#all=Expr(:block,:())\r\n\r\n		sortedList=SortedDict{Symbol, Array{Renderer,1}}(Forward)\r\n\r\n		order=0\r\n		for (k,this) in list\r\n			order+=1\r\n			ex=:()\r\n			for (k,v) in this.modes\r\n				ex=:($(ex.args...); $(GRAPHICSDRIVER().getMode(k,v).args...);)\r\n			end\r\n\r\n			this.setModes=()->nothing #eval(:(function(); $(ex.args...); end;))\r\n\r\n			if this.order == :_ this.order=Symbol(order) end\r\n			if !haskey(sortedList,this.order) sortedList[this.order]=Array{Renderer,1}(); end\r\n			push!(sortedList[this.order], this)\r\n		end\r\n\r\n		global renderAll = stabilize(eval(:(function();\r\n			for (_,a) in $sortedList; for this in a; render(this); end; end;\r\n		end;)))\r\n		println(\"sortedList generated.\")\r\n	end\r\n	\r\n	global OnRender = OnRender != DEFAULT_FUNCTION ? OnRender : renderAll\r\nendfunction copy(l::Renderer,r::Renderer)\r\n	l.model = r.model\r\n	l.camera = r.camera\r\n	l.transform = r.transform\r\n	l.shaderProgram = r.shaderProgram\r\nendfunction unlink(typ::DataType)\r\n	#obj = typ == Camera ? EMPTY_CAMERA : (typ == Model ? EMPTY_MODEL : (typ == Model ? nothing : nothing))\r\n	if obj != nothing link(obj) end\r\nendfunction link(ent::Transform)\r\n	this = getSelected()\r\n	this.transform = ent\r\nendfunction link(camera::Camera)\r\n	this = getSelected()\r\n	this.camera = camera\r\nendfunction link(model::Model)\r\n	this = getSelected()\r\n	this.model = model\r\nendfunction link(program::ShaderProgram)\r\n	this = getSelected()\r\n	this.shaderProgram = program\r\nendis(id::Symbol) = RenderManager.getSelected().id == idisTransform(id::Symbol) = RenderManager.getSelected().transform.id == idisModel(id::Symbol) = RenderManager.getSelected().model.id == idisCamera(id::Symbol) = RenderManager.getSelected().camera.id == idgetMVP() = RenderManager.getSelected().camera.mvpMatgetData(k::Symbol) = ModelManager.getData(getSelected().model,k)function init()\r\n	ShaderManager.setListenerOnShaderPropertyUpdate(:OnShaderPropertyUpdateAttributes, (\r\n		\"iVertex\" => () ->  getData(:VERTEX)\r\n		,\"iUV\" => () -> (d=getData(:UV); d != nothing ? d : getData(:VERTEX))\r\n		,\"iNormal\" => () -> (d=getData(:NORMAL); d != nothing ? d : getData(:VERTEX))\r\n		)\r\n	)\r\nendfunction getShaderProperties(this::Renderer)\r\n	ShaderManager.getShaderProperties(this.shaderProgram, ModelManager.getMainBuffer(this.model).data)\r\nendsetRenderMode(this::Renderer, mode::Symbol) = GRAPHICSDRIVER().update(ModelManager.getGroup(this.model,:VERTEX).data, mode)setMode(this::Renderer, mode::Symbol, value::Any) = this.modes[mode]=valuesetRenderMode(mode::Symbol) = setRenderMode(getSelected(), mode)setMode(mode::Symbol, value::Any) = GRAPHICSDRIVER().setMode(mode,value)function draw(this::Renderer)\r\n	model=this.model\r\n	buffer=ModelManager.getMainBuffer(model)\r\n	if model.enabled && ModelManager.isLinked(model) && buffer != nothing && buffer.data != nothing && (data=StorageManager.getData(buffer, 1)) != nothing\r\n		ShaderManager.render(this.shaderProgram, buffer.data, data)\r\n	end\r\nend"
},

{
    "location": "files/JLGEngine/ShaderManager.html#",
    "page": "ShaderManager.jl",
    "title": "ShaderManager.jl",
    "category": "page",
    "text": ""
},

{
    "location": "files/JLGEngine/ShaderManager.html#ShaderManager.jl-1",
    "page": "ShaderManager.jl",
    "title": "ShaderManager.jl",
    "category": "section",
    "text": "using CoreExtended using FileManager using JLGEngineusing ..GraphicsManagerAPI = nothingfunction init()\r\n	global API = GRAPHICSDRIVER().ShaderManager\r\nendtype ShaderProgram <: JLGEngine.IComponent\r\n	id::Symbol\r\n  source::FileSource\r\n	obj::AbstractGraphicsShaderProgram\r\n	ShaderProgram(id=:_) = new(id,FileSource(),API.createShaderProgram())\r\n	ShaderProgram(obj::AbstractGraphicsShaderProgram) = new(:_,FileSource(),obj)\r\nendfunction init(this::ShaderProgram)\r\nendfunction resets()\r\n	API.reset()\r\nendfunction unlinks()\r\n	API.unlink()\r\nendfunction link(this::ShaderProgram)\r\n	API.link(this.obj)\r\nendgetSource(this::ShaderProgram) = this.sourcesetPath(this::ShaderProgram, path::String) = (this.source.path = path)listenReload(this::ShaderProgram, f::Function) =\r\n	registerFileUpdate(getSource(this), (source::FileSource,p) -> push!(listWatchShaderProgram, (p,f)), this)function watchShaderReload(OnReload=()->nothing)\r\n	global listWatchShaderProgram\r\n	count=length(listWatchShaderProgram)\r\n	if count != 0\r\n		println(\"Reload Shaders ($count)...\")\r\n		for t in listWatchShaderProgram\r\n			p = t[1]\r\n			f = t[2]\r\n			reload(p)\r\n			if isa(f, Function) execute(f,p) end\r\n		end\r\n		listWatchShaderProgram = []\r\n		OnReload()\r\n	end\r\nendfunction create(name::Symbol, path::String, listen::Union{Void,Function}=nothing)\r\n	exists = haskey(list,name)\r\n	this = create(name)\r\n	if !exists\r\n		setPath(this, path)\r\n		if listen != nothing listenReload(this, listen) end\r\n	end\r\n	this\r\nendsetListenerOnShaderPropertyUpdate(name::Symbol, listen::Tuple) = API.setListenerOnShaderPropertyUpdate(name, listen)getShaderProperties(program::ShaderProgram, buffer::AbstractGraphicsData) = API.getShaderProperties(program.obj, buffer)render(program::ShaderProgram, buffer::AbstractGraphicsData, data::AbstractGraphicsData) = API.render(program.obj, buffer, data)\r\nreload(program::ShaderProgram) = API.reload(program.obj, program.source) ```"
},

{
    "location": "files/JLGEngine/StorageManager.html#",
    "page": "StorageManager.jl",
    "title": "StorageManager.jl",
    "category": "page",
    "text": ""
},

{
    "location": "files/JLGEngine/StorageManager.html#StorageManager.jl-1",
    "page": "StorageManager.jl",
    "title": "StorageManager.jl",
    "category": "section",
    "text": "using ..GraphicsManagerAPI = nothingtype StorageGroup\r\n	id::Symbol\r\n	data::AbstractGraphicsData\r\n	list::ObjectIdDict #Dict{Symbol,StorageGroup}\r\n	StorageGroup() = new(:_, nothing, ObjectIdDict())\r\n	StorageGroup(typ::Symbol, subtyp::Symbol,id=:_) = new(id, API.create(typ,subtyp),ObjectIdDict())\r\nendfunction init()\r\n	global API = GRAPHICSDRIVER().StorageManager\r\nendfunction create(this::StorageGroup, id::Symbol, typ::Symbol, subtyp::Symbol)\r\n	println(\"Create $id $typ $subtyp\")\r\n	haskey(this.list, id) ? this.list[id] : this.list[id]=StorageGroup(typ, subtyp, id)\r\nendlink(this::StorageGroup, child::StorageGroup, id::Symbol) = (child.id=id;this.list[id]=child)clean(this::StorageGroup) = API.clean(this.data)getGroup(this::StorageGroup, id::Symbol) = haskey(this.list, id) ? this.list[id] : nothinggetData(this::StorageGroup, id::Symbol) = haskey(this.list, id) ? this.list[id].data : nothing\r\nfunction getData(this::StorageGroup, id::Integer)\r\n	c=collect(keys(this.list))\r\n	v=length(c)>=id ? get(this.list,c[id],nothing) : nothing\r\n	if v != nothing v=v.data end\r\n	v\r\nendgetValues(this::StorageGroup) = API.getValues(this.data)setValues(this::StorageGroup, values::AbstractArray, elems::Integer, mode=:TRIANGLES) = API.setValues(this.data, values, elems, mode)function link(this::StorageGroup, on=true)\r\n	for (k,block) in this.list\r\n		for (k,storage) in block.list\r\n			link(block, storage, on)\r\n		end\r\n	end\r\nendlink(block::StorageGroup, storage::StorageGroup, on=true) = API.bind(block.data,storage.data,on)upload(block::StorageGroup, storage::StorageGroup, data::StorageGroup) = API.upload(block.data, storage.data, data.data)function upload(this::StorageGroup)\r\n	uploads=[]\r\n	for (kb,block) in this.list\r\n		API.prepare(block.data)\r\n		for (ks,storage) in block.list\r\n			API.prepare(block.data, storage.data)\r\n			for (kd,data) in storage.list\r\n				API.prepare(block.data, storage.data, data.data)\r\n				push!(uploads,[block.data, storage.data, data.data])\r\n			end\r\n		end\r\n		API.init(block.data)\r\n	end\r\n\r\n	API.upload(uploads)\r\nend"
},

{
    "location": "files/JLGEngine/SzeneManager.html#",
    "page": "SzeneManager.jl",
    "title": "SzeneManager.jl",
    "category": "page",
    "text": ""
},

{
    "location": "files/JLGEngine/SzeneManager.html#SzeneManager.jl-1",
    "page": "SzeneManager.jl",
    "title": "SzeneManager.jl",
    "category": "section",
    "text": ""
},

{
    "location": "files/JLGEngine/TextureManager.html#",
    "page": "TextureManager.jl",
    "title": "TextureManager.jl",
    "category": "page",
    "text": ""
},

{
    "location": "files/JLGEngine/TextureManager.html#TextureManager.jl-1",
    "page": "TextureManager.jl",
    "title": "TextureManager.jl",
    "category": "section",
    "text": "using CoreExtended using MatrixMath using FileManager using JLGEngine using ..GraphicsManagertype Texture <: JLGEngine.IComponent\r\n	id::Symbol\r\n	enabled::Bool\r\n	\r\n	source::FileSource\r\n	api::Any\r\n	\r\n	Texture(id=:_) = new(id,true,FileSource(),nothing)\r\nend\r\n\r\nAPI = nothingfunction init()\r\n	global API = GRAPHICSDRIVER().TextureManager\r\nendfunction init(this::Texture)\r\n	this.api = API.create()\r\nendload(this::Texture, path::String) = (this.source.path=path; API.load(this.api, this.source.path))bind(this::Texture) =	API.bind(api)"
},

{
    "location": "files/JLGEngine/TransformManager.html#",
    "page": "TransformManager.jl",
    "title": "TransformManager.jl",
    "category": "page",
    "text": ""
},

{
    "location": "files/JLGEngine/TransformManager.html#TransformManager.jl-1",
    "page": "TransformManager.jl",
    "title": "TransformManager.jl",
    "category": "section",
    "text": "using ..Management using CoreExtended using MatrixMathtype Transform\r\n	id::Symbol\r\n	enabled::Bool\r\n\r\n  position::Vec3f\r\n  rotation::Vec3f\r\n	scaling::Vec3f\r\n\r\n	Transform(id=:_) = new(id,true,zeros(Vec3f),zeros(Vec3f),ones(Vec3f))\r\nend"
},

{
    "location": "files/JLGEngine/ModelManager/MeshData.html#",
    "page": "MeshData.jl",
    "title": "MeshData.jl",
    "category": "page",
    "text": ""
},

{
    "location": "files/JLGEngine/ModelManager/MeshData.html#MeshData.jl-1",
    "page": "MeshData.jl",
    "title": "MeshData.jl",
    "category": "section",
    "text": "using MatrixMathconst MeshDataPlaneQuad = rotr90flipdim2(Float32[\r\n	-1 -1 0 0	# upleft\r\n	1 -1 0 0	# upright\r\n	1 1 0 0	# downright\r\n	-1 1 0 0	# downleft\r\n])const MeshDataPlaneVertex = rotr90flipdim2(Float32[\r\n	-1.0 -1.0 0.0 1.0 0.0\r\n	1.0 -1.0 0.0 0.0 0.0\r\n	1.0 1.0 0.0 0.0 1.0\r\n	1.0 1.0 0.0 0.0 1.0\r\n	-1.0 1.0 0.0 1.0 1.0\r\n	-1.0 -1.0 0.0 1.0 1.0\r\n\r\n	-1.0 -1.0 0.0 1.0 0.0\r\n	1.0 -1.0 0.0 0.0 0.0\r\n	-1.0 1.0 0.0 1.0 1.0\r\n	1.0 -1.0 0.0 0.0 0.0\r\n	1.0 1.0 0.0 0.0 1.0\r\n	-1.0 1.0 0.0 1.0 1.0\r\n])const MeshDataCube = Float32[\r\n	#  X, Y, Z, U, V\r\n	# Bottom\r\n	-1.0, -1.0, -1.0, 0.0, 0.0,\r\n	1.0, -1.0, -1.0, 1.0, 0.0,\r\n	-1.0, -1.0, 1.0, 0.0, 1.0,\r\n	1.0, -1.0, -1.0, 1.0, 0.0,\r\n	1.0, -1.0, 1.0, 1.0, 1.0,\r\n	-1.0, -1.0, 1.0, 0.0, 1.0,\r\n\r\n	# Top\r\n	-1.0, 1.0, -1.0, 0.0, 0.0,\r\n	-1.0, 1.0, 1.0, 0.0, 1.0,\r\n	1.0, 1.0, -1.0, 1.0, 0.0,\r\n	1.0, 1.0, -1.0, 1.0, 0.0,\r\n	-1.0, 1.0, 1.0, 0.0, 1.0,\r\n	1.0, 1.0, 1.0, 1.0, 1.0,\r\n\r\n	# Front\r\n	-1.0, -1.0, 1.0, 1.0, 0.0,\r\n	1.0, -1.0, 1.0, 0.0, 0.0,\r\n	-1.0, 1.0, 1.0, 1.0, 1.0,\r\n	1.0, -1.0, 1.0, 0.0, 0.0,\r\n	1.0, 1.0, 1.0, 0.0, 1.0,\r\n	-1.0, 1.0, 1.0, 1.0, 1.0,\r\n\r\n	# Back\r\n	-1.0, -1.0, -1.0, 0.0, 0.0,\r\n	-1.0, 1.0, -1.0, 0.0, 1.0,\r\n	1.0, -1.0, -1.0, 1.0, 0.0,\r\n	1.0, -1.0, -1.0, 1.0, 0.0,\r\n	-1.0, 1.0, -1.0, 0.0, 1.0,\r\n	1.0, 1.0, -1.0, 1.0, 1.0,\r\n\r\n	# Left\r\n	-1.0, -1.0, 1.0, 0.0, 1.0,\r\n	-1.0, 1.0, -1.0, 1.0, 0.0,\r\n	-1.0, -1.0, -1.0, 0.0, 0.0,\r\n	-1.0, -1.0, 1.0, 0.0, 1.0,\r\n	-1.0, 1.0, 1.0, 1.0, 1.0,\r\n	-1.0, 1.0, -1.0, 1.0, 0.0,\r\n\r\n	# Right\r\n	1.0, -1.0, 1.0, 1.0, 1.0,\r\n	1.0, -1.0, -1.0, 1.0, 0.0,\r\n	1.0, 1.0, -1.0, 0.0, 0.0,\r\n	1.0, -1.0, 1.0, 1.0, 1.0,\r\n	1.0, 1.0, -1.0, 0.0, 0.0,\r\n	1.0, 1.0, 1.0, 0.0, 1.0,\r\n]MeshDataCubeVertices_small = [\r\n1f0,  1,  1, # 0\r\n-1,  1,  1, # 1\r\n-1, -1,  1, # 2\r\n1, -1,  1, # 3\r\n1, -1, -1, # 4\r\n-1, -1, -1, # 5\r\n-1,  1, -1, # 6\r\n1,  1, -1, # 7\r\n]MeshDataCubeIndices = Int32[\r\n0, 1, 2, 2, 3, 0,           # Front face\r\n7, 4, 5, 5, 6, 7,           # Back face\r\n6, 5, 2, 2, 1, 6,           # Left face\r\n7, 0, 3, 3, 4, 7,           # Right face\r\n7, 6, 1, 1, 0, 7,           # Top face\r\n3, 2, 5, 5, 4, 3            # Bottom face\r\n]createCubeDataTest() = (:TRIANGLES, MeshDataCubeVertices_small, [], [], MeshDataCubeIndices)function createPlaneDataTest(wdetail::Integer, hdetail::Integer)\r\n	vertices=Vec3f[]\r\n	normals=Vec3f[]\r\n	uvs=Vec2f[]\r\n	indicies=UInt32[]\r\n	\r\n	push!(vertices, Vec3f(-1,-1,0))\r\n	push!(vertices, Vec3f(-1,1,0))\r\n	push!(vertices, Vec3f(1,-1,0))\r\n	\r\n	#push!(vertices, Vec3f(1,-1,0))\r\n	#push!(vertices, Vec3f(1,1,0))\r\n	#push!(vertices, Vec3f(-1,1,0))\r\n	\r\n	push!(indicies, 0)\r\n	push!(indicies, 1)\r\n	push!(indicies, 2)\r\n	#push!(indicies, 2)\r\n	#push!(indicies, 1)\r\n	#push!(indicies, 3)\r\n\r\n	(:TRIANGLE_STRIP, vertices, normals, uvs, indicies)\r\nendfunction createPlaneData(wdetail::Integer, hdetail::Integer)\r\n	texture_scale = true\r\n\r\n	W = wdetail < 1 ? 1 : wdetail\r\n	H = hdetail < 1 ? 1 : hdetail\r\n\r\n	MW = W + 1\r\n	MH = H + 1\r\n\r\n	dW = 1.f0 / W\r\n	dH = 1.f0 / H\r\n\r\n	s = false\r\n\r\n	vertices=Vec3f[]\r\n	normals=Vec3f[]\r\n	uvs=Vec2f[]\r\n	indicies=UInt32[]\r\n\r\n	for h=0:H\r\n		hs = H - h - 1\r\n		V = h * dH\r\n\r\n		for w=0:W\r\n			ws = W - w - 1\r\n			U = w * dW\r\n\r\n			v = Vec3f(-1 + U * 2, -1 + V * 2, 0) # vec3(-cos(theta) * sin(phi),-cos(phi),0);\r\n			uv = texture_scale ? Vec2f(V, U) : Vec2f(h, w)\r\n\r\n			push!(vertices, v)\r\n			push!(normals, Vec3f(0,0,1))\r\n			push!(uvs, MatrixMath.rotate(uv - Vec2f(1,0), 3.14f0*-0.5f0))\r\n\r\n			if h < H && w < W\r\n				if !s\r\n					push!(indicies, w + (hs + 1) * MW) # top left\r\n					push!(indicies, w + hs * MW) # left\r\n					push!(indicies, w + 1 + (hs + 1) * MW) # top right\r\n					push!(indicies, w + 1 + hs * MW) # right\r\n				else\r\n					push!(indicies, ws + 1 + (hs + 1) * MW) # top right\r\n					push!(indicies, ws + 1 + hs * MW) # right\r\n					push!(indicies, ws + (hs + 1) * MW) # top left\r\n					push!(indicies, ws + hs * MW) # left\r\n				end\r\n\r\n				#push!(indicies, w + h * MW); # left\r\n				#push!(indicies, w + 1 + h * MW) # right\r\n				#push!(indicies, w + (h + 1) * MW) # top left\r\n				#push!(indicies, w + 1 + (h + 1) * MW) # top right\r\n				#push!(indicies, w + (h + 1) * MW) # top left\r\n				#push!(indicies, w + 1 + h * MW) # right\r\n			end\r\n		end\r\n\r\n		if h < H\r\n			if !s push!(indicies, W + hs * MW) #top right\r\n			else push!(indicies, hs * MW) # top left\r\n			end\r\n			s = !s\r\n		end\r\n	end\r\n\r\n	(:TRIANGLE_STRIP, vertices, normals, uvs, indicies) #TRIANGLE_STRIP\r\nendfunction createCubeDataSimple()\r\n	const vd = Vec3f[\r\n		Vec3f(-1, -1, 0),\r\n		Vec3f(1, -1, 0),\r\n		Vec3f(1, 1, 0),\r\n		Vec3f(1, 1, 0),\r\n		Vec3f(-1, 1, 0),\r\n		Vec3f(-1, -1, 0),\r\n\r\n		Vec3f(-1, -1, 0),\r\n		Vec3f(1, -1, 0),\r\n		Vec3f(-1, 1, 0),\r\n		Vec3f(1, -1, 0),\r\n		Vec3f(1, 1, 0),\r\n		Vec3f(-1, 1, 0),\r\n	]\r\n\r\n	len = length(vd)\r\n	vertices=zeros(Vec3f, len)\r\n	normals=zeros(Vec3f, 0)\r\n	uvs=zeros(Vec2f, 0)\r\n	indicies=zeros(UInt32, 0)\r\n\r\n	i=0\r\n	for v in vd; i+=1; vertices[i]=v end\r\n	#for v in vd; i+=1; vertices[i]=v end\r\n\r\n	(:TRIANGLES, vertices, normals, uvs, indicies)\r\nendfunction createCubeData()\r\n		v = [\r\n			Vec3f(-1, -1, -1), Vec3f(1, -1, -1), Vec3f(-1, 1, -1), Vec3f(1, 1, -1),\r\n			Vec3f(-1, -1, 1), Vec3f(1, -1, 1), Vec3f(-1, 1, 1), Vec3f(1, 1, 1)\r\n		]\r\n\r\n		n = zeros(Vec3f, 8)\r\n		for ni=1:length(n) n[ni] = normalize(v[ni]) end\r\n\r\n		uv = [ Vec2f(0, 1), Vec2f(1, 1), Vec2f(0, 0), Vec2f(1, 0)	]\r\n\r\n		const i = UInt32[\r\n			0, 1, 2, 3, # back (0, 1, 2, 3)\r\n			4, 5, 6, 7, # front (4, 5, 6, 7)\r\n			0, 4, 2, 6, # left (8, 9, 10, 11)\r\n			1, 5, 3, 7, # right (12, 13, 14, 15)\r\n			0, 1, 4, 5, # bottom (16, 17, 18, 19)\r\n			2, 3, 6, 7  # top (20, 21, 22, 23)\r\n		]\r\n\r\n		const u = UInt32[\r\n			0, 1, 2, 3, # back (0, 1, 2, 3)\r\n			0, 1, 2, 3, # front (4, 5, 6, 7)\r\n			0, 1, 2, 3, # left (8, 9, 10, 11)\r\n			0, 1, 2, 3, # right (12, 13, 14, 15)\r\n			0, 1, 2, 3, # bottom (16, 17, 18, 19)\r\n			0, 1, 2, 3  # top (20, 21, 22, 23)\r\n		]\r\n\r\n		const C = UInt32[ #36\r\n			0 + 1, 0 + 0, 0 + 2, 0 + 2, 0 + 3, 0 + 1, # back (1, 0, 2, 2, 3, 1)\r\n			4 + 0, 4 + 1, 4 + 3, 4 + 3, 4 + 2, 4 + 0, # front (4, 5, 7, 7, 6, 4)\r\n			8 + 0, 5 + 4, 9 + 2, 9 + 2, 8 + 2, 8 + 0, # left (0, 4, 6, 6, 2, 0)\r\n			12 + 1, 12 + 0, 12 + 2, 12 + 2, 12 + 3, 12 + 1, # right (5, 1, 3, 3, 7, 5)\r\n			16 + 0, 16 + 1, 16 + 3, 16 + 3, 16 + 2, 16 + 0, # bottom (0, 1, 5, 5, 4, 0)\r\n			20 + 1, 20 + 0, 20 + 2, 20 + 2, 20 + 3, 20 + 1 # top (3, 2, 6, 6, 7, 3)\r\n		]\r\n\r\n		const C2 = UInt32[ 	#35\r\n			17, 19, 16, 18,		# bottom\r\n			9, 11, 8, 10,			# left\r\n			20, 0,						# skip\r\n			0, 2, 1, 3,				# back\r\n			14, 2,						# skip\r\n			20, 22, 21, 23,		# top\r\n			15, 13, 14, 12,		# right\r\n			1, 5,							# skip\r\n			5, 7, 4, 6,				# front\r\n		]\r\n\r\n		Ilen=length(i)\r\n		Clen=length(C)\r\n\r\n		vertices=zeros(Vec3f, Ilen)\r\n		normals=zeros(Vec3f, Ilen)\r\n		uvs=zeros(Vec2f, Ilen)\r\n		indicies=zeros(UInt32, Clen)\r\n\r\n		uvi = UInt32(0)\r\n		for vi = 1:Ilen\r\n			uvi+=1\r\n			if uvi>3 uvi = 0 end\r\n			index = i[vi] + 1\r\n\r\n			vertices[vi] = v[index] + 1\r\n			normals[vi] = n[index] + 1\r\n			uvs[vi] = uv[u[vi] + 1] + 1\r\n		end\r\n\r\n		#uvi = UInt32(0)\r\n		for vi=1:Clen\r\n			#uvi+=1\r\n			indicies[vi] = C[vi] + 1 #index\r\n		end\r\n\r\n		#shape->setType(DRAWS::draw_TRIANGLE_STRIP);\r\n		(:TRIANGLE_STRIP, vertices, normals, uvs, indicies)\r\nendfunction addTriangle(list::Dict{Symbol,Any}, id::Integer, index::Integer, v::Vec3f)\r\n	ids = list[:IDS]\r\n	position = list[:VERTICES]\r\n	normal = list[:NORMALS]\r\n	texcoord = list[:UVS]\r\n\r\n	position[ids[1]] = v\r\n	ids[1]+=1\r\n\r\n	n = normalize(v)\r\n\r\n	normal[ids[2]] = n\r\n	ids[2]+=1\r\n\r\n	x = 1 + n[1]\r\n	z = 1 + n[3]\r\n\r\n	if z < 1 x = 4 + -x end\r\n	#if ids[4] < x ids[4] = x end\r\n	#if !(x < 0 && z < 0) x = z = 2 end\r\n\r\n	#n2 = normalize(uid * 0.5f0)\r\n	#if z > .5f x = mx end\r\n\r\n	texcoord[ids[3]] = Vec2f(x * 0.25f0, 0.5f0 + n[2] * -0.5f0)\r\n	ids[3]+=1\r\nendfunction addTriangle(list::Dict{Symbol,Any}, id::Integer, v::Array{Vec3f,1})\r\n	for i=1:length(v) addTriangle(list, id, i, v[i]) end\r\nendfunction subdivide(list::Dict{Symbol,Any}, id::Integer, depth::Integer, v::Array{Vec3f,1})\r\n	if depth <= 0\r\n		addTriangle(list, id, v)\r\n		return\r\n	end\r\n\r\n	v1 = v[1]\r\n	v2 = v[2]\r\n	v3 = v[3]\r\n\r\n	v12 =  normalize(v1 + v2)\r\n	v23 =  normalize(v2 + v3)\r\n	v31 =  normalize(v3 + v1)\r\n\r\n	#matrix 3x4 vec3f\r\n	vs = [\r\n		[v1, v12, v31],\r\n		[v2, v23, v12],\r\n		[v3, v31, v23],\r\n		[v12, v23, v31]\r\n	]\r\n\r\n	#index=1+(i-1) * 3\r\n	#vs = [v1,v2,v3,v12]\r\n\r\n	depth = depth - 1\r\n\r\n	for i=1:length(vs)\r\n		subdivide(list, id, depth, vs[i])\r\n	end\r\nendfunction computeVAO(list::Dict{Symbol,Any}, sides::Integer, depth::Integer, points::Array{Vec3f,1}, indices::Array{Vec3u,1})\r\n	if depth>8\r\n		error(\"VAO depth should not be larger than 8! Computer will freeze!\")\r\n		return\r\n	end\r\n\r\n	# Compute and store vertices\r\n	numVertices = sides * 3 #/ sides *  points for one vertex\r\n	VAOSize = numVertices * 3 * Integer(4^depth) # *(x,y,z)\r\n\r\n	println(\"size: $sides*3=$numVertices*3=$(numVertices*3)*4^$depth=$VAOSize\")\r\n\r\n	list[:IDS] = [1,1,1,0]\r\n	list[:VERTICES] = fill(zeros(Vec3f),VAOSize)\r\n	list[:NORMALS] = fill(zeros(Vec3f),VAOSize)\r\n	list[:UVS] = fill(zeros(Vec2f),VAOSize)\r\n	#list[:INDICIES] = fill(UInt32(0),(numP - 1) * (numSides + 1) * 6)\r\n\r\n	for i=1:sides\r\n		vs = [ points[1+indices[i][1]], points[1+indices[i][2]], points[1+indices[i][3]] ]\r\n		subdivide(list, i, depth, vs)\r\n	end\r\nendfunction createTetrahedronSphere(depth::Integer)\r\n	X = 0.525731112119133606f0; # sin(inc * 6.362117953f0); // 0.61803399f0,0.6662394341f0,6.362117953f0\r\n	Z = 0.850650808352039932f0; # 1.61803399f0; // cos(0.0f0);\r\n\r\n	list = Dict{Symbol,Any}()\r\n\r\n	points = [\r\n		Vec3f(X, 0, -Z), Vec3f(-X, 0, -Z), Vec3f(X, 0, Z), Vec3f(-X, 0, Z),\r\n		Vec3f(0, -Z, -X), Vec3f(0, -Z, X), Vec3f(0, Z, -X), Vec3f(0, Z, X),\r\n		Vec3f(-Z, -X, 0), Vec3f(Z, -X, 0), Vec3f(-Z, X, 0), Vec3f(Z, X, 0),\r\n	]\r\n\r\n	indices = [\r\n		Vec3u(0, 4, 1), Vec3u(0, 9, 4), Vec3u(9, 5, 4), Vec3u(4, 5, 8), Vec3u(4, 8, 1),\r\n		Vec3u(8, 10, 1), Vec3u(8, 3, 10), Vec3u(5, 3, 8), Vec3u(5, 2, 3), Vec3u(2, 7, 3),\r\n		Vec3u(7, 10, 3), Vec3u(7, 6, 10), Vec3u(7, 11, 6), Vec3u(11, 0, 6), Vec3u(0, 1, 6),\r\n		Vec3u(6, 1, 10), Vec3u(9, 0, 11), Vec3u(9, 11, 2), Vec3u(9, 2, 5), Vec3u(7, 2, 11)\r\n	]\r\n\r\n	computeVAO(list, 20, depth, points, indices)\r\n\r\n	#(:TRIANGLES, list[:VERTICES], list[:NORMALS], list[:UVS], UInt32[])\r\n	(:TRIANGLES, list[:VERTICES], [], [], [])\r\nend"
},

{
    "location": "files/JLGEngine/ModelManager/MeshFabric.html#",
    "page": "MeshFabric.jl",
    "title": "MeshFabric.jl",
    "category": "page",
    "text": ""
},

{
    "location": "files/JLGEngine/ModelManager/MeshFabric.html#MeshFabric.jl-1",
    "page": "MeshFabric.jl",
    "title": "MeshFabric.jl",
    "category": "section",
    "text": "include(\"MeshData.jl\") include(\"MeshLoader_OBJ.jl\")function createMesh(this::Model, id::Symbol)\r\n	if !haskey(this.meshes, id)\r\n		mesh = MeshManager.Mesh()\r\n		this.meshes[id]=mesh\r\n	else\r\n		mesh=this.meshes[id]\r\n	end\r\n	mesh\r\nendfunction addMesh(this::Model, typ::Symbol)\r\n	mesh=createMesh(this, :DEFAULT)\r\n	if MeshManager.isEmpty(mesh)\r\n		update(mesh, typ, this.source.path)\r\n	end\r\n	upload(this)\r\n	mesh\r\nendfunction update(mesh::Mesh, typ::Symbol, path::String)\r\n	if typ == :PLANE\r\n		MeshManager.update(mesh, typ, MeshDataPlaneQuad)\r\n	elseif typ == :CUBE\r\n		MeshManager.update(mesh, typ, MeshDataCube, 5)\r\n	elseif typ == :CUBE2\r\n		MeshManager.update(mesh,typ, createCubeDataTest)\r\n	elseif typ == :IPLANE\r\n		MeshManager.update(mesh, typ, ()->createPlaneData(5,5))\r\n	elseif typ == :ICOSPHERE\r\n		MeshManager.update(mesh, typ, ()->createTetrahedronSphere(1))\r\n	elseif typ == :MODEL\r\n		if !loadOBJ(path, mesh)	warn(string(\"Failed loading mesh file \", path))	end\r\n	end\r\nendfunction prepare(this::Model, mesh::Mesh)\r\n	vlen=length(mesh.vertices.data.values)\r\n	uvlen=length(mesh.uvs.data.values)\r\n	nlen=length(mesh.normals.data.values)\r\n	ilen=length(mesh.indicies.data.values)\r\n\r\n	if vlen>0 || uvlen>0 || nlen>0\r\n		va=StorageManager.create(this.group, :VA, :BLOCK, :ARRAY_BLOCK)\r\n		vao=StorageManager.create(va, :VAO, :STORAGE, :ARRAY)\r\n\r\n		vb=StorageManager.create(this.group, :VB, :BLOCK, :BUFFER_BLOCK)\r\n		vbo=StorageManager.create(vb, :VBO, :STORAGE, :ARRAY_BUFFER)\r\n\r\n		if vlen>0	StorageManager.link(vbo, mesh.vertices, :VERTEX) end\r\n		if uvlen>0 StorageManager.link(vbo, mesh.uvs, :UV) end\r\n		if nlen>0	StorageManager.link(vbo, mesh.normals, :NORMAL)	end\r\n		if ilen==0 setMainBuffer(this,vbo) end\r\n	end\r\n\r\n	if ilen>0\r\n		ib=StorageManager.create(this.group, :IB, :BLOCK, :INDEX_BLOCK)\r\n		ibo=StorageManager.create(ib, :IBO, :STORAGE, :ELEMENT_ARRAY_BUFFER)\r\n		StorageManager.link(ibo, mesh.indicies, :INDEX)\r\n		setMainBuffer(this,ibo)\r\n	end\r\nend"
},

{
    "location": "files/JLGEngine/ModelManager/MeshLoader_OBJ.html#",
    "page": "MeshLoader_OBJ.jl",
    "title": "MeshLoader_OBJ.jl",
    "category": "page",
    "text": ""
},

{
    "location": "files/JLGEngine/ModelManager/MeshLoader_OBJ.html#MeshLoader_OBJ.jl-1",
    "page": "MeshLoader_OBJ.jl",
    "title": "MeshLoader_OBJ.jl",
    "category": "section",
    "text": "type ShapeCoordinates\r\n	#std::string& name\r\n	positions::AVec3f\r\n	normals::AVec3f\r\n	texcoords::AVec2f\r\n	indicies::AIndex\r\n	origin::Vec3f\r\n	scale::Vec3f\r\n\r\n	ShapeCoordinates() = new(AVec3f(),AVec3f(),AVec1f(),AIndex(),Vec3f(),Vec3f())\r\n	ShapeCoordinates(positions,normals,texcoords,indicies,origin,scale) = new(positions,normals,texcoords,indicies,origin,scale)\r\nendtype VertexIndex\r\n	v::Integer\r\n	vt::Integer\r\n	vn::Integer\r\n\r\n	VertexIndex() = new(0,0,0)\r\n	VertexIndex(a::Integer) = new(a,a,a)\r\n	VertexIndex(v::Integer, vn::Integer, vt::Integer) = new(v,vt,vn)\r\nend\r\n\r\nAVertexIndex = Array{VertexIndex,1}\r\nAAVertexIndex = Array{AVertexIndex,1}\r\nAGroupIndex = Array{Array{Array{Integer,1},1},1}function clear(sc::ShapeCoordinates)\r\n	sc.positions = AVec3f()\r\n	sc.normals = AVec3f()\r\n	sc.texcoords = AVec1f()\r\n	sc.indicies = AIndex()\r\n	sc.origin = Vec3f()\r\n	sc.scale = Vec3f()\r\nend"
},

{
    "location": "files/JLGEngine/ModelManager/MeshLoader_OBJ.html#for-std::map-1",
    "page": "MeshLoader_OBJ.jl",
    "title": "for std::map",
    "category": "section",
    "text": "function isSmaller(a::VertexIndex, b::VertexIndex)\r\n	if a.v != b.v return (a.v < b.v) end\r\n	if a.vn != b.vn return (a.vn < b.vn) end\r\n	if a.vt != b.vt return (a.vt < b.vt) end\r\n	false\r\nendisSpace(c::Char) = (c == \' \') || (c == \'\\t\')isNewLine(c::Char) = (c == \'\\r\') || (c == \'\\n\') || (c == \'\\0\')function getOrigin(min_BBOX::Vec3f, max_BBOX::Vec3f, scale::Number)\r\n	(max_BBOX + min_BBOX) * (scale * 0.5f0)\r\nendfunction getScale(min_BBOX::Vec3f, max_BBOX::Vec3f)\r\n	size = max_BBOX - min_BBOX\r\n	println(\"size: \",size)\r\n	scale_value = size.x > size.z ? size.x : size.z\r\n	println(\"1scale_value: \",scale_value)\r\n	scale_value = scale_value > size.y ? scale_value : size.y\r\n	println(\"2scale_value: \",scale_value)\r\n	scale_value = abs(scale_value)\r\n	println(\"3scale_value: \",scale_value)\r\n	if scale_value > 1 scale_value = 1 / scale_value\r\n	#if scale_value > 0 && scale_value < 1 scale_value = scale_value\r\n	else scale_value = 1\r\n	end\r\n	scale_value\r\nendfunction parseVal(T::DataType, str::AbstractString, default=T(0))\r\n	try\r\n		return parse(T, str)\r\n	catch(e)\r\n	end\r\n	default\r\nendfunction parseArray(T::DataType, str::AbstractString)\r\n	a = Array{T,1}()\r\n	m = matchall(Regex(\"(^|(?<=\\\\s))[+-]?([0-9]+[.])?[0-9]+([eE][-+]?[0-9]+)?((?=\\\\s)|\\$)\"),str) # only valid: (space?)(number)(space?)\r\n	#for x in m push!(a, parseval(T, x)) end\r\n	map(x->parseVal(T,x),m)\r\nendfunction parseVec(linenr::Number, str::AbstractString, count::Number)\r\n	if count < 1 error(\"count < 1\") end\r\n\r\n	a = parseArray(Float32, str)\r\n	len = length(a)\r\n	\r\n	if len != count	warn(linenr, \": missmatch count: required=$count != found=$(length(a)) \", str)	end\r\n\r\n	# on count missmatch: just read until max(count) reachted\r\n	v = zeros(Float32,count)\r\n	for i=1:(len>=count ? count : len) v[i]=a[i] end\r\n	\r\n	result = nothing\r\n	if count == 1 result = Vec1f(v)\r\n	elseif count == 2 result = Vec2f(v)\r\n	elseif count == 3 result = Vec3f(v)\r\n	elseif count == 4 result = Vec4f(v)\r\n	else result = Vec{count, Float32}(v)\r\n	end\r\n	result\r\nend"
},

{
    "location": "files/JLGEngine/ModelManager/MeshLoader_OBJ.html#Make-index-zero-base,-and-also-support-relative-index.-1",
    "page": "MeshLoader_OBJ.jl",
    "title": "Make index zero-base, and also support relative index.",
    "category": "section",
    "text": "function parseIndex(str::AbstractString, n::Integer)\r\n	#a = parseArray(Integer, str)\r\n	i = parseVal(Int, str, -1) #length(a)>0 ? a[1] : 0\r\n	#if idx >= 0 i = idx\r\n	#else i = n + idx # negative value = relative\r\n	#end\r\n	i\r\nendhas(str::AbstractString, index::Integer, c::Char) = index>0 && index<=length(str) && str[index] == c"
},

{
    "location": "files/JLGEngine/ModelManager/MeshLoader_OBJ.html#Parse-triples:-i,-i/j/k,-i//k,-i/j-1",
    "page": "MeshLoader_OBJ.jl",
    "title": "Parse triples: i, i/j/k, i//k, i/j",
    "category": "section",
    "text": "function parseTriple(line::AbstractString, vsize::Integer, vnsize::Integer, vtsize::Integer)\r\n	vi = VertexIndex()\r\n\r\n	tmp = line\r\n	vi.v = parseIndex(tmp, vsize)\r\n	token = search(tmp, r\"[/\\s]\").start\r\n	if !has(line,token,\'/\') return vi end\r\n	token+=1\r\n\r\n	# i//k\r\n	if has(line,token,\'/\')\r\n		token+=1\r\n		tmp = line[token:end]\r\n		vi.vn = parseIndex(tmp, vnsize)\r\n		token = search(tmp, r\"/\\s\").start\r\n		return vi\r\n	end\r\n\r\n	# i/j/k or i/j\r\n	tmp = line[token:end]\r\n	vi.vt = parseIndex(tmp, vtsize)\r\n	token = search(tmp, r\"[/\\s]\").start\r\n	\r\n	if !has(line,token,\'/\') return vi\r\n	else token+=1  # skip \'/\'\r\n	end\r\n	\r\n	tmp = line[token:end]\r\n	vi.vn = parseIndex(tmp, vnsize)\r\n	token = search(tmp, r\"[/\\s]\").start\r\n	vi\r\nendfunction updateVertex2(vi::VertexIndex, vCache::Dict{VertexIndex, Integer}, coord::ShapeCoordinates, cache::ShapeCoordinates)\r\n	if haskey(vCache, vi) return vCache[vi] end\r\n\r\n	if vi.v > 0 && vi.v > length(coord.positions)\r\n		error(\"$(vi.v) > $(length(coord.positions))\")\r\n		return 0\r\n	end\r\n\r\n	v = coord.positions[vi.v]\r\n	println(\"push position \", v)\r\n	push!(cache.positions, v) #MatrixMath.scale(v,coord.scale) - coord.origin)\r\n\r\n	if vi.vn > 0\r\n		v = coord.normals[vi.vn]\r\n		println(\"push normal \", v)\r\n		push!(cache.normals, v)\r\n	end\r\n\r\n	if vi.vt > 0\r\n		v = coord.texcoords[vi.vt]\r\n		println(\"push texcoord \", v)\r\n		push!(cache.texcoords, v)\r\n	end\r\n\r\n	idx = length(cache.positions)\r\n	vCache[vi] = idx\r\n	idx\r\nendcorrectVec(v::Vec3f, tmp::ShapeCoordinates) = MatrixMath.scale(v, tmp.scale) #MatrixMath.scale(v, tmp.scale) - tmp.originfunction parseAll(\r\n	vCache::Dict{VertexIndex,Integer},\r\n	groups::AGroupIndex,\r\n	#const int material_id,\r\n	#const std::string &name,\r\n	#bool clearCache,\r\n	tmp::ShapeCoordinates,\r\n	cache::ShapeCoordinates)\r\n	\r\n	clear(cache) # remove old\r\n\r\n	cache.positions = map(x->correctVec(x, tmp),tmp.positions)\r\n	cache.normals = tmp.normals\r\n	cache.texcoords = tmp.texcoords\r\n	\r\n	for gs in groups\r\n		for g in gs\r\n			for index in g\r\n				index += -1 #fix: index in file starts with 1 (not 0)\r\n				index = index < MinUInt32 || index > MaxUInt32 ? MaxUInt32 : index\r\n				push!(cache.indicies, UInt32(index))\r\n				break # take only vertex indicies\r\n			end\r\n		end\r\n	end\r\n\r\n	# Flatten vertices and indices\r\n	#=\r\n	if length(group) < 1\r\n		warn(\"group: $(length(group))\")\r\n		return false\r\n	end\r\n	\r\n	println(\"indicies group $(length(group))\")\r\n	for i=1:length(group)\r\n		face = group[i]\r\n\r\n		i0 = face[1]\r\n		i1 = VertexIndex()\r\n		i2 = face[2]\r\n\r\n		npolys = length(face)\r\n\r\n		# Polygon -> triangle fan conversion\r\n		for k=3:npolys\r\n			i1 = i2\r\n			i2 = face[k]\r\n\r\n			v0 = updateVertex(i0, vCache, sc, cache)\r\n			v1 = updateVertex(i1, vCache, sc, cache)\r\n			v2 = updateVertex(i2, vCache, sc, cache)\r\n\r\n			println(\"push index \", v0); push!(cache.indicies, v0)\r\n			println(\"push index \", v1); push!(cache.indicies, v1)\r\n			println(\"push index \", v2); push!(cache.indicies, v2)\r\n		end\r\n	end\r\n	=#\r\n\r\n	true\r\nendfunction parseIndicies(tmp_vi::AAVertexIndex,tmp::ShapeCoordinates, cache::ShapeCoordinates)\r\n\r\n	clear(cache) # remove old\r\n\r\n	ig = 0\r\n	iCount = length(tmp_vi)\r\n	vCount = length(tmp.positions)\r\n	vnCount = length(tmp.normals)\r\n	vtCount = length(tmp.texcoords)\r\n\r\n	if !iCount warn(\"No index coordinates! $tmp\")	end\r\n\r\n	if !vCount\r\n		error(\"No vertex coordinates! $tmp\")\r\n		return false\r\n	end\r\n\r\n	# For each vertex of each triangle\r\n	for it in tmp_vi\r\n		ig+=1\r\n		for jt in it\r\n			vi = jt\r\n			iv = vi.v\r\n			ivn = vi.vn\r\n			ivt = vi.vt\r\n\r\n			if iv > 0\r\n				if iv <= vCount\r\n					push!(cache.positions, tmp.positions[iv])\r\n				else\r\n					error(\"Missmatch count of vertex coordinates! $ig ($iv <= 0 or >= $vCount).\")\r\n					return false\r\n				end\r\n			end\r\n\r\n			if ivn > 0\r\n				if ivn <= vnCount\r\n					push!(cache.normals, tmp.normals[ivn])\r\n				else\r\n					error(\"Missmatch count of normal coordinates! $ig ($ivn <= 0 or >= $vnCount).\")\r\n					return false\r\n				end\r\n			end\r\n\r\n			if ivt > 0\r\n				if ivt <= vtCount\r\n					push!(cache.texcoords, tmp.texcoords[ivt])\r\n				else\r\n					error(\"Missmatch count of texture coordinates! $ig ($ivt <= 0 or >= $vtCount).\")\r\n					return false\r\n				end\r\n			end\r\n		end\r\n	end\r\n\r\n	vCount = length(cache.positions)\r\n	vnCount = length(cache.normals)\r\n	vtCount = length(cache.texcoords)\r\n\r\n	if !vCount\r\n		error(\"No vertex coordinates!\")\r\n		return false\r\n	end\r\n\r\n	if vnCount > 0 && vCount != vnCount\r\n		error(\"Missmatch count of vertex and normal coordinates! ($vCount != $vnCount).\")\r\n		return false\r\n	end\r\n\r\n	if vtCount > 0 && vCount != vtCount\r\n		error(\"Missmatch count of vertex and texture coordinates! ($vCount != $vtCount).\")\r\n		return false\r\n	end\r\n\r\n	true\r\nendfunction loadOBJ(path::String, mesh::Mesh)\r\n	println(\"Load OBJ file $path...\");\r\n\r\n	tmp_v = AVec3f()\r\n	tmp_vn = AVec3f()\r\n	tmp_vt = AVec2f()\r\n	tmp_g = AGroupIndex()\r\n\r\n	vertexCache = Dict{VertexIndex,Integer}()\r\n\r\n	min_BBOX = zeros(Vec3f)\r\n	max_BBOX = zeros(Vec3f)\r\n\r\n	linenr = 0\r\n	warn(string(\"read \", path))\r\n	open(path) do file\r\n		content=readstring(file)\r\n		content=Base.replace(content, \"\\r\", \"\")\r\n		content=Base.replace(content, \"\\\\\\n\", \"\") #remove broken lines\r\n		#content=string(content,\'\\0\')\r\n		open(x -> println(x, content), string(path, \".cleaned\"), \"w+\")\r\n		for line in split(content,r\"\\n\")\r\n			linenr += 1\r\n			line = lstrip(line)\r\n			len = length(line) #+remove r\r\n			id = len\r\n\r\n			if len == 0 || line == \"\" continue end\r\n			\r\n			token = search(line, r\"\\s+\").start\r\n			if token <= 0\r\n				#error(string(linenr, \": invalid token = \", token))\r\n				warn(string(linenr, \": no separator -> skip\"))\r\n				continue\r\n			end\r\n			\r\n			#println(string(linenr, \": search...\"))\r\n\r\n			first = line[1]\r\n			second = len > 1 ? line[2] : \"\"\r\n			third = len > 2 ? line[3] : \"\"\r\n\r\n			if first == \'\\0\' || first == \'#\' continue # skip line\r\n\r\n			elseif first == \'v\' && isSpace(second)\r\n				part = line[token:end]\r\n				#warn(string(linenr, \": \", line))\r\n				v = parseVec(linenr, part, 3)\r\n\r\n				# set bounding box\r\n				if v.x < min_BBOX.x min_BBOX.x = v.x end\r\n				if v.y < min_BBOX.y min_BBOX.y = v.y end\r\n				if v.z < min_BBOX.z min_BBOX.z = v.z end\r\n				if v.x > max_BBOX.x max_BBOX.x = v.x end\r\n				if v.y > max_BBOX.y max_BBOX.y = v.y end\r\n				if v.z > max_BBOX.z max_BBOX.z = v.z end\r\n\r\n				push!(tmp_v,v)\r\n				continue\r\n\r\n			elseif first == \'v\' && second == \'n\' && isSpace(third)\r\n				part = line[token:end]\r\n				#warn(string(linenr, \": \", line))\r\n				v = parseVec(linenr, part, 3)\r\n				#push!(tmp_vn, v)\r\n				continue\r\n\r\n			elseif first == \'v\' && second == \'t\' && isSpace(third)\r\n				part = line[token:end]\r\n				#warn(string(linenr, \": \", line))\r\n				v = parseVec(linenr, part, 2)\r\n				#push!(tmp_vt,v)\r\n				continue\r\n\r\n			elseif first == \'f\' && isSpace(second)\r\n\r\n				token += 1\r\n				part = line[token:end]\r\n				#warn(string(linenr, \": \", line))\r\n				\r\n				group = map((p)->map(function(x)\r\n					v=parseVal(UInt32,x, -1)\r\n					#println(linenr, \": index \", part, \" => \", v)\r\n					v\r\n				end,split(p, r\"/\")),split(part, r\"\\s+\"))\r\n				\r\n				#if j>0\r\n				#	println(\"=> \", vi)\r\n				#	push!(group,vi)\r\n				#end\r\n				\r\n				#max = length(a) #search(line[token:end],r\"[\\n]\").start\r\n				#for i=1:max\r\n				#	part = line[token:end]\r\n				#	vi = parseTriple(part, Integer(round(length(tmp_v) / 3)), Integer(round(length(tmp_vn) / 3)), Integer(round(length(tmp_vt) / 2)))\r\n				#	println(linenr, \": index \", part, \" => \", vi)\r\n				#	push!(group,vi)\r\n				#	n = search(part, r\"[ \\t]\").start\r\n				#	token += n\r\n				#end\r\n\r\n				push!(tmp_g, group)\r\n			end\r\n		end\r\n	end\r\n\r\n	scale_value = getScale(min_BBOX, max_BBOX)\r\n	println(\"scale_value: \",scale_value)\r\n	tmp_sc = ShapeCoordinates( tmp_v, tmp_vn, tmp_vt, AIndex(), getOrigin(min_BBOX, max_BBOX, scale_value), Vec3f(scale_value) )\r\n	cache = ShapeCoordinates()\r\n	result = parseAll(vertexCache, tmp_g, tmp_sc, cache)\r\n\r\n	if result\r\n		#println(\"positions $(length(cache.positions)): \", cache.positions)\r\n		#println(\"normals $(length(cache.normals)): \", cache.normals)			\r\n		#println(\"texcoords $(length(cache.texcoords)): \", cache.texcoords)\r\n		#println(\"indicies $(length(cache.indicies)). \", cache.indicies)\r\n		\r\n		MeshManager.update(mesh, :MODEL, ()->(:TRIANGLES, cache.positions,cache.normals,cache.texcoords,cache.indicies))\r\n		#shape.material_ids.push_back(material_id);\r\n		#shape.name = name;\r\n		#if (clearCache)	vCache.clear();\r\n		println(\"Finsihed loading OBJ file $path.\")\r\n	end\r\n\r\n	result\r\nend"
},

{
    "location": "files/JLGEngine/LibGL/LibGL.html#",
    "page": "LibGL.jl",
    "title": "LibGL.jl",
    "category": "page",
    "text": ""
},

{
    "location": "files/JLGEngine/LibGL/LibGL.html#LibGL.jl-1",
    "page": "LibGL.jl",
    "title": "LibGL.jl",
    "category": "section",
    "text": "import DataStructuresusing ModernGLusing CoreExtended using FileManagerinclude(\"GLLists.jl\") include(\"GLDebugControl.jl\") include(\"GLExtendedFunctions.jl\") include(\"StorageManager.jl\") include(\"ShaderManager.jl\") include(\"TextureManager.jl\")using JLGEngine.GraphicsManager using .GLLists using .GLExtendedFunctionshasDuplicates(msg) = (for (i,j) in zip(msg,lastMessage) if i != j return false end end; true)function openglerrorcallback(\r\n                source::GLenum, typ::GLenum,\r\n                id::GLuint, severity::GLenum,\r\n                len::GLsizei, message::Ptr{GLchar},\r\n                userParam::Ptr{Void}\r\n            )\r\n\r\n		msg = (source, typ, id, severity, len)\r\n		if hasDuplicates(msg) return end # ignore duplicates\r\n		global lastMessage = msg\r\n\r\n		#source = GL_DEBUG_SOURCE_API, GL_DEBUG_SOURCE_WINDOW_SYSTEM_, GL_DEBUG_SOURCE_SHADER_COMPILER, GL_DEBUG_SOURCE_THIRD_PARTY, GL_DEBUG_SOURCE_APPLICATION, GL_DEBUG_SOURCE_OTHER, GL_DONT_CARE\r\n		#typ = GL_DEBUG_TYPE_ERROR, GL_DEBUG_TYPE_DEPRECATED_BEHAVIOR, GL_DEBUG_TYPE_UNDEFINED_BEHAVIOR, GL_DEBUG_TYPE_PORTABILITY, GL_DEBUG_TYPE_PERFORMANCE, GL_DEBUG_TYPE_MARKER, GL_DEBUG_TYPE_PUSH_GROUP, GL_DEBUG_TYPE_POP_GROUP, or GL_DEBUG_TYPE_OTHER, GL_DONT_CARE\r\n		#severity = GL_DEBUG_SEVERITY_LOW, GL_DEBUG_SEVERITY_MEDIUM, or GL_DEBUG_SEVERITY_HIGH, GL_DONT_CARE\r\n    errormessage = 	\"\\n\"*\r\n                    \" __OPENGL________________________________________________________\\n\"*\r\n                    \"|\\n\"*\r\n                    #\"| type: $(GLENUM(typ).name) :: id: $(GLENUM(id).name)\\n\"*\r\n										#\"| source: $(GLENUM(source).name) :: severity: $(GLENUM(severity).name)\\n\"*\r\n										(userParam != C_NULL ? \"| UserParam : NOT NULL\\n\" : \"\")*\r\n                    (len > 0 ? \"| \"*ascii(unsafe_string(message, len))*\"\\n\" : \"\")*\r\n										(haskey(LIST_ERROR,id) ? \"| \"*LIST_ERROR[id]*\"\\n\" : \"\")*\r\n                    \"|________________________________________________________________\\n\"\r\n    #if typ == GL_DEBUG_TYPE_ERROR\r\n				warn(errormessage)\r\n    #end\r\n    nothing\r\nendconst _openglerrorcallback = cfunction(openglerrorcallback, Void,\r\n                                        (GLenum, GLenum,\r\n                                        GLuint, GLenum,\r\n                                        GLsizei, Ptr{GLchar},\r\n                                        Ptr{Void}))function SetDebugging(debug::Bool)\r\n  if debug SetErrorCallBack() end\r\nendfunction SetErrorCallBack()\r\n  @static if is_apple()\r\n			warn(\"OpenGL debug message callback not available on osx\")\r\n			return\r\n  end\r\n	flags = getValByRef((ref) -> glGetIntegerv(GL_CONTEXT_FLAGS, ref), GLint(0))\r\n  if (flags & GL_CONTEXT_FLAG_DEBUG_BIT) != 0\r\n		glEnable(GL_DEBUG_OUTPUT)\r\n		glEnable(GL_DEBUG_OUTPUT_SYNCHRONOUS)\r\n		glDebugMessageCallbackARB(_openglerrorcallback, C_NULL)\r\n	end\r\nendfunction init()\r\n	SetErrorCallBack()\r\nendGetVersion(key::Symbol) = haskey(LIST_INFO,key) ? string(\"OpenGL \",glString(LIST_INFO[key])) : \"\"function getMode(key::Symbol, value::Any)\r\n	global MOD\r\n	if key == :POLYGONMODE\r\n		k=eval(Symbol(PREFIX,value[1]))\r\n		v=eval(Symbol(PREFIX,value[2]))\r\n		:($MOD.glPolygonMode($k,$v);)\r\n	else\r\n		:()\r\n	end\r\nendfunction resetBuffers()	StorageManager.unbindStorages() endfunction resetRegisters()\r\n	#StorageManager.unbindStorages()\r\n	ShaderManager.reset()\r\nend"
},

{
    "location": "files/JLGEngine/LibGL/GLDebugControl.html#",
    "page": "GLDebugControl.jl",
    "title": "GLDebugControl.jl",
    "category": "page",
    "text": ""
},

{
    "location": "files/JLGEngine/LibGL/GLDebugControl.html#GLDebugControl.jl-1",
    "page": "GLDebugControl.jl",
    "title": "GLDebugControl.jl",
    "category": "section",
    "text": "using ModernGLusing ..GLListsfunction printError(title=nothing)\r\n result=false\r\n	while (err = checkError())[1]\r\n		if typeof(title) == String\r\n			err=err[2]\r\n			errstr = haskey(LIST_ERROR,err) ? LIST_ERROR[err] : \"\"\r\n			warn(\"OpenGL Error! $(title): $(errstr)\")\r\n		end\r\n		if !result result=true end\r\n	end\r\n	result\r\nendfunction checkError()\r\n	err = glGetError()\r\n	(err != GL_NO_ERROR, err)\r\nendhasNoError()function getInfoLog(s::Symbol, id::GLuint)\r\n	len = zeros(GLint,1)\r\n	LIST_STATUS[s][:STATE](id, GL_INFO_LOG_LENGTH, len)\r\n	len = len[]\r\n	#log := strings.Repeat(\"\\x00\", int(logLength+1))\r\n	#d[::INFO](id, logLength, nil, glStr(log))\r\n	#glGetShaderInfoLog(id, logLength, nil, gl.Str(log))\r\n	#glGetProgramInfoLog(id, logLength, nil, gl.Str(log))\r\n\r\n	if len > 0\r\n		buffer = zeros(GLchar, len)\r\n		sizei = zeros(GLsizei,1)\r\n		LIST_STATUS[s][:INFO](id, len, sizei, buffer)\r\n		len = sizei[]\r\n		unsafe_string(pointer(buffer),len) # bytestring(pointer(buffer), len)\r\n	else\r\n		\"\"\r\n	end\r\nendvalidate(s::Symbol, id::GLuint, status::GLenum) = (result = zeros(GLint,1); LIST_STATUS[s][:STATE](id, status, result); result[] == GL_TRUE)"
},

{
    "location": "files/JLGEngine/LibGL/GLExtendedFunctions.html#",
    "page": "GLExtendedFunctions.jl",
    "title": "GLExtendedFunctions.jl",
    "category": "page",
    "text": ""
},

{
    "location": "files/JLGEngine/LibGL/GLExtendedFunctions.html#GLExtendedFunctions.jl-1",
    "page": "GLExtendedFunctions.jl",
    "title": "GLExtendedFunctions.jl",
    "category": "section",
    "text": "using MatrixMath using ModernGLfunction glGetActiveUniform(program::GLuint, index::Integer)\r\n    actualLength   = GLsizei[1]\r\n    uniformSize    = GLint[1]\r\n    typ            = GLenum[1]\r\n    maxcharsize    = glGetProgramiv(program, GL_ACTIVE_UNIFORM_MAX_LENGTH)\r\n    name           = Vector{GLchar}(maxcharsize)\r\n\r\n    glGetActiveUniform(program, index, maxcharsize, actualLength, uniformSize, typ, name)\r\n\r\n    actualLength[1] <= 0 &&  error(\"No active uniform at given index. Index: \", index)\r\n\r\n    uname = unsafe_string(pointer(name), actualLength[1])\r\n    uname = Symbol(replace(uname, r\"\\[\\d*\\]\", \"\")) # replace array brackets. This is not really a good solution.\r\n    (uname, typ[1], uniformSize[1])\r\nendfunction glGetActiveAttrib(program::GLuint, index::Integer)\r\n    actualLength   = GLsizei[1]\r\n    attributeSize  = GLint[1]\r\n    typ            = GLenum[1]\r\n    maxcharsize    = glGetProgramiv(program, GL_ACTIVE_ATTRIBUTE_MAX_LENGTH)\r\n    name           = Vector{GLchar}(maxcharsize)\r\n\r\n    glGetActiveAttrib(program, index, maxcharsize, actualLength, attributeSize, typ, name)\r\n\r\n    actualLength[1] <= 0 && error(\"No active uniform at given index. Index: \", index)\r\n\r\n    uname = unsafe_string(pointer(name), actualLength[1])\r\n    uname = Symbol(replace(uname, r\"\\[\\d*\\]\", \"\")) # replace array brackets. This is not really a good solution.\r\n    (uname, typ[1], attributeSize[1])\r\nendfunction glGetActiveUniformsiv(program::GLuint, index::Integer, variable::GLenum)\r\n    result = Ref{GLint}(-1)\r\n		#glGetActiveUniformBlockiv(program, index, variable, result)\r\n    result[]\r\nend"
},

{
    "location": "files/JLGEngine/LibGL/GLExtendedFunctions.html#display-information-for-a-program\'s-attributes-1",
    "page": "GLExtendedFunctions.jl",
    "title": "display information for a program\'s attributes",
    "category": "section",
    "text": "function getAttributesInfo(program::GLuint)\r\n	# how many attribs?\r\n	@show activeAttr = glGetProgramiv(program, GL_ACTIVE_ATTRIBUTES)\r\n	# get location and type for each attrib\r\n	for i=0:activeAttr-1\r\n		@show name, typ, siz = glGetActiveAttrib(program,	i)\r\n		@show loc = glGetAttribLocation(program, name)\r\n	end\r\nend"
},

{
    "location": "files/JLGEngine/LibGL/GLExtendedFunctions.html#display-info-for-all-active-uniforms-in-a-program-1",
    "page": "GLExtendedFunctions.jl",
    "title": "display info for all active uniforms in a program",
    "category": "section",
    "text": "function getUniformsInfo(program::GLuint)\r\n	# Get uniforms info (not in named blocks)\r\n	@show activeUnif = glGetProgramiv(program, GL_ACTIVE_UNIFORMS)\r\n\r\n	for i=0:activeUnif-1\r\n		@show index = glGetActiveUniformsiv(program, i, GL_UNIFORM_BLOCK_INDEX)\r\n		if (index == -1)\r\n			@show name 		     = glGetActiveUniformName(program, i)\r\n			@show uniType 	   	 = glGetActiveUniformsiv(program, i, GL_UNIFORM_TYPE)\r\n\r\n			@show uniSize 	   	 = glGetActiveUniformsiv(program, i, GL_UNIFORM_SIZE)\r\n			@show uniArrayStride = glGetActiveUniformsiv(program, i, GL_UNIFORM_ARRAY_STRIDE)\r\n\r\n			auxSize = 0\r\n			if (uniArrayStride > 0)\r\n				@show auxSize = uniArrayStride * uniSize\r\n			else\r\n				@show auxSize = spGLSLTypeSize[uniType]\r\n			end\r\n		end\r\n	end\r\n	# Get named blocks info\r\n	@show count = glGetProgramiv(program, GL_ACTIVE_UNIFORM_BLOCKS)\r\n\r\n	for i=0:count-1\r\n		# Get blocks name\r\n		@show name 	 		 = glGetActiveUniformBlockName(program, i)\r\n		@show dataSize 		 = glGetActiveUniformBlockiv(program, i, GL_UNIFORM_BLOCK_DATA_SIZE)\r\n\r\n		@show index 	 		 = glGetActiveUniformBlockiv(program, i,  GL_UNIFORM_BLOCK_BINDING)\r\n		@show binding_point 	 = glGetIntegeri_v(GL_UNIFORM_BUFFER_BINDING, index)\r\n\r\n		@show activeUnif   	 = glGetActiveUniformBlockiv(program, i, GL_UNIFORM_BLOCK_ACTIVE_UNIFORMS)\r\n\r\n		indices = zeros(GLuint, activeUnif)\r\n		glGetActiveUniformBlockiv(program, i, GL_UNIFORM_BLOCK_ACTIVE_UNIFORM_INDICES, indices)\r\n		@show indices\r\n		for ubindex in indices\r\n			@show name 		   = glGetActiveUniformName(program, ubindex)\r\n			@show uniType 	   = glGetActiveUniformsiv(program, ubindex, GL_UNIFORM_TYPE)\r\n			@show uniOffset    = glGetActiveUniformsiv(program, ubindex, GL_UNIFORM_OFFSET)\r\n			@show uniSize 	   = glGetActiveUniformsiv(program, ubindex, GL_UNIFORM_SIZE)\r\n			@show uniMatStride = glGetActiveUniformsiv(program, ubindex, GL_UNIFORM_MATRIX_STRIDE)\r\n		end\r\n	end\r\nend"
},

{
    "location": "files/JLGEngine/LibGL/GLExtendedFunctions.html#display-the-values-for-a-uniform-in-a-named-block-1",
    "page": "GLExtendedFunctions.jl",
    "title": "display the values for a uniform in a named block```",
    "category": "section",
    "text": "function getUniformInBlockInfo(program::GLuint, blockName, uniName)\r\n	@show index = glGetUniformBlockIndex(program, blockName)\r\n	if (index == GL_INVALID_INDEX)\r\n		println(\"$uniName is not a valid uniform name in block $blockName\")\r\n	end\r\n	@show bindIndex 		= glGetActiveUniformBlockiv(program, index, GL_UNIFORM_BLOCK_BINDING)\r\n	@show bufferIndex 	= glGetIntegeri_v(GL_UNIFORM_BUFFER_BINDING, bindIndex)\r\n	@show uniIndex 			= glGetUniformIndices(program, uniName)\r\n\r\n	@show uniType 			= glGetActiveUniformsiv(program, uniIndex, GL_UNIFORM_TYPE)\r\n	@show uniOffset 		= glGetActiveUniformsiv(program, uniIndex, GL_UNIFORM_OFFSET)\r\n	@show uniSize 			= glGetActiveUniformsiv(program, uniIndex, GL_UNIFORM_SIZE)\r\n	@show uniArrayStride 	= glGetActiveUniformsiv(program, uniIndex, GL_UNIFORM_ARRAY_STRIDE)\r\n	@show uniMatStride 		= glGetActiveUniformsiv(program, uniIndex, GL_UNIFORM_MATRIX_STRIDE)\r\nend"
},

{
    "location": "files/JLGEngine/LibGL/GLExtendedFunctions.html#display-program\'s-information-1",
    "page": "GLExtendedFunctions.jl",
    "title": "display program\'s information",
    "category": "section",
    "text": "function getProgramInfo(program::GLuint)\r\n	# check if name is really a program\r\n	@show program\r\n	# Get the shader\'s name\r\n	@show shaders = glGetAttachedShaders(program)\r\n	for shader in shaders\r\n		@show info = GLENUM(convert(GLenum, glGetShaderiv(shader, GL_SHADER_TYPE))).name\r\n	end\r\n	# Get program info\r\n	@show info = glGetProgramiv(program, GL_PROGRAM_SEPARABLE)\r\n	@show info = glGetProgramiv(program, GL_PROGRAM_BINARY_RETRIEVABLE_HINT)\r\n	@show info = glGetProgramiv(program, GL_LINK_STATUS)\r\n	@show info = glGetProgramiv(program, GL_VALIDATE_STATUS)\r\n	@show info = glGetProgramiv(program, GL_DELETE_STATUS)\r\n	@show info = glGetProgramiv(program, GL_ACTIVE_ATTRIBUTES)\r\n	@show info = glGetProgramiv(program, GL_ACTIVE_UNIFORMS)\r\n	@show info = glGetProgramiv(program, GL_ACTIVE_UNIFORM_BLOCKS)\r\n	@show info = glGetProgramiv(program, GL_ACTIVE_ATOMIC_COUNTER_BUFFERS)\r\n	@show info = glGetProgramiv(program, GL_TRANSFORM_FEEDBACK_BUFFER_MODE)\r\n	@show info = glGetProgramiv(program, GL_TRANSFORM_FEEDBACK_VARYINGS)\r\nendglSwitch(id::Symbol, on::Bool) = (option = Options[id]; on ? glEnable(option) : glDisable(option))\r\n#glDepthMask(on)glShaderSource(shaderID::GLuint, source::String) = (shadercode=Vector{UInt8}(string(source,\"\\x00\")); glShaderSource(shaderID, 1, Ptr{UInt8}[pointer(shadercode)], Ref{GLint}(length(shadercode))))function glGetShaderSource(shaderID::GLuint)\r\n	len = Ref(GLint(0))\r\n	glGetShaderiv(shaderID, GL_SHADER_SOURCE_LENGTH, len)\r\n	len=len.x\r\n\r\n	if len <= 0 return \"\" end\r\n	println(len)\r\n\r\n	sourceLen = len\r\n	source = zeros(GLchar,len)\r\n	len = zeros(GLsizei,1)\r\n	glGetShaderSource(shaderID, sourceLen, pointer(len), pointer(source)) #(shader::GLuint, bufSize::GLsizei, length::Ptr{GLsizei}, source::Ptr{GLchar})::Void\r\n\r\n	source=convert(String, source[1:sourceLen-1])\r\n	println(source)\r\n	chomp(readline())\r\nendfunction glCompile(shaderID::GLuint, source::String)\r\n	glShaderSource(shaderID, source)\r\n	glCompileShader(shaderID)\r\nendglGetShaderiv(shaderID::GLuint, variable::GLenum) = (result = Ref{GLint}(-1); glGetShaderiv(shaderID, variable, result); result[])glGetProgramiv(programID::GLuint, variable::GLenum) = (result = Ref{GLint}(-1); glGetProgramiv(programID, variable, result); result[])function glGetAttachedShaders(program::GLuint)\r\n    shader_count   = glGetProgramiv(program, GL_ATTACHED_SHADERS)\r\n    length_written = GLsizei[0]\r\n    shaders        = zeros(GLuint, shader_count)\r\n\r\n    glGetAttachedShaders(program, shader_count, length_written, shaders)\r\n    shaders[1:first(length_written)]\r\nendfunction getValByRef(f::Function, arg)\r\n	ref = Ref(arg)\r\n	f(ref)\r\n	ref.x\r\nendglString(name::GLenum) = unsafe_string(glGetString(name))glString(name::GLenum, index::GLuint) = unsafe_string(glGetStringi(name,index))glGetIntegerv(name::GLenum) = getValByRef((r)->glGetIntegerv(name,r), GLint(-1))glGetInteger64v(name::GLenum) = getValByRef((r)->glGetInteger64v(name,r), GLint64(-1))glGetBooleanv(name::GLenum) = getValByRef((r)->glGetBooleanv(name,r), GLboolean(false))glGetFloatv(name::GLenum) = getValByRef((r)->glGetFloatv(name,r), GLfloat(-1))glGetDoublev(name::GLenum) = getValByRef((r)->glGetDoublev(name,r), GLdouble(-1))glGetIntegeri_v(name::GLenum, index::GLuint) = getValByRef((r)->glGetIntegeri_v(name,r), GLint(-1))glGetInteger64i_v(name::GLenum, index::GLuint) = getValByRef((r)->glGetInteger64i_v(name,r), GLint64(-1))glGetBooleani_v(name::GLenum, index::GLuint) = getValByRef((r)->glGetBooleani_v(name,r), GLboolean(false))glGetFloati_v(name::GLenum, index::GLuint) = getValByRef((r)->glGetFloati_v(name,r), GLfloat(-1))glGetDoublei_v(name::GLenum, index::GLuint) = getValByRef((r)->glGetDoublei_v(name,r), GLdouble(-1))function glGet(typ::DataType, name::GLenum)\r\n\r\n	fn = nothing\r\n	ti = typeof(index)\r\n\r\n	if typ == GLboolean fn = glGetBooleanv\r\n	elseif typ == GLint fn = glGetIntegerv\r\n	elseif typ == GLint64 fn = glGetInteger64v\r\n	elseif typ == GLfloat fn = glGetFloatv\r\n	elseif typ == GLdouble fn = glGetDoublev\r\n	end\r\n\r\n	if fn != nothing return fn(name) end #getValByRef((r)->(fn)(name,r), typ(-1))	end\r\n	nothing\r\nendfunction glGet(typ::DataType, name::GLenum, index::GLuint)\r\n\r\n	fn = nothing\r\n	ti = typeof(index)\r\n\r\n	if typ == GLboolean fn = glGetBooleani_v\r\n	elseif typ == GLint fn = glGetIntegeri_v\r\n	elseif typ == GLint64 fn = glGetInteger64i_v\r\n	elseif typ == GLfloat fn = glGetFloati_v\r\n	elseif typ == GLdouble fn = glGetDoublei_v\r\n	end\r\n\r\n	if fn != nothing return fn(name,index) end #getValByRef((r)->(fn)(name,index,r), typ(-1))	end\r\n	nothing\r\nendsetFragLocation(id::GLuint, name::String, colorNumber=GLuint(0)) = glFragLocation(id, name, colorNumber)glFragLocation(id::GLuint, name::String, colorNumber::GLuint) = glBindFragDataLocation(id, colorNumber, pointer(string(name,\"\\x00\")))glAttribLocation(id::GLuint, name::String) = glGetAttribLocation(id, pointer(string(name,\"\\x00\")))glUniformLocation(id::GLuint, name::String) = glGetUniformLocation(id, pointer(string(name,\"\\x00\")))glUniform(location::GLint, value::Bool) = glUniform1ui(location, GLuint(value?1:0))\r\nglUniform(location::GLint, value::UInt32) = glUniform1ui(location, GLuint(value))\r\nglUniform(location::GLint, value::UInt64) = glUniform1ui(location, GLuint(value))\r\nglUniform(location::GLint, value::Int32) = glUniform1i(location, GLint(value))\r\nglUniform(location::GLint, value::Int64) = glUniform1i(location, GLint(value))\r\nglUniform(location::GLint, value::Float32) = glUniform1f(location, GLfloat(value))\r\nglUniform(location::GLint, value::Float64) = glUniform1d(location, GLdouble(value))\r\nglUniform(location::GLint, value::Array{Float32,1}) = glUniform1fv(location, length(value), pointer(value))\r\nglUniform(location::GLint, value::Array{Float64,1}) = glUniform1dv(location, length(value), pointer(value))\r\n#glUniform(location::GLint, value::Array{Vec{2, Float32},1}) = glUniform2fv(location, length(value), pointer(value))\r\n#glUniform(location::GLint, value::Array{Vec{3, Float32},1}) = glUniform3fv(location, length(value), pointer(value))\r\n#glUniform(location::GLint, value::Array{Vec{4, Float32},1}) = glUniform4fv(location, length(value), pointer(value))\r\nglUniform(location::GLint, value::Vec2f) = glUniform2fv(location, 1, pointer(convert(Array, value)))\r\nglUniform(location::GLint, value::Vec3f) = glUniform3fv(location, 1, pointer(convert(Array, value)))\r\nglUniform(location::GLint, value::Vec4f) = glUniform4fv(location, 1, pointer(convert(Array, value)))\r\nglUniform(location::GLint, value::Mat2x2f, transpose=false) = glUniformMatrix2fv(location, 1, transpose, pointer(convert(Array, value)))\r\nglUniform(location::GLint, value::Mat3x3f, transpose=false) = glUniformMatrix3fv(location, 1, transpose, pointer(convert(Array, value)))\r\nglUniform(location::GLint, value::Mat4x4f, transpose=false) = glUniformMatrix4fv(location, 1, transpose, pointer(convert(Array, value)))"
},

{
    "location": "files/JLGEngine/LibGL/GLLists.html#",
    "page": "GLLists.jl",
    "title": "GLLists.jl",
    "category": "page",
    "text": ""
},

{
    "location": "files/JLGEngine/LibGL/GLLists.html#GLLists.jl-1",
    "page": "GLLists.jl",
    "title": "GLLists.jl",
    "category": "section",
    "text": "using ModernGLconst GL_QUERY_BUFFER = 0x9192 # (was not defined)const LIST_STATUS = Dict{Symbol,Dict{Symbol,Function}}(\r\n	:SHADER		=> Dict{Symbol,Function}(:STATE => glGetShaderiv, :INFO => glGetShaderInfoLog),\r\n	:PROGRAM	=> Dict{Symbol,Function}(:STATE => glGetProgramiv, :INFO => glGetProgramInfoLog),\r\n)\r\n\r\nconst LIST_BUFFER = Dict{Symbol,GLenum}(\r\n	:ARRAY_BUFFER								=> GL_ARRAY_BUFFER,\r\n	:ATOMIC_COUNTER_BUFFER			=> GL_ATOMIC_COUNTER_BUFFER,\r\n	:COPY_READ_BUFFER						=> GL_COPY_READ_BUFFER,\r\n	:COPY_WRITE_BUFFER					=> GL_COPY_WRITE_BUFFER,\r\n	:DISPATCH_INDIRECT_BUFFER		=> GL_DISPATCH_INDIRECT_BUFFER,\r\n	:DRAW_INDIRECT_BUFFER				=> GL_DRAW_INDIRECT_BUFFER,\r\n	:ELEMENT_ARRAY_BUFFER				=> GL_ELEMENT_ARRAY_BUFFER,\r\n	:PIXEL_PACK_BUFFER					=> GL_PIXEL_PACK_BUFFER,\r\n	:PIXEL_UNPACK_BUFFER				=> GL_PIXEL_UNPACK_BUFFER,\r\n	:QUERY_BUFFER								=> GL_QUERY_BUFFER,\r\n	:SHADER_STORAGE_BUFFER			=> GL_SHADER_STORAGE_BUFFER,\r\n	:TEXTURE_BUFFER							=> GL_TEXTURE_BUFFER,\r\n	:TRANSFORM_FEEDBACK_BUFFER	=> GL_TRANSFORM_FEEDBACK_BUFFER,\r\n	:UNIFORM_BUFFER							=> GL_UNIFORM_BUFFER,\r\n)\r\n\r\nconst CLIP_DISTANCE = [\r\n	GL_CLIP_DISTANCE0,\r\n	GL_CLIP_DISTANCE1,\r\n	GL_CLIP_DISTANCE2,\r\n	GL_CLIP_DISTANCE3,\r\n	GL_CLIP_DISTANCE4,\r\n	GL_CLIP_DISTANCE5,\r\n	GL_CLIP_DISTANCE6,\r\n	GL_CLIP_DISTANCE7,\r\n	#GL_CLIP_DISTANCE8,\r\n]\r\n\r\n#	GL_CLIP_ORIGIN,\r\n#	GL_CLIP_DEPTH_MODE\r\n#	GL_CLIPPING_INPUT_PRIMITIVES_ARB\r\n#	GL_CLIPPING_OUTPUT_PRIMITIVES_ARB\r\n\r\nconst LIST_OPTIONS = Dict{Symbol,GLuint}(\r\n	:ALPHA_TEST                     => 0,                                # GL_ALPHA_TEST\r\n	:AUTO_NORMAL                    => GL_AUTO_GENERATE_MIPMAP,          # GL_AUTO_NORMAL\r\n	:BLEND                          => GL_BLEND,                         # GL_BLEND\r\n	:CLIP_PLANEi                    => 0,                                # GL_CLIP_PLANEi\r\n	:CLIP_DISTANCEi                 => 0,                                # GL_CLIP_DISTANCEi\r\n	:COLOR_LOGIC_OP                 => GL_COLOR_LOGIC_OP,                # GL_COLOR_LOGIC_OP\r\n	:COLOR_MATERIAL                 => 0,                                # GL_COLOR_MATERIAL\r\n	:COLOR_SUM                      => 0,                                # GL_COLOR_SUM\r\n	:COLOR_TABLE                    => 0,                                # GL_COLOR_TABLE\r\n	:CONVOLUTION_1D                 => 0,                                # GL_CONVOLUTION_1D\r\n	:CONVOLUTION_2D                 => 0,                                # GL_CONVOLUTION_2D\r\n	:CULL_FACE                      => GL_CULL_FACE,                     # GL_CULL_FACE\r\n	:DEBUG_OUTPUT                   => GL_DEBUG_OUTPUT,                  # GL_DEBUG_OUTPUT\r\n	:DEBUG_OUTPUT_SYNCHRONOUS       => GL_DEBUG_OUTPUT_SYNCHRONOUS,      # GL_DEBUG_OUTPUT_SYNCHRONOUS\r\n	:DEPTH_CLAMP                    => GL_DEPTH_CLAMP,                   # GL_DEPTH_CLAMP\r\n	:DEPTH_TEST                     => GL_DEPTH_TEST,                    # GL_DEPTH_TEST\r\n	:DITHER                         => GL_DITHER,                        # GL_DITHER\r\n	:FOG                            => 0,                                # GL_FOG\r\n	:FRAMEBUFFER_SRGB               => GL_FRAMEBUFFER_SRGB,              # GL_FRAMEBUFFER_SRGB\r\n	:HISTOGRAM                      => 0,                                # GL_HISTOGRAM\r\n	:INDEX_LOGIC_OP                 => 0,                                # GL_INDEX_LOGIC_OP\r\n	:LIGHTi                         => 0,                                # GL_LIGHTi\r\n	:LIGHTING                       => 0,                                # GL_LIGHTING\r\n	:LINE_SMOOTH                    => GL_LINE_SMOOTH,                   # GL_LINE_SMOOTH\r\n	:LINE_STIPPLE                   => 0,                                # GL_LINE_STIPPLE\r\n	:MAP1_COLOR_4                   => 0,                                # GL_MAP1_COLOR_4\r\n	:MAP1_INDEX                     => 0,                                # GL_MAP1_INDEX\r\n	:MAP1_NORMAL                    => 0,                                # GL_MAP1_NORMAL\r\n	:MAP1_TEXTURE_COORD_1           => 0,                                # GL_MAP1_TEXTURE_COORD_1\r\n	:MAP1_TEXTURE_COORD_2           => 0,                                # GL_MAP1_TEXTURE_COORD_2\r\n	:MAP1_TEXTURE_COORD_3           => 0,                                # GL_MAP1_TEXTURE_COORD_3\r\n	:MAP1_TEXTURE_COORD_4           => 0,                                # GL_MAP1_TEXTURE_COORD_4\r\n	:MAP1_VERTEX_3                  => 0,                                # GL_MAP1_VERTEX_3\r\n	:MAP1_VERTEX_4                  => 0,                                # GL_MAP1_VERTEX_4\r\n	:MAP2_COLOR_4                   => 0,                                # GL_MAP2_COLOR_4\r\n	:MAP2_INDEX                     => 0,                                # GL_MAP2_INDEX\r\n	:MAP2_NORMAL                    => 0,                                # GL_MAP2_NORMAL\r\n	:MAP2_TEXTURE_COORD_1           => 0,                                # GL_MAP2_TEXTURE_COORD_1\r\n	:MAP2_TEXTURE_COORD_2           => 0,                                # GL_MAP2_TEXTURE_COORD_2\r\n	:MAP2_TEXTURE_COORD_3           => 0,                                # GL_MAP2_TEXTURE_COORD_3\r\n	:MAP2_TEXTURE_COORD_4           => 0,                                # GL_MAP2_TEXTURE_COORD_4\r\n	:MAP2_VERTEX_3                  => 0,                                # GL_MAP2_VERTEX_3\r\n	:MAP2_VERTEX_4                  => 0,                                # GL_MAP2_VERTEX_4\r\n	:MINMAX                         => 0,                                # GL_MINMAX\r\n	:MULTISAMPLE                    => GL_MULTISAMPLE,                   # GL_MULTISAMPLE\r\n	:NORMALIZE                      => 0,                                # GL_NORMALIZE\r\n	:POINT_SMOOTH                   => 0,                                # GL_POINT_SMOOTH\r\n	:POINT_SPRITE                   => 0,                                # GL_POINT_SPRITE\r\n	:POLYGON_OFFSET_FILL            => GL_POLYGON_OFFSET_FILL,           # GL_POLYGON_OFFSET_FILL\r\n	:POLYGON_OFFSET_LINE            => GL_POLYGON_OFFSET_LINE,           # GL_POLYGON_OFFSET_LINE\r\n	:POLYGON_OFFSET_POINT           => GL_POLYGON_OFFSET_POINT,          # GL_POLYGON_OFFSET_POINT\r\n	:POLYGON_SMOOTH                 => GL_POLYGON_SMOOTH,                # GL_POLYGON_SMOOTH\r\n	:POLYGON_STIPPLE                => 0,                                # GL_POLYGON_STIPPLE\r\n	:POST_COLOR_MATRIX_COLOR_TABLE  => 0,                                # GL_POST_COLOR_MATRIX_COLOR_TABLE\r\n	:POST_CONVOLUTION_COLOR_TABLE   => 0,                                # GL_POST_CONVOLUTION_COLOR_TABLE\r\n	:PRIMITIVE_RESTART              => GL_PRIMITIVE_RESTART,             # GL_PRIMITIVE_RESTART\r\n	:PRIMITIVE_RESTART_FIXED_INDEX  => GL_PRIMITIVE_RESTART_FIXED_INDEX, # GL_PRIMITIVE_RESTART_FIXED_INDEX\r\n	:PROGRAM_POINT_SIZE             => GL_PROGRAM_POINT_SIZE,            # GL_PROGRAM_POINT_SIZE\r\n	:RASTERIZER_DISCARD             => GL_RASTERIZER_DISCARD,            # GL_RASTERIZER_DISCARD\r\n	:RESCALE_NORMAL                 => 0,                                # GL_RESCALE_NORMAL\r\n	:SAMPLE_ALPHA_TO_COVERAGE       => GL_SAMPLE_ALPHA_TO_COVERAGE,      # GL_SAMPLE_ALPHA_TO_COVERAGE\r\n	:SAMPLE_ALPHA_TO_ONE            => GL_SAMPLE_ALPHA_TO_ONE,           # GL_SAMPLE_ALPHA_TO_ONE\r\n	:SAMPLE_COVERAGE                => GL_SAMPLE_COVERAGE,               # GL_SAMPLE_COVERAGE\r\n	:SAMPLE_SHADING                 => GL_SAMPLE_SHADING,                # GL_SAMPLE_SHADING\r\n	:SAMPLE_MASK                    => GL_SAMPLE_MASK,                   # GL_SAMPLE_MASK\r\n	:SEPARABLE_2D                   => 0,                                # GL_SEPARABLE_2D\r\n	:SCISSOR_TEST                   => GL_SCISSOR_TEST,                  # GL_SCISSOR_TEST\r\n	:STENCIL_TEST                   => GL_STENCIL_TEST,                  # GL_STENCIL_TEST\r\n	:TEXTURE_1D                     => GL_TEXTURE_1D,                    # GL_TEXTURE_1D\r\n	:TEXTURE_2D                     => GL_TEXTURE_2D,                    # GL_TEXTURE_2D\r\n	:TEXTURE_3D                     => GL_TEXTURE_3D,                    # GL_TEXTURE_3D\r\n	:TEXTURE_CUBE_MAP               => GL_TEXTURE_CUBE_MAP,              # GL_TEXTURE_CUBE_MAP\r\n	:TEXTURE_CUBE_MAP_SEAMLESS      => GL_TEXTURE_CUBE_MAP_SEAMLESS,     # GL_TEXTURE_CUBE_MAP_SEAMLESS\r\n	:TEXTURE_GEN_Q                  => 0,                                # GL_TEXTURE_GEN_Q\r\n	:TEXTURE_GEN_R                  => 0,                                # GL_TEXTURE_GEN_R\r\n	:TEXTURE_GEN_S                  => 0,                                # GL_TEXTURE_GEN_S\r\n	:TEXTURE_GEN_T                  => 0,                                # GL_TEXTURE_GEN_T\r\n	:VERTEX_PROGRAM_POINT_SIZE      => GL_VERTEX_PROGRAM_POINT_SIZE,     # GL_VERTEX_PROGRAM_POINT_SIZE\r\n	:VERTEX_PROGRAM_TWO_SIDE        => 0,                                # GL_VERTEX_PROGRAM_TWO_SIDE\r\n)\r\n\r\nconst LIST_COLOR_MASK = Dict{Symbol,GLuint}(\r\n	:SRC_COLOR                 => GL_SRC_COLOR,\r\n	:ONE_MINUS_SRC_COLOR       => GL_ONE_MINUS_SRC_COLOR,\r\n	:DST_COLOR                 => GL_DST_COLOR,\r\n	:ONE_MINUS_DST_COLOR       => GL_ONE_MINUS_DST_COLOR,\r\n	:SRC_ALPHA                 => GL_SRC_ALPHA,\r\n	:ONE_MINUS_SRC_ALPHA       => GL_ONE_MINUS_SRC_ALPHA,\r\n	:DST_ALPHA                 => GL_DST_ALPHA,\r\n	:ONE_MINUS_DST_ALPHA       => GL_ONE_MINUS_DST_ALPHA,\r\n	:CONSTANT_COLOR            => GL_CONSTANT_COLOR,\r\n	:ONE_MINUS_CONSTANT_COLOR  => GL_ONE_MINUS_CONSTANT_COLOR,\r\n	:CONSTANT_ALPHA            => GL_CONSTANT_ALPHA,\r\n	:ONE_MINUS_CONSTANT_ALPHA  => GL_ONE_MINUS_CONSTANT_ALPHA,\r\n	:SRC_ALPHA_SATURATE        => GL_SRC_ALPHA_SATURATE,\r\n	:SRC1_COLOR                => GL_SRC1_COLOR,\r\n	:ONE_MINUS_SRC1_COLOR      => GL_ONE_MINUS_SRC1_COLOR,\r\n	:SRC1_ALPHA                => GL_SRC1_ALPHA,\r\n	:ONE_MINUS_SRC1_ALPHA      => GL_ONE_MINUS_SRC1_ALPHA,\r\n)\r\n\r\nconst LIST_COMPARE = Dict{Symbol,GLuint}(\r\n	:NEVER     => GL_NEVER,\r\n	:LESS      => GL_LESS,\r\n	:EQUAL     => GL_EQUAL,\r\n	:LEQUAL    => GL_LEQUAL,\r\n	:GREATER   => GL_GREATER,\r\n	:NOTEQUAL  => GL_NOTEQUAL,\r\n	:GEQUAL    => GL_GEQUAL,\r\n	:ALWAYS    => GL_ALWAYS,\r\n)\r\n\r\nconst LIST_INFO = Dict{Symbol,GLuint}(\r\n	:RENDERER =>                 GL_RENDERER,\r\n	:VENDOR =>                   GL_VENDOR,\r\n	:VERSION =>                  GL_VERSION,\r\n	:SHADING_LANGUAGE_VERSION => GL_SHADING_LANGUAGE_VERSION,\r\n	:EXTENSIONS =>               GL_EXTENSIONS,\r\n)\r\n\r\nconst DEFAULT_SHADER_VERSION = 130\r\n\r\nfunction DEFAULT_SHADER_CODE(typ::Symbol)\r\n	code = LIST_SHADER[typ][:CODE]\r\n	string(\"#version \",DEFAULT_SHADER_VERSION,\"\\n\",code[1],\"\\n\",code[2],\"\\nvoid main(){\\n\",code[3],\"\\n}\")\r\nend\r\n\r\nconst LIST_SHADER = Dict(\r\n	:VERTEX           => Dict(:TYPE => GLuint(GL_VERTEX_SHADER),					:EXT => \"vert\", :CODE => (\"in vec3 iVertex; uniform mat4 iMVP = mat4(vec4(1,0,0,0),vec4(0,1,0,0),vec4(0,0,1,0),vec4(0,0,0,1));\", \"\", \"gl_Position = iMVP * vec4(iVertex,1);\")),\r\n	:FRAGMENT         => Dict(:TYPE => GLuint(GL_FRAGMENT_SHADER),				:EXT => \"frag\", :CODE => (\"\", \"out vec4 oFragColor;\", \"oFragColor=vec4(vec3(0.5),1.0);\")),\r\n	:TESS_CONTROL			=> Dict(:TYPE => GLuint(GL_TESS_CONTROL_SHADER),		:EXT => \"tesc\", :CODE => (\"uniform uint iTessLevel = 1;\", \"layout (vertices = 3) out;\", \"#define ID gl_InvocationID\\n if (ID == 0) for(int i=0; i<3; ++i){	if(i<2) gl_TessLevelInner[i] = iTessLevel; gl_TessLevelOuter[i] = iTessLevel; }; gl_out[ID].gl_Position = gl_in[ID].gl_Position;\")),\r\n	:TESS_EVALUATION	=> Dict(:TYPE => GLuint(GL_TESS_EVALUATION_SHADER),	:EXT => \"tese\", :CODE => (\"layout (triangles, equal_spacing, ccw) in;\", \"\", \"gl_Position = vec4(gl_in[0].gl_Position.xyz * gl_TessCoord.x + gl_in[1].gl_Position.xyz * gl_TessCoord.y + gl_in[2].gl_Position.xyz * gl_TessCoord.z,1.0);\")),\r\n	:GEOMETRY         => Dict(:TYPE => GLuint(GL_GEOMETRY_SHADER),				:EXT => \"geom\",	:CODE => (\"layout(triangles) in;\", \"layout(triangle_strip, max_vertices=3) out;\", \"for(int i=0; i<gl_in.length(); ++i){ gl_Position = gl_in[i].gl_Position; EmitVertex(); }; EndPrimitive();\")),\r\n	:COMPUTE          => Dict(:TYPE => GLuint(GL_COMPUTE_SHADER),					:EXT => \"comp\",	:CODE => (\"\", \"\", \"\")),\r\n)\r\n\r\nconst LIST_DRAW_MODE = Dict{Symbol,GLuint}(\r\n	:POINTS										=> GL_POINTS,										#0x0000\r\n	:LINES										=> GL_LINE,											#0x0001\r\n	:LINE_LOOP								=> GL_LINE_LOOP,								#0x0002\r\n	:LINE_STRIP     					=> GL_LINE_STRIP,								#0x0003\r\n	:TRIANGLES 								=> GL_TRIANGLES,								#0x0004\r\n	:TRIANGLE_STRIP  					=> GL_TRIANGLE_STRIP,						#0x0005\r\n	:TRIANGLE_FAN							=> GL_TRIANGLE_FAN,							#0x0006\r\n	:QUADS										=> GL_QUADS,										#0x0007\r\n	:QUAD_STRIP								=> GL_QUAD_STRIP,								#0x0008 (deprecated since OpenGL3)\r\n	:POLYGON									=> GL_POLYGON,									#0x0009 (deprecated since OpenGL3)\r\n	:LINES_ADJACENCY					=> GL_LINES_ADJACENCY,					#0x000A\r\n	:LINE_STRIP_ADJACENCY			=> GL_LINE_STRIP_ADJACENCY,			#0x000B\r\n	:TRIANGLES_ADJACENCY			=> GL_TRIANGLES_ADJACENCY,			#0x000C\r\n	:TRIANGLE_STRIP_ADJACENCY	=> GL_TRIANGLE_STRIP_ADJACENCY,	#0x000D\r\n	:PATCHES 									=> GL_PATCHES,									#0x000E\r\n)\r\n\r\nconst LIST_ERROR = Dict{GLuint,AbstractString}(\r\n	GL_NO_ERROR											 =>	\"\",\r\n	GL_INVALID_ENUM									 =>	\"INVALID_ENUM: An unacceptable value is specified for an enumerated argument. The offending command is ignored and has no other side effect than to set the error flag.\",\r\n	GL_INVALID_VALUE								 =>	\"INVALID_VALUE: A numeric argument is out of range. The offending command is ignored and has no other side effect than to set the error flag.\",\r\n	GL_INVALID_OPERATION						 =>	\"INVALID_OPERATION: The specified operation is not allowed in the current state. The offending command is ignored and has no other side effect than to set the error flag.\",\r\n	GL_INVALID_FRAMEBUFFER_OPERATION => \"INVALID_FRAMEBUFFER_OPERATION: The framebuffer object is not complete. The offending command is ignored and has no other side effect than to set the error flag.\",\r\n	GL_OUT_OF_MEMORY								 =>	\"OUT_OF_MEMORY: There is not enough memory left to execute the command. The state of the GL is undefined, except for the state of the error flags, after this error is recorded.\",\r\n	GL_STACK_UNDERFLOW							 =>	\"STACK_UNDERFLOW\",\r\n	GL_STACK_OVERFLOW								 =>	\"STACK_OVERFLOW\",\r\n)\r\n\r\nconst LIST_TYPE = Dict{DataType,GLuint}(\r\n	Bool => GL_BOOL,\r\n	Int8 => GL_BYTE,\r\n	Int16 => GL_SHORT,\r\n	Int32 => GL_INT, #gl_low_int, gl_medium_int, gl_high_int\r\n	Int64 => GL_INT, # no 64 bit support\r\n	Int128 => GL_INT, # no 128 bit support\r\n	UInt8 => GL_UNSIGNED_BYTE,\r\n	UInt16 => GL_UNSIGNED_SHORT,\r\n	UInt32 => GL_UNSIGNED_INT,\r\n	UInt64 => GL_UNSIGNED_INT, # no 64 bit support\r\n	UInt128 => GL_UNSIGNED_INT, # no 128 bit support\r\n	Float16 => GL_HALF_FLOAT,\r\n	Float32 => GL_FLOAT,\r\n	Float64 => GL_DOUBLE,\r\n)\r\n\r\nconst LIST_TYPE_ELEMENTS = Dict{GLuint,UInt32}(\r\n	# Float\r\n	GL_FLOAT =>      1,\r\n	GL_FLOAT_VEC2 => 2,\r\n	GL_FLOAT_VEC3 => 3,\r\n	GL_FLOAT_VEC4 => 4,\r\n\r\n	# Doubles\r\n	GL_DOUBLE =>      1,\r\n	GL_DOUBLE_VEC2 => 2,\r\n	GL_DOUBLE_VEC3 => 3,\r\n	GL_DOUBLE_VEC4 => 4,\r\n\r\n	# Int\r\n	GL_INT =>      1,\r\n	GL_INT_VEC2 => 2,\r\n	GL_INT_VEC3 => 3,\r\n	GL_INT_VEC4 => 4,\r\n\r\n	# Unsigned Int\r\n	GL_UNSIGNED_INT =>      1,\r\n	GL_UNSIGNED_INT_VEC2 => 2,\r\n	GL_UNSIGNED_INT_VEC3 => 3,\r\n	GL_UNSIGNED_INT_VEC4 => 4,\r\n\r\n	# Bool\r\n	GL_BOOL =>      1,\r\n	GL_BOOL_VEC2 => 2,\r\n	GL_BOOL_VEC3 => 3,\r\n	GL_BOOL_VEC4 => 4,\r\n\r\n	# Float Matrix\r\n	GL_FLOAT_MAT2 =>   4,\r\n	GL_FLOAT_MAT3 =>   9,\r\n	GL_FLOAT_MAT4 =>   16,\r\n	GL_FLOAT_MAT2x3 => 6,\r\n	GL_FLOAT_MAT2x4 => 8,\r\n	GL_FLOAT_MAT3x2 => 6,\r\n	GL_FLOAT_MAT3x4 => 12,\r\n	GL_FLOAT_MAT4x2 => 8,\r\n	GL_FLOAT_MAT4x3 => 12,\r\n\r\n	# Double Matrix\r\n	GL_DOUBLE_MAT2 =>   4,\r\n	GL_DOUBLE_MAT3 =>   9,\r\n	GL_DOUBLE_MAT4 =>   16,\r\n	GL_DOUBLE_MAT2x3 => 6,\r\n	GL_DOUBLE_MAT2x4 => 8,\r\n	GL_DOUBLE_MAT3x2 => 6,\r\n	GL_DOUBLE_MAT3x4 => 12,\r\n	GL_DOUBLE_MAT4x2 => 8,\r\n	GL_DOUBLE_MAT4x3 => 12,\r\n)\r\n\r\nconst LIST_TYPE_STRING = Dict{GLuint,AbstractString}(\r\n	# Float\r\n	GL_FLOAT =>      \"float\",\r\n	GL_FLOAT_VEC2 => \"vec2f\",\r\n	GL_FLOAT_VEC3 => \"vec3f\",\r\n	GL_FLOAT_VEC4 => \"vec4f\",\r\n\r\n	# Doubles\r\n	GL_DOUBLE =>      \"double\",\r\n	GL_DOUBLE_VEC2 => \"vec2d\",\r\n	GL_DOUBLE_VEC3 => \"vec3d\",\r\n	GL_DOUBLE_VEC4 => \"vec4d\",\r\n\r\n	# Int\r\n	GL_INT =>      \"int\",\r\n	GL_INT_VEC2 => \"vec2i\",\r\n	GL_INT_VEC3 => \"vec3i\",\r\n	GL_INT_VEC4 => \"vec4i\",\r\n\r\n	# Unsigned Int\r\n	GL_UNSIGNED_INT =>      \"uint\",\r\n	GL_UNSIGNED_INT_VEC2 => \"vec2u\",\r\n	GL_UNSIGNED_INT_VEC3 => \"vec3u\",\r\n	GL_UNSIGNED_INT_VEC4 => \"vec4u\",\r\n\r\n	# Bool\r\n	GL_BOOL =>      \"bool\",\r\n	GL_BOOL_VEC2 => \"vec2b\",\r\n	GL_BOOL_VEC3 => \"vec3b\",\r\n	GL_BOOL_VEC4 => \"vec4b\",\r\n\r\n	# Float Matrix\r\n	GL_FLOAT_MAT2 =>   \"mat2f\",\r\n	GL_FLOAT_MAT3 =>   \"mat3f\",\r\n	GL_FLOAT_MAT4 =>   \"mat4f\",\r\n	GL_FLOAT_MAT2x3 => \"mat2x3f\",\r\n	GL_FLOAT_MAT2x4 => \"mat2x4f\",\r\n	GL_FLOAT_MAT3x2 => \"mat3x2f\",\r\n	GL_FLOAT_MAT3x4 => \"mat3x4f\",\r\n	GL_FLOAT_MAT4x2 => \"mat4x2f\",\r\n	GL_FLOAT_MAT4x3 => \"mat4x3f\",\r\n\r\n	# Double Matrix\r\n	GL_DOUBLE_MAT2 =>   \"mat2d\",\r\n	GL_DOUBLE_MAT3 =>   \"mat3d\",\r\n	GL_DOUBLE_MAT4 =>   \"mat4d\",\r\n	GL_DOUBLE_MAT2x3 => \"mat2x3d\",\r\n	GL_DOUBLE_MAT2x4 => \"mat2x4d\",\r\n	GL_DOUBLE_MAT3x2 => \"mat3x2d\",\r\n	GL_DOUBLE_MAT3x4 => \"mat3x4d\",\r\n	GL_DOUBLE_MAT4x2 => \"mat4x2d\",\r\n	GL_DOUBLE_MAT4x3 => \"mat4x3d\",\r\n\r\n	# Sampler\r\n	GL_SAMPLER_1D =>                   \"sampler1D\",\r\n	GL_SAMPLER_2D =>                   \"sampler2D\",\r\n	GL_SAMPLER_3D =>                   \"sampler3D\",\r\n	GL_SAMPLER_CUBE =>                 \"sampler_Cube\",\r\n	GL_SAMPLER_CUBE_SHADOW =>          \"sampler_Cube_Shadow\",\r\n	GL_SAMPLER_1D_SHADOW =>            \"sampler1D_Shadow\",\r\n	GL_SAMPLER_2D_SHADOW =>            \"sampler2D_Shadow\",\r\n	GL_SAMPLER_1D_ARRAY =>             \"sampler1D_Array\",\r\n	GL_SAMPLER_2D_ARRAY =>             \"sampler2D_Array\",\r\n	GL_SAMPLER_1D_ARRAY_SHADOW =>      \"sampler1D_Array_Shadow\",\r\n	GL_SAMPLER_2D_ARRAY_SHADOW =>      \"sampler2D_Array_Shadow\",\r\n	GL_SAMPLER_2D_MULTISAMPLE =>       \"sampler2D_Multisample\",\r\n	GL_SAMPLER_2D_MULTISAMPLE_ARRAY => \"sampler2D_Multisample_Array\",\r\n	GL_SAMPLER_BUFFER =>               \"sampler_Buffer\",\r\n	GL_SAMPLER_2D_RECT =>              \"sampler2D_Rect\",\r\n	GL_SAMPLER_2D_RECT_SHADOW =>       \"sampler2D_Rect_Shadow\",\r\n\r\n	# Sampler Int\r\n	GL_INT_SAMPLER_1D =>                   \"isampler1D\",\r\n	GL_INT_SAMPLER_2D =>                   \"isampler2D\",\r\n	GL_INT_SAMPLER_3D =>                   \"isampler3D\",\r\n	GL_INT_SAMPLER_CUBE =>                 \"isampler_Cube\",\r\n	GL_INT_SAMPLER_1D_ARRAY =>             \"isampler1D_Array\",\r\n	GL_INT_SAMPLER_2D_ARRAY =>             \"isampler2D_Array\",\r\n	GL_INT_SAMPLER_2D_MULTISAMPLE =>       \"isampler2D_Multisample\",\r\n	GL_INT_SAMPLER_2D_MULTISAMPLE_ARRAY => \"isampler2D_Multisample_Array\",\r\n	GL_INT_SAMPLER_BUFFER =>               \"isampler_Buffer\",\r\n	GL_INT_SAMPLER_2D_RECT =>              \"isampler2D_Rect\",\r\n\r\n	# Sampler Unsigned Int\r\n	GL_UNSIGNED_INT_SAMPLER_1D =>                   \"usampler1D\",\r\n	GL_UNSIGNED_INT_SAMPLER_2D =>                   \"usampler2D\",\r\n	GL_UNSIGNED_INT_SAMPLER_3D =>                   \"usampler3D\",\r\n	GL_UNSIGNED_INT_SAMPLER_CUBE =>                 \"usampler_Cube\",\r\n	GL_UNSIGNED_INT_SAMPLER_1D_ARRAY =>             \"usampler1D_Array\",\r\n	GL_UNSIGNED_INT_SAMPLER_2D_ARRAY =>             \"usampler2D_Array\",\r\n	GL_UNSIGNED_INT_SAMPLER_2D_MULTISAMPLE =>       \"usampler2D_Multisample\",\r\n	GL_UNSIGNED_INT_SAMPLER_2D_MULTISAMPLE_ARRAY => \"usampler2D_Multisample_Array\",\r\n	GL_UNSIGNED_INT_SAMPLER_BUFFER =>               \"usampler_Buffer\",\r\n	GL_UNSIGNED_INT_SAMPLER_2D_RECT =>              \"usampler2D_Rect\",\r\n)"
},

{
    "location": "files/JLGEngine/LibGL/GLSLParser.html#",
    "page": "GLSLParser.jl",
    "title": "GLSLParser.jl",
    "category": "page",
    "text": ""
},

{
    "location": "files/JLGEngine/LibGL/GLSLParser.html#GLSLParser.jl-1",
    "page": "GLSLParser.jl",
    "title": "GLSLParser.jl",
    "category": "section",
    "text": "function readShaders(program::AbstractGraphicsShaderProgram, fileSource::FileSource)\r\n	if program == nothing end\r\n\r\n	global shaderAttributes = []\r\n	shaderSource=\"\"\r\n	globalSource=\"\"\r\n	lokalSource=\"\"\r\n	shaderType=nothing\r\n	pbegin=0\r\n	comment=false\r\n	count=0\r\n\r\n	#o.logShader.Info(\"Shader %s\\n\", path)\r\n	\r\n	clear(program)\r\n\r\n	shaderCatch = function()\r\n		pend=length(shaderSource)\r\n\r\n		if shaderType != nothing\r\n			f=FileSourcePart(fileSource,range(pbegin+1,pend-pbegin))\r\n			f.cache = globalSource * lokalSource #f.source.cache[f.range]\r\n			shader = createShader(program,shaderType,f)\r\n			shader.cache=\"\" #DEFAULT_SHADER_CODE(shaderType) #default\r\n			lokalSource=\"\"\r\n			shaderType=nothing\r\n		end\r\n\r\n		pbegin = pend\r\n		count+=1\r\n		#o.logShader.Info(\"(%v,%v) %s\\n\", sourceBegin, sourceEnd, shader.GetSource())\r\n	end\r\n\r\n	readLines = function(file)\r\n		for line in eachline(file)\r\n			#line=replace(line, \"\\r\", \"\") #remove windows extra break sign\r\n			line=rstrip(lstrip(line)) #trim\r\n			#line=filter(x -> !isspace(x), line)\r\n\r\n			len = length(line)\r\n\r\n			if len < 1 continue end\r\n\r\n			firstSign = line[1]\r\n			inputFmt = firstSign\r\n\r\n			if len > 1 inputFmt = line[1:2] end\r\n\r\n			if comment\r\n				if inputFmt == \"*/\" comment = false end\r\n				#continue\r\n			#elseif firstSign == \'\\n\'\r\n				#continue\r\n			elseif inputFmt == \"/*\"\r\n				comment = true\r\n				#continue\r\n			elseif inputFmt == \"//\" # Comment\r\n				#continue\r\n\r\n				if len < 3 continue	end\r\n\r\n				if line[3] == \'!\'\r\n					ln = line[3:len]\r\n					len = length(ln)\r\n\r\n					if len < 2 continue	end\r\n\r\n					sp = split(ln[2:len], \" \")\r\n					len = length(sp)\r\n					cmd = \"\"\r\n					value = \"\"\r\n\r\n					if len < 1 continue end\r\n\r\n					cmd = uppercase(lstrip(sp[1]))\r\n\r\n					if len > 1\r\n						value = uppercase(rstrip(sp[2]))\r\n\r\n						if cmd == \"\"\r\n							cmd = value\r\n						end\r\n					end\r\n\r\n					#o.logShader.Info(\"(%s):\\n\", value)\r\n\r\n					if cmd == value\r\n						value=Symbol(value)\r\n						if haskey(LIST_SHADER,value)\r\n							shaderCatch()\r\n							shaderType=value\r\n						end\r\n						#for (k, v) in SHADER_FILE_TYPE\r\n						#	if v == value\r\n						#		shaderCatch()\r\n						#		shaderType=v\r\n						#		break\r\n						#	end\r\n						#end\r\n					end\r\n				end\r\n				#continue\r\n\r\n			else\r\n				findShaderProperty(program, line)\r\n				if count == 0\r\n					globalSource = string(globalSource,line,\"\\n\")\r\n				else\r\n					lokalSource = string(lokalSource,line,\"\\n\")\r\n				end\r\n				shaderSource = string(shaderSource,line,\"\\n\")\r\n			end\r\n		end\r\n		shaderCatch()\r\n		fileSource.cache=shaderSource\r\n		shaderSource != \"\"\r\n	end\r\n\r\n	FileManager.waitForFileReady(fileSource.path,readLines)\r\nendinclude(\"GLSLRessources.jl\")"
},

{
    "location": "files/JLGEngine/LibGL/GLSLRessources.html#",
    "page": "GLSLRessources.jl",
    "title": "GLSLRessources.jl",
    "category": "page",
    "text": ""
},

{
    "location": "files/JLGEngine/LibGL/GLSLRessources.html#GLSLRessources.jl-1",
    "page": "GLSLRessources.jl",
    "title": "GLSLRessources.jl",
    "category": "section",
    "text": "using ..StorageManagersetListenerOnShaderPropertyUpdate(id::Symbol, t::Tuple) = setListenerOnShaderPropertyUpdate(id, Dict{String,Function}(t))setListenerOnShaderPropertyUpdate(id::Symbol, d::Dict{String,Function}) = listListenerOnShaderPropertyUpdate[id]=d\r\nremoveListenerOnShaderPropertyUpdate(id::Symbol) = (listListenerOnShaderPropertyUpdate[id]=nothing)setShaderPropberty(program::AbstractGraphicsShaderProgram, name::String, args...) = program != nothing ? glUniform(glUniformLocation(program.id, name), args...) : nothingisAttribute(x) = (x == GL_PROGRAM_INPUT || x == GL_PROGRAM_OUTPUT)isUniform(x) = (x == GL_UNIFORM || x == GL_UNIFORM_BLOCK || x == GL_SHADER_STORAGE_BLOCK)function setVertexAttribArray(program::GLuint, prop::ShaderProperty)\r\n	if prop.location < 0 || prop.data == nothing || !isa(prop.data, GLStorageData) return end\r\n	glEnableVertexAttribArray(prop.location)\r\n	glVertexAttribPointer(prop.location, prop.elements, prop.data.typ,\r\n			GLboolean(prop.data.flags & GL_VERTEX_ATTRIB_ARRAY_NORMALIZED != GL_VERTEX_ATTRIB_ARRAY_NORMALIZED),\r\n			prop.data.elementsSize, prop.offset == 0 ? C_NULL : GLuint[prop.offset]) #gl.PtrOffset(0)\r\n	#glDisableVertexAttribArray(prop.location)\r\nendfunction findShaderProperties(program::AbstractGraphicsShaderProgram)\r\n	if program == nothing return end\r\n	for (id,list) in listListenerOnShaderPropertyUpdate\r\n		for (name,f) in list if haskey(program.properties,name) program.properties[name].update=f end	end\r\n	end\r\nendfunction getShaderProperties(program::AbstractGraphicsShaderProgram, buffer::AbstractGraphicsData)\r\n	if isLinked(program) && buffer != nothing && isa(buffer, GLStorage) && buffer.linked\r\n		for (_,p) in program.properties\r\n			c = p.categoryid\r\n			data = p.update()\r\n			if data != nothing\r\n				p.data = data\r\n				if isAttribute(c)\r\n					if p.location == -1 p.location = glAttribLocation(program.id, p.name) end\r\n					if c == GL_PROGRAM_INPUT setVertexAttribArray(program.id, p)\r\n					else setFragLocation(program.id, p.name)\r\n					end\r\n				elseif isUniform(c)\r\n					if p.location == -1 p.location = glUniformLocation(program.id, p.name) end\r\n					if c == GL_UNIFORM  glUniform(p.location, p.data) end\r\n				end\r\n			end\r\n		end\r\n	end\r\nendfunction findShaderProperty(program::AbstractGraphicsShaderProgram, line::String)\r\n	if program == nothing return end\r\n	m = match(r\"\\s*(\\w+)\\s+(\\w+)\\s+(\\w+)\\s*\\;\", line)\r\n	if m != nothing\r\n		m=m.captures\r\n		c=m[1]\r\n		t=m[2]\r\n\r\n		# [mat/vec] without type => float\r\n		mt = match(r\"^((mat[2-4](\\x[2-4])?)|(vec))[2-4]$\", t)\r\n		if mt != nothing t=string(t,\"f\") end\r\n\r\n		#GL_UNIFORM_BLOCK\r\n		ci = (c == \"in\" ? GL_PROGRAM_INPUT : (c == \"out\" ? GL_PROGRAM_OUTPUT : (c == \"uniform\" ? GL_UNIFORM : GL_BUFFER_VARIABLE)))\r\n\r\n		p = ShaderProperty()\r\n		p.name = m[3]\r\n		p.category=c\r\n		p.typname=t\r\n		p.categoryid = ci\r\n		for (key, value) in LIST_TYPE_STRING if p.typname == value p.typid=key;	break end end\r\n		for (key, value) in LIST_TYPE if p.typid == value p.typ=key;	break end end\r\n		p.elements = haskey(LIST_TYPE_ELEMENTS, p.typid) ?  LIST_TYPE_ELEMENTS[p.typid] : 1\r\n\r\n		# set offset\r\n		if isAttribute(p.categoryid)\r\n			offset=0\r\n			for v in shaderAttributes\r\n				offset+=v.offset+v.elements*sizeof(v.typ)\r\n			end\r\n			p.offset = offset\r\n			push!(shaderAttributes, p)\r\n		end\r\n\r\n		#p.size=size\r\n		CoreExtended.update(program.properties,p.name,\r\n		function(x)\r\n			if !x[1] return p end\r\n			p=x[2]\r\n			if isAttribute(ci) && isAttribute(p.categoryid)\r\n				p.categoryid = -1 # custom type\r\n				p.category=\"shared\"\r\n			end\r\n			p\r\n		end)\r\n	end\r\nendfunction findActiveRessources(program::AbstractGraphicsShaderProgram)\r\n	if program == nothing return end\r\n	if printError(\"Before findActiveRessources\") return end\r\n\r\n	programID = program.id\r\n\r\n	attributeMap = []\r\n	uniformMap = []\r\n	uniformBlockMap = []\r\n	matrixMap = []\r\n\r\n	#if !program.linked\r\n		#program.shaders_count = 0\r\n		#program.shaderParts = false\r\n		#return\r\n	#end\r\n\r\n	const properties = GLenum[ GL_PROGRAM_INPUT, GL_PROGRAM_OUTPUT, GL_UNIFORM, GL_UNIFORM_BLOCK, GL_SHADER_STORAGE_BLOCK ]\r\n	const NAMES = String[ \"IN Attributes\", \"OUT Attributes\", \"Uniforms\", \"Uniform Blocks\", \"Storage Blocks\" ]\r\n	const TOTAL = length(properties)\r\n	COUNT = zeros(GLint, TOTAL)\r\n\r\n	#println(\"Version: \",glString(GL_VERSION))\r\n	#println(\"MJ: \",glGet(GLint,GL_MAJOR_VERSION))\r\n	#println(\"MN: \",glGet(GLint, GL_MINOR_VERSION))\r\n	println(\"\\n[ SHADER RESOURCES ]\\n\")\r\n\r\n	#@show activeUnif = glGetProgramiv(programID, GL_ACTIVE_UNIFORMS)\r\n\r\n	for i = 1:TOTAL\r\n		# glGetProgramInterfaceiv usable since gl version 4.3\r\n		# breaks when using intel gpu ..?\r\n		count = getValByRef((ref) -> glGetProgramInterfaceiv(programID, properties[i], GL_ACTIVE_RESOURCES, ref), COUNT[i])\r\n\r\n		if printError(\"glGetProgramInterfaceiv\") return end\r\n\r\n		if count > 0 COUNT[i] = count end\r\n	end\r\n\r\n	#@printf(\"%s : %d\\n\", NAMES[i], count)\r\n	#println()\r\n\r\n	for i = 1:TOTAL\r\n		count =  GLuint(COUNT[i])\r\n		if count <= 0 continue end\r\n		println(\"  [ $(NAMES[i]) ] ($(count))\")\r\n		category=properties[i]\r\n		addProperties(program, category, count)\r\n		#if category != GL_UNIFORM_BLOCK addProperties(program, category, count)\r\n		#else addShaderPropertyBlocks(category, count)\r\n		#end\r\n		println()\r\n	end\r\n\r\n	println(\"[/ SHADER RESOURCES ]\\n\")\r\nend\r\n\r\n# TODO: CHECK\r\n#=\r\nfunction addShaderPropertyBlocks(program::AbstractGraphicsShaderProgram, category::GLenum, count::GLuint)\r\n	if program == nothing return end\r\n	if printError(\"Before addShaderPropertyBlocks\") return end\r\n	if count <= 0 return end\r\n\r\n	programID = program.id\r\n\r\n	if category != GL_UNIFORM_BLOCK && category != GL_SHADER_STORAGE_BLOCK return end #_DEBUG_BREAK_IF\r\n\r\n	const b_NAME = 1\r\n	const b_VARS = 2\r\n	const b_BINDS = 3\r\n	const b_SIZE = 4\r\n\r\n	const properties	= GLenum[ GL_NAME_LENGTH, GL_NUM_ACTIVE_VARIABLES, GL_BUFFER_BINDING, GL_BUFFER_DATA_SIZE ]\r\n	const activeProp = GLenum[ GL_ACTIVE_VARIABLES ]\r\n\r\n	const TOTAL = length(properties)\r\n\r\n	block = nothing\r\n	pcount = 0\r\n\r\n	values = zeros(GLint, TOTAL)\r\n\r\n	nameData = GLchar[0]\r\n\r\n	for tmpId = 1:count\r\n\r\n		values = getValByRef((ref) -> glGetProgramResourceiv(programID, category, tmpId, TOTAL, pointer(properties), TOTAL * sizeof(GLenum), C_NULL, ref), values)\r\n\r\n		if printError(\"glGetProgramResourceiv\") return end\r\n\r\n		if err len = 255\r\n		else\r\n			len = length(values) >= p_NAME ? values[p_NAME] : 0\r\n			if len < 0 len = 0 end\r\n		end\r\n\r\n		nameData = zeros(GLchar,len)\r\n		nameData = getValByRef((ref) -> glGetProgramResourceName(programID, category, tmpId, length(nameData), C_NULL, ref), nameData)\r\n\r\n		if printError(\"glGetProgramResourceName\") name = \"Unknown\"\r\n		else name = convert(String, nameData[1:len-1])\r\n		end\r\n\r\n		size = values[b_SIZE]\r\n		index = glGetProgramResourceIndex(programID, category, pointer(name)) # TODO\r\n\r\n		if printError(\"glGetProgramResourceIndex\") index = -1	end\r\n\r\n		binding = values[b_BINDS]\r\n\r\n		#GL_INVALID_ENUM; GL_INVALID_INDEX\r\n		block = ShaderProperty()\r\n		block.categoryid=category\r\n		block.name = name\r\n		block.index=index\r\n		block.binding=binding\r\n		block.size=size\r\n\r\n		#link(block, program)\r\n\r\n		@printf(\"  - %d. [%d] %s <%d>\\n\", index, binding, name, size)\r\n\r\n		pcount = values[b_VARS]\r\n		#if !pcount continue end\r\n		#addProperties(program, category == GL_UNIFORM_BLOCK ? GL_UNIFORM : GL_BUFFER_VARIABLE, pcount, block)\r\n		#add(block)\r\n	end\r\nend\r\n=#function addProperties(program::AbstractGraphicsShaderProgram, category::GLenum, count::GLuint, block=nothing) #ShaderProperty\r\n	if program == nothing return end\r\n	if printError(\"Before addProperties\") return end\r\n	if count <= 0 return end\r\n\r\n	programID = program.id\r\n\r\n	const p_INDEX = 1\r\n	const p_NAME = 2\r\n	const p_TYPE = 3\r\n	const p_ARRAYSIZE = 4\r\n	const p_LOCATION = 5\r\n	const p_OFFSET = 6\r\n	const p_ARRAY = 7\r\n	const p_MATRIX = 8\r\n	const p_TOPARRAYSIZE = 9\r\n	const p_TOPARRAYSTRIDE = 10\r\n\r\n	const GL_LOCATION_COMPONENT = convert(GLenum, 0x934A)\r\n\r\n	const aplist = GLenum[ GL_LOCATION_COMPONENT,	GL_NAME_LENGTH, GL_TYPE, GL_ARRAY_SIZE, GL_LOCATION ]\r\n	const uplist = GLenum[ GL_BLOCK_INDEX, 				GL_NAME_LENGTH, GL_TYPE, GL_ARRAY_SIZE, GL_LOCATION, GL_OFFSET, GL_ARRAY_STRIDE, GL_MATRIX_STRIDE ]\r\n	const bplist = GLenum[ GL_BLOCK_INDEX,				GL_NAME_LENGTH, GL_TYPE, GL_ARRAY_SIZE,	GL_LOCATION, GL_OFFSET, GL_ARRAY_STRIDE, GL_MATRIX_STRIDE, GL_TOP_LEVEL_ARRAY_SIZE, GL_TOP_LEVEL_ARRAY_STRIDE ]\r\n	const splist = GLenum[ GL_BLOCK_INDEX,				GL_NAME_LENGTH, GL_TYPE, GL_BUFFER_DATA_SIZE, GL_BUFFER_BINDING, GL_NUM_ACTIVE_VARIABLES ]\r\n\r\n	#GL_IS_ROW_MAJOR, GL_ATOMIC_COUNTER_BUFFER_INDEX, GL_REFERENCED_BY_VERTEX_SHADER, GL_REFERENCED_BY_TESS_CONTROL_SHADER,\r\n	#GL_REFERENCED_BY_TESS_EVALUATION_SHADER, GL_REFERENCED_BY_GEOMETRY_SHADER, GL_REFERENCED_BY_FRAGMENT_SHADER, GL_REFERENCED_BY_COMPUTE_SHADER\r\n\r\n	const CATEGORIES = Dict{GLenum,Tuple{String,Array{GLenum,1}}}(\r\n		GL_PROGRAM_OUTPUT		=> (\"Output\", aplist),\r\n		GL_PROGRAM_INPUT		=> (\"Input\", aplist),\r\n		GL_UNIFORM					=> (\"Uniform\", uplist),\r\n		GL_BUFFER_VARIABLE	=> (\"Buffer\", bplist),\r\n		GL_UNIFORM_BLOCK		=> (\"UniformBlock\", splist),\r\n	)\r\n\r\n	if !haskey(CATEGORIES, category)\r\n		println(\"ERROR: UNKNOWN TYPE\") #_DEBUG_BREAK_IF\r\n		return\r\n	end\r\n\r\n	t=CATEGORIES[category]\r\n	category_name = t[1]\r\n	properties = t[2]\r\n	TOTAL = length(properties)\r\n	BUFSIZE = TOTAL * sizeof(GLenum)\r\n\r\n	values = zeros(GLint,TOTAL)\r\n	nameData = GLchar[0]\r\n\r\n	categoryID = category\r\n	name = \"\"\r\n	len = 0\r\n\r\n	PTR = pointer(properties)\r\n\r\n	for i = 1:count\r\n		tmpId=i-1\r\n\r\n		values = getValByRef((ref) -> glGetProgramResourceiv(programID, category, tmpId, TOTAL, PTR, BUFSIZE, C_NULL, ref), values)\r\n\r\n		err = printError(\"glGetProgramResourceiv\")\r\n\r\n		if err len = 255\r\n		else\r\n			len = length(values) >= p_NAME ? values[p_NAME] : 0\r\n			if len < 0 len = 0 end\r\n		end\r\n\r\n		nameData = zeros(GLchar,len)\r\n		nameData = getValByRef((ref) -> glGetProgramResourceName(programID, category, tmpId, length(nameData), C_NULL, ref), nameData)\r\n\r\n		if printError(\"glGetProgramResourceName\") name = \"Unknown\"\r\n		else name = convert(String, nameData[1:len-1])\r\n		end\r\n\r\n		# debugging\r\n		if err\r\n			warn(\"An error did occur for variable $name [$category_name] ($tmpId)!\")\r\n\r\n			pdummy = GLenum[1]; dummy = GLint[1]\r\n			for tId = 1:TOTAL\r\n				pdummy[1] = properties[tId]\r\n				#VideoDriver<GLEW>::Shader<Ressource>::get(programID, categoryID, tmpId, GLint(1), pdummy, dummy)\r\n				dummy = getValByRef((ref) -> glGetProgramResourceiv(programID, category, tmpId, 1, pointer(pdummy), 1 * sizeof(GLenum), C_NULL, ref), dummy)\r\n				if hasError() @printf(\"Parameter %d (%d) failed.\\n\", tId, pdummy[1]) end\r\n			end\r\n			continue\r\n		end\r\n\r\n		# ------------------------------------\r\n		hasBlock = block != nothing\r\n\r\n		if category == GL_UNIFORM\r\n			if hasBlock || values[p_INDEX] == -1 pindex = tmpId\r\n			else continue\r\n			end\r\n		elseif category == GL_BUFFER_VARIABLE pindex = tmpId\r\n		else pindex = values[p_INDEX]\r\n		end\r\n\r\n		index = glGetProgramResourceIndex(programID, category, pointer(name)) # TODO\r\n		if printError(\"glGetProgramResourceIndex\") index = -1	end\r\n\r\n		typ = values[p_TYPE]\r\n		type_name = LIST_TYPE_STRING[typ]\r\n		location = category != GL_BUFFER_VARIABLE ? values[p_LOCATION] : values[p_INDEX]\r\n		binding = length(values)>= GL_LOCATION ? values[GL_LOCATION] : -1\r\n		arrSize = values[p_ARRAYSIZE]\r\n		size = arrSize\r\n\r\n		prop = ShaderProperty()\r\n		prop.index = index\r\n		prop.name = name\r\n		prop.categoryid=category\r\n		prop.typid=typ\r\n		prop.location=location\r\n		prop.binding = binding\r\n		prop.size=size\r\n\r\n		#if typ == GL_FLOAT_MAT4 prop.code = MATRICES::getCode(name)\r\n\r\n		#GL_TRANSPOSE_MODELVIEW_MATRIX\r\n		#GL_TRANSPOSE_PROJECTION_MATRIX\r\n		#GL_TRANSPOSE_TEXTURE_MATRIX\r\n		#GL_TRANSPOSE_COLOR_MATRIX\r\n\r\n		if category == GL_UNIFORM || category == GL_BUFFER_VARIABLE\r\n\r\n			auxSize = 0\r\n			arrayStride = values[p_ARRAY]\r\n			matrixStride = values[p_MATRIX]\r\n\r\n			prop.offset=values[p_OFFSET]\r\n			prop.arrayStride=arrayStride\r\n			prop.matrixStride=values[p_MATRIX]\r\n\r\n			if category == GL_BUFFER_VARIABLE\r\n				prop.topSize=values[p_TOPARRAYSIZE]\r\n				prop.topStride=values[p_TOPARRAYSTRIDE]\r\n			end\r\n\r\n			if arrayStride > 0\r\n				size = arrayStride * arrSize\r\n\r\n			elseif matrixStride > 0\r\n\r\n				if (typ == GL_FLOAT_MAT2) || (typ == GL_FLOAT_MAT2x3) || (typ == GL_FLOAT_MAT2x4) || (typ == GL_DOUBLE_MAT2) || (typ == GL_DOUBLE_MAT2x3) || (typ == GL_DOUBLE_MAT2x4)\r\n					auxSize = 2\r\n				elseif (typ == GL_FLOAT_MAT3) || (typ == GL_FLOAT_MAT3x2) || (typ == GL_FLOAT_MAT3x4) || (typ == GL_DOUBLE_MAT3) || (typ == GL_DOUBLE_MAT3x2) || (typ == GL_DOUBLE_MAT3x4)\r\n					auxSize = 3\r\n				elseif (typ == GL_FLOAT_MAT4) || (typ == GL_FLOAT_MAT4x2) || (typ == GL_FLOAT_MAT4x3) || (typ == GL_DOUBLE_MAT4) || (typ == GL_DOUBLE_MAT4x2) || (typ == GL_DOUBLE_MAT4x3)\r\n					auxSize = 4\r\n				end\r\n\r\n				auxSize *= matrixStride\r\n				size = auxSize\r\n			end\r\n\r\n			#if (location != -1 && type == GL_SAMPLER_2D)\r\n			#glUniform1i(location, 0); // Set our sampler to user Texture Unit 0\r\n			#driver->printError(\"glUniform1i DiffuseMap\");\r\n			#end\r\n		end\r\n\r\n		prop.size=size\r\n\r\n		if size == 0\r\n			@printf(\"  %s%d. [%d] %s %s <%d>\\n\", hasBlock ? \"\\t- \" : \"\",	pindex, location, name, type_name, size)\r\n		else\r\n			@printf(\"  %s%d. [%d] %s %s (%d) <%d>\\n\", hasBlock ? \"\\t- \" : \"\", pindex, location, name, type_name, prop.offset, size);\r\n		end\r\n\r\n		pcount = length(values)>= p_OFFSET ? values[p_OFFSET] : 0 # vars\r\n\r\n		if pcount > 0 && (category == GL_UNIFORM_BLOCK || category == GL_ATOMIC_COUNTER_BUFFER || category == GL_SHADER_STORAGE_BLOCK || category == GL_TRANSFORM_FEEDBACK_BUFFER)\r\n			addProperties(program, category == GL_UNIFORM_BLOCK ? GL_UNIFORM : GL_BUFFER_VARIABLE, pcount, prop)\r\n		end\r\n\r\n		if hasBlock && !haskey(block.properties, prop.name) block.properties[prop.name]=prop\r\n		elseif !haskey(program.properties, prop.name) program.properties[prop.name]=prop\r\n		end\r\n\r\n	end\r\nend"
},

{
    "location": "files/JLGEngine/LibGL/ShaderManager.html#",
    "page": "GL/ShaderManager.jl",
    "title": "GL/ShaderManager.jl",
    "category": "page",
    "text": ""
},

{
    "location": "files/JLGEngine/LibGL/ShaderManager.html#GL-ShaderManager.jl-1",
    "page": "GL/ShaderManager.jl",
    "title": "GL/ShaderManager.jl",
    "category": "section",
    "text": "export ShaderProperty export ShaderProgram export Shaderusing CoreExtended using ModernGL using FileManagerusing JLGEngine.GraphicsManager using ..GLLists using ..GLDebugControl using ..GLExtendedFunctionstype ShaderProperty <: IGraphicsShaderProperty\r\n	enabled::Bool\r\n	linked::Bool\r\n\r\n	name::String\r\n	typname::String\r\n	category::String\r\n\r\n	typ::DataType\r\n	elements::Int32\r\n\r\n	categoryid::Int32\r\n	typid::Int32\r\n	location::Int32 #GLuint\r\n	offset::Int32\r\n\r\n	arrayStride::Int32\r\n	matrixStride::Int32\r\n	topSize::Int32\r\n	topStride::Int32\r\n\r\n	size::UInt32\r\n	code::UInt32\r\n\r\n	index::Int32\r\n	binding::Int32\r\n	id::UInt32\r\n\r\n	data::Any\r\n	update::Function\r\n\r\n	properties::Dict{String, ShaderProperty}\r\n\r\n	ShaderProperty() = new(true,false,\"\",\"\",\"\",Void,0,-1,-1,-1,0,-1,-1,-1,-1,0,0,-1,-1,0,nothing,()->nothing,Dict{String,ShaderProperty}())\r\nendtype Shader <: IGraphicsShader\r\n	enabled ::Bool\r\n	created ::Bool\r\n\r\n	typ			::Symbol\r\n	file 		::FileSourcePart\r\n	cache		::String\r\n\r\n	id      ::GLuint # GL\r\n	typid   ::GLuint # GL\r\n\r\n	Shader(typ::Symbol, source::FileSource) = Shader(typ, FileSourcePart(source))\r\n  Shader(typ::Symbol, file::FileSourcePart)	= new(true,false,typ,file,\"\",0,0)\r\nendtype ShaderProgram <: IGraphicsShaderProgram\r\n	id			::GLuint\r\n\r\n	enabled	::Bool\r\n	created ::Bool\r\n	linked	::Bool\r\n	bound		::Bool\r\n\r\n	#source	::FileSource\r\n	shaders ::Dict{Symbol,Shader}\r\n	properties ::Dict{String, ShaderProperty}\r\n\r\n	#ShaderProgram() = new(0,true,false,false,false,FileSource(),Dict(),Dict())\r\n  ShaderProgram() = new(0,true,false,false,false,Dict(),Dict())\r\nend\r\n\r\n#listShaderProgramListener = createSortedDict(Dict{String,Function})\r\n#listenOnShaderProgramUpdate(id::Symbol, t::Tuple) = listenOnShaderProgramUpdate(id, Dict{String,Function}(t))\r\n#listenOnShaderProgramUpdate(id::Symbol, d::Dict{String,Function}) = listShaderProgramListener[id]=d\r\n#notlistenOnShaderPropertyUpdate(id::Symbol) = (listShaderProgramListener[id]=nothing)link(this::Shader, p::AbstractGraphicsShaderProgram) = (this.program = p; true)\r\nfunction compile(this::Shader)\r\n	println(\"compile: \", this.typ);\r\n	f = this.file\r\n	glGetShaderSource(this.id)\r\n	cache = f.cache #source.cache #FileManager.getCache(f.source)\r\n\r\n	if cache == \"\"\r\n		warn(\"OpenGL Error! Compile shader \'$(f.source.path)\': Failed loading content!\")\r\n		return false\r\n	end\r\n\r\n	#cache = cache[f.range]\r\n	#println(f.source.path, \" \", f.range, \":(\",length(cache), \")\\n--------------------------\\n\", cache,\"\\n--------------------------\\n\")\r\n\r\n	glCompile(this.id,cache)\r\n	r = validate(:SHADER, this.id, GL_COMPILE_STATUS)\r\n	if !r\r\n		warn(\"OpenGL Error! Compile shader \'$(f.source.path)\': $(getInfoLog(:SHADER, this.id))\")\r\n		glCompile(this.id,this.cache)\r\n		r = validate(:SHADER, this.id, GL_COMPILE_STATUS)\r\n		if !r\r\n			warn(\"OpenGL Error! Compile shader cache \'$(f.source.path)\': $(getInfoLog(:SHADER, this.id))\")\r\n		end\r\n	else\r\n		this.cache = cache\r\n	end\r\n	r\r\nendfunction reload(this::AbstractGraphicsShaderProgram, source::FileSource)\r\n	if this == nothing return end\r\n\r\n	clear(this)\r\n\r\n	if printError(\"Before readShadersFromSource\") end\r\n\r\n	println(\"[ readShadersFromSource ]\")\r\n	readShaders(this,source)\r\n	println(\"---------------------------------------\")\r\n	println(\"[ setUp ]\")\r\n	setUp(this)\r\n	println(\"---------------------------------------\")\r\n\r\n	#programID = this.id\r\n	#getProgramInfo(this)\r\n	#getAttributesInfo(this)\r\n	#getUniformsInfo(this)\r\n\r\n	if isValid(this)\r\n		#glUseProgram(this.id)\r\n		println(\"[ findActiveRessources ]\")\r\n		findActiveRessources(this)\r\n		println(\"---------------------------------------\")\r\n		println(\"[ findShaderProperties ]\")\r\n		findShaderProperties(this)\r\n		println(\"---------------------------------------\")\r\n	end\r\n	link(this)\r\n	#useLinkedShaderProgram() # switch back to linked shader\r\nendcreateShaderProgram() = ShaderProgram()createShader(program::ShaderProgram, typ::Symbol, file::FileSourcePart) = (this=Shader(typ, file); program.shaders[typ]=this; this)\r\n\r\n#getSource(this::AbstractGraphicsShaderProgram) = this.source\r\n#setPath(this::AbstractGraphicsShaderProgram, path::String) = (this.source.path = path)clear(this::AbstractGraphicsShaderProgram) = this.shaders = Dict()hasShader(this::AbstractGraphicsShaderProgram, id::Symbol) = haskey(this.shaders,id)\r\n\r\nlinked = nothingunlink() = link(nothing)\r\n#isValid(this::ShaderProgram) = this.created && this.boundisValid(this::AbstractGraphicsShaderProgram) = this != nothing && isa(this,ShaderProgram) && this.created && this.boundisLinked(this::AbstractGraphicsShaderProgram) =	isValid(this) && this == linkedfunction create(this::Shader)\r\n	if this.created return true end\r\n	this.created = true\r\n	println(\"create: \", this.typ);\r\n	this.typid = LIST_SHADER[this.typ][:TYPE]\r\n	this.id = glCreateShader(this.typid)\r\n	hasNoError()\r\nendfunction delete(this::Shader)\r\n	if !this.created return true end\r\n	println(\"delete: \", this.typ);\r\n	glDeleteShader(this.id)\r\n	this.created = false\r\n	hasNoError()\r\nendattach(this::Shader, programID::GLuint) = (println(\"attach: \", this.typ); glAttachShader(programID, this.id); hasNoError())detach(this::Shader, programID::GLuint) = (println(\"detach: \", this.typ); glDetachShader(programID, this.id); hasNoError())function link(this::AbstractGraphicsShaderProgram)\r\n	global linked\r\n	if linked == this return end\r\n	linked = this\r\n	result = isValid(this)\r\n	id = 0\r\n	if result	id = this.id end\r\n	glUseProgram(id)\r\n	if result	result=hasNoError() end\r\n	result\r\nendfunction create(this::ShaderProgram)\r\n	if this.created return true end\r\n	this.created = true\r\n	this.id = glCreateProgram()\r\n	hasNoError()\r\nendfunction delete(this::ShaderProgram)\r\n	if !this.created return true end\r\n	this.created = false\r\n	unlink()\r\n	glDeleteProgram(this.id)\r\n	hasNoError()\r\nendfunction bind(this::ShaderProgram)\r\n	glLinkProgram(this.id)\r\n  #result = validate(:PROGRAM, this.id, GL_LINK_STATUS)\r\n	#if !result	warn(\"OpenGL Error! Link ShaderProgram $(this.id): $(getInfoLog(:PROGRAM, this.id))\")	end\r\n	#result\r\n	#this.bound=result\r\n	#result\r\n	this.bound=hasNoError()\r\nendfunction setUp(this::ShaderProgram)\r\n	result = (\r\n	(reset(this) ? true : true) &&\r\n	(create(this) && detach(this) && compile(this) && attach(this) && bind(this) && clearList(this))\r\n	) ? true : (reset(this) ? false : false)\r\n	#if !result warn(\"OpenGL Error! SetUp ShaderProgram $(this.id): $(getInfoLog(:PROGRAM, this.id))\") end\r\n	result\r\nendfunction invokeList(list::Dict, f::Function, args...)\r\n	if length(list) <= 0 return false end;\r\n	for (k,e) in list\r\n		if !f(e,args...) return false end\r\n	end\r\n	true\r\nendreset() = unlink()\r\n#(create(this) && compileAll(this) && link(this, true) && cleanAll(this))reset(this::ShaderProgram) = (unlink(); clearList(this) && delete(this))compile(this::ShaderProgram) = invokeList(this.shaders, (s)->(create(s) && compile(s)))detach(this::ShaderProgram) = (shader_ids = glGetAttachedShaders(this.id); foreach(glDetachShader, shader_ids); true)attach(this::ShaderProgram) = invokeList(this.shaders, attach, this.id)clearList(this::ShaderProgram) = invokeList(this.shaders, delete)clear(this::ShaderProgram) = (this.properties = Dict{String, ShaderProperty}())function render(this::ShaderProgram, buffer, data)\r\n	if !isLinked(this) return end\r\n	if !buffer.linked return end\r\n\r\n	mode = data.mode\r\n	if hasShader(this,:TESS_CONTROL) ||  hasShader(this,:TESS_EVALUATION)\r\n		mode=GL_PATCHES\r\n	end\r\n\r\n	if buffer.typ == GL_ELEMENT_ARRAY_BUFFER\r\n		glDrawElements(mode, data.elementsCount, data.typ, C_NULL)\r\n	else\r\n		glDrawArrays(mode, 0, data.elementsCount) #first::GLint\r\n	end\r\nendinclude(\"GLSLParser.jl\")"
},

{
    "location": "files/JLGEngine/LibGL/StorageManager.html#",
    "page": "GL/StorageManager.jl",
    "title": "GL/StorageManager.jl",
    "category": "page",
    "text": ""
},

{
    "location": "files/JLGEngine/LibGL/StorageManager.html#GL-StorageManager.jl-1",
    "page": "GL/StorageManager.jl",
    "title": "GL/StorageManager.jl",
    "category": "section",
    "text": "export GLStorageData export GLStorage export GLStorageBlockusing ModernGL using MatrixMathusing JLGEngine.GraphicsManager using ..GLLists using ..GLDebugControl using ..GLExtendedFunctionstype GLStorageData <: IGraphicsData\r\n	id::GLuint  # GL\r\n	dtyp::DataType\r\n	typ::GLenum\r\n	flags::GLuint\r\n	mode::GLenum\r\n\r\n	offset::GLuint\r\n	count::GLuint\r\n	size::GLsizei\r\n	values::AbstractArray\r\n	valuesPtr::Ptr{Void}\r\n\r\n	elements::GLint\r\n	elementsCount::GLsizei\r\n	elementsSize::GLsizei\r\n\r\n	uploaded::Bool\r\n\r\n	GLStorageData() = new(0,Float32,GL_FLOAT,0,GL_TRIANGLES,0,0,0,[],C_NULL,0,0,0,false)\r\nendtype GLStorage <: IGraphicsData\r\n	linked::Bool\r\n	id::GLuint  # bind point\r\n	size::GLsizei\r\n	count::GLuint\r\n	typ::GLenum\r\n	mode::GLuint\r\n	GLStorage(typ=GL_ARRAY_BUFFER) = new(false,0,0,0,typ,GL_STATIC_DRAW)\r\nendtype GLStorageBlock <: IGraphicsData\r\n	created::Bool\r\n	isarray::Bool\r\n	anchor::Array{GLuint,1}\r\n	count::GLuint\r\n	GLStorageBlock(isarray::Bool) = new(false, isarray, GLuint[0], 0)\r\nend\r\n\r\nlinkedArray = nothing\r\nlinkedBuffers = Dict{GLenum,AbstractGraphicsData}()function unbindStorages()\r\n	# unbind\r\n	for (s,k) in LIST_BUFFER bind(false, k, GLuint(0), nothing) end\r\n  bind(true, GLenum(0), GLuint(0), nothing)\r\nendfunction create(typ::Symbol, id::Symbol)\r\n	r = nothing\r\n	if typ == :DATA\r\n		r=GLStorageData()\r\n	elseif typ == :STORAGE\r\n		r=GLStorage(haskey(LIST_BUFFER, id) ? LIST_BUFFER[id] : 0)\r\n	elseif typ == :BLOCK\r\n		r= GLStorageBlock(id == :ARRAY_BLOCK)\r\n	end\r\n	r\r\nendgetValues(this::GLStorageData) = this.valuesfunction setValues(this::GLStorageData, values::AbstractArray, elems::Integer, mode = :TRIANGLES)\r\n	this.uploaded = false\r\n\r\n	# convert to one dim valid array\r\n	v=MatrixMath.convertMatrixToArray(values)\r\n	values=v[1]\r\n	elems=elems == 0 ? v[2] : elems\r\n\r\n	this.values = values\r\n	this.count = length(this.values)\r\n	this.size = sizeof(this.values)\r\n	this.dtyp = typeof(this.values[1])\r\n	this.valuesPtr = pointer(this.values)\r\n	this.typ = LIST_TYPE[this.dtyp]\r\n	this.mode = LIST_DRAW_MODE[mode]\r\n\r\n	n=this.count/elems\r\n	 #check if number becomes fractional\r\n	if modf(n)[1]>0\r\n		warn(\"element number does not match up with data count! instruction aborted.\")\r\n		return\r\n	end\r\n\r\n	this.elements=elems\r\n	this.elementsSize=elems*sizeof(this.dtyp)\r\n	this.elementsCount=n\r\n\r\n	println(\"setValues:done.\")\r\nendfunction prepare(block::GLStorageBlock, storage::GLStorage, this::GLStorageData)\r\n	storage.count += 1\r\n	this.id=storage.count\r\n	this.offset = storage.size\r\n	storage.size += this.size\r\nendfunction prepare(block::GLStorageBlock, this::GLStorage)\r\n	block.count += 1\r\n	this.id=block.count\r\n	this.count=0\r\nendfunction prepare(this::GLStorageBlock)\r\n	this.count=0\r\nendfunction init(this::GLStorageBlock)\r\n	if this.created return end\r\n	this.anchor=zeros(GLuint,this.count)\r\n	if this.isarray	glGenVertexArrays(this.count, this.anchor)\r\n	else glGenBuffers(this.count, this.anchor)\r\n	end\r\n	this.created=true\r\nendfunction clean(this::GLStorageBlock)\r\n	if !this.created return end\r\n	this.anchor=zeros(GLuint,this.count)\r\n	if this.isarray	glDeleteVertexArrays(this.count, this.anchor)\r\n	else glDeleteBuffers(this.count, this.anchor)\r\n	end\r\n	this.created=false\r\nendfunction bind(isarray::Bool, k::GLenum, v::GLuint, s::AbstractGraphicsData)\r\n	global linkedBuffers\r\n	global linkedArray\r\n	if isarray\r\n		glBindVertexArray(v)\r\n		if linkedArray != nothing linkedArray.linked = false end\r\n		if s != nothing s.linked = true end\r\n		linkedArray = s\r\n	else\r\n		glBindBuffer(k,v)\r\n		if haskey(linkedBuffers,k)\r\n			prev = linkedBuffers[k]\r\n			if prev != nothing prev.linked = false end\r\n			if s != nothing s.linked = true end\r\n		end\r\n		linkedBuffers[k] = s\r\n	end\r\nendbind(block::GLStorageBlock, this::GLStorage, on=true) = bind(block.isarray, this.typ, GLuint(on ? block.anchor[this.id] : 0), on ? this : nothing)upload(xs::Array{Any,1}) = for x in xs upload(x[1], x[2], x[3]) endfunction upload(block::GLStorageBlock, this::GLStorage, data::GLStorageData)\r\n	if block.isarray return end\r\n	bind(block,this)\r\n	uploadData(block, this, data) # offsets etc.\r\n	bind(block,this,false)\r\nendfunction uploadData(block::GLStorageBlock, this::GLStorage, data::GLStorageData)\r\n	if block.isarray || this.typ == 0 return end # || data.uploaded\r\n\r\n	if data.id == 1\r\n			size=GLsizeiptr(data.size)\r\n			values=data.valuesPtr\r\n\r\n			if this.size > data.size\r\n				values = C_NULL\r\n				size = this.size\r\n			end\r\n\r\n			#this.typ to name\r\n			\r\n			println(\"Data Upload: $(this.typ), $(data.id) , $(size) bytes\")\r\n			glBufferData(this.typ, size, values, this.mode)\r\n	end\r\n\r\n	if this.size > data.size\r\n		#location = data.id-1\r\n		#normalized = GL_FALSE #GLboolean(data.flags & GL_VERTEX_ATTRIB_ARRAY_NORMALIZED != GL_VERTEX_ATTRIB_ARRAY_NORMALIZED)\r\n		#stride = 0 #data.elementsSize #Vertex.SIZE * 4\r\n		#offset = C_NULL #data.offset == 0 ? C_NULL : GLintptr[data.offset]\r\n\r\n		#glEnableVertexAttribArray(location)\r\n		#glVertexAttribPointer(location, data.elements, data.typ, normalized, stride, offset)\r\n\r\n		println(\"Data Sub Upload: $(this.typ), $(data.size) bytes, offset:$(data.offset)\")\r\n		glBufferSubData(this.typ, GLintptr(data.offset), GLsizeiptr(data.size), data.valuesPtr)\r\n	end\r\n\r\n	data.uploaded = true\r\nendupdate(this::GLStorageData, mode::Symbol) = this.mode = LIST_DRAW_MODE[mode]"
},

{
    "location": "files/JLGEngine/LibGL/TextureManager.html#",
    "page": "GL/TextureManager.jl",
    "title": "GL/TextureManager.jl",
    "category": "page",
    "text": ""
},

{
    "location": "files/JLGEngine/LibGL/TextureManager.html#GL-TextureManager.jl-1",
    "page": "GL/TextureManager.jl",
    "title": "GL/TextureManager.jl",
    "category": "section",
    "text": "using ModernGL using Images using Colors using FileIO using MatrixMathusing JLGEngine.GraphicsManager using ..GLLists using ..GLDebugControl using ..GLExtendedFunctionstype GLTextureBlock\r\n	anchor::Array{GLuint,1}\r\n	\r\n	GLTextureBlock() = new(GLuint[1])\r\nendtype GLTexture\r\n	anchor::Array{GLuint,1}\r\n	id::GLuint\r\n	typ::GLenum\r\n	\r\n	GLTexture() = new(GLuint[1],0,GL_TEXTURE_2D)\r\nendfunction create()\r\n	this = GLTexture()\r\n	glGenTextures(1, this.anchor)\r\n	this.id = this.anchor[1]\r\n	this\r\nendbind(this::GLTexture) = glBindTexture(this.typ, this.id)function load(this::GLTexture, file::AbstractString)\r\n	img = Images.load(file)\r\n	sz = size(img)\r\n	width = sz[1] #1\r\n	height = sz[2] #1\r\n	a = channelview(img)\r\n	a = reinterpret.(vec(a))\r\n	#a = [0xFF, 0xFF, 0xFF, 0xFF]\r\n	internalformat = GL_RGBA8\r\n	format = GL_RGBA\r\n	typ = GL_UNSIGNED_BYTE\r\n	\r\n	glActiveTexture(GL_TEXTURE0)\r\n	glBindTexture(this.typ, this.id)\r\n	glTexParameteri(this.typ, GL_TEXTURE_MIN_FILTER, GL_NEAREST) #GL_LINEAR\r\n	glTexParameteri(this.typ, GL_TEXTURE_MAG_FILTER, GL_NEAREST) #GL_LINEAR\r\n	glTexParameteri(this.typ, GL_TEXTURE_WRAP_S, GL_REPEAT) #GL_CLAMP_TO_EDGE)\r\n	glTexParameteri(this.typ, GL_TEXTURE_WRAP_T, GL_REPEAT) #GL_CLAMP_TO_EDGE)\r\n	glTexImage2D(this.typ, 0, internalformat, width, height, 0, format, typ, pointer(a))\r\n	#glGenerateMipmap(this.typ)\r\nend"
},

]}
