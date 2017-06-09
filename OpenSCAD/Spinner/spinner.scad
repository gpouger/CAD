bearing_diam = 22;
bearing_height = 7;
nb_branches = 3;
dist_between_bearings = 30;
border_width = 0;

$fn=64;

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
  translate([x, y, z+bearing_height/2])
    rotate_extrude()
      translate([bearing_diam/2+border_width, 0, 0])
        circle(d = bearing_height);
}

module outer_shell()
{
  angle = 360/nb_branches;
  union()
  {
    for(i=[0:nb_branches])
    {
      hull()
      {
        outer_shell_one_bearing();
        rotate(a=angle*i) outer_shell_one_bearing(x=dist_between_bearings);
      }
    }
  }
}
difference()
{
  outer_shell();
  translate([0,0,-0.5]) place_bearings(height=bearing_height+1);
}
