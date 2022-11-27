require "utils"

lid_diameter = 56.5
lid_height = 8
wall_thickness = 2.05
tolerance = 0.3
base_height = 1
base_lip_height = 1
bottom_hole_border_size = 6

function pie_slice(radius, angle, height)
  shape = cylinder(radius, height)
  
  triangle = { v(0,0), v(radius,radius), v(-radius,radius)}
  triangle_cutout = linear_extrude(v(0,0,height), triangle)

  return intersection(shape, triangle_cutout)
end

function lid_holder_round(nb_lids, nb_holders)
  nb_holders = nb_holders or 1

  outer_diam = lid_diameter + 2*tolerance + 2*wall_thickness
  inner_diam = lid_diameter + 2*tolerance
  side_height = lid_height*nb_lids
  total_height = side_height + base_height
  
  outer = cylinder(outer_diam/2, total_height)
  inner = translate(0, 0, base_height)*cylinder(inner_diam/2, side_height+1)

  cutout1 = pie_slice(outer_diam/2+1, 90, side_height)
  cutout2 = rotate(0,0,180)*cutout1
  side_cutout = union(cutout1, cutout2)

  side_cutout = translate(0, 0, base_height+base_lip_height)*side_cutout
  --side_cutout = translate(0, 0, base_height+base_lip_height)*cube(outer_diam, lid_diameter/1.5, side_height)
  --side_cutout = union(side_cutout, rotate(0, 0, 90)*side_cutout)

  bottom_cutout = cylinder(inner_diam/2-bottom_hole_border_size, total_height)

  one_holder = rotate(0,0,90)*difference(outer, union{inner, side_cutout, bottom_cutout})

  holders = {one_holder}
  offset = lid_diameter+2*tolerance+wall_thickness
  for i=2,nb_holders do
    holders[i] = translate(0, offset*(i-1), 0)*one_holder
  end

  return union(holders)

end

emit(lid_holder_round(10, 2))
--emit(translate(0,0,base_height+base_lip_height)*pie_slice(outer_diam/2, 90, side_height))
