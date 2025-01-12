/*
 * quadruped_gallop.h - quadruped gallop gait
 * 
 * Move the quadruped using pass gait
 * gallop - 3 phase; right gallop: left back, right back and left front almost synchronous, right front, floating phase
 * 
 */

#ifndef QUADRUPED_GALLOP_H
#define QUADRUPED_GALLOP_H

void gallop_right(unsigned long ms) {
  /* phase 1 */
  left::rear::step_forward(ms);
  left::rear::home();
  delay(ms);
  /* phase 2 */
  legs::step_left_right_forward(ms);
  body::move_left_right_forward(ms);
  /* phase 3 */
  right::front::step_forward(ms);
  right::front::home();
  delay(ms);
  /* floating/suspension phase */
  delay(ms);
}
void gallop_left(unsigned long ms) {
  /* phase 1 */
  right::rear::step_forward(ms);
  right::rear::home();
  delay(ms);
  /* phase 2 */
  legs::step_right_left_forward(ms);
  body::move_right_left_forward(ms);
  /* phase 3 */
  left::front::step_forward(ms);
  left::front::home();
  delay(ms);
  /* floating/suspension phase */
  delay(ms);
}

#endif
