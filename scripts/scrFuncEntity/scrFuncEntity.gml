// skeleton
function Skeleton_ia(event){
    var follow = function(event, p) {
        var dist = point_in_circle(event.x, event.y, p.x, p.y, event.attribute.distance_view*32);
        var view = collision_line(event.x, event.y + 8, p.x, p.y + 8, objBlock, true, false);
        
        if (dist and !view) {
            event.move(p);
            
            if (point_in_circle(event.x, event.y, p.x, p.y, 32)) {
                event.attack(p);
            }
        }
    }
    
    follow(event, objPlayer);
}
function Skeleton_attack(event, source){
    var arrow = instance_create_depth(event.x, event.y, 0, objArrow);
    
    arrow.target = source;
    arrow.damage_count = event.tag.strength;
    arrow.dir = point_direction(event.x, event.y, source.x, source.y);
}

// zombie
function Zombie_ia(event){
    var dist = point_in_circle(event.x, event.y, objPlayer.x, objPlayer.y, event.attribute.distance_view*32);
    var view = collision_line(event.x, event.y + 8, objPlayer.x, objPlayer.y + 8, objBlock, true, false);
    
    if (dist and !view) {
        event.move(objPlayer);
        
        if (point_in_circle(event.x, event.y, objPlayer.x, objPlayer.y, 32)) {
            event.attack(objPlayer);
        }
    }
}
function Zombie_attack(event, source){
    source.tag.health -= event.tag.strength;
}