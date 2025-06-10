draw_set_color(c_lime);

var ww = display_get_gui_width();
var hh = display_get_gui_height();

draw_text_gui(16, 16, $"x: {floor((x + 16) / 32)}", fa_left, fa_top);
draw_text_gui(16, 32, $"y: {floor((y + 16) / 32)}", fa_left, fa_top);

var draw_slot = function(x, y) {
    var x1 = x - (48 * scale_factor());
    var y1 = y - (48 * scale_factor());
    var x2 = x + (48 * scale_factor());
    var y2 = y + (48 * scale_factor());
    
    var mx = device_mouse_x_to_gui(0);
    var my = device_mouse_y_to_gui(0);
    
    // mouse dentro del boton
    var in = point_in_rectangle(mx, my, x1 + 2 * scale_factor(), y1 + 2 * scale_factor(), x2 - 2 *scale_factor(), y2 - 2 * scale_factor());
    
    // fondo
    draw_set_color(in ? c_dkgray : c_gray);
    draw_rectangle(x1, y1, x2, y2, false);
    
    // borde
    draw_set_color(c_white);
    for (var i = 1; i <= 3; ++i) draw_rectangle(x1 + i, y1 + i, x2 - i, y2 - i, true);
    
    return in;
}

for (var i = 0; i < 4; ++i) {
    var posx = i * (96 * scale_factor());
    
    if (draw_slot(gui_haling("left") + 48 * scale_factor() + posx, gui_valing("bottom") - 48 * scale_factor())) {
        if (mouse_check_button_pressed(mb_left)) {
            tag.health = 0;
        }
    }
}