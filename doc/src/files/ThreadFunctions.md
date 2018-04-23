# [ThreadFunctions.jl](@id ThreadFunctions.jl)

```
thread_println(t::ThreadManager.Thread, msg) = ThreadManager.safe_call(t, (x) -> print(msg))
```

```
thread_push(t::ThreadManager.Thread, a, e) = ThreadManager.safe_call(t, (x) -> push!(a, e))
```

```
thread_sleep(sec::Real) = Libc.systemsleep(sec)
```

```
thread_init(p::Tuple{String,Function}) = function(t::ThreadManager.Thread)
	thread_println(t, LogManager.logMsg(:Debug, p[1], "start"))
	p[2](t)
end
```