MetalDetector = {Timer = {}}

local Achievements = {
	{1,289},
	{10,290},
	{25,291},
	{50,292},
	{75,293},
	{125,294},
	{175,295},
	{250,296},
}

function MetalDetector.Activate(player)
	if(hasPlayerItem(player,145) >= 1)then
		if(apocalypseGetElementData(player,"MetalDetector") == true)then
			apocalypseSetElementData(player,"MetalDetector",false)
			triggerClientEvent(player,"MetalDetector.Stop",player)
		else
			apocalypseSetElementData(player,"MetalDetector",true)
			triggerClientEvent(player,"MetalDetector.Start",player)
		end
	end
end

addEvent("MetalDetector.Search",true)
addEventHandler("MetalDetector.Search",root,function()
	if(not(isTimer(MetalDetector.Timer[client])))then
		if not apocalypseGetElementData(client,"MetalDetector") then return end
		setElementFrozen(client,true)
		toggleAllControls(client,false)
		setTimer(function(client)
			setPedAnimation(client,"BOMBER", "BOM_Plant_Loop",-1,true,false,false,true)
		end,250,1,client)
		MetalDetector.Timer[client] = setTimer(function(client)
			if(isElement(client))then
				setPedAnimation(client)
				setElementFrozen(client,false)
				toggleAllControls(client,true)
				triggerClientEvent(client,"MetalDetector.Spawn",client)

				if(getSkillLevel(client,8) >= 1)then bonus_item = getSkillLevel(client,8) * 1 else bonus_item = 0 end
				
				local rndItem = math.random(5,8) + bonus_item
				if(SERVERBONUS.METAL_DETECTOR == true)then rndItem = rndItem + 5 end
				giveLootItems(client,rndItem)
				outputLog(getPlayerName(client).." hat "..rndItem.." Items gefunden", "Metal Detector", getCharacterID(client))
				Characters.addStats(client,"metal_detector_looted",getPlayerData("character_stats","character_id",getCharacterID(client),"metal_detector_looted")+1)
				local looted = getPlayerData("character_stats","character_id",getCharacterID(client),"metal_detector_looted")
				for _,v in pairs(Achievements)do
					if(looted >= v[1])then
						setAchievement(client,v[2])
					end
				end
				
				if(DailyTasks.playerTasks[client][22])then
					DailyTasks.updateProgress(client,22,DailyTasks.playerTasks[client][22].progress + 1)
				end
				
				if(WeeklyTasks.playerTasks[client][22])then
					WeeklyTasks.updateProgress(client,22,WeeklyTasks.playerTasks[client][22].progress + 1)
				end
				MetalDetector.Timer[client] = nil
			end
		end,3500,1,client)
	end
end)

function MetalDetector.check(player)
	if(hasPlayerItem(player,145) < 1)then
		triggerClientEvent(player,"MetalDetector.createPickup",player)
	end
end

addEvent("MetalDetector.Collect",true)
addEventHandler("MetalDetector.Collect",root,function()
	if(hasPlayerItem(client,145) < 1)then
		giveItem(client,145,1)
		triggerClientEvent(client, "showItemBar", client, {{145,1}})
		NPC.MeMessage(client,getText(client,"SMetalDetector1"))
	end
end)

addEvent("MetalDetector.destroyWood",true)
addEventHandler("MetalDetector.destroyWood",root,function()
	local status = tonumber(getPlayerData("characters","ID",getCharacterID(client),"quest_wood_removed"))
	if(status == 0)then
		if(hasPlayerItem(client,9) >= 50)then
			takeItem(client,9,50)
			dbExec(handler,"UPDATE characters SET quest_wood_removed = '1' WHERE ID = '"..getCharacterID(client).."'")
			triggerClientEvent(client,"MetalDetector.destroyClientWood",client)
		else
			NPC.MeMessage(client,getText(client,"SMetalDetector3"))
		end
	end
end)