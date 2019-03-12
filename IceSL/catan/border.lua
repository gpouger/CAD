require "utils"
shape = load('W:\\documents\\Perso\\TevoTarantula\\Models\\catan with borders\\terrain\\border_mid.stl')
shape = load('W:\\documents\\Perso\\TevoTarantula\\Models\\catan with borders\\terrain\\border_side.stl')
shape = rotate(0, 0, 0)*shape
emit(shape)

set_setting_value("add_brim", false)
set_setting_value("print_speed_mm_per_sec", 40.0)
set_setting_value("perimeter_print_speed_mm_per_sec", 15.0)
set_setting_value("enable_fit_single_path", false)
set_setting_value("infill_type_0", "Honeycomb")
set_setting_value("fan_speed_percent", 20.0)
set_setting_value("fan_speed_percent_on_bridges", 50.0)