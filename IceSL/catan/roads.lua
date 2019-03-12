require "utils"

road_shape = load('W:\\documents\\Perso\\TevoTarantula\\Models\\catan with borders\\road.stl')

tokens = {}
for i=1,15 do
  table.insert(tokens, road_shape)
end

emit(group_grid(tokens, 2, 2))