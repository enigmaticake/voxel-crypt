draw_set_color(c_lime);

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_text(16, 16, $"x: {floor((x + 16) / 32)}");
draw_text(16, 32, $"y: {floor((y + 16) / 32)}");