/*
 * obstacle_functions.h - Obstacle detecion functions
 * 
 * A single ultrasonic module is used to detect the distance to H(ead)
 * 
 * HC-SR04
 * * Max Range 400 cm
 * * Min Range 2 cm
 * * Measuring Angle: 15 degree
 * * Trigger Input Signal: 10 us TTL pulse
 * * Echo output signal: Input TTL lever signal and the range in proportion
 * * Formula: us / 58 = cm, 
 * *  speed of sound at 20 deg is 343 m/s or 29,15 cm/s
 * *  the ultrasonic wave has to take twice the way 58,3 cm/s
 * * Measurement Cycle: over 60 ms: 
 */

int outputPin = 9;                  // ultrasonic module  TRIG
int inputPin  = 8;                  // ultrasonic module  ECHO
unsigned long timeout_us = 100000;  // timout in microseconds (100 ms)

/* Initialize the obstacle detection */
void O_Control_IO_config()
{
  pinMode(inputPin, INPUT);      // ultrasonic module signal ECHO
  pinMode(outputPin, OUTPUT);    // ultrasonic module signal trigger

}
#define NO_OBSTACLE 10000    // about 100 meters 
/* Measure the obstacle distance to the Head */
int H_distance() 
{
  int ask_pin_H(unsigned char Mode);
  int H = ask_pin_H(1);
#ifdef USE_SERIAL
    Serial.print("\n H = ");
    Serial.print(H, DEC);
#endif
  return H == 0 ? NO_OBSTACLE : H;
}

int ask_pin_H(unsigned char Mode) 
{
  // start trigger
  digitalWrite(outputPin, LOW);
  delayMicroseconds(2);
  digitalWrite(outputPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(outputPin, LOW);
  // get echo - reading the duration of high level
  unsigned long distance = pulseIn(inputPin, HIGH, timeout_us);
  distance = distance / 58; // Transform pulse time to distance
  if (Mode == 1) {
#ifdef USE_SERIAL
    Serial.print("\n H = ");
    Serial.print(distance, DEC);
#endif
    return (int) distance;
  }
  else  
    return (int) distance;
}
