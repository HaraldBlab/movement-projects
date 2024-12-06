// robot_legs_rotation.scad
// some (animatable) rotation calculation
//
// simulation of the quadruped examples
use <animate_walk.scad>
use <animate_trot.scad>
use <animate_pass.scad>

animate = true;
animation = "pass";

function animate_steps() =
  (animation == "walk") ?
    walk_steps() : 
  (animation == "trot") ?
    trot_steps() : 
  pass_steps();

function animate_points() =
  (animation == "walk") ?
    walk_points() : 
  (animation == "trot") ?
    trot_points() :
  pass_points();

dp = animate_steps();
pt = animate_points();
npoly = len(pt)-1;

echo(degree=npoly);

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

function interpolate(i) = linearn(i,npoly);

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
