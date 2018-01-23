require "montessori_inset_lib"

scale_factor_xy = 1

-- equilateral triangle
triangle_side = 100/scale_factor_xy
outer_circle_diameter = triangle_side/math.sqrt(3)*2
h = triangle_side*math.sqrt(3)/2
offset = v(-h/6,0,0)
-- base
b = regular_polygon_base(3, outer_circle_diameter, base_width/scale_factor_xy, base_height, offset)
-- inset
i = regular_polygon_inset(3, outer_circle_diameter, base_height, offset)

emit(b)
emit(i)
