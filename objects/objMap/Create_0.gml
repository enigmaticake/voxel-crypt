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
        
        var inst = instance_create_depth(pos[0] * 32, pos[1] * 32, 0, objBlock);
        
        inst.depth = -(pos[1] * 32);
        inst.spr = rsc_find_tex("Block_" + obj.texture);
        
        // propiedad del objeto
        var p = {
            type : 0,
            inst : inst,
            x : pos[0],
            y : pos[1]
        }
        
        ds_list_add(chunk[# cx, cy], p);
    }
}

instance_create_depth(room_width / 2, room_height / 2, -1, objPlayer);


// cargar chunk (FUNCION)
function chunk_load(xx, yy) {
    var objs = ds_grid_get(chunk, xx, yy);
    
    for (var i = 0; i < ds_list_size(objs); ++i) {
        var obj = objs[| i];
        
        if (obj.type == 0) {
            instance_activate_object(obj.inst);
        }
    }
}


// eliminar chunk (FUNCION)
function chunk_delete(xx, yy) {
    var objs = ds_grid_get(chunk, xx, yy);
    
    for (var i = 0; i < ds_list_size(objs); ++i) {
        var obj = objs[| i];
        
        if (obj.type == 0) {
            instance_deactivate_object(obj.inst);
        }
    }
}