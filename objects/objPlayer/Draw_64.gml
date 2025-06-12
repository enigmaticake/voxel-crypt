draw_set_color(c_lime);

var ww = display_get_gui_width();
var hh = display_get_gui_height();

draw_text_gui(16, 16, $"x: {floor((x + 16) / 32)}", fa_left, fa_top);
draw_text_gui(16, 32, $"y: {floor((y + 16) / 32)}", fa_left, fa_top);

var draw_slot = function(x, y, color) {
    var x1 = x - (48 * scale_factor());
    var y1 = y - (48 * scale_factor());
    var x2 = x + (48 * scale_factor());
    var y2 = y + (48 * scale_factor());
    
    var mx = device_mouse_x_to_gui(0);
    var my = device_mouse_y_to_gui(0);
    
    // mouse dentro del boton
    var in = point_in_rectangle(mx, my, x1 + 2 * scale_factor(), y1 + 2 * scale_factor(), x2 - 2 *scale_factor(), y2 - 2 * scale_factor());
    
    // fondo
    draw_set_color(c_black);
    draw_set_alpha(0.5);
    draw_rectangle(x1, y1, x2, y2, false);
    draw_set_alpha(1);
    
    // borde
    draw_set_color(in ? merge_color(color, c_black, 0.5) : color);
    for (var i = 1; i <= 3; ++i) draw_rectangle(x1 + i, y1 + i, x2 - i, y2 - i, true);
    
    return in;
}

// dibujar inventario (4 slots)
for (var i = 0; i < slot.max; ++i) {
    var posx = i * (96 * scale_factor());
    
    // input
    if (keyboard_check_pressed(ord(string(i + 1)))) {
        slot.mainhand = i;
    }
    
    
    // slot
    if (draw_slot(gui_haling("left") + 48 * scale_factor() + posx, gui_valing("bottom") - 48 * scale_factor(), slot.mainhand == i ? c_green : c_white)) {
        // input
        if (mouse_check_button_pressed(mb_left)) {
            slot.mainhand = i;
        }
    }
    
    // item
    var item = slot.items[i];
    if (struct_exists(item, "sprite")) {
        draw_sprite_part_ext(item.sprite, 0, 0, 0, 96, 96, gui_haling("left") + 8*scale_factor() + posx, gui_valing("bottom") - 88*scale_factor(), 5*scale_factor(), 5*scale_factor(), c_white, 1);
    }
}

// dibujar vidas (10 vidas)
for (var i = 0; i < floor(tag.health); ++i) {
    var posx = i * (36 * scale_factor());
    var posy = sin(random_range(current_time - 10, current_time + 10) * 0.2) * floor(6 / tag.health);
    
    draw_sprite_ext(rsc_find_tex("gui/health"), 0, gui_haling("left") + posx + 16*scale_factor(), gui_valing("top") + 16*scale_factor() + posy, scale_factor(), scale_factor(), 0, c_white, 1);
}