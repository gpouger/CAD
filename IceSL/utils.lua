function concat_lists(l1, l2)
  for i=1,#l2 do
        l1[#l1+1] = l2[i]
    end
    return l1
end

function scale_to_x(shape, want_x)
	shape_bbox = bbox(shape)
    scale_factor = want_x / shape_bbox:extent().x
    return scale(scale_factor, scale_factor, scale_factor)*shape
end

function scale_to_y(shape, want_y)
	shape_bbox = bbox(shape)
    scale_factor = want_y / shape_bbox:extent().y
    return scale(scale_factor, scale_factor, scale_factor)*shape
end

function z_scale(shape, height)
    shape_bbox = bbox(shape)
    z_scale_factor = height / shape_bbox:extent().z
    return scale(1, 1, z_scale_factor)*shape
end

function xy_scale(shape, diam)
    shape_bbox = bbox(shape)
    max_dimension = math.max(shape_bbox:extent().x, shape_bbox:extent().y)
    xy_scale_factor = diam / max_dimension
    return scale(xy_scale_factor, xy_scale_factor, 1)*shape
end

function xy_scale_to_x(shape, want_x)
    shape_bbox = bbox(shape)
    xy_scale_factor = want_x / shape_bbox:extent().x
    return scale(xy_scale_factor, xy_scale_factor, 1)*shape
end

function xy_scale_to_y(shape, want_y)
    shape_bbox = bbox(shape)
    xy_scale_factor = want_y / shape_bbox:extent().y
    return scale(xy_scale_factor, xy_scale_factor, 1)*shape
end

function xy_offs_to_center(shape)
	shape_bbox = bbox(shape)
    shape_center = shape_bbox:center()
	xy_offs = v(-shape_center.x, -shape_center.y, 0)
	return xy_offs
end

function move_bottom_to_z(shape, wanted_z)
	wanted_z = wanted_z or 0
	return translate(0,0,-(bbox(shape):min_corner().z)+wanted_z)*shape
end

function center_shape_xy(shape)
	-- center the shape
    return translate(xy_offs_to_center(shape))*shape
end

function center_shape(shape)
	-- center the shape
    shape_bbox = bbox(shape)
    shape_center = shape_bbox:center()
	return translate(-shape_center.x, -shape_center.y, -(shape_center.z-shape_bbox:extent().z/2))*shape
end

function center_and_scale_shape(shape, diam, height)
    -- center the shape
    shape = center_shape(shape)

    -- scale it to have the desired height
    shape = z_scale(shape, height)

    -- scale it to fit the given diameter
    shape = xy_scale(shape, diam)

    return shape
end

function center_text(text, diam, height, inverted, tracking, font_file)
	inverted = inverted or false
	tracking = tracking or 10
	font_file = font_file or "ARIALBD.TTF"
    font_path = Path .. font_file
    f = font(font_path)
    txt = f:str(text, tracking)
	
	if inverted then
		txt = rotate(0, 180, 0)*txt
	end

    return center_and_scale_shape(txt, diam, height)
end

function rounded_box(w, l, h, r)
    -- produces a box with flat top and bottom, and rounded corners with radius r
    corner_neg = difference(cube(r, r, h), translate(v(r/2, r/2, 0))*cylinder(r, h))
    c = cube(w, l, h)
    x_offs = w/2-r/2
    y_offs = l/2-r/2
    c = difference(c, rotate(0, Z)*translate(v(-x_offs, -y_offs, 0))*corner_neg)
    c = difference(c, translate(v(-x_offs, y_offs, 0))*rotate(-90, Z)*corner_neg)
    c = difference(c, translate(v(x_offs, -y_offs, 0))*rotate(90, Z)*corner_neg)
    c = difference(c, translate(v(x_offs, y_offs, 0))*rotate(180, Z)*corner_neg)
    return c
end

function extrude_svg(svg_file, extrude_height)
	-- get all the contours from an SVG file and transform them to a single 3D shape
	svg_shapes = svg_ex(svg_file, 90)
	svg_shape = linear_extrude(v(0, 0, extrude_height), svg_shapes[1]:outline())
	for i,contour in pairs(svg_shapes) do
		if i > 1 then
			svg_shape = union(svg_shape, linear_extrude(v(0,0,extrude_height),contour:outline()))
		end
	end
	
	return svg_shape
end

function extrude_svg_contour(svg_file, extrude_height)
	-- get all the contours from an SVG file and transform them to a single 3D shape
	svg_shapes = svg_contouring(svg_file, 90)
	svg_shape = linear_extrude(v(0, 0, extrude_height), svg_shapes[1]:outline())
	for i,contour in pairs(svg_shapes) do
		if i > 1 then
			svg_shape = union(svg_shape, linear_extrude(v(0,0,extrude_height),contour:outline()))
		end
	end
	
	return svg_shape
end

function group_grid_offset(index, nb_col, spacing, max_size_x, max_size_y)
    x_step = max_size_x + spacing
    y_step = max_size_y + spacing
	
	x = (index-1) % nb_col
    y = math.floor((index-1) / nb_col)
	
	return v(x*x_step, y*y_step)
end

function group_grid(shapes, nb_col, spacing)
    max_size_x=0
    max_size_y=0
    for i, shape in ipairs(shapes) do
        s_bbox = bbox(shape)
        max_size_x = math.max(s_bbox:extent().x, max_size_x)
        max_size_y = math.max(s_bbox:extent().y, max_size_y)
    end

    x_step = max_size_x + spacing
    y_step = max_size_y + spacing
	
	s = cube(0, 0, 0)

    for i, shape in ipairs(shapes) do
		offs = group_grid_offset(i, nb_col, spacing, max_size_x, max_size_y)
		s = union(s, translate(offs.x, offs.y, 0) * center_shape(shape))
    end
	
	return s
end

local binpack_new = require('binpack')function build_plate(shapes, x_max, y_max, spacing)
	-- usage: build_plate(shapes, 200, 260, 2)
	y_max = y_max or x_max
	spacing = spacing or 8
	
	local bp = binpack_new(x_max, y_max)
	for i, shape in ipairs(shapes) do
		local s_bbox = bbox(shape)
        local s_center = s_bbox:center()
		local s_min = s_bbox:min_corner()
		local s_extent = s_bbox:extent()
		local pos = bp:insert(s_extent.x+spacing, s_extent.y+spacing)
		emit(translate(pos.x-s_min.x+spacing/2, pos.y-s_min.y+spacing/2, -(s_center.z-s_extent.z/2))*shape)
    end
end

function emit_multiple_shapes(shape, num, x_max, y_max, spacing)
  shapes = {}
  for i=1,num do
    table.insert(shapes, shape)
  end
  build_plate(shapes, x_max, y_max, spacing)
end

function multiple_stl(fpath, num, x_max, y_max, spacing)
  -- usage: multiple_stl(stl_file_path, 12, 200, 260, 2)
  emit_multiple_shapes(load_centered_on_plate(fpath), num, x_max, y_max, spacing)
end

function hexagon_l(l, height)
  w = l/(2*sin(60))
  b = cube(w, l, height)
  return(union({b, rotate(0, 0, 60)*b, rotate(0, 0, -60)*b}))
end

function hexagon_s(side, height)
  l = side * (2*sin(60))
  b = cube(side, l, height)
  return(union({b, rotate(0, 0, 60)*b, rotate(0, 0, -60)*b}))
end

function triangle(b, h)
  h = h or math.sqrt(b^2-(b/2)^2)
  t = {v(-b/2,0,0), v(b/2,0,0), v(0,h,0)}
  return t
end

function losange(side, small_diagonal)
  b = small_diagonal or side
  h = math.sqrt(side^2-(b/2)^2)
  l = {v(-b/2,0,0), v(0,-h,0), v(b/2,0,0), v(0,h,0)}
  return l
end

function prisme_base_triangle(side, z_height, triangle_height)
  triangle_2d = triangle(side, triangle_height)
  return linear_extrude(v(0,0,z_height), triangle_2d)
end

function prisme_base_losange(side, z_height, small_diagonal)
  small_diagonal = small_diagonal or side
  losange_2d = losange(side, small_diagonal)
  return linear_extrude(v(0,0,z_height), losange_2d)
end

function torus(r_major, r_minor)
	local points = {};
	local indices = {};
	for angle_major = 0, 361, 1 do
		for angle_minor = 0, 361, 1 do
			points[(360 * angle_minor) + angle_major] = v(
				(r_major + r_minor*cos(angle_minor)) * cos(angle_major),
				(r_major + r_minor*cos(angle_minor)) * sin(angle_major),
				r_minor * sin(angle_minor));
		end
	end
	for angle_major = 0, 360, 1 do
		for angle_minor = 0, 360, 1 do
			table.insert(indices, v(
				(360*angle_minor) + angle_major,
				(360*angle_minor) + ((1+angle_major)%360),
				angle_major+(360*(angle_minor+1))));
			table.insert(indices, v(
				(360*angle_minor) + ((1+angle_major)%360),
				((angle_major+1)%360)+(360*(angle_minor+1)),
				angle_major+(360*(angle_minor+1))));
		end
	end
	
	return polyhedron(points, indices);
end

function pie_slice(r, h, angle)
  s = cylinder(r, h)
  c = translate(0,-r,0)*cube(r*3,r*2,h)
  s = difference(s, rotate(0,0,-90+angle/2)*c)
  s = difference(s, rotate(0,0,90-angle/2)*c)
  return s
end