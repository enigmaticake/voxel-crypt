// trigger
target_id = [];

// chunk
cx = 0;
cy = 0;

// modelo 2d
skin = [];
model = -1;

// atacar con delay
attack_delay = 0;

// es atacado
function is_attacked(event) {
    
}

// propiedades
function move(source) {
    if ((event & EntityEvent.Ataco) == 0) {
        var dir = point_direction(x, y, source.x, source.y);
        
        var xx = lengthdir_x(1, dir);
        var yy = lengthdir_y(1, dir);
        
        move_entity(xx, yy);
    }
}
function attack(source) {
    if (attack_delay == 30) {
        attack_delay = 0;
        event |= EntityEvent.Ataco;
        source.is_attacked(id);
        events.attack(id, source);
    }
}
attribute = {};
tag = {};
events = {
    ia:-1,
    attack:-1
};
health_max = 0;