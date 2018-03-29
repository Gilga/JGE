module ThreadManager

export Thread

type Thread
	id::Integer
	mutex::Threads.Mutex
	Thread(id, m) = new(id, m)
end

Mutex = Threads.Mutex()
List = Thread[]

function safe_call(t::Thread, f::Function)
	Threads.lock(t.mutex)
	f(t)
	Threads.unlock(t.mutex)
end

function reset()
	global Mutex
	global List
	Mutex = Threads.Mutex()
	List = Thread[]
end

function run(a = Function[])
	reset()
	max=Threads.nthreads()
	i=0; Threads.@threads for f in a
		t=Thread(Threads.threadid(), Mutex)
		push!(List, t)
		f(t)
		if i >= max break end
		i+=1
  end
end

end # ThreadManager