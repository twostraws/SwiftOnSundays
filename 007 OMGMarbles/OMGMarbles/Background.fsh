void main() {
    float speed = u_time * u_speed * 0.05;
    float strength = u_strength / 100.0;

    vec2 coord = v_tex_coord;

    coord.x += sin((coord.x + speed) * u_frequency) * strength;
    coord.y += cos((coord.y + speed) * u_frequency) * strength;

    gl_FragColor = texture2D(u_texture, coord) * v_color_mix.a;
}
