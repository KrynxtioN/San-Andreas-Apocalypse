shootingRange = {
	["Spawnpositions"] = {
		{-7186.6000976562, -2463.6000976562, 31.5,false},
		{-7186.6000976562, -2465.1000976562, 31.39999961853,false},
		{-7186.6000976562, -2462, 31.5,false},
		{-7186.6000976562, -2460.3000488281, 31.5,false},
		{-7186.6000976562, -2458.6999511719, 31.5,false},
		{-7186.6000976562, -2457.1000976562, 31.5,false},
		{-7186.6000976562, -2455.5, 31.5,false},
		{-7186.6000976562, -2466.6999511719, 31.5,false},
		{-7186.6000976562, -2468.3999023438, 31.5,false},
		{-7186.6000976562, -2470, 31.5,false},
		{-7186.6000976562, -2471.6000976562, 31.5,false},
		{-7186.6000976562, -2473.1999511719, 31.5,false},
		{-7186.6000976562, -2474.8000488281, 31.5,false},
	},
}

function shootingRange.start(player,weapon)
	local id = 0
	for i,v in ipairs(shootingRange["Spawnpositions"])do
		if(v[4] == false)then
			v[4] = true
			id = i
			break
		end
	end
	if(id > 0)then
		local tbl = shootingRange["Spawnpositions"][id]
		setElementPosition(player,tbl[1],tbl[2],tbl[3])
		setPedRotation(player,270)
		setElementInterior(player,0)
		setElementDimension(player,0)
		setElementFrozen(player,true)
		takeAllWeapons(player)
		apocalypseSetElementData(player,"isInShootingRange",true)
		apocalypseSetElementData(player,"shootingrange_hits",0)
		giveWeapon(player,weapon,250,true)
		triggerClientEvent(player,"shootingRange.showShootingsStats",player,"create")
		apocalypseSetElementData(player,"ShootingrangeID",id)
		NPC.NormalMessage(player,getText(player,"SWeaponskills4"))
	end
end
addEvent("shootingRange.start",true)
addEventHandler("shootingRange.start",root,shootingRange.start)

function shootingRange.calcTargetsSpeed(element, tY)
	local x, y, z = getElementPosition ( element )
	local distance = getDistanceBetweenPoints2D ( x, tY, x, y )
	
	local speed = distance*200
	
	return speed, x, z
end

function shootingRange.onTargetHit(object)
	if not isElement(object) then return false end
	if apocalypseGetElementData(object, "hitAble") == false then return false end
	apocalypseSetElementData(object, "hitAble", true)
	
	local times = getRealTime()
	local shootingrange_hits = apocalypseGetElementData(client, "shootingrange_hits")
	if shootingrange_hits == nil then shootingrange_hits = 0 end
	if shootingrange_hits == false then shootingrange_hits = 0 end
	shootingrange_hits = shootingrange_hits + 1
	
	if(shootingrange_hits == 30)then
		local time = times.timestamp-apocalypseGetElementData(client, "sTime")
		local totalammo2 = getPedTotalAmmo(client)	
		local acc = math.floor(30*100/(250-totalammo2))
		if(acc >= 75)then
			local weapon = getPedWeapon(client)
			if(tonumber(weapon) == 24)then
				local skills = tonumber(getPlayerData("character_stats","character_id",getCharacterID(client),"deagleskills"))
				if(skills == 0)then
					NPC.NormalMessage(client,getText(client,"SWeaponskills1"))
					dbExec(handler,"UPDATE character_stats SET deagleskills = '1' WHERE character_id = '"..getCharacterID(client).."'")
					setAchievement(client,413)
					outputLog("[WAFFENSKILLS] "..getPlayerName(client).. " ("..getCharacterID(client)..") hat folgenden Waffenskills freigeschaltet: deagleskills","Weaponskills", getCharacterID(client))
				else
					NPC.NormalMessage(client,getText(client,"SWeaponskills2"))
				end
			elseif(tonumber(weapon) == 25)then
				local skills = tonumber(getPlayerData("character_stats","character_id",getCharacterID(client),"shotgunskills"))
				if(skills == 0)then
					NPC.NormalMessage(client,getText(client,"SWeaponskills1"))
					dbExec(handler,"UPDATE character_stats SET shotgunskills = '1' WHERE character_id = '"..getCharacterID(client).."'")
					setAchievement(client,414)
					outputLog("[WAFFENSKILLS] "..getPlayerName(client).. " ("..getCharacterID(client)..") hat folgenden Waffenskills freigeschaltet: shotgunskills","Weaponskills", getCharacterID(client))
				else
					NPC.NormalMessage(client,getText(client,"SWeaponskills2"))
				end
			elseif(tonumber(weapon) == 31)then
				local skills = tonumber(getPlayerData("character_stats","character_id",getCharacterID(client),"m4skills"))
				if(skills == 0)then
					NPC.NormalMessage(client,getText(client,"SWeaponskills1"))
					dbExec(handler,"UPDATE character_stats SET m4skills = '1' WHERE character_id = '"..getCharacterID(client).."'")
					setAchievement(client,415)
					outputLog("[WAFFENSKILLS] "..getPlayerName(client).. " ("..getCharacterID(client)..") hat folgenden Waffenskills freigeschaltet: m4skills","Weaponskills", getCharacterID(client))
				else
					NPC.NormalMessage(client,getText(client,"SWeaponskills2"))
				end
			elseif(tonumber(weapon) == 29)then
				local skills = tonumber(getPlayerData("character_stats","character_id",getCharacterID(client),"mp5skills"))
				if(skills == 0)then
					NPC.NormalMessage(client,getText(client,"SWeaponskills1"))
					dbExec(handler,"UPDATE character_stats SET mp5skills = '1' WHERE character_id = '"..getCharacterID(client).."'")
					setAchievement(client,416)
					outputLog("[WAFFENSKILLS] "..getPlayerName(client).. " ("..getCharacterID(client)..") hat folgenden Waffenskills freigeschaltet: mp5skills","Weaponskills", getCharacterID(client))
				else
					NPC.NormalMessage(client,getText(client,"SWeaponskills2"))
				end
			end
			setPlayerWeaponSkills(client)
			setAchievement(client,268)
		else
			NPC.NormalMessage(client,getText(client,"SWeaponskills3"))
		end
		apocalypseSetElementData(client,"isInShootingRange",false)
		shootingRange["Spawnpositions"][apocalypseGetElementData(client,"ShootingrangeID")][4] = false
		apocalypseSetElementData(client,"ShootingrangeID",nil)
		triggerClientEvent(client,"shootingRange.showShootingsStats",client,"destroy")
		takeAllWeapons(client)
		setElementPosition(client,-7195.0048828125,-2456.1630859375,32.355361938477)
		setPedRotation(client,180)
		setElementFrozen(client,false)
	elseif(shootingrange_hits == 1)then
		apocalypseSetElementData(client, "sTime", times.timestamp)
		apocalypseSetElementData(client, "shootingrange_hits", shootingrange_hits)
	else
		apocalypseSetElementData(client, "shootingrange_hits", shootingrange_hits)
	end
	
	local x, y, z = getElementPosition ( object )
	stopObject(object)
	moveObject(object, 200, x, y, z, 90)
	setTimer(shootingRange.reactivateTarget, 2000, 1, object)
	killTimer(apocalypseGetElementData(object, "timer"))
	apocalypseSetElementData(object, "hitAble", false)
end
addEvent("shootingRange.onTargetHit", true)
addEventHandler("shootingRange.onTargetHit", getRootElement(), shootingRange.onTargetHit)

function shootingRange.reactivateTarget(object)
	if not isElement(object) then return false end
	local x, y, z = getElementPosition ( object )
	stopObject(object)
	moveObject(object, 200, x, y, z, -90)
	setTimer(shootingRange.moveTargetOtherSide, 201, 1, object, math.random(0,1))
	setTimer(apocalypseSetElementData, 202, 1, object, "hitAble", true)
end

function shootingRange.moveTargetOtherSide(object, side)
	if not isElement(object) then return false end
	if(side == 1)then
		local moveTime, x, z = shootingRange.calcTargetsSpeed(object, -2457)
		stopObject(object)
		moveObject(object, moveTime, x,  -2457, z)
		moveTime = moveTime - math.random(1,1000)
		if moveTime < 50 then moveTime = 50 end
		local timer = setTimer(shootingRange.moveTargetOtherSide, moveTime, 1, object, 0)
		apocalypseSetElementData(object, "timer", timer)
	else
		local moveTime, x, z = shootingRange.calcTargetsSpeed(object, -2478)
		stopObject(object)
		moveObject(object, moveTime, x,  -2478, z)
		
		moveTime = moveTime - math.random(1,1000)
		if moveTime<50 then moveTime = 50 end
		local timer = setTimer(shootingRange.moveTargetOtherSide, moveTime, 1, object, 1)
		apocalypseSetElementData(object, "timer", timer)
	end
end

local target = {}

local function addTargets()
	if(isElement(target[0]))then killTargets() end
		
	target[0] = createObject(1585, -7163.3999023438, -2466.1000976562, 31.39999961853, 0, 0, 90)
	target[1] = createObject(1585, -7180.7001953125, -2462.1999511719, 31.39999961853, 0, 0, 90)
	target[2] = createObject(1585, -7169.8999023438, -2465.1000976562, 31.39999961853, 0, 0, 90)
	target[3] = createObject(1585, -7176.8999023438, -2465.1000976562, 31.39999961853, 0, 0, 90)
	target[4] = createObject(1585, -7165.7001953125, -2462.1999511719, 31.39999961853, 0, 0, 90)
	target[5] = createObject(1585, -7170.3999023438, -2466.1000976562, 31.39999961853, 0, 0, 90)
		
	for i = 0, 5, 1 do 
		shootingRange.moveTargetOtherSide(target[i], math.random(0,1))
		apocalypseSetElementData(target[i], "target", true)
		apocalypseSetElementData(target[i], "hitAble", true)
	end
end
addTargets()

function killTargets()
	for i = 0, 5, 1 do 
		local timer = apocalypseGetElementData(target[i], "timer")
		if(isTimer(timer))then killTimer(timer) end
		
		apocalypseSetElementData(target[i], "target", nil)
		apocalypseSetElementData(target[i], "hitAble", nil)
		destroyElement(target[i])
	end
end

function shootingRange.resetPosition(player)
	local ShootingrangeID = apocalypseGetElementData(player,"ShootingrangeID")
	if(ShootingrangeID and ShootingrangeID ~= nil)then
		shootingRange["Spawnpositions"][ShootingrangeID][4] = false
		apocalypseSetElementData(player,"ShootingrangeID",nil)
	end
end

addEventHandler("onPlayerQuit",root,function()
	shootingRange.resetPosition(source)
end)

addEventHandler("onPlayerWasted",root,function()
	shootingRange.resetPosition(source)
end)