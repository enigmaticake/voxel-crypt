/// @param {struct} AnimationJson animation json (load)
/// @param {real} Count Cantidad de huesos que tendra
/// @return {Id.DsMap}
function model_create(_anim, _count) {
    var anim = ds_map_create();
    ds_map_add(anim, "anim", []);
    ds_map_add(anim, "animationJSON", _anim);
    ds_map_add(anim, "anim_time", 0);
    ds_map_add(anim, "anim_current", "idle");
    
    for (var i = 0; i < _count; ++i) {
        array_push(anim[? "anim"], new Vec2r(0, 0, 0));
    }
    
    return anim;
}

function model_free(model) {
    ds_map_destroy(model);
}

/// @param {id.dsmap} model model actual
/// @param {string} animation la animacion que existe
function model_set_animation(model, animation, bits = 0) {
    function get_prop(a, b) {
        return (b < array_length(a)) ? a[b] : undefined;
    }
    var frame = model[? "anim_time"]; // copiar el tiempo actual
    
    if (model[? "anim_current"] != animation) {
        frame = 0.00;
        model[? "anim_current"] = animation;
    }
    
    var anim = struct_get(model[? "animationJSON"], animation);
    
    if (anim != undefined) {
        for (var i = 0; i < array_length(anim.bone); ++i) {
            var frameCurrently = struct_get(anim.bone[i], string_format(frame - 0.01, 1, 2));
            
            if (!is_undefined(frameCurrently)) {
                var vector = struct_get(frameCurrently, "vec2r") ?? []; // Transform2D
                model[? "anim"][i].x = get_prop(vector, 0) ?? 0; // x
                model[? "anim"][i].y = get_prop(vector, 1) ?? 0; // y
                model[? "anim"][i].angle = get_prop(vector, 2) ?? 0; // angulo
                model[? "anim"][i].color = get_prop(vector, 3) ?? c_white; // color
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
function model_draw_body(model, skin, color = c_white, alpha = 1, nbt = -1) {
    var get_spr = function(nbt, type, index) {
        var struct = struct_get(nbt, type) ?? [];
        return (index < array_length(struct)) ? struct[index] : -1;
    }
    
    var anim = model[? "anim"];
    
    for (var i = 0; i < array_length(anim); ++i) {
        var xx = anim[i].x * image_xscale;
        var yy = anim[i].y;
        var angle = anim[i].angle * image_xscale;
        var _color = struct_get(anim[i], "color") ?? c_white;
        
        draw_sprite_ext(skin[i], 0, x + xx, y + yy, image_xscale, 1, angle, _color, alpha);
        if (nbt != -1) {
            var _item = get_spr(nbt, "mainhand", i);
            var _skin_cape = get_spr(nbt, "skin_cape", i);
            
            if (_skin_cape != -1) draw_sprite_ext(_skin_cape, 0, x + xx, y + yy, image_xscale, 1, angle, _color, alpha);
            if (_item != -1) draw_sprite_ext(_item, 0, x + xx, y + yy - 16, image_xscale, 1, angle, _color, alpha);
        }
    }
}