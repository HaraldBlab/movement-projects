/*
 * motor_functions.h - Obstacle detetcion functions
 * extracted from RobitCarKit obstacleAvoid sample.
 * 
 * 4WD car with Adafruit Motor Shield V1 (V2?)
 */

// vehicle using motors
int Car_state = 0;           //the working state of car

#include <AFMotor.h> 

// TODO: name the motors as front/rear/left/right
AF_DCMotor motor1(1, MOTOR12_64KHZ);
AF_DCMotor motor2(2, MOTOR12_64KHZ);
AF_DCMotor motor3(3, MOTOR12_64KHZ);
AF_DCMotor motor4(4, MOTOR12_64KHZ);

unsigned char Lpwm_val = 120;
unsigned char Rpwm_val = 120;

void M_Control_IO_config(void) {
}

void Set_Speed(unsigned char Left, unsigned char Right) {

  motor1.setSpeed(Right);
  motor2.setSpeed(Left);
  motor3.setSpeed(Left);
  motor4.setSpeed(Right);
}

void advance() {
  motor1.run(FORWARD);       
  motor2.run(FORWARD);       
  motor3.run(FORWARD);       
  motor4.run(FORWARD);         
  Car_state = 2;
}

void back() {
  motor1.run(BACKWARD);       
  motor2.run(BACKWARD);       
  motor3.run(BACKWARD);       
  motor4.run(BACKWARD);         
  Car_state = 1;
}

void turnR() {
  motor1.run(FORWARD);       
  motor2.run(RELEASE);       
  motor3.run(RELEASE);       
  motor4.run(FORWARD);         
  Car_state = 4;
}

void turnL() {
  motor1.run(RELEASE);       
  motor2.run(FORWARD);       
  motor3.run(FORWARD);       
  motor4.run(RELEASE);         
  Car_state = 3;
}

void stopp() {
  motor1.run(RELEASE);       
  motor2.run(RELEASE);       
  motor3.run(RELEASE);       
  motor4.run(RELEASE);         
  Car_state = 5;
}
