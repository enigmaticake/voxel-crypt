var delta = delta_time / 1_000_000;

var xx = lengthdir_x(1, dir);
var yy = lengthdir_y(1, dir);

if (!objMap.chunk_loading[# floor(x / objMap.chunk_size), floor(y / objMap.chunk_size)]) {
    instance_destroy();
}

for (var i = 0; i < 500 * delta; ++i) {
    x += xx;
    y += yy;
    
    var inst = collision_circle(x, y + 16, 8, target, true, false);
    if (inst) {
        inst.tag.health -= damage_count;
        instance_destroy();
        break;
    }
    
    if (place_meeting(x, y, [objBlock, objChest])) {
        instance_destroy();
        break;
    }
}

depth = -y;