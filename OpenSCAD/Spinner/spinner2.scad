bearing_diam = 22;
bearing_height = 7;
nb_branches = 3;
dist_between_bearings = 24;
border_width = 1.5;

$fn=32;

module bearing(x=0, y=0, z=0, height=bearing_height)
{
  translate([x, y, z]) cylinder(h=height, d=bearing_diam);
}

module place_bearings(height=bearing_height)
{
  angle = 360/nb_branches;
  bearing(height=height);
  for(i=[0:nb_branches])
  {
    rotate(a=angle*i) bearing(x=dist_between_bearings, height=height);
  }
}

module outer_shell_one_bearing(x=0, y=0, z=0)
{
  dist = bearing_diam/2+border_width;
  translate([x, y, z+bearing_height/2])
    rotate_extrude()
      union()
      {
        translate([dist, 0, 0]) circle(d = bearing_height);
        translate([dist/2, 0, 0]) square(size=[dist, bearing_height], center=true);
      }
}

module outer_shell()
{
  angle = 360/nb_branches;
  union()
  {
    outer_shell_one_bearing(); // center bearing
    for(i=[0:nb_branches])
    {
      rotate(a=angle*i) outer_shell_one_bearing(x=dist_between_bearings);
    }
  }
}

difference()
{
  outer_shell();
  translate([0, 0, -0.5]) place_bearings(height=bearing_height+1);
}