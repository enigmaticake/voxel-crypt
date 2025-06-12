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
    draw_rectangle_outline(0, 0, ww, height_window_principal, (mouse_depth == 0) ? c_white : c_dkgray, 3);
    
    
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
        draw_sprite_ext(rsc_find_tex("create_levelEditor"), 0, 48 * sf, 48 * sf, sf, sf, 0, c_white, 1);
        
        // boton de capas (layers)
        if (draw_button_gui(64, 64, 96 * sf, 16 * sf, 0, mouse_depth, c_gray) == buttonState.released) {
            window_edit_layer.active = !window_edit_layer.active;
        }
        draw_sprite_ext(rsc_find_tex("gui_layer_cape"), 0, 96 * sf, 16 * sf, sf, sf, 0, c_white, 1);
        
        // boton de configuracion
        if (draw_button_gui(64, 64, ww - 80 * sf, 16 * sf, 0, mouse_depth, c_gray) == buttonState.released) {
            state = states_editor.configuration;
        }
        draw_sprite_ext(rsc_find_tex("gui_config"), 0, ww - 48 * sf, 48 * sf, sf, sf, 0, c_white, 1);
        
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
            draw_sprite_ext(rsc_find_tex("gui_arrowR"), 0, ww - 192 * sf, 16 * sf, sf, sf, 0, c_white, 1);
            
            // texto que muestra el valor de posy_global actual
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_set_color(c_white);
            draw_text_transformed(ww - 240 * sf, 48 * sf, posy_global, 2, 2, 0);
            
            // boton que resta el posy_global con flecha izquierda
            if (draw_button_gui(64, 64, ww - 352 * sf, 16 * sf, 0, mouse_depth, c_black) == buttonState.released) {
                posy_global = max(0, posy_global - 1);
            }
            draw_sprite_ext(rsc_find_tex("gui_arrowL"), 0, ww - 352 * sf, 16 * sf, sf, sf, 0, c_white, 1);
        }
    }
    
    // configuracion
    else if (state == states_editor.configuration) {
        var bx = 16 * sf;
        var by = 16 * sf;
        
        var create_button = function(xx, yy) {
            var bt = draw_button_gui(64, 64, xx, yy, 0, mouse_depth, c_gray) == buttonState.released;
            
            return bt;
        }
        
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        
        // salida
        if (create_button(32 * sf, 32 * sf)) {
            state = states_editor.principal;
        }
        draw_sprite_ext(rsc_find_tex("gui_leave"), 0, 64 * sf, 64 * sf, sf, sf, 0, c_white, 1);
        draw_text_gui(98 * sf, 64 * sf, "Exit", fa_left, fa_middle, #ff7f7f);
        
        
        // dia o noche
        if (create_button(32 * sf, 96 * sf)) {
            time_day = !time_day;
        }
        var spr = (time_day) ? rsc_find_tex("editor/sun") : rsc_find_tex("editor/moon");
        draw_sprite_ext(spr, 0, 32 * sf, 96 * sf, sf, sf, 0, c_white, 1);
        draw_text_gui(98 * sf, 128 * sf, $"Time: {time_day ? "day" : "night"}", fa_left, fa_middle, #d3d3d3);
    }
    
    // objetos
    else if (state == states_editor.objetos) {
        // 16 + (68 <-- sumar)
        
        // leave
        if (draw_button_gui(64, 64, 16 * sf, 16 * sf, 0, mouse_depth, c_red) == buttonState.released) {
            state = states_editor.principal;
        }
        draw_sprite_ext(rsc_find_tex("gui_leave"), 0, 48 * sf, 48 * sf, sf, sf, 0, c_white, 1);
        
        
        // bloque
        if (draw_button_gui(64, 64, 84 * sf, 16 * sf, 0, mouse_depth, c_gray) == buttonState.released) {
            state = states_editor.objetos_bloques;
        }
        draw_sprite_ext(rsc_find_tex("editor_object_block"), 0, 116 * sf, 48 * sf, sf, sf, 0, c_white, 1);
        
        
        // entidad
        if (draw_button_gui(64, 64, 152 * sf, 16 * sf, 0, mouse_depth, c_gray) == buttonState.released) {
            state = states_editor.objetos_entidades;
        }
        draw_sprite_ext(rsc_find_tex("editor_object_entity"), 0, 184 * sf, 48 * sf, sf, sf, 0, c_white, 1);
        
        
        // comando
        if (draw_button_gui(64, 64, 220 * sf, 16 * sf, 0, mouse_depth, c_gray) == buttonState.released) {
            ds_map_clear(object_data);
            
            ds_map_add(object_data, "id", 1);
            ds_map_add(object_data, "sprite", "editor_object_cmd");
            ds_map_add(object_data, "path_cmd", "tu_caca.json");
            ds_map_add(object_data, "destroy", true);
            ds_map_add(object_data, "trigger_id", []);
        }
        draw_sprite_ext(rsc_find_tex("editor_object_cmd"), 0, 252 * sf, 48 * sf, sf, sf, 0, c_white, 1);
        
        
        // cofre
        if (draw_button_gui(64, 64, 288 * sf, 16 * sf, 0, mouse_depth, c_gray) == buttonState.released) {
            ds_map_clear(object_data);
            
            ds_map_add(object_data, "id", 3);
            ds_map_add(object_data, "sprite", "chest/normal");
            ds_map_add(object_data, "type_chest", "normal");
            ds_map_add(object_data, "content", [24, 6]);
            ds_map_add(object_data, "trigger_id", []);
        }
        draw_sprite_ext(rsc_find_tex("chest/normal"), 0, 304 * sf, 24 * sf, sf, sf, 0, c_white, 1);
        
        
        // punto de inicio
        if (draw_button_gui(64, 64, 356 * sf, 16 * sf, 0, mouse_depth, c_gray) == buttonState.released) {
            ds_map_clear(object_data);
            
            ds_map_add(object_data, "id", 4);
            ds_map_add(object_data, "sprite", "editor_object_startpoint");
            ds_map_add(object_data, "trigger_id", []);
        }
        draw_sprite_ext(rsc_find_tex("editor_object_startpoint"), 0, 356 * sf, 24 * sf, sf, sf, 0, c_white, 1);
    }
    
    
    // bloques
    else if (state == states_editor.objetos_bloques) {
        // 16 + (68 <-- sumar)
        
        // leave
        if (draw_button_gui(64, 64, 16 * sf, 16 * sf, 0, mouse_depth, c_red) == buttonState.released) {
            state = states_editor.principal;
        }
        draw_sprite_ext(rsc_find_tex("gui_leave"), 0, 48 * sf, 48 * sf, sf, sf, 0, c_white, 1);
        
        
        // separador
        draw_set_color(c_black);
        draw_rectangle(16 * sf, 88 * sf, ww - 16 * sf, 88 * sf, false);
        
        
        // crear botones con texturas de bloques del juego
        var bx = 48 * sf; // boton x
        var by = 96 * sf; // boton y
        
        for (var tex = 0; tex < array_length(global.lists.block); ++tex) {
            // boton de textura del bloque
            if (draw_button_gui(64, 64, bx * sf, by * sf, 0, mouse_depth, c_red) == buttonState.released) {
                ds_map_clear(object_data);
                
                ds_map_add(object_data, "id", 0);
                ds_map_add(object_data, "sprite", global.lists.block[tex]);
                ds_map_add(object_data, "trigger_id", []);
            }
            draw_sprite_ext(rsc_find_tex("block/" + global.lists.block[tex]), 0, (bx + 16) * sf, (by + 8) * sf, sf, sf, 0, c_white, 1);
            
            
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
        draw_sprite_ext(rsc_find_tex("gui_leave"), 0, 48 * sf, 48 * sf, sf, sf, 0, c_white, 1);
        
        
        // separador
        draw_set_color(c_black);
        draw_rectangle(16 * sf, 88 * sf, (ww - 16) * sf, 88 * sf, false);
        
        
        // crear botones con entidades del juego
        var bx = 48 * sf; // boton x
        var by = 96 * sf; // boton y
        
        for (var ent = 0; ent < array_length(global.assets.entity); ++ent) {
            // boton de tipo de entidad
            if (draw_button_gui(64, 64, bx * sf, by * sf, 0, mouse_depth, c_red) == buttonState.released) {
                ds_map_clear(object_data);
                
                ds_map_add(object_data, "id", 2);
                ds_map_add(object_data, "sprite", "editor_object_entity"); 
                ds_map_add(object_data, "entity", global.assets.entity[ent].type);
                ds_map_add(object_data, "trigger_id", []);
            }
            draw_sprite_ext(rsc_find_tex(global.assets.entity[ent].type + "_head"), 0, (bx + 32) * sf, (by + 32) * sf, sf, sf, 0, c_white, 1);
            
            draw_text((bx + 32) * sf, (by + 56) * sf, global.assets.entity[ent].type);
            
            
            // sumar posicion
            if (bx * sf > (ww - 128 * sf) * sf) {
                by += 68 * sf;
                bx = 48 * sf;
                continue;
            }
            
            bx += 68 * sf;
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
        draw_sprite_ext(rsc_find_tex("gui_arrowL"), 0, w_x + 16 * sf, w_y + 32 * sf, sf, sf, 0, c_white, 1);
        
        // boton que resta la capa (layer) con la flecha derecha
        if (draw_button_gui(64, 64, w_x + 96 * sf, w_y + 32 * sf, 3, mouse_depth, c_black) == buttonState.released) {
            layer_current = min(200, layer_current + 1);
            
            if (layer_current >= array_length(layers)) {
                array_push(layers, ds_grid_create(width, height));
                ds_grid_clear(layers[layer_current], -1);
            }
        }
        draw_sprite_ext(rsc_find_tex("gui_arrowR"), 0, w_x + 96 * sf, w_y + 32 * sf, sf, sf, 0, c_white, 1);
    }
    
    
    // ====== panel de edicion de objetos ======
if (state_edit != window_type_edit.none) {
        draw_set_color(c_black);
        draw_set_alpha(0.5);
        draw_rectangle(0, 0, ww, hh, false);
        
        draw_set_alpha(1);
    }
    
    // editar objeto
    if (state_edit == window_type_edit.edit_object) {
        var bx = 8 * sf;
        var by = 32 * sf;
        
        // text: edit object
        var _obj = obj_edit.obj;
        
        draw_text_gui(8 * sf, 8 * sf, "Object's propierties.", fa_left, fa_top, c_white);
        
        
        // leave
        if (draw_button_gui(64, 64, bx, by, 2, mouse_depth, c_red) == buttonState.released) {
            state_edit = window_type_edit.none;
            windowObjectEdit.buttons_list = [];
            exit;
        }
        draw_sprite_ext(rsc_find_tex("gui_leave"), 0, bx + 32 * sf, by + 32 * sf, sf, sf, 0, c_white, 1);
        
        
        draw_set_halign(fa_left);
        draw_set_valign(fa_middle);
        
        by += 104 * sf;
        
        // propiedades
        var textboxF = function(buttons, xx, yy, obj) {
            textbox_draw(buttons.textbox, xx, yy);
            if (textbox_step(buttons.textbox, xx, yy)) {
                var value = buttons.textbox.text;
                
                switch (buttons.type) {
                	case VarType.float:
                        value = (EsNumero(value)) ? real(value) : 0.0;
                    break;
                    
                	case VarType.int:
                        value = (EsNumero(value)) ? int64(real(value)) : int64(0);
                    break;
                    
                	case VarType.string:
                        value = string(value);
                    break;
                    
                	case VarType.bool:
                        value = (EsNumero(value)) ? bool(value) : 0;
                    break;
                }
                
                ds_map_set(obj, buttons.name, value);
                buttons.textbox.text = string(value);
            }
        }
        
        var surf = surface_create(ww, hh);
        surface_set_target(surf);
        draw_clear_alpha(c_black, 0);
        
        for (var i = 0; i < array_length(windowObjectEdit.buttons_list); ++i) {
            var button = windowObjectEdit.buttons_list[i]
            
            if (button.type == VarType.menu_panel) {
                draw_button_gui(64, 64, bx, by - 32*scale_factor() + windowObjectEdit.buttony, 4, mouse_depth, c_white);
                draw_text_gui(bx + 72*sf, by + windowObjectEdit.buttony, button.name + " (menu)", fa_left, fa_middle, c_yellow);
            }
            else {
                button.textbox.active = (mouse_depth != 4) ? false : button.textbox.active;
                textboxF(button, bx + (button.textbox.width / 2), by + windowObjectEdit.buttony, _obj);
                draw_text_gui(bx + (button.textbox.width + 8), by + windowObjectEdit.buttony, button.name, fa_left, fa_middle, c_white);
            }
            
            by += 68 * sf;
        }
        surface_reset_target();
        
        // Dibujar surface desplazada dentro del recorte
        draw_surface_part(surf, 0, 98 * sf, ww, hh, 0, 98 * sf);
        
        surface_free(surf);
    }
}
else {
    var que = question_draw(question);
    
    if (is_bool(que)) {
        question = -1;
    }
}