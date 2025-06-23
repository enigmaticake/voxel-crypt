function get_item() {
    return struct_get(slot.items[slot.mainhand], "sprite") ?? -1;
}
function get_armor(index) {
    spr = -1;
    
    switch (index) {
    	case 0:
            spr = "armor/" + slot.armor + "_body";
        break;
        
    	case 1:
            spr = "armor/" + slot.armor + "_hand";
        break;
        
    	case 2:
            spr = "armor/" + slot.armor + "_hand";
        break;
        
    	case 3:
            spr = "armor/" + slot.armor + "_head";
        break;
    }
    
    return rsc_find_tex(spr);
}

// dibujar jugador
if (surface_exists(surf)) {
    surface_set_target(surf);
    draw_clear_alpha(c_white, 0);
    model_draw_body(model, skin, c_white, 1, {mainhand:[-1, -1, get_item(), -1],skin_cape:[get_armor(0), get_armor(1), get_armor(2), get_armor(3)]}, 48, 48);
    surface_reset_target();
    
    shader_set(sh_shadow);
    draw_surface(surf, x - 48, y - 48);
    shader_reset();
}
else surf = surface_create(96, 96);