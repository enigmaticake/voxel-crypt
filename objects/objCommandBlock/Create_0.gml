target_id = [];
ID = 0;

active_json = {};
path_cmd = [];

spr = rsc_find_tex("editor_object_cmd");

// funciones
function PlayerRegions(json) {
    return struct_exists(json, "region") &&
           struct_exists(json.region, "x") &&
           struct_exists(json.region, "y") &&
           struct_exists(json.region, "dx") &&
           struct_exists(json.region, "dy") &&
           point_in_rectangle(floor((objPlayer.x+16)/32), floor((objPlayer.y+16)/32), json.region.x, json.region.y, json.region.dx, json.region.dy)
}