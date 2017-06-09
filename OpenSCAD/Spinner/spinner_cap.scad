bearing_out_diam = 22;
bearing_in_diam = 8.1;
bearing_height = 7;
inner_ring_diam = 11;

cap_height = 2;
clearance = 0.4;

$fn=64;

union()
{
  cylinder(d=bearing_out_diam, h=cap_height);
  translate([0,0,cap_height]) cylinder(d=inner_ring_diam, h=clearance);
  translate([0,0,cap_height+clearance]) cylinder(d=bearing_in_diam, h=(bearing_height/2-clearance));
}
