depth = -y;

model_set_animation("idle", animation);

if (distance_to_object(objPlayer) < 64) {
    var dir = point_direction(x, y, objPlayer.x, objPlayer.y);
    
    var xx = lengthdir_x(1, dir);
    var yy = lengthdir_y(1, dir);
    
    move_entity(xx, yy);
}

var new_cx = floor((x + 32) / objMap.chunk_size);
var new_cy = floor((y + 32) / objMap.chunk_size);

if (new_cx != cx || new_cy != cy) {
    // Sacarse del chunk viejo
    chunk_delete_data(cx, cy);

    // Meterse al chunk nuevo
    var p = {
        type : 2,
        inst : id
    };
    ds_list_add(objMap.chunk[# new_cx, new_cy], p);

    // Actualizar el chunk actual de la entidad
    cx = new_cx;
    cy = new_cy;
}