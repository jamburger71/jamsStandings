local service = {}

-- Modules
local _helpers = require(workspace.JamsStandings.Modules.Helpers)

-- Variables
local player = game.Players.LocalPlayer
local gui = script.Parent.Parent.Parent

function service:Init()
	
	wait(3)

	-- Determines visibility
	if _helpers:CheckPlayerIsAdmin(player) then
		
		gui.Control.Visible = true
		
	end

end

return service