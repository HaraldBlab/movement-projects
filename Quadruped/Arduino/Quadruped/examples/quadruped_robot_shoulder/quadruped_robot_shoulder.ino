/*
 * Quadruped_robot_shoulder - sample project to perfrom shoulder movements with the quadruped robot
 * 
 * Based on:
 * Project for the construction of a Quadruped Robot.
 * Miguel Torres Gordo
 * Getafe (Madrid) - ESPAÑA          Last revision 22-09-2023
 * 
 * Board: Arduino Uno
 * Port: COM5
 */

#include <Wire.h>                                                               // Library for I2C communications.
#include <Adafruit_PWMServoDriver.h>                                            // PCA9685 Library.

Adafruit_PWMServoDriver servoDriver_module = Adafruit_PWMServoDriver();         // Implementation of an object of module PCA9685.

#include <quadruped_move.h>
#include <quadruped_home.h>
#include <quadruped_shoulder.h>

void setup() {
  //Serial.begin(9600);
  servoDriver_module.begin();                                               // Initialization of the PCA9685 module.
  servoDriver_module.setPWMFreq(50);                                        // Analog servos run at ~50 Hz updates.
  home();
  delay(1000);
}

void loop() {
  shoulder(1000);
}
