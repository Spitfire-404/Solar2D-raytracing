--shapes.lua

local sphere ={
    name = "sphere",
    x = 0,
    y = 0,
    z = 0,
    radius = 0,
    init = function(self,x,y,z,radius)
        self.x = x
        self.y = y
        self.z = z
        self.radius = radius
    end
}
local cube = {
    name = "cube",
    x = 0,
    y = 0,
    z = 0,
    width = 0,
    height = 0,
    depth = 0,
    init = function(self,x,y,z,width,height,depth)
        self.x = x
        self.y = y
        self.z = z
        self.width = width
        self.height = height
        self.depth = depth
    end
}
local triangle = {
    name = "triangle",
    x1 = 0,
    y1 = 0,
    z1 = 0,
    x2 = 0,
    y2 = 0,
    z2 = 0,
    x3 = 0,
    y3 = 0,
    z3 = 0,
    init = function(self,x1,y1,z1,x2,y2,z2,x3,y3,z3)
        self.x1 = x1
        self.y1 = y1
        self.z1 = z1
        self.x2 = x2
        self.y2 = y2
        self.z2 = z2
        self.x3 = x3
        self.y3 = y3
        self.z3 = z3
    end
}
