var mousex = floor(device_mouse_x(0) / 32);
var mousey = floor(device_mouse_y(0) / 32);

// desactivar script
if (question != -1) {
    exit;
}

var xView = floor(camera_get_view_x(view_camera[0]) / 32);
var yView = floor(camera_get_view_y(view_camera[0]) / 32);
var wView = floor(camera_get_view_width(view_camera[0]) / 32) + 2;
var hView = floor(camera_get_view_height(view_camera[0]) / 32) + 2;

var startX = max(xView, 0);
var startY = max(yView, 0);
var endX = min(startX + wView, width);
var endY = min(startY + hView, height);

// dibujar objetos por capas
for (var i = 0; i < array_length(layers); ++i) {
    // objeto
    for (var xx = startX; xx < endX; ++xx) {
        for (var yy = startY; yy < endY; ++yy) {
            var cell = ds_grid_get(layers[i], xx, yy);
            
            
            // dibujar si no hay un espacio
            if (cell != -1) {
                var color_obj = (mousex == xx and mousey == yy and mouse_depth == 1 and layer_current == i) ? c_gray : c_white;
                var alpha_obj = (i == layer_current) ? 1 : 0.5;
                
                // verificar si esta seleccionado
                if (objectos_seleccionados[# xx, yy] == true) color_obj = c_lime;
                
                var tex = cell[? "sprite"];
                
                var spr = (cell[? "id"] == 0) ? rsc_find_tex("block/" + tex) : rsc_find_tex(tex);
                
                var offsetx = cell[? "offset_x"] ?? 0.0;
                var offsety = cell[? "offset_y"] ?? 0.0;
                
                if (spr != -1) draw_sprite_part_ext(spr, 0, 0, 0, 32, 32, (xx + offsetx) * 32, (yy + offsety) * 32, 1, 1, color_obj, alpha_obj);
                
                // para objetos tipo 0
                if (cell[? "id"] == 0 ) {
                    draw_set_alpha(0.5);
                    draw_set_halign(fa_center);
                    draw_set_valign(fa_middle);
                    draw_set_color(c_white);
                    draw_text(xx * 32 + 16, yy * 32 + 16, $"z:{cell[? "z"]}");
                    
                    draw_set_alpha(1);
                }
            }
        }
    }
}

if (mouse_depth == 1 and (keyboard_check_direct(vk_shift) and mouse_check_button(mb_left))) {
    draw_set_alpha(0.5);
    draw_set_color(c_blue);
    draw_rectangle_outline(seleccion_start[0], seleccion_start[1], device_mouse_x(0), device_mouse_y(0), c_aqua, 2 * scale_factor());
    
    draw_set_alpha(1);
}