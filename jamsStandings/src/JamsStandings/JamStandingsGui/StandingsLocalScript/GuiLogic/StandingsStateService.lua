local service = {}

-- Modules
local _remotes = require(workspace.JamsStandings.Modules.RemotesLocal)
local _dataHelper = require(workspace.JamsStandings.Modules.Helpers)
local _towerService = require(script.Parent.StandingsTowerService)

local GameState = require(workspace.JamsStandings.DataModels.StandingsState)
local CarData = require(workspace.JamsStandings.DataModels.CarData)

-- Variables
local gameState
local laps
local currentLap

local timerConnection

local topDisplay = script.Parent.Parent.Parent.Lap
local timerStore = script.Parent.Parent.Timer

function service:updateGameState(state: GameState, value: number)
	
	gameState = state
	
	if gameState == GameState.TimedRace or gameState == GameState.Qualifying then
		
		ConnectToTimer()
		
	elseif gameState == GameState.Race then
		
		DisconnectTimer()
		
		laps = value
		
		SetRaceState()
		
	else

		DisconnectTimer()
		
		topDisplay.Label.Text = ""
		
	end
	
end

function service:UpdateLaps(data)

	local leader = _towerService:GetLeader()
	
	if leader ~= nil then
		currentLap = leader.Laps + 1
	else
		currentLap = 1
	end
	
	if gameState == GameState.Race then
		SetRaceState()
	end
	
end

function ConnectToTimer()
	
	timerConnection = timerStore.Changed:Connect(function()
		
		topDisplay.Label.Text = _dataHelper:ConvertDisplayTime(timerStore.Value)
		
	end)
	
end

function DisconnectTimer()
	
	if timerConnection ~= nil then
		timerConnection:Disconnect()
	end
	
end

function SetRaceState()
	
	local leader = _towerService:GetLeader()
	
	if leader ~= nil then
		currentLap = leader.Laps + 1
	else
		currentLap = 1
	end
	
	if currentLap > laps then
		topDisplay.Label.Text = laps .. "/" .. laps
	else
		topDisplay.Label.Text = currentLap .. "/" .. laps
	end
end


function service:Init()
	
	local gameStateFunction = _remotes:GetRemoteFunction("getGameStateFunction")
	local state, value = gameStateFunction:InvokeServer()
	service:updateGameState(state, value)
	
end

return service
