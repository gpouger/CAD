bearing_diam = 22;
bearing_height = 7;
nb_branches = 3;
dist_between_bearings = 25;
border_width = 0;
recess_depth = bearing_diam / 2.5;

out_circle_radius = bearing_diam/2+border_width;
recess_contact_dist = sqrt(pow(dist_between_bearings, 2) - pow(out_circle_radius, 2));

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

module outer_shell_one_bearing()
{
  translate([dist_between_bearings, 0, bearing_height/2])
    rotate_extrude()
      union()
      {
        translate([out_circle_radius, 0, 0]) circle(d = bearing_height);
        translate([out_circle_radius/2, 0, 0]) square(size=[out_circle_radius, bearing_height], center=true);
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
      rotate(a=angle*i) outer_shell_one_bearing();
    }
  }
}

module recess()
{
  angle_branches = 360/nb_branches;
  angle_recess = angle_branches - 2*asin(out_circle_radius / dist_between_bearings);
  recess_height = bearing_height + 1;
  
  c = 2*dist_between_bearings * sin(angle_recess/2);
  
  recess_radius = (pow(c,2)/4 + pow(recess_depth,2))/(2*recess_depth);
  
  recess_center_dist = sqrt(pow(dist_between_bearings,2) - pow(c/2,2)) + sqrt(pow(recess_radius,2) - pow(c/2,2));
  
  for(i=[0:nb_branches])
  {
    rotate(a=angle_branches*(i+0.5))
      translate([recess_center_dist, 0, bearing_height/2])
        rotate_extrude()
          difference()
          {
            translate([recess_radius/2, 0, 0]) square(size=[recess_radius, recess_height], center=true);
            translate([recess_radius, 0, 0]) circle(d = bearing_height);
          }
  }
}

difference()
{
  union()
  {
    outer_shell();
    cylinder(h=bearing_height, r=recess_contact_dist);
  }
  recess();
  translate([0, 0, -0.5]) place_bearings(height=bearing_height+1);
}
*recess();