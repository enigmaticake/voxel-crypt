/**
 * Guardar objetos de mapa. "[tamaño de mapa, [ objetos ]]"
 * @param {array} _objetos Objetos en struct
 * @param {string} fname Ruta de archivo en el que guardar
 */
function guardar_objetos(_objetos, fname) {
    // Crea un buffer para almacenar los datos
    var buffer = buffer_create(1024, buffer_grow, 1);
    
    buffer_write(buffer, buffer_string, "level_game"); // formato de archivo (level_game)
    
    
    // formato de version X.X.X
    buffer_write(buffer, buffer_u16, versionMajor); // major
    buffer_write(buffer, buffer_u8, versionMinor); // minor
    buffer_write(buffer, buffer_u8, versionPatch); // patch
    
    
    // guardar objetos
    buffer_write(buffer, buffer_u16, array_length(_objetos)); // Escribir la cantidad de objetos a guardar
    
    for (var i = 0; i < array_length(_objetos); i++) {
        var objeto = _objetos[i];
        var _id = real(ref_get(objeto, "id", type_object.block));
        
        
        // Guardar la posición 2D (vector2D)
        buffer_write(buffer, buffer_u8, objeto.pos[0]); // x
        buffer_write(buffer, buffer_u8, objeto.pos[1]); // y
        
        
        // Guardar de objeto como id
        buffer_write(buffer, buffer_u16, int64(_id));
        
        
        // guardar la cantidad de id target
        var len = array_length(ref_get(objeto, "triggers", []));
        
        buffer_write(buffer, buffer_u8, len);
        
        for (var j = 0; j < len; ++j) {
            buffer_write(buffer, buffer_u16, real(objeto.triggers[j]));
        }
        
        
        // id
        switch (_id) {
            case 0:
                buffer_write(buffer, buffer_string, objeto.texture);
                buffer_write(buffer, buffer_u8, objeto.z);
                break;
            
            case 1:
                buffer_write(buffer, buffer_string, objeto.path_cmd);
                buffer_write(buffer, buffer_bool, objeto.destroy);
                break;
            
            case 2:
                buffer_write(buffer, buffer_string, objeto.entity);
                break;
            
            case 3:
                // tipo de cofre
                buffer_write(buffer, buffer_string, objeto.type_chest);
                
                // contenido
                len = array_length(objeto.content);
                
                buffer_write(buffer, buffer_u8, len); // cantidad de contenido
                
                for (var j = 0; j < len; ++j) {
                    buffer_write(buffer, buffer_u8, objeto.content[j]); // cualquier cosa, no?
                }
                break;
        }
        
        
        // capa
        buffer_write(buffer, buffer_u8, objeto.layer);
        
    }
    
    
    // Guardar el buffer en un archivo
    buffer_save(buffer, fname);
    buffer_delete(buffer);
}


/**
 * Cargar objetos de mapa. error: 0 = version antigua, 1 = version superior o desconocida, 2 = formato no valido
 * @param {string} fname Ruta de archivo en el que cargar
 * @returns {array<struct>}
 */
function cargar_objetos(fname) {
    var buffer = buffer_load(fname);
    
    var format = buffer_read(buffer, buffer_string); // tipo de archivo
    
    // X.X.X formato de la version
    var _major = buffer_read(buffer, buffer_u16);
    var _minor = buffer_read(buffer, buffer_u8);
    var _patch = buffer_read(buffer, buffer_u8);
    
    
    // cantidad de objetos
    var _list = buffer_read(buffer, buffer_u16); // listas de objetos
    var _objs = [];
    
    
    // formato
    if (format != "level_game") return -1;
    
    
    // cargar objetos
    for (var i = 0; i < _list; i++) {
        var objeto = {};
        
        // posicion del objeto
        var xx = buffer_read(buffer, buffer_u8); // x
        var yy = buffer_read(buffer, buffer_u8); // y
        objeto.pos = [xx, yy];
        
        // id del objeto
        objeto.id = buffer_read(buffer, buffer_u16);
        
        // cantidad de targets de trigger
        var countTarget = buffer_read(buffer, buffer_u8);
        var targets = [];
        
        for (var j = 0; j < countTarget; ++j) {
            array_push(targets, real(buffer_read(buffer, buffer_u16)));
        }
        objeto.triggers = targets;
        
        // cargar propiedades personalizada depende de la id del objeto
        switch (objeto.id) {
            case 0:
                objeto.texture = buffer_read(buffer, buffer_string);
                objeto.z = buffer_read(buffer, buffer_u8);
                
                // arreglar bugs de texturas
                if (rsc_find_tex("block/" + objeto.texture) == -1) {
                    objeto.texture = global.lists.block[0];
                }
                
                break;
            
            case 1:
                objeto.texture = "editor_object_cmd";
                objeto.path_cmd = buffer_read(buffer, buffer_string);
                objeto.destroy = buffer_read(buffer, buffer_bool);
                break;
            
            case 2:
                objeto.texture = "editor_object_entity";
                objeto.entity = buffer_read(buffer, buffer_string);
                break;
            
            case 3:
                objeto.type_chest = buffer_read(buffer, buffer_string);
                objeto.texture = "chest/" + objeto.type_chest;
                
                objeto.content = [];
                var len = buffer_read(buffer, buffer_u8);
                for (var j = 0; j < len; ++j) {
                    array_push(objeto.content, buffer_read(buffer, buffer_u8));
                }
                
                show_debug_message(objeto);
                break;
        }
        
        // capa
        objeto.layer = buffer_read(buffer, buffer_u8);
        
        
        // terminar
        array_push(_objs, objeto);
    }
    
    buffer_delete(buffer);
    
    
    show_debug_message($"version: {_major}.{_minor}.{_patch}\ncantidad de objetos:{_list}");
    return _objs;
}

function cargar_version_mapa(fname) {
    var buffer = buffer_load(fname);
    
    buffer_read(buffer, buffer_string);
    
    var major = buffer_read(buffer, buffer_u16);
    var minor = buffer_read(buffer, buffer_u8);
    var patch = buffer_read(buffer, buffer_u8);
    
    var v = {
        major:major,
        minor:minor,
        patch:patch
    }
    
    return v;
}

function cargar_config_mapa(fname) {
    var buffer = buffer_load(fname);
    
    var c = {
        day:true
    }
    
    
    // formato de archivo
    var form = buffer_read(buffer, buffer_string);
    
    if (form != "level_conf") return c;
    
    
    // version
    var major = buffer_read(buffer, buffer_u16);
    var minor = buffer_read(buffer, buffer_u8);
    var patch = buffer_read(buffer, buffer_u8);
    
    if (version_comparator(major, minor, patch) == -1) return c;
    
    
    // dia
    var day = buffer_read(buffer, buffer_bool);
    
    
    // añadir al c propiedades
    c.day = day;
    
    return c;
}

function cargar_config_editor(fname) {
    var buffer = buffer_load(fname);
    
    var c = {
        camera:[992, 992],
    }
    
    
    // formato de archivo
    var form = buffer_read(buffer, buffer_string);
    
    if (form != "7560DDF87554D2D5FB0C1F10F1C993A26D800FC9") return c;
    
    
    // version
    var major = buffer_read(buffer, buffer_u16);
    var minor = buffer_read(buffer, buffer_u8);
    var patch = buffer_read(buffer, buffer_u8);
    
    if (version_comparator(major, minor, patch) == -1) return c;
    
    
    // posicion de la camara
    var cx = buffer_read(buffer, buffer_u16); // x
    var cy = buffer_read(buffer, buffer_u16); // y
    
    
    // añadir al c propiedades
    c.camera[0] = cx;
    c.camera[1] = cy;
    
    return c;
}


#region xml
/**
 * @param {string} xml
 * @param {string} xml_text
 * @param {any} value
 * @returns {string}
 */
function xml_parse(xml_text, xml, value) {
    var start_pos = string_pos("<" + xml + ">", xml_text) + string_length("<" + xml + ">");
    var end_pos = string_pos("</" + xml + ">", xml_text);
    
    if (start_pos > 0 && end_pos > 0) {
        return string_copy(xml_text, start_pos, end_pos - start_pos);
    } else {
        return value
    }
}
#endregion

#region hexadecimal
function dec_to_hex(n) {
    var hex = "0123456789ABCDEF";
    var res = "";
    repeat(8) {
        var index = (n mod 16); // Usamos "mod" en lugar de "& 15"
        res = string_copy(hex, index + 1, 1) + res;
        n = n div 16; // Desplazamos dividiendo
        if (n == 0) break;
    }
    return res;
}
function hex_to_dec(hex_str) {
    hex_str = string_upper(hex_str); // Asegura que esté en mayúsculas
    var hex = "0123456789ABCDEF";
    var result = 0;
    var len = string_length(hex_str);
    
    for (var i = 0; i < len; i++) {
        var char = string_char_at(hex_str, i + 1);
        var value = string_pos(char, hex) - 1;
        if (value < 0) return -1; // Caracter no válido
        result = result * 16 + value;
    }
    
    return result;
}
#endregion


/**
 * comparar versiones
 * @param {real} major mejor
 * @param {real} minor menor
 * @param {real} patch parche
 * @returns {real}
 */
function version_comparator(major, minor, patch) {
    if (versionMajor > major) return 1;
    else if (versionMajor < major) return -1;
        
    if (versionMinor > minor) return 1;
    else if (versionMinor < minor) return -1;
        
    if (versionPatch > patch) return 1;
    else if (versionPatch < patch) return -1;
        
    return 0;
}

function chunk_delete_data(xx, yy) {
    // Sacarse del chunk viejo
    var old_list = objMap.chunk[# xx, yy];
    for (var i = 0; i < ds_list_size(old_list); ++i) {
        var p = old_list[| i];
        if (p.inst == id) {
            p.remove = true;
            break;
        }
    }
}