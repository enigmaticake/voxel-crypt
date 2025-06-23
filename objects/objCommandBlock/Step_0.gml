var _active = false; // activador de comando (esto activara eventos global del mundo)
var Activador = (struct_exists(active_json, "active")) ? active_json.active : {};

// activar con el choque del jugador, cuando el jugador esta dentro de el objeto trigger (objCommmandBlock)
if (struct_exists(Activador, "touch") and Activador.touch == true and place_meeting(x, y, objPlayer)) {
    _active = true;
}

// activar segun la region del jugador (px, py, x1, y1, x2, y2)
if (PlayerRegions(Activador)) {
    _active = true;
}


// activar comando para crear eventos del mundo por ejemplo: move un bloque, obtener cantidad de entidades...
if (_active) {
    for (var i = 0; i < array_length(path_cmd); ++i) {
        array_push(objMap.events, path_cmd[i]);
        if (struct_exists(Activador, "destroy") and Activador.destroy == true) instance_destroy();
    }
}