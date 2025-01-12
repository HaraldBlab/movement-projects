/*
 * quadruped_hop.h - quadruped hop movement
 * 
 * Move the quadruped using hop gait
 * hop - front legs and back legs like a rabbit
 * 
 * TODO:
 * rear legs positioned before front legs?
 * 
 */

#ifndef QUADRUPED_HOP_H
#define QUADRUPED_HOP_H

#include <quadruped_walk.h>
#include <quadruped_body.h>
#include <quadruped_legs.h>

void hop(unsigned long ms) {
  legs::step_front_forward(ms);
  legs::step_back_forward(ms);
  body::move_forward(ms);
}
#endif
