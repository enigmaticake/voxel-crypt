// skeleton
function Skeleton_ia(event){
    if (point_in_circle(event.x, event.y, objPlayer.x, objPlayer.y, event.attribute.distance_view*32)) {
        event.move(objPlayer);
        
        if (point_in_circle(event.x, event.y, objPlayer.x, objPlayer.y, 96)) {
            event.attack(objPlayer);
        }
    }
}
function Skeleton_attack(event, source){
    var arrow = instance_create_depth(event.x, event.y, 0, objArrow);
    
    arrow.target = source;
    arrow.damage_count = event.tag.strength;
    arrow.dir = point_direction(event.x, event.y, source.x, source.y);
}

// zombie
function Zombie_ia(event){
    if (point_in_circle(event.x, event.y, objPlayer.x, objPlayer.y, event.attribute.distance_view*32)) {
        event.move(objPlayer);
        
        if (point_in_circle(event.x, event.y, objPlayer.x, objPlayer.y, 32)) {
            event.attack(objPlayer);
        }
    }
}
function Zombie_attack(event, source){
    source.tag.health -= event.tag.strength;
}