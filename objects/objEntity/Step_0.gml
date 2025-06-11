view = bool(!collision_line(x, y + 9, objPlayer.x, objPlayer.y + 9, objBlock, false, false));

depth = -y;

// delays
attack_delay = min(30, attack_delay + 1);

// animacion
event |= EntityEvent.EnReposo;

// seguir al jugador
if (distance_to_object(objPlayer) < 128 and view) {
    event |= EntityEvent.Caminar;
    
    if (distance_to_object(objPlayer) < 64 and attack_delay >= 30) {
        attack_delay = 0;
        event |= EntityEvent.Ataco;
        objPlayer.tag.health -= 0.3;
    }
    
    var dir = point_direction(x, y, objPlayer.x, objPlayer.y);
    
    var xx = lengthdir_x(1, dir);
    var yy = lengthdir_y(1, dir);
    
    move_entity(xx, yy);
}

// animaciones
if (event_has(event, EntityEvent.Ataco)) {
    model_set_animation(model, "animation.attack", EntityEvent.Ataco);
}
else if (event_has(event, EntityEvent.Caminar)) {
    model_set_animation(model, "animation.walk", EntityEvent.Caminar);
    event &= ~EntityEvent.Caminar;
}
else if (event_has(event, EntityEvent.Murio)) {
    model_set_animation(model, "animation.death", EntityEvent.Murio);
}
else if (event_has(event, EntityEvent.EnReposo)) {
    model_set_animation(model, "animation.idle");
}

// cambiar de chunks
var new_cx = floor(x / objMap.chunk_size);
var new_cy = floor(y / objMap.chunk_size);

if (new_cx != cx || new_cy != cy) {
    // Sacarse del chunk viejo
    var old_list = objMap.chunk[# cx, cy];
    for (var i = 0; i < ds_list_size(old_list); ++i) {
        var p = old_list[| i];
        if (p.inst == id) {
            var p_new = p;
            ds_list_delete(old_list, i);
            break;
        }
    }

    // Meterse al chunk nuevo
    ds_list_add(objMap.chunk[# new_cx, new_cy], p_new);

    // Actualizar el chunk actual de la entidad
    cx = new_cx;
    cy = new_cy;
}

// morir al tener 0 vidas
if (tag.health <= 0) {
    event |= EntityEvent.Murio;
    instance_destroy();
}