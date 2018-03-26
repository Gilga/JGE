@echo off
set JULIA_NUM_THREADS = 4
set "version=%1"

if "%version%" == "" (
	set "version=0.6.1"
)

rem "C:/Users/%username%/AppData/Local/Julia-%version%/bin/julia.exe" "runtest.jl"
"C:/Users/%username%/AppData/Local/Julia-%version%/bin/julia.exe" "test.jl" "%version%"
pause