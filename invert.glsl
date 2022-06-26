vec4 effect(vec4 color, Image tx, vec2 tc, vec2 pc)
{
    vec4 col = Texel( tx, tc );
    return vec4(1-col.r, 1-col.g, 1-col.b, col.a);
}
