PlayerItems = {counter = {}}

local function item_check_save(player)
	if(not(PlayerItems.counter[player]))then PlayerItems.counter[player] = 0 end
	PlayerItems.counter[player] = PlayerItems.counter[player] + 1
	if(PlayerItems.counter[player] >= 75)then
		PlayerItems.counter[player] = 0
		savePlayerItems(player)
	end
end

function hasPlayerItem(player, itemID)
	if(isCharacterLoggedIn(player))then
		local amount = 0
		if(PlayerItems[player])then
			for i, v in ipairs(PlayerItems[player]) do
				if(v.item == itemID)then
					amount = v.amount
					break
				end
			end
		end
		return amount
	end
end

function takeItem(player, itemID, amount)
    for i, v in ipairs(PlayerItems[player]) do
        local storedItemID = tonumber(v.item)
        local requestedItemID = tonumber(itemID)
        
        if(storedItemID == requestedItemID)then
            v.amount = v.amount - amount

            if(v.amount <= 0)then
                table.remove(PlayerItems[player], i)
            end
            break
        end
    end
	item_check_save(player)
    updateClientItems(player)
	outputLog(getPlayerName(player).." wurde ein Item entfernt (ID: "..itemID..", Anzahl: "..amount..")", "Items", getCharacterID(player))
end

function loadPlayerItems(player)
    local itemString = getPlayerData("characters", "ID", getCharacterID(player), "items")
    if(itemString)then
        PlayerItems[player] = {}
		if(#itemString >= 1)then
			local itemPairs = split(itemString, "|")
			for _, v in ipairs(itemPairs)do
				local itemInfo = split(v, ",")
				local itemID = tonumber(itemInfo[1])
				local amount = tonumber(itemInfo[2])
				table.insert(PlayerItems[player], {item = itemID, amount = amount})
			end
		end
    end
	updateClientItems(player)
end

function giveItem(player, itemID, amount)
    if(not(PlayerItems[player]))then PlayerItems[player] = {} end
    local found = false
	local itemID = tonumber(itemID)
	local amount = tonumber(amount)
    
    for _,v in ipairs(PlayerItems[player])do
        if(v.item == itemID)then
            v.amount = v.amount + amount
            found = true
            break
        end
    end

    if(not(found))then
        table.insert(PlayerItems[player], {item = itemID, amount = amount})
    end
	item_check_save(player)
	updateClientItems(player)
	setAchievement(player, 35)
	outputLog(tostring(getPlayerName(player)).." hat ein Item bekommen (ID: "..tostring(itemID)..", Anzahl: "..tostring(amount)..")", "Items", getCharacterID(player))
end
addEvent("giveItem",true)
addEventHandler("giveItem",root,giveItem)

function savePlayerItems(player)
   if(isCharacterLoggedIn(player))then
        local items = ""
        for _, v in ipairs(PlayerItems[player])do
            items = items..v.item.."," ..v.amount.."|"
        end
        items = items:sub(1, -2)
        dbExec(handler, "UPDATE characters SET items = '" .. items .. "' WHERE ID = '" .. getCharacterID(player) .. "'")
    end
end

function updateClientItems(player)
	triggerClientEvent(player,"updatePlayerItems", player, PlayerItems[player])
end

local smokeTimer = {}
local drinkTimer = {}
local chestsSpam = {}
local chestsSpamTimer = {}

function setPlayerChestSpam(player)
	chestsSpam[player] = true
	if(isTimer(chestsSpamTimer[player]))then
		killTimer(chestsSpamTimer[player])
	end
	chestsSpamTimer[player] = setTimer(function(player)
		if(isElement(player))then
			chestsSpam[player] = false
		end
	end,10000,1,player)
end

function checkChestTimer(player)
	if(not(chestsSpam[player]))then
		chestsSpam[player] = false
	end
	if(chestsSpam[player] == true)then
		return false
	else
		return true
	end
end

addEvent("onPlayerItemDoubleClicked",true)
addEventHandler("onPlayerItemDoubleClicked",root,function(item)
	local item = tonumber(item)
	
	
	-- // Food & Drinks
	if(isItemEatable(item))then
		setPlayerEating(client,item)
	end
	
	if(isItemDrinkable(item))then
		setPlayerDrinking(client,item)
	end
	
	if(item == 2)then
		if(not(isTimer(smokeTimer[client])))then
			if(hasPlayerItem(client,3) >= 1)then
				toggleAllControls(client,false)
				setElementFrozen(client,true)
				setPedAnimation(client,"lowrider","m_smkstnd_loop")
				smokeTimer[client] = setTimer(function(client)
					setPedAnimation(client)
					setElementFrozen(client,false)
					toggleAllControls(client,true)
					if(getElementHealth(client) < 100)then
						setElementHealth(client,getElementHealth(client)+6)
						if(getElementHealth(client) > 100)then
							setElementHealth(client,100)
						end
					end
				end,10000,1,client)
				takeItem(client,2,1)
			else NPC.MeMessage(client,getText(client,"SInventory1"))end
		end
	elseif(item == 6)then
		if(isPedInVehicle(client))then
			local vehicle = getPedOccupiedVehicle(client)
			local fuel = apocalypseGetElementData(vehicle,"fuel")
			if(fuel < 100)then
				takeItem(client,6,1)
				apocalypseSetElementData(vehicle,"fuel",apocalypseGetElementData(vehicle,"fuel")+5)
				if(apocalypseGetElementData(vehicle,"fuel") > 100)then
					apocalypseSetElementData(vehicle,"fuel",100)
				end
			else NPC.MeMessage(client,getText(client,"SInventory3"))end
		else NPC.MeMessage(client,getText(client,"SInventory2"))end
	elseif(item == 8)then
		MechanicSkillRepairVehicle(client)
	elseif(item == 13)then
		local dice = math.random(1,6)
		local x,y,z = getElementPosition(client)
		takeItem(client,13,1)
		for _,v in pairs(getElementsByType("player"))do
			if(isCharacterLoggedIn(v))then
				if(getDistanceBetweenPoints3D(x,y,z,getElementPosition(v)) <= 10)then
					outputChatBox(getText(v,"SItems1"):format(getCharacterName(client),dice),v,0,125,0)
				end
			end
		end
	elseif(item == 15)then
		activateDoubleExperience(client)
		takeItem(client,15,1)
	elseif(item == 16)then
		activateDoubleMoney(client)
		takeItem(client,16,1)
	elseif(item == 17)then
		activateZombieImmune(client)
		takeItem(client,17,1)
	elseif(item == 19)then
		if(not(isTimer(smokeTimer[client])))then
			toggleAllControls(client,false)
			setElementFrozen(client,true)
			setPedAnimation(client,"lowrider","m_smkstnd_loop")
			smokeTimer[client] = setTimer(function(client)
				setPedAnimation(client)
				setElementFrozen(client,false)
				toggleAllControls(client,true)
				if(getElementHealth(client) < 100)then
					setElementHealth(client,getElementHealth(client)+25)
					if(getElementHealth(client) > 100)then
						setElementHealth(client,100)
					end
				end
			end,10000,1,client)
			takeItem(client,19,1)
		end
	elseif(item == 20)then
		if(not(isTimer(smokeTimer[client])))then
			toggleAllControls(client,false)
			setElementFrozen(client,true)
			setPedAnimation(client,"lowrider","m_smkstnd_loop")
			smokeTimer[client] = setTimer(function(client)
				setPedAnimation(client)
				setElementFrozen(client,false)
				toggleAllControls(client,true)
				if(getElementHealth(client) < 100)then
					setElementHealth(client,getElementHealth(client)+75)
					if(getElementHealth(client) > 100)then
						setElementHealth(client,100)
					end
				end
			end,10000,1,client)
			takeItem(client,20,1)
		end
	elseif(item == 28)then
		local medicSkill = getSkillLevel(client,1)
		local healing = 5
		if(medicSkill >= 1)then healing = 10 end
		if(medicSkill >= 2)then healing = 15 end
		if(medicSkill >= 3)then healing = 20 end
		if(medicSkill >= 4)then healing = 25 end
	
		setPedAnimation(client, "BOMBER", "BOM_Plant")
		takeItem(client,28,1)
		toggleAllControls(client,false)
		smokeTimer[client] = setTimer(function(client)
			setElementHealth(client,getElementHealth(client)+healing)
			if(getElementHealth(client) > 100)then
				setElementHealth(client,100)
			end
			setPedAnimation(client)
			setElementFrozen(client,false)
			toggleAllControls(client,true)
			if(getElementHealth(client) > 100)then
				setElementHealth(client,100)
			end
		end,2650,1,client)
	elseif(item == 35)then
		triggerClientEvent(client,"closeInventory",client)
		triggerClientEvent(client,"Objectsystem.createObject",client,1463)
	elseif(item == 38)then -- Christmas present

	elseif(item == 40)then -- Molotov
		takeItem(client,40,1)
		PlayerWeapons.addNewWeapon(client,18,1)
	elseif(item == 44 or item == 45 or item == 46 or item == 47)then
		PlayerWeapons.itemReload(client,item)
	elseif(item == 68)then
		takeItem(client,68,1)
		triggerClientEvent(client, "showTheRaffle", client, "SAACoinCrate")
	elseif(item == 69)then
		takeItem(client,69,1)
		triggerClientEvent(client,"showTheRaffle", client, "VehicleCrate")
	--------------------------------
	elseif(item == 72)then
		if(checkChestTimer(client) == true)then
			setPlayerChestSpam(client)
			takeItem(client,72,1)
			giveLootItems(client,15)
		else
			createInfobox(client,getText(client,"SChestTimer1"))
		end
	elseif(item == 73)then
		if(checkChestTimer(client) == true)then
			setPlayerChestSpam(client)
			takeItem(client,73,1)
			giveLootItems(client,25)
		else
			createInfobox(client,getText(client,"SChestTimer1"))
		end
	elseif(item == 74)then
		if(checkChestTimer(client) == true)then
			setPlayerChestSpam(client)
			takeItem(client,74,1)
			giveLootItems(client,50)
		else
			createInfobox(client,getText(client,"SChestTimer1"))
		end
	elseif(item == 75)then
		if(checkChestTimer(client) == true)then
			setPlayerChestSpam(client)
			takeItem(client,75,1)
			giveToolboxItems(client,15)
		else
			createInfobox(client,getText(client,"SChestTimer1"))
		end
	elseif(item == 76)then
		if(checkChestTimer(client) == true)then
			setPlayerChestSpam(client)
			takeItem(client,76,1)
			giveToolboxItems(client,25)
		else
			createInfobox(client,getText(client,"SChestTimer1"))
		end
	elseif(item == 77)then
		if(checkChestTimer(client) == true)then
			setPlayerChestSpam(client)
			takeItem(client,77,1)
			giveToolboxItems(client,50)
		else
			createInfobox(client,getText(client,"SChestTimer1"))
		end
	--------------------------------
	elseif(item == 82 or item == 83 or item == 84 or item == 121 or item == 184 or item == 210)then
		Plantsystem.plant(client,item)
	elseif(item == 93)then -- Treasure Map 1/3
		triggerClientEvent(client,"startRenderTreasureMapFromInventory",client,1)
	elseif(item == 94)then
		takeItem(client,94,1)
		local itemlist = {}
		local appleSeed, orangeSeed, hempSeed = math.random(1,2),math.random(1,2),math.random(1,2)
		table.insert(itemlist,{82,appleSeed})
		table.insert(itemlist,{83,orangeSeed})
		table.insert(itemlist,{84,hempSeed})
		local cactusSeed,mushroomSeed = 0,0
		if(math.random(0,100) <= 10)then cactusSeed = 1 end
		if(math.random(0,100) <= 30)then mushroomSeed = 1 end
		if(cactusSeed >= 1)then table.insert(itemlist,{122,cactusSeed}) end
		if(mushroomSeed >= 1)then table.insert(itemlist,{210,mushroomSeed}) end
		for _,v in pairs(itemlist)do
			giveItem(client,v[1],v[2])
		end
		triggerClientEvent(client, "showItemBar", client, {{82,appleSeed},{83,orangeSeed},{84,hempSeed},{122,cactusSeed},{210,mushroomSeed}})
	elseif(item == 103)then -- Treasure Map 2/3
		triggerClientEvent(client,"startRenderTreasureMapFromInventory",client,2)
	elseif(item == 104)then -- Treasure Map 2/3
		triggerClientEvent(client,"startRenderTreasureMapFromInventory",client,3)
	elseif(item == 105)then
		local BottleOxygen = tonumber(getPlayerData("character_stats","character_id",getCharacterID(client),"bottle_oxygen"))
		if(BottleOxygen < 900)then
			Characters.addStats(client,"bottle_oxygen",BottleOxygen + 100)
		else
			NPC.MeMessage(client,getText(client,"SDiving1"))
		end
	elseif(item == 106)then
		local BottleOxygen = tonumber(getPlayerData("character_stats","character_id",getCharacterID(client),"bottle_oxygen"))
		apocalypseSetElementData(client,"BottleOxygen",BottleOxygen)
		triggerClientEvent(client,"useDivingSuit",client)
	elseif(item == 123)then
		triggerClientEvent(client,"closeInventory",client)
		triggerClientEvent(client,"Objectsystem.createObject",client,944)
	elseif(item == 116)then
		triggerClientEvent(client,"closeInventory",client)
		triggerClientEvent(client,"Objectsystem.createObject",client,3927)
	elseif(item == 120)then
		triggerClientEvent(client,"closeInventory",client)
		triggerClientEvent(client,"Objectsystem.createObject",client,2332)
	elseif(item == 127)then
		triggerClientEvent(client,"closeInventory",client)
		triggerClientEvent(client,"Objectsystem.createObject",client,1808)
	elseif(item == 124 or item == 125 or item == 126)then
		if(item == 124)then hotdogid = 2 end
		if(item == 125)then hotdogid = 3 end
		if(item == 126)then hotdogid = 4 end
		HotDog.addNoFoodTimer(client,HotDog["Time"][hotdogid])
		takeItem(client,item,1)
	elseif(item == 131)then
		triggerClientEvent(client,"closeInventory",client)
		triggerClientEvent(client,"Objectsystem.createObject",client,1271)
	elseif(item == 143)then
		local weapon = getPedWeapon(client)
		if(weapon == 35 or weapon == 36)then
			PlayerWeapons.addNewWeapon(client, weapon, 1)
			takeItem(client,143,1)
		end
	elseif(item == 145)then
		MetalDetector.Activate(client)
	elseif(item == 146 or item == 147)then
		addPlayerExtraArmor(client,item)
	elseif(item == 177 or item == 178 or item == 179)then
		if(item == 177)then shakeid = 2 end
		if(item == 178)then shakeid = 3 end
		if(item == 179)then shakeid = 4 end
		Shakes.addNoThirstTimer(client,Shakes["Time"][shakeid])
	elseif(item == 133 or item == 134 or item == 135 or item == 136 or item == 137 or item == 138 or item == 139 or item == 140 or item == 141 or item == 142 or item == 117)then
		Campfire.cookItem(client,item)
	elseif(item == 185)then
		local medicSkill = getSkillLevel(client,1)
		local healing = 25
		if(medicSkill >= 1)then healing = 30 end
		if(medicSkill >= 2)then healing = 35 end
		if(medicSkill >= 3)then healing = 40 end
		if(medicSkill >= 4)then healing = 50 end
	
		setPedAnimation(client, "BOMBER", "BOM_Plant")
		takeItem(client,185,1)
		smokeTimer[client] = setTimer(function(client)
			setElementHealth(client,getElementHealth(client)+healing)
			setPedAnimation(client)
			if(getElementHealth(client) > 100)then
				setElementHealth(client,100)
			end
		end,2650,1,client)
	elseif(item == 187)then
		activateDoubleSkillpoints(client)
		takeItem(client,item,1)
	elseif(item == 205)then
		takeItem(client,205,1)
		openTradingCardPack(client)
		triggerClientEvent(client,"closeInventory",client)
	elseif(item == 206)then
		loadPlayerNotepad(client)
		triggerClientEvent(client,"closeInventory",client)
	elseif(item == 241)then
		triggerClientEvent(client,"closeInventory",client)
		triggerClientEvent(client,"Skillsystem.openManager",client)
	end
end)

function checkDivingOxygen()
	local BottleOxygen = tonumber(getPlayerData("character_stats","character_id",getCharacterID(client),"bottle_oxygen"))
	if(BottleOxygen < 1)then
		apocalypseSetElementData(client,"BottleOxygen",0)
		Characters.addStats(client,"bottle_oxygen",0)
	else
		apocalypseSetElementData(client,"BottleOxygen",BottleOxygen - 1)
		Characters.addStats(client,"bottle_oxygen",BottleOxygen - 1)
	end
end
addEvent("checkDivingOxygen",true)
addEventHandler("checkDivingOxygen",root,checkDivingOxygen)

local possibleToolboxItems = {78,79,80,81}

function giveToolboxItems(player,amount)
    giveEXP(player, 5 * amount)

    local tbl = {}

    for i = 1, amount do
        local item = possibleToolboxItems[math.random(1,#possibleToolboxItems)]

        giveItem(player, item, 1)
        table.insert(tbl, {item, 1})
    end
	triggerClientEvent(player, "showItemBar", player, tbl)
end

addEventHandler("onPlayerQuit",root,function()
	if(isCharacterLoggedIn(source))then
		savePlayerItems(source)
		PlayerItems[source] = nil
		smokeTimer[source] = nil
		drinkTimer[source] = nil
		chestsSpam[source] = nil
	end
end)