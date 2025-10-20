-- =========================================================================================
-- GUI TOGGLE & KEYBIND FUNCTIONALITY
-- =========================================================================================

local UserInputService = game:GetService("UserInputService")
local GuiTarget = game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")
local ScreenGui = GuiTarget:FindFirstChild("AutoTennisMenu", true)

local mainTab = window:CreateTab("Main")
local playerTab = window:CreateTab("Player")
local gameTab = window:CreateTab("Game")
local miscTab = window:CreateTab("Misc")

mainTab:CreateSection("Money stuff")
mainTab:CreateButton({
    Name = "Add money",
    Callback = function()
        toggleMoney()
    end
})

mainTab:CreateToggle({
    Name = "Auto money",
    Callback = function()
        isAutoMoney = not isAutoMoney
        task.spawn(toggleMoney(true))
    end
})

mainTab:CreateSlider({
    Name = "Auto money interval (seconds)",
    Range = { 0.0, 3.0 },
    Increment = 0.1,
    Suffix = "sec",
    CurrentValue = 0.4,
    Flag = "AutoMoneyIntervalSlider",
    Callback = function(interval)
        autoMoneyInterval = interval
    end
})

mainTab:CreateSection("Slot machines stuff")
mainTab:CreateButton({
    Name = "Activate slot machines",
    Callback = function()
        task.spawn(toggleSlotMachines())
    end
})

mainTab:CreateToggle({
    Name = "Auto slot machines",
    Callback = function()
        isAutoSlotMachine = not isAutoSlotMachine
        task.spawn(toggleSlotMachines(true))
    end
})

mainTab:CreateSlider({
    Name = "Slot machine range",
    Range = { 0, 1000 },
    Increment = 10,
    Suffix = "studs",
    CurrentValue = 50,
    Flag = "SlotMachineRangeSlider",
    Callback = function(range)
        slotMachineRange = range
    end
})

mainTab:CreateSlider({
    Name = "Slot machine interval",
    Range = { 2, 10 },
    Increment = 1,
    Suffix = "sec",
    CurrentValue = 5,
    Flag = "SlotMachineIntervalSlider",
    Callback = function(interval)
        autoSlotMachineInterval = interval
    end
})

playerTab:CreateSlider({
    Name = "Walk speed",
    Range = { 0, 100 },
    Increment = 1,
    Suffix = "",
    CurrentValue = hmd.WalkSpeed,
    Flag = "WalkSpeedSlider",
    Callback = function(speed)
        hmd.WalkSpeed = speed
    end
})

playerTab:CreateSlider({
    Name = "Jump power",
    Range = { 0, 500 },
    Increment = 1,
    Suffix = "",
    CurrentValue = hmd.JumpPower,
    Flag = "JumpPowerSlider",
    Callback = function(power)
        hmd.JumpPower = power
    end
})

gameTab:CreateSection("Casino teleports")
for _, loc in ipairs(casinoLocations) do
    gameTab:CreateButton({
        Name = loc.name,
        Callback = function()
            hmdRoot.CFrame = loc.pos
        end
    })
end

miscTab:CreateButton({
    Name = "Unload script",
    Callback = function()
        isAutoMoney = false
        isAutoSlotMachine = false
        rayfield:Destroy()
    end
})

-- NOTE: You should still keep your MouseButton1Click connections for the AutoHit/AutoServe 
-- buttons as they are vital for controlling the hack's logic.

