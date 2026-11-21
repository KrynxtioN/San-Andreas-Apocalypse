Tutorial = {}

addEvent("tutorialStatus",true)
addEventHandler("tutorialStatus",root,function()
	setStatus(client,1)
end)

local keypad = createObject(2886, 696.06640625, -478.552734375, 16.832000732422, 0, 0, 180)

addEventHandler("onPlayerClick", root, function(button, state, clickedElement)
	if(button == "left" and state == "down" and clickedElement)then
		if(clickedElement == keypad)then
			if(apocalypseGetElementData(source, "tutorialtask") >= 7)then
				triggerClientEvent(source, "Tutorial.createKeypad", source)
			end
		end
	end
end)

function Tutorial.start(player)
	if(apocalypseGetElementData(player, "tutorialtask") < 8)then
		triggerClientEvent(player, "Tutorial.load", player)
	end
	removeElementData(player, "keypadCodeTutorial")
	if(apocalypseGetElementData(player,"tutorialtask") == 3)then
		Tutorial.HatPickup = createPickup(-220.59350585938, 1401.5965576172, 27.597199249268,3,1318,50)
		setElementInterior(Tutorial.HatPickup, 18)
	end
end

function Tutorial.nextTask(player)
	apocalypseSetElementData(player, "tutorialtask", apocalypseGetElementData(player, "tutorialtask")+1)
	triggerClientEvent(player, "updateTask", player)
	giveEXP(player, 25 * apocalypseGetElementData(player, "tutorialtask"))
	givePlayerServerMoney(player, 10 * apocalypseGetElementData(player, "tutorialtask"))
	
	if(apocalypseGetElementData(player,"tutorialtask") == 3)then
		Tutorial.HatPickup = createPickup(-220.59350585938, 1401.5965576172, 27.597199249268,3,1318,50)
		setElementInterior(Tutorial.HatPickup, 18)
	end
	
	if(apocalypseGetElementData(player, "tutorialtask") >= 8)then
		triggerClientEvent(player, "Tutorial.destroy", player)
		triggerClientEvent(player, "Tutorial.openGate", player)
		
		Documents.createHelpMarker(player)
		Helpmenu.createHelpMarker(player)
		addPlayerSpawn(player,1)
	end
	triggerClientEvent(player, "Tutorial.updateHelpMarker", player)
end
addEvent("Tutorial.nextTask", true)
addEventHandler("Tutorial.nextTask", root, Tutorial.nextTask)

function Tutorial.checkTask1()
	local NPCData = getPlayerData("characters", "ID", getCharacterID(client), "npcData")
	if(not(NPCData))then
		dbExec(handler, "UPDATE characters SET npcData = '' WHERE ID = '"..getCharacterID(client).."'")
		NPCData = getPlayerData("characters", "ID", getCharacterID(client), "npcData")
	end
		
	local values = split(tostring(NPCData), "|")
	local JackMiller = false
	local LeeroyMiller = false
	local BillyMiller = false
		
	for _, v in pairs(values)do
		if(tonumber(v) == 1)then
			BillyMiller = true
		end
		if(tonumber(v) == 2)then
			JackMiller = true
		end
		if(tonumber(v) == 3)then
			LeeroyMiller = true
		end
	end
	
	if(BillyMiller == true and JackMiller == true and LeeroyMiller == true)then
		if(apocalypseGetElementData(client, "tutorialtask") == 1)then
			Tutorial.nextTask(client)
		end
	end
end

local hatMarker = createMarker(-220.59350585938, 1401.5965576172, 27.197199249268, "cylinder", 2, 0, 0, 255, 0)
setElementInterior(hatMarker, 18)

local function giveHat(player)
	if(getDistanceBetweenPoints3D(-220.59350585938, 1401.5965576172, 27.197199249268,getElementPosition(player)) <= 3.5)then
		if(tonumber(getPlayerData("characters", "ID", getCharacterID(player), "grandfathershat")) == 0)then
			unbindKey(player, "e", "down", giveHat)
			createInfobox(player, getText(player, "SGrandfathersClothes1"))
			setPedClothes(player, 16, math.random(0, 56))
			setAchievement(player, 5)
			Tutorial.nextTask(player)
			destroyElement(hatMarker)
			destroyElement(Tutorial.HatPickup)
				
			savePlayerClothes(player)
			dbExec(handler, "UPDATE characters SET grandfathershat = '1' WHERE ID = '"..getCharacterID(player).."'")
		end
	end
end

addEventHandler("onMarkerHit", hatMarker, function(player)
	if(isCharacterLoggedIn(player))then
		if(getElementInterior(player) == getElementInterior(source))then
			if(getElementDimension(player) == getElementDimension(source))then
				if(tonumber(getPlayerData("characters", "ID", getCharacterID(player), "grandfathershat")) == 0)then
					if(tonumber(apocalypseGetElementData(player, "tutorialtask")) >= 3)then
						createInfobox(player, getText(player, "SGrandfathersClothes2"))
						bindKey(player, "e", "down", giveHat)
					end
				end
			end
		end
	end
end)

addCommandHandler("skiptutorial",function(player)
	if(tonumber(apocalypseGetElementData(player, "tutorialtask")) == 3)then
		Tutorial.nextTask(player)
	end
end)