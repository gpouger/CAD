require("utils")

s = extrude_svg_contour('test.svg', 1)
s = rotate(0, 0, -90)*s
--s = xy_scale_to_y(s, bed_size_y_mm)

emit(s)