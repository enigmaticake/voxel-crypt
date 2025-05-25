var ww = display_get_gui_width();
var hh = display_get_gui_height();

draw_set_color(c_gray);
draw_rectangle(0, 0, ww, hh, false);

draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_text(ww - (ww * 0.95), hh - (hh * 0.95), floor((get_timer() - time) / 1_000_000));


draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(ww / 2, hh / 2, $"Loading: {label}...");