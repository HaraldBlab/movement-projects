// QuadrupedRobot_print.scad
// prepare QuadrupedRobot for printing

use <robot_legs.scad>
use <robot_body.scad>

*robot_leg_front_left(pose=[0,0,0]);

module print_robot_ulna(left=true) 
{
  ry=left?1.0:-1.0;
  scale([1,ry,1]) 
  ulna();
}
// 2 left and 2 right
*print_robot_ulna(left=true);
*print_robot_ulna(left=false);

module print_robot_humerus(left=true) 
{
  ry=left?-1.0:1.0;
  scale([1,ry,1])
  humerus();

}
// 2 left and 2 right
*print_robot_humerus(left=true);
*print_robot_humerus(left=false);

module print_robot_scapula(front=true) 
{
  ry=front?0:180;
  rotate([90,0,0]) // rotate back for printing
  rotate([-90,ry,0]) 
  scapula();
}
// 2 front and 2 back
*print_robot_scapula(front=true);
*print_robot_scapula(front=false);

// holders are scaled in the robot body design
*scale([-1,1,1]) front_left_leg_holder();
*scale([-1,1,1]) front_right_leg_holder();
*scale([-1,1,1]) back_left_leg_holder();
*scale([-1,1,1]) back_right_leg_holder();

// print the robot body as parts
*robot_body_front();
*robot_body_back();
*robot_body_middle(true);
*translate([(210-(38+6))/2,0,3])robot_body_middle(true);

// the front panel (distance holder)
*rotate([0,-90,0])hcsr04_holder();
// the robot body motor cover 
*robot_body_cover(true);

robot_body_design();

