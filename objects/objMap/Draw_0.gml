var camx = floor(camera_get_view_x(view_camera[0]) / 32);
var camy = floor(camera_get_view_y(view_camera[0]) / 32);
var camw = floor(camera_get_view_width(view_camera[0]) / 32);
var camh = floor(camera_get_view_height(view_camera[0]) / 32);

var startx = max(0, camx);
var starty = max(0, camy);
var endx = min(room_width / 32, camx + camw + 2);
var endy = min(room_height / 32, camy + camh + 2);

for (var i = startx; i < endx; ++i) {
    for (var j = starty; j < endy; ++j) {
        draw_sprite_part_ext(rsc_find_tex("block/" + global.lists.block[1]), 0, 0, 0, 32, 32, i * 32 - 16, j * 32, 1, 1, c_gray, 1);
    }
}