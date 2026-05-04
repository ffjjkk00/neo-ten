local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Tennis All-in-One 🎾",
   LoadingTitle = "Script by ffjjkk00",
   LoadingSubtitle = "Gemini UI Edition",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "ffjjkk00_Settings",
      FileName = "Config"
   }
})

-- [[ 🛠️ ตัวแปรหลักจากโค้ดของคุณ ]]
getgenv().PowerValue = 100
getgenv().PerfectMode = true
getgenv().ServeModEnabled = true -- เพิ่มตัวเลือกเปิด/ปิดระบบ

-- [[ 📑 หน้าเมนู ]]
local Tab = Window:CreateTab("Main Settings", 4483362458)

Tab:CreateSection("Power & Perfect Control")

Tab:CreateToggle({
   Name = "Enable Script (เปิดใช้งานสคริปต์)",
   CurrentValue = true,
   Flag = "ScriptToggle",
   Callback = function(Value)
      getgenv().ServeModEnabled = Value
   end,
})

Tab:CreateToggle({
   Name = "Perfect Mode (ลูกตบ/Perfect)",
   CurrentValue = true,
   Flag = "PerfectToggle",
   Callback = function(Value)
      getgenv().PerfectMode = Value
   end,
})

Tab:CreateSlider({
   Name = "Hit/Serve Power",
   Range = {0, 300},
   Increment = 10,
   Suffix = "Power",
   CurrentValue = 100,
   Flag = "PowerSlider",
   Callback = function(Value)
      getgenv().PowerValue = Value
   end,
})

-- [[ ⚙️ ระบบเบื้องหลัง (ใช้ Logic เดิมของคุณทั้งหมด) ]]
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    -- เช็คว่าเปิดใช้งานสคริปต์อยู่หรือไม่
    if not getgenv().ServeModEnabled then 
        return old(self, ...) 
    end

    if method == "InvokeServer" or method == "FireServer" then
        -- ส่วนการ Serve
        if tostring(self) == "ServeRF" then
            args[1].Power = getgenv().PowerValue
            args[1].RotateType = 3
            return old(self, unpack(args))
        end

        -- ส่วนการตีลูก (HitBallRF)
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
   Title = "ffjjkk00 Script",
   Content = "โหลดหน้าเมนูสำเร็จ!",
   Duration = 5,
   Image = 4483362458,
})

print("All-in-One Tennis Script: ffjjkk00 with UI")
