require("utils")

z = 0.3
outer_max = 119

--s = extrude_svg_contour('snowman.svg', z)
--s = extrude_svg_contour('sapin3.svg', z)
s = extrude_svg_contour('flocon2.svg', z)

shape_bbox = bbox(s)
target = outer_max - 20
if shape_bbox:extent().x > shape_bbox:extent().y then
  s = xy_scale_to_x(s, target)
else
  s = xy_scale_to_y(s, target)
end
s = center_shape_xy(s)

shape_extent = bbox(s):extent()
outer_x = math.min(shape_extent.x + 20, outer_max)
outer_y = math.min(shape_extent.y + 20, outer_max)
b = cube(outer_x, outer_y, z)

final_shape = difference(b,s)

emit(final_shape)
--dump(to_mesh(final_shape, 0.5), 'pochoir_flocon.stl')