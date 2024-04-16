local helper = {}

-- Modules
local State = require(script.Parent.Parent.DataModels.StandingsState)

function helper:GetSortedData(data, state: State): table
	
	local list = {}
	
	for _, carData in pairs(data) do
		table.insert(list, carData)
	end
	
	if state == State.Race or state == State.TimedRace then
		table.sort(list, CompareCarDataRace)
	elseif state == State.Qualifying then
		table.sort(list, CompareCarDataQuali)
	end
	
	return list
	
end

function CompareCarDataRace(car1: table, car2: table): boolean
	
	if car1.Laps == car2.Laps then 
		print(car1.Elapsed.."   "..car2.Elapsed)
		return car1.Elapsed < car2.Elapsed
		
	else return car1.Laps > car2.Laps end
	
end

function CompareCarDataQuali(car1: table, car2: table): boolean

	if car1.BestLap == nil and car2.BestLap == nil 
		or car1.BestLap == car2.BestLap 
	then return car1.Elapsed < car2.Elapsed end
	if car1.BestLap == nil and car2.BestLap ~= nil then return false end
	if car1.BestLap ~= nil and car2.BestLap == nil then return true end
	return car1.BestLap < car2.BestLap
	
end

return helper