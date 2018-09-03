require "utils"

wall_thickness = 0.5
decor_thickness = 0.2
tolerance = 0.5

function key_cover(svg_file, svg_shape_index, key_width, key_thickness, hole_size, hole_y_offset, key_flat_width, insertion_hole_ratio, decor_file, decor_size, decor_y_offset)
  svg_shapes = svg_ex(svg_file, 90)

  -- add tolerance
  key_width = key_width + tolerance
  key_thickness = key_thickness + tolerance
  key_flat_width = key_flat_width + tolerance
  
  
  -- shape of the key head from SVG file (used to cut the hole)
  key_shape = rotate(180, 0, 0)*linear_extrude(v(0, 0, key_thickness), svg_shapes[svg_shape_index]:outline())
  sizes = bbox(key_shape):extent()
  size_factor = key_width/sizes.x
  key_shape = center_shape(scale(size_factor, size_factor, 1)*key_shape)

  -- shape of the key cover (key shape expanded)
  cover_shape = translate(0, 0, -wall_thickness)*center_shape(linear_offsets(key_shape,{v(1,0,0), v(0,1,0), v(0,0,1)}, {wall_thickness, wall_thickness, wall_thickness}))

  cover = difference(cover_shape, key_shape)
  cover_sizes = bbox(cover):extent()

  -- add keyring hole
  cover = difference(cover, translate(0, cover_sizes.y/2 - hole_size/2 - hole_y_offset, -wall_thickness)*cylinder(hole_size/2, key_thickness+2*wall_thickness))

  -- add insertion hole
  cover = difference(cover, translate(0, cover_sizes.y/insertion_hole_ratio, 0)*cube(cover_sizes.x, cover_sizes.y, key_thickness))

  -- add output hole
  cover = difference(cover, translate(0, 0, 0)*cube(key_flat_width, cover_sizes.y, key_thickness))

  -- add decor
  decor = center_shape(extrude_svg(decor_file, decor_thickness))
  decor = translate(0, decor_y_offset, 0)*xy_scale(rotate(0, 0, 180)*decor, decor_size)
  cover = union(cover, translate(0, 0, key_thickness+wall_thickness)*decor)
  cover = union(cover, translate(0, 0, -wall_thickness-decor_thickness)*decor)

  --set_setting_value("process_thin_features", 0)
  set_setting_value("brim_distance_to_print_mm", 0)
  set_setting_value("brim_num_contours", 4)
  set_setting_value("infill_percentage_0", 100)
  set_setting_value("num_shells_0", 0)

  return cover
end

function key_cover_house()
  svg_file = 'iseo_r6_big_3.svg'
  svg_shape_index = 2
  key_width = 28.5
  key_thickness = 2.8
  hole_size = 5.75
  hole_y_offset = 2
  key_flat_width = 12
  insertion_hole_ratio = 1.5
  decor_file = "home.svg"
  decor_size = 15
  decor_y_offset = 0
  
  mesh = key_cover(svg_file, svg_shape_index, key_width, key_thickness, hole_size, hole_y_offset, key_flat_width, insertion_hole_ratio, decor_file, decor_size, decor_y_offset)

  return mesh
end

function key_cover_garage()
  svg_file = 'iseo_r6_small.svg'
  svg_shape_index = 2
  key_width = 24.5
  key_thickness = 2.8
  hole_size = 5.75
  hole_y_offset = 3.35
  key_flat_width = 12
  insertion_hole_ratio = 1.5
  decor_file = "garage.svg"
  decor_size = 15
  decor_y_offset = -1.5
  
  mesh = key_cover(svg_file, svg_shape_index, key_width, key_thickness, hole_size, hole_y_offset, key_flat_width, insertion_hole_ratio, decor_file, decor_size, decor_y_offset)

  return mesh
end

function key_cover_legallais(decor_file, decor_size, decor_y_offset)
  svg_file = 'legallais.svg'
  svg_shape_index = 1
  key_width = 28.5
  key_thickness = 2.75
  hole_size = 5
  hole_y_offset = 2
  key_flat_width = 11
  insertion_hole_ratio = 1.3
  
  mesh = key_cover(svg_file, svg_shape_index, key_width, key_thickness, hole_size, hole_y_offset, key_flat_width, insertion_hole_ratio, decor_file, decor_size, decor_y_offset)

  return mesh
end

function key_cover_garden()
  return key_cover_legallais("garden.svg", 12, -2)
end

function key_cover_stairs()
  return key_cover_legallais("stairs.svg", 14, 0)
end

emit(rotate(90, 0, 90)*key_cover_house())
--emit(rotate(90, 0, 90)*key_cover_garage())
--emit(rotate(90, 0, 90)*key_cover_garden())
--emit(rotate(90, 0, 90)*key_cover_stairs())