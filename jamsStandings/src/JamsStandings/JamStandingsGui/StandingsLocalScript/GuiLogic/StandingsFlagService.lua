local service = {}

-- Modules

local FlagState = require(workspace.JamsStandings.DataModels.FlagState)
local _remotes = require(workspace.JamsStandings.Modules.RemotesLocal)

-- Variables
local currentFlag
local currentNumber
local flagDisplayTask
local flagDisplay = script.Parent.Parent.Parent.Lap.Flag
local chequeredDisplay = flagDisplay.Chequered


function service:Init()
	
	local functionName: string = "getFlagFunction"
	local getFlagFunction = _remotes:GetRemoteFunction(functionName)
	currentFlag = getFlagFunction:InvokeServer()
	service:ShowNewFlag(currentFlag)
	
end

function service:ShowNewFlag(newFlag: FlagState, carNumber: number | nil)
	
	currentFlag = newFlag
	currentNumber = carNumber
	
	if flagDisplayTask ~= nil then
		task.cancel(flagDisplayTask)
	end
	
	local function showFlag()
		
		if currentFlag == FlagState.Chequered then
			chequeredDisplay.Visible = true
			flagDisplay.BackgroundColor3 = Color3.new(1,1,1)
			flagDisplay.TextLabel.Text = ""
		else
			chequeredDisplay.Visible = false
		end
		if currentFlag == FlagState.Green then
			flagDisplay.BackgroundColor3 = Color3.new(0,170/255,0)
			flagDisplay.TextLabel.Text = "GREEN - GO NOW"
			
		elseif currentFlag == FlagState.Yellow then
			flagDisplay.BackgroundColor3 = Color3.new(1,0.8,0)
			flagDisplay.TextLabel.Text = "YELLOW - NO OVERTAKING"
			
		elseif currentFlag == FlagState.Yellow1 then
			flagDisplay.BackgroundColor3 = Color3.new(1,0.8,0)
			flagDisplay.TextLabel.Text = "LOCAL - SECTOR 1"
			
		elseif currentFlag == FlagState.Yellow2 then
			flagDisplay.BackgroundColor3 = Color3.new(1,0.8,0)
			flagDisplay.TextLabel.Text = "LOCAL - SECTOR 2"
			
		elseif currentFlag == FlagState.Yellow3 then
			flagDisplay.BackgroundColor3 = Color3.new(1,0.8,0)
			flagDisplay.TextLabel.Text = "LOCAL - SECTOR 3"
			
		elseif currentFlag == FlagState.Red then
			flagDisplay.BackgroundColor3 = Color3.new(0.9,0,0)
			flagDisplay.TextLabel.Text = "RED - RETURN TO PL"
			
		elseif currentFlag == FlagState.Black then
			flagDisplay.BackgroundColor3 = Color3.new(0,0,0)
			if carNumber == nil then
				carNumber = "NaN"
			end
			flagDisplay.TextLabel.Text = "BLACK - CAR #"..carNumber.." PENALTY"
			
		elseif currentFlag == FlagState.White then
			flagDisplay.BackgroundColor3 = Color3.new(1,1,1)
			flagDisplay.TextLabel.Text = "WHITE - SLOW CAR"
			
		elseif currentFlag == FlagState.PitOpen then
			flagDisplay.BackgroundColor3 = Color3.new(0,170/255,0)
			flagDisplay.TextLabel.Text = "PIT LANE OPEN"
			
		elseif currentFlag == FlagState.PitClosed then
			flagDisplay.BackgroundColor3 = Color3.new(1,0.8,0)
			flagDisplay.TextLabel.Text = "PIT LANE CLOSED"
		end
		
		for i = 1, 12 do
			local x = (1-(i/12))^2
			flagDisplay.Size = UDim2.new(1,0,0,26-21*x)
			wait(0.025)
		end
		wait(5)
		for i = 1, 12 do
			local x = (1-(i/12))^2
			flagDisplay.Size = UDim2.new(1,0,0,5+21*x)
			wait(0.025)
		end
		
	end
	
	flagDisplayTask = task.spawn(showFlag)
	
end

return service
