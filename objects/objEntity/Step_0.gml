view = bool(!collision_line(x, y, objPlayer.x, objPlayer.y + 9, objBlock, false, false));

depth = -y;

// animacion
event |= EntityEvent.idle;

// seguir al jugador
if (distance_to_object(objPlayer) < 128 and view) {
    event |= EntityEvent.attack;
    
    var dir = point_direction(x, y, objPlayer.x, objPlayer.y);
    
    var xx = lengthdir_x(1, dir);
    var yy = lengthdir_y(1, dir);
    
    move_entity(xx, yy);
}

// morir al tener 0 vidas
if (tag.health <= 0) {
    event |= EntityEvent.die;
    instance_destroy();
}

// animaciones
if ((event & EntityEvent.die) != 0) {
    model_set_animation(model, "animation.death");
}
else if ((event & EntityEvent.attack) != 0) {
    model_set_animation(model, "animation.attack");
}
else if ((event & EntityEvent.idle) != 0) {
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

event &= ~EntityEvent.attack;
event &= ~EntityEvent.die;