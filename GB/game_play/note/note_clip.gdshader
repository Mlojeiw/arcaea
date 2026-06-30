shader_type spatial;
render_mode unshaded;

uniform float clip_y = 0.0;          
uniform sampler2D note_tex ;  

varying float world_y;             

void vertex() {
    vec3 world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
    world_y = world_pos.y;
}

void fragment() {

    if (world_y > clip_y) {
        discard;
    }
    ALBEDO = texture(note_tex, UV).rgb;
}