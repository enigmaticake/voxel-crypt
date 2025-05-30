/// @param {real} type_model tipo de modelo
/// @param {array<real>} part_body... tiene que ser un vector2D
/// @return {Id.DsMap}
function model_create(type_model) {
    var anim = ds_map_create();
    ds_map_add(anim, "anim", []);
    ds_map_add(anim, "type_model", type_model);
    ds_map_add(anim, "anim_time", 0);
    ds_map_add(anim, "anim_current", "idle");
    
    for (var i = 1; i < argument_count; ++i) {
        if (is_struct(argument[i]) and struct_exists(argument[i], "x") and struct_exists(argument[i], "y")) {
            array_push(anim[? "anim"], argument[i]);
        }
        else {
            show_debug_message("Error: argument[{0}] no es un array válido de x, y.", i);
        }
    }
    
    return anim;
}

/// @param {Id.DsMap} animation la animacion que existe
/// @param {string} type tipo de animacion (por ejemplo IDLE)
/// @param {real} type_model tipo de modelo
function model_set_animation(animation, type, type_model) {
    if (animation[? "anim_current"] != type) {
        animation[? "anim_time"] = 0;
        animation[? "anim_current"] = type;
    }
    
    animation[? "anim_time"] += delta_time / 1_000_000;
    
    switch (type_model) {
        case 0:
            switch (type) {
            	case "idle":
                    // head
                    animation[? "anim"][3].y = -5 + sin(animation[? "anim_time"] * 3);
            }
            break;
    }
}


/// @param {id.dsmap} animation
/// @param {array<asset.gmsprite>} skin
function model_draw_body(animation, skin) {
    var anim = animation[? "anim"];
    
    for (var i = 0; i < array_length(anim); ++i) {
        draw_sprite_ext(skin[i], 0, x + anim[i].x * image_xscale, y + anim[i].y, image_xscale, 1, 0, c_white, 1);
    }
}
