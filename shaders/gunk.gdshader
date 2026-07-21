shader_type spatial;

uniform vec3 color:source_color;
uniform float scale = 0.1;
uniform float transparency = 0.5;
uniform sampler2D noise;

void fragment() {
	ALPHA = texture(noise, UV * scale).r * transparency;
	ALBEDO = color;
}
