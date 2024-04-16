local service = {}

-- Modules
local CarData = require(script.Parent.Parent.DataModels.CarData)
local GameState = require(script.Parent.Parent.DataModels.StandingsState)
local FlagState = require(script.Parent.Parent.DataModels.FlagState)

local _config = require(script.Parent.Parent._Config)
local _dataHelpers = require(script.Parent.Parent.Modules.StandingsDataHelpers)
local _timerService = require(script.Parent.StandingsTimerService)
local _remotes = require(script.Parent.Parent.Modules.Remotes)

-- Variables
local data = {}
local state = GameState.Off
local maxLaps = 0
local timer = 0
local finished = false
local currentFlag = FlagState.Green
local timerTracker
	
	
function service:UpdateCar(player: Player, lap: number | nil, invalidLap: boolean)
	
	local car = player.Character.Humanoid.SeatPart.Parent
	local fireChequered = _remotes:GetRemoteEvent("flagEvent")
	
	if car ~= nil then
		local carData = data[car.Name]
		if carData == nil then
			carData = service:AddCar(car)
		end
		
		if not carData.Finished then
					
			carData.Laps = player.leaderstats.Laps.Value
			carData.Elapsed = os.clock()
			
			if not invalidLap and lap ~= nil then
				if carData.BestLap ~= nil then
					if lap < carData.BestLap then
						carData.BestLap = lap
					end
				else
					carData.BestLap = lap
				end
			end
			
			if state == GameState.Race then
				if finished == true or carData.Laps >= maxLaps then
					if not finished then
						finished = true
						fireChequered:FireAllClients(FlagState.Chequered)
					end
					carData.Finished = true
				else
					carData.Finished = false
				end
			elseif state == GameState.TimedRace or state == GameState.Qualifying then
				carData.Finished = finished
			end
		end
		
		data[car.Name] = carData
		
		local sortedTable = service:GetSortedTable()
		
		if sortedTable[1].Laps == maxLaps and state == GameState.Race then
			if not finished then
				finished = true
				fireChequered:FireAllClients(FlagState.Chequered)
			end
		else
			finished = false
		end
		
		return true, sortedTable
		
	else
		local sortedTable = service:GetSortedTable()
		return false, sortedTable
	end
	
end

function service:UpdateCarPitState(player: Player, inPits: boolean): table
	
	local car = player.Character.Humanoid.SeatPart.Parent
	local carData = data[car.Name]
	if carData == nil then
		carData = service:AddCar(car)
	end
	
	carData.InPits = inPits
	
	return carData
	
end

function service:AddCar(car: Instance): table
	
	local carData = data[car.Name]
	if carData ~= nil then
		return
	end
	
	carData = CarData.new(car, finished)
	data[car.Name] = carData
	
	return carData
end

function service:RemoveCar(car: Instance)
	
	data[car.Name] = nil
	
end

function service:ResetData()
	
	data = {}
	
end

function service:GetSortedTable(): table
	
	return _dataHelpers:GetSortedData(data, state)
	
end

function service:UpdateGameState(newState: GameState, value)
	
	if newState ~= state then
		state = newState
		
		if state == GameState.Race then
			
			maxLaps = value
			timer = 0
			DisconnectTimerTracker()
			
		else
			
			maxLaps = 0
			timer = value
			ConnectTimerTracker()
			
		end
	else
		state = GameState.Off
		maxLaps = 0
		timer = value
		DisconnectTimerTracker()
	end
	
	return state
	
end

function service:GetGameState(): (GameState, number | nil)
	
	if state == GameState.Race then
		return state, maxLaps
	else
		return state
	end
	
end

function service:SetCurrentFlag(flag: FlagState)
	
	currentFlag = flag
	
end

function service:GetCurrentFlag(): FlagState
	
	return currentFlag
	
end

function ConnectTimerTracker()
	
	_timerService:StartTimer(timer)
	
	timerTracker = script.Parent.Timer.Changed:Connect(function(value)
		
		if value <= 0 then
			finished = true
			local fireChequered = _remotes:GetRemoteEvent("flagEvent")
			fireChequered:FireAllClients(FlagState.Chequered)
			DisconnectTimerTracker()
		end
		
	end) 
	
end

function DisconnectTimerTracker()
	
	if timerTracker ~= nil then
		
		timerTracker:Disconnect()
		
	end
	
end

return service