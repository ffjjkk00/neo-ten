-- [[ ดึง UI Library มาใช้งาน ]]
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- [[ สร้างหน้าต่างหลัก ]]
local Window = Rayfield:CreateWindow({
   Name = "Tennis All-in-One 🎾",
   LoadingTitle = "Script by ffjjkk00",
   LoadingSubtitle = "Gemini UI Edition",
   ConfigurationSaving = {
      Enabled = false -- ปิดไว้ก่อนเพื่อให้รันง่ายที่สุด
   }
})

-- [[ ตั้งค่าตัวแปร (ใช้ Logic ของคุณ) ]]
getgenv().PowerValue = 100
getgenv().PerfectMode = true
getgenv().ScriptEnabled = true

-- [[ สร้างเมนูควบคุม ]]
local Tab = Window:CreateTab("Settings", 4483362458)

Tab:CreateSection("Main Controls")

Tab:CreateToggle({
   Name = "Enable Script (เปิด/ปิด ระบบ)",
   CurrentValue = true,
   Callback = function(Value)
      getgenv().ScriptEnabled = Value
   end,
})

Tab:CreateToggle({
   Name = "Perfect Mode (บังคับ Perfect)",
   CurrentValue = true,
   Callback = function(Value)
      getgenv().PerfectMode = Value
   end,
})

Tab:CreateSlider({
   Name = "Power (ความแรง)",
   Range = {0, 300},
   Increment = 10,
   Suffix = "Power",
   CurrentValue = 100,
   Callback = function(Value)
      getgenv().PowerValue = Value
   end,
})

-- [[ ระบบเบื้องหลัง (Logic ที่คุณต้องการ) ]]
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    -- ถ้ากดปิดสคริปต์ใน UI ให้ทำงานปกติ
    if not getgenv().ScriptEnabled then 
        return old(self, ...) 
    end

    if method == "InvokeServer" or method == "FireServer" then
        -- แก้ไขการ Serve
        if tostring(self) == "ServeRF" then
            args[1].Power = getgenv().PowerValue
            args[1].RotateType = 3
            return old(self, unpack(args))
        end

        -- แก้ไขการตี (HitBallRF)
        if tostring(self) == "HitBallRF" then
            if getgenv().PerfectMode then
                args[1].HitBallType = 7 
            end
            
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


Rayfield:Notify({
   Title = "Success!",
   Content = "สคริปต์ทำงานแล้ว ปรับค่าได้ในเมนูเลย",
   Duration = 5,
   Image = 4483362458,
})

print("Tennis Script Loaded Successfully!")
