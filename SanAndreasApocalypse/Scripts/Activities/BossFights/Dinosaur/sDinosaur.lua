Spinosaurus = {entryMarker = {}, playerPos = {},
	["Entrys"] = {
		{2305.6809082031,-432.74508666992,84.249603271484,7.5},
		{2145.6306152344,-410.02020263672,83.293197631836,5},
		{2189.7880859375,-647.69647216797,73.907897949219,5},
	},
	["OutSpawn"] = {
		[1] = {2309.5119628906,-424.11712646484,82.140472412109},
		[2] = {2142.2287597656,-406.76916503906,79.371841430664},
		[3] = {2187.1557617188,-652.82305908203,69.872009277344},
	},
}

function Spinosaurus.createEntrys()
	for i,v in pairs(Spinosaurus["Entrys"])do
		Spinosaurus.entryMarker[i] = createMarker(v[1],v[2],v[3],"cylinder",v[4],255,255,255,0)
		apocalypseSetElementData(Spinosaurus.entryMarker[i],"Open",false)
		apocalypseSetElementData(Spinosaurus.entryMarker[i],"ID",i)
		
		addEventHandler("onMarkerHit",Spinosaurus.entryMarker[i],function(player)
			if(getElementType(player) == "player")then
				if(not(isPedInVehicle(player)))then
					if(getElementDimension(player) == getElementDimension(source))then
						if(apocalypseGetElementData(player,"cantentercave") ~= true)then
							apocalypseSetElementData(player,"SpinosaurusEntryID",apocalypseGetElementData(source,"ID"))
							if(apocalypseGetElementData(source,"Open") == true)then
								Spinosaurus.enterCave(player)
							else
								if(apocalypseGetElementData(player,"Spinosaurus.bindKey") ~= true)then
									apocalypseSetElementData(player,"Spinosauruscave.bindKey",true)
									bindKey(player,"e","down",Spinosaurus.bindKey)
								end
								NPC.MeMessage(player,getText(player,"SDinosaur1"))
								triggerClientEvent(player,"createInformationMessage",player,getText(player,"SDinosaur3"))
							end
						else
							setTimer(function(player)
								apocalypseSetElementData(player,"cantentercave",false)
							end,10000,1,player)
						end
					end
				end
			end
		end)
		
		addEventHandler("onMarkerLeave",Spinosaurus.entryMarker[i],function(player)
			if(getElementType(player) == "player")then
				apocalypseSetElementData(player,"Spinosauruscave.bindKey",false)
				unbindKey(player,"e","down",Spinosaurus.bindKey)
			end
		end)
	end
end
Spinosaurus.createEntrys()

function Spinosaurus.bindKey(player)
	if(hasPlayerItem(player,102) >= 2)then
		takeItem(player,102,2)
		apocalypseSetElementData(player,"Spinosauruscave.bindKey",false)
		unbindKey(player,"e","down",Spinosaurus.bindKey)
		Spinosaurus.enterCave(player)
	else NPC.MeMessage(player,getText(player,"SDinosaur4"))end
end

local Achievements = {
	{3,423},
	{5,424},
	{7,425},
	{10,426},
	{15,427},
	{25,428},
	{35,429},
	{50,430},
}

addEvent("Spinosaurus.died",true)
addEventHandler("Spinosaurus.died",root,function()
	if(DailyTasks.playerTasks[client][23])then
		DailyTasks.updateProgress(client,23,DailyTasks.playerTasks[client][23].progress + 1)
	end
	
	if(WeeklyTasks.playerTasks[client][23])then
		WeeklyTasks.updateProgress(client,23,WeeklyTasks.playerTasks[client][23].progress + 1)
	end
	
	local killed_spinosaurus = tonumber(getPlayerData("character_stats","character_id",getCharacterID(client),"killed_spinosaurus"))
	Characters.addStats(client,"killed_spinosaurus",killed_spinosaurus + 1)
	
	setAchievement(client,317)
	
	for _,v in pairs(Achievements)do
		if(killed_spinosaurus + 1 >= v[1])then
			setAchievement(client,v[2])
		end
	end

	outputLog(getPlayerName(client).." hat einen Spinosaurus getötet", "Spinosaurus", getCharacterID(client))
end)

addEvent("Spinosaurus.leaveCave",true)
addEventHandler("Spinosaurus.leaveCave",root,function()
	local pos = Spinosaurus["OutSpawn"][apocalypseGetElementData(client,"SpinosaurusEntryID")]
	setElementPosition(client,pos[1],pos[2],pos[3])
	setElementDimension(client,0)
	triggerClientEvent(client,"Spinosaurus.destroy",client)
end)

addEvent("Spinosaurus.collectBone",true)
addEventHandler("Spinosaurus.collectBone",root,function()
	local amount = 1
	if(SERVERBONUS.SPINOSAURUS == true)then amount = 2 end
	giveItem(client,193,amount)
	triggerClientEvent(client, "showItemBar", client, {{193,amount}})
	
	local EXP = 750
	local Level_Bonus_EXP = tonumber(apocalypseGetElementData(client,"level"))
	if(Level_Bonus_EXP > 100)then Level_Bonus_EXP = 100 end
	EXP = EXP + (25 * Level_Bonus_EXP)
	
	giveEXP(client, EXP)

	givePlayerPhoto(client,3)
	giveRadioData(client,23)
	
	triggerClientEvent(client,"SpinosaurusClub.destroyGate",client)
end)

function Spinosaurus.openCaves()
	for _,v in pairs(Spinosaurus.entryMarker)do
		apocalypseSetElementData(v,"Open",true)
	end
end

function Spinosaurus.closeCaves()
	for _,v in pairs(Spinosaurus.entryMarker)do
		apocalypseSetElementData(v,"Open",false)
	end
end

addEventHandler("onPlayerWasted",root,function()
	apocalypseSetElementData(source,"Spinosauruscave.bindKey",false)
	unbindKey(source,"e","down",Spinosaurus.bindKey)
end)