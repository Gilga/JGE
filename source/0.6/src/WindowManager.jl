module WindowManager

import GLFW
import GLFW.Window

WINDOW_HANDLER_ID_COUNTER = 0
lastKey=Number(0)
KEYS=Dict{Number,Number}()

""" TODO """
type WindowHandler
	id						::Symbol
	name					::AbstractString
	pos						::Tuple{Number,Number}
	size					::Tuple{Number,Number}
	lastSize			::Tuple{Number,Number}
	listenList		::Dict{Symbol, Function}
	events				::Array{Array{Any,1},1}
	lastPos	      ::AbstractVector
	lastCursorPos	::AbstractVector
	nativeWindow	::Window
	fullScreen		::Bool
end

""" TODO """
function WindowHandler(name::AbstractString, size::Tuple{Number,Number})
  global WINDOW_HANDLER_ID_COUNTER

  if WINDOW_HANDLER_ID_COUNTER == 0
    GLFW.Init()
  end

  WindowHandler(
    Symbol("display"*string(WINDOW_HANDLER_ID_COUNTER+=1)),
    name,
    (0,0),
    size,
    size,
    Dict(),
    [],[],[],
    Window(GLFW.WindowHandle(C_NULL)),
    false
  )
end

WINDOW_TO_HANDLER_DICT = Dict{Window, WindowHandler}()

windowHandler = nothing

""" TODO """
getWindowHandler() = windowHandler

""" TODO """
setWindowHandler(this::WindowHandler) = (global windowHandler = this)

""" TODO """
terminate() = GLFW.Terminate()

""" TODO """
function setListener(this::WindowHandler, key::Symbol, listener::Function)
	this.listenList[key] = listener
end

################################################################################
# Window Events

""" TODO """
function OnWindowResize(window::Window, width::Number, height::Number)
	h = WINDOW_TO_HANDLER_DICT[window]
	h.size = (width,height)
	OnEvent(h, :OnWindowResize, [width,height])
end

""" TODO """
OnWindowIconify(window::Window, iconified::Number) = OnEvent(WINDOW_TO_HANDLER_DICT[window], :OnWindowIconify, iconified)

""" TODO """
OnWindowClose(window::Window) = OnEvent(WINDOW_TO_HANDLER_DICT[window], :OnWindowClose)

""" TODO """
OnWindowFocus(window::Window, focused::Number) = OnEvent(WINDOW_TO_HANDLER_DICT[window], :OnWindowFocus, focused)

""" TODO """
OnWindowRefresh(window::Window) = OnEvent(WINDOW_TO_HANDLER_DICT[window], :OnWindowRefresh)

""" TODO """
OnFramebufferResize(window::Window, width::Number, height::Number) =  OnEvent(WINDOW_TO_HANDLER_DICT[window], :OnFramebufferResize, [width,height])

""" TODO """
OnCursorEnter(window::Window, entered::Number) = OnEvent(WINDOW_TO_HANDLER_DICT[window], :OnCursorEnter, entered)

""" TODO """
OnDroppedFiles(window::Window, files::AbstractArray) = OnEvent(WINDOW_TO_HANDLER_DICT[window], :OnDroppedFiles, files)

""" TODO """
function OnWindowPos(window::Window, x::Number, y::Number)
  h = WINDOW_TO_HANDLER_DICT[window]
  t = [-x,y]
  OnEvent(h, :OnWindowPos, t)
  l = h.lastPos; if l == [] l = t end
  n = l - t
  h.lastPos = t
  OnEvent(h, :OnWindowMove, n)
end

""" TODO """
function OnCursorPos(window::Window, x::Number, y::Number)
  h = WINDOW_TO_HANDLER_DICT[window]
  t = [x,y]
  OnEvent(h, :OnMousePos, t)
  l = h.lastCursorPos; if l == [] l = t end
  n = l - t
  h.lastCursorPos = t
  OnEvent(h, :OnMouseMove, n)
end

# Input Events
""" TODO """
OnScroll(window::Window, x::Number, y::Number) = OnEvent(WINDOW_TO_HANDLER_DICT[window], :OnScroll, [x,y])

""" TODO """
OnCharMods(window::Window, code::Char, mods::Number) = OnEvent(WINDOW_TO_HANDLER_DICT[window], :OnCharMods, code, mods)

""" TODO """
function OnUpdateEvents()
  GLFW.PollEvents()  # Poll for and process events
	for (window,h) in WINDOW_TO_HANDLER_DICT
		for e in h.events
			if length(e) > 5 && e[1] == :OnKey
				key=e[2]
				if haskey(KEYS, key) e[6]=KEYS[key] end
			end
			OnEvent(h, e...)
		end
		if length(h.events) > 0	h.events	= [] end
	end
end

""" TODO """
function OnKey(window::Window, key::Number, scancode::Number, action::Number, mods::Number)
	h = WINDOW_TO_HANDLER_DICT[window]
	global lastKey = key
	push!(h.events, [ :OnKey, key, scancode, action, mods, Number(0) ]) # unicode = 0
end

""" TODO """
function OnMouseKey(window::Window, key::Number, action::Number, mods::Number)
  h = WINDOW_TO_HANDLER_DICT[window]
  OnEvent(h, :OnMouseKey, key, action, mods)
end

""" TODO """
function OnUnicodeChar(window::Window, unicode::Char)
	h = WINDOW_TO_HANDLER_DICT[window]
	if lastKey > 0 KEYS[lastKey]=Number(unicode) end
	global lastKey=0
end

################################################################################

""" TODO """
function ShowError(debugging::Bool)
  @static if is_apple() return end
  GLFW.WindowHint(GLFW.OPENGL_DEBUG_CONTEXT, convert(Cint, debugging))
end

""" TODO """
function OnEvent(this::WindowHandler, eventName::Symbol, args...)
 #a = values(d) # convert Dict Values to Array
  for (k,listener) in this.listenList
		listener(eventName, args...)
    #s = listener.storage
		#if haskey(s.events, eventName) s.events[eventName](args...) end
  end
end

""" TODO """
title(this::WindowHandler, name::String) = GLFW.SetWindowTitle(this.nativeWindow, name)

""" TODO """
function cursor(this::WindowHandler, mode::Symbol)
	GLFW.SetInputMode(this.nativeWindow, GLFW.CURSOR, eval(:(GLFW.$mode)))
	#GLFW.STICKY_KEYS or GLFW.STICKY_MOUSE_BUTTONS
end

""" TODO """
function fullscreen(this::WindowHandler, full::Bool)
	monitor = GLFW.GetPrimaryMonitor()
	mode = GLFW.GetVideoMode(monitor)
	pos = GLFW.GetMonitorPos(monitor)

	if !full
		pos = this.pos
		this.size = this.lastSize
		mode = GLFW.VidMode(this.size[1], this.size[2], mode.redbits, mode.greenbits, mode.bluebits, mode.refreshrate)
		monitor = GLFW.Monitor(C_NULL)
	else
		this.lastSize = this.size
		this.pos = GLFW.GetWindowPos(this.nativeWindow)
		this.size = GLFW.GetWindowSize(this.nativeWindow)
	end
	
	this.fullScreen = full
	SetWindowMonitor(this.nativeWindow, monitor, pos[1], pos[2], mode.width, mode.height, mode.refreshrate)
end

# GLFW.SetWindowMonitor
""" TODO """
function SetWindowMonitor(window::Window, monitor::GLFW.Monitor, xpos, ypos, width, height, refreshRate)
    ccall((:glfwSetWindowMonitor, GLFW.lib), Void, (GLFW.WindowHandle, GLFW.Monitor, Cint, Cint, Cint, Cint, Cint), window, monitor, xpos, ypos, width, height, refreshRate)
end

# Create a window and its OpenGL context
""" TODO """
function open(this::WindowHandler, windowhints=[])
    for (id,val) in windowhints
        GLFW.WindowHint(eval(:(GLFW.$id)),val)
    end

    w = this.size[1]; h = this.size[2]

    window = GLFW.CreateWindow(w, h, this.name)
    this.nativeWindow = window
		
		this.pos = GLFW.GetWindowPos(this.nativeWindow)

    WINDOW_TO_HANDLER_DICT[window] = this

  	GLFW.MakeContextCurrent(window)

    GLFW.SwapInterval(0)

    GLFW.ShowWindow(window)

    #GLFW.SetWindowSize(window, w, h) # Seems to be necessary to guarantee that window > 0

    # Window Callbacks
    GLFW.SetWindowIconifyCallback(window, OnWindowIconify)
    GLFW.SetWindowSizeCallback(window, OnWindowResize)
    GLFW.SetWindowCloseCallback(window, OnWindowClose)
    GLFW.SetWindowFocusCallback(window, OnWindowFocus)
    GLFW.SetWindowPosCallback(window, OnWindowPos)
    GLFW.SetWindowRefreshCallback(window, OnWindowRefresh)
    GLFW.SetFramebufferSizeCallback(window, OnFramebufferResize)
    GLFW.SetCursorPosCallback(window, OnCursorPos)
    GLFW.SetCursorEnterCallback(window, OnCursorEnter)
    GLFW.SetDropCallback(window, OnDroppedFiles)

	   # Input Callbacks
    GLFW.SetKeyCallback(window, OnKey)
    GLFW.SetMouseButtonCallback(window, OnMouseKey)
    GLFW.SetScrollCallback(window, OnScroll)
    GLFW.SetCharCallback(window, OnUnicodeChar)
    GLFW.SetCharModsCallback(window, OnCharMods)
end

""" TODO """
isClosing(this::Window) = GLFW.WindowShouldClose(this.nativeWindow)
isClosing(this::WindowHandler) = GLFW.WindowShouldClose(this.nativeWindow)

""" TODO """
function create(name::AbstractString, size::Tuple{Number,Number})
	h=WindowHandler(name,size)
	setWindowHandler(h)
	h
end

""" TODO """
function close(this::WindowHandler)
	global WINDOW_HANDLER_ID_COUNTER
	if WINDOW_HANDLER_ID_COUNTER == 1 GLFW.Terminate() end
	if WINDOW_HANDLER_ID_COUNTER > 0 WINDOW_HANDLER_ID_COUNTER -= 1 end
end

""" TODO """
function swap(this::WindowHandler)
  GLFW.SwapBuffers(this.nativeWindow)   # Swap front and back buffers
end

""" TODO """
function update(this::WindowHandler)
  swap(this)
	OnUpdateEvents()
end

""" Loop until the user closes the window """
function loop(this::WindowHandler, repeat::Function)
	while !isClosing(this)
		repeat()
		update(this) # update window
	end
	close(this)
end

end # WindowManager
