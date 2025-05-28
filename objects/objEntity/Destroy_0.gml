// eliminar del chunk para ahorrar memoria
var old_list = objMap.chunk[# cx, cy];
for (var i = 0; i < ds_list_size(old_list); ++i) {
    var p = old_list[| i];
    if (p.inst == id) {
        ds_list_delete(old_list, i);
        break;
    }
}