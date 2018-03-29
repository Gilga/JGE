module TimeManager

export currentTime
export programTime
export programTimeStr
export programStartTime
export OnTime

now() = Dates.time()
programStartTime = now()

currentTime(startTime::Real) = (now() - startTime)
programTime() = currentTime(programStartTime)
programTimeStr() = @sprintf("%.3f", programTime())

function OnTime(milisec::Float64, prevTime::Base.RefValue{Float64})
	time=now()
	r=(time - Base.getindex(prevTime)) >= milisec
	if r Base.setindex!(prevTime, time) end
	r
end

#Dates.millisecond(Dates.unix2datetime(Dates.time()))

end
