var sf = scale_factor();
display_set_gui_maximize();

// desactivar script
if (question != -1) {
    exit;
}


// tamaño de pantalla
var ww = display_get_gui_width();
var hh = display_get_gui_height();


// depth del mouse
if (CustomMenu > 0) mouse_depth = 5;
else if (state_edit != window_type_edit.none and device_mouse_y_to_gui(0) > 96 * sf) mouse_depth = 4;
else if (state_edit != window_type_edit.none and device_mouse_y_to_gui(0) <= 96 * sf) mouse_depth = 2;
else if (device_mouse_y_to_gui(0) <= height_window_principal * sf) mouse_depth = 0;
else if (point_in_rectangle(
    device_mouse_x_to_gui(0),
    device_mouse_y_to_gui(0),
    ww - 176 * sf,
    hh - 128 * sf,
    ww,
    hh) and window_edit_layer.active) mouse_depth = 3;
else mouse_depth = 1;


// Cursor en slot
var cursorX = floor(device_mouse_x(0) / 32);
var cursorY = floor(device_mouse_y(0) / 32);

if (mouse_depth == 1) {
    var objCell = ds_grid_get(layers[layer_current], cursorX, cursorY);
    
    // crear objeto
    if (type_cursor == 0 and key_only() and mouse_check_button_pressed(mb_left) and objCell == -1) {
        ds_grid_clear(objectos_seleccionados, false);
    }
    else if (type_cursor == 0 and key_only() and mouse_check_button(mb_left) and objCell == -1) {
        var data = ds_map_create();
        
        ds_map_copy(data, object_data);
        data[? "trigger_id"] = [];
        data[? "z"] = posy_global;
        array_sort(data[? "trigger_id"], true);
        
        ds_grid_set(layers[layer_current], cursorX, cursorY, data);
        ds_grid_set(objectos_seleccionados, cursorX, cursorY, true);
    }
    
    // eliminar objetos seleccionados con SUPR
    else if (keyboard_check_pressed(46)) {
        for (var i = 0; i < width; ++i) {
            for (var j = 0; j < height; ++j) {
                if (objectos_seleccionados[# i, j]) ds_grid_set(layers[layer_current], i, j, -1);
            }
        }
    }
    
    // eliminar objeto
    else if (type_cursor == 0 and keyboard_check(vk_control) and mouse_check_button(mb_left)) {
        var obj = layers[layer_current][# cursorX, cursorY];
        
        if (obj != -1) {
            ds_grid_clear(objectos_seleccionados, false);
            
            ds_map_destroy(obj);
            ds_grid_set(layers[layer_current], cursorX, cursorY, -1);
        }
    }
    
    // editar objeto
    else if (key_only() and mouse_check_button(mb_right)) {
        var CrearBoton = function(name, type, width, obj) {
            array_push(windowObjectEdit.buttons_list, {
                name : name,
                type : type,
                textbox : textbox_create(width * scale_factor(), 64 * scale_factor(), "", (width - 8) * scale_factor(), function(char, index, text) {
                    return (string_pos(char, "[] {} 0123456789.") > 0) ? #ffe299 : c_white;
                })
            });
            windowObjectEdit.buttons_list[array_length(windowObjectEdit.buttons_list) - 1].textbox.text = obj[? name];
        }
        var CrearBotonMenu = function(name, obj) {
            array_push(windowObjectEdit.buttons_list, {
                name : name,
                type : VarType.menu_panel,
            });
        }
        
        var obj = layers[layer_current][# cursorX, cursorY];
        
        if (obj != -1) {
            obj_edit.obj = obj;
            obj_edit.pos = [cursorX, cursorY];
            
            state_edit = window_type_edit.edit_object;
            
            CrearBotonMenu("trigger_id", obj);
            switch (obj[? "id"]) {
            	case 0:
                    CrearBoton("sprite", VarType.string, 256, obj);
                    CrearBoton("z", VarType.int, 64, obj);
                break;
                
                case 1:
                    CrearBoton("path_cmd", VarType.string, 512, obj);
                    CrearBoton("destroy", VarType.bool, 64, obj);
                break;
                
                case 2:
                    CrearBoton("entity", VarType.string, 256, obj);
                break;
                
                case 3:
                    CrearBoton("type_chest", VarType.string, 256, obj);
                break;
                
                case 4:
                    CrearBoton("clear", VarType.bool, 64, obj);
                break;
            }
        }
    }
    
    // seleccionar objetos
    else if (keyboard_check(vk_shift) and mouse_check_button_pressed(mb_left)) {
        seleccion_start = [device_mouse_x(0), device_mouse_y(0)];
    }
    else if (keyboard_check(vk_shift) and mouse_check_button(mb_left)) {
        ds_grid_clear(objectos_seleccionados, false);
        ds_grid_set_region(objectos_seleccionados, floor(seleccion_start[0]/32), floor(seleccion_start[1]/32), cursorX, cursorY, true);
    }
    
    // movimiento de cámara con input
    var spd = 16;
    var movex = (keyboard_check(ord("D")) - keyboard_check(ord("A"))) * spd;
    var movey = (keyboard_check(ord("S")) - keyboard_check(ord("W"))) * spd;
    
    // posición actual de cámara
    var cam_x = camera_get_view_x(view_camera[0]);
    var cam_y = camera_get_view_y(view_camera[0]);
    
    camera_set_view_pos(view_camera[0], cam_x + movex, cam_y + movey);
}


// mover botones de (object edit)
if (mouse_depth == 4) {
    if (mouse_wheel_up()) {
        windowObjectEdit.buttony = windowObjectEdit.buttony + 16*sf;
    }
    else if (mouse_wheel_down()) {
        windowObjectEdit.buttony = windowObjectEdit.buttony - 16*sf;
    }
    
    var buttonHeight = array_length(windowObjectEdit.buttons_list) * (64*sf);
    var maxHeight = -max(0, buttonHeight - (hh - 160*sf));
    windowObjectEdit.buttony = clamp(windowObjectEdit.buttony, maxHeight, 0);
}


// input
if (keyboard_check_pressed(vk_escape) and mouse_depth <= 1) {
    guardarmapa();
    room_goto(rmMenu);
}
else if (keyboard_check_pressed(vk_enter) and mouse_depth <= 1) {
    guardarmapa();
    room_goto(rmLevel);
}

posy_global += keyboard_check_pressed(vk_up) - keyboard_check_pressed(vk_down);