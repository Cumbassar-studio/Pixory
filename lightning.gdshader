shader_type canvas_item;

uniform vec4 emission_color = vec4(1.0, 1.0, 0.2, 1.0); // желтое свечение
uniform float pulse_speed = 2.0;

void fragment() {
    vec4 tex = texture(TEXTURE, UV);
    float pulse = 0.5 + 0.5 * sin(TIME * pulse_speed); // мягкая пульсация
    COLOR = tex;
    COLOR.rgb += emission_color.rgb * pulse * tex.a; // свечение пропорционально альфе
}
