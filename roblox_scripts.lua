-- Script Name: Auto Tennis Utility with Basic Menu
-- Purpose: Creates a simple toggle menu to control the Auto Hit and Auto Serve features.

if not game:IsLoaded() then
	game.Loaded:Wait()
end

-- Core Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

-- State Variables
local IsActive = false
local AutoHitThread = nil
local AutoServeThread = nil

-- =========================================================================================
-- UTILITY FUNCTIONS
-- =========================================================================================

local function findBall()
    -- !!! You may need to change "Ball" or "TennisBall" to the EXACT name used in the game !!!
    return Workspace:FindFirstChild("Ball") or Workspace:FindFirstChild("TennisBall") 
end

local function stopThreads()
    if AutoHitThread and AutoHitThread.Status ~= "dead" then
        task.cancel(AutoHitThread)
    end
    if AutoServeThread and AutoServeThread.Status ~= "dead" then
        task.cancel(AutoServeThread)
    end
end

-- =========================================================================================
-- AUTOMATION LOGIC
-- =========================================================================================

local function autoHitLoop()
    while IsActive do
        local ball = findBall()
        local character = LocalPlayer.Character
        local camera = Workspace.CurrentCamera

        if ball and character and camera then
            local calculatedCamPos = camera.CFrame.p
            local calculatedHitPos = ball.Position
            local calculatedCamDir = camera.CFrame.LookVector
            local calculatedVelocity = character:FindFirstChild("HumanoidRootPart") and character.HumanoidRootPart.Velocity or Vector3.new(0, 0, 0)

            local hitBallArgs = {
                {
                    CamPos = calculatedCamPos,
                    HitPos = calculatedHitPos,
                    HitBallType = 0,
                    ClientTick = tick(),
                    CamDir = calculatedCamDir,
                    AttackMoveSpeed = calculatedVelocity 
                }
            }
            
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("HitBallRF"):InvokeServer(unpack(hitBallArgs))
        end
        task.wait()
    end
end

local function autoServeLoop()
    while IsActive do
        local args = {
            {
                RotateType = 0, 
                Power = 100 
            }
        }
        
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ServeRF"):InvokeServer(unpack(args))
        task.wait(1) 
    end
end

-- =========================================================================================
-- GUI (MENU) CREATION
-- =========================================================================================

local PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoTennisMenu"
ScreenGui.Parent = PlayerGui

local MenuFrame = Instance.new("Frame")
MenuFrame.Size = UDim2.new(0, 200, 0, 80) -- Small, centered box
MenuFrame.Position = UDim2.new(0.5, -100, 0.8, -40)
MenuFrame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
MenuFrame.BorderSizePixel = 0
MenuFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 20)
Title.Text = "Auto Tennis"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
Title.Parent = MenuFrame

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(1, -20, 0, 30)
ToggleButton.Position = UDim2.new(0, 10, 0, 40)
ToggleButton.Text = "TOGGLE: OFF"
ToggleButton.TextColor3 = Color3.new(1, 1, 1)
ToggleButton.BackgroundColor3 = Color3.new(0.8, 0, 0) -- Red
ToggleButton.Parent = MenuFrame

-- =========================================================================================
-- BUTTON FUNCTIONALITY
-- =========================================================================================

ToggleButton.MouseButton1Click:Connect(function()
    if IsActive then
        -- TURN OFF
        IsActive = false
        stopThreads()
        ToggleButton.Text = "TOGGLE: OFF"
        ToggleButton.BackgroundColor3 = Color3.new(0.8, 0, 0) -- Red
    else
        -- TURN ON
        IsActive = true
        
        -- Start both loops on separate threads
        AutoHitThread = task.spawn(autoHitLoop)
        AutoServeThread = task.spawn(autoServeLoop)
        
        ToggleButton.Text = "TOGGLE: ON"
        ToggleButton.BackgroundColor3 = Color3.new(0, 0.8, 0) -- Green
    end
end)
