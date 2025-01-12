/*
 * quadruped_robot_pass.ino - sample for pass animal gait
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
#include <quadruped_pass.h>

void setup() {

#ifdef USE_SERIAL
  Serial.begin(115200);
#endif
  servoDriver_module.begin();
  servoDriver_module.setPWMFreq(50);
  home(); 
  delay(1000);
}

void demo_pass() {
  /* pass gaits */
  delay(1000);
  delay(1000);
  home();
}
#define PASS_LEFT
void loop() {
  int pass_speed = 250; // [ms]
#ifdef PASS_LEFT
  pass_left(pass_speed);
#else
  pass_right(pass_speed);
#endif
}
