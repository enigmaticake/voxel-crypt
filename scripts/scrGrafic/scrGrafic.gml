function draw_rectangle_outline(x1, y1, x2, y2, colorOutline, sizeOutline = 4) {
	draw_rectangle(x1, y1, x2, y2, false);
	
	draw_set_color(colorOutline);
	for (var i = 0; i < sizeOutline; ++i) draw_rectangle(x1 + i, y1 + i, x2 - i, y2 - i, true);
}