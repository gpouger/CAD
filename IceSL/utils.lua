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