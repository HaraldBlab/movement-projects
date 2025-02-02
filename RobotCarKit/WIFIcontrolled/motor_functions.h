/*
 * motor_functions.h - Obstacle detetcion functions
 * extracted from RobitCarKit obstacleAvoid sample.
 * 
 * Two DC motors driven by a L298N motor driver.
 */

// motors
/*
// Motor 1
int motor1Pin1 = 27; 
int motor1Pin2 = 26; 
int enable1Pin = 14;

// Motor 2
int motor2Pin1 = 33; 
int motor2Pin2 = 25; 
int enable2Pin = 32;
*/
// Setting PWM properties
const int freq = 30000;
const int resolution = 8;
int dutyCycle = 0;


#define Lpwm_pin  14    //pin of controlling speed---- ENA of motor driver board
#define Rpwm_pin  32    //pin of controlling speed---- ENB of motor driver board
int pinLB = 27;         //pin of controlling turning---- IN1 of motor driver board
int pinLF = 26;         //pin of controlling turning---- IN2 of motor driver board
int pinRB = 33;         //pin of controlling turning---- IN3 of motor driver board
int pinRF = 25;         //pin of controlling turning---- IN4 of motor driver board
unsigned char Lpwm_val = 120; //initialized left wheel speed at 250
unsigned char Rpwm_val = 120; //initialized right wheel speed at 250
// vehicle using motors
int Car_state = 0;           //the working state of car

/* Initialize the motor control */
void M_Control_IO_config(void)
{
  // Set the Motor pins as outputs
  pinMode(pinLB, OUTPUT);
  pinMode(pinLF, OUTPUT);
  pinMode(pinRB, OUTPUT);
  pinMode(pinRF, OUTPUT);

  // Configure PWM Pins
  ledcAttach(Lpwm_pin, freq, resolution);
  ledcAttach(Rpwm_pin, freq, resolution);
    
  // Initialize PWM with 0 duty cycle
  ledcWrite(Lpwm_pin, 0);
  ledcWrite(Rpwm_pin, 0);

}

void Set_Speed(unsigned char Left, unsigned char Right) //function of setting speed
{
  analogWrite(Lpwm_pin, Left);
  analogWrite(Rpwm_pin, Right);
}

void set_speed(int value)
{
  if (value == 0) {
    ledcWrite(Lpwm_pin, 0);
    ledcWrite(Rpwm_pin, 0);
    digitalWrite(pinLB, LOW); 
    digitalWrite(pinLF, LOW); 
    digitalWrite(pinRB, LOW);
    digitalWrite(pinRF, LOW);   
  } else { 
    dutyCycle = map(value, 25, 100, 200, 255);
    ledcWrite(Lpwm_pin, dutyCycle);
    ledcWrite(Rpwm_pin, dutyCycle);
  }
}

void back()
{
  digitalWrite(pinRB, LOW);
  digitalWrite(pinRF, HIGH);
  digitalWrite(pinLB, LOW);
  digitalWrite(pinLF, HIGH);
  Car_state = 1;
}
void turnR()
{
  digitalWrite(pinRB, LOW);
  digitalWrite(pinRF, HIGH);
  digitalWrite(pinLB, HIGH);
  digitalWrite(pinLF, LOW);
  Car_state = 4;
}
void turnL()
{
  digitalWrite(pinRB, HIGH);
  digitalWrite(pinRF, LOW );
  digitalWrite(pinLB, LOW);
  digitalWrite(pinLF, HIGH);
  Car_state = 3;
}
void stopp()
{
  digitalWrite(pinRB, HIGH);
  digitalWrite(pinRF, HIGH);
  digitalWrite(pinLB, HIGH);
  digitalWrite(pinLF, HIGH);
  Car_state = 5;
}
void advance()
{
  digitalWrite(pinRB, HIGH);
  digitalWrite(pinRF, LOW);
  digitalWrite(pinLB, HIGH);
  digitalWrite(pinLF, LOW);
  Car_state = 2;
}
