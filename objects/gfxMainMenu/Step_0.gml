if (keyboard_check_pressed(vk_f11)) {
	window_set_fullscreen(!window_get_fullscreen());
	display_mouse_set(display_get_width() / 2, display_get_height() / 2);
}

if (state == states.level or state == states.editor) {
    if (mouse_wheel_up()) {
        level_posy = max(0, level_posy - 16 * scale_factor());
    }
    else if (mouse_wheel_down()) {
        level_posy += 16 * scale_factor();
    }
}