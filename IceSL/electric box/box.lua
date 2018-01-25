require "utils"

box_width = 50
box_length = 60
box_height = 25
box_rounding_radius = 5
wall_thickness = 1.2
screw_holes_radius = 1.5
entry_hole_radius = 5
entry_hole_offset_from_top = 45
output_hole_radius = 3
output_hole_length = 5
output_hole_offset_from_plate = 0

function box()
    outer_shell = rounded_box(box_width, box_length, box_height, box_rounding_radius)
    inner_hole = translate(v(0, 0, wall_thickness))*rounded_box(box_width-wall_thickness*2, box_length-wall_thickness*2, box_height, box_rounding_radius-wall_thickness)
	
    box = difference(outer_shell, inner_hole)

    -- drill screw holes in the corners
    hole_cylinder = cylinder(screw_holes_radius, wall_thickness)
    hole_offset = wall_thickness + screw_holes_radius + 5
    hole_x_offset = box_width/2 - hole_offset
    hole_y_offset = box_length/2 - hole_offset
    box = difference(box, translate(v(-hole_x_offset, hole_y_offset, 0))*hole_cylinder)
    box = difference(box, translate(v(hole_x_offset, hole_y_offset, 0))*hole_cylinder)
    box = difference(box, translate(v(-hole_x_offset, -hole_y_offset, 0))*hole_cylinder)
    box = difference(box, translate(v(hole_x_offset, -hole_y_offset, 0))*hole_cylinder)

    -- entry hole in the back
    hole_cylinder = cylinder(entry_hole_radius, wall_thickness)
    box = difference(box, translate(v(0, box_length/2-entry_hole_radius-entry_hole_offset_from_top, 0))*hole_cylinder)

    -- output hole on top
    hole_cylinder = translate(v(0, box_length/2, wall_thickness/2))*rotate(90, X)*cylinder(output_hole_radius, output_hole_length)
    box = difference(box, hole_cylinder)

	return box
end

emit(box())