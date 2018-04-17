# JGE
Julia Grafik Engine

# Status
* Works with 0.6.0 (Compiling will work, but execution will fail, see [Status of BuildExecutable.jl](https://github.com/Gilga/BuildExecutable.jl#status))
* Works with 0.6.1
* Works with 0.6.2

# Requirements
## Packages
* Compat
* Images
* ImageMagick
* ModernGL
* GLFW
* Quaternions
* StaticArrays (used by Images)
* WinRPM (used by ImageMagick)

# Compiling
see [Compiling with BuildExecutable.jl](https://github.com/Gilga/BuildExecutable.jl#compiling)

# Run
## Windows
* Operating System: Windows 10 Home 64-bit (10.0, Build 16299) (16299.rs3_release.170928-1534)
* Processor: Intel(R) Core(TM) i7-4510U CPU @ 2.00GHz (4 CPUs), ~2.0GHz
* Memory: 8192MB RAM
* Graphics Card 1: Intel(R) HD Graphics Family
* Graphics Card 2: NVIDIA GeForce 840M

# Program Control

| Key   | Command/Description
|:-----:| :---
|  F1   | Fullscreen (Enable/Disable) 
|  F2   | Wireframe (Enable/Disable)     
| WASD  | Move Camera (Forward,Left,Back,Right,Up,Down)
|Space  | Move Camera (Up)
|Ctrl/c | Move Camera (Down)
| HMK   | Hold any mouse key to rotate view
