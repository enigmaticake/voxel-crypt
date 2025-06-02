/// @param {real} type_model tipo de modelo
/// @param {array<struct>} ... tiene que ser un vector2D
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

function model_free(animation) {
    ds_map_destroy(animation);
}

/// @param {Id.DsMap} animation la animacion que existe
/// @param {string} type tipo de animacion (por ejemplo IDLE)
/// @param {real} type_model tipo de modelo
function model_set_animation(animation, type, type_model) {
    var frame = animation[? "anim_time"]; // copiar el tiempo actual
    
    if (animation[? "anim_current"] != type) {
        frame = 0;
        animation[? "anim_current"] = type;
    }
    
    frame += delta_time / 1_000_000; // sumar por microsegundos real
    
    switch (type_model) {
        case 0:
            switch (type) {
            	case "idle":
                    // head
                    animation[? "anim"][BODY_OFFSET.head].y = -3 + sin(animation[? "anim_time"] * 3) * 1.5;
                break;
            }
        break;
    }
    
    animation[? "anim_time"] = frame; // establecer al tiempo original
}


/// @param {id.dsmap} animation
/// @param {array<asset.gmsprite>} skin
function model_draw_body(animation, skin, color = c_white, alpha = 1) {
    var anim = animation[? "anim"];
    
    for (var i = 0; i < array_length(anim); ++i) {
        draw_sprite_ext(skin[i], 0, x + anim[i].x * image_xscale, y + anim[i].y, image_xscale, 1, 0, color, alpha);
    }
}
