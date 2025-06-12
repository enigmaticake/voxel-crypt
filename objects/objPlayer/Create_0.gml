// propiedades
var _animation = json_parse(scrFile("animation.json"));
create_entity(12, 10, 200);


// slot
slot = {
    max : 4,
    mainhand : 0,
    items : [{}, {sprite:rsc_find_tex("item/diamond_sword"), type:"sword", tag:{strength:3}}, {}, {}]
}

/// @param {string} type
function get_slots(type) {
    switch (type) {
    	case "count":
            return slot.max;
        case "slot":
            return slot.items; 
        case "mainhand":
            return slot.mainhand;
    }
}


// flechas
tag.delay_shot = 20;
delay_shot = 20;


// poder controlar el jugador (mover, atacar, curarse, etc)
InputActive = true;


// modelo 2d
skin = [rsc_find_tex("player_body"), rsc_find_tex("player_hand"), rsc_find_tex("player_hand"), rsc_find_tex("player_head")];
model = model_create(_animation, Vec2r(0, 0, 0), Vec2r(0, 0, 0), Vec2r(0, 0, 0), Vec2r(0, 0, 0));