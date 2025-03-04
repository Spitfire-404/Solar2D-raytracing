Camera = {
    x = 0,
    y = 0,
    z = 0,

    direction = {0, 0, 1.0},
    fov = 90,
    near = 1,
    far = 1000,
    aspect = display.actualContentWidth / display.actualContentHeight,

    nearPlaneWidth = nil,
    nearPlaneHeight = nil
}

Camera.nearPlaneWidth = 2 * (math.tan(math.rad(Camera.fov / 2)) * Camera.near)
Camera.nearPlaneHeight = Camera.nearPlaneWidth * Camera.aspect
