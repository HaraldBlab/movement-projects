// RobotCarKit.scad
// Kit: https://www.az-delivery.de/products/smart-robot-car-kit

//
// the controller board
function board() =
    [ 40, 44, 1];
function board_to_holder() =
    [4,16-4,0];
function board_mounts_to_board() =
    [board().x/2,board().y-17-4/2,-2*2];

module board_mount($fn=36) {
    cylinder(d=4,h=4*2);
}
module longhole(d=4, $fn=36) {
  hull() {
    translate([-d/2/2,0,0]) cylinder(d=d,h=4*2);
    translate([+d/2/2,0,0]) cylinder(d=d,h=4*2);
  }
}
*longhole();

module board_mounts(lh=false) {
  translate([board().x/2-(4/2+0.5),0,0])
  if (lh) longhole(4); else board_mount();
  translate([-board().x/2+(4/2+0.5),0,0])
  if (lh) longhole(4); else board_mount();
}
*board_mounts(lh=true);

module board() {
  color("red") difference() {
    cube(board());
    translate(board_mounts_to_board())
    board_mounts();
  }
}
*board();

function kitcar_mount_to_kitcar() = [0,5,0];
function board_holder_to_kitcar() = 
    [board_holder().x/2,0,0];
module kitcar_mount($fn=36) {
    cylinder(d=4,h=4*2);
}
module kitcar_mounts(lh=false) {
  translate([24/2+4/2,0,-.1])
  if (lh) longhole(4); else kitcar_mount();
  translate([-(24/2+4/2),0,-.1]) 
  if (lh) longhole(4); else kitcar_mount();
}

function devcar_mount_to_devcar() = [0,3,0];
function board_holder_to_devcar() = 
    [board_holder().x/2,0,0];
module devcar_mount($fn=36) {
    cylinder(d=3,h=4*2);
}
module devcar_mounts(lh=false) {
  translate([12/2+3/2,0,-.1])
  if (lh) longhole(3); else devcar_mount();
  translate([-(12/2+3/2),0,-.1]) 
  if (lh) longhole(3); else devcar_mount();
}


function board_holder() = [
    sensors().x + 4,
    60, 
    2 ]; 

module board_holder(board=false) {
  difference() {
    cube(board_holder());
    // mounting holes of board
    translate(board_to_holder())
    translate([board().y,0,0])
    rotate([0,0,90])
    translate(board_mounts_to_board())
    board_mounts(lh=true);
    translate(board_holder_to_kitcar())
    translate(kitcar_mount_to_kitcar())
    kitcar_mounts(lh=true);
    translate(board_holder_to_devcar())
    translate(devcar_mount_to_devcar())
    devcar_mounts(lh=true);
  }
  if (board)
    translate(board_to_holder()+[0,0,2.1]) 
    translate([board().y,0,0])
    rotate([0,0,90])
    board();
}

*board_holder();

function sensor() =
    [ 12, 13, 1];

function sensors() =
    [ 4*sensor().x, 13, 1];

function sensors_mounts_to_board() = 
    [4.5+3/2,6,-.1];
module sensor_mount($fn=36) {
    cylinder(d=3,h=4*2);
}
module sensors_mounts(lh=false) {
  if (lh) longhole(3); else sensor_mount();
  translate([1*sensor().x,0,0]) 
  if (!lh) sensor_mount();
  translate([2*sensor().x,0,0]) 
  if (!lh) sensor_mount();
  translate([3*sensor().x,0,0]) 
  if (lh) longhole(3); else sensor_mount();
};
*sensors_mounts();
module sensors() {
  color("red") difference() {
    cube(sensors());
    translate(sensors_mounts_to_board())
    sensors_mounts();
  }
}
*sensors();

function sensors_to_sensors_holder() = 
    [2,sensors().y + 10-7,0];
function sensors_holder() = [
    sensors().x + 4,
    sensors().y + 10 + 4 + 2, 
    2 ]; 
module sensors_holder(board=false) {
  difference() {
    cube(sensors_holder());
    translate(sensors_to_sensors_holder())
    translate(sensors_mounts_to_board())
    sensors_mounts(lh=true);
  }
  if (board)
    translate(sensors_to_sensors_holder())
    translate([0,0,2+.1])
    color("red") sensors();
}
*sensors_holder();

module line_follower_holder(board=false) {
  union() {
    translate([board_holder().x,0,2])
    rotate([0,0,90])
    rotate([0,180,0])
    rotate([0,0,90])
    board_holder(board);
    rotate([90,0,0]) 
    sensors_holder(board);
  }
}
line_follower_holder(board=true);
