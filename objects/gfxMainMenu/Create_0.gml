display_set_gui_maximize();


// Pagina de menu
enum states {
    menu,
    level,
    option,
    editor
}
state = states.menu;


// niveles
level_posy = 0;

level_story = [];
level_editor = [];

function reload_lvleditor() {
    level_editor = [];
    
    var file_level = file_find_first(working_directory + "editor/*.", fa_directory);
    while (file_level != "") {
        array_push(level_editor, {name:file_level,path:"editor/" + file_level});
        
        file_level = file_find_next();
    }
    
    file_find_close();
}
function reload_lvlstory() {
    level_story = [];
    
    var file_level = file_find_first(working_directory + "main/lvl/*.", fa_directory);
    while (file_level != "") {
        var _spr = sprite_add("main/lvl/" + file_level + "/icon.png", 0, false, false, 0, 0);
        
        array_push(level_story, {name:file_level,path:"main/lvl/" + file_level,icon:_spr});
        
        file_level = file_find_next();
    }
    
    file_find_close();
}


// Menu de inicios
function ButtonToggle(_x, _y, _active) constructor {
    x = _x;
    y = _y;
    w = 64 * scale_factor();
    h = 64 * scale_factor();
    active = _active;
    
    draw = function() {
        draw_set_color((active) ? c_lime : c_red);
        draw_rectangle_outline(x, y, x + w, y + h, c_black, 2);
    };
    
    on_click = function() {
        var ClickUI = rsc_find_snd("sndClickUI")
        if (ClickUI != -1) audio_play_sound(ClickUI, 0, false);
        
        return (point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), x, y, x + w, y + h)
                and mouse_check_button_pressed(mb_left));
    };
}

button = [ "play", "option", "editor", "leave" ]; // Array de nombres
button_option = [
    new ButtonToggle(0, 64 * scale_factor(), window_get_fullscreen()),
    textbox_create(64*scale_factor(), 64*scale_factor(), global.assets.conf.scale_ui, 60, function(a, b, c){return c_white;})
]

buttonf = [ // Array de funciones
	function() {
        level_posy = 0;
        reload_lvlstory();
		state = states.level;
	},
	function() {
		state = states.option;
	},
	function() {
        level_posy = 0
        reload_lvleditor();
        state = states.editor
	},
	function() {
		question = question_create("Do you leave?", function(){game_end();}, function(){});
	}
]

question = -1; // Mensaje de preguntas


// Cambiar Cursor
window_set_cursor(cr_none);
cursor_sprite = rsc_find_tex("cursor_idle");
mouse_depth = 0;