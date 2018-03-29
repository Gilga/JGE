module Environment

using RessourceManager
using FileManager

#using Logging
#@Logging.configure(level=DEBUG)

#export LOGGERS

#export CreateLogger
#export LogTest
#export StartMainLogger

#LogLevel = Logging.DEBUG
#LOGGERS = Dict{Any,Logger}()

#function (d::Dict, s::Symbol, f::Function, args...)
#  ok = true
#	for (k,e) in d
#     ok = f(e,s,args...)
#     if !ok break end
#  end
#	ok
#end

# EVENTS = [ :OnWindowIconify, :OnWindowResize, :OnWindowClose, :OnWindowFocus,
# :OnWindowPos, :OnWindowMove, :OnWindowRefresh, :OnFramebufferResize,
# :OnCursorPos, :OnCursorMove, :OnCursorEnter, :OnDroppedFiles,
# :OnKey, :OnMouseKey, :OnScroll, :OnCharMods ]

#StartMainLogger() = Logging.configure(output=open(string(GetPath(:LOGS),"log","_",CurrentDay(),".log"),"w"))

#function ShowLog(show)
  #lvl = if log == show LogLevel else Logging.OFF end
  #Logging.configure(level=lvl)
#end

#function CreateLogger(id::Any, path::AbstractString, lvl=DEBUG)
  #(dir, name, ext) = SplitFileName(path, GetPath(:LOGS))
  #logger = Logger(name)
  #Logging.configure(logger, level=lvl, output=open(string(dir,name,"_",CurrentDay(),ext), "w"))
  #LOGGERS[id] = logger
  #logger
	#nothing
#end

#function LogTest()
	#@debug("debug message")
	#@info("info message")
	#@warn("warning message")
	#@err("error message")
	#@critical("critical message")
#end

end # Environment
