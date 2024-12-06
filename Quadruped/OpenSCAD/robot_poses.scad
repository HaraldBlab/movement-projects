// robot_poses.scad
//
// some poses for the qudruped robot
//

use <QuadrupedRobot.scad>
use <robot_legs.scad>

$vpt = [116.387, 41.5, -49.2779];
$vpr =  [55+10, 0, -90+25];

current_pose = mount_pose();
robot(current_pose);
//robot_leg_left(0,0,current_pose[0]);
echo(vpt=$vpt);
echo(vpr=$vpr);
