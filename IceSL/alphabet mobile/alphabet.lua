require "utils"

f = font("BelleAllureGS-Gros.ttf")
scale_vect = v(15, 15, 3)

voyelles = {'a', 'e', 'i', 'o', 'u', 'y'}
consonnes = {'b', 'c', 'd', 'f', 'g', 'h', 'j', 'k', 'l', 'm', 'n', 'p', 'q', 'r', 's', 't', 'v', 'w', 'x', 'z'}

consonnes_0 = {'s', 'c', 'n'}
consonnes_1 = {'r', 'v', 'x'}
consonnes_2 = {'b', 'd', 'g', 'h', 'j', 'k'}
consonnes_3 = {'l', 'p', 'q', 't', 'z'}
consonnes_4 = {'f', 'm', 'w'}

function letters(letters_list)
  shapes = {}
  for i, l in ipairs(letters_list) do
    shapes[i] = scale(scale_vect)*f:str(l, 0)
  end
  return shapes
end

emit(group_grid(letters(voyelles), 3, 2))
--emit(group_grid(letters(consonnes_0), 3, 2))
--emit(group_grid(letters(consonnes_1), 3, 2))
--emit(group_grid(letters(consonnes_2), 3, 2))
--emit(group_grid(letters(consonnes_3), 3, 2))
--emit(group_grid(letters(consonnes_4), 3, 2))