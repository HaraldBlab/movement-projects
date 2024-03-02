/*
 * based on: https://create.arduino.cc/projecthub/electropeak/arduino-l293d-motor-driver-shield-tutorial-c1ac9b
 * Driving DC Motor
 * 
 * IRcontrolled - IR controlled 4WD car with Adafruit Motor Shield V1 (V2?)
 * Skeleton from RobotCarKit (IRcontrolled)
 * 
 * Use this with (https://www.xiaorgeek.net/products/xiaor-geek-4wd-robot-chassis-kit-with-4-tt-motor-for-arduino-raspberry-pi)
 * Board: Arduino Uno
 * Port: COM9 (Arduino Uno)
 * 
 * TODOs:
 * TODO: find out why the IRremote library always uses the hardware timers (V 4.2.0)
 * TODO: name the motors as front/rear/left/right
 *
 */

#define IR_OPERATION 0  /* 0=Black,1=DominatorController */
#if ((!defined(IR_OPERATION) || (defined(IR_OPERATION) && IR_OPERATION==0)))
  #define IR_OPERATION_BLACK 1
#elif (defined(IR_OPERATION) && IR_OPERATION==1)
  #define IR_OPERATION_DOMINATOR 1
#else
  #define IR_OPERATION_BLACK 1
#endif

#include "commands.h"
#if defined(IR_OPERATION_BLACK)
#include "Black_IRcontrol.h"
#elif defined(IR_OPERATION_DOMINATOR)
#include "DominatorController_IRcontrol.h"
#endif
#include "functions.h"

uint8_t speed_left;
uint8_t speed_right;
uint8_t speed_step = 5;
uint8_t speed_min = 195;
uint8_t speed_max = 255;

void set_speed(uint8_t left, uint8_t right) {
  speed_left = left;
  speed_right = right;
  Set_Speed(speed_left, speed_right);
  Serial.println(speed_left,DEC);
  Serial.println(speed_right,DEC);
}
uint8_t incr_speed(uint8_t speed) {
  return min(speed+speed_step, 255); 
}
uint8_t decr_speed(uint8_t speed) {
  if (speed > speed_step)
    return max(speed-speed_step, 0); // speed-speed_step
  else
    return 0;  
}
/* execute a command received by the controller */
int do_command(int command) {
  switch (command) {
    case COMMAND_ADVANCE:
      advance();
      do_step(1000);
      break;
    case COMMAND_BACK:
      back();
      do_step(1000);
      break;
    case COMMAND_TURNLEFT:
      turnL();
      do_step(250);
      break;
    case COMMAND_TURNRIGHT:
      turnR();
      do_step(250);
      break;
    case COMMAND_STOPP:
      stopp(); 
      break;
    case COMMAND_CONTINUOUSLY:
      mode = MOVE_CONTINOUSLY;
      break;
    case COMMAND_SINGLESTEP:
      mode = MOVE_STEP;
      break;
    case COMMAND_ACCELERATE:
      set_speed(incr_speed(speed_left), incr_speed(speed_right));
      break;
    case COMMAND_DECELARATE:
      set_speed(decr_speed(speed_left), decr_speed(speed_right));
      break;
    case COMMAND_MAXSPEED:
      set_speed(speed_max, speed_max);
      break;
    default:
      break;
  }
  return command;
}

void setup() {
  Serial.begin(115200);
  
  M_Control_IO_config();
  set_speed(Lpwm_val, Rpwm_val);

  // Start the receiver, take LED_BUILTIN pin from the internal boards definition as default feedback LED
  IrReceiver.begin(IR_RECEIVE_PIN, ENABLE_LED_FEEDBACK);

  stopp();
}

void IR_Ignore(unsigned long endTime) {
  unsigned long currentTime = millis();
  while (currentTime < endTime) {
    if (IrReceiver.decode()) {
      delay(10);
      IrReceiver.resume();  // Receive the next value
    }
    currentTime = millis();
  }
}

int IR_Control_Timed(unsigned long window) {
  unsigned long startTime = millis();
  int command = IR_Control();
  unsigned long endTime = millis();
  delay(IR_Control_Gap); // delay for the IR control
  // if multiple valid commands come within time window just ignore them
  if (command != COMMAND_NONE)
    IR_Ignore(millis()+window-(endTime-startTime)-IR_Control_Gap);
   return command;
}

void loop() {
  do_command(IR_Control_Timed(250));
}
