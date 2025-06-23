model_draw_body(model, skin, c_white, 1);

// dibujar vidas
var healthReal = floor((tag.health / health_max) * 100);

draw_set_color(c_red);
draw_text(x, y - 32, healthReal);