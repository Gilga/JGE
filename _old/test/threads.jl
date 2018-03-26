include("../App/src/TimeManager.jl")
include("../App/src/LogManager.jl")
include("../App/src/ThreadManager.jl")
include("../App/src/ThreadFunctions.jl")

Messages = Array{String,1}()
clearMessages() = (global Messages = Array{String,1}())
getMessages() = Messages

pushMessage(t, name, msg) = thread_push(t, Messages, LogManager.logMsg(:Info , name, msg))
pushDebug(t, name, msg) = thread_push(t, Messages, LogManager.logMsg(:Debug, name, msg))
pushError(t, name, msg) = thread_push(t, Messages, LogManager.logMsg(:Error, name, msg))
pushWarning(t, name, msg) = thread_push(t, Messages, LogManager.logMsg(:Warning, name, msg))

function thread_printer()
	p=(
		"Printer",
		function(t)
			#init
			while true
				global Messages
				pushMessage(t, p[1], "I print messages")
				ThreadManager.safe_call(t, function(t)
					if length(Messages) > 0
						println("---[Messages]---")
						for msg in Messages println(msg) end
						clearMessages()
						println("----------------")
					end
				end)
				thread_sleep(1)
			end
			#cleanUp
		end,
	)
end

function thread_compute()
	p=(
		"Compute", 
		function(t)
			#init
			myTime = 0
			while true
				result = TimeManager.OnTick(2, myTime)
				if result[1]
					myTime = result[2]
					pushMessage(t, p[1], "I calculate stuff")
				end
				thread_sleep(1)
			end
			#cleanUp
		end,
	)
end

function thread_renderer()
	p=(
		"Renderer",
		function(t)
			pushMessage(t, p[1], "I render objects")
		end,
	)
end

function thread_sound()
	p=(
		"Sound", 
		function(t)
			pushMessage(t, p[1], "I play sounds")
		end,
	)
end

function main()
	println("Test Threads")
	t1 = thread_init(thread_printer())
	t2 = thread_init(thread_compute())
	t3 = thread_init(thread_renderer())
	t4 = thread_init(thread_sound())
	ThreadManager.run([t1,t2,t3,t4])
end