/*
 * quadruped_move.h: Quadruped move things
 * 
 * Move motors by setting/smooting the PWN operation
 */

#ifndef QUADRUPED_MOVE_H
#define QUADRUPED_MOVE_H

uint8_t sync_move = 0;
uint8_t sync_count = 0;
struct sync_list_t {
  uint8_t num;
  uint16_t from; 
  uint16_t to; 
  uint16_t *curve;
} sync_list[8];

void start_sync() { 
  sync_count = 0;
  sync_move = 1; 
}
void execute_sync() {
  sync_move = 0;
  for (int i = 0; i < 12; i++) {
    for (int j = 0; j < sync_count; j++)  {
      if (sync_list[j].from == 0) {
        servoDriver_module.setPWM(sync_list[j].num, 0, sync_list[j].to);
      } else if (sync_list[j].from < sync_list[j].to) {
        servoDriver_module.setPWM(sync_list[j].num, 0, sync_list[j].from+sync_list[j].curve[i]);
      } else if (sync_list[j].from > sync_list[j].to) {
        servoDriver_module.setPWM(sync_list[j].num, 0, sync_list[j].from-sync_list[j].curve[i]);
      }
      delay(20);  // minimum time between 2 commands
    }
  }
}

void add_move(uint8_t num, uint16_t from, uint16_t to, uint16_t* curve) {
  if (sync_count >= 8)
    return;
  sync_list[sync_count].num = num;
  sync_list[sync_count].from = from;
  sync_list[sync_count].to = to;
  sync_list[sync_count].curve = curve;
  sync_count++;
}

uint16_t smooth_curve_15[12] = {1, 2,  4,  6,  7,  8,  8,  9, 10, 12, 14, 15};
uint16_t smooth_curve_20[12] = {1, 2,  4,  8,  9, 10, 11, 12, 16, 18, 19, 20};
uint16_t smooth_curve_30[12] = {1, 3,  6, 12, 14, 15, 16, 18, 24, 27, 28, 30};
uint16_t find_curve(uint16_t from, uint16_t to) {
  if (abs(to-from) == 15) {
    return smooth_curve_15;
  }
  else if (abs(to-from) == 20) {
    return smooth_curve_20;
  }
  else if (abs(to-from) == 30) {
    return smooth_curve_30; 
  }
}

uint16_t smooth_forward(uint8_t num, uint16_t from, uint16_t to, uint16_t* curve) {
  if (to-from == 50) {
    for (int i = 0; i < 12; i++) {
      servoDriver_module.setPWM(num, 0, from+curve[i]);
      delay(5);
    }
  } else
    servoDriver_module.setPWM(num, 0, to);
}
uint16_t smooth_backward(uint8_t num, uint16_t from, uint16_t to, uint16_t* curve) {
  if (from-to == 50) {
    for (int i = 0; i < 12; i++) {
      servoDriver_module.setPWM(num, 0, from-curve[i]);
      delay(5);
    }
  } else
    servoDriver_module.setPWM(num, 0, to);
}

uint8_t smooth_move = 1;
void start_smooth() { smooth_move = 1; }
void end_smooth() { smooth_move = 0; }

uint16_t move_smooth(uint8_t num, uint16_t from, uint16_t to, uint16_t* curve) {
  if (from == 0) {
    servoDriver_module.setPWM(num, 0, to);
  } else if (from < to) {
    smooth_forward(num, from, to, curve);
  } else if (from > to) {
    smooth_backward(num, from, to, curve);
  }
  return to;  
}

uint16_t move_to(uint8_t num, uint16_t from, uint16_t to) {
  if (smooth_move) {
    move_smooth(num, from, to, find_curve(from, to));
  } else if (sync_move) {
    add_move(num, from, to, find_curve(from, to));  
  } else {
    servoDriver_module.setPWM(num, 0, to);
  }
  return to;
}

#endif
