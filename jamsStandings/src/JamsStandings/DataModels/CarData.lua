local CarData = {}
CarData.__Index = CarData

local GameState = require(script.Parent.StandingsState)

local _config = require(script.Parent.Parent._Config)

function CarData.new(car: Instance, finished: boolean)
	
	local carData = {}
	setmetatable(carData, CarData)
	
	carData.UniqueName = car.Name
	carData.TeamName = car:GetAttribute("CarName")
	carData.Number = car:GetAttribute("CarNumber")
	carData.Class = car:GetAttribute("CarClass")
	carData.Laps = 0
	carData.Gap = os.clock()
	carData.Elapsed = os.clock()
	carData.BestLap = nil
	carData.InPits = car.DriveSeat.limiter.Value
	carData.Finished = finished
	
	return carData
end

return CarData
