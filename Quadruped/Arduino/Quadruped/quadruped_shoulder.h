/*
 * quadruped_shoulder.h - quaduped shoulder movement
 * 
 * Move the quadruped shoulders to make the quadruped swing left and right
 * 
 * TODO: using swing_offset 50 shows invalid sync movement (timing constraints) 
 * TODO: swing_front and swing_back?
 */

#ifndef QUADRUPED_SHOULDER_H
#define QUADRUPED_SHOULDER_H

#include "quadruped_home.h"

uint16_t swing_offset = 15;

namespace left {
  namespace front {
    namespace scapula {
      void swing_right() { set_pos(home_pos+swing_offset); }
      void swing_left() { set_pos(home_pos-swing_offset); }
    }
  }
  namespace rear {
    namespace scapula {
      void swing_right() { set_pos(home_pos-swing_offset); }
      void swing_left() { set_pos(home_pos+swing_offset); }
    }
  }
}
namespace right {
  namespace rear {
    namespace scapula {
      void swing_right() { set_pos(home_pos-swing_offset); }
      void swing_left() { set_pos(home_pos+swing_offset); }
    }
  }
  namespace front {
    namespace scapula {
      void swing_right() { set_pos(home_pos+swing_offset); }
      void swing_left() { set_pos(home_pos-swing_offset); }
    }
  }
}

void swing_right() {
  start_sync();
  
  left::front::scapula::swing_right();
  left::rear::scapula::swing_right();
  right::rear::scapula::swing_right();
  right::front::scapula::swing_right();

  execute_sync();
}
void swing_left() {
  start_sync();
  
  left::front::scapula::swing_left();
  left::rear::scapula::swing_left();
  right::rear::scapula::swing_left();
  right::front::scapula::swing_left();

  execute_sync();
}

void swing_home() {
  start_sync();
  
  left::front::scapula::home();
  left::rear::scapula::home();
  right::rear::scapula::home();
  right::front::scapula::home();
  
  execute_sync();  
}

void shoulder(unsigned ms) {
  swing_right();
  delay(ms);

  swing_home();
  delay(ms);

  swing_left();
  delay(ms);

  swing_home();
  delay(ms);
}

#endif
