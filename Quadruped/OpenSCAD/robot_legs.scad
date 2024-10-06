// robot_legs.scad
// Souece of inspiration
// https://www.az-delivery.de/blogs/azdelivery-blog-fur-arduino-und-raspberry-pi/vierbeiniger-roboter-mit-pca9685-und-12-servomotoren

use <mg90s_rotor.scad>
use <mg90s_body.scad>
use <robot_legs_rotation.scad>

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
// a mg90s motor
leg_mg90s_body = [  // the body
    22.6,   // 21,     // length [mm]
    12.4,   // 12,     // width [mm]
    10,     // height [mm] > 8
];
leg_mg90s_holder = [ // the screwing part
    32.2,  // 21+10,  // length [mm]
    12.2,  // 12,     // width [mm]
    2.54,  // height [mm] >= 2
];

module leg_mg90s_body(air=0.2) {
    cube(leg_mg90s_body+[air,air,air]);
}

module leg_mg90s_body_cutout(air=0) {
    rotate([0,0,90]) leg_mg90s_body();
}

*color("black") mg90s_body_cutout();

module leg_mg90s_holder(air) {
    cube(leg_mg90s_holder+[2*air,air,air]);
}

module leg_mg90s_holder_cutout(air) {
    rotate([0,0,90]) leg_mg90s_holder(air);
}

*color("black") mg90s_holder_cutout();

module leg_mg90s_holder_holes() {
    h = 12;
    pt = mg90s_holder_hole_pos();
    mx= (-pt[0].x + pt[1].x)/2;
    rotate([0,0,90]) 
    translate([mx+2.5,0,(leg_mg90s_holder.z-h)/2])
    {
        translate(pt[0])
        mg90s_holder_screw(h=h);
     
        translate(pt[1])
        mg90s_holder_screw(h=h);
    }
}
cable_dm = 2.54 / 2;    // cable diameter
mg90s_cable = [cable_dm*3, 6*2.1, cable_dm];

module leg_mg90s_holder_cable_cutout(at_ulna) {
  air = 0.2;
  pt = mg90s_holder_hole_pos();
  if (at_ulna) {
    translate([0,leg_mg90s_holder.x-6*cable_dm/2,0])
    rotate([90,0,0])
    cube(mg90s_cable+[air,air,air],center=true);
  } else {
    translate([0,7*cable_dm/2,0])
    rotate([90,0,0])
    cube(mg90s_cable+[air,air,air],center=true);
  }
}

module leg_mg90s_cutout(at_ulna) {
    air = 0.5;
    union() {
    translate([(leg_mg90s_body.y)/2,5,-leg_mg90s_body.z+.2]) 
    leg_mg90s_body_cutout(air);
    translate([(leg_mg90s_holder.y)/2,0,-leg_mg90s_holder.z/2+0]) 
    leg_mg90s_holder_cutout(air);
    
    leg_mg90s_holder_holes();

    leg_mg90s_holder_cable_cutout(at_ulna);
    }
}

*olor("blue") 
leg_mg90s_cutout(false);

// Robot Legs
// Robot Legs Parts.jpg
module humerus() {
    // 19 = 22*cosa
    cosa = cos(-33);
    sina = sin(-33);
    pts = [[0,0], [22,0], [22,80],
    [22-34*sina, 80+34*cosa],
    [22-34*sina-19*cosa, 80+34*cosa-19*sina],
    [0,79]
    ];
    
    difference() {
    linear_extrude(height=2*material) polygon(pts); 
    translate([(22)/2,4,2*material])          leg_mg90s_cutout(false);
    
    translate([(22)/2,80,2*material]) 
    rotate([0,0,-33]) 
    translate([0,5,0]) 
    leg_mg90s_cutout(true);
    }
    *translate([(22)/2,4,2*material]) 
    translate([0,15,-3])
    rotate([0,0,90]) 
    {
        translate(mg90s_holder_hole_pos()[0])
        mg90s_holder_screw();    
     
        translate(mg90s_holder_hole_pos()[1])
        mg90s_holder_screw();
    }

}

*humerus();

// move that the top motor cut out is centered
function humerus_holder_pos() = 
    [-22/2,-leg_mg90s_holder.x/2,4];

*translate(humerus_holder_pos()) humerus();

leg_mg90s_gear_screw = [  // screw to hold gear
    4.25,   // dialmeter  [mm]
    15     // length [mm] > 2*2*material
];  

module leg_mg90s_gear_screw($fn=24) {
  sd = 18;  // distance holder mout screw
  dd = 1.5; // radius holder mount scre
  md = (sd-dd)/2;
  union() {
    cylinder(d=leg_mg90s_gear_screw[0],     leg_mg90s_gear_screw[1],center=true);
    translate([md,0,0]) cylinder(d=dd,   leg_mg90s_gear_screw[1],center=true);
    translate([-md,0,0]) cylinder(d=dd, leg_mg90s_gear_screw[1],center=true);
  }
}
size=[31,31,31];

function scapula_dowel_pos() = [-size.x/2,0,0];

function scapula_horn_x_pos() = [size.x/2,0,0];
function scapula_horn_y_pos() = [0,size.y/2,0];
function scapula_horn_z_pos() = [0,0,-size.z/2];

module scapula() {
  walls=[2*material,1*material,0];
  difference() {
    // the body
    cube(size, center=true);
    // the body opening
    translate([0,0, material+.1]) 
    cube(size-2*walls, center=true);
    // hole for the dowel
    translate(scapula_dowel_pos())
    rotate([0,90,0]) 
    dowel();
    // screw hole at holder 1
    translate(scapula_horn_x_pos())
    rotate([0,90,0]) 
    rotate([0,0,45]) 
    leg_mg90s_gear_screw();
    // hole opposite to body opening
    translate(scapula_horn_z_pos())
    rotate([0,0,0])
    rotate([0,0,45]) 
    leg_mg90s_gear_screw();
  }
  *translate(scapula_dowel_pos())rotate([0,90,0]) dowel();
  *translate(scapula_horn_x_pos())rotate([0,90,0]) leg_mg90s_gear_screw();
  *translate(scapula_horn_z_pos())rotate([0,0,0]) leg_mg90s_gear_screw();
}

module scapula_with_horns(a_y=0,leg=0,pose=[0,0,0],
        connectors=true) {
  color("BurlyWood") scapula();
    
  if (connectors) {
      translate(scapula_horn_x_pos())
      rotate([0,90,0])
      rotate([0,0,45])
      color("darkGrey") mg90s_horn(2);

      translate(scapula_horn_x_pos())
      rotate([0,-90,0])
      translate(mg90s_to_gear()-[0,0,material-0.5])
      mg90s_body();
        
      translate(scapula_horn_z_pos())
      rotate([180,0,0])
      rotate([0,0,-45])
      color("darkGrey") mg90s_horn(2);

      translate(scapula_horn_z_pos())
      rotate([0,0,0])
      rotate([0,0,90+a_y+humerus_rotate(pose,leg).y])
      translate(mg90s_to_gear()-[0,0,2])
      mg90s_body()
      ;
  }
    
}

// rotate to be used with the left leg
*rotate([-90,0,0]) scapula_with_horns();

module humerus_with_motor(a=33) {
  color("BurlyWood") humerus();

  translate([(22)/2-0,80,2*material]) 
  rotate([0,0,-a]) 
  translate(-[11.4/2,5+4,-18+4.5])
  rotate([0,0,90]) 
  rotate([0,180,180]) 
  translate(-mg90s_gear_to_holder()+[18+.5,0,2])
  mg90s_body();
}

*humerus_with_motor();

function ulna_to_humerus_pos() =
    [(22)/2-(5-material)/2,80-5/2,-8];

// see: robot_legs_rotation.scad
//function ulna_rotate(pose) =
//    [0,0,-(pose.y+pose.z)];
//function humerus_rotate(pose) =
//    [0,-pose.y,0];
//function scapula_rotate(pose) =
//    [-pose.x,0,0];

module robot_leg(leg=0,a_y=0, pose=[0,33,33]) {
  rotate([-90,a_y,0]) 
  rotate(scapula_rotate(pose,leg))
  scapula_with_horns(a_y,leg,pose);
  
  rotate(atback(leg)*scapula_rotate(pose,leg))
  rotate([-90,0,0]+humerus_rotate(pose,leg)) 
  translate(-mg90s_gear_to_holder())
  translate(scapula_horn_z_pos())
  rotate([180,0,180]) {
    translate([0,0,-material])
    translate(humerus_holder_pos())
    // TODO: check rotation of motor
    humerus_with_motor(a=33);
  
    translate(ulna_to_humerus_pos())
    // TODO: negative value
    rotate(ulna_rotate(pose,leg)) 
    translate(ulna_to_horn()) 
    ulna_with_horn();
  }

}
robot_leg(pose=[0,-40,20]);

// legs at the left are the same
module robot_leg_left(leg,a_y=0,pose) {
   robot_leg(leg=leg,a_y=a_y,pose=pose);
}
*robot_leg_left(leg=0,pose=[10,-40,20]);

module robot_leg_front_left(pose) {
  robot_leg_left(leg=0,pose=pose);
}
*robot_leg_front_left(pose=[10,-40,20]);

module robot_leg_back_left(pose) {
  robot_leg_left(leg=2,a_y=180,pose=pose);
}
*robot_leg_back_left(pose=[10,-40,20]);

// legs at the right are the same
module robot_leg_right(leg,a_y=0,pose) {
   scale([1,-1,1]) 
   robot_leg(leg=leg,a_y=a_y,pose=pose);
}
*robot_leg_right(leg=3,pose=[10,-40,20]);

module robot_leg_front_right(pose) {
  robot_leg_right(leg=1,pose=pose);
}
*robot_leg_front_right(pose=[10,-40,20]);

module robot_leg_back_right(pose) {
  robot_leg_right(leg=3,a_y=180,pose=pose);
}
*robot_leg_back_right(pose=[10,-40,20]);


module ulna() {
  d=15; //circular base diameter
    pts = [
    [0,0], 
    [15,0], 
    [15,23], 
    [15+10,23+23],
    [15+10,23+29+36], 
    [15+10,23+23+57-d/2], 
    [15,23+23+57-d/2], 
    [15,23+29],
    [0,27]];
    
    difference() {
      linear_extrude(height=2*material) polygon(pts); 
      // mounting hole
      translate(-ulna_to_horn()) 
      rotate([180,0,90])
      rotate([0,0,0])
      leg_mg90s_gear_screw();
    }
    // adding w/o known numbers
    translate([d+d/2,23+23+57-d/2,0])
    cylinder(d=d, h=2*material);
    
}

*ulna();

function ulna_horn_pos() = [15/2,27-20/2,6];
// 6 = height of horn
function ulna_to_horn() = -ulna_horn_pos()+[0,0,0];

module ulna_with_horn() {
  color("BurlyWood") ulna();
  
  translate(ulna_horn_pos()) 
  rotate([0,0,90])
  rotate([0,0,0])
  color("darkGrey") mg90s_horn(2);

}

*translate(ulna_to_horn()) ulna_with_horn();
