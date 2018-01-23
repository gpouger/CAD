 -- welcome to IceSL!

base_width = 140
base_height = 5
holder_radius = 5
holder_height = 10
tolerance = 0.4

function holder(radius, height, z_offset)
    radius = radius or holder_radius
    height = height or holder_height
    z_offset = z_offset or base_height
    return cylinder(radius, v(0,0,z_offset), v(0,0,z_offset+height))
end

function base(width, height)
	width = width or base_width
	height = height or base_height
	return cube(width, width, height)
end

function rectangle_base(rect_long_width, rect_short_width, total_width, height)
	total_width = total_width or base_width
    height = height or base_height
	rect_hole_width_long = rect_long_width + tolerance
    rect_hole_width_short = rect_short_width + tolerance
    return difference(base(total_width, height), cube(rect_hole_width_long, rect_hole_width_short, height))
end

function rectangle_inset(rect_long_width, rect_short_width, height)
    height = height or base_height
    rect_inset_width_long = rect_long_width - tolerance
    rect_inset_width_short = rect_short_width - tolerance
    return union(cube(rect_inset_width_long, rect_inset_width_short, base_height), holder(holder_radius, holder_height, height))
end

function circle_base(circle_diameter, total_width, height)
	total_width = total_width or base_width
    height = height or base_height
	circle_hole_radius = (circle_diameter + tolerance) / 2
    return difference(base(total_width, height), cylinder(circle_hole_radius, v(0,0,0), v(0,0,height)))
end

function circle_inset(circle_diameter, height)
    height = height or base_height
    circle_inset_radius = (circle_diameter - tolerance) / 2
    return union(cylinder(circle_inset_radius, v(0,0,0), v(0,0,height)), holder(holder_radius, holder_height, height))
end

function regular_polygon_shape(nb_vertices, diameter, height)
    height = height or base_height
	offset = offset or v(0,0,0)
    angle = 360/nb_vertices
    first_point = v(diameter/2,0,0)
    points = {first_point}
    for i=2,nb_vertices do
        points[i] = rotate(angle*(i-1),Z)*first_point
    end
    return linear_extrude(v(0,0,height), points)
end

function regular_polygon_base(nb_vertices, diameter, total_width, height, offset)
	total_width = total_width or base_width
    height = height or base_height
	offset = offset or v(0,0,0)
	shape_diam = diameter + tolerance
	return difference(base(total_width, height), regular_polygon_shape(nb_vertices, shape_diam, height, offset) * translate(offset))
end

function regular_polygon_inset(nb_vertices, diameter, height, offset)
    height = height or base_height
	offset = offset or v(0,0,0)
	shape_diam = diameter - tolerance
	return union(regular_polygon_shape(nb_vertices, shape_diam, height), holder(holder_radius, holder_height, height)) * translate(offset)
end