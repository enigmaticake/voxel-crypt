/// @param {struct} AnimationJson animation json (load)
/// @param {struct} Vector2D... tiene que ser un vector2D
/// @return {Id.DsMap}
function model_create(_anim) {
    var anim = ds_map_create();
    ds_map_add(anim, "anim", []);
    ds_map_add(anim, "animationJSON", _anim);
    ds_map_add(anim, "anim_time", 0);
    ds_map_add(anim, "anim_current", "idle");
    
    for (var i = 1; i < argument_count; ++i) {
        if (is_struct(argument[i]) and struct_exists(argument[i], "x") and struct_exists(argument[i], "y") and struct_exists(argument[i], "angle")) {
            array_push(anim[? "anim"], argument[i]);
        }
        else {
            show_debug_message("Error: argument[{0}] no es un array válido de Transform2D.", i);
        }
    }
    
    return anim;
}

function model_free(model) {
    ds_map_destroy(model);
}

/// @param {id.dsmap} model model actual
/// @param {string} animation la animacion que existe
function model_set_animation(model, animation, bits = 0) {
    var frame = model[? "anim_time"]; // copiar el tiempo actual
    
    if (model[? "anim_current"] != animation) {
        frame = 0.00;
        model[? "anim_current"] = animation;
    }
    
    var anim = struct_get(model[? "animationJSON"], animation);
    
    if (anim != undefined) {
        for (var i = 0; i < array_length(anim.bone); ++i) {
            var frameCurrently = struct_get(anim.bone[i], string_format(frame - 0.01, 1, 2));
            
            if (frameCurrently != undefined) {
                model[? "anim"][i].x = frameCurrently.vec2r[0];
                model[? "anim"][i].y = frameCurrently.vec2r[1];
                model[? "anim"][i].angle = frameCurrently.vec2r[2];
            }
        }
        
        if (frame > anim.duration) {
            frame = 0.00;
            event &= ~bits;
        }
        
        frame += 0.01 * (struct_get(anim, "time") ?? 1);
    }
    
    model[? "anim_time"] = frame; // establecer al tiempo original
}


/// @param {id.dsmap} model
/// @param {array<asset.gmsprite>} skin
function model_draw_body(model, skin, color = c_white, alpha = 1, mainhand = -1, mainhand_sprite = -1) {
    var anim = model[? "anim"];
    
    for (var i = 0; i < array_length(anim); ++i) {
        draw_sprite_ext(skin[i], 0, x + anim[i].x * image_xscale, y + anim[i].y, image_xscale, 1, anim[i].angle * image_xscale, color, alpha);
        if (mainhand == i)
            if (mainhand_sprite != -1)
                draw_sprite_ext(mainhand_sprite, 0, x + anim[i].x * image_xscale, y + anim[i].y - 16, image_xscale, 1, anim[i].angle * image_xscale, color, alpha);
    }
}
