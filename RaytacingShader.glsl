const float fov = 90.0;
const float PI = 3.1415926535897932384626433832795897932384626433832795;
const float aspect = (1280.0/720.0);
const float nearClip = 1.0;

const vec3 lightDir = vec3(0.5,1,-0.5);

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
    P_COLOR vec3 color;
};
struct material{
    vec3 color;
    float emission;
    vec3 emissionColor;
};
struct sphere{
    vec3 position;
    float radius;
    material material;
};

vec3 position = vec3(0,0,0);
void handleInput(float keyinput)
{
    if (keyinput == 1.0){
        position.z = position.z + 1.0;
    }else{
        if(keyinput == 2.0){
            position.x = position.x - 1.0;
            }else{
                if(keyinput == 3.0){
                    position.z = position.z - 1.0;
                    }else{
                        if(keyinput == 4.0){
                            position.x = position.x + 1.0;
                        }
                    }
            }
    }
}
hitInfo rayHitSphere(Ray ray, sphere sphere)
{
    vec3 spherePosition = vec3(sphere.position);
    float sphereRadius = float(sphere.radius);
    hitInfo hit;
    hit.didHit = false;
    hit.color = vec3(0,0,0);

    vec3 vecDistFromSphere = spherePosition - ray.origin;
    float rayPen = dot(vecDistFromSphere, ray.direction);
    float rayPenDistFromCenter = sqrt((length(vecDistFromSphere)*length(vecDistFromSphere)) - (rayPen*rayPen));
    if (rayPenDistFromCenter <= sphereRadius)
    {
        
        
        float rayPenDist = sqrt(((sphereRadius*sphereRadius) - (rayPenDistFromCenter*rayPenDistFromCenter)));
        hit.distance = rayPen - rayPenDist;
        if (hit.distance > nearClip)
        {
            hit.didHit = true;
            hit.point = ray.origin + ray.direction * hit.distance;
            hit.normal = normalize(hit.point - spherePosition);
            hit.color = (vec3(1,1,1)*dot(-lightDir,hit.normal))/2.0+0.5;
        }
    }
    return hit;
}



P_COLOR vec4 FragmentKernel( P_UV vec2 texCoord )
{
handleInput(CoronaVertexUserData.w);

    P_DEFAULT vec3 camDir = normalize(CoronaVertexUserData.xyz);
    P_DEFAULT vec3 camDirEpsilon = camDir + vec3(0.00001, 0.00001, 0.00001);
    P_DEFAULT vec3 camRight = normalize(cross(camDirEpsilon, vec3(0, 1, 0)));
    P_DEFAULT vec3 camUp = normalize(cross(camRight, camDirEpsilon));


    P_DEFAULT float nearClipHeight = (tan((PI/180.0)*(fov / 2.0)) * nearClip )*2.0;
    P_DEFAULT float nearClipWidth = nearClipHeight*aspect;
    P_DEFAULT vec3 localRayDir = vec3((1.0*texCoord.x - 0.5)/(aspect),(1.0* texCoord.y - 0.5)/(aspect), 1)*vec3(nearClipWidth, nearClipHeight, nearClip);
   // Construct a rotation matrix from camera space to world space
P_DEFAULT mat3 rotationMatrix = mat3(
  -camRight,
  camUp,
  camDir
);



// Transform localRayDir from camera space to world space
P_DEFAULT vec3 rayDir = rotationMatrix * localRayDir;
rayDir = normalize(rayDir);

    Ray ray;
    ray.origin = position;
    ray.direction = rayDir;

    sphere testSphere;
    testSphere.radius = 0.5;
    testSphere.position = vec3(0,0,2);
    testSphere.material.color = vec3(1,1,1);

    return vec4(rayHitSphere(ray, testSphere).color,0);
    //return vec4(rayHitSphere(ray, testSphere).didHit,0,0,0);
    //return vec4(rayDir,0);
    
    //return vec4(CoronaVertexUserData.w,0,0,0);
} 