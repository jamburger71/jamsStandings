local storage = game:GetService("ReplicatedStorage")
local flagEvent = storage:WaitForChild("StandingsFlagEvent")

local flag = script.Parent.Flag
local data = workspace.StandingsScriptEnduranceEdition

local current = "red"

local thread

local extended = false

local finalLap = false

local function Flag(color,animate)
	
	if color == current then
		extended = not extended
	else
		extended = animate
		current = color
		if color == "cheq" then
			flag.Chequered.Visible = true
			flag.BackgroundColor3 = Color3.new(1,1,1)
			flag.TextLabel.Text = ""
		elseif color == "green" then
			flag.Chequered.Visible = false
			flag.BackgroundColor3 = Color3.new(0,170/255,0)
			flag.TextLabel.Text = "GREEN - GO NOW"
		elseif color == "yellow" then
			flag.Chequered.Visible = false
			flag.BackgroundColor3 = Color3.new(1,0.8,0)
			flag.TextLabel.Text = "YELLOW - NO OVERTAKING"
		elseif color == "prgp" then
			flag.Chequered.Visible = false
			flag.BackgroundColor3 = Color3.new(1,0.8,0)
			flag.TextLabel.Text = "PLEASE CLEAR UP CIRCUIT"
		elseif color == "s1" then
			flag.Chequered.Visible = false
			flag.BackgroundColor3 = Color3.new(1,0.8,0)
			flag.TextLabel.Text = "LOCAL - SECTOR 1"
		elseif color == "s2" then
			flag.Chequered.Visible = false
			flag.BackgroundColor3 = Color3.new(1,0.8,0)
			flag.TextLabel.Text = "LOCAL - SECTOR 2"
		elseif color == "s3" then
			flag.Chequered.Visible = false
			flag.BackgroundColor3 = Color3.new(1,0.8,0)
			flag.TextLabel.Text = "LOCAL - SECTOR 3"
		elseif color == "red" then
			flag.Chequered.Visible = false
			flag.BackgroundColor3 = Color3.new(0.9,0,0)
			flag.TextLabel.Text = "RED - RETURN TO PL"
		elseif color == "blue" then
			flag.Chequered.Visible = false
			flag.BackgroundColor3 = Color3.new(0,0,0.9)
			flag.TextLabel.Text = "BLUE - MOVE OVER"
		elseif color == "black" then
			flag.Chequered.Visible = false
			flag.BackgroundColor3 = Color3.new(0,0,0)
			flag.TextLabel.Text = "BLACK - PENALTY"
		elseif color == "white" then
			flag.Chequered.Visible = false
			flag.BackgroundColor3 = Color3.new(1,1,1)
			flag.TextLabel.Text = "WHITE - LAST LAP"
		elseif color == "pitopen" then
			flag.Chequered.Visible = false
			flag.BackgroundColor3 = Color3.new(0,170/255,0)
			flag.TextLabel.Text = "PIT LANE OPEN"
		elseif color == "pitclosed" then
			flag.Chequered.Visible = false
			flag.BackgroundColor3 = Color3.new(1,0.8,0)
			flag.TextLabel.Text = "PIT LANE CLOSED"
		end
	end
	if extended then
		for i = 1, 12 do
			local x = (1-(i/12))^2
			flag.Size = UDim2.new(1,0,0,26-21*x)
			wait(0.025)
		end
	else
		for i = 1, 12 do
			local x = (1-(i/12))^2
			flag.Size = UDim2.new(1,0,0,5+21*x)
			wait(0.025)
		end
	end
	
end

data.Timer.Changed:connect(function()
	
	if data.Mode.Value == "Quali" or data.Mode.Value == "RaceTimed" then
		local current = data.Timer.Value
		local hr = math.floor(current/3600)
		local min = math.floor(current/60)-60*hr
		local sec = math.floor((current)-60*min)-3600*hr
		if hr < 1 then
			hr = ""
		else
			hr = hr..":"
		end
		if sec < 10 then
			sec = "0"..sec
		end
		if min < 10 then
			min = "0"..min
		end
		script.Parent.Label.Text = "Time"
		script.Parent.Value.Text = hr..min..":"..sec
		
		if current == 0 then
			if data.Mode.Value == "Quali" then
				Flag("cheq",true) 
			else
				Flag("white",true)
				finalLap = true
			end
		else
			finalLap = false
		end
	end
	
end)

data.Lap.Changed:connect(function()
	
	if data.Mode.Value == "Race" then
		local current = data.Lap.Value
		local total = data.Laps.Value
		if current <= total then
			script.Parent.Label.Text = "L"
			script.Parent.Value.Text = current.."/"..total
		elseif current > total then
			script.Parent.Label.Text = "L"
			script.Parent.Value.Text = "CF"
			Flag("cheq",true)
		end
	elseif finalLap == true then
		Flag("cheq",true)
	end
	
end)


function createFlagTask(color, animate)
	if thread ~= nil then
		task.cancel(thread)
	end
	print("Running task")
	thread = task.spawn(Flag,color,animate)
	
end

flagEvent.OnClientEvent:connect(createFlagTask)