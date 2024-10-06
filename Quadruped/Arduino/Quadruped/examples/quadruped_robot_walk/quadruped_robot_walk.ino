/*
 * quadruped_walk.h - sample to walk forward
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

/*
 * https://vhdlwhiz.com/rc-servo-controller-using-pwm/
 * The ideal interval between pulses is 20 ms, although it’s duration is of less importance. 
 * The 20 ms translates into a PWM frequency of 50 Hz. 
 * This means that the servo gets a new position command every 20 ms.
 * 
 * When a pulse arrives at the RC servo, it samples the duration of the high period. 
 * The timing is crucial because this interval translates directly to an angular position on the servo. 
 * Most servos expect to see a pulse width varying between 1 and 2 ms, but there is no set rule.
 * 
 * TAKE AWAYS
 * every new command in (about) 20 ms
 * only pulse width variation between 1ms (0 deg) and 2ms (180 deg) are expected.
 * 
 * PWN controller allows 4096 different values (for 20 ms)
 * pulse values for 1 ms to 2 ms allows 4096 / 10 different values
 * min and max values to be determined for each servo
 * (minimum) delay between 2 commands is 20 ms
 */
Adafruit_PWMServoDriver servoDriver_module = Adafruit_PWMServoDriver();         // Implementation of an object of module PCA9685.

int movement_speed = 150; // [ms] // 50   // Variable to use between the movements of the Servo Motors.

#include <quadruped_move.h>
#include <quadruped_home.h>
#include <quadruped_walk.h>

void setup() {
  //Serial.begin(115200);
  servoDriver_module.begin();         // Initialization of the PCA9685 module.
  servoDriver_module.setPWMFreq(50);  // Analog servos run at ~50 Hz updates.
  home();
  delay(3000);
}

void loop() {
  walk(movement_speed);
}
