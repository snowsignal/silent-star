// jangsy5 code
extern number aberration = 2.0;

uniform float time;

vec4 effect(vec4 color, Image tx, vec2 tc, vec2 pc)
{
    float vx = abs(sin(time*3.0)) + 0.2;
    float vy = abs(cos(time*5.0)) + 0.2;
    // fake chromatic aberration
    float sx = vx * aberration/love_ScreenSize.x;
    float sy = vy * aberration/love_ScreenSize.y;
    vec4 r = Texel(tx, vec2(tc.x + sx, tc.y - sy));
    vec4 g = Texel(tx, vec2(tc.x, tc.y + sy));
    vec4 b = Texel(tx, vec2(tc.x - sx, tc.y - sy));
    number a = (r.a + g.a + b.a)/3.0;

    return vec4(r.r, g.g, b.b, a);
}
