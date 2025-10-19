-- Script Name: Auto Tennis Utility with Menu (FINAL REVISION)
-- Purpose: Fixes GUI loading and uses minimal, robust remote calls for execution.

-- Core Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- State Variables
local IsActive = false

-- =========================================================================================
-- UTILITY FUNCTIONS
-- =========================================================================================

-- Function to safely find a remote event/function
local function findRemote(remoteName)
    local remotesFolder = ReplicatedStorage:FindFirstChild("Remotes")
    if remotesFolder then
        return remotesFolder:FindFirstChild(remoteName)
    end
    return nil
end

local function toggleState(newState)
    IsActive = newState
    local ToggleButton = LocalPlayer.PlayerGui.AutoTennisMenu.MenuFrame.ToggleButton

    if IsActive then
        ToggleButton.Text = "TOGGLE: ON (Active)"
        ToggleButton.BackgroundColor3 = Color3.new(0, 0.6, 0) -- Green
    else
        ToggleButton.Text = "TOGGLE: OFF (Paused)"
        ToggleButton.BackgroundColor3 = Color3.new(0.6, 0, 0) -- Red
    end
end

-- =========================================================================================
-- AUTOMATION LOGIC (Simplified and More Robust)
-- =========================================================================================

-- The main loop that tries to hit the ball
RunService.Heartbeat:Connect(function()
    if not IsActive then return end

    -- The game likely uses a single Remote Function for all shot types (HitBall)
    local HitBallRF = findRemote("HitBallRF") 
    
    if HitBallRF and LocalPlayer.Character then
        local character = LocalPlayer.Character
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        
        -- You saw a "Hit Power" bar, so the game is looking for an argument related to power.
        -- We'll try to invoke the server with the minimal arguments needed.

        -- Attempt 1: Minimal Invoke (most likely to bypass complex checks)
        local success, result = pcall(HitBallRF.InvokeServer, HitBallRF, {
            HitBallType = 1, -- Try a default shot type
            Power = 100      -- Try max power
        })
        
        -- Attempt 2: If the game doesn't like a table, try multiple arguments (less common for modern games)
        -- local success, result = pcall(HitBallRF.InvokeServer, HitBallRF, 100, 1)

        if not success then
            -- print("Error invoking HitBallRF:", result) -- Uncomment for debugging
        end
    end
end)

-- Separate function to handle the serve (usually a specific remote)
local function executeServe()
    if not IsActive then return end
    
    local TossBallRE = findRemote("TossBallRE") -- Event for the toss/jump
    local ServeRF = findRemote("ServeRF")       -- Function for the final hit
    
    if TossBallRE then
        TossBallRE:FireServer()
        task.wait(0.1) -- Wait for the ball to be tossed
    end

    if ServeRF then
        -- The serve likely needs a rotation type and power to be considered valid
        pcall(ServeRF.InvokeServer, ServeRF, {
            RotateType = 1, -- Default spin
            Power = 100     -- Max power
        })
    end
end

-- Create a loop to spam the serve attempt when the player is in the serving position
task.spawn(function()
    while true do
        if IsActive then
            -- This wait is critical. Too fast, and you might get kicked.
            task.wait(0.7) 
            executeServe()
        end
        task.wait(0.2)
    end
end)

-- =========================================================================================
-- GUI (MENU) CREATION & FUNCTIONALITY (FIXED)
-- =========================================================================================

-- Wait until the PlayerGui is available before creating the GUI
task.wait(1) 

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoTennisMenu"
ScreenGui.Parent = PlayerGui

local MenuFrame = Instance.new("Frame")
MenuFrame.Size = UDim2.new(0, 200, 0, 80)
-- Centered position (better than the previous fixed value)
MenuFrame.Position = UDim2.new(0.5, -100, 0.85, -40) 
MenuFrame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
MenuFrame.BorderSizePixel = 0
MenuFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 20)
Title.Text = "Auto Neo Tennis"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
Title.Parent = MenuFrame

local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton" -- Added Name for better access in toggleState
ToggleButton.Size = UDim2.new(1, -20, 0, 30)
ToggleButton.Position = UDim2.new(0, 10, 0, 40)
ToggleButton.Text = "TOGGLE: OFF (Paused)"
ToggleButton.TextColor3 = Color3.new(1, 1, 1)
ToggleButton.BackgroundColor3 = Color3.new(0.6, 0, 0)
ToggleButton.Parent = MenuFrame

-- BUTTON FUNCTIONALITY
ToggleButton.MouseButton1Click:Connect(function()
    toggleState(not IsActive)
end)

-- Initialize the script state
toggleState(false)
