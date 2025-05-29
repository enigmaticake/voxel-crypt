if (question == -1) {
    var sf = scale_factor();
    
    var ww, hh;
    
    // Posicion y tamaño
    ww = display_get_gui_width();
    hh = display_get_gui_height();
    
    // ventana tamaño
    if (state == states_editor.principal or state == states_editor.objetos) height_window_principal = 96 * sf;
    else if (state == states_editor.objetos_bloques or state == states_editor.objetos_entidades) height_window_principal = hh;
    else if (state == states_editor.configuration) height_window_principal = hh;
    
    
    // ventana de fondo de principal
    draw_set_color(#4b4b4b);
    draw_rectangle_outline(0, 0, ww, height_window_principal * sf, (mouse_depth == 0) ? c_white : c_dkgray, 3);
    
    
    // --------------------------------------
    // Ventanas
    // --------------------------------------
    
    
    // ====== panel de creacion ======
    
    // principal
    if (state == states_editor.principal) {
        // boton de objetos
        if (draw_button_gui(64, 64, 16 * sf, 16 * sf, 0, mouse_depth, c_lime) == buttonState.released) {
            state = states_editor.objetos;
        }
        draw_sprite(rsc_find_tex("create_levelEditor"), 0, 48 * sf, 48 * sf);
        
        // boton de capas (layers)
        if (draw_button_gui(64, 64, 96 * sf, 16 * sf, 0, mouse_depth, c_gray) == buttonState.released) {
            window_edit_layer.active = !window_edit_layer.active;
        }
        draw_sprite(rsc_find_tex("gui_layer_cape"), 0, 96 * sf, 16 * sf);
        
        // boton de configuracion
        if (draw_button_gui(64, 64, ww - 80 * sf, 16 * sf, 0, mouse_depth, c_gray) == buttonState.released) {
            state = states_editor.configuration;
        }
        draw_sprite(rsc_find_tex("gui_config"), 0, ww - 48 * sf, 48 * sf);
        
        // para objetos de tipo 0
        if (object_data[? "id"] == 0) {
            // texto 0
            draw_set_halign(fa_left);
            draw_set_valign(fa_middle);
            draw_set_color(c_black);
            draw_text(ww - 368 * sf, 16 * sf, "z:");
             
            // boton que suma el posy_global con flecha derecha
            if (draw_button_gui(64, 64, ww - 192 * sf, 16 * sf, 0, mouse_depth, c_black) == buttonState.released) {
                posy_global = min(5, posy_global + 1);
            }
            draw_sprite(rsc_find_tex("gui_arrowR"), 0, ww - 192 * sf, 16 * sf);
            
            // texto que muestra el valor de posy_global actual
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_set_color(c_white);
            draw_text_transformed(ww - 240 * sf, 48 * sf, posy_global, 2, 2, 0);
            
            // boton que resta el posy_global con flecha izquierda
            if (draw_button_gui(64, 64, ww - 352 * sf, 16 * sf, 0, mouse_depth, c_black) == buttonState.released) {
                posy_global = max(0, posy_global - 1);
            }
            draw_sprite(rsc_find_tex("gui_arrowL"), 0, ww - 352 * sf, 16 * sf);
        }
    }
    
    // configuracion
    else if (state == states_editor.configuration) {
        var bx = 16 * sf;
        var by = 16 * sf;
        
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        
        // salida
        if (draw_button_gui(64, 64, bx, by, 0, mouse_depth, c_red) == buttonState.released) {
            state = states_editor.principal;
        }
        draw_sprite(rsc_find_tex("gui_leave"), 0, bx + 32, by + 32);
        
        
        // dia o noche
        by += 68 * sf;
        if (draw_button_gui(64, 64, bx, by, 0, mouse_depth, c_white) == buttonState.pressed) {
            time_day = !time_day;
        }
        draw_set_color((time_day) ? c_lime : c_red);
        draw_rectangle(bx + 1, by + 1, bx + 63, by + 63, false);
        
        draw_set_color(c_black);
        draw_set_halign(fa_left);
        draw_text(bx + 68, by + 32, "day (default in green)");
    }
    
    // objetos
    else if (state == states_editor.objetos) {
        // 16 + (68 <-- sumar)
        
        // leave
        if (draw_button_gui(64, 64, 16 * sf, 16 * sf, 0, mouse_depth, c_red) == buttonState.released) {
            state = states_editor.principal;
        }
        draw_sprite(rsc_find_tex("gui_leave"), 0, 48 * sf, 48 * sf);
        
        
        // bloque
        if (draw_button_gui(64, 64, 84 * sf, 16 * sf, 0, mouse_depth, c_gray) == buttonState.released) {
            state = states_editor.objetos_bloques;
        }
        draw_sprite(rsc_find_tex("editor_object_block"), 0, 116 * sf, 48 * sf);
        
        
        // entidad
        if (draw_button_gui(64, 64, 152 * sf, 16 * sf, 0, mouse_depth, c_gray) == buttonState.released) {
            state = states_editor.objetos_entidades;
        }
        draw_sprite(rsc_find_tex("editor_object_entity"), 0, 184 * sf, 48 * sf);
        
        
        // comando
        if (draw_button_gui(64, 64, 220 * sf, 16 * sf, 0, mouse_depth, c_gray) == buttonState.released) {
            ds_map_clear(object_data);
            
            ds_map_add(object_data, "id", 1);
            ds_map_add(object_data, "sprite", "editor_object_cmd");
            ds_map_add(object_data, "command", "");
            ds_map_add(object_data, "trigger_id", []);
        }
        draw_sprite(rsc_find_tex("editor_object_cmd"), 0, 252 * sf, 48 * sf);
    }
    
    
    // bloques
    else if (state == states_editor.objetos_bloques) {
        // 16 + (68 <-- sumar)
        
        // leave
        if (draw_button_gui(64, 64, 16 * sf, 16 * sf, 0, mouse_depth, c_red) == buttonState.released) {
            state = states_editor.principal;
        }
        draw_sprite(rsc_find_tex("gui_leave"), 0, 48 * sf, 48 * sf);
        
        
        // separador
        draw_set_color(c_black);
        draw_rectangle(16 * sf, 88 * sf, ww - 16 * sf, 88 * sf, false);
        
        
        // crear botones con texturas de bloques del juego
        var bx = 48; // boton x
        var by = 96; // boton y
        
        for (var tex = 0; tex < array_length(global.lists.block); ++tex) {
            // boton de textura del bloque
            if (draw_button_gui(64, 64, bx * sf, by * sf, 0, mouse_depth, c_red) == buttonState.released) {
                ds_map_clear(object_data);
                
                ds_map_add(object_data, "id", 0);
                ds_map_add(object_data, "sprite", global.lists.block[tex]);
                ds_map_add(object_data, "trigger_id", []);
            }
            draw_sprite(rsc_find_tex("Block_" + global.lists.block[tex]), 0, (bx + 16) * sf, (by + 8) * sf);
            
            
            // sumar posicion
            if (bx * sf > ww - 128 * sf) {
                by += 68;
                bx = 48;
                continue;
            }
            
            bx += 68;
        }
    }
    
    
    // entidad
    else if (state == states_editor.objetos_entidades) {
        // 16 + (68 <-- sumar)
        
        // leave
        if (draw_button_gui(64, 64, 16 * sf, 16 * sf, 0, mouse_depth, c_red) == buttonState.released) {
            state = states_editor.principal;
        }
        draw_sprite(rsc_find_tex("gui_leave"), 0, 48 * sf, 48 * sf);
        
        
        // separador
        draw_set_color(c_black);
        draw_rectangle(16 * sf, 88 * sf, ww - 16 * sf, 88 * sf, false);
        
        
        // crear botones con entidades del juego
        var bx = 48; // boton x
        var by = 96; // boton y
        
        for (var ent = 0; ent < array_length(global.assets.entity); ++ent) {
            // boton de tipo de entidad
            if (draw_button_gui(64, 64, bx * sf, by * sf, 0, mouse_depth, c_red) == buttonState.released) {
                ds_map_clear(object_data);
                
                ds_map_add(object_data, "id", 2);
                ds_map_add(object_data, "sprite", "editor_object_entity"); 
                ds_map_add(object_data, "entity", global.assets.entity[ent].type);
                ds_map_add(object_data, "trigger_id", []);
            }
            draw_sprite(rsc_find_tex(global.assets.entity[ent].type + "_head"), 0, bx + 32, by + 32);
            
            draw_text(bx + 32, by + 56, global.assets.entity[ent].type);
            
            
            // sumar posicion
            if (bx * sf > ww - 128 * sf) {
                by += 68;
                bx = 48;
                continue;
            }
            
            bx += 68;
        }
    }
    
    
    // ====== panel de capas (layers) ======
    if (window_edit_layer.active) {
        var w_x = ww - 176 * sf;
        var w_y = hh - 128 * sf;
        var w_w = ww;
        var w_h = hh;
        
        draw_set_color(c_gray);
        draw_rectangle_outline(w_x, w_y, w_w, w_h, c_white, 3);
        
        // boton que suma la capa (layer) con la flecha izquierda
        if (draw_button_gui(64, 64, w_x + 16 * sf, w_y + 32 * sf, 3, mouse_depth, c_black) == buttonState.released) {
            layer_current = max(0, layer_current - 1);
        }
        draw_sprite(rsc_find_tex("gui_arrowL"), 0, w_x + 16 * sf, w_y + 32 * sf);
        
        // boton que resta la capa (layer) con la flecha derecha
        if (draw_button_gui(64, 64, w_x + 96 * sf, w_y + 32 * sf, 3, mouse_depth, c_black) == buttonState.released) {
            layer_current = min(200, layer_current + 1);
            
            if (layer_current >= array_length(layers)) {
                array_push(layers, ds_grid_create(width, height));
                ds_grid_clear(layers[layer_current], -1);
            }
        }
        draw_sprite(rsc_find_tex("gui_arrowR"), 0, w_x + 96 * sf, w_y + 32 * sf);
    }
    
    
    // ====== panel de edicion de objetos ======
    w_x = 64 * sf;
    w_y = 64 * sf;
    w_w = ww - 64 * sf;
    w_h = hh - 64 * sf;
    
    if (state_edit != window_type_edit.none) {
        draw_set_color(c_gray);
        draw_rectangle_outline(w_x, w_y, w_w, w_h, c_white, 2);
    }
    
    // editar objeto
    if (state_edit == window_type_edit.edit_object) {
        var bx = w_x + 8 * sf;
        var by = w_y + 72 * sf;
        
        // text: edit object
        var _obj = obj_edit.obj;
        
        draw_set_color(c_black);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_text(w_x + 8 * sf, w_y + 8 * sf, "edit object");
        
        
        // leave
        if (draw_button_gui(64, 64, bx, by, 2, mouse_depth, c_red) == buttonState.released) {
            state_edit = window_type_edit.none;
            textboxes_list = [];
            exit;
        }
        draw_sprite(rsc_find_tex("gui_leave"), 0, bx + 32 * sf, by + 32 * sf);
        
        
        draw_set_halign(fa_left);
        draw_set_valign(fa_middle);
        
        by += 68 * sf;
        
        // propiedades del objeto
        if (_obj[? "id"] == 0) { // id del bloque
            if (draw_textbox(textboxes_list[0], bx + 32, by + 32)) {
                var value = string_digits(textboxes_list[0].text);
                
                _obj[? "z"] = clamp(real((value != "") ? value : "0"), 0, 5);
                textboxes_list[0].text = "";
            }
            draw_set_color(c_black) draw_text(bx + 68, by + 32, $"z: {_obj[? "z"]}");
        }
        else if (_obj[? "id"] == 1) { // id del comando
            if (draw_textbox(textboxes_list[0], bx + 256, by + 32)) {
                _obj[? "command"] = textboxes_list[0].text;
            }
            draw_set_color(c_black) draw_text(bx + 520, by + 32, $"cmd");
        }
    }
}
else {
    var que = question_draw(question);
    
    if (is_bool(que)) {
        question = -1;
    }
}