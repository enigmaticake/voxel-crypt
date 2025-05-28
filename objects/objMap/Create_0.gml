gpu_set_texfilter(false);

var path = global.assets.conf.level_path + "/";

var map = cargar_objetos(path + "map.vxdata");


// tamaño de mapa y chunk
chunk_size = 32 * 4;

width = floor(room_width div chunk_size);
height = floor(room_height div chunk_size);

// chunk
chunk = ds_grid_create(width, height);
for (var i = 0; i < width; ++i) {
    for (var j = 0; j < height; ++j) {
        ds_grid_add(chunk, i, j, ds_list_create());
    }
}

// chunk cargados
chunk_loading = ds_grid_create(width, height);
for (var i = 0; i < width; ++i) {
    for (var j = 0; j < height; ++j) {
        ds_grid_add(chunk_loading, i, j, false);
    }
}


// posicion del jugador en chunks
plx = 0;
ply = 0;


// cargar objetos por listas
for (var i = 0; i < array_length(map); ++i) {
    var obj = map[i];

    var pos = [obj.pos[0], obj.pos[1]];
    
    // bloque
    if (obj.id == 0) {
        var cx = floor((pos[0] * 32) / chunk_size);
        var cy = floor((pos[1] * 32) / chunk_size);
        
        var inst = instance_create_depth(pos[0] * 32, pos[1] * 32, 0, (obj.z <= 0) ? objBlock : objBlockMask);
        
        inst.depth = -(pos[1] * 32 + (obj.z * 16));
        inst.spr = rsc_find_tex("Block_" + obj.texture);
        inst.y -= obj.z * 16;
        
        // propiedad del objeto
        var p = {
            type : 0,
            inst : inst,
        }
        
        // desactivar al finalizar
        instance_deactivate_object(inst);
        
        ds_list_add(chunk[# cx, cy], p);
    }
    else if (obj.id == 1) {
        var cx = floor((pos[0] * 32) / chunk_size);
        var cy = floor((pos[1] * 32) / chunk_size);
        
        var inst = instance_create_depth(pos[0] * 32, pos[1] * 32, 0, objCommandBlock);
        
        inst.command = obj.command;
        
        // propiedad del objeto
        var p = {
            type : 0,
            inst : inst,
        }
        
        // desactivar al finalizar
        instance_deactivate_object(inst);
        
        ds_list_add(chunk[# cx, cy], p);
    }
    else if (obj.id == 2) {
        var cx = floor((pos[0] * 32) / chunk_size);
        var cy = floor((pos[1] * 32) / chunk_size);
        
        // propiedad del objeto
        var p = {
            type : 2,
            pos : pos,
            inst : -1,
        }
        
        ds_list_add(chunk[# cx, cy], p);
    }
}

instance_create_depth(room_width / 2, room_height / 2, -1, objPlayer);


// cargar chunk (FUNCION)
function chunk_load(xx, yy) {
    var objs = ds_grid_get(chunk, xx, yy);
    
    for (var i = ds_list_size(objs) - 1; i >= 0; --i) {
        var obj = objs[| i];
        
        if (obj.type == 0) {
            instance_activate_object(obj.inst);
        }
        else if (obj.type == 2) {
            // spawnear si no existe la entidad
            if (obj.inst == -1) {
                var ent = instance_create_depth(obj.pos[0] * 32, obj.pos[1] * 32, 0, objEntity);
                
                ent.skin = [rsc_find_tex("zombie_head"), rsc_find_tex("zombie_body"), rsc_find_tex("zombie_hand")];
                ent.cx = floor((obj.pos[0] * 32) / chunk_size);
                ent.cy = floor((obj.pos[1] * 32) / chunk_size);
                with (ent) {
                    create_entity(100, 10, 80);
                }
                
                obj.inst = ent;
            }
            
            // activar la entidad si existe
            else if (obj.inst != -1) {
                instance_activate_object(objEntity);
            }
        }
    }
}


// eliminar chunk (FUNCION)
function chunk_delete(xx, yy) {
    var objs = ds_grid_get(chunk, xx, yy);
    
    for (var i = ds_list_size(objs) - 1; i >= 0; --i) {
        var obj = objs[| i];
        
        if (obj.type >= 0 and obj.type <= 2) {
            instance_deactivate_object(obj.inst);
        }
    }
}