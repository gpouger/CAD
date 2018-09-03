-- Generic reprap customized for Tevo Tarantula (still pretty generic, would work for any Marlin printer with Linear Advance feature enabled)
version=2

function comment(text)
  output('; ' .. text)
end

layer_count = 0

extruder_e = 0 -- current total extrusion length
extruder_e_layer_start = 0 -- total extrusion length at start of current layer
current_k_factor = 0

function set_k_factor(val)
	if current_k_factor ~= val then
		current_k_factor = output("M900 K" .. val .. " ; set linear advance K parameter")
		current_k_factor = val
	end
end

function header()
  output("G21 ; set units to millimeters")
  output("M140 S" .. bed_temp_degree_c .. " ; set bed temperature")
  output("M104 S" .. extruder_temp_degree_c_0 .. " ; set extruder temperature")
  output("G28 ; home all axes")
  output("G0 F6000 Z1.0 ; lift nozzle a little")
  output("G0 F6000 X0 Y0 Z0 ; move to zero position")
  output("G92 ; define all axis to 0")
  output("M190 S" .. bed_temp_degree_c .. " ; wait for bed temperature to be reached")
  output("M109 S" .. extruder_temp_degree_c_0 .. " ; wait for temperature to be reached")
  output("M209 S0 ; disable autoretract")
  if use_fw_retract then
    output("M207 F" .. priming_mm_per_sec*60 .. " S" .. f(filament_priming_mm_0) .. " Z" .. ff(z_lift) .. " ; set FW retract parameters")
    output("M208 F" .. priming_mm_per_sec*60 .. " S" .. ff(unretract_extra_mm) .. " ; set FW retract recovery parameters")
  end
  output("G90 ; use absolute coordinates")
  output("M82 ; use absolute distances for extrusion")
  output("G0 Z15.0 F6000 ; move the platform down 15mm")
  output("G1 F200 E3 ; prime the extruder")
  output("G92 E0 ; reset extruder to 0")
  output("M900 K" .. lin_advance_k .. " ; set linear advance K parameter")
  current_k_factor = lin_advance_k
end

function footer()
  output("M107 ; fan off")
  output("M104 S0 ; turn off extruder temperature")
  output("M140 S0 ; turn off bed temperature")
  output("G92 E0")
  output("G1 E-3 F300 ; Retract the filament")
  output("G1 X0 Y" .. bed_size_y_mm .. " F6000 ; home X and move platter to the front")
  output("M84 ; disable motors")
end

function layer_start(zheight)
  comment('<layer ' .. layer_count .. '>')
  comment('<extruded ' .. extruder_e .. 'mm >')
  
  extruder_e_layer_start = extruder_e
  output('G92 E0')
  
  -- change Z height before extruding only for layers other than the first (because of the priming in the corner, for the first layer we want to start moving X and Y before Z reaches the initial layer height)
  if layer_count ~= 0 then
	output('G1 Z' .. f(zheight))
  end
end

function layer_stop()
  comment('</layer ' .. layer_count .. '>')
  layer_count = layer_count + 1
end

function retract(extruder,e)
  if use_fw_retract then
    output('G10')
    return e
  else
    length = filament_priming_mm[extruder]
    speed = priming_mm_per_sec * 60;
    output('G1 F' .. speed .. ' E' .. ff(e - length - extruder_e_layer_start))
    extruder_e = e - length
    return extruder_e
  end
end

function prime(extruder,e)
  if use_fw_retract then
    output('G11')
    return e
  else
    length = filament_priming_mm[extruder]
    speed = priming_mm_per_sec * 60;
    output('G1 F' .. speed .. ' E' .. ff(e + length - extruder_e_layer_start))
    extruder_e = e + length
    return extruder_e
  end
end

current_extruder = 0
current_frate = 0
new_frate = 0

function select_extruder(extruder)
end

function swap_extruder(from,to,x,y,z)
end

function move_xyz(x,y,z)
  if new_frate ~= current_frate then
	fr = ' F' .. f(new_frate)
	current_frate = new_frate
  else
    fr = ''
  end
  
  if z == current_z then
    output('G0' .. fr .. ' X' .. f(x) .. ' Y' .. f(y))
  else
    output('G0' .. fr .. ' X' .. f(x) .. ' Y' .. f(y) .. ' Z' .. ff(z))
    current_z = z
  end
end

function move_xyze(x,y,z,e)
  extruder_e = e
  
  if path_is_perimeter or path_is_shell then
    -- set configured K factor for linear advance
	set_k_factor(lin_advance_k)
  else
    -- disable linear advance
    set_k_factor(0)
  end
  
  if new_frate ~= current_frate then
	fr = ' F' .. f(new_frate)
	current_frate = new_frate
  else
    fr = ''
  end
  
  if z == current_z then
    output('G1' .. fr .. ' X' .. f(x) .. ' Y' .. f(y) .. ' E' .. ff(e - extruder_e_layer_start))
  else
    output('G1 X' .. f(x) .. ' Y' .. f(y) .. ' Z' .. ff(z) .. ' E' .. ff(e - extruder_e_layer_start))
    current_z = z
  end
end

function move_e(e)
  extruder_e = e
  output('G1 E' .. ff(e - extruder_e_layer_start))
end

function set_feedrate(feedrate)
  new_frate = feedrate
end

function extruder_start()
end

function extruder_stop()
end

function progress(percent)
  output('M73 P' .. percent)
end

function set_extruder_temperature(extruder,temperature)
  output('M104 S' .. temperature .. ' T' .. extruder)
end

current_fan_speed = -1
function set_fan_speed(speed)
  if speed ~= current_fan_speed then
    output('M106 S'.. math.floor(255 * speed/100))
    current_fan_speed = speed
  end
end