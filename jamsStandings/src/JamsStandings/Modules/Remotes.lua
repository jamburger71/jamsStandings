local remotes = {}

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Create Folders
local folder = Instance.new("Folder", ReplicatedStorage)
folder.Name = "JamsStandingsRemotes"

local events = Instance.new("Folder", folder)
events.Name = "Events"

local functions = Instance.new("Folder", folder)
functions.Name = "Functions"




function remotes:CreateRemoteEvent(name: string): RemoteEvent

	local remote = Instance.new("RemoteEvent", events)
	remote.Name = name

	return remote

end

function remotes:CreateRemoteFunction(name: string): RemoteFunction

	local remote = Instance.new("RemoteFunction", functions)
	remote.Name = name

	return remote

end

function remotes:GetRemoteEvent(name: string): RemoteEvent

	local remote = events:WaitForChild(name, 20)

	if remote == nil then
		warn("Could not find RemoteEvent " .. name)
	end

	return remote

end

function remotes:GetRemoteFunction(name: string): RemoteFunction

	local remote = functions:WaitForChild(name, 10)

	if remote == nil then
		warn("Could not find RemoteFunction " .. name)
	end

	return remote

end

return remotes