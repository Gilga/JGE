using ModernGL
using GLFW

function main()
  println("---------------------------------------------------------------------")
  println("[ Start Program ]\n")
  versioninfo()
  println("---------------------------------------------------------------------")

  ### window
  size=[800,600]

  GLFW.WindowHint(GLFW.SAMPLES, 4)
  GLFW.WindowHint(GLFW.CONTEXT_VERSION_MAJOR, 3)
  GLFW.WindowHint(GLFW.CONTEXT_VERSION_MINOR, 3)

  window = GLFW.CreateWindow(size[1], size[2], "Julia GLFW Window")
  GLFW.MakeContextCurrent(window)

  GLFW.WindowHint(GLFW.OPENGL_FORWARD_COMPAT, true)
  GLFW.WindowHint(GLFW.OPENGL_PROFILE, GLFW.OPENGL_CORE_PROFILE)

  ModernGL.glEnable(0)

  GLFW.Terminate()
end
