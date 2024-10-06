/*
 * quadruped_walk.h - quadruped walking
 * 
 * Move the quadruped fromward by moving opposite legs
 *
 */

#ifndef QUADRUPED_WALK_H
#define QUADRUPED_WALK_H

#include "quadruped_home.h"

uint16_t walk_elbow_offset = 30;
uint16_t walk_humerus_offset = 30;

namespace left {
  namespace front {
    namespace elbow_joint {
      //uint16_t step_pos = 450;  // home_pos = 420;
      void step_forward() { set_pos(home_pos+walk_elbow_offset); }
    }
    namespace humerus_joint {
      //uint16_t step_pos = 330;  // home_pos = 360;
      void step_forward() { set_pos(home_pos-walk_humerus_offset); }
    }
    void step_forward(unsigned long ms) {
      start_smooth(); 
      elbow_joint::step_forward();
      delay(ms);
      humerus_joint::step_forward();
      delay(ms);
      elbow_joint::home();
      delay(ms);
      end_smooth();
    }
    void move_body_forward() {
      humerus_joint::home();
    }
  }
  namespace rear {
    namespace elbow_joint {
      //uint16_t step_pos = 430; // home_pos = 400; 
      void step_forward() { set_pos(home_pos+walk_elbow_offset); }
    }
    namespace humerus_joint {
      //uint16_t step_pos = 470; // home_pos = 450
      void step_forward() { set_pos(home_pos-walk_humerus_offset); }
    }
    void step_forward(unsigned long ms) {
      start_smooth(); 
      elbow_joint::step_forward();
      delay(ms);
      humerus_joint::step_forward();
      delay(ms);
      elbow_joint::home();
      delay(ms);
      end_smooth();
    }
    void move_body_forward() {
      humerus_joint::home();
    }
  }
}
namespace right {
  namespace rear {
    namespace elbow_joint {
      //uint16_t step_pos = 210;  // home_pos = 240;
      void step_forward() { set_pos(home_pos-walk_elbow_offset); }
    }
    namespace humerus_joint {
      //uint16_t step_pos = 250;  // home_pos = 220;
      void step_forward() { set_pos(home_pos+walk_humerus_offset); }
    }
    void step_forward(unsigned long ms) {
      start_smooth(); 
      elbow_joint::step_forward();
      delay(ms);
      humerus_joint::step_forward();
      delay(ms);
      elbow_joint::home();
      delay(ms);
      end_smooth();
    }
    void move_body_forward() {
      humerus_joint::home();
    }
  }
  namespace front {
    namespace elbow_joint {
      //uint16_t step_pos = 160; // home_pos = 190
      void step_forward() { set_pos(home_pos-walk_elbow_offset); }
    }
    namespace humerus_joint {
      //uint16_t step_pos = 260;  // home_pos = 230
      void step_forward() { set_pos(home_pos+walk_humerus_offset); }
    }
    void step_forward(unsigned long ms) {
      start_smooth(); 
      elbow_joint::step_forward();
      delay(ms);
      humerus_joint::step_forward();
      delay(ms);
      elbow_joint::home();
      delay(ms);
      end_smooth();
    }
    void move_body_forward() {
      humerus_joint::home();
    }
  }
}

void move_body(unsigned long ms) {
  //start_sync();

  right::front::move_body_forward();
  left::front::move_body_forward();
  left::rear::move_body_forward();
  right::rear::move_body_forward();
  
  //execute_sync();
  delay(ms);
}

void walk_left_right(unsigned long ms) {
  left::front::step_forward(ms);
  right::rear::step_forward(ms);  
}

void walk_right_left(unsigned long ms) {
  right::front::step_forward(ms);
  left::rear::step_forward(ms);
}

void walk(unsigned long ms) {
  walk_left_right(ms);
  move_body(ms);
  walk_right_left(ms);
}

#endif
