// jangsy5 code
// with some tweaks by penguin
float aberration = 10.0;

uniform float punch;

vec4 effect(vec4 color, Image tx, vec2 tc, vec2 pc)
{
    // fake chromatic aberration
    float sx = punch * aberration/love_ScreenSize.x;
    float sy = punch * aberration/love_ScreenSize.y;
    vec4 r = Texel(tx, vec2(tc.x + sx, tc.y - sy));
    vec4 g = Texel(tx, vec2(tc.x, tc.y + sy));
    vec4 b = Texel(tx, vec2(tc.x - sx, tc.y - sy));
    float a = (r.a + g.a + b.a)/3.0;

    return vec4(r.r, g.g, b.b, a);
}
