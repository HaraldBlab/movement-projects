/*
 * Black_IRControl.h - remote IR control
 * 
 * Black IR controller delived with many electronic (starter) kits.
 * 
 * Footprint of IRremote
 * Sketch uses 9486 bytes (29%) of program storage space. Maximum is 32256 bytes.
 * Global variables use 736 bytes (35%) of dynamic memory, leaving 1312 bytes for local variables. Maximum is 2048 bytes.
 * #define EXCLUDE_EXOTIC_PROTOCOLS
 * Sketch uses 8714 bytes (27%) of program storage space. Maximum is 32256 bytes.
 * Global variables use 612 bytes (29%) of dynamic memory, leaving 1436 bytes for local variables. Maximum is 2048 bytes.
 * #define EXCLUDE_UNIVERSAL_PROTOCOLS
 * Sketch uses 7644 bytes (23%) of program storage space. Maximum is 32256 bytes.
 * Global variables use 592 bytes (28%) of dynamic memory, leaving 1456 bytes for local variables. Maximum is 2048 bytes.
 *
 */

// no change if I use these settings -> the library always uses hardware time
//#define SEND_PWM_BY_TIMER
//#define IR_SEND_PIN 14
// as suggested in the arduino forum and documented in the hpp file -> use dedicated timer setting
#define IR_USE_AVR_TIMER1
// TODO: find out why it always uses the hardware timers (V 4.2.0)
#define EXCLUDE_EXOTIC_PROTOCOLS
#define EXCLUDE_UNIVERSAL_PROTOCOLS
#include <IRremote.hpp>
#define IR_RECEIVE_PIN 14 /* A0 */

#define IR_Go 0x46     //up
#define IR_Back 0x15   //down
#define IR_Left 0x44   //left
#define IR_Right 0x43  //right
#define IR_Stop 0x40   //OK
// additional codes
#define IR_1  0x16    //1
#define IR_2  0x19    //2
#define IR_3  0x0D    //3
#define IR_4  0x0C    //4
#define IR_5  0x18    //5
#define IR_6  0x5E    //6
#define IR_7  0x08    //7
#define IR_8  0x1C    //8
#define IR_9  0x5A    //9
#define IR_Star  0x42    //Star
#define IR_0  0x52    //0
#define IR_Hash  0x4A    //Hash

int IR_Control(void) {
  int command = COMMAND_NONE;
  unsigned long Key;
  if (IrReceiver.decode())  //judging if serial port receives data
  {
    Key = IrReceiver.decodedIRData.command;
    Serial.println(Key,HEX);
    switch (Key) {
      case IR_Go:
        command = COMMAND_ADVANCE;
        break;
      case IR_Back:
        command = COMMAND_BACK;
        break;
      case IR_Left:
        command = COMMAND_TURNLEFT;
        break;
      case IR_Right:
        command = COMMAND_TURNRIGHT;
        break;
      case IR_Stop:
        command = COMMAND_STOPP;
        break;
      case IR_Star: //mode continuous
        command = COMMAND_CONTINUOUSLY;
        break;
      case IR_Hash: //mode single step
        command = COMMAND_SINGLESTEP;
        break;
      case IR_1:
        command = COMMAND_ACCELERATE;
        break;
      case IR_2:
        command = COMMAND_MAXSPEED;
        break;
      case IR_3:
        command = COMMAND_DECELARATE;
        break;
      default:
        break;
    }
    IrReceiver.resume();  // Receive the next value
  }
  return command;
}

#define IR_Control_Gap 250
