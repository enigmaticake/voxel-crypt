rsc_unload_tex("BlockEditor");

for (var i = array_length(layers) - 1; i >= 0; --i) {
    // elimina datos de objetos
    for (var xx = 0; xx < width; ++xx) {
        for (var yy = 0; yy < height; ++yy) {
            var obj = layers[i][# xx, yy];
            
            if (ds_exists(obj, ds_type_map)) ds_map_destroy(obj);
        }
    }
    
    // elimina capas
    ds_grid_destroy(layers[i]);
}

// eliminar capa seleccion
ds_grid_destroy(objectos_seleccionados);
ds_map_destroy(object_data);