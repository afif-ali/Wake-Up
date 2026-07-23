shader_type spatial;
render_mode unshaded, fog_disabled, depth_draw_never;

uniform sampler2D screen_tex:hint_screen_texture, repeat_disable;
uniform float pixel_size:hint_range(0.0, 20.0, 1.0);
uniform vec2 r_displacement = vec2(3.0, 0.0);
uniform vec2 g_displacement = vec2(0.0, 0.0);
uniform vec2 b_displacement = vec2(-3.0, 0.0);

uniform float alpha = 1.0;
uniform float inner_radius = 0.0;
uniform float outer_radius = 1.0;

void vertex() {
	POSITION = vec4(VERTEX.xy, 1.0, 1.0);
}

void fragment() {
	vec2 tex_size = vec2(textureSize(screen_tex, 0));
	vec2 pixel_count = tex_size / (pixel_size*2.0);
	vec2 pixelatex_uv = floor(SCREEN_UV * pixel_count) / pixel_count;
	float r = texture(screen_tex, pixelatex_uv + vec2(r_displacement/tex_size)).r;
	float g = texture(screen_tex, pixelatex_uv + vec2(g_displacement/tex_size)).g;
	float b = texture(screen_tex, pixelatex_uv + vec2(b_displacement/tex_size)).b;
	vec3 color = vec3(r,g,b);
	
	float vignette_x = abs(UV.r-.5)*2.0;
	float vignette_y = abs(UV.g-.5)*2.0;
	float q = 1.0-(1.0-sqrt(vignette_x*vignette_x+vignette_y*vignette_y)/outer_radius)/(1.0-inner_radius);
	color = mix(color, vec3(0.0), q*alpha);
	
	ALBEDO = color;
}