draw_set_font(fnt_pixel);

if (!file_exists("save/config.properties")) {
    file_save_string("save/config.properties", "sfx=1\nmusic=1\nscale_gui=1\nname=username");
}
var config = scrFile("save/config.properties");

// Crear una "carpeta" de recursos
global.assets = {
	texture : [],
	sound : [],
	font : [],
    entity : [
        // zombie
        {
            type : "zombie",
            tag : {speed:90,health:10,strength:0.25},
            model : "biped",
            events:{
                ia: Zombie_ia,
                attack: Zombie_attack
            },
            attribute:{distance_view:12}
        },
        {
            type : "skeleton",
            tag : {speed:90,health:5,strength:1},
            model : "biped",
            events:{
                ia: Skeleton_ia,
                attack: Skeleton_attack
            },
            attribute:{distance_view:5}
        }
    ],
    animation : {
        biped : json_parse(scrFile("resource/animation/biped_model.json"))
    },
	conf : {
        // log
        log_number : 0,
        
        // Audio
        sfx : bool(properties_find_real(config, "sfx") ?? 1),
        msc : bool(properties_find_real(config, "music") ?? 1),
        
        // ui
        scale_ui : properties_find_real(config, "scale_gui") ?? 1,
        
        // Jugador
        name : properties_find_string(config, "name") ?? "undefined",
        level : 0,
        xp : 0,
        
        // Otro
        level_path : "",
        level_type : 0 // 0 = normal, 1 = editor
    }
}

show_debug_message("config: {0}", global.assets.conf);

global.lists = {
    block : [],
};

var i = 0;
while (file_exists("log" + string(i) + ".txt")) {
    i++;
}
global.assets.conf.log_number = i;

/// ------------MACROS y ENUM--------------
enum type_object {
	block,
    entity,
}

enum buttonState {
	none,
    in,
	hold,
	pressed,
	released
}

enum EntityEvent {
    EnReposo = 1 << 0,
    Murio = 1 << 1,
    Ataco = 1 << 2,
    EsHerido = 1 << 3,
    Caminar = 1 << 4
}

enum BODY_OFFSET {
	torso,
    handL,
    handR,
    head
}

enum VarType {
    int,
    float,
    bool,
    string,
    menu_panel
}

#macro versionMajor 1
#macro versionMinor 0
#macro versionPatch 0


// Variables
return_code = 1;

time = get_timer();
loading = "loading resource: ";

label = "";
load_i = -1;

#region Funciones
// Función helper para cargar texturas
function load_texture(name, path, w, h, xo = 0, yo = 0) {
	var spr = rsc_load_tex(name, path, w, h, xo, yo);
	log_to_file(loading + path);
	if (spr == -1) {
        if (file_exists(path)) log_to_file("❌ Failed to load texture: " + path + ", The file could not be loaded.");
        else log_to_file("❌ Failed to load texture: " + path + ", The file does not exist.");
        show_debug_message("error de recursos");
		game_end(return_code);
		return false;
	}
    else if (spr == -2) {
        log_to_file("❌ Failed to load texture: " + path + ", Invalid format.");
        show_debug_message("error de recursos");
		game_end(return_code);
		return false;
	}
	return true;
}

// Función helper para cargar sonidos
function load_sound(name, path) {
	var snd = rsc_load_snd(name, path);
	log_to_file(loading + path);
	if (snd == -1) {
		if (file_exists(path)) log_to_file("❌ Failed to load sound: " + path + ", The file could not be loaded.");
        else log_to_file("❌ Failed to load sound: " + path + ", The file does not exist.");
        show_debug_message("error de recursos");
		game_end(return_code);
		return false;
	}
	return true;
}

// Función helper para cargar datos
function load_data(name, path, key) {
	var data = rsc_load_data(name, path, key);
	log_to_file(loading + path);
	if (data == -1) {
		if (file_exists(path)) log_to_file("❌ Failed to load data: " + path + ", The file could not be loaded.");
        else log_to_file("❌ Failed to load data: " + path + ", The file does not exist.");
		show_debug_message("error de recursos");
        game_end(return_code);
		return false;
	}
	return true;
}
#endregion

load_pack = [
    function() {
		label = "Entity textures";
        
        // player
		if (!load_texture("player_body", "resource/entity/player_body.png", 10, 13, 5, 6)) return;
		if (!load_texture("player_hand", "resource/entity/player_hand.png", 4, 4, 2, 2)) return;
		if (!load_texture("player_head", "resource/entity/player_head.png", 16, 13, 8, 6)) return;
        
        // zombie
		if (!load_texture("zombie_body", "resource/entity/zombie_body.png", 10, 13, 5, 6)) return;
		if (!load_texture("zombie_hand", "resource/entity/zombie_hand.png", 4, 4, 2, 2)) return;
		if (!load_texture("zombie_head", "resource/entity/zombie_head.png", 16, 13, 8, 6)) return;
        
        // skeleton
		if (!load_texture("skeleton_body", "resource/entity/skeleton_body.png", 10, 13, 5, 6)) return;
		if (!load_texture("skeleton_hand", "resource/entity/skeleton_hand.png", 4, 4, 2, 2)) return;
		if (!load_texture("skeleton_head", "resource/entity/skeleton_head.png", 16, 13, 8, 6)) return;
        
        // armadura de diamante
        if (!load_texture("armor/diamond_body", "resource/entity/armor/diamond_body.png", 18, 21, 9, 10)) return;
        if (!load_texture("armor/diamond_hand", "resource/entity/armor/diamond_hand.png", 12, 12, 6, 6)) return;
        if (!load_texture("armor/diamond_head", "resource/entity/armor/diamond_head.png", 24, 21, 12, 10)) return;
	},
    
    function() {
        label = "finding texture";
        
        // buscar texturas
        var _tex = file_find_first("resource/block/*.png", fa_none);
        
        while (_tex != "") {
            if (string_ends_with(_tex, ".png")) {
                _tex = string_copy(_tex, 1, string_length(_tex) - 4); // copia sin los últimos 4 caracteres
                array_push(global.lists.block, _tex);
            }
            _tex = file_find_next();
        }
    },
    
    function() {
		label = "Block textures";
        
        // block
        for (var i = 0; i < array_length(global.lists.block); ++i) {
		    if (!load_texture("block/" + global.lists.block[i], "resource/block/" + global.lists.block[i] + ".png", 32, 48)) return;
        }
        
        if (!load_texture("chest/normal", "resource/object/chest_normal.png", 32, 48)) return;
	},
    
	function() {
		label = "GUI textures";
        
        // gui boton
		if (!load_texture("Outline64x64", "resource/gui/outline_64x64.png", 64, 64, 32, 32)) return;
		if (!load_texture("Outline128x64", "resource/gui/outline_128x64.png", 128, 64, 64, 32)) return;
		if (!load_texture("Outline256x64", "resource/gui/outline_256x64.png", 256, 64, 128, 32)) return;
		if (!load_texture("Outline1024x96", "resource/gui/outline_1024x96.png", 1024, 96, 256, 48)) return;
        if (!load_texture("create_levelEditor", "resource/gui/add.png", 64, 64, 32, 32)) return;
        if (!load_texture("gui_leave", "resource/gui/exit.png", 64, 64, 32, 32)) return;
        if (!load_texture("gui_config", "resource/gui/configuration.png", 64, 64, 32, 32)) return;
        
        // flechas
        if (!load_texture("gui_arrowR", "resource/gui/arrow_right.png", 64, 64, 0, 0)) return;
        if (!load_texture("gui_arrowL", "resource/gui/arrow_left.png", 64, 64, 0, 0)) return;
        
        // nivel visual
        if (!load_texture("gui/health", "resource/gui/game/health.png", 32, 32, 0, 0)) return;
        
        // cursor
		if (!load_texture("cursor_idle", "resource/gui/cursor_move.png", 32, 32, 1, 1)) return;
		if (!load_texture("cursor_attack", "resource/gui/cursor_attack.png", 32, 32, 1, 1)) return;
        
        // ui de teclas
        if (!load_texture("ui_press_key_e", "resource/gui/press_key_e.png", 32, 32)) return;
        
        // editor
		if (!load_texture("editor_object_block", "resource/gui/obj_block.png", 32, 32, 16, 16)) return;
		if (!load_texture("editor_object_cmd", "resource/gui/obj_cmd.png", 32, 32, 16, 16)) return;
		if (!load_texture("editor_object_entity", "resource/gui/obj_entity.png", 32, 32, 16, 16)) return;
		if (!load_texture("editor_object_startpoint", "resource/gui/obj_startpoint.png", 32, 32, 16, 16)) return;
        if (!load_texture("gui_layer_cape", "resource/gui/layer_ui.png", 64, 64, 0, 0)) return;
        if (!load_texture("editor/sun", "resource/gui/sun.png", 64, 64, 0, 0)) return;
        if (!load_texture("editor/moon", "resource/gui/moon.png", 64, 64, 0, 0)) return;
	},

	function() {
		label = "GUI sound";
        
        // gui boton
		if (!load_sound("sndClickUI", "resource/gui/sound/snd_click_ui.ogg")) return;
	},

	function() {
		label = "item texture";
        
        // swords
		if (!load_texture("item/diamond_sword", "resource/item/diamond_sword.png", 16, 16, 0, 0)) return;
        
        // foods
		if (!load_texture("item/apple", "resource/item/apple.png", 16, 16, 0, 0)) return;
	}
];