global.paused = false;


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
    
    var file_level = file_find_first("editor/*.", fa_directory);
    while (file_level != "") {
        array_push(level_editor, {name:file_level,path:"editor/" + file_level});
        
        file_level = file_find_next();
    }
}
function reload_lvlstory() {
    level_story = [];
    
    var file_level = file_find_first("main/lvl/*.", fa_directory);
    while (file_level != "") {
        var _spr = sprite_add("main/lvl/" + file_level + "/icon.png", 0, false, false, 0, 0);
        
        array_push(level_story, {name:file_level,path:"main/lvl/" + file_level,icon:_spr});
        
        file_level = file_find_next();
    }
}


// Menu de inicios
button = [ "play", "option", "editor", "leave" ]; // Array de nombres

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