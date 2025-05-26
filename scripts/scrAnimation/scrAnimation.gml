/// @param {array<real>} head cabeza
/// @param {array<real>} body cuerpo (especialmente en el centro del objeto)
/// @param {array<real>} handL mano izquierda
/// @param {array<real>} handR mano derecha
/// @return {Id.DsMap}
function model_create(head, body, handL, handR) {
    var anim = ds_map_create();
    ds_map_add(anim, "idle", [head, body, handL, handR]);
    ds_map_add(anim, "anim_time", 0);
    ds_map_add(anim, "anim_current", "idle");
    
    return anim;
}

/// @param {real} type tipo de animacion (por ejemplo IDLE)
/// @param {Id.DsMap} animation la animacion que existe
function model_set_animation(type, animation) {
    if (animation[? "anim_current"] != type) {
        animation[? "anim_time"] = 0;
        animation[? "anim_current"] = type;
    }
    
    animation[? "anim_time"] += delta_time / 1_000_000;
    
    switch (type) {
    	case "idle":
            // head
            animation[? type][0].y = -5 + sin(animation[? "anim_time"] * 3);
    }
}


/// @param {id.dsmap} animation
/// @param {array<asset.gmsprite>} skin
function model_draw_body(animation, skin) {
    var anim = animation[? animation[? "anim_current"]];
    
    
    // body
    draw_sprite_ext(skin[1], 0, x + anim[1].x * image_xscale, y + anim[1].y, image_xscale, 1, 0, c_white, 1);
    
    // head
    draw_sprite_ext(skin[0], 0, x + anim[0].x * image_xscale, y + anim[0].y, image_xscale, 1, 0, c_white, 1);
    
    // hand left
    draw_sprite_ext(skin[2], 0, x + anim[2].x * image_xscale, y + anim[2].y, image_xscale, 1, 0, c_white, 1);
    
    // hand right
    draw_sprite_ext(skin[2], 0, x + anim[3].x * image_xscale, y + anim[3].y, image_xscale, 1, 0, c_white, 1);
}
