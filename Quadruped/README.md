# Quadruped
A Quadruped robot with 12 servo motors on a PWM controller.
 

## Model
This is a rebuild of https://www.az-delivery.de/en/blogs/azdelivery-blog-fur-arduino-und-raspberry-pi/vierbeiniger-roboter-mit-pca9685-und-12-servomotoren

## Source code

### Arduino
Source code and samples as an Arduino library.
 
I translated the source code from writing PWM values directly to the controller to an object based implementation.
This allows me the move the elbow, humerus and scapula of each leg by method hiding the PWM signal details.
Running on Arduino UNO

### OpenSCAD
OpenSCAD files to print the model.

The model of this rebuild was originally designed with balsa wood.
I made it with 3D printed parts designed in OpenSCAD.
Out of curiosity I added posing to the model which allows me to make simple animations.

