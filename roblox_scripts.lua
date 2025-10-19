-- Script Name: Auto Tennis Utility with Basic Menu (REVISED)
-- Purpose: Fixes ball-finding, implements proper GUI toggle logic, and adds Serve Toss command.

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
    -- REVISED: Added "Part" which is a common fallback name for simple physics objects.
    return Workspace:FindFirstChild("Ball") 
        or Workspace:FindFirstChild("TennisBall")
        or Workspace:FindFirstChild("Part") 
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

        if ball and character and camera and character:FindFirstChild("HumanoidRootPart") then
            local calculatedCamPos = camera.CFrame.p
            local calculatedHitPos = ball.Position
            local calculatedCamDir = camera.CFrame.LookVector
            local calculatedVelocity = character.HumanoidRootPart.Velocity or Vector3.new(0, 0, 0)

            local hitBallArgs = {
                {
                    CamPos = calculatedCamPos,
                    HitPos = calculatedHitPos,
                    HitBallType = 1, -- CHANGED: Testing Hit Type 1 (standard forehand/return)
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
    -- REVISED: Now attempts to send the ball toss command first.
    local TossBallRE = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("TossBallRE", 0.1) -- Assuming a Toss/Throw remote
    
    while IsActive do
        
        if TossBallRE then
            -- STEP 1: Send the toss/jump command (usually an Event, not a Function)
            TossBallRE:FireServer() 
        end
        
        -- STEP 2: Send the hit command
        local args = {
            {
                RotateType = 1, -- CHANGED: Testing RotateType 1
                Power = 85      -- CHANGED: Testing a non-perfect power
            }
        }
        
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ServeRF"):InvokeServer(unpack(args))
        task.wait(0.5) -- Increased speed of serve attempts
    end
end

-- =========================================================================================
-- GUI (MENU) CREATION (No changes here, only in the button logic below)
-- =========================================================================================

local PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoTennisMenu"
ScreenGui.Parent = PlayerGui

local MenuFrame = Instance.new("Frame")
MenuFrame.Size = UDim2.new(0, 200, 0, 80)
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
ToggleButton.BackgroundColor3 = Color3.new(0.8, 0, 0)
ToggleButton.Parent = MenuFrame

-- =========================================================================================
-- BUTTON FUNCTIONALITY (FIXED)
-- =========================================================================================

ToggleButton.MouseButton1Click:Connect(function()
    if IsActive then
        -- TURN OFF (FIXED: Threads are now correctly cancelled)
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
