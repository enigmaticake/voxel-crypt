function event_has(ev, flag) {
    return (ev & flag) != 0;
}
function event_deactive(ev) {
    return 0;
}