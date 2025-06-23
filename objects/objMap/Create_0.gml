path = global.assets.conf.level_path + "/";


// eventos
events = array_create(0); // crear array vacio

// tamaño de mapa y chunk
chunk_size = 32 * 5;

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
function level_start(map) {
    // cargar objetos por listas
    for (var i = 0; i < array_length(map); ++i) {
        var obj = map[i];
        
        var pos = [obj.pos[0], obj.pos[1]];
        
        var p = {
            type : obj.id,
            pos : pos
        }
        
        var cx = floor((pos[0] * 32) / chunk_size);
        var cy = floor((pos[1] * 32) / chunk_size);
        
        // bloque
        switch (obj.id) {
        	case 0:
                var inst = instance_create_depth(pos[0] * 32, pos[1] * 32, 0, (obj.z <= 0) ? objBlock : objBlockMask);
                
                inst.depth = -(pos[1] * 32 + (obj.z * 16)) - 16;
                inst.spr = rsc_find_tex("block/" + obj.texture);
                inst.y -= (obj.z * 16);
                
                // propiedad del objeto
                p.inst = inst;
                
                // desactivar al finalizar
                instance_deactivate_object(inst);
            break;
            
            case 1:
                var inst = instance_create_depth(pos[0] * 32, pos[1] * 32, 0, objCommandBlock);
                
                var _PathFile = obj.path_cmd; // ruta de archivo del comando (commands\example.json)
                
                if (file_exists(path + "commands/" + _PathFile)) {
                    // si encuentra error seguir con otro objeto para prevenir errores
                    try {
                        var json = json_parse(scrFile(path + "commands/" + _PathFile));
                    }
                    catch (e) {
                        show_debug_message("error: {0}", e);
                        continue;
                    }
                    
                    inst.active_json = (is_struct(json)) ? json : {};
                    inst.path_cmd = (is_array(json.events)) ? json.events : [];
                }
                
                
                // propiedad del objeto
                p.inst = inst;
                
                // desactivar al finalizar
                instance_deactivate_object(inst);
            break;
            
            case 2:
                var inst = instance_create_depth(pos[0] * 32, pos[1] * 32, 0, objEntity);
                
                // buscar la entidad existente
                var entity = -1;
                for (var j = 0; j < array_length(global.assets.entity); ++j) {
                    if (global.assets.entity[j].type == obj.entity) {
                        entity = struct_copy(global.assets.entity[j]);
                    }
                }
                
                // verificar si encontro
                if (entity == -1) {
                    show_debug_message("Error de entidad: {0}", obj.entity);
                    continue;
                }
                
                // skin
                inst.skin = [
                    rsc_find_tex(entity.type + "_body"),
                    rsc_find_tex(entity.type + "_hand"),
                    rsc_find_tex(entity.type + "_hand"),
                    rsc_find_tex(entity.type + "_head")
                ];
                
                // chunk
                inst.cx = cx;
                inst.cy = cy;
                
                // propiedad de la entidad
                var Anim = struct_get(global.assets.animation, entity.model); // animaciones del modelo (por ejemplo biped)
                var CountBone = Anim.count_bone; // cantidad de partes del cuerpo (brazos, manos, cabeza...)
                with (inst)
                    create_entity(entity.tag.health, entity.tag.strength, entity.tag.speed); // (vida, fuerza de ataque, velocidad de pasos)
                inst.attribute = entity.attribute; // atributos como fuerza, vida, velocidad de pasos, etc
                inst.events = entity.events; // eventos que se activan cuando hace una actividad la entidad
                inst.health_max = entity.tag.health; // eventos que se activan cuando hace una actividad la entidad
                
                inst.model = model_create(Anim, 4); // crear modelo con animaciones incluido
                
                // propiedad del objeto
                p.inst = inst;
                
                
                // desactivar al finalizar
                instance_deactivate_object(inst);
            break;
            
            case 3:
                var inst = instance_create_depth(pos[0] * 32, pos[1] * 32, 0, objChest);
                
                
                // contenido en el cofre
                inst.spr = rsc_find_tex(obj.texture);
                inst.content = obj.content;
                
                
                // propiedad del objeto
                p.inst = inst;
                
                
                // desactivar al finalizar
                instance_deactivate_object(inst);
            break;
            
            case 4:
                objPlayer.x = pos[0] * 32;
                objPlayer.y = pos[1] * 32;
                
                // fijar la camara
                var targetx = objPlayer.x - camera_get_view_width(view_camera[0]) / 2;
                var targety = objPlayer.y - camera_get_view_height(view_camera[0]) / 2;
                
                // limpiar propiedades del jugador
                if (obj.clear) {
                    objPlayer.slot = {
                        max : 4,
                        mainhand : 0,
                        items : [{}, {}, {}, {}],
                        armor : ""
                    }
                }
                
                camera_set_view_pos(view_camera[0], targetx, targety);
            break; 
        }
        
        if not (obj.id == 4) ds_list_add(chunk[# cx, cy], p);
    }
}

// cargar chunk (FUNCION)
function chunk_load(xx, yy) {
    var objs = ds_grid_get(chunk, xx, yy);
    
    for (var i = ds_list_size(objs) - 1; i >= 0; --i) {
        var obj = objs[| i];
        
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


// eliminar chunk (FUNCION)
function chunk_delete(xx, yy) {
    var objs = ds_grid_get(chunk, xx, yy);
    
    for (var i = ds_list_size(objs) - 1; i >= 0; --i) {
        var obj = objs[| i];
        
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


// cargar nivel
instance_create_depth(room_width / 2, room_height / 2, 0, objPlayer);

map = cargar_objetos(path + "map.vxdata");

level_start(map);