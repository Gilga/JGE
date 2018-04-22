# [JLScriptManager.jl](@id JLScriptManager.jl)

using CoreExtended
using FileManager.FileSource

```
abstract type JLComponent <: AbstractObjectReference end
```

```
type JLInvalidComponent <: JLComponent end

const JL_INVALID_COMPONENT = JLInvalidComponent()
```

```
type JLStateListComponent <: JLComponent
	isInitalized	::Bool
	isRunning			::Bool
	isTerminated	::Bool
	
	JLStateListComponent() = new(false,false,false)
end

export JLScriptFunction
```

```
type JLScriptFunction
	func::Function
	JLScriptFunction(f::Function) = new(stabilize(f))
end

export JLScript
```

```
type JLScript
  id        ::Symbol
	mod				::Module
  source    ::FileSource
	
	args			::Tuple # arguments passed on main()
  cache			::Dict{Symbol, Any}
  listener	::Dict{Symbol, Function}
	extern		::Dict{Symbol, Function}
	state			::JLComponent
	objref		::JLComponent
	funcs			::JLComponent
	events		::JLComponent
end
```

```
JLScript(id::Symbol) = JLScript(id,FileSource())
```

```
function JLScript(id::Symbol, source::FileSource)
  this=JLScript(id,Module(id),source,(),Dict(),Dict(),Dict(),JLStateListComponent(),JL_INVALID_COMPONENT,JL_INVALID_COMPONENT,JL_INVALID_COMPONENT)
  JLSCRIPTS[id]=this
  this
end

JLSCRIPTS = Dict{Symbol,JLScript}()
```

```
loop(f::Function) = for (k,s) in JLSCRIPTS f(s) end
```

```
listen(this::JLScript, k::Symbol, f::Function) = (this.listener[k]=f)
```

```
function run(this::JLScript, args...)
	debug("run $(this.id)")
	#Module(:__anon__)
	result = execute(this)
	if !result[1] result = nothing
	else result = result[2]
	end
  result
end
```

```
(this::JLScript)(s::Symbol, args...) = CoreExtended.execute(this.mod,s,args...) #@eval $f($args...)
```

```
exists(this::JLScript, s::Symbol) = CoreExtended.exists(this.mod,s)
```

```
function execute(this::JLScript, compile_args=[], args...)
  debug("execute $(this.id)")
	result = compile(this, compile_args...)
	if result[1] result = (true, execute(result[2], args...)) end
	result
end
```

```
execute(f::JLScriptFunction, args...) = (debug("execute function("*string(args...)*")"); f.func(args...))
```

```
function compile(this::JLScript, args...)
	debug("compile $(this.id)")
	result = (false, nothing)
	
	catchException(function()
		#if length(args)>0
			result = eval(this, args...)
		#else
		#	result = evalfile(this.source.path)
		#end
		
		if isa(result, Function) result = JLScriptFunction(result)
		else warn("Main Function not found.")
		end

		result = (true, result)
	end)
	
	result
end
```

```
function cleanCode(code::String)
	
	# problem using match(): only "function (name)" will be detected!
	# for x in eachmatch(r"function \s(\w)", code) println(x.captures[1]) end

	# TODO merge code lines
	code=Base.replace(code, "\r", "")
	#code=Base.replace(code, r"\#\=(?(?=\=\#)then|else)*\=\#", "")
	code=Base.replace(code, r"(?s)(?<=\#\=)(.*?)(?=\=\#)", "")
	code=Base.replace(code, r"(\#[^\n]+)", "")
	code=Base.replace(code, r"\n\s+\n", "\n")
	code=Base.replace(code, r"\n+", "\n")
	code=Base.replace(code, r"\s*(,)\s*", s"\1")
	code=Base.replace(code, r"(\()\s*", s"\1")
	code=Base.replace(code, r"\s*(\))", s"\1")
	code=Base.replace(code, r"\n", ";")
end
```

```
function eval(this::JLScript, args...)
	
	this.mod = Module(this.id) #reset modul

	debug("eval $(this.id)")
	
	# parse
	#################################################
	
	code = ""
	open(this.source.path) do f	code = readstring(f) end
	code=cleanCode(code)
	code=parse(code)
	
	#################################################
	
	funcs = ""
	funcsext = "" #"_(x) = (args...)->execute(x,args...);"
	
	xTypBody = ""
	xTypCall = ""
	fTypBody = ""
	fTypCall = ""
	eTypBody = ""
	eTypCall = ""
	
	def = (name) -> "$name::Function;"
	dec = (name) -> "(args...)->execute($name,args...)"
	
	for (name,f) in this.extern
		funcsext *= "global $name = this.extern[:$name];"
		#xTypBody *= def(name)
		#xTypCall *= (xTypCall != "" ? "," : "") * dec(name)
	end
	
	#################################################
	
	for x in code.args
		if x.head == Symbol("function")
			name=Symbol(Base.replace(string(x.args[1]), r"\(.*", ""))

			if ismatch(r"^On\w+", string(name))
				# event functions
				eTypBody *= def(name)
				eTypCall *= (eTypCall != "" ? "," : "") * dec(name)
			else
				# other functions
				fTypBody *= def(name)
				fTypCall *= (fTypCall != "" ? "," : "") * dec(name)
			end

		end
	end
	
	#################################################
	
	imports = ""
	imports *= "using CoreExtended;"
	imports *= "using JLScriptManager;"
	
	typs = ""
	typ = string(this.mod) #*"_JLFunctionListComponent"
	#if createExtFuncList typs *= "type "*typ*"_EXTFUNCTIONS <: JLComponent;"*xTypBody*";end;" end
	typs *= "type "*typ*"_FUNCTIONS <: JLComponent;"*fTypBody*";end;"
	typs *= "type "*typ*"_EVENTS <: JLComponent;"*eTypBody*";end;"
	
	mainFunc = "function main(args...);"
	mainFunc *= "this.args=args;"
	mainFunc *= funcsext
	#if createExtFuncList mainFunc *= "this.extfuncs = "*typ*"_EXTFUNCTIONS("*xTypCall*");" end
	mainFunc *= "this.funcs = "*typ*"_FUNCTIONS("*fTypCall*");"
	mainFunc *= "this.events = "*typ*"_EVENTS("*eTypCall*");"
	mainFunc *= "end;"
	
	#################################################

	ex=Expr(:toplevel,
		:(const ARGS = $(this.args)),
		:(eval(x) = Main.Core.eval($(this.mod),x)),
		#:(eval(m,x) = Main.Core.eval(m,x)),
		:(this=$this),
		args...,
		:(Main.Base.include($(this.source.path))), #which is faster?
		#code, #which is faster?
		parse(imports*typs*funcs*mainFunc),
	)
	
	#################################################
	
	#println("EXTFUNCS:\n", Base.replace(extfuncs, ",(", "\n("),"\n")
	#println("FUNCS: ", fTypBody)
	#println("EVENTS: ", eTypBody)
	#dump(ex)
	
	#################################################
	
	eval(this.mod, ex)
end
```
