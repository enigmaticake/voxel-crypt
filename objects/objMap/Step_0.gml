var newplx = floor((objPlayer.x + 32) / chunk_size);
var newply = floor((objPlayer.y + 32) / chunk_size);

if (plx != newplx || ply != newply) {
    plx = newplx;
    ply = newply;
    
    for (var xx = plx - 1; xx < plx + 1; ++xx) {
        for (var yy = ply - 1; yy < ply + 1; ++yy) {
            if (chunk_loading[# xx, yy] == false) {
                chunk_load(xx, yy);
                chunk_loading[# xx, yy] = true;
            }
        }
    }
}