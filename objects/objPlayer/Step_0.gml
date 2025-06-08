event |= EntityEvent.idle;

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
        event |= EntityEvent.attack;
    }
}

if (keyboard_check_pressed(vk_escape)) {
    room_goto((global.assets.conf.level_type == 0) ? rmMenu : rmEditor);
}


// muerte
if (tag.health <= 0) {
    event |= EntityEvent.die;
}

// movimiento
move_entity(moveX, moveY);

x = clamp(x, 0, room_width - 32);
y = clamp(y, 0, room_height - 32);


// animacion
if ((event & EntityEvent.die) != 0) {
    model_set_animation(model, "animation.death", EntityEvent.die);
}
else if ((event & EntityEvent.attack) != 0) {
    model_set_animation(model, "animation.attack", EntityEvent.attack);
}
else if ((event & EntityEvent.idle) != 0) {
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