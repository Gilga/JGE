VERSION >= v"0.4.0-dev+6521" && __precompile__(true)

include("JLGEngine.jl")

importall LoggerManager

"""
TODO
"""
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

"""
TODO
"""
type ScriptRefs <: JLComponent
	WINDOW	::Any
	GD		::Any

	ScriptRefs() = new()
end

"""
TODO
"""
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

### configure App
#function __init__()
#end

#Environment.StartMainLogger()
#Logging.configure(level=Logging.OFF)

#console = Environment.CreateLogger(:Console, "console.log")
# Logging.configure(console, output=STDOUT)
# log = Environment.CreateLogger(:Shader, "shader.log")
# Logging.configure(log,level=OFF)
# Environment.LogTest()
# Logging.debug(log,"debug message")
# Logging.info(log,"info message")
# Logging.warn(log,log,"warning message")
# Logging.err(log,"error message")
# Logging.critical(log,"critical message")
###

# (errorRead, errorWrite) = redirect_stderr()
#
# atexit(function ()
#     close(errorWrite)
#     errors = readavailable(errorRead)
#     close(errorRead)
#     logfile = open(string(Environment.GetPath(:LOGS),"errors.log"), "a")
#     write(logfile, errors)
#     close(logfile)
# end)

"""
TODO
"""
function start()
	# (errorRead, errorWrite) = redirect_stderr()

	# atexit(function ()
			# close(errorWrite)

			# errors = readavailable(errorRead)

			# close(errorRead)

			# logfile = open("errors.log", "a")
			# write(logfile, errors)
			# close(logfile)
	# end)

	#(outRead, outWrite) = redirect_stdout()
	#
#	print("Test")
	#print("ing")
	#
	#close(outWrite)
	#
	#data = readavailable(outRead)
	#
	#close(outRead)

	#logfile = open("debug.log", "a")
	#write(logfile, data)
	#close(logfile)

	signalTime = 0

	#function updateSignals()
	#	result = TimeManager.OnTick(0.01, signalTime)
	#	if result[1]
	#		signalTime = result[2]
	#		Reactive.run(1)
	#	end
	#end

#macro ifund(exp)
#    local e = :($exp)
#    isdefined(e.args[1]) ? :($(e.args[1])) : :($(esc(exp)))
#end

	JLGEngine.init()

	RessourceManager.AddPath(:LOGS,"logs")
	RessourceManager.AddPath(:SCRIPTS,"scripts")
	RessourceManager.AddPath(:SHADERS,"shaders")

	println("---------------------------------------------------------------------")
	println("Start Program @ ", now())
	versioninfo()

	#try
	WINDOW = WindowManager.create("Julia GLFW Window",(800,600))

	#(GLFW.OPENGL_FORWARD_COMPAT, true)
	#(GLFW.OPENGL_PROFILE, GLFW.OPENGL_CORE_PROFILE)
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

	# bad()
#catch err
#	VLWindow.terminate()
#	println("There was an error: ", err)
	#readline()
#end

end

end
