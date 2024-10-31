/*
 * quadruped_home.h - quaduped home positioning
 */

#ifndef QUADRUPED_HOME_H
#define QUADRUPED_HOME_H

#include "quadruped_move.h"

namespace left {
  namespace front {
    namespace elbow_joint {
      uint8_t num = 0;
      uint16_t last_pos = 0;
      uint16_t home_pos = 420;
      void set_pos(uint16_t pos) {
        last_pos = move_to(num, last_pos, pos);
      }
      void init() { last_pos = 0; }
      void home() { set_pos(home_pos); }
    }
    namespace humerus_joint {
      uint8_t num = 1;
      uint16_t last_pos = 0;
      uint16_t home_pos = 340;
      void set_pos(uint16_t pos) {
        last_pos = move_to(num, last_pos, pos);
      }
      void init() { last_pos = 0; }
      void home() { set_pos(home_pos); }
    }
    namespace scapula {
      uint8_t num = 2;
      uint16_t last_pos = 0;
      uint16_t home_pos = 335; // 350;
      void set_pos(uint16_t pos) {
        last_pos = move_to(num, last_pos, pos);
      }
      void init() { last_pos = 0; }
      void home() { set_pos(home_pos); }
    }
    void init() {
      elbow_joint::init();
      humerus_joint::init();
      scapula::init();     
    }
    void home() {
      elbow_joint::home();
      humerus_joint::home();
      scapula::home();
    }
  }
  namespace rear {
    namespace elbow_joint {
      uint8_t num = 4;
      uint16_t last_pos = 0;
      uint16_t home_pos = 400;
      void set_pos(uint16_t pos) {
        last_pos = move_to(num, last_pos, pos);
      }
      void init() { last_pos = 0; }
      void home() { set_pos(home_pos); }
    }
    namespace humerus_joint {
      uint8_t num = 5;
      uint16_t last_pos = 0;
      uint16_t home_pos = 440;  // was 450
      void set_pos(uint16_t pos) {
        last_pos = move_to(num, last_pos, pos);
      }
      void init() { last_pos = 0; }
      void home() { set_pos(home_pos); }
    }
    namespace scapula {
      uint8_t num = 6;
      uint16_t last_pos = 0;
      uint16_t home_pos = 280;
      void set_pos(uint16_t pos) {
        last_pos = move_to(num, last_pos, pos);
      }
      void init() { last_pos = 0; }
      void home() { set_pos(home_pos); }
    }
    void init() {
      elbow_joint::init();
      humerus_joint::init();
      scapula::init();     
    }
    void home() {
      elbow_joint::home();
      humerus_joint::home();
      scapula::home();
    }
  }
}
namespace right {
  namespace rear {
    namespace elbow_joint {
      uint8_t num = 8;
      uint16_t last_pos = 0;
      uint16_t home_pos = 240;
      void set_pos(uint16_t pos) {
        last_pos = move_to(num, last_pos, pos);
      }
      void init() { last_pos = 0; }
      void home() { set_pos(home_pos); }
    }
    namespace humerus_joint {
      uint8_t num = 9;
      uint16_t last_pos = 0;
      uint16_t home_pos = 220;
      void set_pos(uint16_t pos) {
        last_pos = move_to(num, last_pos, pos);
      }
      void init() { last_pos = 0; }
      void home() {set_pos(home_pos); }
    }
    namespace scapula {
      uint8_t num = 10;
      uint16_t last_pos = 0;
      uint16_t home_pos = 350; // 340;
      void set_pos(uint16_t pos) {
        last_pos = move_to(num, last_pos, pos);
      }
      void init() { last_pos = 0; }
      void home() { set_pos(home_pos); }
    }
    void init() {
      elbow_joint::init();
      humerus_joint::init();
      scapula::init();     
    }
    void home() {
      elbow_joint::home();
      humerus_joint::home();
      scapula::home();
    }
  }
  namespace front {
    namespace elbow_joint {
      uint8_t num = 12;
      uint16_t last_pos = 0;
      uint16_t home_pos = 190;
      void set_pos(uint16_t pos) {
        last_pos = move_to(num, last_pos, pos);
      }
      void init() { last_pos = 0; }
      void home() { set_pos(home_pos); }
    }
    namespace humerus_joint {
      uint8_t num = 13;
      uint16_t last_pos = 0;
      uint16_t home_pos = 230; 
      void set_pos(uint16_t pos) {
        last_pos = move_to(num, last_pos, pos);
      }
      void init() { last_pos = 0; }
      void home() { set_pos(home_pos); }
    }
    namespace scapula {
      uint8_t num = 14;
      uint16_t last_pos = 0;
      uint16_t home_pos = 270; // 260
      void set_pos(uint16_t pos) {
        last_pos = move_to(num, last_pos, pos);
      }
      void init() { last_pos = 0; }
      void home() { set_pos(home_pos); }
    }
    void init() {
      elbow_joint::init();
      humerus_joint::init();
      scapula::init();     
    }
    void home() {
      elbow_joint::home();
      humerus_joint::home();
      scapula::home();
    }
  }
}

void home() {
  left::front::init();
  left::rear::init();
  right::rear::init();
  right::front::init();

  left::front::home();
  left::rear::home();
  right::rear::home();
  right::front::home();
}

#endif