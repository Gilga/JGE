# [WindowManager.jl](@id WindowManager.jl)

## import
* [GLFW.jl](https://github.com/JuliaGL/GLFW.jl) - Docs [here](http://www.glfw.org/docs/latest/)
* GLFW.Window

```@docs
WindowManager.WindowHandler
```

```@docs
WindowManager.getWindowHandler()
```

```@docs
WindowManager.setWindowHandler(this::WindowManager.WindowHandler)
```

```@docs
WindowManager.terminate()
```

```@docs
WindowManager.setListener(this::WindowManager.WindowHandler, key::Symbol, listener::Function)
```

```@docs
WindowManager.OnWindowResize(window::WindowManager.Window, width::Number, height::Number)
```

```@docs
WindowManager.OnWindowIconify(window::WindowManager.Window, iconified::Number)
```

```@docs
WindowManager.OnWindowClose(window::WindowManager.Window)
```

```@docs
WindowManager.OnWindowFocus(window::WindowManager.Window, focused::Number)
```

```@docs
WindowManager.OnWindowRefresh(window::WindowManager.Window)
```

```@docs
WindowManager.OnFramebufferResize(window::WindowManager.Window, width::Number, height::Number)
```

```@docs
WindowManager.OnCursorEnter(window::WindowManager.Window, entered::Number)
```

```@docs
WindowManager.OnDroppedFiles(window::WindowManager.Window, files::AbstractArray)
```

```@docs
WindowManager.OnWindowPos(window::WindowManager.Window, x::Number, y::Number)
```

```@docs
WindowManager.OnCursorPos(window::WindowManager.Window, x::Number, y::Number)
```

```@docs
WindowManager.OnScroll(window::WindowManager.Window, x::Number, y::Number)
```

```@docs
WindowManager.OnCharMods(window::WindowManager.Window, code::Char, mods::Number)
```

```@docs
WindowManager.OnUpdateEvents()
```

```@docs
WindowManager.OnKey(window::WindowManager.Window, key::Number, scancode::Number, action::Number, mods::Number)
```

```@docs
WindowManager.OnMouseKey(window::WindowManager.Window, key::Number, action::Number, mods::Number)
```

```@docs
WindowManager.OnUnicodeChar(window::WindowManager.Window, unicode::Char)
```

```@docs
WindowManager.ShowError(debugging::Bool)
```

```@docs
WindowManager.OnEvent(this::WindowManager.WindowHandler, eventName::Symbol, args...)
```

```@docs
WindowManager.title(this::WindowManager.WindowHandler, name::String)
```

```@docs
WindowManager.cursor(this::WindowManager.WindowHandler, mode::Symbol)
```

```@docs
WindowManager.fullscreen(this::WindowManager.WindowHandler, full::Bool)
```

```@docs
WindowManager.SetWindowMonitor(window::WindowManager.Window, monitor::GLFW.Monitor, xpos, ypos, width, height, refreshRate)
```

```@docs
WindowManager.open(this::WindowManager.WindowHandler, windowhints=[])
```

```@docs
WindowManager.isClosing(this::WindowManager.Window)
```

```@docs
WindowManager.create(name::AbstractString, size::Tuple{Number,Number})
```

```@docs
WindowManager.close(this::WindowManager.WindowHandler)
```

```@docs
WindowManager.swap(this::WindowManager.WindowHandler)
```

```@docs
WindowManager.update(this::WindowManager.WindowHandler)
```

```@docs
WindowManager.loop(this::WindowManager.WindowHandler, repeat::Function)
```

