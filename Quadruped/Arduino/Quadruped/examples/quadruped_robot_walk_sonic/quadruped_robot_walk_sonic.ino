/*
 * quadruped_robot_walk_sonic.ino - sample to walk forward
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
#include "obstacle_functions.h"

int walk_speed = 150; // [ms] // 50

void setup() {
#ifdef USE_SERIAL
  Serial.begin(115200);
#endif
  servoDriver_module.begin();
  servoDriver_module.setPWMFreq(50);
  home(); 
  O_Control_IO_config();
  delay(1000);
}

void loop() {
  if (H_distance() >= 30)
    walk(walk_speed);
  else
    home();
}
