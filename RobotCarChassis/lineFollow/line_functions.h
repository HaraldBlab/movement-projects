/*
 * line_functions.h - (black) line detection functions
 * 
 * Uses a four-sensor infrared module to detect line edges.
 *
 */
/*-based on---------------------------------------------------------------
    Project to modify the AZ-Delivery 2WD Intelligent Robot Car as an 
    autonomous vehicle for line following.
    It uses a four-sensor infrared module to detect line edges.
      
    Miguel Torres Gordo                                                                               
    Getafe (Madrid) - ESPAÑA          Last revision 22-03-2024     
-------------------------------------------------------------------------*/

/* 
 *  pins are connected right to left
 *  1 is the right most sensor
 *  4 is the left most sensor
 */
#define IR_sensor_1 14 /* A0 */
#define IR_sensor_2 15 /* A1 */
#define IR_sensor_3 16 /* A2 */
#define IR_sensor_4 17 /* A3 */

/* variables to save measure of sensors */
int value_IR_sensor_1;
int value_IR_sensor_2;
int value_IR_sensor_3;
int value_IR_sensor_4;

/* Setup the sensors used */
void L_Control_IO_config(void) {
  pinMode(IR_sensor_1, INPUT);
  pinMode(IR_sensor_2, INPUT);
  pinMode(IR_sensor_3, INPUT);
  pinMode(IR_sensor_4, INPUT);
}

/* Method for saving the infrared sensor value 1. */
void state_IR_1() {
  value_IR_sensor_1 = digitalRead(IR_sensor_1);
  Serial.print("State IR sensor 1");
  Serial.print(value_IR_sensor_1);
}
/* Method for saving the infrared sensor value 2. */
void state_IR_2() {
  value_IR_sensor_2 = digitalRead(IR_sensor_2);
  Serial.print("State IR sensor 2");
  Serial.print(value_IR_sensor_2);
}
/* Method for saving the infrared sensor value 3. */
void state_IR_3() {
  value_IR_sensor_3 = digitalRead(IR_sensor_3);
  Serial.print("State IR sensor 3");
  Serial.print(value_IR_sensor_3);
}
/* Method for saving the infrared sensor value 4. */
void state_IR_4() {
  value_IR_sensor_4 = digitalRead(IR_sensor_4);
  Serial.print("State IR sensor 4");
  Serial.print(value_IR_sensor_4);
}

/* read the state (value) of all sensors */
void L_read() {
  state_IR_1();
  state_IR_2();
  state_IR_3();
  state_IR_4();
}

/* all four sensors are above the black line. */
int L_on_line() { return value_IR_sensor_1 == HIGH && value_IR_sensor_2 == HIGH && value_IR_sensor_3 == HIGH && value_IR_sensor_4 == HIGH; }
/* sensor number 1 is not on the black line. */
int L_right_off_line() { return value_IR_sensor_1 == LOW && value_IR_sensor_2 == HIGH && value_IR_sensor_3 == HIGH && value_IR_sensor_4 == HIGH; }
/* sensors 1 and 2 are not on the black line. */
int L_rights_off_line() { return value_IR_sensor_1 == LOW && value_IR_sensor_2 == LOW && value_IR_sensor_3 == HIGH && value_IR_sensor_4 == HIGH; }
/* sensor number 4 is not on the black line. */
int L_left_off_line() { return value_IR_sensor_1 == HIGH && value_IR_sensor_2 == HIGH && value_IR_sensor_3 == HIGH && value_IR_sensor_4 == LOW; }
/* sensors 3 and 4 are not on the black line. */
int L_lefts_off_line() { return value_IR_sensor_1 == HIGH && value_IR_sensor_2 == HIGH && value_IR_sensor_3 == LOW && value_IR_sensor_4 == LOW; }
/* all sensors are not above the black line. */
int L_off_line() { return value_IR_sensor_1 == LOW && value_IR_sensor_2 == LOW && value_IR_sensor_3 == LOW && value_IR_sensor_4 == LOW; }
