SkeletonTaxiDriver = {}

addEvent("SkeletonTaxiDriver.Finished",true)
addEventHandler("SkeletonTaxiDriver.Finished",root,function(amount)
	local amount = tonumber(amount)
	local pumpkins = 5 + amount
	giveHalloweenPumpkin(client,pumpkins)
	giveEXP(client,250)
	givePlayerSkillpoint(client,5)
	
	local skeletons_taxi = tonumber(getPlayerData("character_stats","character_id",getCharacterID(client),"skeletons_taxi"))
	Characters.addStats(client,"skeletons_taxi",skeletons_taxi+1)
	
	outputLog(getPlayerName(client).." hat ein Skelett zu seinem Ziel gebracht und 250 EXP und "..pumpkins.." Kürbisse erhalten","Halloween Event",getCharacterID(client))
end)

addEventHandler("onPlayerWasted",root,function()
	triggerClientEvent(source,"SkeletonTaxiDriver.reset",source)
end)