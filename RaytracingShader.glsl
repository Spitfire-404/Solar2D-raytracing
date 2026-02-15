
const float fov = 90.0;
const float PI = 3.1415926535897932384626433832795897932384626433832795;
const float aspect = (1280.0/720.0);
const float nearClip = 0.001;

const int maxBounces = 60;
const int maxRaysPerPixel = 1;

struct Ray
{
    vec3 origin;
    vec3 direction;
};
struct Material {
    vec3 color;
    float emission;
    float roughness;
};

struct Sphere {
    vec3 position;
    float radius;
    Material material;
};

struct HitInfo
{
    bool didHit;
    P_DEFAULT float distance;
    P_DEFAULT vec3 point;
    P_DEFAULT vec3 normal;
    Sphere sphere;
};

vec3 position = vec3(0, 0, 0);

Sphere sphereArray[100];

HitInfo rayHitSphere(Ray ray, Sphere sphere)
{
    vec3 spherePosition = vec3(sphere.position);
    float sphereRadius = float(sphere.radius);
    HitInfo hit;
    hit.didHit = false;
    hit.sphere.material.color = vec3(0,0,0);
    

    vec3 vecDistFromSphere = spherePosition - ray.origin;
    float rayPen = dot(vecDistFromSphere, ray.direction);
    float rayPenDistFromCenter = abs(sqrt((length(vecDistFromSphere)*length(vecDistFromSphere)) - (rayPen*rayPen)));
    if (rayPenDistFromCenter < sphereRadius)
    {
        
        
        float rayPenDist = sqrt(((sphereRadius*sphereRadius) - (rayPenDistFromCenter*rayPenDistFromCenter)));
        hit.distance = rayPen - rayPenDist;
        if (hit.distance >= nearClip)
        {
            hit.didHit = true;
            hit.point = ray.origin + ray.direction * hit.distance;
            hit.normal = normalize(hit.point - spherePosition);
            hit.sphere = sphere;
        }
    }
    return hit;
}
vec3 rayTraceSpheres(Ray ray, Sphere spheres[100], int sphereCount, float rand, vec2 texCoord) {
    vec3 totalColor = vec3(1);
    for (int r = 0; r < maxRaysPerPixel; r++) {

        vec3 color = vec3(0,0,0);
        Ray stepRay = ray;
        vec3 tintColor = vec3(1);
        for (int b = 0; b < maxBounces; b++)
        {
            Sphere lastSphere;
            HitInfo hit;
            hit.didHit = false;
            float closestHit = 1.0/0.0;

            // get closest hit sphere
            for (int i = 0; i < sphereCount; i++)
            {   
                HitInfo tempHit = rayHitSphere(stepRay, spheres[i]);
                if (tempHit.didHit && tempHit.distance < closestHit && tempHit.sphere != lastSphere)
                {
                    closestHit = tempHit.distance;
                    hit = tempHit;
                }
                    //float value = float(texCoord.x + texCoord.y + CoronaTotalTime + (rand-0.5));
                    //stepRay.direction = normalize(vec3(texture2D(CoronaSampler0,vec2(CoronaTotalTime,rand+float(r))/texCoord).r,texture2D(CoronaSampler0,vec2(CoronaTotalTime,rand+float(r))/texCoord).g,texture2D(CoronaSampler0,vec2(CoronaTotalTime,rand+float(r))/texCoord).b))-0.5;
                    //if (dot(stepRay.direction, hit.normal) < 0.0 || mod(CoronaTotalTime,2.0) == 1.0)
                    //{
                    //    stepRay.direction = -stepRay.direction;
                    //}
            }   
            lastSphere = hit.sphere;

            // if nothing hit, sample the skybox
            if (!hit.didHit) {
                color = vec3(texture2D(CoronaSampler0,vec2(cos(stepRay.direction.x),-stepRay.direction.y)))*tintColor;
                break;
            }
            
            else
            {
                    // otherwise tint based on material
                    tintColor = (tintColor + hit.sphere.material.color)/2.0;

                    // setup ray for next bounce
                    stepRay.origin = hit.point;
                    stepRay.direction = reflect(stepRay.direction, hit.normal);
                if (hit.sphere.material.emission > 0.0)
                {
                    color = (tintColor * (hit.sphere.material.emission));
                    break;
                }
            }
        }
        totalColor = totalColor * color;
    }
    totalColor = totalColor/float(maxRaysPerPixel);
    return totalColor;
    
}

void test(inout Material material) {
    
}
int sphereCount = 0;

void addSphere(vec3 position, float radius, Material material) {
    Sphere newSphere;
    newSphere.position = position;
    newSphere.radius = radius;
    newSphere.material = material;
    sphereArray[sphereCount] = newSphere;
    sphereCount++;
}


Material copyMaterial(Material material) {
    return material;
}

P_COLOR vec4 FragmentKernel( P_UV vec2 texCoord )
{


    P_DEFAULT vec3 camDir = normalize(CoronaVertexUserData.xyz);
    P_DEFAULT vec3 camDirEpsilon = camDir + vec3(0.00001, 0.00001, 0.00001);
    P_DEFAULT vec3 camRight = normalize(cross(camDirEpsilon, vec3(0, 1, 0)));
    P_DEFAULT vec3 camUp = normalize(cross(camRight, camDirEpsilon));


    P_DEFAULT float nearClipHeight = (tan((PI/180.0)*(fov / 2.0)) * nearClip )*2.0;
    P_DEFAULT float nearClipWidth = nearClipHeight*aspect;
    P_DEFAULT vec3 localRayDir = vec3((1.0*texCoord.x - 0.5)/(2.0),(1.0* texCoord.y - 0.5)/(2.0), 1)*vec3(nearClipWidth, nearClipHeight, nearClip);
   // Construct a rotation matrix from camera space to world space
    P_DEFAULT mat3 rotationMatrix = mat3
    (
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



    Material lightMaterial;
    lightMaterial.color = vec3(1, 1, 1);
    lightMaterial.emission = 1.0;
    lightMaterial.roughness = 0.0;

    Material whiteMaterial;
    whiteMaterial.color = vec3(1.0, 1.0, 1.0);
    whiteMaterial.emission = 0.0;
    whiteMaterial.roughness = 0.1;

    Material redMaterial;
    redMaterial.color = vec3(0.8, 0.1, 0.1);
    redMaterial.emission = 0.0;
    redMaterial.roughness = 0.1;

    Material blueMaterial;
    blueMaterial.color = vec3(0.1, 0.1, 0.8);
    blueMaterial.emission = 0.0;
    blueMaterial.roughness = 0.1;
    

    addSphere(vec3(0, 100, 10), 99.8, blueMaterial);
    addSphere(vec3(0.5, 0, 2), 0.5, whiteMaterial);
    addSphere(vec3(0.5 + cos(CoronaTotalTime) * 1.0, -0.2, 2.0 + sin(CoronaTotalTime) * 1.0), 0.25, redMaterial);
    addSphere(vec3(10.0 * cos(CoronaTotalTime), 0, -1), 0.5, lightMaterial);



    vec4 texColor = texture2D( CoronaSampler0, texCoord);
    //return vec4(texColor);
    //return vec4(rayHitSphere(ray, testSphere).material.color,0);

    return vec4(rayTraceSpheres(ray, sphereArray, sphereCount, CoronaVertexUserData.w, texCoord), 0);
    //return vec4(rayHitSphere(ray, testSphere).didHit,0,0,0);
    //return (vec4(0,Random(texCoord + 2.01),0,0));
    //return vec4(ray.direction,0);
    //return vec4(CoronaVertexUserData.w,0,0,0);
}
