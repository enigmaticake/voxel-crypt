// mensaje
question = -1;


// nivel estado
time_day = true;


// mouse depth
mouse_depth = 1;
layer_current = 0;

type_cursor = 0;

object_data = ds_map_create();
ds_map_add(object_data, "id", 0); // tipo de objeto
ds_map_add(object_data, "z", 0); // posicion z
ds_map_add(object_data, "sprite", global.lists.block[0]); // textura
ds_map_add(object_data, "trigger_id", []); // trigger


// ventanas y estados
enum states_editor {
    configuration,
    
    principal,
    objetos,
    objetos_bloques,
    objetos_entidades
}
state = states_editor.principal;
height_window_principal = 96;


// ventana de edicion
enum window_type_edit {
    none,
    edit_object,
    edit_trigger
}


// ventana de layer
window_edit_layer = {
    active : false,
}


// ventana custom
var TriggerID = 1 << 0; // 0001
var ContentChest = 1 << 1; // 0010
CustomMenu = 0;


// ventana de edicion de objetos
state_edit = window_type_edit.none;
obj_edit = {
    obj : -1,
    pos : [-1, -1],
}
windowObjectEdit = {
    buttons_list : [],
    buttony : 0
}



#region crear primer capa
// tamaño de la mapa divido del tamaño de las celdas 32x32px
width = room_width / 32;
height = room_height / 32;

layers = [ds_grid_create(width, height)];

ds_grid_clear(layers[0], -1);
#endregion                                                               


#region Cargar objetos
global.assets.conf.level_type = 1; // Modo editor

var path = global.assets.conf.level_path + "/"; // Ruta de directorio de la mapa


// Verificar si existe la mapa
if (!file_exists(path + "map.vxdata")) {
    show_message("Error This level file path does not exist\n" + path + "map.vxdata");
    room_goto(rmMenu);
}


// GUARDAR MAPA
function guardarmapa() {
    var objects = [];
    
    for (var i = 0; i < array_length(layers); ++i) {
        for (var xx = 0; xx < width; ++xx) {
            for (var yy = 0; yy < height; ++yy) {
                var dataObj = layers[i][# xx, yy];
                
                if (dataObj == -1) continue;
                
                var data = {
                    id : dataObj[? "id"],
                    pos : [xx + (dataObj[? "offset_x"] ?? 0.0), yy + (dataObj[? "offset_y"] ?? 0.0)],
                    layer : i,
                }
                
                switch (data.id) { 
                    case 0: // bloque
                        data.texture = dataObj[? "sprite"];
                        data.z = clamp(dataObj[? "z"], 0, 5);
                    break;
                    
                    case 1: // comando
                        data.path_cmd = dataObj[? "path_cmd"];
                    break;
                    
                    case 2: // entidad
                        data.entity = dataObj[? "entity"];
                    break;
                    
                    case 3: // cofre
                        data.type_chest = dataObj[? "type_chest"];
                        data.content = dataObj[? "content"];
                    break;

                    case 4: // startpoint
                        data.clear = dataObj[? "clear"];
                    break;
                }
                
                data.triggers = dataObj[? "trigger_id"];
                
                array_push(objects, data);
            }
        }
    }
    
    guardar_objetos(objects, global.assets.conf.level_path + "/map.vxdata", {});
    
    
    // ===== configuraciones del nivel =====
    
    var buff = buffer_create(1024, buffer_grow, 1);
    
    
    // formato de archivo
    buffer_write(buff, buffer_string, "level_conf");
    
    
    // version
    buffer_write(buff, buffer_u8, versionMajor);
    buffer_write(buff, buffer_u16, versionMinor);
    buffer_write(buff, buffer_u16, versionPatch);
    
    
    // dia
    buffer_write(buff, buffer_bool, time_day);
    
    
    // guardar archivo binario
    buffer_save(buff, global.assets.conf.level_path + "/conf.vxdata");
    
    buffer_delete(buff);
    
    // ===== configuraciones del editor =====
    
    buff = buffer_create(1024, buffer_grow, 1);
    
    
    // formato de archivo
    buffer_write(buff, buffer_string, "7560DDF87554D2D5FB0C1F10F1C993A26D800FC9");
    
    
    // version
    buffer_write(buff, buffer_u8, versionMajor);
    buffer_write(buff, buffer_u16, versionMinor);
    buffer_write(buff, buffer_u16, versionPatch);
    
    
    // camara
    buffer_write(buff, buffer_u16, camera_get_view_x(view_camera[0]));
    buffer_write(buff, buffer_u16, camera_get_view_y(view_camera[0]));
    
    
    // guardar archivo binario
    buffer_save(buff, global.assets.conf.level_path + "/editor.vxdata");
    
    buffer_delete(buff);
}


// CARGAR MAPA EXISTENTE
var map = cargar_objetos(path + "map.vxdata");


///////// verificar errores
var _version = cargar_version_mapa(path + "map.vxdata");
var v = version_comparator(_version.major, _version.minor, _version.patch);

// version antigua
if (v == -1) {
    show_message($"Version posterior, actualiza el juego para poder usarlo.\nVersion: '{_version.major}.{_version.minor}.{_version.patch}'.");
    room_goto(rmMenu);
}

else if (v == 1) {
    show_message($"Version antigua.\n'{_version.major}.{_version.minor}.{_version.patch}'");
}

else if (map == -1) {
    show_message("Formato no valido.");
    room_goto(rmMenu);
}


// cargar objetos por listas
for (var i = 0; i < array_length(map); ++i) {
    var obj = map[i];
    
    var data = ds_map_create();
    
    ds_map_add(data, "trigger_id", obj.triggers);
    ds_map_add(data, "id", obj.id);
    
    ds_map_add(data, "offset_x", obj.pos[0] - int64(obj.pos[0]));
    ds_map_add(data, "offset_y", obj.pos[1] - int64(obj.pos[1]));
    
    switch (obj.id) {
        case 0: // bloque
            ds_map_add(data, "sprite", obj.texture ?? "stone");
            ds_map_add(data, "z", clamp(obj.z, 0, 5) ?? 0);
        break;
        
        case 1: // comando
            ds_map_add(data, "sprite", obj.texture ?? "editor_object_cmd");
            ds_map_add(data, "path_cmd", obj.path_cmd ?? "");
        break;
        
        case 2: // entidad (mob)
            ds_map_add(data, "entity", obj.entity ?? "zombie");
            ds_map_add(data, "sprite", obj.texture ?? "editor_object_entity");
        break;
        
        case 3: // cofre
            ds_map_add(data, "type_chest", obj.type_chest ?? "normal");
            ds_map_add(data, "content", obj.content ?? []);
            ds_map_add(data, "sprite", obj.texture ?? "chest/normal");
        break;
        
        case 4: // punto de inicio
            ds_map_add(data, "sprite", obj.texture ?? "editor_object_startpoint");
            ds_map_add(data, "clear", obj.clear ?? false);
        break;
    }
    
    // crear capas antes de establecer en una capa inexistente
    while (obj.layer >= array_length(layers)) {
        array_push(layers, ds_grid_create(width, height));
        ds_grid_clear(layers[array_length(layers) - 1], -1);
    }
    
    ds_grid_set(layers[obj.layer], obj.pos[0], obj.pos[1], data);
}
#endregion

#region cargar mapa propiedades
var _worldconf = cargar_config_mapa(path + "conf.vxdata");

time_day = _worldconf.day;
#endregion

#region cargar configuraciones del editor
var _editorconf = cargar_config_editor(path + "editor.vxdata");

camera_set_view_pos(view_camera[0], _editorconf.camera[0], _editorconf.camera[1]);
#endregion


// movimiento
function move_object(xxm, yym) {
    var start_x = (xxm > 0) ? width - 1 : 0;
    var end_x = (xxm > 0) ? -1 : width;
    var step_x = (xxm > 0) ? -1 : 1;
    
    var start_y = (yym > 0) ? height - 1 : 0;
    var end_y = (yym > 0) ? -1 : height;
    var step_y = (yym > 0) ? -1 : 1;
    
    for (var xx = start_x; xx != end_x; xx += step_x) {
        for (var yy = start_y; yy != end_y; yy += step_y) {
            var cell = layers[layer_current][# xx, yy];
            var sell = objectos_seleccionados[# xx, yy];
            
            if (sell) {
                var new_x = xx + xxm;
                var new_y = yy + yym;
                
                if (new_x >= 0 && new_x < width && new_y >= 0 && new_y < height) {
                    ds_grid_set(objectos_seleccionados, xx, yy, false);
                    ds_grid_set(objectos_seleccionados, new_x, new_y, true);
                }
            }
            
            if (cell != -1) {
                var new_x = xx + xxm;
                var new_y = yy + yym;
                
                if (new_x >= 0 && new_x < width && new_y >= 0 && new_y < height) {
                    var propObj = ds_map_create();
                    ds_map_copy(propObj, cell);
                    
                    ds_map_destroy(cell);
                    
                    ds_grid_set(layers[layer_current], xx, yy, -1);
                    ds_grid_set(layers[layer_current], new_x, new_y, propObj);
                }
            }
        }
    }
}


// selector de objetos
objectos_seleccionados = ds_grid_create(width, height);
ds_grid_clear(objectos_seleccionados, false);
seleccion_start = [-1, -1];

posy_global = 0;

key_only = function() {
    return !keyboard_check(vk_shift) and !keyboard_check(vk_control) and !keyboard_check(vk_alt);
}