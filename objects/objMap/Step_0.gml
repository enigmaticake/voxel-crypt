// ======== eventos ========

// quitar tiempo a los eventos
for (var i = array_length(events) - 1; i >= 0; --i) {
    var ev = events[i];
    
    ev.time -= 0.01; // tiempo
    
    // tiempo acabado
    if (ev.time <= 0) {
        
        // tipo de evento
        switch (ev.type ?? "message") {
        	case "message":
                show_message(ev.msg ?? "");
                break;
        }
        
        array_delete(events, i, 1);
    }
}


// ======== chunks ========

var new_plx = floor(objPlayer.x / chunk_size);
var new_ply = floor(objPlayer.y / chunk_size);

// Solo si el jugador cambió de chunk
if (new_plx != plx || new_ply != ply) {
    
    // Rango de carga (3x3)
    var range = 3;

    // Descargar chunks que ya no están cerca
    for (var i = 0; i < width; ++i) {
        for (var j = 0; j < height; ++j) {
            // Si el chunk está FUERA del rango del nuevo chunk del jugador
            if (abs(i - new_plx) > range || abs(j - new_ply) > range) {
                chunk_delete(i, j);
                chunk_loading[# i, j] = false;
            }
        }
    }

    // Cargar nuevos chunks dentro del rango
    for (var i = -range; i <= range; i++) {
        for (var j = -range; j <= range; j++) {
            var cx = new_plx + i;
            var cy = new_ply + j;

            if (cx >= 0 && cy >= 0 && cx < width && cy < height && !chunk_loading[# cx, cy]) {
                chunk_load(cx, cy);
                chunk_loading[# cx, cy] = true;
            }
        }
    }

    // Actualizar chunk del jugador
    plx = new_plx;
    ply = new_ply;
}