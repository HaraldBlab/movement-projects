// animate_trot.scad
// move pattern for troting robot
// 1 - front left and back right sync
// 2 - front right and back left sync
// 3 - front left and back right sync
// 4 - front right and back left sync

elbow_offset = 10;  // PWM 30
humerus_offset = 5; // PWM 15

elbow_step = [0,0,elbow_offset];
humerus_step = [0,humerus_offset,0];

function left_right_step(step) = [
  step,
  [0,0,0],
  [0,0,0],
  step
];

left_right = [
  left_right_step(-elbow_step),
  left_right_step(-humerus_step),
  left_right_step(elbow_step)
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

left_right_steps = 
  leg_steps(left_right);

left_right_home =
  left_right_step(humerus_step);

left_right_home_steps = [
  left_right_home[0],
  left_right_home[1],
  left_right_home[2],
  left_right_home[3]
];

function right_left_step(step) = [
    [0,0,0],
    step,
    step,
    [0,0,0]
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


// animation interface
function trot_steps() = concat(
  /* Phase 1 */
  left_right_steps,
  left_right_home_steps,
  /* Phase 2 */
  right_left_steps,
  right_left_home_steps,
  /* Phase 3 */
  left_right_steps,
  left_right_home_steps,
  /* Phase 4 */
  right_left_steps,
  right_left_home_steps
);

function trot_home_pose() = [
    [0,33,-67],
    [0,33,-67],
    [0,33,-67],
    [0,33,-67]
];

ps = trot_home_pose();

/* Phase 1 */
pm1 = ps  + left_right[0];
pm2 = pm1 + left_right[1];
pm3 = pm2 + left_right[2];
pe1 = pm3 + left_right_home;
/* Phase 2 */
pm4 = pe1 + right_left[0];
pm5 = pm4 + right_left[1];
pm6 = pm5 + right_left[2];
pe2 = pm6 + right_left_home;
/* Phase 3 */
pm7 = pe2  + left_right[0];
pm8 = pm7 + left_right[1];
pm9 = pm8 + left_right[2];
pe3 = pm3 + left_right_home;
/* Phase 4 */
pm10 = pe3 + right_left[0];
pm11 = pm10 + right_left[1];
pm12 = pm11 + right_left[2];
pe4 = pm6 + right_left_home;

function trot_points() = 
  [ps, 
  pm1, pm2, pm3, pe1, 
  pm4, pm5, pm6, pe2,
  pm7, pm8, pm9, pe3, 
  pm10, pm11, pm12, pe4];

echo(trot_steps());
echo(trot_points());
echo("Size", len(trot_points()));
