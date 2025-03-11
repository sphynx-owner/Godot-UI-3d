shader_type spatial;

render_mode depth_draw_always;

uniform sampler2D albedo_texture;

uniform float id = 0;

uniform vec2 uv_offset = vec2(0.0);
uniform vec2 uv_scale = vec2(1.0);
uniform float uv_rotation = 0;

uniform vec4 out_of_bounds_color : source_color = vec4(0);

vec2 rotate(vec2 uv, float rotation){
	return vec2(cos(-rotation) * uv.x + sin(-rotation) * uv.y, - sin(-rotation) * uv.x + cos(-rotation) * uv.y);
}

void vertex() {
	UV -= uv_offset;
	UV = rotate(UV - 0.5, uv_rotation) + 0.5;
	UV = (UV - 0.5) / uv_scale + 0.5;
}

void fragment() {
	bool out_of_bounds = (UV.x < 0.) || (UV.y < 0.) || (UV.x > 1.) || (UV.y > 1.);
	
	if((CAMERA_VISIBLE_LAYERS & uint(1 << (20 - 1))) == uint(0)){
		ALBEDO = vec3(mod(UV, vec2(1)), out_of_bounds ? 0.0 : id + 0.5);
	}
	else{
		ALBEDO = out_of_bounds ? out_of_bounds_color.xyz : texture(albedo_texture, UV).xyz;
		ALPHA = out_of_bounds ? out_of_bounds_color.a : texture(albedo_texture, UV).a;
	}
}
