-- โหลด Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- ตั้งค่าตัวแปร Global (ต้องประกาศก่อน Hook ทำงาน)
getgenv().PowerValue = 100
getgenv().PerfectMode = true

-- สร้างหน้าต่าง UI
local Window = Rayfield:CreateWindow({
   Name = "All-in-One Tennis Script | ffjjkk00",
   LoadingTitle = "Tennis Pro Hub",
   LoadingSubtitle = "by ffjjkk00",
   ConfigurationSaving = { Enabled = false }
})

local MainTab = Window:CreateTab("Main Settings", 4483362458)

-- ปุ่มเปิด/ปิด Perfect Mode
MainTab:CreateToggle({
   Name = "Perfect Mode (ตีติด Perfect)",
   CurrentValue = true,
   Flag = "PerfectModeToggle",
   Callback = function(Value)
      getgenv().PerfectMode = Value
   end,
})

-- ตัวเลื่อนความแรง
MainTab:CreateSlider({
   Name = "Power Value (ความแรง)",
   Range = {0, 1000},
   Increment = 1,
   Suffix = "Power",
   CurrentValue = 100,
   Flag = "PowerSlider",
   Callback = function(Value)
      getgenv().PowerValue = Value
   end,
})

--- ฟังก์ชัน Metatable Hook (ตัวสำคัญที่ใช้ตีแรง) ---
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if method == "InvokeServer" or method == "FireServer" then
        
        -- ส่วนการ Serve
        if tostring(self) == "ServeRF" then
            args[1].Power = getgenv().PowerValue
            args[1].RotateType = 3
            return old(self, unpack(args))
        end

        -- ส่วนการตีลูก (HitBall)
        if tostring(self) == "HitBallRF" then
            -- เช็คว่าเปิด Perfect Mode ใน UI หรือไม่
            if getgenv().PerfectMode then
                args[1].HitBallType = 7 
            end
            
            -- ปรับค่าความแรงจาก Slider ใน UI
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
   Content = "ระบบตีแรงและ Perfect พร้อมใช้งานแล้วครับ",
   Duration = 5,
})
