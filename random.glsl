
float Random(vec2 co, float time) {
    return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453 * time);
}

P_COLOR vec4 FragmentKernel(P_UV vec2 texCoord) {   
    vec3 random = vec3(1.0, 1.0, 1.0) * Random(texCoord, CoronaTotalTime * 10.0);
    return vec4(random, 1.0);
}
