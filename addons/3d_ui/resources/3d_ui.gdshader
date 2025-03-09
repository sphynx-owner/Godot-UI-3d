shader_type spatial;

uniform sampler2D albedo_texture;

uniform vec2 uv_scale = vec2(1.0);
uniform vec2 uv_offset = vec2(0.0);

void vertex() {
	UV *= uv_scale;
	UV += uv_offset;
}

void fragment() {
	if((CAMERA_VISIBLE_LAYERS & uint(1 << 19)) == uint(0)){
		ALBEDO = vec3(mod(UV, vec2(1.0)), 0);
	}
	else{
		ALBEDO = texture(albedo_texture, UV).xyz;
	}
}
