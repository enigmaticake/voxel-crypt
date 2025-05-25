var moveX = 0;
var moveY = 0;

// input
if (InputActive) {
    moveX = keyboard_check_direct(ord("D")) - keyboard_check_direct(ord("A"));
    moveY = keyboard_check_direct(ord("S")) - keyboard_check_direct(ord("W"));
}

if (keyboard_check_pressed(vk_escape)) {
    room_goto(rmMenu);
}


// movimiento
move_entity(moveX, moveY);

x = clamp(x, 0, room_width - 32);
y = clamp(y, 0, room_height - 32);


// animacion
model_set_animation("idle", animation);


// camara
var camx = camera_get_view_x(view_camera[0]);
var camy = camera_get_view_y(view_camera[0]);

var targetx = lerp(camx, x - camera_get_view_width(view_camera[0]) / 2, 0.01);
var targety = lerp(camy, y - camera_get_view_height(view_camera[0]) / 2, 0.01);

camera_set_view_pos(view_camera[0], targetx, targety);