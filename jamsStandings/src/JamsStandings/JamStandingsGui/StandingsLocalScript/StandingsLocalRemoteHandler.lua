local handler = {}

-- Modules
local _flagService = require(script.Parent.GuiLogic.StandingsFlagService)
local _stateService = require(script.Parent.GuiLogic.StandingsStateService)
local _towerService = require(script.Parent.GuiLogic.StandingsTowerService)
local _remotes = require(workspace.JamsStandings.Modules.RemotesLocal)

local FlagState = require(workspace.JamsStandings.DataModels.FlagState)
local GameState = require(workspace.JamsStandings.DataModels.StandingsState)

local timerStore = script.Parent.Timer

-- Remotes
local flagEvent = _remotes:GetRemoteEvent("flagEvent")
local updateCarPitStateEvent = _remotes:GetRemoteEvent("updateCarPitStateEvent")
local updateGameStateEvent = _remotes:GetRemoteEvent("updateGameStateEvent")
local serverEvent = _remotes:GetRemoteEvent("serverEvent")
local timerEvent = _remotes:GetRemoteEvent("updateTimerEvent")

function updateFlag(newFlag: FlagState, carNumber: number | nil)
	
	_flagService:ShowNewFlag(newFlag, carNumber)
	
end

function serverDataEvent(data)

	_towerService:Update(data)
	_stateService:UpdateLaps(data)
	
end

function GetTimer(timerValue: number | nil)
	
	timerStore.Value = timerValue
	
end

function serverStateEvent(state: GameState, value: number | nil)
	
	_stateService:updateGameState(state, value)
	_towerService:updateGameState(state)
	
end

function CarPitEvent(carData)
	
	_towerService:SetPit(carData)
	
end

function handler:Init()
	
	flagEvent.OnClientEvent:Connect(updateFlag)
	serverEvent.OnClientEvent:Connect(serverDataEvent)
	timerEvent.OnClientEvent:Connect(GetTimer)
	updateGameStateEvent.OnClientEvent:Connect(serverStateEvent)
	updateCarPitStateEvent.OnClientEvent:Connect(CarPitEvent)
	
end

return handler