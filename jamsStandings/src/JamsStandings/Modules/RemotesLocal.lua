local remotes = {}

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Create Folders
local folder = ReplicatedStorage:WaitForChild("JamsStandingsRemotes")
local events = folder:WaitForChild("Events")
local functions = folder:WaitForChild("Functions")

function remotes:GetRemoteEvent(name: string): RemoteEvent

	local remote = events:WaitForChild(name, 10)

	if remote == nil then
		warn("Could not find RemoteEvent " .. name)
	end

	return remote

end

function remotes:GetRemoteFunction(name: string, name2: string): RemoteFunction
	
	print(name, name2)
	local remote = functions:WaitForChild(name, 10)

	if remote == nil then
		warn("Could not find RemoteFunction " .. name)
	end

	return remote

end

return remotes