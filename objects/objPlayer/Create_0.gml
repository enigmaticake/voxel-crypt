create_entity(100, 10, 200);

tag.delay_shot = 20;
delay_shot = 20;

xx = x - 1;
yy = y;

InputActive = true;

skin = [rsc_find_tex("player_body"), rsc_find_tex("player_hand"), rsc_find_tex("player_hand"), rsc_find_tex("player_head")];

// Lista para almacenar posiciones del trail
trail = [];
trail_max = 10; // número máximo de partículas activas
trail_delay = 30; // delay de creacion de particulas

animation = model_create(0, vector2D(0, 6), vector2D(-6, 7), vector2D(6, 7), vector2D(0, -5));