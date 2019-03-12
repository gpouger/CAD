require "utils"

city_shape = load('W:\\documents\\Perso\\TevoTarantula\\Models\\catan with borders\\city.stl')
settlement_shape = load('W:\\documents\\Perso\\TevoTarantula\\Models\\catan with borders\\settlment.stl')

tokens = {}
for i=1,4 do
  table.insert(tokens, city_shape)
end

for i=1,5 do
  table.insert(tokens, settlement_shape)
end

emit(group_grid(tokens, 3, 2))