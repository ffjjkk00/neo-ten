-- =========================================================================================
-- GUI TOGGLE & KEYBIND FUNCTIONALITY
-- =========================================================================================

local UserInputService = game:GetService("UserInputService")
local GuiTarget = game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")
local ScreenGui = GuiTarget:FindFirstChild("AutoTennisMenu", true)

-- Ensure the GUI elements are accessible
local MenuFrame = ScreenGui and ScreenGui:FindFirstChild("MenuFrame")

-- Function to handle the key press
local function onKeyPress(input, gameProcessedEvent)
    -- 'gameProcessedEvent' ensures we don't toggle if the player is typing in chat/textbox
    if gameProcessedEvent then
        return
    end

    -- Check for the 'Insert' key
    if input.KeyCode == Enum.KeyCode.Insert then
        if MenuFrame then
            -- Toggle the visibility of the main frame
            MenuFrame.Visible = not MenuFrame.Visible
        end
    end
end

-- Connect the function to the InputBegan event
UserInputService.InputBegan:Connect(onKeyPress)

-- Make the MenuFrame visible by default when the script runs (Optional)
if MenuFrame then
    MenuFrame.Visible = true 
end

-- NOTE: You should still keep your MouseButton1Click connections for the AutoHit/AutoServe 
-- buttons as they are vital for controlling the hack's logic.
