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
    
    // principal
    if (state == states_editor.principal) {
        if (draw_button_gui(64, 64, 16 * sf, 16 * sf, 0, mouse_depth, c_lime) == buttonState.released) {
            state = states_editor.objetos;
        }
        draw_sprite(rsc_find_tex("create_levelEditor"), 0, 48, 48);
        
        if (draw_button_gui(64, 64, ww - 80 * sf, 16 * sf, 0, mouse_depth, c_gray) == buttonState.released) {
            state = states_editor.configuration;
        }
        draw_sprite(rsc_find_tex("gui_config"), 0, ww - 48, 48);
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
        draw_sprite(rsc_find_tex("editor_object_entity"), 0, 252 * sf, 48 * sf);
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
            draw_sprite(rsc_find_tex(global.assets.entity[ent].sprite + "_head"), 0, bx, by);
            
            draw_text(bx, by, global.assets.entity[ent].type);
            
            
            // sumar posicion
            if (bx * sf > ww - 128 * sf) {
                by += 68;
                bx = 48;
                continue;
            }
            
            bx += 68;
        }
    }
    
    
    // ====== ventanas de edicion ======
    var w_x = 64 * sf;
    var w_y = 64 * sf;
    var w_w = ww - 64 * sf;
    var w_h = hh - 64 * sf;
    
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
        }
        draw_sprite(rsc_find_tex("gui_leave"), 0, bx + 32 * sf, by + 32 * sf);
        
        
        draw_set_halign(fa_left);
        draw_set_valign(fa_middle);
        
        by += 68 * sf;
        
        // propiedades del objeto
        if (draw_textbox(textboxes_list[0], bx + 32, by + 32)) {
            var value = string_digits(textboxes_list[0].text);
            
            _obj[? "z"] = real((value != "") ? value : "0");
            textboxes_list[0].text = "";
        }
        draw_set_color(c_black) draw_text(bx + 68, by + 32, $"z: {_obj[? "z"]}");
    }
}
else {
    var que = question_draw(question);
    
    if (que == false or que == true) {
        question = -1;
    }
}