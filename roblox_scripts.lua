--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
    
    NOTE: Auto Hit works because the server accepts the dummy data.
    Auto Serve has been modified with extra dummy arguments (Position, ClientTick) 
    to bypass stricter server validation.
]]

--Auto Hit (DO NOT CHANGE THE VALUES!)
if not game:IsLoaded() then
	game.Loaded:Wait()
end

-- Auto Hit Loop: Continuously fires the HitBall Remote Function
while true do
    local hitBallArgs = {
        {
            CamPos = Vector3.new(0, 0, 0),
            HitPos = Vector3.new(0, 0, 0),
            HitBallType = 0,
            ClientTick = 0,
            CamDir = Vector3.new(0, 0, 0),
            AttackMoveSpeed = Vector3.new(0, 0, 0)
        }
    }

    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("HitBallRF"):InvokeServer(unpack(hitBallArgs))
    task.wait()
end

--Auto Serve (Modified with extra arguments for reliability)

if not game:IsLoaded() then
	game.Loaded:Wait()
end

-- Auto Serve Loop: Continuously fires the Serve Remote Function
while true do
    local args = {
	{
		RotateType = 0, -- Spin type: 0, 1, 2 ,3 (try other numbers if 0 fails)
		Power = 100, -- Speed of the ball (Max 100)
        
        -- **NEW DUMMY ARGUMENTS ADDED FOR SERVER VALIDATION:**
        Position = Vector3.new(0, 0, 0),
        ClientTick = math.random(100000, 999999) 
	}
}

    -- NOTE: You may need to change the 'task.wait(0.2)' if it is still not working
    -- A higher number can bypass aggressive anti-spam measures.
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ServeRF"):InvokeServer(unpack(args))
    task.wait(0.2) 
end
