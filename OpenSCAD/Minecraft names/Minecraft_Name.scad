module Minecraft_Name(text, font_size=30, extrude_height=10, extra_base=3, adjust_base_width=0, texture_width=1.6, texture_depth=0.4)
{
    nb_char = len(text);
    color("LimeGreen")
    
    union() {
        linear_extrude(height=extrude_height)
          text(text=text, size=font_size, font="Minecrafter", halign="center");
        translate([0, -extra_base/2, (extrude_height+extra_base)/2])
          cube(size=[nb_char*font_size+adjust_base_width, extra_base, extrude_height+extra_base], center=true);
    }
}