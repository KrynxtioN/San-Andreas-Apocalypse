local PossibleWeathers = {0,1,2,3,4,5,6,7,8,10,11,12,13,14,15,16,17,18}

local realSecondsPerHour = (4 * 60 * 60) / 24 -- A Day has 4 Hours
local weather = math.random(1,#PossibleWeathers)
resetSkyGradient()

ServerTime = {}
ServerTime.Hour = 0
ServerTime.Minute = 0
ServerTime.GameDay = 1 -- Monday - Sunday (1-7)

resetWaterColor()

function loadNewDayStuff()
	SellFish.generatePrices()
end

function loadPlayerWeather(player)
	triggerClientEvent(player,"clientSetWeather",player,PossibleWeathers[weather])
end

function ServerTime.updateGameTime()
	if(math.random(1,75) == 50)then
		for _,v in pairs(getElementsByType("player"))do
			if(isCharacterLoggedIn(v))then
				triggerClientEvent(v,"earthQuakeStart",v)
			end
		end
		
		if(isTimer(Spinosaurus.closeTimer))then
			killTimer(Spinosaurus.closeTimer)
		end
		Spinosaurus.openCaves()
		
		Spinosaurus.closeTimer = setTimer(function()
			Spinosaurus.closeCaves()
		end,1800000,1)
	end

	ServerTime.Minute = ServerTime.Minute + 1
	if(ServerTime.Minute >= 60)then
		local Hour = ServerTime.Hour
		local weather = math.random(1,#PossibleWeathers)
		if(Hour == 6 or Hour == 12 or Hour == 18 or Hour == 24)then
			for _,v in pairs(getElementsByType("player"))do
				if(isCharacterLoggedIn(v))then
					triggerClientEvent(v,"clientSetWeather",v,PossibleWeathers[weather])
				end
			end
		end
	
		ServerTime.Minute = 0
		ServerTime.Hour = ServerTime.Hour + 1
		if(ServerTime.Hour >= 24)then
			ServerTime.Hour = 0
			ServerTime.GameDay = ServerTime.GameDay + 1
			loadNewDayStuff()
			if(ServerTime.GameDay > 7)then
				ServerTime.GameDay = 1
			end
		end
	end
	setTime(ServerTime.Hour, ServerTime.Minute)
	
	for _, v in pairs(getElementsByType("player"))do
		triggerClientEvent(v, "ServerTime.updateData", v, ServerTime.Hour, ServerTime.Minute, ServerTime.GameDay)
	end
end
setTimer(ServerTime.updateGameTime, realSecondsPerHour * 1000 / 60, 0)