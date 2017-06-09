module Pencil_Holder(in_diam=30, out_diam=40, top_lip_height=5, top_bevel_height=0, body_height=100, walls=1, tolerance=0.2, round_bottom=false, upside_down=true, bevelled_inside=false)
{
  // in_diam: diameter of the smaller hole in the desk (outside dimension of the object)
  // out_diam: diameter of the bigger hole on top (outside dimension of the lip)
  // top_height: height of the lip (outside dimension)
  // body_height: inside depth of the pencil holder
  // walls: width of the walls (difference between inside and outside dimension on the main part)
  // tolerance: removed size for places where object needs to fit in hole

  real_top_lip_height = top_lip_height - tolerance;
  real_out_diam = out_diam - tolerance*2;
  real_body_height = body_height + walls;
  real_in_diam = in_diam - tolerance*2;
  hole_diam = real_in_diam - walls*2;

  $fa = 1;
  $fs = 1;
  
  translate([0, 0, upside_down ? real_body_height+real_top_lip_height+top_bevel_height : 0]) rotate([upside_down ? 180 : 0, 0, 0])
  union()
  {
    difference()
    {
      // solid outer part
      union()
      {
        // outer lip
        translate([0, 0, real_body_height+top_bevel_height]) cylinder(h=real_top_lip_height, d=real_out_diam);
        
        if(top_bevel_height > 0)
        {
          // bevel
          translate([0, 0, real_body_height]) cylinder(h=top_bevel_height, d1=real_in_diam, d2=real_out_diam);
        }

        // pencil holder body
        cylinder(h=real_body_height, d=real_in_diam);
      }

      // main hole
      if(round_bottom)
      {
        // completely through hole for round bottom
        translate([0, 0, -walls/2]) cylinder(h=real_body_height+real_top_lip_height+top_bevel_height+walls, d=hole_diam);
      }
      else
      {
        // keep bottom solid
        translate([0, 0, walls]) cylinder(h=real_body_height+real_top_lip_height+top_bevel_height+walls, d=hole_diam);
      }
      
      if(top_bevel_height > 0 && bevelled_inside)
      {
        // bevelled top hole
        translate([0, 0, real_body_height]) cylinder(h=top_bevel_height+real_top_lip_height, d1=hole_diam, d2=real_out_diam-max(walls*2, 5));
      }
    }
    
    if(round_bottom)
    {
      // round bottom
      difference()
      {
        sphere(d=real_in_diam);
        sphere(d=hole_diam);
        translate([0, 0, in_diam/2]) cube(size=in_diam, center=true);
      }
    }
  }
}
