function scrFile(file_path){
	var text = "";
	
	if (file_exists(file_path)) {
	    var file = file_text_open_read(file_path); // Abre el archivo en modo lectura

	    while (!file_text_eof(file)) { // Mientras no llegue al final del archivo
	        var line = file_text_read_string(file); // Lee una línea
	        file_text_readln(file); // Pasa a la siguiente línea
	        text += line + "\n"; // Muestra la línea en la consola
	    }

	    file_text_close(file); // Cierra el archivo
	}
	else {
		show_message($"Error loading a text file.\nPath: {file_path}");
	    return "";
	}
	
	return text;
}


function file_save_string(fname, str) {
	var file = file_text_open_write(fname);
	
	file_text_write_string(file, str);
	
	file_text_close(file);
}


/// @param {string} msg Mensaje de log
function log_to_file(_msg) {
    var path = "log" + string(global.assets.conf.log_number) +  ".txt";
    
    var log = "";
    if (file_exists(path)) {
        log += scrFile(path);
    }
    
    var time = string(current_hour) + " - " + string(current_minute) + " - " + string(current_second);
    file_save_string(path, log + "[" + time + "] " + _msg + "\n");
}


/// @param {string} str
/// @return {bool}
function EsNumero(str) {
    var len = string_length(str);
    if (len == 0) return false; // No puede estar vacío

    var tiene_punto = false;
    var tiene_signo = false;

    for (var i = 1; i <= len; i++) {
        var c = string_char_at(str, i);

        if (c == "-") {
            if (i != 1) return false; // El signo '-' solo puede estar al inicio
            tiene_signo = true;
        }
        else if (c == ".") {
            if (tiene_punto) return false; // No puede haber más de un punto
            tiene_punto = true;
        }
        else if (string_digits(c) != c) {
            return false; // Si no es dígito, no es un número válido
        }
    }

    return true; // Si pasó todas las validaciones, es un número
}


/// @param {string} text
/// @param {real} x
/// @param {real} y
/// @param {function} color
function draw_text_vip(text, _x, _y, color = function(_char, index, text){return c_white}, width = -1) {
	var _xstart = _x;
	for (var i = 1; i <= string_length(text); ++i) {
		var char = string_char_at(text, i);
		
		if (width != -1 and _x > width + _xstart) {
			_x = _xstart;
			_y += string_height("a") + 2;
		}
		
		draw_set_color(color(string(char), real(i), string(text)));
		draw_text_gui(_x, _y, char, fa_left, fa_middle);
		
		_x += string_width(char) * scale_factor();
	}
}


function scale_factor() {
	var dpi = display_get_dpi_x();
	var base_dpi = 96; // DPI estándar
	
	var result = dpi / base_dpi;
	
	return result * global.assets.conf.scale_ui;
}


/// @param {real} x
/// @param {real} y
function Vector2(_x, _y) constructor {
    x = _x;
    y = _y;

    add = function(v) {
        x += v;
        y += v;
        return self;
    };
    
    subtract = function(v) {
        x -= v;
        y -= v;
        return self;
    }
    
    multiply = function(v) {
        x *= v;
        y *= v;
        return self;
    }
    
    copy = function() {
        return new Vector2(x, y);
    }
    
    toString = function() {
        return "(" + string(x) + ", " + string(y) + ")";
    };
}

/// @param {real} x
/// @param {real} y
/// @param {real} angle
function Vec2r(xx, yy, r) constructor {
    x = xx;
    y = yy;
    angle = r;
    
    add = function(v) {
        x += v;
        y += v;
        return self;
    };
    
    subtract = function(v) {
        x -= v;
        y -= v;
        return self;
    }
    
    multiply = function(v) {
        x *= v;
        y *= v;
        return self;
    }
    
    copy = function() {
        return new Vec2r(x, y, angle);
    }
    
    toString = function() {
        return "(" + string(x) + ", " + string(y) + ")";
    };
}
