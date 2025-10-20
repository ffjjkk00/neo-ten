if not game:IsLoaded() then
	game.Loaded:Wait()
end

while true do
    local args = {
	{
		RotateType = 0, --0, 1, 2 ,3
		Power = 100 --Speed Of The Ball (Max 100)
	}
}


game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ServeRF"):InvokeServer(unpack(args))
task.wait()
end
