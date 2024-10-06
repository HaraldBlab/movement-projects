// mg90S_body.scad
// a mg90S model without rotor
//
// Source: https://components101.com/sites/default/files/component_datasheet/MG90S-Datasheet.pdf
// https://sellseatar.xyz/product_details/50064365.html
// mg90S_dimesions.jpg

$fn=32;

//dimensions of parts
// overall body
m_dim = [23.6,11.4,30.5];
// lower part
l_dim = [m_dim.x,m_dim.y,18.6];
// holder with screws
h_dim = [30.5,m_dim.y,2];
// upper part
u_dim = [m_dim.x,m_dim.y,4];
// gear
g_dim = [5/2,5,7.6]; // from mg90s_rotor.scad
// plate on upper part
r_dim = [11.4,5,g_dim.z];
// screws on holder
s_dim = [1.9/2,2.1*h_dim.z,g_dim.z];
// position of screws on holder
t_dim = [1.5,m_dim.y/2,h_dim.z];

// positions of the screws
function mg90s_holder_hole_pos() = [
[-(h_dim.x/2-t_dim.x),-(h_dim.y/2-t_dim.y),h_dim.z],
[h_dim.x/2-t_dim.x,h_dim.y/2-t_dim.y,h_dim.z]
];

// draws a screw (cutout) for the holder
module mg90s_holder_screw(h=s_dim.y) {
  cylinder(r=s_dim.x,h=h,center=true);
}
// draw the body
module mg90s_body($fn=36) {
    // lower part
    color ("DarkGrey") 
    cube(l_dim);
    // holder
    translate([(l_dim.x-h_dim.x)/2,0,l_dim.z])
    color ("DarkGrey") difference(){
    cube(h_dim);
    translate([t_dim.x,t_dim.y,h_dim.z])
    cylinder(r=s_dim.x,h=s_dim.y,center=true);
    translate([h_dim.x-t_dim.x,h_dim.y-t_dim.y,h_dim.z])
    cylinder(r=s_dim.x,h=s_dim.y,center=true);
    }
    // upper part
    translate([0,0,l_dim.z+h_dim.z])
    color ("DarkGrey") 
    cube(u_dim);
    // gear
    translate([g_dim.z,l_dim.y/2,m_dim.z-1.7])
    color ("Gold") 
    cylinder(r=g_dim.x,h=g_dim.y,center=true); 
    translate([r_dim.z,l_dim.y/2,m_dim.z-1.7-r_dim.y/2])
    color ("DarkGrey")
    cylinder(d=r_dim.x,h=r_dim.y,center=true);
}

*mg90s_body();

// moves the body : top of the gear is [0,0,0]
function mg90s_to_gear() = 
    -[g_dim.z,l_dim.y/2,m_dim.z];

*translate(mg90s_to_gear()) mg90s_body();

// moves the body : center of holder is [0,0,0]
function mg90s_to_holder() = 
    -[l_dim.x/2,l_dim.y/2,h_dim.z+l_dim.z];
function mg90s_gear_to_holder() = 
    [0,0,g_dim.y+ u_dim.z-h_dim.z];

translate(mg90s_to_holder()) mg90s_body();

pos = mg90s_holder_hole_pos();
translate(pos[0]) mg90s_holder_screw();
translate(pos[1]) mg90s_holder_screw();
