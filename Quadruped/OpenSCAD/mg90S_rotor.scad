// Inspiration: https://www.printables.com/en/model/316901-mg90s-servo-arm
$fn = 60;

legs = 2; // [1:1:10]
leg_holes = true;
horn_mount = 1.6;

module leg(holes) {
  difference() {
    translate([1, 0, 0]) hull() {
      cylinder(h=2, d=5.5);
      translate([32/2-2.5/2, 0, 0]) 
      cylinder(h=2, d=2.5);
    }
    if(holes) {
      for(h=[4:2:32/2]) {
        translate([h, 0, -.1]) cylinder(r=0.4, h=20);
      }
    }
  }
}

module mg90s_horn_screw(h=5) { 
  cylinder(h=h, r=1.6);
}

module mg90s_horn(size=1) {
  legs = size;    
  difference() {
    union() {
      cylinder(h=5, d=7);
      *cylinder(h=5, d=5);
      for(i=[0:360/legs:360]) {
          rotate([0, 0, i]) leg(leg_holes);
      }
    }
    translate([0, 0, 2]) cylinder(h=5, d=5);
    translate([0, 0, -.1]) mg90s_horn_screw(h=5);
  }
}

mg90s_horn(2);