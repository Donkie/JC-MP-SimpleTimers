--[[
Simple timers API by Donkie http://steamcommunity.com/id/Donkie/

Usable both client and serverside.

API:
simpletimers.Simple(delay, function)
simpletimers.Create(delay, repetitions, function)
simpletimers.Create(id, delay, repetitions, function)
simpletimers.Remove(id)

Usage:
simpletimers.Simple(10, function()
	print("This will get printed in 10 seconds")
end)

simpletimers.Create("someid", 1, 10, function()
	print("This will get printed 10 times with 1 second delay")
end)

simpletimers.Create(1, 10, function()
	print("This will too get printed 10 times with 1 second delay")
end)

simpletimers.Remove("someid")

Terms:
Don't release this under any other name than mine.
Keep the code inside this file, don't put it in your own.
Don't rename the file.
]]

simpletimers = {}

local timers = {}
function simpletimers.Simple(delay, func)
	timers[#timers + 1] = {timer = Timer(), delay = delay, func = func}
end

local reptimers = {}
local i = 0
function simpletimers.Create(id, delay, reps, func)
	local func = func
	if not func then -- Incase he didn't supply any ID, create one for him.
		local fdelay = id
		local freps = delay
		local ffunc = reps
		delay = fdelay
		reps = freps
		func = ffunc
		id = i + 1
		i = i + 1
	else
		if type(id) != "string" then
			error("ID not a string!", 1)
			return
		end
	end
	
	reptimers[id] = {timer = Timer(), delay = delay, reps = reps, repsdone = 0, func = func}
end

function simpletimers.Remove(id)
	if type(id) != "string" then
		error("ID not a string!", 1)
		return
	end
	reptimers[id] = nil
end

local function PostTick()
	for k,v in pairs(timers) do
		if v.timer:GetSeconds() >= v.delay then
			v.func()
			timers[k] = nil
		end
	end
	
	for id,v in pairs(reptimers) do
		if v.timer:GetSeconds() > v.delay then
			v.repsdone = v.repsdone + 1
			if v.repsdone >= v.reps then
				reptimers[id] = nil
			else
				v.timer:Restart()
			end
			
			v.func()
		end
	end
end
Events:Subscribe("PostTick", PostTick)
