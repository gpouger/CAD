require 'utils'

height = 3
small_size = 40
big_size = 70

function shapes(size, with_rectangles)
  with_rectangles = with_rectangles or false
  s = {
--    cube(size, size, height),
--    cylinder(size/2, height),
--    linear_extrude( v(0, 0, height), {v(0, 0), v(size, 0), v(size/2, math.sqrt(size^2-(size/2)^2))} )
  }
  if with_rectangles then
    table.insert(s, cube(size, size/2, height))
    table.insert(s, cube(size, size/4, height))
  end
  return s
end

small_shapes = shapes(small_size, true)
big_shapes = shapes(big_size)

all_shapes = {}
for i, s in ipairs(big_shapes) do table.insert(all_shapes, s) end
for i, s in ipairs(small_shapes) do table.insert(all_shapes, s) end

build_plate(all_shapes, 180, 260, 2)