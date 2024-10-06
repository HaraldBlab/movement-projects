// Quadruped.scad
// Souece of inspiration
// https://www.az-delivery.de/blogs/azdelivery-blog-fur-arduino-und-raspberry-pi/vierbeiniger-roboter-mit-pca9685-und-12-servomotoren

use <robot_body.scad>
use <robot_legs.scad>

function mount_pose() = [
    [0,33,33],
    [0,33,33],
    [0,33,33],
    [0,33,33]
];


// material is 3mm thick
material = 3; // material thickness [mm]

module robot_legs(pose) {
  // front legs
  translate([37+38/2,0, (31-3)/2]) {
    translate([0,31/2,0]) 
    robot_leg_front_left(pose[0]);
    translate([0,83-31/2,0])
    robot_leg_front_right(pose[1]);
  }
  // back legs
  translate([210-11-38/2,0, (31-3)/2]) {
    translate([0,31/2,0]) 
    robot_leg_back_left(pose[2]);
    translate([0,83-31/2,0])
    robot_leg_back_right(pose[3]);
  }
}


module robot(pose=mount_pose()) {
  robot_body(cover=true, front=true);
  robot_legs(pose);
}
robot();
