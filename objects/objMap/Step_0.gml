var newplx = floor((objPlayer.x + 32) / chunk_size);
var newply = floor((objPlayer.y + 32) / chunk_size);

// actualizar chunks
if (plx != newplx || ply != newply) {
    plx = newplx;
    ply = newply;
    
    
    // eliminar chunk
    for (var xx = 0; xx < width; ++xx) {
        for (var yy = 0; yy < height; ++yy) {
            if (xx < plx - 1 || xx > plx + 1 || yy < ply - 1 || yy > ply + 1) {
                chunk_delete(xx, yy);
                chunk_loading[# xx, yy] = false;
            }
        }
    }
    
    
    // crear chunk
    for (var xx = plx - 1; xx < plx + 1; ++xx) {
        for (var yy = ply - 1; yy < ply + 1; ++yy) {
            if (chunk_loading[# xx, yy] == false) {
                chunk_load(xx, yy);
                chunk_loading[# xx, yy] = true;
            }
        }
    }
}