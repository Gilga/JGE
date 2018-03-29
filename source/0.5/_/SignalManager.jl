module SignalManager

export Signal
export sleep
export fpswhen
export smap

Signals = []

type Signal
  parents::Any
  func::Function
  params::Vector
  Signal(parents=[], f=()->nothing, params=[]) = new(parents, f, params)
end

# function callSignal(s::Signal)
  # result = (false,nothing)
  # if s != nothing
    # s_result = true
    # p = s.parents
    # if (isa(p,AbstractArray) && length(p) > 0) || isa(p,Tuple) p = p[1] end
    # if typeof(p) == Signal && p != nothing
      # s_result = false
      # p_result = callSignal(p)
      # if isa(p_result,Tuple{Bool,Any}) s_result = p_result[1] end
    # end
    # if s_result && s.func != nothing
        # f_result = s.func(s.params...)
        # if isa(f_result,Tuple{Bool,Any})
          # if f_result[1] && f_result[2] != nothing && isa(s.params,AbstractArray) && length(s.params) > 0 s.params[1] = f_result[2] end
          # result = f_result
        # end
    # end
  # end
  # result
# end

smap(f::Function, v0, inputs...; typ=typeof(v0)) = push!(Signals, Signal(v0, f, [inputs...]))

function fpswhen(s, rate)
  current = s.parents[1]
  s.params = [current, rate]
  s.func = (current, rate) -> (
    time = Dates.time();
    result=((time - current) >= rate);
    if result s.params[1] = time end;
    (result, nothing)
  )
  s
end

update() = map(Signals) do s end

sleep = update
yield = update

end
