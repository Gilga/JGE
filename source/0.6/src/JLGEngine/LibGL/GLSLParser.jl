function readShaders(program::AbstractGraphicsShaderProgram, fileSource::FileSource)
	if program == nothing end

	global shaderAttributes = []
	shaderSource=""
	globalSource=""
	lokalSource=""
	shaderType=nothing
	pbegin=0
	comment=false
	count=0

	#o.logShader.Info("Shader %s\n", path)
	
	clear(program)

	shaderCatch = function()
		pend=length(shaderSource)

		if shaderType != nothing
			f=FileSourcePart(fileSource,range(pbegin+1,pend-pbegin))
			f.cache = globalSource * lokalSource #f.source.cache[f.range]
			shader = createShader(program,shaderType,f)
			shader.cache="" #DEFAULT_SHADER_CODE(shaderType) #default
			lokalSource=""
			shaderType=nothing
		end

		pbegin = pend
		count+=1
		#o.logShader.Info("(%v,%v) %s\n", sourceBegin, sourceEnd, shader.GetSource())
	end

	readLines = function(file)
		for line in eachline(file)
			#line=replace(line, "\r", "") #remove windows extra break sign
			line=rstrip(lstrip(line)) #trim
			#line=filter(x -> !isspace(x), line)

			len = length(line)

			if len < 1 continue end

			firstSign = line[1]
			inputFmt = firstSign

			if len > 1 inputFmt = line[1:2] end

			if comment
				if inputFmt == "*/" comment = false end
				#continue
			#elseif firstSign == '\n'
				#continue
			elseif inputFmt == "/*"
				comment = true
				#continue
			elseif inputFmt == "//" # Comment
				#continue

				if len < 3 continue	end

				if line[3] == '!'
					ln = line[3:len]
					len = length(ln)

					if len < 2 continue	end

					sp = split(ln[2:len], " ")
					len = length(sp)
					cmd = ""
					value = ""

					if len < 1 continue end

					cmd = uppercase(lstrip(sp[1]))

					if len > 1
						value = uppercase(rstrip(sp[2]))

						if cmd == ""
							cmd = value
						end
					end

					#o.logShader.Info("(%s):\n", value)

					if cmd == value
						value=Symbol(value)
						if haskey(LIST_SHADER,value)
							shaderCatch()
							shaderType=value
						end
						#for (k, v) in SHADER_FILE_TYPE
						#	if v == value
						#		shaderCatch()
						#		shaderType=v
						#		break
						#	end
						#end
					end
				end
				#continue

			else
				findShaderProperty(program, line)
				if count == 0
					globalSource = string(globalSource,line,"\n")
				else
					lokalSource = string(lokalSource,line,"\n")
				end
				shaderSource = string(shaderSource,line,"\n")
			end
		end
		shaderCatch()
		fileSource.cache=shaderSource
		shaderSource != ""
	end

	FileManager.waitForFileReady(fileSource.path,readLines)
end

include("GLSLRessources.jl")
