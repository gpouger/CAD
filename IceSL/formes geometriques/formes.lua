require "utils"

height = 70.0
width = 45.0

radius = width/2
triangle_y = math.sqrt(width^2-(width/2)^2)

function cylindre()
  return cylinder(radius, height)
end

function cone_()
  return cone(radius, 0, height)
end

function cube_()
  return cube(width)
end

function sphere_()
  return sphere(radius, v(0, 0, radius))
end

function prisme_base_triangle()
  triangle = {v(-width/2,0,0), v(width/2,0,0), v(0,triangle_y,0)}
  return linear_extrude(v(0,0,height), triangle)
end

function prisme_base_carree()
  return cube(width, width, height)
end

function pyramide_base_triangle()
  points = {v(-width/2,0,0), v(width/2,0,0), v(0,triangle_y,0), v(0, triangle_y/3, height)}
  faces = {v(0,2,1), v(0,1,3), v(1,2,3), v(2,0,3)}
  return polyhedron(points, faces)
end

function pyramide_base_carree()
  points = {v(0,0,0), v(width,0,0), v(0,width,0), v(width,width,0), v(width/2, width/2, height)}
  faces = {v(0,3,1), v(0,2,3), v(0,1,4), v(1,3,4), v(3,2,4), v(2,0,4)}
  return polyhedron(points, faces)
end

function ellipsoid()
  s = sphere(radius, v(0, 0, radius))
  return scale(0.8, 0.8, 1.2)*s
end

function egg_base(egg_factor, z_height, z_precision, xy_precision)
	b = egg_factor or 0.7
	a = z_height or 1
	z_precision = z_precision or 500
    xy_precision = xy_precision or 200
	
	function egg_y(x)
		c = a - b
		ret = math.sqrt(4*b*x + c^2)
		ret = ret + c - 2*x
		ret = math.sqrt(ret) / math.sqrt(2) * math.sqrt(x)
		return ret
	end

	points = {}
	
	steps = z_precision
	step = 1/steps
	for i=1,steps do
		x = i*step
		y = egg_y(x)
		points[i] = v(y, x, 0)
	end
    points[steps+1] = v(0,0,0)
	
    return rotate(180,0,0)*rotate_extrude(points, xy_precision)
end

function egg()
    return scale(v(53, 53, 53))*egg_base()
end

--simple_shapes = {cylindre(), cone_(), cube_(), prisme_base_triangle(), prisme_base_carree(), pyramide_base_triangle(), pyramide_base_carree()}

complex_shapes = {sphere_(), ellipsoid(), egg()}

emit(group_grid(complex_shapes, 2, 5))

set_setting_value('num_shells_0', 2)
set_setting_value('cover_thickness_mm_0', 0.6)
set_setting_value('gen_cavity', true)