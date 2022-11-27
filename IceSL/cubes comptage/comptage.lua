require "utils"

block_size = 10
line_width = 2

function one_cube()
  c = ccube(block_size)

  border1 = translate(block_size/2, 0, -(block_size/2))*ccube(line_width/2, block_size, line_width/2)
  border2 = translate(-block_size/2, 0, -(block_size/2))*ccube(line_width/2, block_size, line_width/2)
  border3 = translate(-block_size/2, 0, (block_size/2))*ccube(line_width/2, block_size, line_width/2)
  border4 = translate(block_size/2, 0, (block_size/2))*ccube(line_width/2, block_size, line_width/2)

  y_borders = union({border3, border4})
  x_borders = rotate(90, v(0,0,1))*y_borders
  z_borders = rotate(90, v(1,0,0))*union({border1,border2,border3,border4})

  all_borders = union({x_borders, y_borders, z_borders})

  c = difference(c, all_borders)
  
  return c
end

function line_cubes(nb)
  l = one_cube()
  for i=1,(nb-1) do
    l = union(translate(i*block_size, 0, 0)*one_cube(), l)
  end
  return l
end

function line_10()
   return line_cubes(10)
end

function square_100_old()
  s = line_10()
  for i=1,9 do
    s = union(translate(0, i*block_size, 0)*line_10(), s)
  end
  return s
end

function square_100()
  l = block_size*10
  c = ccube(l, l, block_size)

  border_y = translate(l/2, 0, (block_size/2))*ccube(line_width/2, l+10, line_width/2)
  
  borders_xy = border_y
  for i=1,10 do
    borders_xy = union(borders_xy, translate(-i*block_size, 0, 0)*border_y)
  end
  borders_xy = union(borders_xy, rotate(0, 0, 90)*borders_xy)

  border_z = translate(0, -l/2+block_size/2, 0)*rotate(90, 0, 0)*border_y
  borders_z = border_z
  for i=1,10 do
    borders_z = union(borders_z, translate(-i*block_size, 0, 0)*border_z)
  end
  borders_z = union(borders_z, rotate(0, 0, 90)*borders_z)
  borders_z = union(borders_z, rotate(0, 0, 180)*borders_z)

  c = difference(c, union(borders_xy, borders_z))

  return c
end

function cube_1000()
  l = block_size*10
  c = ccube(l)

  border_y = translate(l/2, 0, -(l/2))*ccube(line_width/2, l+10, line_width/2)

  borders_y = border_y
  for i=1,10 do
    borders_y = union(borders_y, translate(0, 0, block_size*i)*border_y)
  end
  borders_y = union(borders_y, rotate(90, 0, 0)*borders_y)
  borders_z = rotate(0, -90, 0)*borders_y
  borders_y = union(borders_y, rotate(0, 0, 180)*borders_y)

  borders_x = rotate(0, 0, -90)*borders_y
  
  return difference(c, union({borders_x, borders_y, borders_z}))
end

function ten_single_squares()
  shapes = {}
  for i=1,20 do
    table.insert(shapes, one_cube())
  end
  build_plate(shapes, 100, 150, 2)
end

function ten_bars()
  shapes = {}
  for i=1,10 do
    table.insert(shapes, line_10())
  end
  build_plate(shapes, 105, 150, 2)
end

ten_bars()