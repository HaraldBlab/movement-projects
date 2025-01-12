/*
 * quadruped_trot - trot sample for quadruped
 * 
 * trot - 4 phase: lr/rl/lr/rl contact to ground only in phases 1/3 
 *  
 * Based on:
 * Project for the construction of a Quadruped Robot.
 * Miguel Torres Gordo
 * Getafe (Madrid) - ESPAÑA          Last revision 22-09-2023
 * 
 * Board: Arduino Uno
 * Port: COM5
 */

#include <quadruped_body.h>
#include <quadruped_legs.h>

/* trot gait */
void trot(unsigned long ms) {
  legs::step_left_right_forward(ms);
  body::move_left_right_forward(ms);
  
  legs::step_right_left_forward(ms);
  body::move_right_left_forward(ms);
  
  legs::step_left_right_forward(ms);
  body::move_left_right_forward(ms);
  
  legs::step_right_left_forward(ms);
  body::move_right_left_forward(ms);
}


#ifndef QUADRUPED_TROT
#define QUADRUPED_TROT


#endif
