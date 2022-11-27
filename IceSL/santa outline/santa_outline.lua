require("utils")

s = extrude_svg_contour("santaCombined.svg", 4)
s = rotate(180, 0, -90)*s
s = center_shape_xy(xy_scale_to_y(s, 500))

t = center_shape_xy(ccube(400, 250, 10))
s = intersection(s, translate(0, 250/2, 0)*t)

emit(s)