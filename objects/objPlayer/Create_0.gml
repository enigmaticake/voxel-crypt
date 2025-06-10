var _animation = json_parse(scrFile("animation.json"));

create_entity(100, 10, 200);

tag.delay_shot = 20;
delay_shot = 20;

xx = x - 1;
yy = y;

InputActive = true;

skin = [rsc_find_tex("player_body"), rsc_find_tex("player_hand"), rsc_find_tex("player_hand"), rsc_find_tex("player_head")];

model = model_create(_animation, Vec2r(0, 0, 0), Vec2r(0, 0, 0), Vec2r(0, 0, 0), Vec2r(0, 0, 0));