// animate_gallop.scad
// move pattern for galopping quadruped
// 1 - left back leg
// 2 - right back and left front (almost) sync
// 3 - right front leg
// (4 - floating phase)

elbow_offset = 10;  // PWM 30
humerus_offset = 5; // PWM 15

elbow_step = [0,0,elbow_offset];
humerus_step = [0,humerus_offset,0];

// Phase 1
function left_back_step(step) = [
  [0,0,0],
  [0,0,0],
  step,
  [0,0,0]
];

left_back = [
  left_back_step(-elbow_step),
  left_back_step(-humerus_step),
  left_back_step(elbow_step)
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

left_back_steps = 
  leg_steps(left_back);

left_back_home =
  left_back_step(humerus_step);

left_back_home_steps = [
  left_back_home[0],
  left_back_home[1],
  left_back_home[2],
  left_back_home[3]
];

// Phase 2

function right_left_step(step) = [
  step,
  [0,0,0],
  [0,0,0],
  step
];

right_left = [
  right_left_step(-elbow_step),
  right_left_step(-humerus_step),
  right_left_step(elbow_step)
];

right_left_steps = 
  leg_steps(right_left);

right_left_home =
  right_left_step(humerus_step);

right_left_home_steps = [
  right_left_home[0],
  right_left_home[1],
  right_left_home[2],
  right_left_home[3]
];


// Phase 3

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

right_front_home =
  right_front_step(humerus_step);

right_front_home_steps = [
  right_front_home[0],
  right_front_home[1],
  right_front_home[2],
  right_front_home[3]
];

// animation interface
function gallop_steps() = concat(
  /* Phase 1 */
  left_back_steps,
  left_back_home_steps,
  /* Phase 2 */
  right_left_steps,
  right_left_home_steps,
  /* Phase 3 */
  right_front_steps,
  right_front_home_steps
);

function gallop_home_pose() = [
    [0,33,-67],
    [0,33,-67],
    [0,33,-67],
    [0,33,-67]
];

ps = gallop_home_pose();

/* Phase 1 */
pm1 = ps  + left_back[0];
pm2 = pm1 + left_back[1];
pm3 = pm2 + left_back[2];
pe1 = pm3 + left_back_home;
/* Phase 2 */
pm4 = pe1 + right_left[0];
pm5 = pm4 + right_left[1];
pm6 = pm5 + right_left[2];
pe2 = pm6 + right_left_home;
/* Phase 3 */
pm7 = pe2 + right_front[0];
pm8 = pm7 + right_front[1];
pm9 = pm8 + right_front[2];
pe3 = pm9 + right_front_home;

function gallop_points() = 
  [ps, 
  pm1, pm2, pm3, pe1, 
  pm4, pm5, pm6, pe2,
  pm7, pm8, pm9, pe3];

echo(gallop_steps());
echo(gallop_points());
echo(Size=len(gallop_points()));
