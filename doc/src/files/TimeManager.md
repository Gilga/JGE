# [TimeManager.jl](@id TimeManager.jl)

```
now() = Dates.time()
```

```
programStartTime = now()
```

```
currentTime(startTime::Real)
```

```
programTime()
```

```
programTimeStr()
```

```
function OnTime(milisec::Float64, prevTime::Base.RefValue{Float64})
	time=now()
	r=(time - Base.getindex(prevTime)) >= milisec
	if r Base.setindex!(prevTime, time) end
	r
end
```
