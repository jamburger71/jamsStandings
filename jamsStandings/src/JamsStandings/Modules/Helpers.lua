local helpers = {}

-- Modules
local _config = require(script.Parent.Parent._Config)

function helpers:CheckPlayerIsAdmin(player: Player): boolean
	
	for _, name in pairs(_config.AdminUsers) do
		if typeof(name) == "string" and name == player.Name then
			return true
		elseif name == player.UserId then
			return true
		end
	end

	return false
	
end

function helpers:ConvertDisplayTime(value: number | nil): string
	
	if value == nil then
		return "--:--:--"
	end
	
	local hr = math.floor(value / 3600)
	local min = math.floor((value/60) - (60*hr))
	local sec = math.floor(value - (60*min) - (3600*hr))

	if hr < 1 then
		hr = ""
	else
		hr = hr..":"
	end
	
	if min < 10 then
		min = "0"..min
	end
	min = min..":"
	
	if sec < 10 then
		sec = "0"..sec
	end
	
	return hr..min..sec
	
end

function helpers:ConvertLapTime(value: number | nil): string

	if value == nil then
		return "NO TIME"
	end
	
	local min = math.floor(value / 60)
	local sec = math.floor(value - 60 * min)
	local milisec = math.floor((value % 1) * 1000)
	
	if min < 1 then
		min = ""
	else
		min = min..":"
	end
	if sec < 10 then
		sec = "0"..sec
	end
	if milisec < 100 and milisec >= 10 then
		milisec = "0"..milisec
	elseif milisec < 10 then
		milisec = "00"..milisec
	end

	return min..sec.."."..milisec

end

function helpers:ConvertTimeToSeconds(value: string): number
	
	local splitValue = string.split(value, ":")
	local min = tonumber(splitValue[1])
	local splitValue2 = string.split(splitValue[2], ".")
	local sec = tonumber(splitValue2[1]) + (min * 60)
	local milisec = tonumber(splitValue2[2]) + (sec * 1000)
	
	return milisec
	
end

return helpers