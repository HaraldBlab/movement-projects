// robot_legs_rotation.scad
// some (animatable) rotation calculation

// TODO: move this to simulation file
animate = true;

/*
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
function left_front_pose() = [
    [10,-25,30],
    [0,33,-67],
    [0,33,-67],
    [0,33,-67]
];
function left_back_pose() = [
    [0,33,33],
    [0,33,33],
    [10,-40,-20],
    [0,33,33]
];
function fly_front_pose() = [
    [10,-40,0],
    [10,-40,0],
    [0,33,-67],
    [0,33,-67]
];
function fly_back_pose() = [
    [0,33,-67],
    [0,33,-67],
    [10,-40,0],
    [10,-40,0]
];
function fly_pose() = [
    [10,-40,0],
    [10,-40,0],
    [10,-40,0],
    [10,-40,0]
];

ps = mount_pose();
pm = fly_front_pose();
pe = fly_pose();
*/

//use <animate_walk.scad>
//dp = walk_steps();
//pt = walk_points();

use <animate_trot.scad>

dp = trot_steps();
pt = trot_points();

function atback(i) = i<2?1.0:-1.0;

// TODO: move this to simulation file
function linear(i) = ps[i] + dp[i]*$t; 
function sinus(i) = ps[i] + dp[i]*sin(180*$t); 

function linear2(i) = 
    $t < 0.5
    ? ps[i] + dp[i]*$t*2
    : pm[i] + dp[i+4]*($t-0.5)*2; 

function linear3(i) = 
    $t < 1/3
    ? pt[0][i] + dp[i]*$t*3
    : $t < 2/3
    ? pt[1][i] + dp[i+4]*($t-1/3)*3 
    : pt[2][i] + dp[i+8]*($t-2/3)*3; 

function linearn(i,n) = 
    pt[floor($t*n)][i] + 
    dp[i+4*floor($t*n)]*($t-floor($t*n)/n)*n; 

function interpolate(i) = linearn(i,16);

function ulna_rotate(pose,i) =
    animate 
    ? [0,0,(interpolate(i).y+interpolate(i).z)]
    : [0,0,(pose.y+pose.z)];
function humerus_rotate(pose,i) =
    animate 
    ? [0,-interpolate(i).y,0]
    : [0,-pose.y,0];
function scapula_rotate(pose,i) =
    animate 
    ? [-interpolate(i).x,0,0]*atback(i)
    : [-pose.x,0,0]*atback(i);
