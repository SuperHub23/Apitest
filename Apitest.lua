-- Define the teleport coordinates
local targetPosition = Vector3.new(-56, -361, 9499)

-- Get the player's character
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Ensure the character has a HumanoidRootPart (the main part used for teleportation)
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Teleport the character to the target position
humanoidRootPart.CFrame = CFrame.new(targetPosition)
