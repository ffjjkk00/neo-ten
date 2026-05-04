local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- สร้าง Window
local Window = Rayfield:CreateWindow({
   Name = "All-in-One Tennis Script | ffjjkk00",
   LoadingTitle = "Tennis Pro Hub",
   LoadingSubtitle = "by Gemini",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "TennisScriptConfig",
      FileName = "Settings"
   }
})

-- ค่าเริ่มต้น (Global Variables)
getgenv().PowerValue = 100
getgenv().PerfectMode = true

-- สร้าง Tab หลัก
local MainTab = Window:CreateTab("Main Settings", 4483362458) -- ไอคอนฟันเฟือง

-- ส่วนประกอบของ UI
local Section = MainTab:CreateSection("Server & Hit Controls")

MainTab:CreateToggle({
   Name = "Perfect Mode (ตีติด Perfect)",
   CurrentValue = true,
   Flag = "PerfectModeToggle",
   Callback = function(Value)
      getgenv().PerfectMode = Value
   end,
})

MainTab:CreateSlider({
   Name = "Power Value (ความแรง)",
   Range = {0, 500},
   Increment = 1,
   Suffix = "Power",
   CurrentValue = 100,
   Flag = "PowerSlider",
   Callback = function(Value)
      getgenv().PowerValue = Value
   end,
})

-- เมธอด Metatable Hook (ตัวดั้งเดิมที่คุณให้มา)
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if method == "InvokeServer" or method == "FireServer" then
        
        -- จัดการการ Serve
        if tostring(self) == "ServeRF" then
            args[1].Power = getgenv().PowerValue
            args[1].RotateType = 3
            return old(self, unpack(args))
        end

        -- จัดการการตีลูก (HitBall)
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
   Title = "Script Loaded!",
   Content = "พร้อมใช้งานแล้วครับ ffjjkk00",
   Duration = 5,
   Image = 4483362458,
})
