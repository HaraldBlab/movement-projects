// robot_body.scad
// quadruped robot body

// material is 3mm thick
material = 3; // material thickness [mm]
// a dowel to connect the scapula
dowel = [  // dowel to rotate ulna
    6,     // diameter  [mm]
    15     // length [mm]
];  
module dowel($fn=24) {
  cylinder(d=dowel[0], h=dowel[1],center=true);
}

leg_mg90s_holder = [ // the screwing part
    32.2,  // 21+10,  // length [mm]
    12.2,  // 12,     // width [mm]
    2.54,  // height [mm] >= 2
];
// a mg90s motor
//leg_mg90s_body = [    // the body
//    23,     // 21,    // length [mm]
//    12.4,   // 12,    // width [mm]
//    10,     // height [mm] > 8
//];

// the whole robot body
body = [210,83,material];
// the back part
back = [11,body.y,material];
// the front part
front = [37,body.y,material];
// the middle part
middle = [24,body.y,material];

// small value for proper solid operations
air = [.1,.1,.1];

// size of stick to hold a mg90s motor
leg_motor_stick = [6,8,21];

// distance between 2 stick holders
leg_motor_holder_distance = 
  [leg_mg90s_holder.z, 23, 0];

// distance from start of one stick to the other
leg_motor_stick_distance = 
  leg_motor_stick + leg_motor_holder_distance;
     
module leg_motor_stick() {
  cube(leg_motor_stick);
}

leg = [
  38,
  leg_motor_stick_distance.y+3,
  3*material
];
module leg_cutout() {
  cube(leg+air);
}
module robot_body_legs_cutout() {
  air = 0.1;
  translate([0,0,0])
  leg_cutout();
  translate([0,body.y-leg.y+air,0])
  leg_cutout();
}

// distance between 2 leg holder sticks in x
leg_motor_stick_distance_x = 
  [leg_motor_stick_distance.x, 0, 0];

module leg_motor_holder_side() {
  translate([0,0,0])
  leg_motor_stick();
  translate(leg_motor_stick_distance_x)
  leg_motor_stick();
}
*leg_motor_holder_side();

// distance between 2 leg holder sticks in y
leg_motor_holder_distance_y = 
  [0, leg_motor_stick_distance.y, 0];

module leg_motor_holder() {
  translate([0,0,0])
  leg_motor_holder_side();
  translate(leg_motor_holder_distance_y)
  leg_motor_holder_side();
}
*leg_motor_holder();

motor_plate = 
    [3+6+2+6+11,body.y/2,material];
motor_back_plate = 
    [material,leg.x,15-material];

// single plate with motor holders
module motor_plate_design()
{
  cube(motor_plate);
}

*motor_plate_design();

// d = m3 screw
module leg_holder_screw(d=3.2,h=4*material,$fn=36)
{
  cylinder(d=d,h=h,center=true);
}
module leg_holder_mount()
{
  w = motor_plate.x/2 + material;
  translate([0,-w/2,0])
  leg_holder_screw();
  translate([0,w/2,0])
  leg_holder_screw();
}

leg_holder_plate =
    [motor_plate.x+leg.x+24/2,
     motor_plate.y, 
     material];

module leg_holder_plate() {
  cube(leg_holder_plate);
}

*leg_holder_plate();

module leg_holder_mounts() {
  // mount under motor
  translate([leg.x/2+leg.x+12,(leg.y+material)/2,0])
  leg_holder_mount();
  // mount at dowl holder
  translate([-back.x+15,motor_plate.x,0]) {
    translate([0,4,0])
    leg_holder_screw();
    translate([0,-leg_motor_holder_distance.y,0])
    leg_holder_screw();
  }
}

*leg_holder_mounts();

body_back_x = back.x-leg_dowel_holder().x;

module leg_holder(mounts) {
  difference() {
    leg_holder_plate();
    translate([leg_dowel_holder().x,-.1,-material]) 
    leg_cutout();
    if (mounts)
      leg_holder_mounts();
  }
  // 
  translate([(leg.x+leg_dowel_holder().x),0,0]) {
    translate([material,0,0]) {
      leg_motor_holder();
      translate([motor_plate.x,0,0])
      cube(motor_back_plate);
    }
    translate([body_back_x,0,0])
    translate(-[back.x+leg.x,0,0])
    leg_dowel_holder();
  }
}

*leg_holder();

module back_left_leg_holder(mounts=false) {
    translate([0,body.y,0])
    scale([1,-1,1]) leg_holder(mounts);
}
module back_right_leg_holder(mounts=false) {
    leg_holder(mounts);
}
module back_legs_holders(mounts=false) {
  back_left_leg_holder(mounts);
  back_right_leg_holder(mounts);
}

module front_left_leg_holder(mounts=false) {
  translate([3,0,0])
  scale([-1,1,1]) 
  back_left_leg_holder(mounts);
}

module front_right_leg_holder(mounts=false) {
  translate([3,0,0])
  scale([-1,1,1]) 
  back_right_leg_holder(mounts);
}

module front_legs_holders(mounts=false) {
  front_left_leg_holder(mounts);
  front_right_leg_holder(mounts);
}

function leg_dowel_holder() = [9,28,18];
function leg_dowel_holder_to_holder() = 
    leg_dowel_holder()/2 + [0,0,material];

module leg_dowel_holder() {
  difference() {
    cube(leg_dowel_holder());
    translate(leg_dowel_holder_to_holder()) 
    rotate([0,90,0]) 
    dowel();
  }
}
*leg_dowel_holder();

function hcsr04_cutout() = [
    8+.2, // radius
    4, // offset left/right
    6  // offset top
];
function hcsr04_hole_to_holder() =
    [-.1, 
    hcsr04_cutout()[1]+hcsr04_cutout()[0], 
    hcsr04_holder().z-hcsr04_cutout()[2]-hcsr04_cutout()[0]];

module hcsr04_holder_hole() {
  rotate([0,90,0]) 
  cylinder(r=hcsr04_cutout()[0],h=2*material);
}
function hcsr04_holder() = [3,51,40];
module hcsr04_holder() {
  difference() {
    cube(hcsr04_holder());
    *union() {
      cube(hcsr04_holder());
      translate([material/2,26,18/2+2*material])
      cube([material, 83, 18],center=true);
      }
    translate(hcsr04_hole_to_holder()) {
      hcsr04_holder_hole();
      translate([0,hcsr04_hole_to_holder().z,0])
      hcsr04_holder_hole();
    }
  }
}

*hcsr04_holder();

module robot_leg_holders(mounts=false) {
  translate([body_back_x,0,0])
  back_legs_holders(mounts);
  translate([body.x-front.x,0,0])
  translate([leg_dowel_holder().x+material,0,0])
  front_legs_holders(mounts);
}

*robot_leg_holders();

function right_to_left() =
    [0,body.y-leg.y-3,0];

module robot_back_leg_holder_mounts() {
  // back right
  leg_holder_mounts();
  // back left
  translate(right_to_left())
  leg_holder_mounts();
}

module robot_front_leg_holder_mounts() {
  // front right
  translate([material,0,0])
  scale([-1,1,1]) leg_holder_mounts();
  // front left
  translate(right_to_left())
  translate([material,0,0])
  scale([-1,1,1]) leg_holder_mounts();
}

module robot_leg_holder_mounts()
{
  translate([-material,0,0])
  robot_back_leg_holder_mounts();
  translate([body.x-30,0,0])
  robot_front_leg_holder_mounts();
}

function back_leg_cut_to_body() =
    [back.x-material,0,0];

function front_leg_cut_to_body() =
    [body.x-front.x-leg.x+material,0,0];

function hcsr04_holder_to_body() =
    [body.x-material,
    (body.y-hcsr04_holder().y)/2,
    ];

module front_panel_cutout(air=[0,0,0]) {
  translate([-material/2, 0, material])
  cube([material, 51, 2*material]+air,center=true);
}

module robot_body_base(mounts=false) {
  difference() {
    cube(body);
    translate([3,-air.y,-material]) {
      // back legs coutout
      translate(back_leg_cut_to_body())
      robot_body_legs_cutout();
      // front leg cutout
      translate(front_leg_cut_to_body())
      robot_body_legs_cutout();
      // leg holder mounts
      if (mounts)
        translate([2,0,2*material])
        robot_leg_holder_mounts();
    }
    // front panel holder
    translate([body.x,body.y/2,0])
    front_panel_cutout(air);
    // middle back/front part connector
    if (mounts)
      translate(middle_pos_to_body())
      robot_body_middle_mount();
  }
}

module robot_body_cover_design() {
  x = leg_motor_stick.y + .5; // 8
  y = leg_motor_holder_distance.y - 1; // 22
  z = body.y-2*(x+y); //23;
  r = 17+1; // 17
  s = 17+53+17-2*r; // 53
  pts = [
    [0,r],
    [0, r+s],
    [x, r+s],
    [x, r+s+r],
    [x+y, r+s+r],
    [x+y, r+s],
    [x+y+z, r+s],
    [x+y+z, r+s+r],
    [x+y+z+y, r+s+r],
    [x+y+z+y, r+s],
    [x+y+z+y+x, r+s],
    [x+y+z+y+x, r], 
    [x+y+z+y, r], 
    [x+y+z+y, 0], 
    [x+y+z, 0], 
    [x+y+z, r], 
    [x+y, r], 
    [x+y, 0], 
    [x, 0],
    [x, 17]
  ];
  linear_extrude(height=material) polygon(pts); 

}

function robot_body_cover_center() =
    [(8+22+23+22+8)/2, (17+53+17)/2];

*robot_body_cover_design();

module robot_cover_mount() {
  cylinder(d=3.2, h=2*material,center=true,$fn=12);
}

module robot_body_cover_mounts() {
  translate(robot_body_cover_center())
  translate([0,0,material/2])
  {
    x = 12*2.54;
    y =  7*2.54;
    translate([x,   y,0]) robot_cover_mount();  
    translate([x,  -y,0]) robot_cover_mount();  
    translate([-x,  y,0]) robot_cover_mount();  
    translate([-x, -y,0]) robot_cover_mount();  
  }
}
*robot_body_cover_mounts();

module robot_body_cover(mounts) {
  translate(robot_body_cover_center())
  rotate([0,0,90])
  translate(-robot_body_cover_center())
  if (mounts)
    difference() {
      robot_body_cover_design();
      robot_body_cover_mounts();
    }
  else
    robot_body_cover_design();
}

*robot_body_cover(true);

function robot_cover_to_body() =
    [11+38+3,-2,leg_dowel_holder().z+body.z];

module robot_body_design(front=false, cover=false,mounts=false) {
  //color("BurlyWood")
  union() {
    robot_body_base(mounts);
    // 4 leg motor holders
    translate([0,0,body.z])
    robot_leg_holders(mounts);
    // middle back/front part connector
    translate(middle_pos_to_body())
    robot_body_middle(mounts);
  }
  // front panel (HC_SR04)
  if (front) 
    translate(hcsr04_holder_to_body())
    hcsr04_holder();
  // cover laying on the motor
  if (cover)
    translate(robot_cover_to_body())
    robot_body_cover(cover);
}

*robot_body_design(false, false, false);

function back_part() = 
  [11+38+3+6+2+6+11+3,body.y,material];

function front_part() = 
    [body.x-back_part(),
     back_part().y,
     back_part().z];

function middle_pos_to_body() = 
    [3+(11+38+3+6+2+6+11+3),0,body.z];

function middle_part() = middle;

module robot_body_middle(mounts=false) {
  difference() {
    cube(middle_part());
    if (mounts)
      robot_body_middle_mount();
  }
}

*translate(middle_pos_to_body())
robot_body_middle(true);

module robot_body_back_middle_hole() {
  cylinder(h=6*material, d=3.2,center=true);
}    
module robot_body_back_middle_mount() {
  pos1 = [6,6,-material/2];
  translate(pos1)
  robot_body_back_middle_hole();
  pos2 = [6,body.y-6,-material/2];
  translate(pos2)
  robot_body_back_middle_hole();
  pos3 = [6,body.y/2-6,-material/2];
  translate(pos3)
  robot_body_back_middle_hole();
  pos4 = [6,body.y/2+6,-material/2];
  translate(pos4)
  robot_body_back_middle_hole();
}
module robot_body_front_middle_mount() {
  pos1 = [24-6,6,-material/2];
  translate(pos1)
  robot_body_back_middle_hole();
  pos2 = [24-6,body.y-6,-material/2];
  translate(pos2)
  robot_body_back_middle_hole();
  pos3 = [24-6,body.y/2-6,-material/2];
  translate(pos3)
  robot_body_back_middle_hole();
  pos4 = [24-6,body.y/2+6,-material/2];
  translate(pos4)
  robot_body_back_middle_hole();
}

module robot_body_middle_mount() {
  robot_body_back_middle_mount();
  robot_body_front_middle_mount();   
}

function front_cut() =
  [body.x-back_cut().x,back_cut().y,back_cut().z];

module robot_body_back() {
  difference() {
  *robot_body_design();
  robot_body_base(true);
  cut=front_cut();
  translate([body.x-back_cut().x-24+4,0,0] + cut/2)
  cube(cut+air,center=true);
  }
}

*robot_body_back();

function back_cut() =
  [(11+38+3+6+2+6+11+3)+3+24/2,body.y,2*material];

module robot_body_front() {
  difference() {
    robot_body_base(true);
    cut=back_cut();
    translate(cut/2)
    cube(cut+air,center=true);
  }
}

*robot_body_front();

module robot_body(front=false,cover=false,mounts=false) {
  translate([body.x,0,0])
  scale([-1,1,1])
  robot_body_design(front, cover, mounts);
}
robot_body();
