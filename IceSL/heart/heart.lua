default_border_width = ui_scalar("Border", 5, 0, 50)
default_bottom_height = ui_scalar("Botton", 2, 0, 50)
default_lobe_diameter = ui_scalar("Diameter", 50, 5, 300)
default_height = ui_scalar("Height", 5, 1, 20)
hole_diameter = ui_scalar("Hole diam", 5, 0, 10)

function heart(lobe_diameter, height)
    lobe_diameter = lobe_diameter or default_lobe_diameter
    height = heigt or default_height

    center = cube(lobe_diameter, lobe_diameter, height)
    lobe = cylinder(lobe_diameter/2, height)
    lobe1 = translate(lobe_diameter/2, 0, 0)*lobe
    lobe2 = translate(0, lobe_diameter/2, 0)*lobe
    return union{center, lobe1, lobe2}
end

function hollowed_heart(lobe_diameter, height, bottom_height, border_width)
    lobe_diameter = lobe_diameter or default_lobe_diameter
    height = height or default_height
    bottom_height = bottom_height or default_bottom_height
    border_width = border_width or default_border_width

    hole_width = lobe_diameter - 2*border_width
    
    -- start with the heart
    h = heart(lobe_diameter, height)

    -- add hole for tying it
    coord_hole = lobe_diameter/2 + hole_diameter/2.8
    height_hole = height/2
    tying_hole = translate(coord_hole,coord_hole,0)*
                    difference{cylinder(hole_diameter, height_hole), cylinder(hole_diameter/2, height_hole)}
    h = union{h, tying_hole}

    -- build the shape to remove from the solid heart
    lobe_hole = cylinder(hole_width/2, height)
    center_hole = cube(hole_width, hole_width, height)
    hole = union{
        center_hole,
        translate(lobe_diameter/2, 0, 0)*lobe_hole,
        translate(0, lobe_diameter/2, 0)*lobe_hole,
        translate(border_width, 0, 0)*center_hole,
        translate(0, border_width, 0)*center_hole,
    }
    h = difference(h, translate(0,0,bottom_height)*hole)

    return rotate(0,0,45)*h
end

function center_xy(shape)
    -- centers a shape on the absolute axis, only on X and Y (Z doesn't change)
    bb = bbox(shape)
    min_corner = bb:min_corner()
    max_corner = bb:max_corner()
    offs = -min_corner*v(1,1,0) - (max_corner-min_corner)*v(0.5,0.5,0)
    return translate(offs) * shape
end

function letter_3d(letter, scale_xy)
    svg_shape = svg_ex(letter .. '.svg',90)[1]
    return rotate(180,0,0)*scale(scale_xy,scale_xy,1)*linear_extrude(v(0,0,-default_height), svg_shape:outline())
end

heart_with_text = union{
    hollowed_heart(),
    translate(-default_lobe_diameter/3,default_lobe_diameter/3,0)*center_xy(letter_3d('K',default_lobe_diameter/20)),
    translate(default_lobe_diameter/3,default_lobe_diameter/3,0)*center_xy(letter_3d('G',default_lobe_diameter/20)),
    translate(0,-default_lobe_diameter/8,0)*center_xy(letter_3d('plus',default_lobe_diameter/25))
}
emit(heart_with_text)
