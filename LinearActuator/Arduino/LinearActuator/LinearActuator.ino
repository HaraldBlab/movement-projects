/*
   LinearActuator:

   Based on:
   Getting Started With Stepper Motor 28BYJ-48
   http://https://create.arduino.cc/projecthub/debanshudas23/getting-started-with-stepper-motor-28byj-48-3de8c9

   Added suggestions from comments
   - use millis instead of delay()
   + add "write(0,0,0,0); delay(5);" at the end of a micro step this to avoid current running if you stop after one step.
   + You can use the 4-step command (this example is using an 8-step command).
   - Add array of electromagnet combinations to simplify cw and ccw implementation
   + Added reverse order of the write statements for ccw rotation (8-step command)
   - delayMicroseconds(805);
   Played with delay settings
   - delayMicroseconds(805) shows missing steps
   - delay with 1 ms and higher value runs save.
   Replaced the blocking move with nin blocking one.
   
   Boards:
    Arduino UNO
    Digispark (default)-16.5mhz
*/

#define USE_SERIAL

/* Digispark uses P3 nd P4 for serial */
#ifdef ARDUINO_AVR_DIGISPARK
#undef USE_SERIAL
#endif

namespace LinearActuator {
#ifdef ARDUINO_AVR_DIGISPARK
/* Digispark PCINT1 - PCINT4 (PCINT5 / RESET failed to use) */
#define A 1 /* IN1 */
#define B 2 /* IN2 */
#define C 3 /* IN3 */
#define D 4 /* IN4 */
#else /* UNO et all */
#define A 2 /* IN1 */
#define B 3 /* IN2 */
#define C 4 /* IN3 */
#define D 5 /* IN4 */
#endif
/* The number of micro steps used for 360° */
#define NUMBER_OF_STEPS_PER_REV 512
/*
   We have a gear with 12 teeth
   A single tooth is 360° / 12 = 30°
   The number of steps used for 30° is 512 / 12 = 42 2/3
   The linear actuator has 10 teeth
   The number of steps used is 512 * 10 / 12 = 426 2/3
*/
#define NUMBER_OF_STEPS_USED 426
void setup() {
  pinMode(A, OUTPUT);
  pinMode(B, OUTPUT);
  pinMode(C, OUTPUT);
  pinMode(D, OUTPUT);
}

void write(int a, int b, int c, int d) {
  digitalWrite(A, a);
  digitalWrite(B, b);
  digitalWrite(C, c);
  digitalWrite(D, d);
}

/* Suggestion:
   use millis instead of delay()
*/
void wait_microstep_done(int n=2) {
  /* Suggestion:
      delayMicroseconds(805);
     - Get some noise with this settings
     - motor sometimes not starting when switching from cw to ccw
  */
  // delayMicroseconds(805);
  delay(n); /* >= 2ms works save */
}
/* Suggestion:
    I also added at the end of the step:
    write(0,0,0,0);
    delay(5);
    this to avoid current running if you stop after one step.
*/
void stop_step() {
  write(0, 0, 0, 0);
  wait_microstep_done();
}
/* Suggestion:
    You can use the 4-step command (this example is using an 8-step command).
    Basically keep only the lines in the cwstep() function that actuate two pins simultaneously.
   TODO: I get more vibrations when using 4 steps only.
*/
void cwstep_4steps() {
  write(1, 1, 0, 0);
  wait_microstep_done();
  write(0, 1, 1, 0);
  wait_microstep_done();
  write(0, 0, 1, 1);
  wait_microstep_done();
  write(1, 0, 0, 1);
  wait_microstep_done();
}
/* Suggestion:
    //add all electromagnet combinations here
    int microsteps[] = {1,0,0,0, 1,1,0,0, 0,1,0,0, 0,1,1,0, 0,0,1,0, 0,0,1,1, 0,0,0,1, 1,0,0,1};
    //Reverses direction when changed
    bool stepdirection = true;
*/
void cwstep_8steps() {
  write(1, 0, 0, 0);
  wait_microstep_done();
  write(1, 1, 0, 0);
  wait_microstep_done();
  write(0, 1, 0, 0);
  wait_microstep_done();
  write(0, 1, 1, 0);
  wait_microstep_done();
  write(0, 0, 1, 0);
  wait_microstep_done();
  write(0, 0, 1, 1);
  wait_microstep_done();
  write(0, 0, 0, 1);
  wait_microstep_done();
  write(1, 0, 0, 1);
  wait_microstep_done();
}
/* clockwise rotation */
#define MICRO_STEPS 8
void cwstep() {
  if (MICRO_STEPS == 4)
    cwstep_4steps();
  else
    cwstep_8steps();
}
/* Suggestion:
    make a new subroutine, copy the onestep() and call it something else. (for example reversestep())
    Then reverse the order of the write statement.
    So the last write becomes the first write and the second to last write becomes the second write...
    and so on, until they are all swapped.
*/
void ccwstep_8steps() {
  write(1, 0, 0, 1);
  wait_microstep_done();
  write(0, 0, 0, 1);
  wait_microstep_done();
  write(0, 0, 1, 1);
  wait_microstep_done();
  write(0, 0, 1, 0);
  wait_microstep_done();
  write(0, 1, 1, 0);
  wait_microstep_done();
  write(0, 1, 0, 0);
  wait_microstep_done();
  write(1, 1, 0, 0);
  wait_microstep_done();
  write(1, 0, 0, 0);
  wait_microstep_done();
  /* the start */
}

/* counter clockwise rotation */
void ccwstep() {
  ccwstep_8steps();
}
}

/*
 * LimitSwithes used in N(ormally) O(open mode)
 * Connections used
 * - C  VCC
 * - NO Arduino input pin (with pulldown)
 * - NC not connected
 * If the switch is open, we define the value to be LOW.
 * If the switch is closed, we define the value to be HIGH.
 * This reads like to logical setup. 
 * - But we have to provide an externel PULLDOWN (10k) resistor for it.
 * Reduced component setup
 * - C  GND
 * - NO Arduino input pin (with pullup)
 * - NC not connected
 * If the switch is open, we define the value to be HIGH.
 * If the switch is closed, we define the value to be LOW.
 * You may use pinMode(x, INPUT_PULLUP)
 */
namespace LimitSwitches
{
#define LIMIT_CLOSE 6
#define LIMIT_OPEN  7

void setup() {
  pinMode(LIMIT_CLOSE, INPUT);
  pinMode(LIMIT_OPEN, INPUT);
}
int closed(int pin) {
  /* TODO: need a debounced read here */
  return digitalRead(pin) == HIGH;
}
}

/*
 * Push button to start open/close operation.
 * Button uses pulldown resisitor (10k)
 * - we get a LOW, when the button is not pressed
 * - we get a HIGH, when the button is pressed
 */
namespace StartButton
{
#define START_BUTTON 8

void setup() {
  pinMode(START_BUTTON, INPUT);
}
int pressed(int pin) {
  if (digitalRead(pin) == HIGH) {
    while (digitalRead(pin) == HIGH)
      delay(10);
    return HIGH;
  }
  return LOW;
}
}

void setup() {
#ifdef USE_SERIAL
  Serial.begin(115200);
#endif
  LinearActuator::setup();
  LimitSwitches::setup();
  StartButton::setup();

#ifdef USE_SERIAL
  Serial.println("Linear Actuator");
#endif
}

/* machine states */
#define LOOP_CCW     0  /* stepper in CCW rotation */
#define LOOP_CW      1  /* stepper in aCW rotation */
#define LOOP_CHECK   2  /* waiting for use input */
#define LOOP_OPERATE 3  /* select open / close operation */
#define LOOP_OPEN    4  /* executing open operation */  
#define LOOP_CLOSE   5  /* executing close operation */

int loop_ccw(int steps, int stop=0) {
  static int i = 0;
  if (stop) {
    i = 0;
    LinearActuator::stop_step();
    return LOOP_CW;
  }
  if (i < steps/*NUMBER_OF_STEPS_PER_REV*/) {
    LinearActuator::ccwstep();
    i++;
    return LOOP_CCW;
  }
  LinearActuator::stop_step();
  return LOOP_CW;
}
int loop_cw(int steps, int stop=0) {
  static int i = 0;
  if (stop) {
    i = 0;
    LinearActuator::stop_step();
    return LOOP_CW;
  }
  if (i < steps/*NUMBER_OF_STEPS_PER_REV*/) {
    LinearActuator::cwstep();
    i++;
    return LOOP_CW;
  }
  LinearActuator::stop_step();
  return LOOP_CCW;
}

int loop_check()
{
  int pressed = StartButton::pressed(START_BUTTON);

#ifdef USE_SERIAL
  Serial.print("CLOSE="); Serial.println(LimitSwitches::closed(LIMIT_CLOSE));
  Serial.print("OPEN ="); Serial.println(LimitSwitches::closed(LIMIT_OPEN));
  Serial.print("MOVE ="); Serial.println(pressed);
#endif

  if (pressed)
    return LOOP_OPERATE;
  /* keep checking for some input */
  delay(50);
  return LOOP_CHECK;
}

int loop_operate() {
  int closedPosition = LimitSwitches::closed(LIMIT_CLOSE);
  if (closedPosition)
    return LOOP_OPEN;
  int openedPosition = LimitSwitches::closed(LIMIT_OPEN);
  if (openedPosition)
    return LOOP_CLOSE;

  /* if no switch is closed we're somewhere in the middle, close it */
  return LOOP_CLOSE;
}

int loop_open() {
  static int steps = NUMBER_OF_STEPS_USED;
  int openedPosition = LimitSwitches::closed(LIMIT_OPEN);
  if (! openedPosition) {
    int state = loop_ccw(steps);
    if (state == LOOP_CCW)
      return LOOP_OPEN;
    /* FALLTHRU: if we're at the end of max steps, stop the motor */
  }
  /* no nore steps */
  loop_ccw(steps, 1);
  return LOOP_CHECK;
}

int loop_close() {
  static int steps = NUMBER_OF_STEPS_USED;
  int closedPosition = LimitSwitches::closed(LIMIT_CLOSE);
  if (! closedPosition) {
    int state = loop_cw(steps);
    if (state == LOOP_CW)
      return LOOP_CLOSE;
    /* FALLTHRU: if we're at the end of max steps, stop the motor */
  }
  loop_cw(steps, 1);
  /* no nore steps */
  return LOOP_CHECK;
}

void loop() {
  static int state = LOOP_CHECK;
  static int steps = NUMBER_OF_STEPS_USED - 8;
  if (state == LOOP_CHECK)
    state = loop_check();
  else if (state == LOOP_OPERATE)
    state = loop_operate();
  else if (state == LOOP_OPEN)
    state = loop_open();
  else if (state == LOOP_CLOSE)
    state = loop_close();
  else if (state == LOOP_CCW)
    state = loop_ccw(steps);
  else if (state == LOOP_CW)
    state = loop_cw(steps);
}
