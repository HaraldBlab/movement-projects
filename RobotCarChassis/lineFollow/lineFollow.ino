/*
 * lineFollow.c - a line follow autonomous vehicle.
 * 
 * Detecs black lines with 4 IR sensors.
 * If all sensors are on the black line, 
 * - follow the line.
 * if any sensor is not on a black line, 
 * - performs a movement to move all back to the black line.
 */
/*-based on---------------------------------------------------------------
    Project to modify the AZ-Delivery 2WD Intelligent Robot Car as an 
    autonomous vehicle for line following.
    It uses a four-sensor infrared module to detect line edges.
    
    Miguel Torres Gordo                                                                               
    Getafe (Madrid) - ESPAÑA          Last revision 22-03-2024  
-------------------------------------------------------------------------*/
/*
 * Modifications:
 * * Serial to 115200
 * * define speed with macro
 */

#include "motor_functions.h"  // car motor functions
#include "line_functions.h"   // line detection functions
 
// 70 -> (1,2,3)
// 90 -> (2,4,6)
#define SPEED 70
#define SPEED_1 (SPEED+2)
#define SPEED_2 (SPEED+4)
#define SPEED_3 (SPEED+6)

void setup() {
  Serial.begin (115200);

  M_Control_IO_config();
  Set_Speed(SPEED_1, SPEED_1);
  L_Control_IO_config();
}

void loop() {

  /* get the state of all IR sensors */
  L_read();
      
  /* Set of conditionals to check the values of the variables of the infrared sensors and perform the necessary movements. */

  /* If all four sensors are above the black line, a call is made to the moves forward. */
  if (L_on_line()) { 
    car_advances();
  }                                                                                                                 

  /* If sensor number 1 is not on the black line, a call is made to the smooth left turn method. */
  else if (L_right_off_line()) { 
    slight_turn_left();
  }

  /* If sensors 1 and 2 are not on the black line, a call is made to the hard left turn method. */
  else if (L_rights_off_line()) { 
    sharp_left_turn();
  }

  /* If sensor number 4 is not on the black line, a call is made to the smooth right turn method. */
  else if (L_left_off_line()) { 
    slight_turn_right();
  }

  /* If sensors 3 and 4 are not on the black line, a call is made to the hard right turn method. */
  else if (L_lefts_off_line()) { 
    sharp_right_turn();
  }

  /* If all sensors are not above the black line, a call is made to the hard left turn method. */
  else if (L_off_line()) { 
    sharp_left_turn();
  }       
}

// Method for the car to move forward.
void car_advances() {
  Serial.println("Car advance");
  Set_Speed(SPEED_1, SPEED_1);
  advance();
}

// Method for the car to slight turn to the right.
void slight_turn_right() {
  Serial.println("Car turn right");
  Set_Speed(SPEED_1, SPEED_2);
  turnR();
}

// Method for the car to sharp turn to the right.
void sharp_right_turn() {
  Serial.println("Car turn right");
  Set_Speed(SPEED_1, SPEED_3);
  turnR();
}

// Method for the car to slight turn to the left.
void slight_turn_left() {
  Serial.println("Car turn left");
  Set_Speed(SPEED_2, SPEED_1);
  turnL();
}

// Method for the car to sharp turn to the left.
void sharp_left_turn() {
  Serial.println("Car turn left");
  Set_Speed(SPEED_3, SPEED_1);
  turnL();
}
