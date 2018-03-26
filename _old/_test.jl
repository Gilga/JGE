function compile(file::String, debug=false)
	result = nothing
	try
		result = evalfile(file)
		if debug println("file compiled.") end
	catch err
		println("Cannot compile file. There was an error: ", err)
	end
	return result
end

function main()
	if length(ARGS) > 0 && ARGS[1] != ""
		index=0
		println("params:")
		for x in ARGS; @printf("%s%s",index>0 ? ", " : "", x); index+=1; end
		println()
	else
		println("No Parameters given.")
		compile("test2.jl")
	end
	println("Hit 2x enter key to exit program.")
	read(STDIN, Char)
	#exit()
end
