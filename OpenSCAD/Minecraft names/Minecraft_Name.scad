module Minecraft_Name(text, font_size=30, extrude_height=10, extra_base=3, adjust_base_width=0, texture_width=1.6, texture_depth=0.4)
{
    nb_char = len(text);
    color("LimeGreen")
    
    union() {
        difference()
        {
            linear_extrude(height=extrude_height)
                text(text=text, size=font_size, font="Minecrafter", halign="center");
            {
                top_width = nb_char*font_size+adjust_base_width;
                top_height = font_size*1.5;
                union()
                {
                  for(x=[-(top_width/2):texture_width:(top_width/2)])
                    for(y=[0:texture_width:top_height])
                    {
                        heights = rands(0,texture_depth,2);
                        texture_extrude_height = heights[0];
                        if(texture_extrude_height == 0.01)
                        { texture_extrude_height = heights[1]; }
                        translate([x, y, (extrude_height+0.01-texture_extrude_height)])
                          cube(size=[texture_width,texture_width,texture_extrude_height]);
                    }
                }
            }
        }
        translate([0, -extra_base/2, (extrude_height+extra_base)/2])
          cube(size=[nb_char*font_size+adjust_base_width, extra_base, extrude_height+extra_base], center=true);
    }
}