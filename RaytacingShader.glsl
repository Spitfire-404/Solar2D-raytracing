const float fov = 90.0;
const float PI = 3.1415926535897932384626433832795897932384626433832795;
const float aspect = (1280.0/720.0);

struct Ray
{
    vec3 origin;
    vec3 direction;
};
struct hitInfo
{
    bool didHit;
    P_DEFAULT float distance;
    P_DEFAULT vec3 point;
    P_DEFAULT vec3 normal;
};


hitInfo rayHitSphere(Ray ray, vec3 spherePosition, float sphereRadius)
{
    hitInfo hit;
    hit.didHit = false;

    vec3 vecDistFromSphere = spherePosition - ray.origin;
    float rayPen = dot(vecDistFromSphere, ray.direction);
    float rayPenDistFromCenter = sqrt((length(vecDistFromSphere)*length(vecDistFromSphere)) - (rayPen*rayPen));
    if (rayPenDistFromCenter <= sphereRadius)
    {
        
        
        float rayPenDist = sqrt(((sphereRadius*sphereRadius) - (rayPenDistFromCenter*rayPenDistFromCenter)));
        hit.distance = rayPen + rayPenDist;
        if (hit.distance > CoronaVertexUserData.w)
        {
            hit.didHit = true;
            hit.point = ray.origin + ray.direction * hit.distance;
            hit.normal = normalize(hit.point - spherePosition);
            
        }
    }
    return hit;
}

struct sphere{
    vec3 position;
    float radius;
    vec3 color;
};

//int data[3];
//GLuint ssbo;
//glGenBuffers(1, &ssbo);
//glBindBuffer(GL_SHADER_STORAGE_BUFFER, ssbo);
//glBufferData(GL_SHADER_STORAGE_BUFFER, sizeof(data), data​, GLenum usage); //sizeof(data) only works for statically sized C/C++ arrays.
//glBindBufferBase(GL_SHADER_STORAGE_BUFFER, 3, ssbo);

//vec2 getCoord() {
//    return vec2(
//    	texelFetch(iChannel0, ivec2(0, 0), 0).r,
//        texelFetch(iChannel0, ivec2(1, 0), 0).r
//    );
//}

P_COLOR vec4 FragmentKernel( P_UV vec2 texCoord )
{
    P_DEFAULT vec3 camDir = normalize(CoronaVertexUserData.xyz);
    P_DEFAULT vec3 camDirEpsilon = camDir + vec3(0.00001, 0.00001, 0.00001);
    P_DEFAULT vec3 camRight = normalize(cross(camDirEpsilon, vec3(0, 1, 0)));
    P_DEFAULT vec3 camUp = normalize(cross(camRight, camDirEpsilon));


    P_DEFAULT float nearClipHeight = (tan((PI/180.0)*(fov / 2.0)) * CoronaVertexUserData.w )*2.0;
    P_DEFAULT float nearClipWidth = nearClipHeight*aspect;
    P_DEFAULT vec3 localRayDir = vec3((2.0*texCoord.x - 1.0)/(aspect*2.0),(2.0* texCoord.y - 1.0)/(aspect*2.0), 1)*vec3(nearClipWidth, nearClipHeight, CoronaVertexUserData.w);
   // Construct a rotation matrix from camera space to world space
P_DEFAULT mat3 rotationMatrix = mat3(
  camRight,
  camUp,
  camDir
);



// Transform localRayDir from camera space to world space
P_DEFAULT vec3 rayDir = rotationMatrix * localRayDir;
rayDir = normalize(rayDir);

    Ray ray;
    ray.origin = vec3(0,0,0);
    ray.direction = rayDir;

    return vec4(rayHitSphere(ray, vec3(0,0,3), 1.0).normal,0);
    
} 