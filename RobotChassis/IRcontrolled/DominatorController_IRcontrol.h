/*
 * DominatorController_IRcontrol.h - Interfaces the DominatorController
 * 
 * DominatorController IR controller - delived with a wall climbing car
 * Has a frequncey-converstion switch (A,B,C)
 * Has a forward/backward joystick (left side)
 * Has a turn left/turn right joystick (right side)
 * Has a left-fine-tuning button (switches forward/back to left joystick)
 * Has a right-fine-tuning button (switches forward/back to right joystick)
 */
 #define IR_USE_AVR_TIMER1
// TODO: find out why it always uses the hardware timers (V 4.2.0)
#define EXCLUDE_EXOTIC_PROTOCOLS
//#define EXCLUDE_UNIVERSAL_PROTOCOLS
#include <IRremote.hpp>
#define IR_RECEIVE_PIN 14 /* A0 */

namespace DominatorController {

typedef enum Device {
  Joystick_Left    = 0x01,
  Joystick_Right   = 0x02,
  Any_Button       = 0x04,
};

uint8_t mapDevice(uint8_t device) {
  if (device == 0x04)
    return Joystick_Left;
  else if (device = 0x0C)
    return Joystick_Right;
  else
    return Any_Button;
}

typedef enum JoystickMovement {
  JM_Undefined = 0x00,
  JM_Home      = 0x01,
  JM_UpLeft    = 0x02,
  JM_DownRight = 0x04,
} JM;

uint8_t mapDirection(uint16_t value) {
  JM direction = JM_Undefined;
  // range is 3C3 to 7C7 (varying), 2xx values for right joystick
  if ((value <= 0x4FF && value >= 0x400) || (value < 0x200)) // different values (most starting with 4)
    direction = JM_Home;
   // TODO: one or the other is detected?
  else if (value > 0x4FF)
    //direction = JM_UpLeft;
    direction = JM_DownRight;
  else
    //direction = JM_DownRight;
    direction = JM_UpLeft;
  return direction;
}

void printValue(uint16_t valueData) {
  Serial.print(F("valueData: ")); Serial.println(valueData,HEX);

}
bool decode() {
  if (IrReceiver.decode()) {
    uint8_t numberOfBits = IrReceiver.decodedIRData.numberOfBits;
    IrReceiver.decodedIRData.command = 0;
    if (numberOfBits == 23) {
      uint32_t rawData = IrReceiver.decodedIRData.decodedRawData;
      uint8_t deviceData = ((rawData & 0x000000F0) >> 4);
      uint8_t device = mapDevice(deviceData);
      uint16_t valueData = ((rawData & 0x007FFFFF)>>8);  // we only have 23 bit
      //printValue(valueData);
      uint8_t direction = mapDirection(valueData);
      IrReceiver.decodedIRData.command = (unsigned long) ((direction << 4) | device);
    }
    return true;
  }
  return false;
}

#define mapCommand(x, y) ((DominatorController::x << 4) | DominatorController::y)
#define IR_Go     mapCommand(JM_DownRight, Joystick_Left)
#define IR_Back   mapCommand(JM_UpLeft, Joystick_Left)
#define IR_Left   mapCommand(JM_UpLeft, Joystick_Right)
#define IR_Right  mapCommand(JM_DownRight, Joystick_Right)
#define IR_Stop   mapCommand(JM_Home, Joystick_Left)

} // namespace

int printIRKey(uint8_t key) {
    switch (key) {
      case IR_Go: 
        Serial.print(F("IR_Go: ")); Serial.println(IR_Go,HEX);
        break;
      case IR_Back: 
        Serial.print(F("IR_Back: ")); Serial.println(IR_Back,HEX);
        break;
      case IR_Left: 
        Serial.print(F("IR_Left: ")); Serial.println(IR_Left,HEX);
        break;
      case IR_Right: 
        Serial.print(F("IR_Right: ")); Serial.println(IR_Right,HEX);
        break;
      case IR_Stop: 
        Serial.print(F("IR_Stop: ")); Serial.println(IR_Stop,HEX);  
        break;
      default: 
        Serial.print(F("Unknown: ")); Serial.println(key,HEX);
        break;
    }
}
int IR_Control(void) {
  int command = COMMAND_NONE;
  unsigned long Key;
  if (DominatorController::decode())  //judging if serial port receives data
  {
    Key = IrReceiver.decodedIRData.command;
    //Serial.print(F("Key: ")); Serial.println(Key,HEX);
    //printIRKey(Key);
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
      default:
        break;
    }
    IrReceiver.resume();  // Receive the next value
  }
  return command;
}

#define IR_Control_Gap 80 /* Dump; 80000 usec */
