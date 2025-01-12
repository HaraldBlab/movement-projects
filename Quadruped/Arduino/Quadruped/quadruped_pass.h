/*
 * quadruped_pass.h - quadruped pass gait
 * 
 * Move the quadruped using pass gait
 * pass - left left and right right like an elefant, a giraffe, a camel, a bear
 * 
 */

#ifndef QUADRUPED_PASS_H
#define QUADRUPED_PASS_H

#include <quadruped_walk.h>
#include <quadruped_body.h>
#include <quadruped_legs.h>

void pass_left(unsigned long ms) {
  legs::step_left_forward(ms);
  body::move_left_forward(ms);
  
  legs::step_right_forward(ms);    
  body::move_right_forward(ms);
}
void pass_right(unsigned ms) {
  legs::step_right_forward(ms);
  body::move_right_forward(ms);
  
  legs::step_left_forward(ms);
  body::move_left_forward(ms);
}

#endif
