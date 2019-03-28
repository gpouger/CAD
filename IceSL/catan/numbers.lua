require "utils"

dot_rad = 0.75
dots_spacing = 2.5
dots_y_offs = 9.5
letter_y_offs = 9
indent = 0.4
total_height = 2.4
total_rad = 13

grid_columns = 4
grid_spacing = 2

numbers_base = {{'A', '5', 4},
               {'B', '2', 1},
               {'C', '6', 5},
               {'D', '3', 2},
               {'E', '8', 5},
               {'F', '10', 3},
               {'G', '9', 4},
               {'H', '12', 1},
               {'I', '11', 2},
               {'J', '4', 3},
               {'K', '8', 5},
               {'L', '10', 3},
               {'M', '9', 4},
               {'N', '4', 3},
               {'O', '5', 4},
               {'P', '6', 5},
               {'Q', '3', 2},
               {'R', '11', 2},
        }

numbers_ext = {
               {'A', '2', 1},
               {'B', '5', 4},
--               {'C', '4', 3},
--               {'D', '6', 5},
--               {'E', '3', 2},
--               {'F', '9', 4},
--               {'G', '8', 5},
--               {'H', '11', 2},
--               {'I', '11', 2},
--               {'J', '10', 3},
--               {'K', '6', 5},
--               {'L', '3', 2},
--               {'M', '8', 5},
--               {'N', '4', 3},
--               {'O', '8', 5},
--               {'P', '10', 3},
--               {'Q', '11', 2},
--               {'R', '12', 1},
--               {'S', '10', 3},
--               {'T', '5', 4},
--               {'U', '4', 3},
--               {'V', '9', 4},
--               {'W', '5', 4},
--               {'X', '9', 4},
--               {'Y', '12', 1},
--               {'Za', '3', 2},
--               {'Zb', '2', 1},
--               {'Zc', '6', 5},
        }

function number_token(letter, number, nb_dots)
  base_shape = cylinder(total_rad, total_height)
  
  dots = {}
  for i=1,nb_dots do
    table.insert(dots, translate((i-1)*dots_spacing, -dots_y_offs, total_height-indent)*cylinder(dot_rad, indent))
  end
  dots = union(dots)
  dots = translate(-bbox(dots):extent().x/2+dot_rad, 0, 0)*dots
  
  number = translate(0, -1, total_height-indent)*xy_scale_to_y(center_text(number, 3, indent, false, 1, "arlrdbd.ttf"), 13)

  letter = translate(0, letter_y_offs, total_height-indent)*center_text(letter, 4, indent, false, 10, "arlrdbd.ttf")
  
  txt = union({dots, number, letter})

  token = {}
  token.white = difference(base_shape, txt)
  token.black = txt

  return token
end

function get_tokens(tok_list)
  tokens = {}
  for i, num in ipairs(tok_list) do
    tok = number_token(num[1], num[2], num[3])
    tok.offs = group_grid_offset(i, grid_columns, grid_spacing, total_rad*2, total_rad*2)
    table.insert(tokens, tok)
  end
  return tokens
end

function emit_tokens_white(tok_list)
  for i, tok in ipairs(tok_list) do
    offs_to_center = xy_offs_to_center(tok.white)
    emit(translate(tok.offs.x, tok.offs.y, 0)*translate(offs_to_center)*rotate(180, Y)*tok.white, 0)
  end
end

function emit_tokens_black(tok_list)
  for i, tok in ipairs(tok_list) do
    offs_to_center = xy_offs_to_center(tok.white)
    emit(translate(tok.offs.x, tok.offs.y, 0)*translate(offs_to_center)*rotate(180, Y)*tok.black, 1)
  end
end

function enable_brush(color)
  if color == "black" then
    enable_nb = 1
    disable_nb = 0
    z_lift = 0.2
    brim = true
    travel_without_retract = 0
    fill_tiny_gaps = true
  else
    enable_nb = 0
    disable_nb = 1
    z_lift = 0.5
    brim = false
    travel_without_retract = 0
    fill_tiny_gaps = true
  end
  layer_thickness = 0.2
    

  set_setting_value("nozzle_diameter_mm", 0.4)
  set_setting_value("first_layer_print_speed_mm_per_sec", 10)
  set_setting_value("z_layer_height_mm", layer_thickness)
  set_setting_value("z_lift", z_lift)
  set_setting_value("add_brim", brim)
  set_setting_value("travel_max_length_without_retract", travel_without_retract)

  set_setting_value("num_shells_" .. disable_nb, 0)
  set_setting_value("cover_thickness_mm_" .. disable_nb, 0)
  set_setting_value("infill_percentage_" .. disable_nb, 0)
  set_setting_value("print_perimeter_" .. disable_nb, false)
  set_setting_value("fill_tiny_gaps_" .. disable_nb, false)

  set_setting_value("num_shells_" .. enable_nb, 2)
  set_setting_value("cover_thickness_mm_" .. enable_nb, layer_thickness*3)
  set_setting_value("infill_percentage_" .. enable_nb, 20)
  set_setting_value("print_perimeter_" .. enable_nb, true)
  set_setting_value("fill_tiny_gaps_" .. enable_nb, fill_tiny_gaps)
end

emit_tokens_black(get_tokens(numbers_ext))
emit_tokens_white(get_tokens(numbers_ext))

--enable_brush("black")
enable_brush("white")
