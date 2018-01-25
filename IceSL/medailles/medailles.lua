require "utils"

function medaille_base(diam, height, border, bottom_height)
    -- produce the base shape of the medal, x/y centered and bottom at z=0
    base_shape = difference(ccylinder(diam/2, height), translate(0, 0, bottom_height)*ccylinder(diam/2 - border, height))
    
    holder = difference(ccube(10, 8, height), ccube(7, 5, height))
    holder = translate(0,diam/2,0)*holder
    holder = difference(holder, ccylinder(diam/2, height))

    return translate(0,0,height/2)*union(base_shape, holder)
end

function center_letter(letter, diam, height)
    font_path = Path .. "ARIALBD.TTF"
    f = font(font_path)
    txt = f:str(letter, 10)

    return center_and_scale_shape(txt, diam, height)
end

base = medaille_base(40, 3, 2, 1)

function medaille_conjugaison()
    letter = center_letter("C", 25, 3)
    return union(base, letter)
end

function medaille_orthographe()
    letter = center_letter("O", 25, 3)
    return union(base, letter)
end

function medaille_grammaire()
    letter = center_letter("G", 25, 3)
    return union(base, letter)
end

function medaille_multiplication()
    letter = center_letter("+", 25, 3)
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
    svg_shapes = svg_ex('ruler.svg', 90)
    svg_shape = linear_extrude(v(0, 0, 3), svg_shapes[1]:outline())

    svg_shape = center_and_scale_shape(rotate(0, 0, 180)*svg_shape, 25, 3)
    return union(base, svg_shape)
end

function medaille_geometrie()
    svg_shapes = svg_ex('compas.svg', 90)
    svg_shape = linear_extrude(v(0, 0, 3), svg_shapes[2]:outline())

    svg_shape = center_and_scale_shape(rotate(0, 0, 180)*svg_shape, 25, 3)
    return union(base, svg_shape)
end

function emit_grid(shapes, nb_col, spacing)
    max_size_x=0
    max_size_y=0
    for i, shape in ipairs(shapes) do
        s_bbox = bbox(shape)
        max_size_x = math.max(s_bbox:extent().x, max_size_x)
        max_size_y = math.max(s_bbox:extent().y, max_size_y)
    end

    x_step = max_size_x + spacing
    y_step = max_size_y + spacing

    for i, shape in ipairs(shapes) do
        x = (i-1) % nb_col
        y = math.floor((i-1) / nb_col)
        emit(translate(x*x_step, y*y_step, 0) * center_shape(shape))
    end
end

--all_medals = {medaille_conjugaison(), medaille_orthographe(), medaille_grammaire(), medaille_multiplication(), medaille_geographie(), medaille_mesures(), medaille_geometrie()}

--emit_grid(all_medals, 3, 5)

emit(medaille_conjugaison())