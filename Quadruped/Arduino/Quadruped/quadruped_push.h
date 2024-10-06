/*
 * quadruped_push.h - quaduped pushups movement positioning
 */

#ifndef QUADRUPED_PUSH_H
#define QUADRUPED_PUSH_H

#include "quadruped_home.h"

uint16_t elbow_offset = 15;
uint16_t humerus_offset = 20;

namespace left {
  namespace front {
    namespace elbow_joint {
      void push() { set_pos(home_pos+elbow_offset); }
    }
    namespace humerus_joint {
      void push() { set_pos(home_pos+humerus_offset); }
    }
  }
  namespace rear {
    namespace elbow_joint {
      void push() { set_pos(home_pos+elbow_offset); }
    }
    namespace humerus_joint {
      void push() { set_pos(home_pos+humerus_offset); }
    }
  }
}
namespace right {
  namespace rear {
    namespace elbow_joint {
      void push() { set_pos(home_pos-elbow_offset); }
    }
    namespace humerus_joint {
      void push() { set_pos(home_pos-humerus_offset); }
    }
  }
  namespace front {
    namespace elbow_joint {
      void push() { set_pos(home_pos-elbow_offset); }
    }
    namespace humerus_joint {
      void push() { set_pos(home_pos-humerus_offset); }
    }
  }
}

// Sequence to lower the body
void lower_body() {
  start_sync();
  
  left::front::elbow_joint::push();
  right::front::elbow_joint::push();  
  left::rear::elbow_joint::push();
  right::rear::elbow_joint::push();

  left::front::humerus_joint::push();
  right::front::humerus_joint::push();
  left::rear::humerus_joint::push();
  right::rear::humerus_joint::push();
  
  execute_sync();
}

// Sequences to raise the body.
void raise_body() {
  start_sync();

  left::front::elbow_joint::home();
  right::front::elbow_joint::home();
  left::rear::elbow_joint::home();
  right::rear::elbow_joint::home();
  
  left::front::humerus_joint::home();
  right::front::humerus_joint::home();  
  left::rear::humerus_joint::home();
  right::rear::humerus_joint::home();
  
  execute_sync();
}

void pushups(unsigned long ms) {
  lower_body();
  delay(ms);

  raise_body();
  delay(ms);
}

#endif
 
