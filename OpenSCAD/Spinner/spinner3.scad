bearing_diam = 22;
bearing_height = 7;
nb_branches = 3;
dist_between_bearings = 30;
border_width = 5;

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

module outer_shell_one_bearing()
{
  cylinder(d=bearing_diam+border_width*2, h=bearing_height);
}

module junction_bars_one_bearing()
{
  bar_len = dist_between_bearings;
  bar_offset = bearing_diam/2;
  union()
  {
    translate([bar_len/2,bar_offset+border_width/2, bearing_height/2]) cube(size=[bar_len,border_width,bearing_height], center=true);
    translate([bar_len/2,-(bar_offset+border_width/2), bearing_height/2]) cube(size=[bar_len,border_width,bearing_height], center=true);
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
      rotate(a=angle*i) union()
      {
        translate([dist_between_bearings,0,0]) outer_shell_one_bearing();
        junction_bars_one_bearing();
      }
    }
  }
}

difference()
{
  outer_shell();
  translate([0, 0, -0.5]) place_bearings(height=bearing_height+1);
}