RaceMinigame = {Marker = {}, Pickup = {},
	["MarkerPos"] = {
		{2021.5124511719,1545.3287353516,10.823545455933},
		{2235.7595214844,1353.5301513672,10.884368896484},
		{2827.2341308594,1382.4471435547,10.804470062256},
		{644.34039306641,-454.08294677734,16.240797042847},
		{852.05810546875,-568.00646972656,17.028739929199},
	},
}

function RaceMinigame.createMarker(ID)
	if(not(ID))then
		for i,v in pairs(RaceMinigame["MarkerPos"])do
			RaceMinigame.Marker[i] = createMarker(v[1],v[2],v[3]-1.5,"cylinder",1.5,255,0,0)
			apocalypseSetElementData(RaceMinigame.Marker[i],"RaceMinigameID",i)
			RaceMinigame.Pickup[i] = createPickup(v[1],v[2],v[3],3,1318,50)
			
			addEventHandler("onMarkerHit",RaceMinigame.Marker[i],function(player)
				apocalypseSetElementData(player,"RaceMinigameID",apocalypseGetElementData(source,"RaceMinigameID"))
				triggerClientEvent(player,"RaceMinigame.openWindow",player)
			end)
		end
	else
		local tbl = RaceMinigame["MarkerPos"][ID]
		RaceMinigame.Marker[ID] = createMarker(tbl[1],tbl[2],tbl[3],"ring",3,255,0,0)
		apocalypseSetElementData(RaceMinigame.Marker[ID],"RaceMinigameID",i)
			
		addEventHandler("onMarkerHit",RaceMinigame.Marker[ID],function(player)
			apocalypseSetElementData(player,"RaceMinigameID",apocalypseGetElementData(source,"RaceMinigameID"))
			triggerClientEvent(player,"RaceMinigame.openWindow",player)
		end)
	end
end
RaceMinigame.createMarker()

addEvent("RaceMinigame.start",true)
addEventHandler("RaceMinigame.start",root,function()
	local ID = tonumber(apocalypseGetElementData(client,"RaceMinigameID"))
	if(isPedInVehicle(client) and getPedOccupiedVehicleSeat(client) == 0)then
		if(isElement(RaceMinigame.Marker[ID]))then
			destroyElement(RaceMinigame.Marker[ID])
			destroyElement(RaceMinigame.Pickup[ID])
			triggerClientEvent(client,"RaceMinigame.startRace",client,ID)
			apocalypseSetElementData(client,"RaceMinigameID",nil)
			
			setTimer(function(ID)
				RaceMinigame.createMarker(ID)
			end,900000,1,ID)
			
			triggerClientEvent(client,"closeWindow",client)
		else
			createInfobox(client,getText(client,"SRaceMinigame1"))
		end
	else
		createInfobox(client,getText(client,"SRaceMinigame2"))
	end
end)

addEvent("RaceMinigame.reward",true)
addEventHandler("RaceMinigame.reward",root,function()
	local Level_Bonus_EXP = tonumber(apocalypseGetElementData(client,"level"))
	if(Level_Bonus_EXP > 100)then Level_Bonus_EXP = 100 end
	local exp_amount, money_amount = 500 + (Level_Bonus_EXP * 5), 125
	if(SERVERBONUS.RACE_MINIGAME == true)then
		exp_amount = exp_amount * 2
		money_amount = money_amount * 2
		giveItem(client,62,1)
		triggerClientEvent(client, "showItemBar", client, {{62,1}})
	end
	giveEXP(client,exp_amount)
	givePlayerServerMoney(client,money_amount)
	setAchievement(client,409)
	if(SERVERBONUS.RACE_MINIGAME == true)then
		outputLog(getPlayerName(client).." hat ein Rennen beendet und $"..money_amount..", "..exp_amount.." EXP und ein Race Ticket bekommen","Race Minigame",getCharacterID(client))
		return
	end
	outputLog(getPlayerName(client).." hat ein Rennen beendet und $"..money_amount.." und "..exp_amount.." EXP bekommen","Race Minigame",getCharacterID(client))
end)

addEventHandler("onPlayerWasted",root,function()
	apocalypseSetElementData(source,"RaceMinigameID",nil)
end)