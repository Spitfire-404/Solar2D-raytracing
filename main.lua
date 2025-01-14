-----------------------------------------------------------------------------------------
--
-- main.lua
--
-- This is the main entry point for the application. It sets up a single rectangle
-- that covers the entire screen, and applies a custom shader to it. The shader is
-- defined in the shader.lua file.
--
-----------------------------------------------------------------------------------------

display.setStatusBar(display.HiddenStatusBar)
require("RaytracingManager")
require("shapes")
require("cameraManager")

-- Create a rectangle that covers the entire screen
local rect = display.newRect(display.contentCenterX,display.contentCenterY,display.actualContentWidth,display.actualContentHeight)

-- Apply the custom shader to the rectangle
rect.fill.effect = "filter.custom.test"

-- Create a text object to display the current frame rate
local fpsText = display.newText("fps: ", display.contentCenterX, display.contentHeight - 20)
fpsText:setFillColor(1,0.2,0.2)
-- Variables to keep track of the current frame rate
local current,dt,fps,prevFrameTime = 0,0,0,0
-- Function to calculate the current frame rate
local function getFPS(time)
    -- Calculate the delta time since the last frame
    current = time
    dt = time - prevFrameTime

    -- Calculate the frame rate to two decimal places
    fps = 1000 / dt
    fps = math.floor(fps*100)/100

    -- Update the frame rate text object
    fpsText.text = "fps: "..fps

    -- Save the current time for the next frame
    prevFrameTime = current
end

local i = 0
-- Flag to indicate whether the update function can be called
local canUpdate = true
-- Function to update the frame rate every frame
function update(time)
  -- Make sure the update function isn't called recursively
  canUpdate = false

  -- Calculate the current frame rate
  getFPS(time)

  -- Increment a counter to keep track of the number of frames
  i = i +1


  fpsText.text = "fps: "..fps
  rect.fill.effect = "filter.custom.test"
  rect.fill.effect.x = Camera.direction[1]
  rect.fill.effect.y = Camera.direction[2]
  rect.fill.effect.z = Camera.direction[3]
  rect.fill.effect.w = Camera.near
  -- Allow the update function to be calledrr again
  canUpdate = true
end

-- Function to call the update function every frame, but only if it's safe to do so
function tryUpdate(event)
  if canUpdate then
    update(event.time)
  end
end

Runtime:addEventListener("enterFrame", tryUpdate)

--Runtime:addEventListener("enterFrame", getFPS)

