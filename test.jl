version=""
	
if length(ARGS) > 0 && ARGS[1] != ""
	index=0
	println("params:")
	for x in ARGS; @printf("%s%s",index>0 ? ", " : "", x); index+=1 end
	println()
	version=replace(ARGS[1],r"[.][0-9]+$","")
else
	println("No Parameters given.")
end

include(string("source/$version/main.jl"))
main()
