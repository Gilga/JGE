module WindowManager

import GLFW
import GLFW.Window

WINDOW_HANDLER_ID_COUNTER = 0
lastKey=Number(0)
KEYS=Dict{Number,Number}()

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

	function WindowHandler(name::AbstractString, size::Tuple{Number,Number})
		global WINDOW_HANDLER_ID_COUNTER

		if WINDOW_HANDLER_ID_COUNTER == 0
			GLFW.Init()
		end

    new(
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
end

WINDOW_TO_HANDLER_DICT = Dict{Window, WindowHandler}()

windowHandler = nothing

getWindowHandler() = windowHandler
setWindowHandler(this::WindowHandler) = (global windowHandler = this)

terminate() = GLFW.Terminate()

function setListener(this::WindowHandler, key::Symbol, listener::Function)
	this.listenList[key] = listener
end

################################################################################
# Window Events

function OnWindowResize(window::Window, width::Number, height::Number)
	h = WINDOW_TO_HANDLER_DICT[window]
	h.size = (width,height)
	OnEvent(h, :OnWindowResize, [width,height])
end

OnWindowIconify(window::Window, iconified::Number) = OnEvent(WINDOW_TO_HANDLER_DICT[window], :OnWindowIconify, iconified)
OnWindowClose(window::Window) = OnEvent(WINDOW_TO_HANDLER_DICT[window], :OnWindowClose)
OnWindowFocus(window::Window, focused::Number) = OnEvent(WINDOW_TO_HANDLER_DICT[window], :OnWindowFocus, focused)
OnWindowRefresh(window::Window) = OnEvent(WINDOW_TO_HANDLER_DICT[window], :OnWindowRefresh)
OnFramebufferResize(window::Window, width::Number, height::Number) =  OnEvent(WINDOW_TO_HANDLER_DICT[window], :OnFramebufferResize, [width,height])
OnCursorEnter(window::Window, entered::Number) = OnEvent(WINDOW_TO_HANDLER_DICT[window], :OnCursorEnter, entered)
OnDroppedFiles(window::Window, files::AbstractArray) = OnEvent(WINDOW_TO_HANDLER_DICT[window], :OnDroppedFiles, files)

function OnWindowPos(window::Window, x::Number, y::Number)
  h = WINDOW_TO_HANDLER_DICT[window]
  t = [-x,y]
  OnEvent(h, :OnWindowPos, t)
  l = h.lastPos; if l == [] l = t end
  n = l - t
  h.lastPos = t
  OnEvent(h, :OnWindowMove, n)
end

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
OnScroll(window::Window, x::Number, y::Number) = OnEvent(WINDOW_TO_HANDLER_DICT[window], :OnScroll, [x,y])
OnCharMods(window::Window, code::Char, mods::Number) = OnEvent(WINDOW_TO_HANDLER_DICT[window], :OnCharMods, code, mods)

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

function OnKey(window::Window, key::Number, scancode::Number, action::Number, mods::Number)
	h = WINDOW_TO_HANDLER_DICT[window]
	global lastKey = key
	push!(h.events, [ :OnKey, key, scancode, action, mods, Number(0) ]) # unicode = 0
end

function OnMouseKey(window::Window, key::Number, action::Number, mods::Number)
  h = WINDOW_TO_HANDLER_DICT[window]
  OnEvent(h, :OnMouseKey, key, action, mods)
end

function OnUnicodeChar(window::Window, unicode::Char)
	h = WINDOW_TO_HANDLER_DICT[window]
	if lastKey > 0 KEYS[lastKey]=Number(unicode) end
	global lastKey=0
end

################################################################################

function ShowError(debugging::Bool)
  @static if is_apple() return end
  GLFW.WindowHint(GLFW.OPENGL_DEBUG_CONTEXT, convert(Cint, debugging))
end

function OnEvent(this::WindowHandler, eventName::Symbol, args...)
 #a = values(d) # convert Dict Values to Array
  for (k,listener) in this.listenList
		listener(eventName, args...)
    #s = listener.storage
		#if haskey(s.events, eventName) s.events[eventName](args...) end
  end
end

title(this::WindowHandler, name::String) = GLFW.SetWindowTitle(this.nativeWindow, name)

function cursor(this::WindowHandler, mode::Symbol)
	GLFW.SetInputMode(this.nativeWindow, GLFW.CURSOR, eval(:(GLFW.$mode)))
	#GLFW.STICKY_KEYS or GLFW.STICKY_MOUSE_BUTTONS
end

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
function SetWindowMonitor(window::Window, monitor::GLFW.Monitor, xpos, ypos, width, height, refreshRate)
    ccall((:glfwSetWindowMonitor, GLFW.lib), Void, (GLFW.WindowHandle, GLFW.Monitor, Cint, Cint, Cint, Cint, Cint), window, monitor, xpos, ypos, width, height, refreshRate)
end

# Create a window and its OpenGL context
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

isClosing(this::Window) = GLFW.WindowShouldClose(this.nativeWindow)
isClosing(this::WindowHandler) = GLFW.WindowShouldClose(this.nativeWindow)

function create(name::AbstractString, size::Tuple{Number,Number})
	h=WindowHandler(name,size)
	setWindowHandler(h)
	h
end

function close(this::WindowHandler)
	global WINDOW_HANDLER_ID_COUNTER
	if WINDOW_HANDLER_ID_COUNTER == 1 GLFW.Terminate() end
	if WINDOW_HANDLER_ID_COUNTER > 0 WINDOW_HANDLER_ID_COUNTER -= 1 end
end

function swap(this::WindowHandler)
  GLFW.SwapBuffers(this.nativeWindow)   # Swap front and back buffers
end

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
