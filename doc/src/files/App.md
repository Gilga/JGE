# [App.jl](@id App.jl)

include("JLGEngine.jl")
importall LoggerManager

```
module App

using Images
using ImageMagick
using Quaternions
#using Mustache
using ModernGL
#using Reactive
using FixedPointNumbers
using ColorTypes
using Compat
using FileIO

using CoreExtended
using RessourceManager
using TimeManager
using FileManager
using Environment
using JLScriptManager
using WindowManager

using JLGEngine
using JLGEngine.GraphicsManager
using JLGEngine.LibGL
using JLGEngine.RenderManager
```

```
type ScriptRefs <: JLComponent
	WINDOW	::Any
	GD		::Any

	ScriptRefs() = new()
end
```

```
type ScriptState <: JLComponent
	isInitalized		::Bool
	isRunning			::Bool
	isTerminated		::Bool
	isRenderRunOnce		::Bool
	isRenderOn			::Bool
	ticks				::Integer
	ticksTotal			::Integer
	ticksTime			::Base.RefValue{Float64}
	startTime			::Real
	currentTime			::Real

	ScriptState() = new(false,false,false,false,true,0,0,Ref(0.0),0.0,0.0)
end
```

```
function start()
	JLGEngine.init()

	RessourceManager.AddPath(:LOGS,"logs")
	RessourceManager.AddPath(:SCRIPTS,"scripts")
	RessourceManager.AddPath(:SHADERS,"shaders")

	println("---------------------------------------------------------------------")
	println("Start Program @ ", now())
	versioninfo()

	WINDOW = WindowManager.create("Julia GLFW Window",(800,600))

	WindowManager.open(WINDOW, [(:OPENGL_DEBUG_CONTEXT,true),(:SAMPLES, 4),(:CONTEXT_VERSION_MAJOR,3),(:CONTEXT_VERSION_MINOR,3)])

	println(GRAPHICSDRIVER().GetVersion(:VERSION))
	println("---------------------------------------------------------------------")

	GRAPHICSDRIVER().init()

	RenderManager.init()

	programTick=0.1

  """
  TODO
  """
	function tickUpdate(script::JLScript)
		script.state.currentTime = currentTime(script.state.startTime)
		script.state.ticks+=1
		if OnTime(1.0,script.state.ticksTime)
			script.state.ticksTotal=script.state.ticks
			script.state.ticks=0
		end
	end

  """
  TODO
  """
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

  """
  TODO
  """
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

  """
  TODO
  """
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

	# create script
	create(:input, "scripts/input.jl")

	WindowManager.loop(WINDOW, function()
		Libc.systemsleep(programTick)
		runOnFileUpdate()
		JLScriptManager.loop(run)
	end)

end
```
