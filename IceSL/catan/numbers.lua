require "utils"

dot_rad = 0.75
dots_spacing = 2.5
dots_y_offs = 9.5
letter_y_offs = 9
indent = 0.8
total_height = 2.4
total_rad = 13

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
  shape = cylinder(total_rad, total_height)
  
  dots = {}
  for i=1,nb_dots do
    table.insert(dots, translate((i-1)*dots_spacing, -dots_y_offs, total_height-indent)*cylinder(dot_rad, 1))
  end
  dots = union(dots)
  dots = translate(-bbox(dots):extent().x/2+dot_rad, 0, 0)*dots
  
  number = translate(0, -1, total_height-indent)*xy_scale_to_y(center_text(number, 3, 1, false, 1, "arlrdbd.ttf"), 13)

  letter = translate(0, letter_y_offs, total_height-indent)*center_text(letter, 4, 1, false, 10, "arlrdbd.ttf")
  
  shape = difference(shape, dots)
  shape = difference(shape, number)
  shape = difference(shape, letter)

  return shape
end

function get_tokens(tok_list)
  tokens = {}
  for i, num in ipairs(tok_list) do
    table.insert(tokens, number_token(num[1], num[2], num[3]))
  end
  return tokens
end

--emit(group_grid(get_tokens(numbers_base), 4, 2))
emit(group_grid(get_tokens(numbers_ext), 4, 2))