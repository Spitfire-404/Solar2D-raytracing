const float fov = 90.0;
const float PI = 3.1415926535897932384626433832795;
const float aspect = 1280.0/720.0;

struct Ray
{
    vec3 origin;
    vec3 direction;
};
struct hitInfo
{
    bool didHit;
    float distance;
    vec3 point;
    vec3 normal;
};
struct Shpere
{
    vec3 position;
    float radius;
};

hitInfo rayHitSphere(Ray ray, vec3 spherePosition, float sphereRadius)
{
    hitInfo hit;
    hit.didHit = false;

    vec3 vecDistFromSphere = ray.origin - spherePosition;
    float rayPen = dot(vecDistFromSphere, ray.origin);

    if (rayPen > 0.0){
        float rayPenDistFromCenter = sqrt((length(vecDistFromSphere)*length(vecDistFromSphere)) - (rayPen*rayPen));
        if (rayPenDistFromCenter >= 0.0 && rayPenDistFromCenter <= sphereRadius){
            hit.didHit = true;
            float rayPenDist = sqrt(((sphereRadius*sphereRadius) - (rayPenDistFromCenter*rayPenDistFromCenter)));
            hit.distance = rayPen - rayPenDist;
            hit.point = ray.origin + ray.direction * hit.distance;
            hit.normal = normalize(hit.point - spherePosition);
        }
    }
    return hit;
}

P_COLOR vec4 FragmentKernel( P_UV vec2 texCoord )
{
    P_DEFAULT vec3 camDir = CoronaVertexUserData.xyz;
    P_DEFAULT vec3 camtemp = vec3(camDir.x,camDir.y,camDir.z*1.0001);
    P_DEFAULT vec3 camUp = cross(camDir, camtemp);
    P_DEFAULT vec3 camRight = cross(camUp, camDir);

    P_DEFAULT float nearClipHeight = (tan((PI/180.0)*(fov / 2.0)) * CoronaVertexUserData.w )*2.0;
    P_DEFAULT float nearClipWidth = nearClipHeight*aspect;
    P_DEFAULT vec3 localRayDir = vec3(texCoord.x - 0.5, texCoord.y - 0.5, 1)*vec3(nearClipWidth, nearClipHeight, CoronaVertexUserData.w);
   // Construct a rotation matrix from camera space to world space
P_DEFAULT mat3 rotationMatrix = mat3(
  camRight,
  camUp,
  -camDir
);

// Transform localRayDir from camera space to world space
P_DEFAULT vec3 rayDir = rotationMatrix * localRayDir;
rayDir = normalize(rayDir);

    Ray ray;
    ray.origin = vec3(0,0,0);
    ray.direction = rayDir;

    return vec4(0,rayHitSphere(ray, vec3(0,0,0.5), 1.0).distance,0,0);
    
} 