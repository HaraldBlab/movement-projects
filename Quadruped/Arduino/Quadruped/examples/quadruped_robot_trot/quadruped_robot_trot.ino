/*
 * quadruped_trot.ino - sample for trot animal gait
 * 
 * Based on:
 * Project for the construction of a Quadruped Robot.
 * Miguel Torres Gordo
 * Getafe (Madrid) - ESPAÑA          Last revision 22-09-2023
 * 
 * Board: Arduino Uno
 * Port: COM5
 */

#include <Wire.h>
#include <Adafruit_PWMServoDriver.h>

Adafruit_PWMServoDriver servoDriver_module = Adafruit_PWMServoDriver();

#include <quadruped_move.h>
#include <quadruped_home.h>
#include <quadruped_walk.h>
#include <quadruped_body.h>
#include <quadruped_legs.h>
#include <quadruped_trot.h>

void setup() {

#ifdef USE_SERIAL
  Serial.begin(115200);
#endif
  servoDriver_module.begin();
  servoDriver_module.setPWMFreq(50);
  home(); 
  delay(1000);
}

void loop() {
  int troit_speed = 100; // [ms]
  trot(troit_speed);  
}
