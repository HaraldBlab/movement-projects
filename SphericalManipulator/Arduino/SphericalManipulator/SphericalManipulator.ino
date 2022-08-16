/*
 * SphericalManipulator.ino
 * Written by plusAlpha Designs
 * Initial Revision, published November 3, 2019.
 * This code is provided to supplement Spherical Parallel Manipulator model
 * on Thingiverse (https://www.thingiverse.com/thing:3951917). This is intended
 * to ne a demo code to get the model up and running. 
 * 
 * Distributed under the Creative Commons  Attribution - Non-Commercial - 
 * Share Alike license.
 * 
 * Simply connect the PWM pins of the 3 servo-motors to Pins 11, 12, and 13 of
 * your Arduino Uno. Appropriately connect the Power and Ground Pins of the 
 * Servo-motor (The Arduino itself may lack the power to drive all 3 motors 
 * at once - see what it takes to drive them).
 * 
 */

#include <Servo.h>

Servo servo1;
Servo servo2;
Servo servo3;

void setup() 
{
  servo1.attach(11);
  servo2.attach(12);
  servo3.attach(13);
  
  pinMode(7, INPUT);

  servo1.write(90);
  servo2.write(90);
  servo3.write(90);

}

//Calibrate Mode
//The Gear Stack Should be assembled when the servo-motors are in
//the 90 deg position
void CalibrateMode() {
  servo1.write(90);
  servo2.write(90);
  servo3.write(90);
  delay(2000); 
}

//Toggle Servo1 only
void ToggleServo1() {
  for(int j = 0; j<3; j++)
  {
    for(int i = 90; i<140; i+=1)
    {
      servo1.write(i);
      delay(20);
    }
  
    for(int i = 140; i>40; i-=1)
    {
      servo1.write(i);
      delay(20);
    }
  
    for(int i = 40; i<90; i+=1)
    {
      servo1.write(i);
      delay(20);
    }  
  }

  servo1.write(90);
}

//Toggle Servo2 only
void ToggleServo2() {
  for(int j = 0; j<3; j++)
  {
    for(int i = 90; i<140; i+=1)
    {
      servo2.write(i);
      delay(20);
    }
  
    for(int i = 140; i>40; i-=1)
    {
      servo2.write(i);
      delay(20);
    }
  
    for(int i = 40; i<90; i+=1)
    {
      servo2.write(i);
      delay(20);
    }  
  }

  servo2.write(90);
}

//Toggle Servo3 only
void ToggleServo3() {
  for(int j = 0; j<3; j++)
  {
    for(int i = 90; i<140; i+=1)
    {
      servo3.write(i);
      delay(20);
    }
  
    for(int i = 140; i>40; i-=1)
    {
      servo3.write(i);
      delay(20);
    }
  
    for(int i = 40; i<90; i+=1)
    {
      servo3.write(i);
      delay(20);
    }  
  }

  servo3.write(90);
}

//Rotate Stage
void RotateStage() {
  for(int j = 0; j<3; j++)
  {
    for(int i = 90; i<160; i+=1)
    {
      servo1.write(i);
      servo2.write(i);
      servo3.write(i);
      delay(20);
    }
  
    for(int i = 160; i>20; i-=1)
    {
      servo1.write(i);
      servo2.write(i);
      servo3.write(i);
      delay(20);
    }
  
    for(int i = 20; i<90; i+=1)
    {
      servo1.write(i);
      servo2.write(i);
      servo3.write(i);
      delay(20);
    }  
  }
}

//Circle at an angle
void CircleAtAnAngle() {
  double angle = 0;
  double servoAngle1 = 0;
  double servoAngle2 = 0;
  double servoAngle3 = 0;
  
  for(int i = 0; i<1000; i++)
  {
    angle = ((double)i)/24;
    servoAngle1 = 90+ 30*sin(angle);
    servoAngle2 = 90+ 30*sin(angle + 2* PI/3);
    servoAngle3 = 90+ 30*sin(angle + 4*PI/3);
    servo1.write(servoAngle1);
    servo2.write(servoAngle2);
    servo3.write(servoAngle3);
    delay(20);
  }
  
}

// Quick move
void QuickMove() {
  servo1.write(90);
  servo2.write(90);
  servo3.write(90);

  delay(500);
  servo2.write(60);
  delay(400);
  servo3.write(120);
  delay(400);
  servo1.write(75);
  delay(400);
  servo3.write(105);
  delay(400);
  servo1.write(110);
  delay(400);
  servo2.write(75);
  delay(400);
  servo3.write(65);
  delay(400);
  servo1.write(90);
  delay(400);
  servo3.write(115);
  delay(400);
  servo2.write(120);
  delay(400);
  servo1.write(60);
  delay(400);
}

//random move
void RandomMove() {
  servo1.write(90);
  servo2.write(90);
  servo3.write(90);

  for(int j = 0; j<10; j++)
  {
    servo1.write((int)random(50,130));    
    servo2.write((int)random(50,130));    
    servo3.write((int)random(50,130));
    delay(600);    
  }  
}

void loop() {
/*
  CalibrateMode();
 */
  ToggleServo1();
  ToggleServo2();
  ToggleServo3();

  RotateStage();
  CircleAtAnAngle();
  QuickMove();
  RandomMove();
 
}
