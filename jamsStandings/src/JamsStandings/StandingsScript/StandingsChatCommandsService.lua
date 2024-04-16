local service = {}

-- Modules
local _config = require(script.Parent.Parent._Config)
local _dataService = require(script.Parent.StandingsDataService)
local _remoteHandler = require(script.Parent.StandingsRemoteHandler)

-- Variables
local commands = {
	
	"setlaps",
	"setcuts"
	
}
local prefix = _config.commandPrefix

function AddCommandsToChat(callingPlayer)
	for _,v in pairs(_config.AdminUsers) do
		if callingPlayer.Name == v then
			callingPlayer.Chatted:Connect(function(msg)
				local loweredString = string.lower(msg)
				local args = string.split(loweredString," ")
				for _,command in pairs(commands) do
					if args[1] ~= nil and args[1] == prefix .. command then
						service[command](args, callingPlayer)
					end
				end
			end)
		end
	end
end

function SearchPlayer(input: string): Player | nil

	for _,player in pairs(game:GetService("Players"):GetPlayers()) do
		if (string.sub(string.lower(player.Name), 1, string.len(input)) == string.lower(input)) 
			or (string.sub(string.lower(player.DisplayName), 1, string.len(input)) == string.lower(input)) then
			return player
		end
	end
	
	return nil
	
end

function service.setlaps(args: {string}, callingPlayer: Player)
	
	if args[2] ~= nil and args[3] ~= nil and tonumber(args[3]) ~= nil then
		if args[2] == "all" or args[2] == "*" then
			for _, player in pairs(game.Players:GetChildren()) do
				player.leaderstats.Laps.Value = tonumber(args[3])
			end
		else
			local player = SearchPlayer(args[2])
			if player ~= nil then
				player.leaderstats.Laps.Value = tonumber(args[3])
				_remoteHandler:UpdateCar(player, nil, 4, false)
			end
		end
	end

end

function service.setcuts(args: {string}, callingPlayer: Player)

	if args[2] ~= nil and args[3] ~= nil and tonumber(args[3]) ~= nil then
		if args[2] == "all" or args[2] == "*" then
			for _, player in pairs(game.Players:GetChildren()) do
				player.leaderstats.CornerCuts.Value = tonumber(args[3])
			end
		else
			local player = SearchPlayer(args[2])
			if player ~= nil then
				player.leaderstats.CornerCuts.Value = tonumber(args[3])
			end
		end
	end

end

function service:Init()
	
	game.Players.PlayerAdded:Connect(AddCommandsToChat)
	for _, player in pairs(game.Players:GetChildren()) do
		AddCommandsToChat(player)
	end
	
end

return service
