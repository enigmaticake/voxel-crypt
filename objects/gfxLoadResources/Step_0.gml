load_i ++;

display_set_gui_maximize();

if (load_i >= 0 and load_i < array_length(load_pack)) load_pack[load_i]();
else {
    var timeSecond = (get_timer() - time) / 1_000_000;
    
    file_delete("log" + string(global.assets.conf.log_number) + ".txt");
    show_debug_message("time: {0} s", timeSecond);
	room_goto(rmMenu);
}