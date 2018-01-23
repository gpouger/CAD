function triangle_isocele(base, height, z)
    points = {}
    points[1] = v(0,0,0)
    points[2] = v(base,0,0)
    points[3] = v(base/2,height,0)
    return linear_extrude(v(0,0,z), points)
end

function triangle_equilateral(base, z)
    return triangle_isocele(base, base*cos(30), z)
end

function shape_grid(shape, nb_l, nb_c, spacing_x, spacing_y)
    for l=1,nb_l do
        for c=1,nb_c do
            emit(translate(v(c*spacing_x, l*spacing_y, 0)) * shape)
        end
    end
end

function triangles_equi_twelve(base, z, spacing_x, spacing_y)
    shape_grid(triangle_equilateral(base, z), 4, 3, spacing_x, spacing_y)
end

function triangles_iso_twelve(base, height, z, spacing_x, spacing_y)
    shape_grid(triangle_isocele(base, height, z), 4, 3, spacing_x, spacing_y)
end

function triangles_bleu_clair(z)
    triangles_equi_twelve(15, z, 20, 20)
end

function triangles_bleu_fonce(z)
    triangles_equi_twelve(22, z, 25, 25)
end

function triangles_noir(z)
    triangles_equi_twelve(35, z, 40, 40)
end

function triangles_violet(z)
    triangles_iso_twelve(20, 30, 5, 25, 35)
end

function ronds_rouge(z)
    shape_grid(ccylinder(14,z), 4, 3, 35, 35)
end

function ronds_orange(z)
    shape_grid(ccylinder(8,z), 3, 3, 20, 20)
end

function rectangles_rose(z)
    shape_grid(ccube(22,9,z), 2, 3, 25, 12)
end

function croissants_vert(z)
    croissant = difference(ccylinder(10,z), translate(v(0,-7,0))*ccylinder(12,z))
    shape_grid(croissant, 3, 3, 25, 15)
end

function interjections_jaune(z)
    base = 10
    height = 20
    rayon = 5
    inter = union(triangle_isocele(base, height, z),
        translate(v(base/2,height-rayon,0))*cylinder(rayon,z))
    
    shape_grid(inter, 2, 3, 12, 22)
end

function pyramid(base, height)
    p = polyhedron(
  { v(0,0,0), v(base,0,0), v(0,base,0), v(base,base,0), v(base/2,base/2,height) },
  { v(0,3,1), v(0,2,3), v(0,1,4), v(1,3,4), v(3,2,4), v(2,0,4) } )
    return p
end

function triangle_bleu_fonce_3d()
    s = pyramid(25, 25)
    emit(s)
end

function triangle_noir_3d()
    s = pyramid(35, 35)
    emit(s)
end

function triangle_bleu_clair_3d()
    s = pyramid(16, 16)
    emit(s)
end

function triangle_violet_3d()
    s = pyramid(25, 50)
    emit(s)
end

function rectangle_rose_3d()
    s = ccube(25, 10, 5)
    emit(s)
end

function croissant_vert_3d()
    z=10
    ring = difference(ccylinder(20,z), ccylinder(16,z))
    croissant = difference(ring, translate(v(0,18,0))*ccube(50))
    emit(croissant)
end

function rond_rouge_3d()
    s = sphere(18)
    emit(s)
end

function rond_orange_3d()
    s = sphere(9)
    emit(s)
end

function interjection_jaune_3d()
    base = 25
    height = 30
    r = 9
    inter = union(pyramid(base,height), translate(v(base/2,base/2,height-r/3))*sphere(r))
    emit(inter)
end

--triangles_bleu_fonce(5)
--ronds_rouge(5)
--triangles_noir(5)
--triangles_bleu_clair(5)
--croissants_vert(5)
--ronds_orange(5)
--triangles_violet(5)
--rectangles_rose(5)
--interjections_jaune(5)

--croissant_vert_3d()
--triangle_bleu_fonce_3d()
--triangle_noir_3d()
--triangle_violet_3d()
--rectangle_rose_3d()
--interjection_jaune_3d()
--rond_rouge_3d()
--rond_orange_3d()
triangle_bleu_clair_3d()

