# Light-Reflection-Simulator
Simulate light reflection between two parallel mirrors by changing angle, distance or refractive index (relative to source). 



Hello all, 

This is a **Processing** code for simulation of a light ray bouncing off between two parallel mirrors. This was a part of one of my college projects and I couldn't find an apt simulation for my purpose, so made this.

You can adjust the distance between mirrors, the angle at which light enters the space between mirrors, and the refractive index of the space between mirrors with respect to the source of light. All the distances are to scale.  

## Crux:  
The light ray orignates at the centre of the emitter ( blue rectangle ) towards downward direction. you can channge the angle by Left/Right arrow keys. You can only take the light ray to the vertice of the emitter, after which, the first mirror will start.

The refractive index of emitter material and of the space between mirrors can be different and the relative refractive index can be changed with +/-. Fractional relative index is also supported, i.e. index of emitter material is greater than that of space between mirrors. However, in this case, total internal reflection may occur beyond a particular combination of angle and refractive index. A message will be displayed when this occurs with the light ray docked at a default place.  

Thus the ray can refract at this interface of space between mirror and emitter. The refracted ray will contact with M2 (downwards mirror) first, then M1 (upward mirror) and then so on... The distance between the 2 mirrors can be changed by Up/Down arrow keys.  
Only the x coordinate of each point of relection is calculated, as the y coordinate is same as the y of the corresponding mirrors.  

Three variables are shown at the top-right- A, d and R which indicate - angle between emitter ray and interface, distance between the 2 mirrors and refractive index of space between mirrors with respect to emitter material.  
You can press R anytime to save a screenshot of the whole sketch display. The dated and screenshot will be saved in a subdirectory 'output' of the current directory.  


Key | Use  
------------ | -------------  
Up/Down    |  Move second(downward) mirrow up/down
Left/Right |  Move  (Rotate the source ray)  
+/-        |  Increase / Decrease refractive index  
R          |  Save screenshot  
\` (grave) |  Quit

I have commented most of the parts of the code, Do raise an issue or let me know (**hemanshu.kale@gmail.com**) in case of any random problems / bugs

Enjoy :)
