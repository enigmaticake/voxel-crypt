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
if (state_edit != window_type_edit.none) mouse_depth = 2;
else if (device_mouse_y_to_gui(0) <= height_window_principal * sf) mouse_depth = 0;
else if (point_in_rectangle(
    device_mouse_x_to_gui(0),
    device_mouse_y_to_gui(0),
    ww - 512 * sf,
    hh - 256 * sf,
    ww,
    hh) and window_edit_layer.active) mouse_depth = 3;
else mouse_depth = 1;


// Cursor en slot
var cursorX = floor(device_mouse_x(0) / 32);
var cursorY = floor(device_mouse_y(0) / 32);

if (mouse_depth == 1) {
    var objCell = ds_grid_get(layers[layer_current], cursorX, cursorY);
    
    // crear objeto
    if (type_cursor == 0 and !keyboard_check(vk_shift) and mouse_check_button(mb_left) and objCell == -1) {
        var data = ds_map_create();
        
        ds_map_copy(data, object_data);
        data[? "trigger_id"] = [];
        data[? "z"] = posy_global;
        array_sort(data[? "trigger_id"], true);
        
        ds_grid_set(layers[layer_current], cursorX, cursorY, data);
        ds_grid_set(objectos_seleccionados, cursorX, cursorY, true);
    }
    else if (mouse_check_button_released(mb_left)) ds_grid_clear(objectos_seleccionados, false);
    
    // eliminar objeto
    else if (type_cursor == 0 and keyboard_check(vk_shift) and mouse_check_button(mb_left)) {
        var obj = layers[layer_current][# cursorX, cursorY];
        
        if (obj != -1) {
            ds_map_destroy(obj);
            ds_grid_set(layers[layer_current], cursorX, cursorY, -1);
        }
    }
    
    // editar objeto
    else if (type_cursor == 0 and mouse_check_button(mb_right)) {
        var obj = layers[layer_current][# cursorX, cursorY];
        
        if (obj != -1) {
            obj_edit.obj = obj;
            obj_edit.pos = [cursorX, cursorY];
            
            state_edit = window_type_edit.edit_object;
            
            if (obj[? "id"] == 0) {
                array_push(textboxes_list, textbox_create(64, 64, "", 504));
            }
            else if (obj[? "id"] == 1) {
                array_push(textboxes_list, textbox_create(512, 64, "", 504));
                textboxes_list[0].text = obj[? "command"];
            }
        }
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