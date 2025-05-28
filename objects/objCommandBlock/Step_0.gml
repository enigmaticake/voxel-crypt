var _active = false; // activador de comando

// comando repetidor
if (repite)
    _active = true;

// comando de una sola vez
else if (place_meeting(x, y, objPlayer) and !touch) {
    touch = true;
    _active = true;
}


// activar comando
if (_active)
    show_message(command);