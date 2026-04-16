shader_type particles;

uniform float speed : hint_range(0.0, 5.0) = 1.0;
uniform float spread : hint_range(0.0, 10.0) = 3.0;
uniform vec3 target_position = vec3(0.0, 0.0, 0.0);
uniform float attraction : hint_range(0.0, 2.0) = 0.0;

// Hash-based PRNG (Godot shaders have no built-in randf)
float hash(float n) {
    return fract(sin(n) * 43758.5453123);
}

void start() {
    float seed = float(INDEX) * 1.37 + float(RANDOM_SEED);
    float r1 = hash(seed);
    float r2 = hash(seed + 1.0);
    float r3 = hash(seed + 2.0);
    float r4 = hash(seed + 3.0);

    float theta = TAU * r1;
    float phi = acos(2.0 * r2 - 1.0);
    float r = spread * pow(r3, 0.33);
    TRANSFORM[3].xyz = vec3(
        r * sin(phi) * cos(theta),
        r * sin(phi) * sin(theta),
        r * cos(phi)
    );
    VELOCITY = normalize(TRANSFORM[3].xyz) * speed * 0.3;
    COLOR = vec4(1.0, 0.84, 0.31, 1.0);
    CUSTOM.x = r4;
}

void process() {
    vec3 dir = target_position - TRANSFORM[3].xyz;
    float dist = length(dir);
    if (dist > 0.01) {
        VELOCITY += normalize(dir) * attraction * DELTA;
    }
    VELOCITY.x += sin(LIFETIME * 2.0 + CUSTOM.x * TAU) * 0.1 * DELTA;
    VELOCITY.y += cos(LIFETIME * 2.0 + CUSTOM.x * TAU) * 0.1 * DELTA;
    COLOR.a = smoothstep(0.0, 0.2, 1.0 - LIFETIME / LIFETIME);
}
