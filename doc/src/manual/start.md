# [Start](@id start)

* [Design Pattern](#Design-Pattern-1)
* [Szene](#Szene-1)
* [Script Manager](#Script-Manager-1)

## Design Pattern
The Graphics Engine holds manages many objects like Shader, Camera, Mesh, Texture, etc.
For each object an Manager Module exists for organisation and optimization.
Manager Modules should hold more or less same structure. This structure can be given by a prototype.

Design Pattern like Object Inhertance can be done with component-based design.
Julia design is mostly modul and function based. Normally this design is sufficient enough for small projects but
for bigger project like this graphics engine project we have to rethink how to design our project without
the use of design pattern like OOP in Java.

This Graphics Engine project is still experimental. I did'nt found the ideal design structure for all cases yet.
Some of my implementations are not the best solutions so there is still a room for improvement.

The main problem lies in performance. We have to avoid performance restrictions through our design as best as we can.
I split this project into two because i wanted to drawn many objects with good performance.

My other project is called [JuliaOpenGL](https://github.com/Gilga/JuliaOpenGL). I created this to achieve good performance for this "render many blocks" issue.
In the future i want to merge this project into the graphics engine project.
I think thats the best way to improve large projects over time such as these without messing up your code to much.

## Szene
The Renderszene itself and its objects is managed by the [RenderManager.jl](@ref RenderManager.jl) which creates Render Objects
which holds all references to Transformations, Mesh datas, textures and more. Those objects are just reference containers with some optional opengl parameters.

## Script Manager
There is single szene called input.jl in scripts directory. Here you can move camera, create objects, sets properties and more.
The script will be loaded automatically when you saved the file. Everything will be rebuilt right from the start

Script will be managed by [JLScriptManager.jl](@ref JLScriptManager.jl).
This manager creates callbacks for events before compiling the script. You can get events on both ways from App to sctipt or other way round.
For Example OnKey() Event comes from the [WindowManager.jl](@ref WindowManager.jl) but will be defined in the script to catch the keyboard values.
We could define a custom function in a script which will be parsed and its reference will be saved to be accessible for the App.

This example calls event OnUpdate which represents the call from App to script.
```
script(:OnUpdate)
```

This example allows the function printSomething() to be called from the script. It represents the call from script to App.
```
list=Dict{Symbol,Function}(:printSomething = ()->println("Hey!"),...)
```
