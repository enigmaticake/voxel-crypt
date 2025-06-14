// propiedades
var _animation = global.assets.animation.biped;
create_entity(40, 10, 200);


// slot
slot = {
    max : 4,
    mainhand : 0,
    items : [{}, {sprite:rsc_find_tex("item/diamond_sword"), type:"sword", tag:{strength:3}}, {}, {}]
}


// flechas
tag.delay_shot = 20;
delay_shot = 20;


// poder controlar el jugador (mover, atacar, curarse, etc)
InputActive = true;


// es atacado
function is_attacked(event) {
    
}


// modelo 2d
skin = [rsc_find_tex("player_body"), rsc_find_tex("player_hand"), rsc_find_tex("player_hand"), rsc_find_tex("player_head")];
model = model_create(_animation, 4);