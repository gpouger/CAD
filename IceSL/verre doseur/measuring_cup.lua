require "utils"

volume_max_ml = 100
volume_step_ml = 10
add_height = 5
radius = 25
wall = 1
mark_width = 0.5
text_width = 5

base_bec = 12
h_bec = 6

flat_angle = (360*(text_width+2)) / (2*radius*math.pi)

function pyramide_base_triangle(b, h)
  triangle_y = math.sqrt(b^2-(b/2)^2)
  points = {v(-b/2,0,0), v(b/2,0,0), v(0,triangle_y,0), v(0, triangle_y/3, h)}
  faces = {v(0,2,1), v(0,1,3), v(1,2,3), v(2,0,3)}
  return rotate(0,180,0)*polyhedron(points, faces)
end

function mark(value, h)
  r = v(radius, 0, 0)
  triangle = { r + v(0,-mark_width/2,0), r + v(0,mark_width/2,0), r + v(-mark_width,0,0) }
  s = rotate_extrude(triangle, 100)
  s = difference(s, translate(0,0,-mark_width)*pie_slice(radius, mark_width*2, flat_angle))

  f = font()
  t = center_shape_xy(f:str(""..value, 2))
  t = xy_scale_to_x(t, text_width)
  t = z_scale(t, mark_width)
  t = translate(0,radius,0)*rotate(90,0,0)*t

  s = union(s, t)
  
  return translate(0,0,h)*s
end

base_area = math.pi * math.pow(radius, 2)
height = volume_max_ml * 1000  / base_area + add_height

mark_interval = 10 * 1000 / base_area

bec = translate(0,radius-base_bec/3,height)*pyramide_base_triangle(base_bec,h_bec)
--emit(bec_inner)

inner = union(cylinder(radius, height), translate(0,-wall,0)*bec)
outer = union(translate(0,0,-wall)*cylinder(radius+wall, height+wall), bec)

s = difference(outer, inner)

for h = mark_interval, height, mark_interval do
  i = h / mark_interval
  vol = volume_step_ml * i
  s = union(s, rotate(0,0,-flat_angle*2*(i-1))*mark(vol, h))
end

emit(s)
--emit(mark(10,0))
