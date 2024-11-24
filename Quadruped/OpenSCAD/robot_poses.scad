// robot_poses.scad
//
// some poses for the qudruped robot
//

use <QuadrupedRobot.scad>
use <robot_legs.scad>

function mount_pose() = [
    [0,33,-67],
    [0,33,-67],
    [0,33,-67],
    [0,33,-67]
];
function straight_pose() = [
    [0,0,0],
    [0,0,0],
    [0,0,0],
    [0,0,0]
];
function sphinx_pose() = [
    [0,60,85],
    [0,60,85],
    [0,60,85],
    [0,60,85]
];
function left_front_pose() = [
    [10,-25,30],
    [0,33,-67],
    [0,33,-67],
    [0,33,-67]
];
function right_front_pose() = [
    [0,33,-67],
    [10,-25,30],
    [0,33,-67],
    [0,33,-67]
];
function left_back_pose() = [
    [0,33,-67],
    [0,33,-67],
    [10,-25,30],
    [0,33,-67]
];
function right_back_pose() = [
    [0,33,-67],
    [0,33,-67],
    [0,33,-67],
    [10,-25,30]
];


use <animate_walk.scad>

$vpt = [116.387, 41.5, -49.2779];
$vpr =  [55+10, 0, -90+25];
echo(current_pose);
current_pose = mount_pose();

echo(current_pose);
robot(current_pose);
//robot_leg_left(0,0,current_pose[0]);
echo($vpt);
echo($vpr);
