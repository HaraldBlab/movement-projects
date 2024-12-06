// animate_pass.scad
// move pattern for passaging quadruped
// 1 - left legs sync
// 2 - right legs sync
// 3 - left legs sync
// 4 - right legs sync

elbow_offset = 10;  // PWM 30
humerus_offset = 5; // PWM 15

elbow_step = [0,0,elbow_offset];
humerus_step = [0,humerus_offset,0];

function left_step(step) = [
  step,
  [0,0,0],
  step,
  [0,0,0]
];

left = [
  left_step(-elbow_step),
  left_step(-humerus_step),
  left_step(elbow_step)
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

left_steps = 
  leg_steps(left);

left_home =
  left_step(humerus_step);

left_home_steps = [
  left_home[0],
  left_home[1],
  left_home[2],
  left_home[3]
];

function right_step(step) = [
  [0,0,0],
  step,
  [0,0,0],
  step
];

right = [
  right_step(-elbow_step),
  right_step(-humerus_step),
  right_step(elbow_step)
];

right_steps = 
  leg_steps(right);

right_home =
  right_step(humerus_step);

right_home_steps = [
  right_home[0],
  right_home[1],
  right_home[2],
  right_home[3]
];


// animation interface
function pass_steps() = concat(
  /* Phase 1 */
  left_steps,
  left_home_steps,
  /* Phase 2 */
  right_steps,
  right_home_steps,
  /* Phase 3 */
  left_steps,
  left_home_steps,
  /* Phase 4 */
  right_steps,
  right_home_steps
);

function pass_home_pose() = [
    [0,33,-67],
    [0,33,-67],
    [0,33,-67],
    [0,33,-67]
];

ps = pass_home_pose();

/* Phase 1 */
pm1 = ps  + left[0];
pm2 = pm1 + left[1];
pm3 = pm2 + left[2];
pe1 = pm3 + left_home;
/* Phase 2 */
pm4 = pe1 + right[0];
pm5 = pm4 + right[1];
pm6 = pm5 + right[2];
pe2 = pm6 + right_home;
/* Phase 3 */
pm7 = pe2 + left[0];
pm8 = pm7 + left[1];
pm9 = pm8 + left[2];
pe3 = pm3 + left_home;
/* Phase 4 */
pm10 = pe3 + right[0];
pm11 = pm10 + right[1];
pm12 = pm11 + right[2];
pe4 = pm6 + right_home;

function pass_points() = 
  [ps, 
  pm1, pm2, pm3, pe1, 
  pm4, pm5, pm6, pe2,
  pm7, pm8, pm9, pe3, 
  pm10, pm11, pm12, pe4];

echo(pass_steps());
echo(pass_points());
echo(Size=len(pass_points()));
