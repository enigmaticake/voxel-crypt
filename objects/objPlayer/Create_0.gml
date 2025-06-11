// propiedades
var _animation = json_parse(scrFile("animation.json"));
create_entity(12, 10, 200);


// slot
slot_max = 4;
mainhand = 0;


// flechas
tag.delay_shot = 20;
delay_shot = 20;


// poder controlar el jugador (mover, atacar, curarse, etc)
InputActive = true;


// modelo 2d
skin = [rsc_find_tex("player_body"), rsc_find_tex("player_hand"), rsc_find_tex("player_hand"), rsc_find_tex("player_head")];
model = model_create(_animation, Vec2r(0, 0, 0), Vec2r(0, 0, 0), Vec2r(0, 0, 0), Vec2r(0, 0, 0));