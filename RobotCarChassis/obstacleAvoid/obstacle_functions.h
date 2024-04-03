/*
 * obstacle_functions.h - Obstacle detetcion functions
 * extracted from RobitCarKit obstacleAvoid sample.
 * 
 * 3 ultrasonic modules mounted on the chasis H(ead), L(eft) and R(ight)
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
 * Changes:
 * * Moved obstacle detection functions to this file
 * * Added H_distance, L_distance and R_distance
 * * Added O_Control_IO_config
 * * Added pulseIn() timout handling
 */

// obstacle detection functions
void O_Control_IO_config();
int H_distance();
int L_distance();
int R_distance();

// ultrasonic modules
int triggerPin = 14;    // TRIG (common to all 3 modules)
int echoPinH = 15;      // ECHO H(ead)
int echoPinL = 16;      // ECHO L(eft)
int echoPinR = 17;      // ECHO R(ight)
unsigned long timeout_us = 100000;  // timout in microseconds (100 ms)

/* Initialize the obstacle detection */
void O_Control_IO_config()
{
  pinMode(triggerPin, OUTPUT);
  pinMode(echoPinH, INPUT);
  pinMode(echoPinL, INPUT);
  pinMode(echoPinR, INPUT);
}
#define NO_OBSTACLE 10000    // about 100 meters 
/* Measure the obstacle distance to the Head */
int H_distance() 
{
  int ask_pin_H(unsigned char Mode);
  int H = ask_pin_H(1);
  return H == 0 ? NO_OBSTACLE : H;
}
/* Measure the obstacle distance to the Left */
int L_distance() 
{
  int ask_pin_L(unsigned char Mode);
  int L = ask_pin_L(2);
  return L == 0 ? NO_OBSTACLE : L;  
}
/* Measure the obstacle distance to the right */
int R_distance()
{
  int ask_pin_R(unsigned char Mode);
  int R = ask_pin_R(3);
  return R == 0 ? NO_OBSTACLE : R;
}

/**
 * Handling of the ultrasonic module.
 * Written that way, that we can use it with 3 different ultrasonic modules
 */
int ask_pin_H(unsigned char Mode)//function of ultrasonic distance detecting ，MODE=1，displaying，no displaying under other situation
{
  // start trigger
  digitalWrite(triggerPin, LOW);
  delayMicroseconds(2);
  digitalWrite(triggerPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(triggerPin, LOW);
  // get echo - reading the duration of high level
  unsigned long distance = pulseIn(echoPinH, HIGH, timeout_us);
  distance = distance / 58; // Transform pulse time to distance
  if (Mode == 1) {
    Serial.print("\n H = ");
    Serial.print(distance, DEC);
    return (int) distance;
  }
  else  
    return (int) distance;
}

int ask_pin_L(unsigned char Mode)
{
  // start trigger
  digitalWrite(triggerPin, LOW);
  delayMicroseconds(2);
  digitalWrite(triggerPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(triggerPin, LOW);
  // get echo
  unsigned long Ldistance = pulseIn(echoPinL, HIGH, timeout_us);
  Ldistance = Ldistance / 58; // Transform pulse time to distance
  if (Mode == 2) {
    Serial.print("\n L = ");
    Serial.print(Ldistance, DEC);
    return (int) Ldistance;
  }
  else  
    return (int) Ldistance;
}
int ask_pin_R(unsigned char Mode)
{
  // start trigger
  digitalWrite(triggerPin, LOW);
  delayMicroseconds(2);
  digitalWrite(triggerPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(triggerPin, LOW);
  // get echo
  unsigned long Rdistance = pulseIn(echoPinR, HIGH, timeout_us);
  Rdistance = Rdistance / 58; // Transform pulse time to distance
  if (Mode == 3) {
    Serial.print("\n R = ");
    Serial.print(Rdistance, DEC);
    return (int) Rdistance;
  }
  else  
    return (int) Rdistance;
}
