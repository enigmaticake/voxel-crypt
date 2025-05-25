#region textura

/// @param {string} name
/// @param {string} Fname
/// @param {real} [SizeX]
/// @param {real} [SizeY]
/// @param {real} [offsetx] Opcional, eh
/// @param {real} [offsety] Opcional, eh
/// @return {Asset.GMSprite}
function rsc_load_tex(name, asset, sizex = 0, sizey = 0, offsetx = 0, offsety = 0) {
	// Verificar si el sprite existe antes de cargar
    if (rsc_find_tex(name) != -1) {
        rsc_unload_tex(name);
    }
    
    var spr = sprite_add(asset, 0, false, false, 0, 0);
	
	// sin sprite
	if (spr == -1)
		return -1;
	
	// cambiar el Pivot del sprite
	if (offsetx > 0 and offsety > 0)
		sprite_set_offset(spr, offsetx, offsety);
	
	// verificar tamaño correcto del sprite
	var ww = sprite_get_width(spr);
	var hh = sprite_get_height(spr);
	
	if (sizex > 0 and sizey > 0)
		if (ww != sizex or hh != sizey)
			return -2;
	
	array_push(global.assets.texture, [name, spr]);
	return spr;
}


/// @param {string} name
/// @return {Asset.GMSprite}
function rsc_find_tex(name) {
	for (var i = 0; i < array_length(global.assets.texture); ++i) {
		if (global.assets.texture[i][0] == name) return global.assets.texture[i][1];
	}
	return -1;
}


/// @param {string} name
/// @return {bool}
function rsc_unload_tex(name) {
	var index = -1;
	var indexArr = -1;
	
	for (var i = 0; i < array_length(global.assets.texture); ++i) {
		if (global.assets.texture[i][0] == name) {
			index = global.assets.texture[i][1];
			indexArr = i;
			break;
		}
	}

	if (index == -1) return false;

	// Borrar primero del array global
	array_delete(global.assets.texture, indexArr, 1);

	// Si aún existe el sprite, borrarlo
	if (sprite_exists(index)) {
		return sprite_delete(index);
	}

	return true;
}


#endregion

#region musica

/// @param {string} name
/// @param {string} Fname
/// @return {Asset.GMSound}
function rsc_load_snd(name, asset) {
	if (!file_exists(asset)) return -1
	
	var msc = audio_create_stream(asset);
	
	array_push(global.assets.sound, [name, msc]);
	return msc;
}


/// @param {string} name
/// @return {Asset.GMSound}
function rsc_find_snd(name) {
	for (var i = 0; i < array_length(global.assets.sound); ++i) {
		if (global.assets.sound[i][0] == name) return global.assets.sound[i][1];
	}
	return -1;
}


/// @param {string} name
/// @return {bool}
function rsc_unload_snd(name) {
	// Verificar si el índice está registrado en el array de texturas
	for (var i = 0; i < array_length(global.assets.sound); ++i) {
		if (global.assets.sound[i][0] == name) {
			var snd = global.assets.sound[i][1];
			
			// Eliminar la textura del array
			var sndResult = audio_destroy_stream(snd);
			
			return sndResult;
		}
	}
	return false;
}

#endregion