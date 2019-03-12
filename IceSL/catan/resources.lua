require "utils"

is_ext = true
if is_ext then
	res_nb = 5
	grid_size = 2
else
	res_nb = 19
	grid_size = 5
end

resource_shape = load('W:\\documents\\Perso\\TevoTarantula\\Models\\catan with borders\\resources\\brick.stl')
--resource_shape = load('W:\\documents\\Perso\\TevoTarantula\\Models\\catan with borders\\resources\\logs.stl')
--resource_shape = load('W:\\documents\\Perso\\TevoTarantula\\Models\\catan with borders\\resources\\sheep.stl')
--resource_shape = load('W:\\documents\\Perso\\TevoTarantula\\Models\\catan with borders\\resources\\wheat.stl')
--resource_shape = load('W:\\documents\\Perso\\TevoTarantula\\Models\\catan with borders\\resources\\iron.stl')

tokens = {}
for i=1,res_nb do
  table.insert(tokens, resource_shape)
end

emit(group_grid(tokens, grid_size, 2))