
local kernel = {
    category = "filter",
    name = "test",
    fragment = io.open("RaytracingShader.glsl", "r"):read("*all")
    --fragment = io.open("random.glsl", "r"):read("*all")
}
kernel.isTimeDependent = true
kernel.vertexData =
{
    {
        name = "x",
        default = 0, 
        min = -1,
        max = 1,
        index = 0,
    },
    {
        name = "y",
        default = 0, 
        min = -1,
        max = 1,
        index = 1,
    },  
    {
        name = "z",
        default = 0, 
        min = -1,
        max = 1,
        index = 2,
    },
    {
        name = "w",
        default = 0, 
        min = 0,
        max = 1000,
        index = 3,
    },
}

graphics.defineEffect(kernel)
