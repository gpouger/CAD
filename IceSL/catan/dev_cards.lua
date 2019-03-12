require "utils"

card_shape = load_centered_on_plate('W:\\documents\\Perso\\TevoTarantula\\Models\\catan with borders\\development\\KnightToken.stl')

tokens = {}
for i=1,19 do
  table.insert(tokens, card_shape)
end

emit(group_grid(tokens, 5, 2))
