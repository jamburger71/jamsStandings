local _buttonService = require(script.Parent.Parent.Parent.Parent.StandingsLocalScript.AdminLogic.StandingsButtonService)
local FlagState = require(workspace.JamsStandings.DataModels.FlagState)

script.Parent.MouseButton1Click:Connect(function()
	
	_buttonService:setFlag(FlagState.Green)
	
end)