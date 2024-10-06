// robot_poses.scad
//
// some poses for the qudruped robot
//

use <QuadrupedRobot.scad>

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

$vpt = [116.387, 41.5, -49.2779];
$vpr =  [55+10, 0, -90+25];
// TODO: verify other poses
robot(mount_pose());
echo($vpt);
echo($vpr);
