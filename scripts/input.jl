using WindowManager
using ModernGL
using TimeManager
using MatrixMath
using Quaternions
using StaticArrays

using JLGEngine.LibGL
using JLGEngine.ModelManager
using JLGEngine.ShaderManager
using JLGEngine.TransformManager
using JLGEngine.CameraManager
using JLGEngine.RenderManager

include("objects/light.jl")

SUN = Light()
SPOTLIGHT = Light()

SCRIPTTICK=0 #0.01
FRAMES = 0
TICKS = 0

fokusChange=false

_RELEASE = 0
_PRESS = 1
_REPEAT = 2
WINDOW = nothing
lastKey = 0
projection = IMat4x4f
camera = IMat4x4f
model = IMat4x4f
randomTick=false
isFocus=true
lastTime=0
currentFrames = 0
max_fps = 0
max_fmps = 0
time = 0
renderReady=false
cursorpos = Vec2f(0,0)
old_cursorpos = Vec2f(0,0)
windowsize = Vec2f(800,600)
fullscreen = false
keyPressed = false
rightMouseKeyPressed = false
modelID = 0
planeModel = nothing
cubeModel = nothing
getVertexBuffer = ()->nothing
getUVBuffer = ()->nothing

angle = Vec2f(0,0)
old_Angle = Vec2f(0,0)
r360 = pi * 2;

right = 0
up = 0
forward = 0
zoom = 0

plane = nothing
cube = nothing
fpsCam = nothing

#@printf("OnKey2: %i, %i\n", 'c','C')

function clearScreen()
	glClearColor(0.0, 0.0, 0.0, 0.0)
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT | GL_STENCIL_BUFFER_BIT)
	WindowManager.update(WINDOW)
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT | GL_STENCIL_BUFFER_BIT)
end

function OnWindowFocus(focused::Bool)
	if !fokusChange return end
	global isFocus = focused
	t=focused ? "" : " - PAUSE"
	WindowManager.title(WINDOW,"$(WINDOW.name)$t")
	setProgramTick(isFocus ? SCRIPTTICK : 0.1)
	setRenderUpdate(isFocus)
	clearScreen()
	println("Fokus: ", focused)
end

function OnWindowResize(size::Array{Int32,1})
	global windowsize=Vec2f(size[1],size[2])
	println("Window Size $(WINDOW.size)")
	CameraManager.setRatio(fpsCam, Float32(windowsize[1]/windowsize[2]))
end

keyFB = 0
keyLR = 0
keyUD = 0

wireframe = false

function OnKey(key::Number, scancode::Number, action::Number, mods::Number, unicode::Number)
  #println("OnKey: '$key', '",Char(unicode),"'($unicode) '$action'")

	if key == 290 && action == 1 # F1 = 290
		global fullscreen=!fullscreen
		WindowManager.fullscreen(WINDOW,fullscreen)

	elseif key == 291 && action == 1 # F2
		global wireframe
		wireframe = !wireframe
		println("Wireframe: ",wireframe)

	elseif key == 293 && action == 1 # F4 = 293
		#this.callList[:reload]()
		#this.callList[:shaderRefresh]()
		#whos()
		println(current_module())

	elseif unicode == UInt32('w')
		global keyFB = (action > 0)?1:0
	elseif unicode == UInt32('s')
		global keyFB = (action > 0)?-1:0
	elseif unicode == UInt32('d')
		global keyLR = (action > 0)?1:0
	elseif unicode == UInt32('a')
		global keyLR = (action > 0)?-1:0
	elseif unicode == UInt32(32)
		global keyUP = (action > 0)?1:0
	elseif unicode == UInt32('c')
		global keyUP = (action > 0)?-1:0

	elseif unicode == UInt32('m') && action > 0
		global modelID += 1
		if modelID > 1 modelID = 0 end
		if modelID == 0 cube.model=planeModel end
		if modelID == 1 cube.model=cubeModel end
  end

	global keyPressed = action != 0

	lastKey = key
	#this.storage[:lastKey] = key

end

function OnMouseKey(key::Number, action::Number, mods::Number)
	#println("Mouse: ", key, ", ", action)
	global keyPressed = action != 0

	global rightMouseKeyPressed = (key == 1 && action == 1)
	rightMouseKeyReleased = (key == 1 && action == 0)

	if rightMouseKeyPressed
		WindowManager.cursor(WINDOW, :CURSOR_DISABLED)
		global old_cursorpos = cursorpos
	end

	if rightMouseKeyReleased
		WindowManager.cursor(WINDOW, :CURSOR_NORMAL)
	end

end

function OnMousePos(pos::AbstractVector)
	global cursorpos = Vec2f(pos[1]/WINDOW.size[1],pos[2]/WINDOW.size[2])

	#println("Mouse: ", cursorpos)

	if rightMouseKeyPressed	OnCamRotate() end
end

function OnMouseMove(pos::AbstractVector)
  #println("Mouse: ", pos)
end

function OnCamRotate()
	mx = cursorpos[1] - old_cursorpos[1]
	my = cursorpos[2] - old_cursorpos[2]
	global old_cursorpos = cursorpos

	fpsCam.transform.rotation+=Vec3f(-mx*2,my*2,0f0) #Vec3f((-mx+0.5f0),(-0.5f0+my),0f0)
	CameraManager.updateRotation(fpsCam)
end

function OnMove(key::Symbol, m::Number)
		forward = MatrixMath.forwardVector4(fpsCam.rotationMat)
		right = MatrixMath.rightVector4(fpsCam.rotationMat)
		up = MatrixMath.upVector4(fpsCam.rotationMat)

		if key == :FORWARD
			fpsCam.transform.position += forward*(m*0.05f0)
		elseif key == :RIGHT
			fpsCam.transform.position -= right*(m*0.05f0) #+Vec3f(-right*0.02f0,-up*0.02f0,forward*0.02f0)
		elseif key == :UP
			fpsCam.transform.position -= up*(m*0.05f0)
		end
		CameraManager.updateTranslation(fpsCam)
end

OnShaderPropertyUpdate = (
	"iDummy" => () -> 0
	,"iResolution" => () -> windowsize
	,"cursorpos" => () -> cursorpos
	,"key" => () -> keyPressed
	,"iTessLevel" => () -> UInt32(65)
	,"iGlobalTime" => () -> Float32(programTime())
	,"programTime" => () -> Float32(scriptTime())
	,"programTick" => () -> Float32(SCRIPTTICK)
	,"frames" => () -> Float32(currentFrames)
	#,"iProjection" => () -> fpsCam.projectionMat
	#,"iView" => () -> fpsCam.viewMat
	#,"iModel" => () -> IMat4x4f
	#,"iUV" => () -> RenderManager.is(:plane) ? RenderManager.getData(:VERTEX) : RenderManager.getData(:UV)
	#,"iNORMAL" => () -> RenderManager.is(:plane) ? RenderManager.getData(:VERTEX) : RenderManager.getData(:NORMAL)
	,"iMVP" => () -> RenderManager.getMVP()
	,"iModel" => () -> fpsCam.modelMat
	,"iVP" => () -> fpsCam.projectionMat*fpsCam.viewMat
	,"iCameraPos" => () -> fpsCam.transform.position
	,"iPos" => () -> cube.transform.position
	,"iLightPos" => () -> SPOTLIGHT.position #getLightData(SPOTLIGHT)
	,"iLightColor" => () -> SPOTLIGHT.color
	#,"tex" => () -> Int32(0)
)

function OnShaderReload(path)
	println("Reloaded Shader ",path,".")

	#chomp(readline())
end

function OnPreRender()
	global rcount
	global renderReady = true

	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT | GL_STENCIL_BUFFER_BIT)
	glViewport(0, 0, windowsize[1], windowsize[2])

	# Configure global settings
	#glDisable(GL_CULL_FACE)
	glEnable(GL_CULL_FACE)
	glFrontFace(GL_CCW)
	glCullFace(GL_BACK)

	glEnable(GL_DEPTH_TEST)
	glDepthFunc(GL_LESS)
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)

	glDepthMask(GL_TRUE)
	glColorMask(GL_TRUE, GL_TRUE, GL_TRUE, GL_TRUE)
	glDepthRange(0.1f0,	1f0) #glDepthRange(0.0001f0,	1000f0)
	glClearColor(0.75, 0.75, 0.75, 0.1)

	glPatchParameteri(GL_PATCH_VERTICES, 4)

	#glBlendEquation(GL_FUNC_ADD)
	#glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA)
	#glBlendFunc(GL_ONE_MINUS_SRC_ALPHA,GL_SRC_ALPHA)
	#glBlendFunc(GL_SRC_ALPHA, GL_SRC_COLOR)

	#glDisable(GL_BLEND)
	glEnable(GL_BLEND)
	#glBlendFunc(GL_ONE, GL_ONE)
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)

	showFrames()	
end

function OnPostRender()
	#println("------------------------------------")
end

function OnRender()
	RenderManager.renderAll()
end

function OnPostDraw()
	r=RenderManager.getSelected()
	if r.id == :FG ||  r.id == :BG
		#glBlendFuncSeparate(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA, GL_ONE, GL_ONE_MINUS_SRC_ALPHA)
		glEnable(GL_DEPTH_TEST)
	elseif r.id == :iplane
		#glDepthMask(GL_TRUE)
	elseif r.id == :cube
		#glEnable(GL_DEPTH_TEST)
		#glDepthFunc(GL_LESS)
		#glDisable(GL_CULL_FACE)
	end
	#println(r.id)
end

function OnPreDraw()
	r=RenderManager.getSelected()
	#println(r.id) #cube,iplane,plane

	if r.id == :FG || r.id == :BG
		glDisable(GL_DEPTH_TEST)
		#glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
		#glBlendFuncSeparate(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA, GL_ONE, GL_ONE_MINUS_SRC_COLOR);
	elseif r.id == :iplane
		#glDepthMask(GL_FALSE)
	elseif r.id == :plane
	elseif r.id == :cube
		#glDepthMask(GL_TRUE)
		#glColorMask(GL_FALSE, GL_FALSE, GL_FALSE, GL_TRUE)
		#glDepthFunc(GL_LESS)
		#glEnable(GL_CULL_FACE)
		#glCullFace(GL_FRONT)
		#glCullFace(GL_BACK)
		#glFrontFace(GL_CCW)

		#glDisable(GL_DEPTH_TEST)
		#glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
		#glBlendFuncSeparate(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA, GL_ONE, GL_ONE_MINUS_SRC_COLOR);
	end

	if wireframe glPolygonMode(GL_FRONT_AND_BACK, GL_LINE)
	else glPolygonMode(GL_FRONT_AND_BACK, GL_FILL)
	end

	#if !isFocus return end

	#if haskey(this.storage, :lastKey)
		#DRIVER.setShaderPropberty("key", this.storage[:lastKey] == UInt32('k') )
		#this.storage[:lastKey]=0
	#end
	#lastKey = 0

	#glActiveTexture(GL_TEXTURE0)
	#glBindTexture(GL_TEXTURE_2D, texture)

	#if isFocus RENDER()
	#else OnRenderPause()
	#end


	#model = mgl32.HomogRotate3D(float32(angle), mgl32.Vec3{0, 1, 0})

	#pointer([convert(Ptr{GLchar}, pointer(source))]))

	# Load the texture
	# texture = GRAPHICSDRIVER().CreateTexture(string(Environment.PATHS[:ROOT],"square.png"))
	# texture, err := GoniGL.NewTexture("square.png")
	# if err != nil {
	# 	panic(err)
	# }

	# draw
end

function OnRenderPause()

end

prevTime1 = Ref(0.0)
prevTime2 = Ref(0.0)

function showFrames()
	global TICKS
	global FRAMES
	global max_fps
	global max_fmps
	global WINDOW

	fps = FRAMES
	fpms = fps > 0 ? (1000.0 / fps) : 0

	# MAX
	if (max_fps < fps)
		max_fps = fps
		max_fmps = fpms
	end

	lastFrames = FRAMES
	FRAMES += 1

	#global currentFrames = fps/max_fps

	if OnTime(1.0,prevTime1)
		#global SCRIPTTICK
		#est = (1/SCRIPTTICK) * 0.6
		WindowManager.title(WINDOW,"$(WINDOW.name) - FPS $(round(fps, 2)) [$(round(max_fps, 2))] | FMPS $(round(fpms, 2)) [$(round(max_fmps, 2))] - Ticks $(TICKS)")
		global currentFrames = fps/max_fps
		FRAMES = 0
		TICKS = 0
	end

	if randomTick && OnTime(5.0,prevTime2)
		r = [0.1,0.05,0.01,0.005,0.001,0.0005,0.0001,0.00005,0.00001]
		global SCRIPTTICK=r[rand(1:length(r))] #0.00016*rand(1:100)
		setProgramTick(SCRIPTTICK)
		#if isFocus this.callList[:setProgramTick](SCRIPTTICK) end
		max_fps=0
		max_fmps=0
		FRAMES = 0
	end
end

prevTime3 = Ref(0.0)
function OnUpdate()
	global TICKS
	TICKS += 1
	#cube.transform.position = Vec3f(sin(FRAMES*0.01f0),0,0)

	if isFocus
		if OnTime(0.01, prevTime3)
			cube.transform.rotation = Vec3f(0.01f0,0.02f0,0.03f0) * programTime() * 10
			if keyFB != 0 OnMove(:FORWARD,keyFB) end
			if keyLR != 0 OnMove(:RIGHT,keyLR) end
			if keyUD != 0 OnMove(:UP,keyUD) end
		end
	end
end

function OnStart()
	println("Reload Entities...")

	robj_bg=RenderManager.create(:BG)
	robj_fg=RenderManager.create(:FG)
	
	robj_plane=RenderManager.create(:plane)
	robj_iplane=RenderManager.create(:iplane)
	
	robj_cube=RenderManager.create(:cube)
	robj_cube_sphere=RenderManager.create(:cube_sphere)
	
	robj_icosphere=RenderManager.create(:icosphere)

	robj_loaded_cube=RenderManager.create(:loaded_cube)
	robj_loaded_monkey=RenderManager.create(:loaded_monkey)
	robj_loaded_bannana=RenderManager.create(:loaded_bannana)
	
	global plane=robj_plane
	global cube=robj_cube_sphere
	
	println("Reload Shaders...")
	listenOnShaderReload = (p)->OnShaderReload(ShaderManager.getSource(p).path)
	ShaderManager.setListenerOnShaderPropertyUpdate(:OnShaderPropertyUpdate, OnShaderPropertyUpdate)

	shader_tess = ShaderManager.create(:Prog1, "shaders/tess.glsl", listenOnShaderReload)
	shader_mandel = ShaderManager.create(:Prog2, "shaders/mandelbrot.glsl", listenOnShaderReload) #mandelbrot, uv
	shader_color = ShaderManager.create(:Prog3, "shaders/color.glsl", listenOnShaderReload)
	shader_uv = ShaderManager.create(:Prog4, "shaders/uv.glsl", listenOnShaderReload)
	shader_texture = ShaderManager.create(:Prog5, "shaders/texture.glsl", listenOnShaderReload)
	shader_sphere_texture = ShaderManager.create(:Prog6, "shaders/sphere_texture.glsl", listenOnShaderReload)
	shader_fg = ShaderManager.create(:FG, "shaders/fg.glsl", listenOnShaderReload)
	shader_bg = ShaderManager.create(:BG, "shaders/bg.glsl", listenOnShaderReload)
	
	#ShaderManager.API.reload(shader_sphere_texture)

	robj_loaded_cube.shaderProgram=shader_texture
	robj_loaded_monkey.shaderProgram=shader_mandel
	robj_loaded_bannana.shaderProgram=shader_mandel

	robj_plane.shaderProgram=shader_tess
	robj_iplane.shaderProgram=shader_color
	robj_cube.shaderProgram=shader_mandel
	robj_icosphere.shaderProgram=shader_mandel
	robj_cube_sphere.shaderProgram=shader_sphere_texture
	
	robj_fg.shaderProgram=shader_fg
	robj_bg.shaderProgram=shader_bg
	
	#RenderManager.setMode(robj_iplane, :POLYGONMODE, [:FRONT_AND_BACK,:LINE])
	#RenderManager.setMode(robj_iplane, :POLYGONMODE, [:FRONT_AND_BACK,:FILL])

	println("Reload Models...")
	model_loaded_cube = ModelManager.create(:cube)
	model_loaded_monkey = ModelManager.create(:monkey)
	model_loaded_bannana = ModelManager.create(:bannana)
	
	model_iplane = ModelManager.create(:iplane)
	model_plane = ModelManager.create(:plane)
	model_cube = ModelManager.create(:cube)
	model_icosphere = ModelManager.create(:icosphere)
	
	global planeModel = model_plane
	global cubeModel = model_cube
	
	robj_loaded_cube.model = model_loaded_cube
	robj_loaded_monkey.model = model_loaded_monkey
	robj_loaded_bannana.model = model_loaded_bannana
	
	robj_iplane.model = model_iplane
	robj_plane.model = model_plane
	robj_cube.model = model_cube
	robj_cube_sphere.model = model_cube
	robj_icosphere.model = model_icosphere
	
	robj_fg.model=model_iplane
	robj_bg.model=model_iplane
	
	model_loaded_cube.source.path = "models/box.obj"
	model_loaded_monkey.source.path = "models/suzanne.obj"
	model_loaded_bannana.source.path = "models/Bananne_Mario.obj"

	print("MODEL LOADED CUBE: "); @time ModelManager.addMesh(model_loaded_cube, :MODEL)
	print("MODEL LOADED MONKEY: "); @time ModelManager.addMesh(model_loaded_monkey, :MODEL)
	print("MODEL LOADED BANNANA: "); @time ModelManager.addMesh(model_loaded_bannana, :MODEL)
	
	print("MODEL IPLANE: "); @time ModelManager.addMesh(model_iplane, :IPLANE)
	print("MODEL PLANE: "); @time ModelManager.addMesh(model_plane, :PLANE)
	print("MODEL CUBE: "); @time ModelManager.addMesh(model_cube, :CUBE2)
	print("MODEL ICOSPHERE: "); @time ModelManager.addMesh(model_icosphere, :ICOSPHERE)
	
	println("Reload Textures...")
	RenderManager.addTexture(robj_loaded_cube,"textures/square.png")
	textures_cube = robj_loaded_cube.textures
	
	println("Reload Cameras...")
	camera_fps = CameraManager.create(:FPS)
	camera_bg = CameraManager.create(:BG)
	
	global fpsCam = camera_fps
	
	robj_loaded_cube.camera = camera_fps
	robj_loaded_monkey.camera = camera_fps
	robj_loaded_bannana.camera = camera_fps
	
	robj_iplane.camera = camera_fps
	robj_plane.camera = camera_fps
	robj_cube.camera = camera_fps
	robj_cube_sphere.camera = camera_fps
	robj_icosphere.camera = camera_fps
	
	robj_fg.camera=camera_bg
	robj_bg.camera=camera_bg

	println("Reload Transformations...")
	robj_fg.transform.scaling = Vec3f(0.25,0.25,1)
	robj_fg.transform.position = Vec3f(0.75,0.75,-1)
	robj_bg.transform.position = Vec3f(0,0,-1)
	
	robj_cube.transform.position = Vec3f(-3,2,-5)
	robj_loaded_monkey.transform.position = Vec3f(0,2,-5)
	robj_loaded_bannana.transform.position = Vec3f(3,2,-5)

	robj_loaded_cube.transform.position = Vec3f(-3,5,-5)
	robj_loaded_cube.transform.rotation = Vec3f(0,0,0)
	
	robj_cube_sphere.transform.position = Vec3f(0,0,-3)
	robj_cube_sphere.transform.rotation = Vec3f(0,0,-3)

	robj_plane.transform.rotation = Vec3f(0,-pi*0.5,0)
	robj_plane.transform.position = Vec3f(0,-2,-5)
	robj_plane.transform.scaling = Vec3f(10,10,1)

	robj_iplane.transform.position = Vec3f(-3,0,-3)
	robj_icosphere.transform.position = Vec3f(3,0,-3)

	# cam
	#camera_fps.transform.position = Vec3f(0,0,-2)
	#camera_fps.transform.rotation = Vec3f(0,0,0) #deg2rad(180)

	CameraManager.setPerspective(camera_fps, 60.0f0, Float32(windowsize[1]/windowsize[2]), 0.001f0, 10000.0f0)
	CameraManager.setPerspective(camera_bg, 53.0f0, 1.0f0, 0.001f0, 100.0f0)

	# enable/disable for rendering
	robj_fg.enabled=true
	robj_bg.enabled=true
	
	#robj_iplane.enabled=false
	#robj_icosphere.enabled=false
	#robj_plane.enabled=false
	#robj_cube.enabled=false

	# transparency order
	RenderManager.renderSortedList(true)
	#robj_model.order=Symbol("-")
	robj_bg.order=Symbol("0")
	robj_cube_sphere.order=Symbol("1")
	robj_plane.order=Symbol("1")
	robj_iplane.order=Symbol("T")
	robj_icosphere.order=Symbol("1")
	robj_cube.order=Symbol("1")
	robj_loaded_cube.order=Symbol("1")
	robj_fg.order=Symbol("Z")
	
	println("Generate Cubes...")
	max=4
	for z=1:max
		for y=1:max
			for x=1:max
				o=RenderManager.create(Symbol(:CUBE,x+(y-1)*max+(z-1)*max*max))
				o.enabled=false
				#RenderManager.register(o,true,false)
				o.model=model_cube
				o.shaderProgram=shader_texture
				o.textures = textures_cube
				o.camera=camera_fps
				o.transform.position = Vec3f(x*2-max,y*2,z*2)
			end
		end
	end
	
	global SPOTLIGHT.color = Vec4f(1,0,0,1)
end

function OnReload()
	global WINDOW=this.objref.WINDOW
	global windowsize = Vec2f(WINDOW.size[1],WINDOW.size[2])

	setProgramTick(SCRIPTTICK)
end

function OnInit()
	FILE = Base.@__FILE__
  println("Script: $(basename(FILE)), $(this.args), time: $(mtime(FILE))")
end
