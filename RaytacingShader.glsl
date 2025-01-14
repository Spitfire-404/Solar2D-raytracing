struct Ray
{
    vec3 origin;
    vec3 direction;
};
P_COLOR vec4 FragmentKernel( P_UV vec2 texCoord )
{
    P_COLOR vec4 texColor = texture2D( CoronaSampler0, texCoord );
    P_DEFAULT float nearClipHeight = 2.0*(tan((90.0/2.0))*1.77777777778)*CoronaVertexUserData.w;
    P_DEFAULT float nearClipWidth = nearClipHeight * 1.77777777778;
    P_DEFAULT vec3 camData = vec3(nearClipWidth,nearClipHeight,1.77777777778);
    P_DEFAULT vec3 viewdirlocal = (texCoord.x - 0.5,texCoord.y - 0.5 ,1.0)*camData;
    //P_DEFAULT vec3 viewdir = 
    Ray ray;
    ray.direction = viewdirlocal;
    ray.origin = vec3(0,0,0);
    return vec4(normalize(viewdirlocal),0);
    
} 