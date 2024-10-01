-- Get the local player and character, wait if character hasn't loaded yet
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Define the target and initial teleport positions
local targetPosition = Vector3.new(-56, -361, 9499)
local initialPosition = Vector3.new(-40, 18, 1142)

-- Flag to control the teleport loop
local shouldTeleport = true

-- Function to simulate teleportation without visible movement
local function teleportTo(position)
    -- Store the current camera position
    local camera = workspace.CurrentCamera

    -- Set the camera to Scriptable mode for free movement
    camera.CameraType = Enum.CameraType.Scriptable

    -- Teleport the character to the new position
    humanoidRootPart.CFrame = CFrame.new(position)

    -- Wait a moment to simulate the teleportation delay
    wait(0.1)

    -- Restore the camera position after teleportation
    camera.CFrame = CFrame.new(humanoidRootPart.Position + Vector3.new(0, 5, -10), humanoidRootPart.Position)  -- Adjusting camera to follow character
end

-- Function to control the teleportation process
local function teleportLoop()
    while shouldTeleport do
        -- Ensure the character and humanoidRootPart exist
        if character and humanoidRootPart then
            -- Teleport to the initial position
            teleportTo(initialPosition)
            
            -- Wait for 2 seconds before the next teleport
            wait(1.4)
            
            -- Teleport to the target position
            teleportTo(targetPosition)
            
            -- Wait for 18 seconds before restarting the loop
            wait(10)
        else
            -- If the character does not exist, wait and check again
            character = player.Character or player.CharacterAdded:Wait()
            humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        end
    end
end

-- Start the teleport loop using spawn to avoid blocking the main thread
spawn(teleportLoop)  -- This will start the loop in a separate thread

-- Control free camera movement (WASD keys and touch controls)
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Variables for mobile controls
local moveSpeed = 10 -- Change this value to adjust speed
local camera = workspace.CurrentCamera
local lastTouchPosition = nil

-- Function to update the camera position based on touch input
local function onTouchInput(touch, isTouchEnded)
    if isTouchEnded then
        lastTouchPosition = nil
        return
    end

    local touchPosition = touch.Position
    if lastTouchPosition then
        local delta = touchPosition - lastTouchPosition

        -- Adjust the camera's CFrame based on the delta from the last touch position
        local cameraRotationSpeed = 0.5 -- Adjust this value for camera rotation sensitivity
        camera.CFrame = camera.CFrame * CFrame.Angles(0, -delta.X * cameraRotationSpeed, 0)
        camera.CFrame = camera.CFrame * CFrame.Angles(-delta.Y * cameraRotationSpeed, 0, 0)
    end

    lastTouchPosition = touch.Position
end

-- Connect touch input events for mobile controls
UserInputService.TouchMoved:Connect(function(touch)
    onTouchInput(touch, false)
end)

UserInputService.TouchEnded:Connect(function(touch)
    onTouchInput(touch, true)
end)

-- Function to update the camera position based on movement
local function onUpdate()
    -- Ensure the camera is in scriptable mode for free movement
    if camera.CameraType == Enum.CameraType.Scriptable then
        -- Get the forward and right vectors of the camera
        local moveDirection = Vector3.new(0, 0, 0)

        -- Determine the movement direction based on touch input
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + camera.CFrame.RightVector
        end

        -- Move the camera based on input
        camera.CFrame = camera.CFrame + (moveDirection * moveSpeed * task.wait())
    end
end

-- Connect to the RenderStepped event for smooth camera movement
RunService.RenderStepped:Connect(onUpdate)

-- Update character and humanoidRootPart references when the character respawns
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoidRootPart = newCharacter:WaitForChild("HumanoidRootPart")
end)
