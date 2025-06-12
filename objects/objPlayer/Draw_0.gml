function get_item() {
    return struct_get(slot.items[slot.mainhand], "sprite");
}

// dibujar jugador
model_draw_body(model, skin, c_white, 1, 2, get_item() ?? -1);