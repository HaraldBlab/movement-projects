#include <AFMotor.h> 

// TODO: name the motors as front/rear/left/right
AF_DCMotor motor1(1, MOTOR12_64KHZ);
AF_DCMotor motor2(2, MOTOR12_64KHZ);
AF_DCMotor motor3(3, MOTOR12_64KHZ);
AF_DCMotor motor4(4, MOTOR12_64KHZ);

unsigned char Lpwm_val = 255;
unsigned char Rpwm_val = 255;

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
}

void back() {
  motor1.run(BACKWARD);       
  motor2.run(BACKWARD);       
  motor3.run(BACKWARD);       
  motor4.run(BACKWARD);         
}

void turnR() {
  motor1.run(FORWARD);       
  motor2.run(RELEASE);       
  motor3.run(RELEASE);       
  motor4.run(FORWARD);         
}

void turnL() {
  motor1.run(RELEASE);       
  motor2.run(FORWARD);       
  motor3.run(FORWARD);       
  motor4.run(RELEASE);         
}

void stopp() {
  motor1.run(RELEASE);       
  motor2.run(RELEASE);       
  motor3.run(RELEASE);       
  motor4.run(RELEASE);         
}

#define MOVE_STEP 0         /* perform the command some time */
#define MOVE_CONTINOUSLY 1  /* perform command until stopp */
int mode = MOVE_STEP;
void do_step(unsigned long ms) { if (mode == MOVE_STEP) { delay(ms); stopp(); } else delay(10); }
