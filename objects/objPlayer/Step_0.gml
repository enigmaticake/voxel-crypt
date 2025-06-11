event |= EntityEvent.EnReposo;

var moveX = 0;
var moveY = 0;
delay_shot = min(tag.delay_shot, delay_shot + 1);

// input
if (InputActive) {
    moveX = keyboard_check_direct(ord("D")) - keyboard_check_direct(ord("A"));
    moveY = keyboard_check_direct(ord("S")) - keyboard_check_direct(ord("W"));
    
    if (mouse_check_button_pressed(mb_right) and delay_shot == tag.delay_shot) {
        delay_shot = 0;
        
        var arrow = instance_create_depth(x, y, 0, objArrow);
        
        arrow.dir = point_direction(x, y, mouse_x, mouse_y);
        event |= EntityEvent.Ataco;
    }
}

if (keyboard_check_pressed(vk_escape)) {
    room_goto((global.assets.conf.level_type == 0) ? rmMenu : rmEditor);
}


// muerte
if (tag.health <= 0) {
    event |= EntityEvent.Murio;
}

// movimiento
if (!event_has(event, EntityEvent.Ataco)) {
    move_entity(moveX, moveY);
}
if (x != xprevious || y != yprevious) {
    event |= EntityEvent.Caminar;
}

x = clamp(x, 0, room_width - 32);
y = clamp(y, 0, room_height - 32);


// animacion
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


// camara
var delta_camara = delta_time / 1_000_000;

var camx = camera_get_view_x(view_camera[0]);
var camy = camera_get_view_y(view_camera[0]);

var lerp_factor = clamp(2 * delta_camara, 0, 1);

var targetx = lerp(camx, x - camera_get_view_width(view_camera[0]) / 2, lerp_factor);
var targety = lerp(camy, y - camera_get_view_height(view_camera[0]) / 2, lerp_factor);

camera_set_view_pos(view_camera[0], targetx, targety);