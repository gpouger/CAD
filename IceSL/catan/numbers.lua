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

numbers_ext = {{'A', '2', 1},
               {'B', '5', 4},
               {'C', '4', 3},
               {'D', '6', 5},
               {'E', '3', 2},
               {'F', '9', 4},
               {'G', '8', 5},
               {'H', '11', 2},
               {'I', '11', 2},
               {'J', '10', 3},
               {'K', '6', 5},
               {'L', '3', 2},
               {'M', '8', 5},
               {'N', '4', 3},
               {'O', '8', 5},
               {'P', '10', 3},
               {'Q', '11', 2},
               {'R', '12', 1},
               {'S', '10', 3},
               {'T', '5', 4},
               {'U', '4', 3},
               {'V', '9', 4},
               {'W', '5', 4},
               {'X', '9', 4},
               {'Y', '12', 1},
               {'Za', '3', 2},
               {'Zb', '2', 1},
               {'Zc', '6', 5},
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

function set_params_black()
  set_setting_value("num_shells_0", 0)
  set_setting_value("num_shells_1", 2)
  set_setting_value("cover_thickness_mm_0", 0)
  set_setting_value("cover_thickness_mm_1", 0.6)
  set_setting_value("infill_percentage_0", 0)
  set_setting_value("infill_percentage_1", 20)
  set_setting_value("print_perimeter_0", false)
  set_setting_value("print_perimeter_1", true)
  set_setting_value("z_lift", 0)
  set_setting_value("first_layer_print_speed_mm_per_sec", 10)
end

function set_params_white()
  set_setting_value("num_shells_0", 2)
  set_setting_value("num_shells_1", 0)
  set_setting_value("cover_thickness_mm_0", 0.6)
  set_setting_value("cover_thickness_mm_1", 0)
  set_setting_value("infill_percentage_0", 20)
  set_setting_value("infill_percentage_1", 0)
  set_setting_value("print_perimeter_0", true)
  set_setting_value("print_perimeter_1", false)
  set_setting_value("z_lift", 0.5)
  set_setting_value("first_layer_print_speed_mm_per_sec", 10)
end

emit_tokens_black(get_tokens(numbers_ext))
emit_tokens_white(get_tokens(numbers_ext))

set_params_black()
set_params_white()
