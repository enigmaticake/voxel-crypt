#region textbox

/// @param {real} width
/// @param {real} height
/// @param {string} [text]
/// @param {real} [max_width]
/// @param {Constant.Color} [color]
function textbox_create(width, height, text = "", _max = -1, color = function(char, index, text) { return true; }) {
	return {
		width : width,
		height : height,
		text : text,
		active : false,
		mousex : 1,
		selx : -1,
		time : 0,
		timeFull : 20,
		maxText : _max,
		color : color,
		stringChar : function(char) {
			if (string_pos(char, "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_") > 0) return true;
			return false;
		}
	}
}

/// @param {struct} tb
/// @return {bool}
function textbox_step(tb, xx, yy) {
    var x1 = xx - (tb.width / 2);
	var x2 = xx + (tb.width / 2);
	var y1 = yy - (tb.height / 2) - 1;
	var y2 = yy + (tb.height / 2) - 1;
	
	var mousex = device_mouse_x_to_gui(0);
	var mousey = device_mouse_y_to_gui(0);
	
	if (point_in_rectangle(mousex, mousey, x1, y1, x2, y2)) {
		if (mouse_check_button_pressed(mb_left) and !tb.active) {
			tb.active = true;
			tb.time = 0;
            
            keyboard_string = "";
		}
		
		if (mouse_check_button_pressed(mb_left)) {
			for (var i = 1; i <= string_length(tb.text) + 1; ++i) {
				var char = string_char_at(tb.text, i);
				
				var posx = x1 + string_width(string_copy(tb.text, 1, i - 1));
				var width = string_width(char);
				
				if (mousex >= posx + 12 and mousex <= posx + width + 12) {
					tb.mousex = i;
				}
			}
			if (mousex < x1 + 12) {
				tb.mousex = 0;
			}
			
			tb.selx = -1;
		}
		if (mouse_check_button(mb_left)) {
			var pos = tb.mousex;
			
			for (var i = 1; i <= string_length(tb.text) + 1; ++i) {
				var char = string_char_at(tb.text, i);
				
				var posx = x1 + string_width(string_copy(tb.text, 1, i - 1));
				var width = string_width(char);
				
				if (mousex >= posx + 12 and mousex <= posx + width + 12) {
					pos = i;
				}
			}
			if (mousex < x1 + 12) {
				pos = 0;
			}
			
			if (pos != tb.mousex) tb.selx = pos;
		}
	}
	else if (mouse_check_button_pressed(mb_left) and tb.active) {
		tb.active = false;
		tb.time = 0;
		tb.selx = -1;
	}
	
	if (tb.active) {
			var maxChar = (tb.maxText > 0) ? tb.maxText : -1;
			
			tb.time++;
			if (tb.time > tb.timeFull * 2) tb.time = 0;
			
			var mousexPrev = tb.mousex;
			
			// Escribir con las teclas
			if (!keyboard_check_direct(vk_control) and string_length(keyboard_string) > 0 and
				string_width(tb.text) <= maxChar) {
				if (tb.selx > -1) {
					if (tb.mousex > tb.selx) {
						tb.text = string_delete(tb.text, tb.selx + 1, tb.mousex - tb.selx);
						
						tb.mousex = tb.selx;
					}
					else if (tb.mousex < tb.selx) {
						tb.text = string_delete(tb.text, tb.mousex + 1, tb.selx - tb.mousex);
					}
					
					tb.selx = -1;
				}
				
				var txt = keyboard_string;
				
				tb.text = string_insert(txt, tb.text, tb.mousex + 1);
				tb.mousex += string_length(txt);
			}
			keyboard_string = "";
			
			// Iniciar seleccion
			if (tb.selx < 0 and keyboard_check_direct(vk_shift) and (keyboard_check_pressed(vk_left) or keyboard_check_pressed(vk_right))) {
				tb.selx = tb.mousex;
			}
			else if (!keyboard_check_direct(vk_shift) and (keyboard_check_pressed(vk_left) or keyboard_check_pressed(vk_right))) {
				tb.selx = -1;
			}
			
			
			// Eliminar por caracteres
			if (tb.selx < 0 and !keyboard_check_direct(vk_control) and keyboard_check_pressed(vk_backspace) and tb.mousex > 0) {
				tb.text = string_delete(tb.text, tb.mousex, 1);
				tb.mousex --;
			}
			
			// Eliminar por palabras
			if (tb.selx < 0 and keyboard_check_direct(vk_control) and keyboard_check_pressed(vk_backspace) and tb.mousex > 0) {
				var posx = clamp(tb.mousex, 0, string_length(tb.text));
				var has_letter = false;
				
				for (var i = posx; i >= 0; --i) {
					var char = string_char_at(tb.text, i);
					
					if (!tb.stringChar(char) and has_letter) {
						break;
					}
					else if (tb.stringChar(char)) has_letter = true;
					
					tb.text = string_delete(tb.text, tb.mousex, 1);
					tb.mousex --;
				}
			}
			
			
			// Mover cursor con las flechas
			if (!keyboard_check_direct(vk_control) and keyboard_check_pressed(vk_left)) {
				tb.mousex -= 1;
			}
			else if (!keyboard_check_direct(vk_control) and keyboard_check_pressed(vk_right)) {
				tb.mousex += 1;
			}
			
			// Mover cursor por palabras con las flechas y control
			if (keyboard_check_direct(vk_control) and keyboard_check_pressed(vk_left)) {
				var posx = tb.mousex;
				var has_letter = false;
				
				for (var i = posx; i >= 0; --i) {
					var char = string_char_at(tb.text, i);
					
					if (!tb.stringChar(char) and has_letter) {
						break;
					}
					else if (tb.stringChar(char)) has_letter = true;
					
					tb.mousex --;
				}
			}
			else if (keyboard_check_direct(vk_control) and keyboard_check_pressed(vk_right)) {
				var posx = tb.mousex;
				var has_letter = false;
				
				for (var i = tb.mousex + 1; i <= string_length(tb.text); ++i) {
					var char = string_char_at(tb.text, i);
					
					if (!tb.stringChar(char) and has_letter) {
						break;
					}
					else if (tb.stringChar(char)) has_letter = true;
					
					tb.mousex ++;
				}
			}
			
			
			// Eliminar todo lo seleccionado con backspace
			if ((tb.selx >= 0 and tb.selx != tb.mousex) and keyboard_check_pressed(vk_backspace)) {
				
				if (tb.mousex > tb.selx) {
					tb.text = string_delete(tb.text, tb.selx + 1, tb.mousex - tb.selx);
					
					tb.mousex = tb.selx;
				}
				else if (tb.mousex < tb.selx) {
					tb.text = string_delete(tb.text, tb.mousex + 1, tb.selx - tb.mousex);
				}
				
				tb.selx = -1;
			}
			
			// Mover cursor al inicio o final de la seleccion
			if (!keyboard_check_direct(vk_shift) and tb.selx >= 0 and keyboard_check_pressed(vk_right)) {
				if (tb.mousex < tb.selx) {
					tb.mousex = tb.selx;
				}
				else if (tb.mousex > tb.selx) tb.mousex --;
			}
			else if (!keyboard_check_direct(vk_shift) and tb.selx >= 0 and keyboard_check_pressed(vk_left)) {
				if (tb.mousex > tb.selx) {
					tb.mousex = tb.selx;
				}
				else if (tb.mousex < tb.selx) tb.mousex ++;
			}
			
			
			// Deseleccionar cuadro de texto y retornar
			if (keyboard_check_pressed(vk_enter)) {
				tb.active = false;
				tb.selx = -1;
				
				return true;
			}
			
			
			// Limitar texto
			if (tb.maxText > 0 and string_width(tb.text) > tb.maxText) {
				for (var i = string_length(tb.text); i >= 1; --i) {
					if (string_width(tb.text) <= tb.maxText) break;
					
					tb.text = string_delete(tb.text, i, 1);
				}
			}
			
			
			// Limitar el cursor
			tb.mousex = clamp(tb.mousex, 0, string_length(tb.text));
		}
}

/// @param {struct} tb
function textbox_draw(tb, xx, yy) {
	var x1 = xx - (tb.width / 2);
	var x2 = xx + (tb.width / 2);
	var y1 = yy - (tb.height / 2) - 1;
	var y2 = yy + (tb.height / 2) - 1;
	
	var mousex = device_mouse_x_to_gui(0);
	var mousey = device_mouse_y_to_gui(0);
	
	// Dibujar cuadro de texto
	draw_set_alpha(0.5);
	draw_set_color(c_black);
	draw_rectangle(x1, y1, x2, y2, false);
	
	draw_set_alpha(1);
	
	if (tb.active) draw_set_color(c_white);
	for (var i = 0; i <= 3; ++i) draw_rectangle(x1 + i, y1 + i, x2 - i, y2 - i, true);
	
	// Dibujar seleccion
	if (tb.selx >= 0 and tb.active) {
		var width = x1 + string_width(string_copy(tb.text, 1, tb.selx)) + 8;
		var widthEnd = x1 + string_width(string_copy(tb.text, 1, tb.mousex)) + 8;
		draw_set_alpha(0.5);
		draw_set_color(c_aqua);
		draw_rectangle(width, yy + 8, widthEnd, yy - 8, false);
		
		draw_set_alpha(1);
	}
	
	draw_set_halign(fa_left);
	draw_set_valign(fa_middle);
	draw_text_vip(tb.text, x1 + 8, yy, tb.color);
	
	// Dibujar linea del mouse
	if (tb.time < tb.timeFull and tb.active) {
		var width = x1 + string_width(string_copy(tb.text, 1, tb.mousex)) + 8;
	
		draw_set_color(c_white);
		draw_rectangle(width, yy + 8, width + 1, yy - 8, false);
	}
}


function draw_textbox(tb, xx, yy) {
    textbox_draw(tb, xx, yy);
    if (textbox_step(tb, xx, yy)) {
        return true;
    }
}

#endregion


#region question

/// @param {string} descripcion
/// @param {function} accept
/// @param {function} cancel
function question_create(_desc, _acc, _can) {
	return {
		text : _desc,
		accept : _acc,
		cancel : _can,
		color_bg : #101010
	}
}

/// @desc Se retornara true si fue Accept, false si fue Cancel.
/// @param {struct} question
/// @return {bool} hola xd
function question_draw(_question) {
	var sf = scale_factor();
	
	var ww, hh;
	
	// posicion y tamaño
	ww = display_get_gui_width();
	hh = display_get_gui_height();
	
	draw_set_color(_question.color_bg);
	draw_rectangle(0, 0, ww, hh, false);
	
	
	// a dibujar
	var xx;
	
	draw_text_vip(_question.text, ww * 0.1, hh * 0.1, function(char, index, text){
		if (string_pos(char, "()[]{}\"'#") > 0) return c_gray;
		else if (string_pos(char, "$") > 0) return c_lime;
		
		return #F0F0F0;
	},
	ww * 0.75);
	
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	
	// aceptar
	xx = clamp(ww * 0.2, 128, ww - 128);
	if (draw_button_v("256x64", xx, hh - 32, c_gray, 1) == buttonState.released) {
		_question.accept();
		return true;
	}
	draw_text(xx, hh - 32, "accept");
	// negar
	xx = clamp(ww * 0.8, 128, ww - 128);
	if (draw_button_v("256x64", xx, hh - 32, c_gray, 1) == buttonState.released) {
		_question.cancel();
		return false;
	}
	draw_text(xx, hh - 32, "cancel");
	
	return -1;
}

#endregion


/// @desc Formato del resolution es por ejemplo: "128x64", "64x64". tipos: 0 = normal, 1 = invisible, 2 = outline
/// @param {string} resolution
/// @param {real} x
/// @param {real} y
/// @param {Constant.Color} color
function draw_button_v(resolution, xx, yy, _color = c_gray, _type = 0) {
    var sf = scale_factor();
    
	var spr = rsc_find_tex("Outline" + resolution);
	if (spr == -1) return;
	
	var scalex = sprite_get_width(spr);
	var scaley = sprite_get_height(spr);
	
	var x1 = xx - ((scalex * sf / 2) - 2);
	var x2 = xx + ((scalex * sf / 2) - 2);
	var y1 = yy - ((scaley * sf / 2) - 2);
	var y2 = yy + ((scaley * sf / 2) - 2);
	
	var mousex = device_mouse_x_to_gui(0);
	var mousey = device_mouse_y_to_gui(0);
	
	
	// Variable
	var stateToReturn = buttonState.none;
	
	var inMouse = point_in_rectangle(mousex, mousey, x1, y1, x2, y2);
	var TypeGroup0 = _type >= 1 and _type <= 2;
	
	
	// Funcion del boton
	var color = _color;
	if (inMouse) {
		color = merge_color(_color, c_black, 0.5);
		
		if (mouse_check_button_pressed(mb_left)) {
			var snd = rsc_find_snd("sndClickUI");
			
			if (snd != -1) audio_play_sound(snd, 0, false);
			
			stateToReturn = buttonState.pressed;
		}
		else if (mouse_check_button(mb_left)) {
			color = c_lime;
			stateToReturn = buttonState.hold;
		}
		else if (mouse_check_button_released(mb_left)) {
			stateToReturn = buttonState.released;
		}
	}
	
	if (TypeGroup0 and !inMouse) {
		draw_set_alpha(0);
	}
	else if (TypeGroup0 and inMouse) {
		draw_set_color(c_white);
		draw_set_alpha(0.5);
	}
	
	
	// Visual del boton
	draw_set_color(color);
	draw_rectangle(x1, y1, x2, y2, false);
	draw_set_alpha(1);
	
	draw_set_color(c_white);
	if (_type == 2) draw_rectangle(x1, y1, x2, y2, true);
	
	if (_type == 0) draw_sprite(spr, 0, xx, yy);
	
	return stateToReturn;
}


/**
 * @param {real} scalex
 * @param {real} scaley
 * @param {real} xx
 * @param {real} yy
 * @param {real} depth
 * @param {real} mouse_depth
 * @param {Constant.Color} [_color]
 * @returns {real}
 */
function draw_button_gui(scalex, scaley, xx, yy, depth, mouse_depth, _color = c_gray) {
    var sf = scale_factor();
    
    // Offset (arriba, izquierda)
    var x1 = xx;
	var x2 = xx + (scalex * sf);
	var y1 = yy;
	var y2 = yy + (scaley * sf);
    
    // Color del boton
    var color0 = c_black;
    var color1 = _color;
    
    // Posicion mouse
    var mousex = device_mouse_x_to_gui(0);
	var mousey = device_mouse_y_to_gui(0);
    
    // Colicion de mouse
	var mousein = point_in_rectangle(mousex, mousey, x1 + 2, y1 + 2, x2, y2);
    
    var result = buttonState.none;
    
    
    // Funcion
    if (mousein and mouse_depth == depth) {
        result = buttonState.in;
        
        if (mouse_check_button_pressed(mb_left)) {
            result = buttonState.pressed;
        }
        else if (mouse_check_button(mb_left)) {
            result = buttonState.hold;
        }
        else if (mouse_check_button_released(mb_left)) {
            result = buttonState.released;
        }
    }
    
    
    // Camibar color segun el estado del boton
    if (result == buttonState.none) {
        color0 = #000000;
    }
    else if (result == buttonState.in) {
        color0 = #000000;
        color1 = #ffffff;
    }
    else if (result == buttonState.hold) {
        color0 = #434343;
        color1 = #9fff00;
    }
    
    
    // Dibujar boton
    draw_set_color(color0);
    draw_rectangle_outline(x1, y1, x2, y2, color1, 2);
    
    return result;
}






