border = 2.0
slot_length = 3.0
slot_depth = 20.0
box_depth = 25.0
box_width = 47.0 -- x axis
box_length = 80.0 -- y axis

offset_slot = 4

nb_boxes = 5

total_width = nb_boxes * box_width + border * (nb_boxes + 1)
total_length = box_length + slot_length + border * 3 + offset_slot
total_height = box_depth + border

slot_width = total_width - border * 2

outer_box = cube(total_width, total_length, total_height)

slot = cube(slot_width, slot_length, slot_depth*4)
slot = rotate(-10, 0, 0)*slot
slot = translate(0, (total_length-slot_length)/2-border-offset_slot, total_height-slot_depth)*slot

box_shape = cube(box_width, box_length, box_depth)
round_cutout = difference({cube(box_width,box_depth,box_depth), translate(-box_width/2,box_depth/2,box_depth)*rotate(0,90,0)*cylinder(box_depth, box_width)})
box_shape = difference(box_shape, translate(0,-box_length/2+box_depth/2,0)*round_cutout)

box1 = translate(-(total_width-box_width)/2+border, -(total_length-box_length)/2+border, border)*box_shape

box2 = translate(border+box_width, 0, 0)*box1
box3 = translate(border+box_width, 0, 0)*box2
box4 = translate(border+box_width, 0, 0)*box3
box5 = translate(border+box_width, 0, 0)*box4

box = difference({outer_box, slot, box1, box2, box3, box4, box5})

emit(rotate(0, 0, 90)*box)
--emit(box_shape)