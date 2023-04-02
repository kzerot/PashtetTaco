shader_type spatial;
uniform vec4 color1 : source_color;
uniform vec4 color2 : source_color;
uniform vec4 color3 : source_color;
uniform float roughness : hint_range(0.0, 1.0, 0.01);
uniform float metallic : hint_range(0.0, 1.0, 0.01);
uniform float spec : hint_range(0.0, 1.0, 0.01);
void fragment() {
	vec4 all_colors = (color1*COLOR.r + color2*COLOR.g + color3*COLOR.b)/3.0;
	ALBEDO = all_colors.rgb;
	ROUGHNESS = roughness;
	METALLIC = metallic;
	SPECULAR = spec;
}
