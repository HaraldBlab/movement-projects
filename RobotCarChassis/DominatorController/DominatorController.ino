/*
 * ReceiveDump.cpp
 *
 * Dumps the received signal in different flavors.
 * Since the printing takes so much time (200 ms @115200 for NEC protocol, 70ms for NEC repeat),
 * repeat signals may be skipped or interpreted as UNKNOWN.
 *
 *  This file is part of Arduino-IRremote https://github.com/Arduino-IRremote/Arduino-IRremote.
 *
 ************************************************************************************
 * MIT License
 *
 * Copyright (c) 2020-2022 Armin Joachimsmeyer
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is furnished
 * to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
 * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
 * PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
 * CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
 * OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 ************************************************************************************
 * DiominatorController IR controller - delived with a wall climbing car
 * Has a frequncey-converstion switch (A,B,C)
 * Has a forward/backward joystick (left side)
 * Has a turn left/turn right joystick (right side)
 * Has a left-fine-tuning button (switches forward/back to left joystick)
 * Has a right-fine-tuning button (switches forward/back to right joystick)
 * 
 * Results reads from ReceiveDump
 * Has a forward/backward joystick (left side)
 *  forward: 
 *  14:53:58.771 -> Protocol=PulseWidth Raw-Data=0x3F804 23 bits LSB first
 *  15:02:16.458 -> Protocol=PulseWidth Raw-Data=0x7FC40 23 bits LSB first
 *  15:03:52.762 -> Protocol=PulseWidth Raw-Data=0x7FC40 23 bits LSB first
 *  15:04:44.428 -> Protocol=PulseWidth Raw-Data=0x7FC40 23 bits LSB first
 *  backward: 
 *  14:55:07.583 -> Protocol=PulseWidth Raw-Data=0x7B804 23 bits LSB first
 *  15:05:43.364 -> Protocol=PulseWidth Raw-Data=0x3BC40 23 bits LSB first
 *  15:07:31.688 -> Protocol=PulseWidth Raw-Data=0x3BC40 23 bits LSB first
 *  15:08:13.699 -> Protocol=PulseWidth Raw-Data=0x3BC40 23 bits LSB first
 * Has a turn left/turn right joystick (right side)
 *  turn left: 
 *  14:55:59.082 -> Protocol=PulseWidth Raw-Data=0x3C384 23 bits LSB first
 *  15:09:05.738 -> Protocol=PulseWidth Raw-Data=0x3C3C0 23 bits LSB first
 *  15:10:03.500 -> Protocol=PulseWidth Raw-Data=0x3C3C0 23 bits LSB first
 *  15:11:17.385 -> Protocol=PulseWidth Raw-Data=0x3C3C0 23 bits LSB first
 *  turn right: 
 *  14:56:36.906 -> Protocol=PulseWidth Raw-Data=0x7C784 23 bits LSB first
 *  15:12:07.986 -> Protocol=PulseWidth Raw-Data=0x7C7C0 23 bits LSB first
 *  15:12:49.595 -> Protocol=PulseWidth Raw-Data=0x7C7C0 23 bits LSB first
 *  15:13:34.100 -> Protocol=PulseWidth Raw-Data=0x7C7C0 23 bits LSB first
 * Has a left-fine-tuning button
 *  14:59:53.718 -> Protocol=PulseWidth Raw-Data=0x260006 23 bits LSB first
 *  15:14:14.251 -> Protocol=PulseWidth Raw-Data=0x224402 23 bits LSB first
 *  15:15:16.856 -> Protocol=PulseWidth Raw-Data=0x244404 23 bits LSB first
 *  15:15:56.412 -> Protocol=PulseWidth Raw-Data=0x224402 23 bits LSB first
 * Has a right-fine-tuning button
 *  15:00:39.310 -> Protocol=PulseWidth Raw-Data=0x440004 23 bits LSB first
 *  15:16:41.934 -> Protocol=PulseWidth Raw-Data=0x444440 23 bits LSB first
 *  15:17:32.617 -> Protocol=PulseWidth Raw-Data=0x464442 23 bits LSB first
 *  15:18:03.056 -> Protocol=PulseWidth Raw-Data=0x404444 23 bits LSB first
 *  
 *  Delay/ Gap
 *  15:35:11.754 -> Protocol=PulseWidth Repeat gap=80200us Raw-Data=0x44440 23 bits LSB first
 *  
 *  forward:0x26040, 0x3F840, 0x7FC40, 0x26040, 0x3F840, 0x37040, 0x26040, 0x7B840
 *  backward:0x3BC40, 0x19C40, 0x22440, 0x3BC40, 0x3BC40, 0x2E840, 0x3F840, 0x37040
 *  release/home forwad/backward: 0x4040, 0x44440, 0x40040, 
 *  turn left: 0x2C2C0, 0x3C3C0
 *  turn right: 0x7C7C0, 0x64640, 0x74740, 0x7C7C0, 0x5C5C0, 0x74740, 0x7C7C0
 *  release/home turn left/turn right: 0x2040, 0x44440, 0x4040
 *  left-fine-tuning: count up (0-->E)
 *  right-fine-tuning: count down (E-->0)
 * 
 * IRControl: 
 * - press the L button left and right are swapped
 * - press the R button works as before
 * 
 * Has a frequncey-converstion switch (A,B,C)
 *  CHANNEL A: forward/backward 0x...40, turn left/turn right 0x...C0 (4, C)
 *  CHANNEL B: forward/backward 0x...F8, turn left/turn right 0x...C8
 *  CHANNEL C: forward/backward 0x...49, turn left/turn right 0x...C9
 *  CHANNEL X: forward/backward 0x...41, turn left/turn right 0x...C1
 *  
 * Board: Arduino Uno
 * Port: COM9 (Arduino Uno)
 * 
 * #define IR_RECEIVE_PIN 14
 * 
 */
#include <Arduino.h>

#define IR_OPERATION 2  /* 0=IRDump,1=IRDecode,2=IRControll */
#if ((!defined(IR_OPERATION) || (defined(IR_OPERATION) && IR_OPERATION==0)))
  #define IR_OPERATION_DUMP 1
#elif (defined(IR_OPERATION) && IR_OPERATION==1)
  #define IR_OPERATION_DECODE 1
#elif (defined(IR_OPERATION) && IR_OPERATION==2)
  #define IR_OPERATION_CONTROL 1
#endif

#include "PinDefinitionsAndMore.h" // Define macros for input and output pin etc.

#define IR_RECEIVE_PIN 14 /* A0 */

#if (defined(IR_OPERATION_DUMP))
  #if !defined(RAW_BUFFER_LENGTH)
  #  if RAMEND <= 0x4FF || RAMSIZE < 0x4FF
  #define RAW_BUFFER_LENGTH  180  // 750 (600 if we have only 2k RAM) is the value for air condition remotes. Default is 112 if DECODE_MAGIQUEST is enabled, otherwise 100.
  #  elif RAMEND <= 0x8FF || RAMSIZE < 0x8FF
  #define RAW_BUFFER_LENGTH  600  // 750 (600 if we have only 2k RAM) is the value for air condition remotes. Default is 112 if DECODE_MAGIQUEST is enabled, otherwise 100.
  #  else
  #define RAW_BUFFER_LENGTH  750  // 750 (600 if we have only 2k RAM) is the value for air condition remotes. Default is 112 if DECODE_MAGIQUEST is enabled, otherwise 100.
  #  endif
#endif

/*
 * MARK_EXCESS_MICROS is subtracted from all marks and added to all spaces before decoding,
 * to compensate for the signal forming of different IR receiver modules. See also IRremote.hpp line 142.
 *
 * You can change this value accordingly to the receiver module you use.
 * The required value can be derived from the timings printed here.
 * Keep in mind that the timings may change with the distance
 * between sender and receiver as well as with the ambient light intensity.
 */
#define MARK_EXCESS_MICROS    20    // Adapt it to your IR receiver module. 20 is recommended for the cheap VS1838 modules.

//#define RECORD_GAP_MICROS 12000 // Default is 5000. Activate it for some LG air conditioner protocols
//#define DEBUG // Activate this for lots of lovely debug output from the decoders.

#endif
/*
 * IR_OPERATION_DUMP
 * Sketch uses 13748 bytes (42%) of program storage space. Maximum is 32256 bytes.
 * Global variables use 1774 bytes (86%) of dynamic memory, leaving 274 bytes for local variables. Maximum is 2048 bytes.
 * Low memory available, stability problems may occur.
 */
#include <IRremote.hpp>

//+=============================================================================
// Configure the Arduino
//
void setup() {
    pinMode(LED_BUILTIN, OUTPUT);

    Serial.begin(115200);
#if defined(__AVR_ATmega32U4__) || defined(SERIAL_PORT_USBVIRTUAL) || defined(SERIAL_USB) /*stm32duino*/|| defined(USBCON) /*STM32_stm32*/|| defined(SERIALUSB_PID) || defined(ARDUINO_attiny3217)
    delay(4000); // To be able to connect Serial monitor after reset or power up and before first print out. Do not wait for an attached Serial Monitor!
#endif
    // Just to know which program is running on my Arduino
    Serial.println(F("START " __FILE__ " from " __DATE__ "\r\nUsing library version " VERSION_IRREMOTE));

    // Start the receiver and if not 3. parameter specified, take LED_BUILTIN pin from the internal boards definition as default feedback LED
    IrReceiver.begin(IR_RECEIVE_PIN, ENABLE_LED_FEEDBACK);

#if (defined(IR_OPERATION_DUMP))
    Serial.print(F("Ready to receive IR signals of protocols: "));
    printActiveIRProtocols(&Serial);
    Serial.println(F("at pin " STR(IR_RECEIVE_PIN)));

    // infos for receive
    Serial.print(RECORD_GAP_MICROS);
    Serial.println(F(" us is the (minimum) gap, after which the start of a new IR packet is assumed"));
    Serial.print(MARK_EXCESS_MICROS);
    Serial.println();
    Serial.println(F("Because of the verbose output (>200 ms at 115200), repeats are probably not dumped correctly!"));
    Serial.println();
#endif
}

#if (defined(IR_OPERATION_DUMP))
//
// The repeating section of the code
//
void ReceiveDump() {
    if (IrReceiver.decode()) {  // Grab an IR code
        // At 115200 baud, printing takes 200 ms for NEC protocol and 70 ms for NEC repeat
        Serial.println(); // blank line between entries
        Serial.println(); // 2 blank lines between entries
        IrReceiver.printIRResultShort(&Serial);
        // Check if the buffer overflowed
        if (IrReceiver.decodedIRData.flags & IRDATA_FLAGS_WAS_OVERFLOW) {
            Serial.println(F("Try to increase the \"RAW_BUFFER_LENGTH\" value of " STR(RAW_BUFFER_LENGTH) " in " __FILE__));
            // see also https://github.com/Arduino-IRremote/Arduino-IRremote#compile-options--macros-for-this-library
        } else {
            if (IrReceiver.decodedIRData.protocol == UNKNOWN) {
                Serial.println(F("Received noise or an unknown (or not yet enabled) protocol"));
            }
            Serial.println();
            IrReceiver.printIRSendUsage(&Serial);
            Serial.println();
            Serial.println(F("Raw result in internal ticks (50 us) - with leading gap"));
            IrReceiver.printIRResultRawFormatted(&Serial, false); // Output the results in RAW format
            Serial.println(F("Raw result in microseconds - with leading gap"));
            IrReceiver.printIRResultRawFormatted(&Serial, true);  // Output the results in RAW format
            Serial.println();                               // blank line between entries
            Serial.print(F("Result as internal 8bit ticks (50 us) array - compensated with MARK_EXCESS_MICROS="));
            Serial.println(MARK_EXCESS_MICROS);
            IrReceiver.compensateAndPrintIRResultAsCArray(&Serial, false); // Output the results as uint8_t source code array of ticks
            Serial.print(F("Result as microseconds array - compensated with MARK_EXCESS_MICROS="));
            Serial.println(MARK_EXCESS_MICROS);
            IrReceiver.compensateAndPrintIRResultAsCArray(&Serial, true); // Output the results as uint16_t source code array of micros
            IrReceiver.printIRResultAsCVariables(&Serial);  // Output address and data as source code variables

            IrReceiver.compensateAndPrintIRResultAsPronto(&Serial);
            /*
             * Example for using the compensateAndStorePronto() function.
             * Creating this String requires 2210 bytes program memory and 10 bytes RAM for the String class.
             * The String object itself requires additional 440 bytes RAM from the heap.
             * This values are for an Arduino Uno.
             */
//        Serial.println();                                     // blank line between entries
//        String ProntoHEX = F("Pronto HEX contains: ");        // Assign string to ProtoHex string object
//        if (int size = IrReceiver.compensateAndStorePronto(&ProntoHEX)) {   // Dump the content of the IReceiver Pronto HEX to the String object
//            // Append compensateAndStorePronto() size information to the String object (requires 50 bytes heap)
//            ProntoHEX += F("\r\nProntoHEX is ");              // Add codes size information to the String object
//            ProntoHEX += size;
//            ProntoHEX += F(" characters long and contains "); // Add codes count information to the String object
//            ProntoHEX += size / 5;
//            ProntoHEX += F(" codes");
//            Serial.println(ProntoHEX.c_str());                // Print to the serial console the whole String object
//            Serial.println();                                 // blank line between entries
//        }
        }
        IrReceiver.resume();                            // Prepare for the next value
    }
  
}
#endif

#if (defined(IR_OPERATION_DECODE))
typedef enum JoystickMovement {
  JM_Undefined = 0x00,
  JM_Home      = 0x01,
  JM_UpLeft   = 0x02, // DOWN/RIGHT
  JM_DownRight  = 0x04, // UP/LEFT
} JM;


uint8_t mapDirection(uint16_t value) {
  JM direction = JM_Undefined;
  // range is 3C3 to 7C7 (varying)
  if ((value <= 0x4FF && value >= 0x400) || (value < 0x3C3)) // different values (most starting with 4)
    direction = JM_Home;
  else if (value > 0x4FF)
    direction = JM_UpLeft;
  else
    direction = JM_DownRight;
  return direction;
}

void printJM(uint8_t direction) {
  if (direction==JM_Home)
    Serial.println(F("HOME"));
  else if (direction==JM_UpLeft)
    Serial.println(F("DOWN/RIGHT"));
  else if (direction==JM_DownRight)
    Serial.println(F("UP/LEFT"));
  else
    Serial.println(F("UNDEFINED"));
}

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
void printDevice(uint8_t device) {
  if (device == Joystick_Left)
    Serial.println(F("LEFT"));
  else if (device = Joystick_Right)
    Serial.println(F("RIGHT"));
  else
    Serial.println(F("BUTTON"));
}

void IRdecode() {
  if (IrReceiver.decode()) {  // Grab an IR code
    uint8_t numberOfBits = IrReceiver.decodedIRData.numberOfBits;
    if (numberOfBits == 23)
      Serial.println(F("Detected:"));
    else if (numberOfBits == 32)
      Serial.println(F("Status:"));
    else
      Serial.println(F("Found:"));

    /* Analyze the data */
    uint16_t address = IrReceiver.decodedIRData.address;
    uint16_t command = IrReceiver.decodedIRData.command;
    uint32_t rawData = IrReceiver.decodedIRData.decodedRawData;

    Serial.print(F("rawData = 0x"));
    Serial.println(rawData, HEX);

    if (numberOfBits == 23) {
      /* decode a valid packet */
      uint8_t channel = (rawData & 0x0000000F);
      uint8_t device = ((rawData & 0x000000F0) >> 4);
      Serial.print(F("channel = 0x")); Serial.println(channel, HEX);
      Serial.print(F("device = 0x"));  Serial.println(device, HEX);
      printDevice (mapDevice(device));

      uint16_t value = ((rawData & 0x007FFFFF)>>8);  // we only have 23 bit
      Serial.print(F("value = 0x")); Serial.println(value, HEX);
      printJM(mapDirection(value));
    }
        
    IrReceiver.resume();                            // Prepare for the next value
  }
}
#define IRdecode_Gap 80 /* Dump; 80000 usec */
#endif

#if (defined(IR_OPERATION_CONTROL))

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
  else if (value > 0x4FF)
    direction = JM_UpLeft;
  else
    direction = JM_DownRight;
  return direction;
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

#include "commands.h"

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
    printIRKey(Key);
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

#endif

void loop() {
#if (defined(IR_OPERATION_DUMP))
  ReceiveDump();
#elif (defined(IR_OPERATION_DECODE))
  IRdecode();
  delay(IRdecode_Gap); 
#elif (defined(IR_OPERATION_CONTROL))
  uint8_t command = IR_Control();
  delay(IR_Control_Gap); 
#endif
}
