local service = {}

-- Modules
local _remotes = require(workspace.JamsStandings.Modules.RemotesLocal)
local _settingsService = require(script.Parent.StandingsSettingsService)
local _towerService = require(script.Parent.Parent.GuiLogic.StandingsTowerService)

local GameState = require(workspace.JamsStandings.DataModels.StandingsState)
local FlagState = require(workspace.JamsStandings.DataModels.FlagState)

local setStateEvent = _remotes:GetRemoteEvent("updateGameStateEvent")
local setFlagEvent = _remotes:GetRemoteEvent("flagEvent")
local deleteDataEvent = _remotes:GetRemoteEvent("deleteDataEvent")

local gui = script.Parent.Parent.Parent
local settingsFrame = gui.Settings
local controlFrame = gui.Control

function setGameStateRace()
	
	local laps = _settingsService:GetLaps()
	setStateEvent:FireServer(GameState.Race, laps)
	
end

function setGameStateRacetimed()

	local timer = _settingsService:GetTimer()
	setStateEvent:FireServer(GameState.TimedRace, timer)
	
end

function setGameStateQualifying()

	local timer = _settingsService:GetTimer()
	setStateEvent:FireServer(GameState.Qualifying, timer)
	
end

function deleteData()
	
	deleteDataEvent:FireServer()
	_towerService:DestroyRows()
	
end

function openSettings()
	
	settingsFrame.Visible = true
	
end

-- FLAGS --

function service:setFlag(flag: FlagState)
	
	setFlagEvent:FireServer(flag)
	
end

function service:Init()
	
	controlFrame.Quali.MouseButton1Click:Connect(setGameStateQualifying)
	controlFrame.Race.MouseButton1Click:Connect(setGameStateRace)
	controlFrame.RaceTimed.MouseButton1Click:Connect(setGameStateRacetimed)
	controlFrame.Settings.MouseButton1Click:Connect(openSettings)
	controlFrame.Reset.MouseButton1Click:Connect(deleteData)
	
end

return service
