// animate_walk.scad
// move pattern for walking robot

elbow_offset = 10;  // PWM 30
humerus_offset = 5; // PWM 15

elbow_step = [0,0,elbow_offset];
humerus_step = [0,humerus_offset,0];

function left_front_step(step) = [
  step,
  [0,0,0],
  [0,0,0],
  [0,0,0]
];

left_front = [
  left_front_step(-elbow_step),
  left_front_step(-humerus_step),
  left_front_step(elbow_step)
];

function leg_steps(leg) = [
  leg[0][0],
  leg[0][1],
  leg[0][2],
  leg[0][3],
  leg[1][0],
  leg[1][1],
  leg[1][2],
  leg[1][3],
  leg[2][0],
  leg[2][1],
  leg[2][2],
  leg[2][3]
];

left_front_steps = 
  leg_steps(left_front);

function right_rear_step(step) = [
    [0,0,0],
    [0,0,0],
    [0,0,0],
    step
];

right_rear = [
  right_rear_step(-elbow_step),
  right_rear_step(-humerus_step),
  right_rear_step(elbow_step)
];

right_rear_steps = 
  leg_steps(right_rear);

left_right_home =
  left_front_step(humerus_step) + 
  right_rear_step(humerus_step);

left_right_home_steps = [
  left_right_home[0],
  left_right_home[1],
  left_right_home[2],
  left_right_home[3]
];

function right_front_step(step) = [
  [0,0,0],
  step,
  [0,0,0],
  [0,0,0]
];

right_front = [
  right_front_step(-elbow_step),
  right_front_step(-humerus_step),
  right_front_step(elbow_step)
];

right_front_steps = 
  leg_steps(right_front);

function left_rear_step(step) = [
  [0,0,0],
  [0,0,0],
  step,
  [0,0,0]
];

left_rear = [
  left_rear_step(-elbow_step),
  left_rear_step(-humerus_step),
  left_rear_step(elbow_step)
];

left_rear_steps = 
  leg_steps(left_rear);

right_left_home =
  right_front_step(humerus_step) + 
  left_rear_step(humerus_step);

right_left_home_steps = [
  right_left_home[0],
  right_left_home[1],
  right_left_home[2],
  right_left_home[3]
];


// animation interface
function walk_steps() = concat(
  left_front_steps,
  right_rear_steps,
  left_right_home_steps,
  right_front_steps,
  left_rear_steps,
  right_left_home_steps
);

function walk_home_pose() = [
    [0,33,-67],
    [0,33,-67],
    [0,33,-67],
    [0,33,-67]
];

ps = walk_home_pose();

pm1 = ps + left_front[0];
pm2 = pm1 + left_front[1];
pe1 = pm2 + left_front[2];
pm3 = pe1 + right_rear[0];
pm4 = pm3 + right_rear[1];
pe2 = pm4 + right_rear[2];
pe3 = pe2 + left_right_home;
pm5 = pe3 + right_front[0];
pm6 = pm5 + right_front[1];
pe4 = pm6 + right_front[2];
pm7 = pe4 + left_rear[0];
pm8 = pm7 + left_rear[1];
pe5 = pm8 + left_rear[2];
pe6 = pe5 + right_left_home;

function walk_points() = 
  [ps, 
  pm1, pm2, pe1, pm3, pm4, pe2, pe3,
  pm5, pm6, pe4, pm7, pm8, pe5, pe6];

//echo(walk_steps());
//echo(walk_points());
