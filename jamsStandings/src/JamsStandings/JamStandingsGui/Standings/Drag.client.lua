local frame = script.Parent
local mouse = game.Players.LocalPlayer:GetMouse()

local active = false

function ScrollFunction()
	
	active = true
	local startPos = mouse.Y
	local current = frame.Position.Y.Offset
	
	mouse.Move:connect(function()
		
		if active then
			local delta = mouse.Y - startPos
			frame.Position = UDim2.new(0, 50, 0.3, current + delta - 200)
		end	
		
	end)
	
	mouse.Button1Up:connect(function()
		
		active = false
		return
		
	end)
	
	frame.MouseButton1Up:connect(function()
		
		active = false
		return
		
	end)
	
end

frame.MouseButton1Down:connect(ScrollFunction)