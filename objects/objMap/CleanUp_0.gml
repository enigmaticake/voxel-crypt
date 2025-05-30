for (var i = 0; i < width; ++i) {
    for (var j = 0; j < height; ++j) {
        var cell = chunk[# i, j];
        ds_list_destroy(cell);
        chunk[# i, j] = undefined;
    }
}

ds_grid_destroy(chunk);
ds_grid_destroy(chunk_loading);