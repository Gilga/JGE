# [App.jl](@id App.jl)

* [Uses libraries](#Uses-libraries-1)
* [Uses Core files](#Uses-Core-files-1)
* [Uses Engine files](#Uses-Engine-files-1)
* [Code](#Code-1)
* [Loop](#Loop-1)
* [Timer](#Timer-1)
* [Create Script](#Create-Script-1)
* [Reload Script](#Reload-Script-1)
* [Run Script](#Run-Script-1)

## Uses libraries
* Images
* ImageMagick
* Quaternions
* Mustache
* ModernGL
* Reactive
* FixedPointNumbers
* ColorTypes
* Compat
* FileIO

## Uses Core files
* [CoreExtended.jl] (@ref CoreExtended.jl)
* [TimeManager.jl] (@ref TimeManager.jl)
* [LoggerManager.jl] (@ref LoggerManager.jl) (importall)
* [RessourceManager.jl] (@ref RessourceManager.jl)
* [FileManager.jl] (@ref FileManager.jl)
* [Environment.jl] (@ref Environment.jl)
* [JLScriptManager.jl] (@ref JLScriptManager.jl)
* [WindowManager.jl] (@ref WindowManager.jl)
* [MatrixMath.jl] (@ref MatrixMath.jl)

## Uses Engine files
* [JLGEngine.jl](@ref JLGEngine.jl) (include)
* [GraphicsManager.jl](@ref GraphicsManager.jl)
* [LibGL.jl](@ref LibGL.jl)
* [RenderManager.jl](@ref RenderManager.jl)

## Code

```@docs
App.ScriptRefs
```

```@docs
App.ScriptState
```

```@docs
App.start()
```

## Loop
```
WindowManager.loop(WINDOW, function()
  Libc.systemsleep(programTick)
  runOnFileUpdate()
  JLScriptManager.loop(run)
end)
```

## Timer
```
function tickUpdate(script::JLScript)
  script.state.currentTime = currentTime(script.state.startTime)
  script.state.ticks+=1
  if OnTime(1.0,script.state.ticksTime)
    script.state.ticksTotal=script.state.ticks
    script.state.ticks=0
  end
end
```

## Create Script
```
function create(id::Symbol,path::String)
  script = JLScript(id, FileSource(path))
  script.state = ScriptState()
  script.objref = ScriptRefs()
  script.objref.WINDOW = WINDOW
  script.objref.GD = GRAPHICSDRIVER()

  WindowManager.setListener(WINDOW,script.id,(args...)->script(args...))

  list=Dict{Symbol,Function}(
     :scriptTime => () -> script.state.currentTime
    ,:OnTick => function(tick::Real)
      m=modf(tick)
      t=m[1]>0?1/m[1]:0
      g=m[2]>0?(TimeManager.now() % m[2]) :0
      println(m," | ", t," | ",g," | ",script.state.ticks/script.state.ticksTotal)
      g < 1 && (script.state.ticksTotal==0?true:(script.state.ticks/script.state.ticksTotal == t))
    end
    ,:reload => function()
      println("Reload Script...")
      programTick=0.1
      RenderManager.reset()
      GRAPHICSDRIVER().resetRegisters()
      reload(script)
    end
    ,:setProgramTick => (tick::Real) -> programTick = tick
    ,:setRenderUpdate => (turn::Bool) -> script.state.isRenderOn = turn
  )

  script.extern = merge(script.extern,list)

  registerFileUpdate(script.source, (source::FileSource) -> list[:reload]())
end

create(:input, "scripts/input.jl")
```

## Reload Script
```
function reload(script::JLScript)
  script.state.isRunning=false
  script.state.isRenderRunOnce=false
  script.state.isRenderOn=true
  
  JLScriptManager.run(script)

  if !script.state.isInitalized
    script(:OnInit)
    
    OnRender=JLScriptManager.exists(script,:OnRender) ? () -> script(:OnRender) : nothing
    RenderManager.setOnRender(() -> script(:OnPreRender),() -> script(:OnPostRender),OnRender)
    RenderManager.setOnDraw(() -> script(:OnPreDraw),() -> script(:OnPostDraw))
    
    script.state.isInitalized=true
  end
  
  script(:OnReload)
end
```

## Run Script
function run(script::JLScript)
  if !script.state.isRunning
    script(:OnStart)
    RenderManager.start()
    script.state.isRunning=true
  end

  tickUpdate(script)
  script(:OnUpdate)
  RenderManager.update()

  if script.state.isRenderOn
    RenderManager.render()
    if !script.state.isRenderRunOnce script.state.isRenderRunOnce=true end
  end
end
```