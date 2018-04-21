module TimeManager

export currentTime
export programTime
export programTimeStr
export programStartTime
export OnTime

"""
TODO
"""
now() = Dates.time()

"""
TODO
"""
programStartTime = now()

"""
TODO
"""
currentTime(startTime::Real) = (now() - startTime)

"""
TODO
"""
programTime() = currentTime(programStartTime)

"""
TODO
"""
programTimeStr() = @sprintf("%.3f", programTime())

"""
TODO
"""
function OnTime(milisec::Float64, prevTime::Base.RefValue{Float64})
	time=now()
	r=(time - Base.getindex(prevTime)) >= milisec
	if r Base.setindex!(prevTime, time) end
	r
end

#Dates.millisecond(Dates.unix2datetime(Dates.time()))

end
