/*
 * obstacleAvoid - self drving obstacle avoiding car.
 * Skeleton from RobitCarKit obstacleAvoid sample.
 * 
 * 4WD car with Adafruit Motor Shield V1 (V2?)
 * 3 ultrasonic modules mounted on the chasis H(ead), L(eft) and R(ight)
 * 
 * Changes
 * * Moved obstacle detection related things to own file
 * * New obstacle detection functions to ge distance only
 * * Detects when there is no signal in any direction because it is stucked.
 * 
 */
#include "motor_functions.h"
#include "obstacle_functions.h"

// motors
void M_Control_IO_config();
void Set_Speed(unsigned char Left, unsigned char Right);
void back();
void turnR();
void turnL();
void stopp();
void advance();

void Self_Control(void)//self-going, ultrasonic obstacle avoidance
{
  int H = H_distance();
  delay(300);
  /* if there is an obstacle very close at front, go back */
  if (H < 15)
//  if (ask_pin_H(1) < 15)
  {
    stopp();
    delay(1000);
    back();
    delay(1000);
  }

  /* if there is an obstacle at front 
   * look left and right for a free way 
   */
  if (H < 30)
//  if (ask_pin_H(1) < 30)
  {
    stopp();
    delay(100);
    int L = L_distance();
    delay(300);
    int R = R_distance();
    delay(300);

    /* if free way on the left turn left */
    if (L > R)
//    if (ask_pin_L(2) > ask_pin_R(3))
    {
      back();
      delay(100);
      turnL();
      delay(400);
      stopp();
      delay(50);
      H = H_distance();
      delay(500);
    }

    /* if free way on the right turn right */
    if (L <= R)
//    if (ask_pin_L(2)  <= ask_pin_R(3))
    {
      back();
      delay(100);
      turnR();
      delay(400);
      stopp();
      delay(50);
      H = H_distance();
      delay(300);
    }

    /* if left and right is not possible, go back */
    if (L  < 35 && R < 35)
//    if (ask_pin_L(2)  < 35 && ask_pin_R(3) < 35)
    {
      stopp();
      delay(50);
      back();
      delay(50);
    }
  }
  else if (H == NO_OBSTACLE)
  {
    int L = L_distance();
    delay(300);
    int R = R_distance();
    delay(300);
    /* if there is no signal in any direction it is stucked.Go back */
    if (L == NO_OBSTACLE && R == NO_OBSTACLE)
    {
      stopp();
      delay(50);
      back();
      delay(50);
    }
    else
    {
      advance();
    }
  }
  else
  {
    advance();
  }
}

void setup()
{
  // motors
  M_Control_IO_config();     //motor controlling the initialization of IO
  Set_Speed(Lpwm_val, Rpwm_val); //setting initialized speed
  // ultrasonic module
  O_Control_IO_config();
  //
  Serial.begin(115200);            //initialized serial port , using Bluetooth as serial port, setting baud
  stopp();                       //stop
  delay(1000);
}

void Self_Test() {
  H_distance();
  delay(500);  
  L_distance();
  delay(500);  
  R_distance();
  delay(500);  
}
void loop()
{
  Self_Control();
//  Self_Test();
}
