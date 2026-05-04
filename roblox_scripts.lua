getgenv().PowerValue = 100 -- [[ editable ]]
getgenv().PerfectMode = true

local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if method == "InvokeServer" or method == "FireServer" then
       
        if tostring(self) == "ServeRF" then
            args[1].Power = getgenv().PowerValue
            args[1].RotateType = 3
            return old(self, unpack(args))
        end

       
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
print("All-in-One Tennis Script: ffjjkk00")
