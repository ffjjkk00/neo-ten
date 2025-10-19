-- Script Name: Auto Neo Tennis (Exploit-Level Revision)
-- Purpose: Fixes GUI visibility and uses simplified, aggressive remote calls.

-- =========================================================================================
-- CORE SERVICES & STATE
-- =========================================================================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- State Variables for the Toggles
local IsAutoHitActive = false
local IsAutoServeActive = false

-- Remote Events/Functions (Caching them once)
local HitBallRemote = nil -- We'll try to find both the RF and RE version
local ServeRemote = nil
local TossBallRemote = nil

-- Function to safely find a remote event/function
local function findRemote(remoteName)
    local remotesFolder = ReplicatedStorage:FindFirstChild("Remotes")
    if remotesFolder then
        return remotesFolder:FindFirstChild(remoteName)
    end
    -- Fallback: Check ReplicatedStorage directly in case the "Remotes" folder is gone
    return ReplicatedStorage:FindFirstChild(remoteName)
end

-- =========================================================================================
-- GUI (MENU) CREATION & FUNCTIONALITY (FIXED for Visibility)
-- =========================================================================================

-- IMPORTANT FIX: Use CoreGui if available, otherwise default to PlayerGui
local GuiTarget = game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoTennisMenu"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global -- Ensures it's on top
ScreenGui.Parent = GuiTarget

local MenuFrame = Instance.new("Frame")
MenuFrame.Size = UDim2.new(0, 200, 0, 115) -- Increased size for 2 buttons
MenuFrame.Position = UDim2.new(0.5, -100, 0.85, -57) -- Centered
MenuFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
MenuFrame.BorderSizePixel = 0
MenuFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 20)
Title.Text = "Auto Neo Tennis"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
Title.Parent = MenuFrame

-- Helper function to create buttons
local function createToggle(name, yPos)
    local button = Instance.new("TextButton")
    button.Name = name .. "Button"
    button.Size = UDim2.new(1, -20, 0, 30)
    button.Position = UDim2.new(0, 10, 0, yPos)
    button.Text = name .. ": OFF"
    button.TextColor3 = Color3.new(1, 1, 1)
    button.BackgroundColor3 = Color3.new(0.6, 0, 0)
    button.Parent = MenuFrame
    return button
end

local AutoHitButton = createToggle("AutoHit", 30)
local AutoServeButton = createToggle("AutoServe", 70)

local function updateButton(button, isActive)
    button.Text = button.Name:gsub("Button", "") .. (isActive and ": ON" or ": OFF")
    button.BackgroundColor3 = isActive and Color3.new(0, 0.6, 0) or Color3.new(0.6, 0, 0)
end

AutoHitButton.MouseButton1Click:Connect(function()
    IsAutoHitActive = not IsAutoHitActive
    updateButton(AutoHitButton, IsAutoHitActive)
end)

AutoServeButton.MouseButton1Click:Connect(function()
    IsAutoServeActive = not IsAutoServeActive
    updateButton(AutoServeButton, IsAutoServeActive)
end)

-- Initialize button states
updateButton(AutoHitButton, IsAutoHitActive)
updateButton(AutoServeButton, IsAutoServeActive)


-- =========================================================================================
-- AUTOMATION LOGIC (Aggressive/Simplified)
-- =========================================================================================

-- 1. Auto Hit Loop (Spamming the "Strike" remote)
task.spawn(function()
    HitBallRemote = findRemote("HitBallRF") or findRemote("HitBallRE")
    
    while true do
        if IsAutoHitActive and HitBallRemote then
            
            -- AGGRESSIVE ATTEMPT: Fire with NO arguments, which sometimes forces a default action.
            -- This bypasses all the complex camera/position/power arguments.
            if HitBallRemote:IsA("RemoteFunction") then
                pcall(HitBallRemote.InvokeServer, HitBallRemote)
            elseif HitBallRemote:IsA("RemoteEvent") then
                HitBallRemote:FireServer()
            end

            task.wait(0.01) -- Very fast loop to ensure the ball is caught
        end
        task.wait(0.01)
    end
end)


-- 2. Auto Serve Loop (Spamming the "Serve" remotes)
task.spawn(function()
    TossBallRemote = findRemote("TossBallRE") or findRemote("TossBallRF")
    ServeRemote = findRemote("ServeRF") or findRemote("ServeRE")

    while true do
        if IsAutoServeActive then
            if TossBallRemote then
                -- Step 1: Toss the ball
                if TossBallRemote:IsA("RemoteFunction") then
                    pcall(TossBallRemote.InvokeServer, TossBallRemote)
                else
                    TossBallRemote:FireServer()
                end
                
                task.wait(0.1) -- Short wait for the toss animation
            end

            if ServeRemote then
                -- Step 2: Hit the serve
                if ServeRemote:IsA("RemoteFunction") then
                    -- If it's a function, we'll send the minimal power argument again just in case
                    pcall(ServeRemote.InvokeServer, ServeRemote, { Power = 100 })
                else
                    ServeRemote:FireServer()
                end
            end
        end
        task.wait(0.5) -- Slow the serve loop down to avoid anti-cheat/kick
    end
end)
