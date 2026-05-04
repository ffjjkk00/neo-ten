local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- [[ ไส้ในเดิมของคุณ ]]
getgenv().PowerValue = 100 
getgenv().PerfectMode = true
getgenv().ServeEnabled = true -- เพิ่มตัวเปิด/ปิด Serve

local Window = Rayfield:CreateWindow({
   Name = "Tennis Script | ffjjkk00",
   LoadingTitle = "Original Logic + UI",
   LoadingSubtitle = "by ffjjkk00",
   ConfigurationSaving = { Enabled = false }
})

local Tab = Window:CreateTab("Main Settings", 4483362458)

-- UI ปรับค่าให้ไส้ใน
Tab:CreateToggle({
   Name = "1. Serve แรง (Perfect Serve)",
   CurrentValue = true,
   Callback = function(Value)
      getgenv().ServeEnabled = Value
   end,
})

Tab:CreateToggle({
   Name = "2. ตีแรง (Perfect Hit)",
   CurrentValue = true,
   Callback = function(Value)
      getgenv().PerfectMode = Value
   end,
})

Tab:CreateSlider({
   Name = "Power Value (ความแรง)",
   Range = {0, 500},
   Increment = 10,
   CurrentValue = 100,
   Callback = function(Value)
      getgenv().PowerValue = Value
   end,
})

--- [[ เริ่มต้นไส้ในเดิม (Metatable Hook) ]] ---
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if method == "InvokeServer" or method == "FireServer" then
        
        -- ส่วนการ Serve (ใช้ ServeEnabled เช็คจาก UI)
        if tostring(self) == "ServeRF" and getgenv().ServeEnabled then
            args[1].Power = getgenv().PowerValue
            args[1].RotateType = 3
            return old(self, unpack(args))
        end

        -- ส่วนการตีลูก (ใช้ PerfectMode เช็คจาก UI)
        if tostring(self) == "HitBallRF" then
            
            if getgenv().PerfectMode then
                args[1].HitBallType = 7 
            end
            
            -- ปรับ Power ตาม UI
            if not args[1].ExtendParams then
                args[1].ExtendParams = {
                    RotateType = 3,
                    Power = getgenv().PowerValue
                }
            else
                args[1].ExtendParams.Power = getgenv().PowerValue
                args[1].ExtendParams.RotateType = 3
            end
            
            return old(self, unpack(args))
        end
    end

    return old(self, ...)
end)

setreadonly(mt, true)
print("All-in-One Tennis Script: ffjjkk00 (UI Integrated)")
