require "utils"

--card_shape = load('W:\\documents\\Perso\\TevoTarantula\\Models\\catan with borders\\development\\KnightToken.stl')

--card_shape = load('W:\\documents\\Perso\\TevoTarantula\\Models\\catan with borders\\development\\MonopolyToken.stl')

--card_shape = load('W:\\documents\\Perso\\TevoTarantula\\Models\\catan with borders\\development\\RoadBuildingToken.stl')

--card_shape = load('W:\\documents\\Perso\\TevoTarantula\\Models\\catan with borders\\development\\VictoryPointToken.stl')

card_shape = load('W:\\documents\\Perso\\TevoTarantula\\Models\\catan with borders\\development\\YearOfPlentyToken.stl')

tokens = {}
for i=1,2 do
  table.insert(tokens, scale(0.75, 0.75, 0.75)*card_shape)
end

emit(group_grid(tokens, 5, 2))