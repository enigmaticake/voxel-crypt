if (!is_struct(question)) {
    var sf = scale_factor();

	var color_BG = #1e1e1e;
	var color_txt = #f0f0f0;

	var ww, hh;

	// Posicion y tamaño
	ww = display_get_gui_width();
	hh = display_get_gui_height();
    
    if (state == states.menu) {
        draw_set_color(color_BG);
    	draw_rectangle(0, 0, ww, hh, false);
    
    	var bx = ww / 2;
    	var by = hh / 2 - ((array_length(button) * 64*sf) / 2);
        
    	for (var i = 0; i < array_length(button); ++i) {
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
    		if (draw_button_v("256x64", bx, by, #333333) == buttonState.released) {
    			buttonf[i]();
    		}
            draw_set_color(color_txt);
    		draw_text_gui(bx, by, button[i]);
    	
    		by += 64 * sf;
    	}
    }
    else if (state == states.option) {
        draw_set_color(#1e1e1e);
        draw_rectangle(0, 0, ww, hh, false);
        
        if (draw_button_v("64x64", 32 * sf, 32 * sf, c_gray, 2) == buttonState.released) {
            state = states.menu;
        }
        draw_sprite_ext(rsc_find_tex("gui_leave"), 0, 32 * sf, 32 * sf, sf, sf, 0, c_white, 1);
    }
    else if (state == states.editor) {
        draw_set_color(#1e1e1e);
        draw_rectangle(0, 0, ww, hh, false);
        
        // mouse
        if (device_mouse_y_to_gui(0) <= 64*sf) mouse_depth = 1;
        else mouse_depth = 0;
        
        // niveles
        for (var i = 0; i < array_length(level_editor); ++i) {
            var lvl = level_editor[i];
            
            var yy = (i * (68*sf)) + (64*sf);
            
            draw_set_halign(fa_left);
            draw_set_valign(fa_middle);
            
            if (draw_button_gui(ww/sf - 64, 64, 0, yy, 0, mouse_depth, c_black) == buttonState.released) {
                // ruta no valido
                if (string_length(lvl.path) <= 0) {
                    var _count = 0; // cantidad de niveles
                    
                    // poner ruta de archivo unico
                    while (file_exists("editor/unnamed" + string(_count))) {
                        _count ++;
                    }
                    
                    lvl.path = "editor/unnamed" + string(_count);
                }
                
                // crear mapa
                if (!file_exists(lvl.path + "/map.vxdata")) {
                    guardar_objetos([], lvl.path + "/map.vxdata");
                }
                
                // crear configuracion del editor
                if (!file_exists(lvl.path + "/editor.vxdata")) {
                    var buff = buffer_create(1024, buffer_grow, 1);
                    
                    
                    // formato de archivo
                    buffer_write(buff, buffer_string, "7560DDF87554D2D5FB0C1F10F1C993A26D800FC9");
                    
                    
                    // version
                    buffer_write(buff, buffer_u16, versionMajor);
                    buffer_write(buff, buffer_u8, versionMinor);
                    buffer_write(buff, buffer_u8, versionPatch);
                    
                    
                    // camara
                    buffer_write(buff, buffer_u16, 4160); // x
                    buffer_write(buff, buffer_u16, 4416); // y
                    
                    
                    // guardar archivo binario
                    buffer_save(buff, lvl.path + "/editor.vxdata");
                    
                    buffer_delete(buff);
                }
                
                // crear configuraciones del nivel
                if (!file_exists(lvl.path + "/conf.vxdata")) {
                    var buff = buffer_create(1024, buffer_grow, 1);
                    
                    
                    // formato de archivo
                    buffer_write(buff, buffer_string, "level_conf");
                    
                    
                    // version
                    buffer_write(buff, buffer_u16, versionMajor);
                    buffer_write(buff, buffer_u8, versionMinor);
                    buffer_write(buff, buffer_u8, versionPatch);
                    
                    
                    // dia
                    buffer_write(buff, buffer_bool, true);
                    
                    
                    // guardar archivo binario
                    buffer_save(buff, lvl.path + "/conf.vxdata");
                    
                    buffer_delete(buff);
                }
                
                // iniciar nivel
                global.assets.conf.level_path = lvl.path;
                global.assets.conf.level_type = 1;
                room_goto(rmEditor);
            }
            draw_set_color(c_white);
            draw_text_gui(8*sf, yy + (32*sf), lvl.name);
        }
        
        // regresar
        if (draw_button_v("64x64", 32 * sf, 32 * sf, c_gray, 0) == buttonState.released) {
            state = states.menu;
        }
        draw_sprite_ext(rsc_find_tex("gui_leave"), 0, 32 * sf, 32 * sf, sf, sf, 0, c_white, 1);
        
        // recargar niveles de editor
        if (draw_button_v("64x64", 96 * sf, 32 * sf, c_gray, 0) == buttonState.released) {
            reload_lvleditor();
        }
        
        // recargar niveles de editor
        if (draw_button_v("64x64", 160 * sf, 32 * sf, c_lime, 0) == buttonState.released) {
            directory_create(working_directory + "editor");
            directory_create(working_directory + "editor/Mi_A3");
        }
        
        // limitar posicion y de los niveles
        level_posy = min(((array_length(level_editor) - 1) * 67*sf), level_posy);
    }
    else if (state == states.level) {
        draw_set_color(#1e1e1e);
        draw_rectangle(0, 0, ww, hh, false);
        
        // mouse
        if (device_mouse_y_to_gui(0) <= 64*sf) mouse_depth = 1;
        else mouse_depth = 0;
        
        // niveles
        var yy = 66*sf - level_posy;
        for (var i = 0; i < array_length(level_story); ++i) {
            var lvl = level_story[i];
            
            draw_set_halign(fa_left);
            draw_set_valign(fa_middle);
            
            if (draw_button_gui(ww - 64*sf, 64*sf, 0, yy, 0, mouse_depth, c_black) == buttonState.released) {
                // ruta no valido
                if (string_length(lvl.path) <= 0) {
                    var _count = 0; // cantidad de niveles
                    
                    // poner ruta de archivo unico
                    while (file_exists("editor/unnamed" + string(_count))) {
                        _count ++;
                    }
                    
                    lvl.path = "editor/unnamed" + string(_count);
                }
                
                // verificar mapa y configuracion
                if (file_exists(lvl.path + "/conf.dat") and file_exists(lvl.path + "/map.vxdata")) {
                    // iniciar nivel
                    global.assets.conf.level_path = lvl.path;
                    global.assets.conf.level_type = 0;
                    room_goto(rmLevel);
                }
                else show_message("ups");
            }
                
            if (lvl.icon != -1) draw_sprite_part_ext(lvl.icon, 0, 0, 0, 64, 64, 0, yy, sf, sf, c_white, 1);
            draw_set_color(c_white);
            draw_text_gui(72*sf, yy + 32*sf, lvl.name);
            
            yy += 67*sf;
        }
        
        // rectangulo
        draw_set_color(c_ltgray);
        draw_rectangle(0, 0, ww, 64*sf, false);
        
        // regresar
        if (draw_button_v("64x64", 32*sf, 32*sf, c_gray, 0) == buttonState.released) {
            state = states.menu;
        }
        draw_sprite_ext(rsc_find_tex("gui_leave"), 0, 32*sf, 32*sf, sf, sf, 0, c_white, 1);
    }
} 

if (is_struct(question)) {
	var qs = question_draw(question);
	
	if (qs != -1) {
		question = -1;
    }
}