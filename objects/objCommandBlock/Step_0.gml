var _active = false; // activador de comando

// comando repetidor
if (repite)
    _active = true;

// comando de una sola vez
else if (place_meeting(x, y, objPlayer) and !touch) {
    touch = true;
    _active = true;
}

else if (!place_meeting(x, y, objPlayer) and touch) {
    touch = false;
}


// activar comando
if (_active) {
    for (var i = 0; i < array_length(path_cmd); ++i) {
        array_push(objMap.events, path_cmd[i]);
        if (destroy) instance_destroy();
    }
}