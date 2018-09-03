require "utils"

function medaille_base(diam, height, border, bottom_height)
    -- produce the base shape of the medal, x/y centered and bottom at z=0
    base_shape = difference(ccylinder(diam/2, height), translate(0, 0, bottom_height)*ccylinder(diam/2 - border, height))
    
    holder = difference(ccube(10, 8, height), ccube(7, 5, height))
    holder = translate(0,diam/2,0)*holder
    holder = difference(holder, ccylinder(diam/2, height))

    return translate(0,0,height/2)*union(base_shape, holder)
end

params_medaille_base = {diam=40, height=3, border_width=2, bottom_height=1}
base = medaille_base(params_medaille_base.diam, params_medaille_base.height, params_medaille_base.border_width, params_medaille_base.bottom_height)

function medaille_conjugaison()
    letter = center_text("C", 25, 3)
    return union(base, letter)
end

function medaille_orthographe()
    letter = center_text("O", 25, 3)
    return union(base, letter)
end

function medaille_grammaire()
    letter = center_text("G", 25, 3)
    return union(base, letter)
end

function medaille_multiplication()
    letter = center_text("+", 25, 3)
    letter = rotate(0, 0, 45)*letter
    return union(base, letter)
end

function medaille_geographie()
    svg_shapes = svg_ex('earth.svg', 90)
    svg_shape = linear_extrude(v(0, 0, 3), svg_shapes[1]:outline())
    for i,contour in pairs(svg_shapes) do
        if i > 1 and i ~= 6 and (contour:hasFill() or contour:hasStroke()) then
            svg_shape = union(svg_shape, linear_extrude(v(0,0,3),contour:outline()))
        end
    end

    svg_shape = center_and_scale_shape(rotate(180, 0, 0)*svg_shape, 25, 3)
    return union(base, svg_shape)
end

function medaille_mesures()
    svg_shape = center_and_scale_shape(rotate(0, 0, 180)*extrude_svg('ruler.svg', 3), 25, 3)
    return union(base, svg_shape)
end

function medaille_geometrie()
    svg_shape = center_and_scale_shape(rotate(0, 0, 180)*extrude_svg('compas.svg', 3), 25, 3)
    return union(base, svg_shape)
end

function medaille_lit()
    svg_shape = center_and_scale_shape(rotate(0, 0, 180)*extrude_svg('bed.svg', 3), 25, 3)
    return union(base, svg_shape)
end

params_medaille_griffon = {diam=50, height=4, border_width=2.5, bottom_height=2}
base_griffon = medaille_base(params_medaille_griffon.diam, params_medaille_griffon.height, params_medaille_griffon.border_width, params_medaille_griffon.bottom_height)

function medaille_griffon_base()
  diam = 50
  height = 4
  border_width = 2.5
  border_height = 2
  
  svg_shape = center_and_scale_shape(rotate(0, 180, 180)*extrude_svg('griffon.svg', height), 30, height)
  
  return union(base_griffon, svg_shape)
end



function medaille_griffon_francais_bois()
  med = union(medaille_griffon_base(), translate(0, -15, 0)*center_text("1", 10, 4, false))

  txt1 = translate(0, 6, 0)*center_text("FRANCAIS", 40, 0.5, true, 1, "arlrdbd.ttf")
  txt2 = translate(0, -2, 0)*center_text("GRIFFON", 30, 0.5, true, 1, "arlrdbd.ttf")
  txt3 = translate(0, -10, 0)*center_text("DE BOIS", 30, 0.5, true, 1, "arlrdbd.ttf")

  return difference({med, txt1, txt2, txt3})
end

function medaille_pot()
  svg_shape = center_and_scale_shape(rotate(0, 180, 180)*extrude_svg('potty.svg', 4), 35, 4)

  return union(base_griffon, svg_shape)
end

function adjust_print_speed_griffon()
  set_setting_value("print_speed_mm_per_sec",
    {[params_medaille_griffon.bottom_height-0.05]=40,
     [params_medaille_griffon.bottom_height-0.02]=20,
     [params_medaille_griffon.bottom_height+0.02]=20,
     [params_medaille_griffon.bottom_height+0.05]=40,
     [params_medaille_griffon.height-0.05]=40,
     [params_medaille_griffon.height-0.02]=20,})
end

--all_medals = {medaille_conjugaison(), medaille_orthographe(), medaille_grammaire(), medaille_multiplication(), medaille_geographie(), medaille_mesures(), medaille_geometrie()}

--emit(group_grid(all_medals, 3, 5))

emit(medaille_pot())
adjust_print_speed_griffon()