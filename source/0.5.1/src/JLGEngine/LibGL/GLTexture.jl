using Images
#using ImageMagick
#using FileIO
#FileIO.read(file::readformats(ImageMagick.BACKEND)) = read(file, ImageMagick.BACKEND)

function CreateTexture(file::AbstractString)
	img = Images.load(file)
	sz = size(img)
	#imgFile = open(file,"r")
	#image.Decode(imgFile)
	#img2 = convert(GrayAlpha{UFixed8}, img)
	#set_packing_alignment(data)
#=
	rgba := image.NewRGBA(img.Bounds())
	if rgba.Stride != rgba.Rect.Size().X*4
		return 0, fmt.Errorf("unsupported stride")
	end
	draw.Draw(rgba, rgba.Bounds(), img, image.Point{0, 0}, draw.Src)
=#
	texture = GLuint[0];
	glGenTextures(1, texture); id = texture[1];
	glActiveTexture(GL_TEXTURE0)
	glBindTexture(GL_TEXTURE_2D, id)
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE)
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE)
	# glTexImage2D(
		# GL_TEXTURE_2D,
		# 0,
		# GL_RGBA,
		# sz[1], # width
		# sz[2], # height
		# 0,
		# GL_RGBA,
		# GL_UNSIGNED_BYTE,
		# pointer(img)
		# )

	return id
end
