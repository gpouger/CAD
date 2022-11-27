require "utils"

lid_length = 74
lid_height = 13
wall_thickness = 2.05
tolerance = 0.5
base_height = 1
base_lip_height = 5
radius = 25
bottom_hole_border_size = 10

function lid_holder(nb_lids, nb_holders)
  nb_holders = nb_holders or 1

  outer_length = lid_length + 2*tolerance + 2*wall_thickness
  inner_length = lid_length + 2*tolerance
  side_height = lid_height*nb_lids
  
  outer = rounded_box(outer_length, outer_length, side_height, radius)
  inner = translate(0, 0, base_height)*rounded_box(inner_length, inner_length, side_height, radius-wall_thickness)
  
  side_cutout = translate(0, 0, base_height+base_lip_height)*cube(outer_length, lid_length-2*radius, side_height)
  side_cutout = union(side_cutout, rotate(0, 0, 90)*side_cutout)

  bottom_cutout = rounded_box(inner_length-2*bottom_hole_border_size, inner_length-2*bottom_hole_border_size, base_height, radius-wall_thickness-bottom_hole_border_size)

  corner_cutout = translate(lid_length/2, lid_length/2, base_height+base_lip_height) * cube(lid_length, lid_length, side_height)

  one_holder = difference(outer, union{inner, side_cutout, bottom_cutout, corner_cutout})

  holders = {rotate(0, 0, 180)*one_holder}
  offset = lid_length+2*tolerance+wall_thickness
  if nb_holders > 1 then
    holders[2] = translate(0,offset,0)*rotate(0, 0, 90)*one_holder
    if nb_holders == 3 then
      holders[3] = translate(0,-offset,0)*rotate(0, 0, 90)*one_holder
    else
      if nb_holders == 4 then
        holders[3] = translate(offset,0,0)*rotate(0, 0, -90)*one_holder
        holders[4] = translate(offset,offset,0)*one_holder
      end
    end
  end

  return union(holders)

end

emit(lid_holder(6, 2))
