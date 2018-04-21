module LoggerManager

import Base.print, Base.println, Base.info, Base.warn, Base.error

export @printf # cannot replace Base.@printf

using Suppressor
using TimeManager
using CoreExtended

export LOGGER_OUT
export LOGGER_ERROR

export print
export printf
export println
export info
export warn
export error

LOGGER_OUT = "out.log"
LOGGER_ERROR = "error.log"

function __init__()
	open(LOGGER_OUT, "w+")
	open(LOGGER_ERROR, "w+")
end


@suppress begin print(xs...) = open(f -> (print(f, xs...); print(STDOUT, xs...)), LOGGER_OUT, "a+") end
macro printf(xs...) open(f -> (:(Base.@printf(f, $xs...)); :(Base.@printf(:STDOUT, $xs...))),LOGGER_OUT, "a+") end 
@suppress begin println(xs...) = open(f -> (println(f, programTimeStr(), " ", xs...); println(STDOUT, xs...)), LOGGER_OUT, "a+") end

@suppress begin info(xs...) = open(f -> (info(f, programTimeStr(), " ", xs...); info(STDOUT, xs...)), LOGGER_OUT, "a+") end
@suppress begin error(xs...) = open(f -> (error(f, programTimeStr()," ", xs...); error(STDERR, xs...)), LOGGER_ERROR, "a+") end
@suppress begin warn(xs...) = open(f -> (warn(f, programTimeStr()," ", xs...); warn(STDERR, xs...)), LOGGER_ERROR, "a+") end

"""
TODO
"""
function logException(ex::Exception)
	t=programTimeStr()

	println(STDERR, "[ ERROR ] EXCEPTION! See '$LOGGER_ERROR' for more info.")
	open(f -> println(f, t, " [ ERROR ] EXCEPTION! See '$LOGGER_ERROR' for more info."), LOGGER_OUT, "a+")
	open(function(f)
			println(f, t, " --- [ BACKTRACE ] ---")
			Base.showerror(f, ex, catch_backtrace())
			println(f, "\n---------------------")
	end, LOGGER_ERROR, "a+")
end

CoreExtended.linkToException(logException)

#messageToString(mode::String, time::String, name::String, msg::String) = string(time, " ", mode != "" ? string("[",mode,"] "): "" , name != "" ? string(name, " ") : "" , ": ", msg, "\n")
#logMsg(mode::Symbol, name::String, msg::String) = messageToString(string(mode), programTimeStr(), name, msg)

end #LoggerManager