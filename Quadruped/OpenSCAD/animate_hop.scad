// animate_hop.scad
// move pattern for hopping quadruped
// 1 - frot legs sync
// 2 - back legs sync
// 3 - front legs sync
// 4 - back legs sync

elbow_offset = 10;  // PWM 30
humerus_offset = 5; // PWM 15

elbow_step = [0,0,elbow_offset];
humerus_step = [0,humerus_offset,0];

function front_step(step) = [
  step,
  step,
  [0,0,0],
  [0,0,0]
];

front = [
  front_step(-elbow_step),
  front_step(-humerus_step),
  front_step(elbow_step)
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

front_steps = 
  leg_steps(front);

front_home =
  front_step(humerus_step);

front_home_steps = [
  front_home[0],
  front_home[1],
  front_home[2],
  front_home[3]
];

function back_step(step) = [
  [0,0,0],
  [0,0,0],
  step,
  step
];

back = [
  back_step(-elbow_step),
  back_step(-humerus_step),
  back_step(elbow_step)
];

back_steps = 
  leg_steps(back);

back_home =
  back_step(humerus_step);

back_home_steps = [
  back_home[0],
  back_home[1],
  back_home[2],
  back_home[3]
];


// animation interface
function hop_steps() = concat(
  /* Phase 1 */
  front_steps,
  front_home_steps,
  /* Phase 2 */
  back_steps,
  back_home_steps,
  /* Phase 3 */
  front_steps,
  front_home_steps,
  /* Phase 4 */
  back_steps,
  back_home_steps
);

function hop_home_pose() = [
    [0,33,-67],
    [0,33,-67],
    [0,33,-67],
    [0,33,-67]
];

ps = hop_home_pose();

/* Phase 1 */
pm1 = ps  + front[0];
pm2 = pm1 + front[1];
pm3 = pm2 + front[2];
pe1 = pm3 + front_home;
/* Phase 2 */
pm4 = pe1 + back[0];
pm5 = pm4 + back[1];
pm6 = pm5 + back[2];
pe2 = pm6 + back_home;
/* Phase 3 */
pm7 = pe2 + front[0];
pm8 = pm7 + front[1];
pm9 = pm8 + front[2];
pe3 = pm3 + front_home;
/* Phase 4 */
pm10 = pe3 + back[0];
pm11 = pm10 + back[1];
pm12 = pm11 + back[2];
pe4 = pm6 + back_home;

function hop_points() = 
  [ps, 
  pm1, pm2, pm3, pe1, 
  pm4, pm5, pm6, pe2,
  pm7, pm8, pm9, pe3, 
  pm10, pm11, pm12, pe4];

echo(hop_steps());
echo(hop_points());
echo(Size=len(hop_points()));
