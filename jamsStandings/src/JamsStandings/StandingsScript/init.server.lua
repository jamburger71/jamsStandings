
-- Modules
local _remoteHandler = require(script.StandingsRemoteHandler)
local _commandsService = require(script.StandingsChatCommandsService)

function Init()
	
	-- Start listening for remotes
	_remoteHandler:Init()
	_commandsService:Init()

	-- Move Timing GUI to StarterGui
	MoveTimingGui()
	

end

function MoveTimingGui()

	local gui = script.Parent:FindFirstChild("JamStandingsGui")
	if gui ~= nil then
		gui.Parent = game.StarterGui
		
		for _,player in pairs(game.Players:GetChildren()) do
			local cloned = gui:Clone()
			cloned.Parent = player.PlayerGui
		end
	end

end

Init()