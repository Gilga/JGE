# [LoggerManager.jl](@id LoggerManager.jl)

## import
* [Base.print](https://docs.julialang.org/en/stable/stdlib/io-network/#Base.print)
* [Base.println](https://docs.julialang.org/en/stable/stdlib/io-network/#Base.println)
* [Base.warn](https://docs.julialang.org/en/stable/stdlib/io-network/#Base.warn)
* [Base.error](https://docs.julialang.org/en/stable/stdlib/io-network/#Base.error)

## export
* [LOGGER_OUT](#Files-1)
* [LOGGER_ERROR](#Files-1)
* [print](#Overwrite-1)
* [printf](#LoggerManager.@printf-Tuple)
* [println](#Overwrite-1)
* [info](#Overwrite-1)
* [warn](#Overwrite-1)
* [error](#Overwrite-1)

## using
* [Suppressor.jl](https://github.com/JuliaIO/Suppressor.jl)
* [TimeManager.jl](@ref TimeManager.jl)
* [CoreExtended.jl](@ref CoreExtended.jl)


```@docs
LoggerManager.logException(ex::Exception)
```

```@docs
LoggerManager.@printf(xs...)
```

## Files
```
LOGGER_OUT = "out.log"
LOGGER_ERROR = "error.log"
```

## Overwrite
```
@suppress begin print(xs...) = open(f -> (print(f, xs...); print(STDOUT, xs...)), LOGGER_OUT, "a+") end
@suppress begin println(xs...) = open(f -> (println(f, programTimeStr(), " ", xs...); println(STDOUT, xs...)), LOGGER_OUT, "a+") end
@suppress begin info(xs...) = open(f -> (info(f, programTimeStr(), " ", xs...); info(STDOUT, xs...)), LOGGER_OUT, "a+") end
@suppress begin error(xs...) = open(f -> (error(f, programTimeStr()," ", xs...); error(STDERR, xs...)), LOGGER_ERROR, "a+") end
@suppress begin warn(xs...) = open(f -> (warn(f, programTimeStr()," ", xs...); warn(STDERR, xs...)), LOGGER_ERROR, "a+") end
```
