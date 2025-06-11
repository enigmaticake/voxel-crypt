// trigger
target_id = [];

// chunk
cx = 0;
cy = 0;

// modelo 2d
skin = [];
model = model_create(json_parse(scrFile("animation.json")), Vec2r(0, 0, 0), Vec2r(0, 0, 0), Vec2r(0, 0, 0), Vec2r(0, 0, 0));

// atacar con delay
attack_delay = 0;

// vista al jugador
view = bool(false);