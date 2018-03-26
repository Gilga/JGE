channel = RemoteChannel()

function asynccall(f)
	@async begin
	put!(channel, true)
	f()
	take!(channel)
	end
end