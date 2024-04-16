local service = {}

-- Modules
local _remotes = require(script.Parent.Parent.Modules.Remotes)

local timerStore = script.Parent.Timer

-- Remotes

local unixTimeStart
local timerStart
local timerTask

function service:StartTimer(startTimer: number)

	service:EndTimer()
	
	timerStart = startTimer
	timerStore.Value = startTimer

	timerTask = task.spawn(LoopTimer)

end

function service:EndTimer()
	
	if timerTask ~= nil then
		task.cancel(timerTask)
	end
	
end

function LoopTimer()
	
	wait(.2)

	unixTimeStart = os.time()
	local updateTimerEvent = _remotes:GetRemoteEvent("updateTimerEvent")

	while timerStore.Value > -1 do
		
		updateTimerEvent:FireAllClients(script.Parent.Timer.Value)

		timerStore.Value = timerStore.Value - 1

		if timerStore.Value > timerStart - (os.time() - unixTimeStart) then
			timerStore.Value = timerStart - (os.time() - unixTimeStart)
		end
		
		wait(1)
	end

end

return service