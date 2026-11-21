SurvivorPass = {}

local Upgrade2Pickup = createPickup(2763.1469726562,-2377.6220703125,819.23999023438,3,1239,50)
setElementInterior(Upgrade2Pickup,5)

addEventHandler("onPickupHit",Upgrade2Pickup,function(player)
	if getElementDimension(player) == getElementDimension(source) then
		if getElementInterior(player) == getElementInterior(source) then
			if not isPedInVehicle(player) then
				triggerClientEvent(player,"SurvivorPass.openLastUpgradeWindow",player)
			end
		end
	end
end)

addEvent("SurvivorPass.checkFinished",true)
addEventHandler("SurvivorPass.checkFinished",root,function()
	if hasPlayerItem(client,24) >= 1 and tonumber(getPlayerData("characters","ID",getCharacterID(client),"survivorpass_level")) >= 1 then
		NPC.NormalMessage(client,getText(client,"SSurvivorPass9"))
		giveRadioData(client,12)
	else
		triggerClientEvent(client,"SurvivorPass.windowGUI",client)
	end
end)

addEvent("SurvivorPass.check",true)
addEventHandler("SurvivorPass.check",root,function()
	local quest_1,quest_2,quest_3,quest_4,quest_5,quest_6,quest_7,quest_8,quest_9,quest_10,quest_11,quest_12,quest_13,quest_14 = 0,0,0,0,0,0,0,0,0,0,0,0,0,0

	local looted_dumpsters = tonumber(getPlayerData("character_stats","character_id",getCharacterID(client),"looted_dumpsters")) or 0
	local looted_vehicles = tonumber(getPlayerData("character_stats","character_id",getCharacterID(client),"looted_vehicles")) or 0
	local looted_houses = tonumber(getPlayerData("character_stats","character_id",getCharacterID(client),"looted_houses")) or 0
	local looted_places = tonumber(getPlayerData("character_stats","character_id",getCharacterID(client),"looted_places")) or 0

	if apocalypseGetElementData(client,"tutorialtask") >= 8 then quest_1 = 1 end
	if looted_dumpsters >= 5 and looted_vehicles >= 5 and looted_houses >= 5 then quest_2 = 1 end
	if tonumber(apocalypseGetElementData(client,"level")) >= 10 then quest_3 = 1 end
	if hasPlayerOutfit(client,1) == true and hasPlayerOutfit(client,2) == true then quest_4 = 1 end
	if tonumber(apocalypseGetElementData(client,"playtime")) >= 30 then quest_5 = 1 end
	if tonumber(apocalypseGetElementData(client,"zombiekills")) >= 100 then quest_6 = 1 end
	
	local NPCData = getPlayerData("characters", "ID", getCharacterID(client), "npcData")
	local values = split(tostring(NPCData), "|")
	local amount = 0
	
	if NPCData then
		for _, v in pairs(values) do
			amount = amount + 1
		end
		if amount >= 10 then quest_7 = 1 end
	end
	
	local result = dbPoll(dbQuery(handler,"SELECT * FROM vehicles WHERE owner_character_id = '"..getCharacterID(client).."'"),-1)
	if #result >= 1 then
		quest_8 = 1
	end

	if tonumber(looted_places) >= 5 then quest_9 = 1 end
	if tonumber(getPlayerData("character_stats","character_id",getCharacterID(client),"finished_quest")) >= 5 then
		quest_10 = 1
	end
	if tonumber(apocalypseGetElementData(client,"playtime")) >= 120 then quest_11 = 1 end
	if tonumber(apocalypseGetElementData(client,"zombiekills")) >= 250 then quest_12 = 1 end
	
	local Stats = getPlayerData("characters", "ID", getCharacterID(client), "npc_stats")
    if Stats then
        local StatsPairs = split(Stats, "|")
        local count = 0
        for _, v in pairs(StatsPairs) do
            local statsInfo = split(v, ",")
            local presents = tonumber(statsInfo[2]) or 0
			
            if presents >= 1 then
                count = count + 1
                if count >= 5 then
                    quest_13 = 1
					break
                end
            end
        end
    end

	if tonumber(apocalypseGetElementData(client,"level")) >= 15 then quest_14 = 1 end
	
	triggerClientEvent(client,"SurvivorPass.updateClient",client,quest_1,quest_2,quest_3,quest_4,quest_5,quest_6,quest_7,quest_8,quest_9,quest_10,quest_11,quest_12,quest_13,quest_14)
end)

addEvent("SurvivorPass.givePass",true)
addEventHandler("SurvivorPass.givePass",root,function()
	local quest_1,quest_2,quest_3,quest_4,quest_5,quest_6,quest_7 = 0,0,0,0,0,0,0
	local looted_dumpsters = tonumber(getPlayerData("character_stats","character_id",getCharacterID(client),"looted_dumpsters")) or 0
	local looted_vehicles = tonumber(getPlayerData("character_stats","character_id",getCharacterID(client),"looted_vehicles")) or 0
	local looted_houses = tonumber(getPlayerData("character_stats","character_id",getCharacterID(client),"looted_houses")) or 0

	if apocalypseGetElementData(client,"tutorialtask") >= 8 then quest_1 = 1 end
	if looted_dumpsters >= 5 and looted_vehicles >= 5 and looted_houses >= 5 then quest_2 = 1 end
	if tonumber(apocalypseGetElementData(client,"level")) >= 10 then quest_3 = 1 end
	if hasPlayerOutfit(client,1) == true and hasPlayerOutfit(client,2) == true then quest_4 = 1 end
	if tonumber(apocalypseGetElementData(client,"playtime")) >= 60 then quest_5 = 1 end
	if tonumber(apocalypseGetElementData(client,"zombiekills")) >= 100 then quest_6 = 1 end
	
	local NPCData = getPlayerData("characters", "ID", getCharacterID(client), "npcData")
	local values = split(tostring(NPCData), "|")
	local amount = 0
	
	if NPCData then
		for _, v in pairs(values) do
			amount = amount + 1
		end
		if amount >= 10 then quest_7 = 1 end
	end

	if quest_1 == 1 and quest_2 == 1 and quest_3 == 1 and quest_4 == 1 and quest_5 == 1 and quest_6 == 1 and quest_7 == 1 then
		if hasPlayerItem(client,24) == 0 then
			giveItem(client,24,1)
			givePlayerSkillpoint(client,50)
			giveEXP(client,3500)
			givePlayerServerMoney(client,500)
			NPC.NormalMessage(client,getText(client,"SSurvivorPass2"))
			outputLog(getPlayerName(client).." hat den Survivor Pass erhalten", "Survivor Pass", getCharacterID(client))
		else
			NPC.NormalMessage(client,getText(client,"SSurvivorPass4"))
		end
	else
		NPC.NormalMessage(client,getText(client,"SSurvivorPass1"))
	end

    triggerClientEvent(client,"closeWindow",client)
    triggerClientEvent(client,"SurvivorPass.receiveOverlayData",client,{})
    triggerEvent("SurvivorPass.requestOverlayData", client)
end)

addEvent("SurvivorPass.givePassUpgrade",true)
addEventHandler("SurvivorPass.givePassUpgrade",root,function()
	if hasPlayerItem(client,24) >= 1 then
		local quest_8,quest_9,quest_10,quest_11,quest_12,quest_13,quest_14 = 0,0,0,0,0,0,0
		local looted_places = tonumber(getPlayerData("character_stats","character_id",getCharacterID(client),"looted_places")) or 0
		
		local result = dbPoll(dbQuery(handler,"SELECT * FROM vehicles WHERE owner_character_id = '"..getCharacterID(client).."'"),-1)
		if #result >= 1 then
			quest_8 = 1
		end
		if tonumber(looted_places) >= 5 then quest_9 = 1 end
		if tonumber(getPlayerData("character_stats","character_id",getCharacterID(client),"finished_quest")) >= 5 then
			quest_10 = 1
		end
		if tonumber(apocalypseGetElementData(client,"playtime")) >= 120 then quest_11 = 1 end
		if tonumber(apocalypseGetElementData(client,"zombiekills")) >= 250 then quest_12 = 1 end
		
		local Stats = getPlayerData("characters", "ID", getCharacterID(client), "npc_stats")
		if Stats then
			local StatsPairs = split(Stats, "|")
			local count = 0
			for _, v in pairs(StatsPairs) do
				local statsInfo = split(v, ",")
				local presents = tonumber(statsInfo[2]) or 0
				
				if presents >= 1 then
					count = count + 1
					if count >= 5 then
						quest_13 = 1
						break
					end
				end
			end
		end

		if tonumber(apocalypseGetElementData(client,"level")) >= 15 then quest_14 = 1 end
		
		if quest_8 == 1 and quest_9 == 1 and quest_10 == 1 and quest_11 == 1 and quest_12 == 1 and quest_13 == 1 and quest_14 == 1 then
			local oldLevel = tonumber(getPlayerData("characters","ID",getCharacterID(client),"survivorpass_level")) or 0
			if oldLevel < 1 then
				local newLevel = 1
				dbExec(handler,"UPDATE characters SET survivorpass_level = '"..newLevel.."' WHERE ID = '"..getCharacterID(client).."'")
				NPC.NormalMessage(client,getText(client,"SSurvivorPass3"):format(newLevel))
				giveEXP(client,3500 * newLevel)
				givePlayerServerMoney(client,500 * newLevel)
				givePlayerSkillpoint(client,50 * newLevel)
				triggerClientEvent(client,"closeWindow",client)
				NPC.NormalMessage(client,getText(client,"SSurvivorPass9"))
				giveRadioData(client,12)
				outputLog(getPlayerName(client).." hat das erste Survivor Upgrade erhalten", "Survivor Pass", getCharacterID(client))
			else
				NPC.NormalMessage(client,getText(client,"SSurvivorPass5"))
			end
		else
			NPC.NormalMessage(client,getText(client,"SSurvivorPass1"))
		end
	else
		NPC.NormalMessage(client,getText(client,"SSurvivorPass8"))
	end

    triggerEvent("SurvivorPass.requestOverlayData", client)
end)

addEvent("SurvivorPass.giveLastUpgrade",true)
addEventHandler("SurvivorPass.giveLastUpgrade",root,function()
	if hasPlayerItem(client,24) >= 1 then
		local zombieKills = tonumber(apocalypseGetElementData(client,"zombiekills")) or 0
		local oldLevel = tonumber(getPlayerData("characters","ID",getCharacterID(client),"survivorpass_level")) or 0
		local money = tonumber(apocalypseGetElementData(client,"money")) or 0
		local brainmass = tonumber(hasPlayerItem(client,1)) or 0

		if zombieKills >= 1000 then
			if oldLevel >= 1 then
				if oldLevel < 2 then
					if money >= 7500 and brainmass >= 1000 then
						local newLevel = 2
						dbExec(handler,"UPDATE characters SET survivorpass_level = '"..newLevel.."' WHERE ID = '"..getCharacterID(client).."'")
						NPC.NormalMessage(client,getText(client,"SSurvivorPass3"):format(newLevel))
						giveEXP(client,3500 * newLevel)
						givePlayerServerMoney(client,500 * newLevel)
						givePlayerSkillpoint(client,50 * newLevel)
						triggerClientEvent(client,"closeWindow",client)
						takeItem(client,1,1000)
						apocalypseSetElementData(client,"money",money - 7500)
						dbExec(handler,"UPDATE character_stats SET survivor_pass_abo = '0' WHERE character_id = '"..getCharacterID(client).."'")
						outputLog(getPlayerName(client).." hat das zweite Survivor Pass Upgrade erhalten", "Survivor Pass", getCharacterID(client))
					else
						NPC.MeMessage(client,getText(client,"SSurvivorPass7"))
					end
				else
					createInfobox(client,getText(client,"SSurvivorPass5"))
				end
			else
				NPC.MeMessage(client,getText(client,"SSurvivorPass6"))
			end
		else
			createInfobox(client,getText(client,"SSurvivorPass1"))
		end
	else
		NPC.NormalMessage(client,getText(client,"SSurvivorPass8"))
	end

    triggerEvent("SurvivorPass.requestOverlayData", client)
end)

addEvent("SurvivorPass.Abo",true)
addEventHandler("SurvivorPass.Abo",root,function()
	local status = tonumber(getPlayerData("character_stats","character_id",getCharacterID(client),"survivor_pass_abo")) or 0

	if status ~= 1 then
		local money = tonumber(apocalypseGetElementData(client,"money")) or 0
		if hasPlayerItem(client,24) == 1 then
			if money >= 1500 then
				apocalypseSetElementData(client,"money",money - 1500)
				NPC.MeMessage(client,getText(client,"SSurvivorPass11"))
				dbExec(handler,"UPDATE character_stats SET survivor_pass_abo = '1' WHERE character_id = '"..getCharacterID(client).."'")
				triggerClientEvent(client,"closeWindow",client)
				outputLog(getPlayerName(client).." hat das Survivor Pass Abo abgeschlossen", "Survivor Pass", getCharacterID(client))
			else
				NPC.MeMessage(client,getText(client,"SSurvivorPass10"))
			end
		else
			NPC.MeMessage(client,getText(client,"SSurvivorPass16"))
		end
	elseif status == 1 then
		NPC.MeMessage(client,getText(client,"SSurvivorPass12"))
		dbExec(handler,"UPDATE character_stats SET survivor_pass_abo = '0' WHERE character_id = '"..getCharacterID(client).."'")
		triggerClientEvent(client,"closeWindow",client)
		outputLog(getPlayerName(client).." hat sein Survivor Pass Abo gekündigt", "Survivor Pass", getCharacterID(client))
	end

    triggerEvent("SurvivorPass.requestOverlayData", client)
end)

addEvent("SurvivorPass.AboOpen",true)
addEventHandler("SurvivorPass.AboOpen",root,function()
	local status = tonumber(getPlayerData("character_stats","character_id",getCharacterID(client),"survivor_pass_abo")) or 0
	triggerClientEvent(client,"SurvivorPass.openAboWindow",client,status)
end)

addEvent("SurvivorPass.requestOverlayData", true)
addEventHandler("SurvivorPass.requestOverlayData", root, function()
    local player = client or source
    if not isElement(player) then return end
	local levelDisplay = "/"

    local charID = getCharacterID(player)
    if not charID then return end

    local level = tonumber(getPlayerData("characters","ID",charID,"survivorpass_level")) or 0
    local abo = tonumber(getPlayerData("character_stats","character_id",charID,"survivor_pass_abo")) or 0
	if(level == 1)then levelDisplay = level end

    local looted_dumpsters = tonumber(getPlayerData("character_stats","character_id",charID,"looted_dumpsters")) or 0
    local looted_vehicles = tonumber(getPlayerData("character_stats","character_id",charID,"looted_vehicles")) or 0
    local looted_houses = tonumber(getPlayerData("character_stats","character_id",charID,"looted_houses")) or 0
    local looted_places = tonumber(getPlayerData("character_stats","character_id",charID,"looted_places")) or 0
    local tutorialtask = tonumber(apocalypseGetElementData(player,"tutorialtask")) or 0
    local plrLevel = tonumber(apocalypseGetElementData(player,"level")) or 0
    local playtime = tonumber(apocalypseGetElementData(player,"playtime")) or 0
    local zombiekills = tonumber(apocalypseGetElementData(player,"zombiekills")) or 0
    local finished_quest = tonumber(getPlayerData("character_stats","character_id",charID,"finished_quest")) or 0
    local money = tonumber(apocalypseGetElementData(player,"money")) or 0
    local brainmass = tonumber(hasPlayerItem(player,1)) or 0

    local npcCount = 0
    local NPCData = getPlayerData("characters", "ID", charID, "npcData")
    if NPCData and tostring(NPCData) ~= "" then
        local values = split(tostring(NPCData), "|")
        for _, _ in pairs(values) do
            npcCount = npcCount + 1
        end
    end

    local presentCount = 0
    local Stats = getPlayerData("characters", "ID", charID, "npc_stats")
    if Stats and tostring(Stats) ~= "" then
        local StatsPairs = split(Stats, "|")
        for _, v in pairs(StatsPairs) do
            local statsInfo = split(v, ",")
            local presents = tonumber(statsInfo[2]) or 0
            if presents >= 1 then
                presentCount = presentCount + 1
            end
        end
    end

    local vehicleOwned = false
    local result = dbPoll(dbQuery(handler,"SELECT * FROM vehicles WHERE owner_character_id = '"..charID.."'"),-1)
    if result and #result >= 1 then
        vehicleOwned = true
    end

    local hasPass = hasPlayerItem(player,24) >= 1
    local hasOutfits = (hasPlayerOutfit(player,1) == true and hasPlayerOutfit(player,2) == true)

    local tasks = {}
    local hint = ""

    if not hasPass then
        tasks = {
            { text = getText(player, "CSurvivorPassDisplay6") .. ": " .. math.min(tutorialtask, 8) .. "/8", done = tutorialtask >= 8 },
            { text = getText(player, "CSurvivorPassDisplay7") .. ": " .. math.min(looted_dumpsters, 5) .. "/5", done = looted_dumpsters >= 5 },
            { text = getText(player, "CSurvivorPassDisplay8") .. ": " .. math.min(looted_vehicles, 5) .. "/5", done = looted_vehicles >= 5 },
            { text = getText(player, "CSurvivorPassDisplay9") .. ": " .. math.min(looted_houses, 5) .. "/5", done = looted_houses >= 5 },
            { text = getText(player, "CSurvivorPassDisplay10") .. ": " .. math.min(plrLevel, 10) .. "/10", done = plrLevel >= 10 },
            { text = getText(player, "CSurvivorPassDisplay11"), done = hasOutfits },
            { text = getText(player, "CSurvivorPassDisplay12") .. ": " .. math.min(playtime, 60) .. "/60", done = playtime >= 60 },
            { text = getText(player, "CSurvivorPassDisplay13") .. ": " .. math.min(zombiekills, 100) .. "/100", done = zombiekills >= 100 },
            { text = getText(player, "CSurvivorPassDisplay14") .. ": " .. math.min(npcCount, 10) .. "/10", done = npcCount >= 10 }
        }
        hint = getText(player, "CSurvivorPassDisplay15")
    elseif level < 1 then
        tasks = {
            { text = getText(player, "CSurvivorPassDisplay16"), done = vehicleOwned },
            { text = getText(player, "CSurvivorPassDisplay17") .. ": " .. math.min(looted_places, 5) .. "/5", done = looted_places >= 5 },
            { text = getText(player, "CSurvivorPassDisplay18") .. ": " .. math.min(finished_quest, 5) .. "/5", done = finished_quest >= 5 },
            { text = getText(player, "CSurvivorPassDisplay12") .. ": " .. math.min(playtime, 120) .. "/120", done = playtime >= 120 },
            { text = getText(player, "CSurvivorPassDisplay13") .. ": " .. math.min(zombiekills, 250) .. "/250", done = zombiekills >= 250 },
            { text = getText(player, "CSurvivorPassDisplay19") .. ": " .. math.min(presentCount, 5) .. "/5", done = presentCount >= 5 },
            { text = getText(player, "CSurvivorPassDisplay10") .. ": " .. math.min(plrLevel, 15) .. "/15", done = plrLevel >= 15 }
        }
        hint = getText(player, "CSurvivorPassDisplay20")
    elseif level < 2 then
        tasks = {
            { text = getText(player, "CSurvivorPassDisplay13") .. ": " .. math.min(zombiekills, 1000) .. "/1000", done = zombiekills >= 1000 },
            { text = getText(player, "CSurvivorPassDisplay21") .. ": $" .. math.min(money, 7500) .. "/7500", done = money >= 7500 },
            { text = getText(player, "CSurvivorPassDisplay22") .. ": " .. math.min(brainmass, 1000) .. "/1000", done = brainmass >= 1000 }
        }
        hint = getText(player, "CSurvivorPassDisplay23")
    else
        --[[tasks = {
            { text = getText(player, "CSurvivorPassDisplay24"), done = true }
        }
        hint = getText(player, "CSurvivorPassDisplay25")]]--
    end

    triggerClientEvent(player, "SurvivorPass.receiveOverlayData", player, {
        level = levelDisplay,
        abo = abo,
        tasks = tasks,
        hint = hint
    })
end)