struct Ray
{
    vec3 origin;
    vec3 direction;
};
P_COLOR vec4 FragmentKernel( P_UV vec2 texCoord )
{
    P_COLOR vec4 texColor = texture2D( CoronaSampler0, texCoord );
    P_DEFAULT vec3 viewdir = (texCoord - 0.5 ,1.0)*CoronaVertexUserData.xyz;

    Ray ray;
    ray.direction = viewdir;
    ray.origin = vec3(0,0,0);
    //P_DEFAULT vec4 userData = CoronaVertexUserData;
    //P_DEFAULT vec3 camData = (userData.xy,1);
    return vec4(normalize(viewdir),0);
    
} 