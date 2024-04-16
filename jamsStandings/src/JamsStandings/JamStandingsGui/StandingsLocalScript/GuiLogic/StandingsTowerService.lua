local service = {}

-- Modules
local _remotes = require(workspace.JamsStandings.Modules.RemotesLocal)
local _helper = require(workspace.JamsStandings.Modules.Helpers)

local CarData = require(workspace.JamsStandings.DataModels.CarData)
local GameState = require(workspace.JamsStandings.DataModels.StandingsState)

-- Variables
local data
local state
standingsGui = script.Parent.Parent.Parent
towerGui = standingsGui.Standings
template = towerGui.Template

tweenService = game:GetService("TweenService")
tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Exponential)

function service:Update(newData)

	data = newData
	
	if data ~= nil and #data > 0 and state ~= GameState.Off then

		local leader = data[1]
		
		for index, carData: CarData in data do
			
			local row = towerGui:FindFirstChild(carData.UniqueName)
			
			if row == nil then
				
				local newRow = template:Clone()
				newRow.Parent = towerGui
				newRow.Visible = true
				newRow.Name = carData.UniqueName
				
				newRow.Driver.Text = carData.TeamName
				newRow.Number.Text = carData.Number
				newRow.BackgroundColor3 = carData.Class
				
				row = newRow
				
				row.Position = UDim2.new(0, -1000, 0, index*21)
				
			end
			
			if index == 1 then
				if state == GameState.Race or state == GameState.TimedRace then
					row.Gap.Text = "Leader"
				elseif state == GameState.Qualifying then
					row.Gap.Text = _helper:ConvertLapTime(carData.BestLap)
				end
			else
				if state == GameState.Race or state == GameState.TimedRace then
					if leader.Elapsed < carData.Elapsed then
						if carData.Laps < leader.Laps then
							row.Gap.Text = "("..leader.Laps - carData.Laps .. ") +"..CreateGapString(carData.Elapsed - leader.Elapsed)
						else
							row.Gap.Text = "+"..CreateGapString(carData.Elapsed - leader.Elapsed)
						end
					else
						row.Gap.Text = ""
					end
				elseif state == GameState.Qualifying then
					if carData.BestLap ~= nil then
						row.Gap.Text = "+"..CreateGapString(carData.BestLap - leader.BestLap)
					else
						row.Gap.Text = "NO TIME"
					end
				end
			end
			
			row.Pos.Text = index
			
			if carData.InPits then
				row.Markers.PitMarker.Size = UDim2.new(0, 40, 0, 20)
			else
				row.Markers.PitMarker.Size = UDim2.new(0, 0, 0, 20)
			end
			
			if carData.Finished then
				row.Markers.ChequeredFlagMarker.Size = UDim2.new(0, 20, 0, 20)
			else
				row.Markers.ChequeredFlagMarker.Size = UDim2.new(0, 0, 0, 20)
			end
			
			local targetPosition = UDim2.new(0, 0, 0, index*21)
			local tween = tweenService:Create(row, tweenInfo, {Position = targetPosition})
			tween:Play()
			
		end
	end

end

function service:GetData()
	
	return data
	
end

function service:GetLeader()
	
	if data ~= nil and #data > 0 then
		return data[1]
	end
end

function service:SetPit(carData)
	
	local row = towerGui:FindFirstChild(carData.UniqueName)
	
	if row ~= nil then
		if carData.InPits then
			row.Markers.PitMarker.Size = UDim2.new(0, 40, 0, 20)
			print(row.Markers.PitMarker.Size)
		else
			row.Markers.PitMarker.Size = UDim2.new(0, 0, 0, 20)
		end
	end
	
end

function service:updateGameState(newState)
	
	if state ~= newState then

		service:DestroyRows()
		
		state = newState
		if state ~= GameState.Off then
			service:Update(service:GetData())
		end
			
	end
	
end

function service:DestroyRows()
	
	for _,row in towerGui:GetChildren() do
		if row.Name ~= "Template" and row.Name ~= "Drag" then
			row:Destroy()
		end
	end
	
end

function CreateGapString(gap: number)
	
	local splitString = string.split(tostring(gap), ".")
	local min = splitString[1]
	local sec = string.sub(splitString[2],1,3)
	
	return min.."."..sec
	
end

function service:Init()

	local getDataFunction = _remotes:GetRemoteFunction("getDataFunction")
	local getStateFunction = _remotes:GetRemoteFunction("getGameStateFunction")
	local localData = getDataFunction:InvokeServer()
	state = getStateFunction:InvokeServer()
	service:Update(localData)

end

return service