// particulas del jugador
trail_delay = min(speed_current * 0.03, trail_delay + 1);

if ((x != xprevious || y != yprevious) and trail_delay == speed_current * 0.03) {
    trail_delay = 0;
    
    var p = {
        x : x,
        y : y + 8,
        life : 3
    }
    
    array_insert(trail, 0, p);
}

for (var i = array_length(trail) - 1; i >= 0; --i) {
    var p = trail[i];
    
    p.life -= delta_time / 1_000_000;
    
    if (i >= trail_max) array_delete(trail, i, 1);
}

trail = array_filter(trail, function(p) {
    return p.life > 0;
});

draw_set_alpha(0.3);
for (var i = 0; i < array_length(trail); ++i) {
    var p = trail[i];
    
    draw_set_color(c_black);
    draw_rectangle(p.x - 1, p.y - 1, p.x + 1, p.y + 1, false);
}
draw_set_alpha(1);


// dibujar jugador
model_draw_body(animation, skin);