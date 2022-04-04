shader_type canvas_item;
render_mode unshaded;

uniform float speed : hint_range(0.0, 5.0);
uniform float magnitude : hint_range(0.0, 0.05);
uniform float direction : hint_range(0.0, 20.0);
uniform float ripple : hint_range(0.0, 20.0);
uniform sampler2D noise;

float wobble(float uv, float t, float y)
{
	float w = uv + magnitude * sin(speed * t + ripple * uv + direction * y);
	return w;
}


float surface_noise(float uv, float t, float y, float n)
{
	float w = uv + (magnitude * 2.0) * sin(speed * t + (ripple) * uv + direction * n* y);
	return w;
}

void fragment()
{
//	vec2 uv = vec2(wobble(SCREEN_UV.x, TIME, SCREEN_UV.y), SCREEN_UV.y) * vec2(256, 144);
	vec2 uv = vec2(wobble(SCREEN_UV.x, TIME, SCREEN_UV.y), SCREEN_UV.y);
	float n = texture(noise, vec2(UV.x + TIME/50.0, UV.y)).r;
	
//	vec4 col = texelFetch(SCREEN_TEXTURE, ivec2(int(uv.x), int(uv.y)), 0);
	vec4 col = texture(SCREEN_TEXTURE, uv);
	vec4 col1 = texture(TEXTURE, vec2(UV.x, UV.y)); //clamp(1.0, 0.0, surface_noise(UV.y, TIME/2.0, UV.x, n))));
	
	if (col1 == vec4(1.0, 1.0, 1.0, 1.0)) {
		COLOR = vec4(117.0/255.0, 248.0/255.0, 190.0/255.0, 0.8);
	} else {
		COLOR = (col + col1) / 2.4;
	}
	
	if (col1.a == 0.0) {
		COLOR.a = 0.0
	}
	
	
//	COLOR = col * col1;
}