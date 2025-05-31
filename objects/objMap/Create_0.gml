gpu_set_texfilter(false);

path = global.assets.conf.level_path + "/";


// eventos
events = array_create(0); // crear array vacio

// tamaño de mapa y chunk
chunk_size = 32 * 1;

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


// cargar nivel (FUNCION)
function level_start(fname) {
    var map = cargar_objetos(fname);
    
    // cargar objetos por listas
    for (var i = 0; i < array_length(map); ++i) {
        var obj = map[i];
    
        var pos = [obj.pos[0], obj.pos[1]];
        
        var p = {
            type : obj.id,
            remove : false
        }
        
        // bloque
        if (obj.id == 0) {
            var cx = floor((pos[0] * 32) / chunk_size);
            var cy = floor((pos[1] * 32) / chunk_size);
            
            var inst = instance_create_depth(pos[0] * 32, pos[1] * 32, 0, (obj.z <= 0) ? objBlock : objBlockMask);
            
            inst.depth = -(pos[1] * 32 + (obj.z * 16));
            inst.spr = rsc_find_tex("block/" + obj.texture);
            inst.y -= obj.z * 16;
            
            // propiedad del objeto
            p.inst = inst;
            
            // desactivar al finalizar
            instance_deactivate_object(inst);
            
            ds_list_add(chunk[# cx, cy], p);
        }
        else if (obj.id == 1) {
            var cx = floor((pos[0] * 32) / chunk_size);
            var cy = floor((pos[1] * 32) / chunk_size);
            
            var inst = instance_create_depth(pos[0] * 32, pos[1] * 32, 0, objCommandBlock);
            
            
            // propiedades
            inst.destroy = obj.destroy;
            
            // comando
            var _PathFile = obj.path_cmd;
            
            if (file_exists(path + "commands/" + _PathFile)) {
                // si encuentra error seguir con otro objeto para prevenir errores
                try {
                    var json = json_parse(scrFile(path + "commands/" + _PathFile));
                }
                catch (e) {
                    show_debug_message("error: {0}", e);
                    continue;
                }
                
                inst.path_cmd = (is_array(json.events)) ? json.events : [];
            }
            
            
            // propiedad del objeto
            p.inst = inst;
            
            // desactivar al finalizar
            instance_deactivate_object(inst);
            
            ds_list_add(chunk[# cx, cy], p);
        }
        else if (obj.id == 2) {
            var cx = floor(((pos[0] * 32) + 32) / chunk_size);
            var cy = floor(((pos[1] * 32) + 32) / chunk_size);
            
            var inst = instance_create_depth(pos[0] * 32, pos[1] * 32, 0, objEntity);
            
            inst.skin = [rsc_find_tex("zombie_body"), rsc_find_tex("zombie_hand"), rsc_find_tex("zombie_hand"), rsc_find_tex("zombie_head")];
            inst.cx = cx;
            inst.cy = cy;
            with (inst) {
                create_entity(100, 10, 80);
            }
            
            // propiedad del objeto
            p.inst = inst;
            
            
            // desactivar al finalizar
            instance_deactivate_object(inst);
            
            ds_list_add(chunk[# cx, cy], p);
        }
        else if (obj.id == 3) {
            var cx = floor((pos[0] * 32) / chunk_size);
            var cy = floor((pos[1] * 32) / chunk_size);
            
            var inst = instance_create_depth(pos[0] * 32, pos[1] * 32, 0, objChest);
            
            
            // contenido en el cofre
            inst.content = obj.content;
            
            
            // propiedad del objeto
            p.inst = inst;
            
            
            // desactivar al finalizar
            instance_deactivate_object(inst);
            
            ds_list_add(chunk[# cx, cy], p);
        }
        
        show_debug_message(p);
    }
}


// guardar progreso
function level_save_progress(fname) {
    var buff = buffer_create(1024, buffer_grow, 1);
    
    buffer_write(buff, buffer_u16, objPlayer.x);
    buffer_write(buff, buffer_u16, objPlayer.y);
    
    for (var xx = 0; xx < width; ++xx) {
        for (var yy = 0; yy < height; ++yy) {
            var _chunk = chunk[# xx, yy];
            
            for (var i = 0; i < ds_list_size(_chunk); ++i) {
                var cell = _chunk[| i];
                
                show_debug_message(cell);
                buffer_write(buff, buffer_bool, cell.remove);
                
                if (cell.type == 2) {
                    buffer_write(buff, buffer_u16, cell.inst.x);
                    buffer_write(buff, buffer_u16, cell.inst.y);
                }
            }
        }
    }
    
    buffer_save(buff, fname);
    buffer_delete(buff);
}

// cargar progreso
function level_load_progress(fname) {
    var buff = buffer_load(fname);
    
    objPlayer.x = buffer_read(buff, buffer_u16);
    objPlayer.y = buffer_read(buff, buffer_u16);
    
    for (var xx = 0; xx < width; ++xx) {
        for (var yy = 0; yy < height; ++yy) {
            var _chunk = chunk[# xx, yy];
            
            for (var i = 0; i < ds_list_size(_chunk); ++i) {
                var cell = _chunk[| i];
                
                var is_destroy = buffer_read(buff, buffer_bool);
                
                if (is_destroy) {
                    if (instance_exists(cell.inst)) instance_destroy(cell.inst);
                    
                    cell.remove = true;
                    cell.inst = -1;
                }
                
                switch (cell.type) {
                	case 2:
                        cell.inst.x = buffer_read(buff, buffer_u16);
                        cell.inst.y = buffer_read(buff, buffer_u16);
                }
            }
        }
    }
    
    buffer_delete(buff);
}


// cargar chunk (FUNCION)
function chunk_load(xx, yy) {
    var objs = ds_grid_get(chunk, xx, yy);
    
    for (var i = ds_list_size(objs) - 1; i >= 0; --i) {
        var obj = objs[| i];
        
        if (!obj.remove) {
            // tipo de objeto
            switch (obj.type) {
                // bloque, comando, entidad o cofre
                case 0:
                case 1:
                case 2:
                case 3:
                    instance_activate_object(obj.inst);
                    break;
            }
        }
    }
}


// eliminar chunk (FUNCION)
function chunk_delete(xx, yy) {
    var objs = ds_grid_get(chunk, xx, yy);
    
    for (var i = ds_list_size(objs) - 1; i >= 0; --i) {
        var obj = objs[| i];
        
        if (!obj.remove) {
            // tipo de objeto
            switch (obj.type) {
                // bloque, comando, entidad o cofre
                case 0:
                case 1:
                case 2:
                case 3:
                    instance_deactivate_object(obj.inst);
                    break;
            }
        }
    }
}


// cargar nivel

instance_create_depth(room_width / 2, room_height / 2, 0, objPlayer);

level_start(path + "map.vxdata");
if (global.assets.conf.level_load) {
    level_load_progress(path + "progress.vxsave");
    global.assets.conf.level_load = false;
}