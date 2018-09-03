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
        x = (i-1) % nb_col
        y = math.floor((i-1) / nb_col)
		s = union(s, translate(x*x_step, y*y_step, 0) * center_shape(shape))
    end
	
	return s
end
