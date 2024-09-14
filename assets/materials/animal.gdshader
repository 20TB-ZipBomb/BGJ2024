shader_type spatial;
render_mode cull_disabled;

uniform vec4 color_to_replace:source_color;
uniform vec4 new_color:source_color;
uniform sampler2D tex:source_color, filter_nearest;

void fragment() {
	vec4 current_pixel = texture(tex, UV);
	current_pixel.r = min(current_pixel.r,new_color.r);
	current_pixel.g = min(current_pixel.g,new_color.g);
	current_pixel.b = min(current_pixel.b,new_color.b);
	ALBEDO = current_pixel.rgb;
	ALPHA = current_pixel.a;
}

