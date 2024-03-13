shader_type canvas_item;

uniform sampler2D mask_texture;
uniform bool mask_with_alpha = false;

void fragment() {
	vec4 mask = texture(mask_texture, UV);
	if (mask_with_alpha) {
		vec4 color = texture(TEXTURE, UV);
		color.a = 1.0 - mask.r;
		COLOR = color;
	}
	else {
		//COLOR += vec4(0.1,0.1,0.1,0.1);
		if (mask.r > 0.5) {
			discard;
		}
	}
}
