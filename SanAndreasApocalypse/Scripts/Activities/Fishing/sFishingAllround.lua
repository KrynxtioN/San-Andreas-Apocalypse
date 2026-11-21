Fishing = {
	marker = {},
	["MarkerPosition"] = {
		-- Santa Maria Beach
		[1] = {403.8399, -2088.4919, 7.6109, false},
		[2] = {398.74319, -2088.6821, 7.6109, false},
		[3] = {396.19421, -2088.7522, 7.6109, false},
		[4] = {391.06699, -2088.7432, 7.6109, false},
		[5] = {383.44009, -2088.7781, 7.6109, false},
		[6] = {374.98709, -2088.7856, 7.6109, false},
		[7] = {369.8335, -2088.7273, 7.6109, false},
		[8] = {367.28311, -2088.7476, 7.6109, false},
		[9] = {362.2059, -2088.7373, 7.6109, false},
		[10] = {354.5256, -2088.6484, 7.6109, false},
		
		-- Loch Ness
		[11] = {2101.8513183594,-104.71347045898,2.2681813240051-0.2,false},
	},
}

local LOCH_NESS_BAIT_ID = 209
local LOCH_NESS_CHANCE = 1

local fishNames = {
	["DE"] = {
		[133] = "Glühkiefer",
		[134] = "Blitzflosse",
		[135] = "Schleicher",
		[136] = "Streifenclown",
		[137] = "Korallenritter",
		[138] = "Pustekugel",
		[139] = "Strömungsschnapper",
		[140] = "Riffgleiter",
		[141] = "Blubberlin",
		[142] = "Sonnenflosser",
	},
	["EN"] = {
		[133] = "Glowjaw",
		[134] = "Flashfin",
		[135] = "Creeper",
		[136] = "Stripeclown",
		[137] = "Coral Knight",
		[138] = "Puffball",
		[139] = "Current Snapper",
		[140] = "Reef Glider",
		[141] = "Blubberlin",
		[142] = "Sunfin",
	},
	["RU"] = {
		[133] = "Светочелюсть",
		[134] = "Громоплавник",
		[135] = "Крипер",
		[136] = "Полосатый клоун",
		[137] = "Рыцарь кораллов",
		[138] = "Пухляш",
		[139] = "Токовый щелкун",
		[140] = "Рифовый скользун",
		[141] = "Пузырьлин",
		[142] = "Солнечный плавник",
	},
	["PT"] = {
		[133] = "Mandíbula Brilhante",
		[134] = "Barbatrovão",
		[135] = "Assombrador",
		[136] = "Palhaço Listrado",
		[137] = "Cavaleiro Coral",
		[138] = "Bolinchudo",
		[139] = "Estalador da Corrente",
		[140] = "Planador de Recife",
		[141] = "Borbulhinho",
		[142] = "Barbatana Solar",
	},
}

local Achievements = {
	{1,273},
	{10,274},
	{25,275},
	{50,276},
	{75,277},
	{125,278},
	{175,279},
	{225,280},
	{300,281},
	{375,282},
	{500,283},
}

function Fishing.loadMarker()
	for i,v in ipairs(Fishing["MarkerPosition"])do
		Fishing.marker[i] = createMarker(v[1],v[2],v[3]-0.60,"cylinder",1,255,255,255,150)
		apocalypseSetElementData(Fishing.marker[i],"FishingMarkerID",i)
		
		addEventHandler("onMarkerHit",Fishing.marker[i],function(player)
			if(getElementType(player) == "player")then
				apocalypseSetElementData(player,"FishingMarkerID",apocalypseGetElementData(source,"FishingMarkerID"))

				if(Fishing["MarkerPosition"][apocalypseGetElementData(source,"FishingMarkerID")][4] == false)then
					if(apocalypseGetElementData(player,"FishingStartBind") ~= true)then
						bindKey(player,"e","down",Fishing.start)
						bindKey(player,"backspace","down",Fishing.stop)
						apocalypseSetElementData(player,"FishingStartBind",true)
						toggleAllControls(player,false)
						setElementFrozen(player,true)

						Fishing["MarkerPosition"][apocalypseGetElementData(source,"FishingMarkerID")][4] = true
						apocalypseSetElementData(player,"isPlayerFishing",true)
						apocalypseSetElementData(player,"FishingBait",false)

						triggerClientEvent(player,"JobInformation.createWindow",player,4)
						triggerClientEvent(player,"Fishing.renderText",player)
					end
				end
			end
		end)
	end
end
Fishing.loadMarker()

function Fishing.start(player)
	triggerClientEvent(player,"Fishing.renderBait",player)
end

function Fishing.playerFishing(player,bait)
	if(not(player))then player = client end

	bait = tonumber(bait) or 0

	local FishingMarkerID = apocalypseGetElementData(player,"FishingMarkerID")
	if(FishingMarkerID)then
		if(hasPlayerItem(player,112) >= 1)then
			if(bait ~= 0)then
				if(hasPlayerItem(player,bait) >= 1)then
					takeItem(player,bait,1)
				else
					NPC.MeMessage(player,getText(player,"SFishing4"))
					return
				end
			end

			takeItem(player,112,1)

			apocalypseSetElementData(player,"FishingBait",bait)
			apocalypseSetElementData(player,"FishingStartBind",false)

			unbindKey(player,"e","down",Fishing.start)

			triggerClientEvent(player,"Fishing.start",player,bait)

			outputLog(getPlayerName(player).." hat angefangen zu angeln (Köder: "..bait..")", "Fishing", getCharacterID(player))
		else
			NPC.MeMessage(player,getText(player,"SFishing3"))
		end
	end
end
addEvent("Fishing.playerFishing",true)
addEventHandler("Fishing.playerFishing",root,Fishing.playerFishing)

addEvent("Fishing.giveFish",true)
addEventHandler("Fishing.giveFish",root,function(fishID,experience)
	local fishID = tonumber(fishID)
	local experience = tonumber(experience)

	local language = apocalypseGetElementData(client,"language") or "EN"
	local fishName = fishNames[language][fishID] or fishNames["EN"][fishID] or "Fish"

	local shellsAmount = math.random(3,5)
	local amount = 1
	local shell_amount = 1

	if(SERVERBONUS.FISHING == true)then
		amount = 2
		shell_amount = 5
	end

	giveItem(client,fishID,amount)
	giveEXP(client,experience)

	bindKey(client,"e","down",Fishing.start)
	apocalypseSetElementData(client,"FishingStartBind",true)

	NPC.MeMessage(client,getText(client,"SFishing2"):format(fishName))

	giveItem(client,67,shellsAmount)
	triggerClientEvent(client, "showItemBar", client, {{67,shell_amount},{fishID,amount}})
	
	local catched_fish = tonumber(getPlayerData("character_stats","character_id",getCharacterID(client),"catched_fish")) or 0
	Characters.addStats(client,"catched_fish",catched_fish + 1)
	
	local FishingMarkerID = tonumber(apocalypseGetElementData(client,"FishingMarkerID"))
	local usedBait = tonumber(apocalypseGetElementData(client,"FishingBait"))

	if(FishingMarkerID == 11 and usedBait == LOCH_NESS_BAIT_ID)then
		local rnd = math.random(1,LOCH_NESS_CHANCE)
		if(rnd == 1)then
			LochNess.SwimAndDive()
			NPC.MeMessage(client,getText(client,"SLochNess1"))
			setAchievement(client,457)
			givePlayerPhoto(client,6)
		end
	end

	apocalypseSetElementData(client,"FishingBait",false)
	
	outputLog(getPlayerName(client).." hat einen Fisch gefangen ("..fishNames["DE"][fishID]..")","Fishing",getCharacterID(client))
	
	for _,v in pairs(Achievements)do
		if(catched_fish + 1 >= v[1])then
			setAchievement(client,v[2])
		end
	end
	
	if(DailyTasks.playerTasks[client] and DailyTasks.playerTasks[client][13])then
		DailyTasks.updateProgress(client,13,DailyTasks.playerTasks[client][13].progress + 1)
	end
	
	if(WeeklyTasks.playerTasks[client] and WeeklyTasks.playerTasks[client][13])then
		WeeklyTasks.updateProgress(client,13,WeeklyTasks.playerTasks[client][13].progress + 1)
	end
end)

addEvent("Fishing.fail",true)
addEventHandler("Fishing.fail",root,function()
	bindKey(client,"e","down",Fishing.start)
	apocalypseSetElementData(client,"FishingStartBind",true)
	apocalypseSetElementData(client,"FishingBait",false)
end)

function Fishing.stop(player)
	local FishingMarkerID = apocalypseGetElementData(player,"FishingMarkerID")

	apocalypseSetElementData(player,"FishingStartBind",false)
	apocalypseSetElementData(player,"FishingBait",false)
	apocalypseSetElementData(player,"isPlayerFishing",false)

	unbindKey(player,"e","down",Fishing.start)
	unbindKey(player,"backspace","down",Fishing.stop)

	triggerClientEvent(player,"stopFishingMiniGame",player)

	setElementFrozen(player,false)
	toggleAllControls(player,true)

	triggerClientEvent(player,"Fishing.unrenderText",player)

	if(FishingMarkerID and Fishing["MarkerPosition"][FishingMarkerID])then
		Fishing["MarkerPosition"][FishingMarkerID][4] = false
	end
end

addEventHandler("onPlayerWasted",root,function()
	if(apocalypseGetElementData(source,"isPlayerFishing") and apocalypseGetElementData(source,"isPlayerFishing") == true)then
		Fishing.stop(source)
	end
end)

addEventHandler("onPlayerQuit",root,function()
	if(apocalypseGetElementData(source,"isPlayerFishing") and apocalypseGetElementData(source,"isPlayerFishing") == true)then
		Fishing.stop(source)
	end
end)