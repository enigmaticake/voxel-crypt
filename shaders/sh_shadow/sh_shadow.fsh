varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main()
{
    vec2 tex = v_vTexcoord;
    //tex.y = 1.0 - tex.y;
    
    gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0) * texture2D(gm_BaseTexture, tex);
}
