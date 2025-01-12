/*
 * quadruped_legs.h - defines legs based movements for the quadruped
 * 
 * Steps 2 legs (synchronous) to a new posiition.
 * 
 * TODO: 
 *	almost sync as sync fails with unknowon reason affects trot and gallop
 */

#ifndef QUADRUPED_LEGS_H
#define QUADRUPED_LEGS_H

#include <quadruped_move.h>
#include <quadruped_home.h>

namespace legs
{

/* step left front and right back leg forward synchronously */
void step_left_right_forward(unsigned long ms) {
  start_sync();
  left::front::elbow_joint::step_forward();
  right::rear::elbow_joint::step_forward();
  execute_sync();
  delay(ms);
//  start_sync();
// almost sync 
  left::front::humerus_joint::step_forward();
  right::rear::humerus_joint::step_forward();
//  execute_sync();
  delay(ms);
  start_sync();
  left::front::elbow_joint::home();
  right::rear::elbow_joint::home();
  execute_sync();
  delay(ms);
}

/* step right front and left back leg forward synchronously */
void step_right_left_forward(unsigned long ms) {
  start_sync();
  right::front::elbow_joint::step_forward();
  left::rear::elbow_joint::step_forward();
  execute_sync();
  delay(ms);
  start_sync();
  right::front::humerus_joint::step_forward();
  left::rear::humerus_joint::step_forward();
  execute_sync();
  delay(ms);
  start_sync();
  right::front::elbow_joint::home();
  left::rear::elbow_joint::home();
  execute_sync();
  delay(ms);
}

/* step left legs forward synchronously */
void step_left_forward(unsigned long ms) {
  start_sync();
  left::front::elbow_joint::step_forward();
  left::rear::elbow_joint::step_forward();
  execute_sync();
  delay(ms);
  start_sync();
  left::front::humerus_joint::step_forward();
  left::rear::humerus_joint::step_forward();
  execute_sync();
  delay(ms);
  start_sync();
  left::front::elbow_joint::home();
  left::rear::elbow_joint::home();
  execute_sync();
  delay(ms);
}

/* step right legs forward synchronously */
void step_right_forward(unsigned long ms) {
  start_sync();
  right::front::elbow_joint::step_forward();
  right::rear::elbow_joint::step_forward();
  execute_sync();
  delay(ms);
  start_sync();
  right::front::humerus_joint::step_forward();
  right::rear::humerus_joint::step_forward();
  execute_sync();
  delay(ms);
  start_sync();
  right::front::elbow_joint::home();
  right::rear::elbow_joint::home();
  execute_sync();
  delay(ms);
}

/* step front legs forward synchronously */
void step_front_forward(unsigned long ms) {
  start_sync();
  left::front::elbow_joint::step_forward();
  right::front::elbow_joint::step_forward();
  execute_sync();
  delay(ms);
  start_sync();
  left::front::humerus_joint::step_forward();
  right::front::humerus_joint::step_forward();
  execute_sync();
  delay(ms);
  start_sync();
  left::front::elbow_joint::home();
  right::front::elbow_joint::home();
  execute_sync();
  delay(ms); 
}

/* step back legs forward synchronously */
void step_back_forward(unsigned long ms) {
  start_sync();
  left::rear::elbow_joint::step_forward();
  right::rear::elbow_joint::step_forward();
  execute_sync();
  delay(ms);
  start_sync();
  left::rear::humerus_joint::step_forward();
  right::rear::humerus_joint::step_forward();
  execute_sync();
  delay(ms);
  start_sync();
  left::rear::elbow_joint::home();
  right::rear::elbow_joint::home();
  execute_sync();
  delay(ms);   
}

}

#endif
