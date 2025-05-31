var delta = delta_time / 1_000_000;

var xx = lengthdir_x(1, dir);
var yy = lengthdir_y(1, dir);

if (!objMap.chunk_loading[# floor(x / objMap.chunk_size), floor(y / objMap.chunk_size)]) {
    instance_destroy();
}

for (var i = 0; i < 500 * delta; ++i) {
    x += xx;
    y += yy;
    
    if (place_meeting(x, y, objEntity)) {
        objEntity.tag.health -= 10;
    }
    
    if (place_meeting(x, y, [objBlock, objChest, objEntity])) {
        instance_destroy();
    }
}

depth = -y;