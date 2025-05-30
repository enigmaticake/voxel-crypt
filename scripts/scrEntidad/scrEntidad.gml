/**
 * @param {real} _health
 * @param {real} strength
 * @param {real} _speed
 */
function create_entity(_health, attack_strength, _speed) {
    tag = {
        health : _health,
        strength : attack_strength
    }
    
    speed_full = _speed;
    speed_current = 0;
}

/**
 * @param {real} moveX
 * @param {real} moveY
 */
function move_entity(moveX, moveY) {
    // movimiento
    var delta = clamp(delta_time / 1_000_000, 0, 0.033);
    
    if (moveX != 0 || moveY != 0) {
        var t = clamp(delta_time / 100_000, 0, 1); // ajustamos para framerate variable
        speed_current = lerp(speed_current, speed_full, t);
        
        // Normalizar el vector de movimiento
        var len = point_distance(0, 0, moveX, moveY);
        var dirX = moveX / len;
        var dirY = moveY / len;
        
        // Movimiento total ajustado por velocidad y delta
        var dist = speed_current * delta;
        
        // Mover en pasos pequeños (pixel-perfect con colisiones)
        var steps = ceil(dist);
        var stepX = dirX * (dist / steps);
        var stepY = dirY * (dist / steps);
        
        for (var i = 0; i < steps; i++) {
            if (!place_meeting(x + stepX, y, [objBlock, objChest])) {
                x += stepX;
            }
            if (!place_meeting(x, y + stepY, [objBlock, objChest])) {
                y += stepY;
            }
        }
        
        if (moveX != 0) image_xscale = sign(moveX);
    }
    else speed_current = 0;
}
