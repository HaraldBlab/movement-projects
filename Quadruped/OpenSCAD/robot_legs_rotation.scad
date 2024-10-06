// robot_legs_rotation.scad
// some (animatable) rotation calculation

// TODO: move this to simulation file
animate = true;

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
function right_front_pose() = [
    [0,33,-67],
    [10,-25,30],
    [0,33,-67],
    [0,33,-67]
];
function right_back_pose() = [
    [0,33,33],
    [0,33,33],
    [0,33,33],
    [10,-40,20]
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
dp = [
    pm[0]- ps[0],
    pm[1]- ps[1],
    pm[2]- ps[2],
    pm[3]- ps[3],
    pe[0]- pm[0],
    pe[1]- pm[1],
    pe[2]- pm[2],
    pe[3]- pm[3]
];

function atback(i) = i<2?1.0:-1.0;

// TODO: move this to simulation file
function linear(i) = ps[i] + dp[i]*$t; 
function sinus(i) = ps[i] + dp[i]*sin(180*$t); 

function linear2(i) = 
    $t < 0.5
    ? ps[i] + dp[i]*$t*2
    : pm[i] + dp[i+4]*($t-0.5)*2; 

function interpolate(i) = linear2(i);

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
