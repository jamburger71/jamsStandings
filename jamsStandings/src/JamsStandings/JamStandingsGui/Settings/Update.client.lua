local storage = game:GetService("ReplicatedStorage")
local settingsEvent = storage:WaitForChild("StandingsSettingsEvent")

local frame = script.Parent

frame.Confirm.MouseButton1Click:connect(function()
	
	local laps = tonumber(frame.Laps.TextBox.Text)
	local quali = tonumber(frame.Quali.TextBox.Text)
	
	if laps > 0 then
		laps = math.floor(laps+0.5)
	else
		return
	end
	
	if quali > 0 then
		quali = math.floor(quali+0.5)
	else
		return
	end
	
	settingsEvent:FireServer(laps,quali)
	
	frame.Visible = false
	
end)

frame.Cancel.MouseButton1Click:connect(function()
	
	frame.Visible = false
	
end)