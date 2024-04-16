local service = {}

-- Variables
frame = script.Parent.Parent.Parent.Settings

function service:GetLaps(): number
	
	local laps = tonumber(frame.Laps.TextBox.Text)
	if laps > 0 then
		return laps
	end
	
end

function service:GetTimer(): number

	local timer = tonumber(frame.Quali.TextBox.Text)
	if timer > 0 then
		return timer
	end

end

function CloseSettings()
	
	frame.Visible = false
	
end

function service:Init()
	
	frame.Close.MouseButton1Click:Connect(CloseSettings)
	
end

return service
