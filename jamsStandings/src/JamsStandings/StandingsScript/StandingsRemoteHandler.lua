local handler = {}

-- Modules
local _dataService = require(script.Parent.StandingsDataService)
local _config = require(script.Parent.Parent._Config)
local _remotes = require(script.Parent.Parent.Modules.Remotes)

local FlagState = require(script.Parent.Parent.DataModels.FlagState)
local GameState = require(script.Parent.Parent.DataModels.StandingsState)

-- Remotes
local flagEvent = _remotes:CreateRemoteEvent("flagEvent")
local updateCarPitStateEvent = _remotes:CreateRemoteEvent("updateCarPitStateEvent")
local updateGameStateEvent = _remotes:CreateRemoteEvent("updateGameStateEvent")
local serverEvent = _remotes:CreateRemoteEvent("serverEvent")
local updateTimerEvent = _remotes:CreateRemoteEvent("updateTimerEvent")
local deleteDataEvent = _remotes:CreateRemoteEvent("deleteDataEvent")

local getFlagFunction = _remotes:CreateRemoteFunction("getFlagFunction")
local getGameStateFunction = _remotes:CreateRemoteFunction("getGameStateFunction")
local getDataFunction = _remotes:CreateRemoteFunction("getDataFunction")
local getLastLapFunction = _remotes:CreateRemoteFunction("getLastLapFunction")

-- Wesleys Remote
local TimerLapEvent = game.ReplicatedStorage:WaitForChild("TimerLapEvent")

-- Variables

function SetFlag(player: Player, flag: FlagState, carNumber: number | nil)
	
	_dataService:SetCurrentFlag(flag)
	flagEvent:FireAllClients(flag, carNumber)

end

function GetFlag(): FlagState

	return _dataService:GetCurrentFlag()

end

function SetCarPitState(player: Player, inPits: boolean)
	
	if inPits ~= nil then
		local carData = _dataService:UpdateCarPitState(player, inPits)
		updateCarPitStateEvent:FireAllClients(carData)
	end
	
end

function UpdateCar(player: Player, split: number, sector: number, cclap: boolean)
	
	handler:UpdateCar(player, split, sector, cclap)

end

function handler:UpdateCar(player: Player, split: number, sector: number, cclap: boolean)

	if sector == 4 then
		local carFound, newData, state = _dataService:UpdateCar(player, split, cclap)

		if carFound then
			serverEvent:FireAllClients(newData, state)
		end
	end

end

function SetGameState(player: Player, state: StandingsState, value: number)
	
	if state == GameState.TimedRace or state == GameState.Qualifying then
		value = value*60
	end
	local newState = _dataService:UpdateGameState(state, value)
	updateGameStateEvent:FireAllClients(newState, value)
	
end

function GetGameState(): GameState
	
	local state, laps = _dataService:GetGameState()
	
	return state, laps
	
end

function GetData()
	
	return _dataService:GetSortedTable()
	
end

function DeleteData()
	
	_dataService:ResetData()
	serverEvent:FireAllClients({}, _dataService:GetGameState())
	
	
end

function handler:Init()
	
	flagEvent.OnServerEvent:Connect(SetFlag)
	updateCarPitStateEvent.OnServerEvent:Connect(SetCarPitState)
	TimerLapEvent.OnServerEvent:Connect(UpdateCar)
	updateGameStateEvent.OnServerEvent:Connect(SetGameState)
	deleteDataEvent.OnServerEvent:Connect(DeleteData)

	getFlagFunction.OnServerInvoke = GetFlag
	getGameStateFunction.OnServerInvoke = GetGameState
	getDataFunction.OnServerInvoke = GetData
	
end

return handler