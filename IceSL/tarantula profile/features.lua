version = 2

bed_size_x_mm = 200
bed_size_y_mm = 275
bed_size_z_mm = 200
nozzle_diameter_mm = 0.4

extruder_count = 1

z_offset   = 0.0

add_checkbox_setting("use_fw_retract", "Use Marlin FW retraction")
use_fw_retract = true

add_setting("priming_mm_per_sec", "Retract and unretract speed (mm/sec)", 20, 200)
priming_mm_per_sec = 60

add_setting("z_lift", "Z-lift height on retraction (mm)", 0, 5)
z_lift = 0

add_setting("unretract_extra_mm", "Extra filament length for unretract (mm)", -1, 1)
unretract_extra_mm = 0

filament_priming_mm_0 = 4.0

z_layer_height_mm_min = 0.05
z_layer_height_mm_max = nozzle_diameter_mm * 0.75

print_speed_mm_per_sec_min = 5
print_speed_mm_per_sec_max = 60

bed_temp_degree_c_min = 0
bed_temp_degree_c_max = 120

perimeter_print_speed_mm_per_sec_min = 5
perimeter_print_speed_mm_per_sec_max = 60

first_layer_print_speed_mm_per_sec = 20
first_layer_print_speed_mm_per_sec_min = 1
first_layer_print_speed_mm_per_sec_max = 60

enable_fit_single_path = true
path_width_speed_adjustment_exponent = 2.0

fan_speed_percent = 75
fan_speed_percent_on_bridges = 100

add_setting("lin_advance_k", "K factor for linear advance", 0, 500)
lin_advance_k = 200 -- set to 0 to disable, 200 is a reasonable default for bowden
