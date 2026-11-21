local Achievements = { -- Needed Kills, Achievement ID
	{1, 58},
	{5, 59},
	{10, 60},
	{25, 61},
	{50, 62},
	{75, 63},
	{125, 64},
	{175, 65},
	{225, 66},
	{275, 67},
	{325, 68},
	{400, 69},
	{500, 70},
}

local ped_ids = {14,21,32,33,38,39,93,102,103,104,121,122,123,132,133,167,194,205,211,233,249,258,259,260}

local function hasPlayerUsedSyringe(player,ID)
	if(player and ID and isCharacterLoggedIn(player))then
		local pedPlayer = apocalypseGetElementData(InfectedSurvivors.Peds[ID], "Player")
		local values = split(pedPlayer, "|")
		
		for _, v in ipairs(values) do
			if(v == getCharacterID(player))then
				return true
			end
		end
	end
    return false
end

function InfectedSurvivors.createPed(ID)
	if(ID)then
		if(isElement(InfectedSurvivors.Peds[ID]))then destroyElement(InfectedSurvivors.Peds[ID]) end
		if(isElement(InfectedSurvivors.PedPickup[ID]))then destroyElement(InfectedSurvivors.PedPickup[ID]) end
		
		if(not(isElement(InfectedSurvivors.Peds[ID])))then
			local tbl = InfectedSurvivors["Coordinates"][ID]
			if(tbl[7])then model = tbl[7] else model = ped_ids[math.random(1,#zombies["Skins"])] end
			
			InfectedSurvivors.Peds[ID] = createPed(model,tbl[1],tbl[2],tbl[3],tbl[4])
			if(tbl[5])then
				setElementInterior(InfectedSurvivors.Peds[ID],tbl[5])
			end
			if(tbl[6])then
				setElementDimension(InfectedSurvivors.Peds[ID],tbl[6])
			end
			apocalypseSetElementData(InfectedSurvivors.Peds[ID],"InfectedSurvivorID",ID)
			apocalypseSetElementData(InfectedSurvivors.Peds[ID],"Player","")
			
			setTimer(function(ped)
				setPedAnimation(ped,"sunbathe", "parksit_m_idlea",-1,true,false,false,true)
			end,500,1,InfectedSurvivors.Peds[ID])
		end
		InfectedSurvivors.updateClientDataForAll()
	else
		for i,v in ipairs(InfectedSurvivors["Coordinates"])do
			if(not(isElement(InfectedSurvivors.Peds[i])))then
				if(v[7])then model = v[7] else model = zombies["Skins"][math.random(1,#zombies["Skins"])] end
				InfectedSurvivors.Peds[i] = createPed(model,v[1],v[2],v[3],v[4])
				if(v[5])then
					setElementInterior(InfectedSurvivors.Peds[i], v[5])
				end
				if(v[6])then
					setElementDimension(InfectedSurvivors.Peds[i], v[6])
				end
				apocalypseSetElementData(InfectedSurvivors.Peds[i],"InfectedSurvivorID",i)
				apocalypseSetElementData(InfectedSurvivors.Peds[i],"Player","")
				
				setTimer(function(ped)
					setPedAnimation(ped,"sunbathe", "parksit_m_idlea",-1,true,false,false,true)
				end,500,1,InfectedSurvivors.Peds[i])
			end
		end
	end
end
InfectedSurvivors.createPed()

function InfectedSurvivors.createLoot(ID)
	if(not(isElement(InfectedSurvivors.PedPickup[ID])))then
		local x,y,z = getElementPosition(InfectedSurvivors.Peds[ID])
		local int,dim = getElementInterior(InfectedSurvivors.Peds[ID]), getElementDimension(InfectedSurvivors.Peds[ID])
		InfectedSurvivors.PedPickup[ID] = createPickup(x,y,z,3,1212,50)
		setElementInterior(InfectedSurvivors.PedPickup[ID],int)
		setElementDimension(InfectedSurvivors.PedPickup[ID],dim)

		addEventHandler("onPickupHit",InfectedSurvivors.PedPickup[ID],function(player)
			if(getElementType(player) == "player" and not(isPedInVehicle(player)))then
				if(getElementDimension(player) == getElementDimension(source))then
					local money = math.random(1,5)
					if(SERVERBONUS.INFECTED_SURVIVORS == true)then money = money * 2 end
					apocalypseSetElementData(player,"money",apocalypseGetElementData(player,"money") + money)
					destroyElement(source)
					outputLog(getPlayerName(player).." hat $"..money.." eingesammelt","Infected Survivors",getCharacterID(player))
				end
			end
		end)
	end
end

addEvent("InfectedSurvivors.UseSyringe",true)
addEventHandler("InfectedSurvivors.UseSyringe",root,function(ID)
	local ID = tonumber(ID)
	if(not(isTimer(InfectedSurvivors.Timer[client])))then
		if(hasPlayerUsedSyringe(client,ID) == false)then
			if(hasPlayerItem(client,31) >= 1)then
				takeItem(client,31,1)
				giveItem(client,30,1)
				setPlayerAnimationStatus(client)
				setAchievement(client,410)
				setPedAnimation(client, "BOMBER", "BOM_Plant")
				triggerClientEvent(client, "showItemBar", client, {{30,1}})
				
				local pedPlayer = apocalypseGetElementData(InfectedSurvivors.Peds[ID],"Player")
				local pedPlayer = pedPlayer..getCharacterID(client).."|"
				apocalypseSetElementData(InfectedSurvivors.Peds[ID],"Player",pedPlayer)
				
				InfectedSurvivors.Timer[client] = setTimer(function(player)
					resetPlayerAnimationStatus(player)
					NPC.MeMessage(player,getText(player,"MeMessage27"))
					local skillpoints_amount = 1
					if(SERVERBONUS.INFECTED_SURVIVORS == true)then skillpoints_amount = skillpoints_amount * 2 end
					givePlayerSkillpoint(player,skillpoints_amount)
					local amount = 10
					if(SERVERBONUS.INFECTED_SURVIVORS == true)then amount = amount * 2 end
					giveEXP(player,amount)
					outputLog(getPlayerName(player).." hat eine Spritze benutzt und "..amount.." EXP und "..skillpoints_amount.." Skillpunkte erhalten","Infected Survivors",getCharacterID(player))
				end,2650,1,client)
			else
				NPC.MeMessage(client,getText(client,"MeMessage28"))
			end
		else
			NPC.MeMessage(client,getText(client,"MeMessage29"))
		end
	end
end)

function InfectedSurvivors.checkAchievements(player)
	local killed_infected_survivors = getPlayerData("character_stats","character_id",getCharacterID(player),"killed_infected_survivors") or 0
	
	for _,v in pairs(Achievements)do
		if(tonumber(killed_infected_survivors) >= v[1])then
			setAchievement(player,v[2])
		end
	end
end

addEventHandler("onPedWasted", root, function(ammo, attacker, weapon, bodypart)
	if(apocalypseGetElementData(source, "InfectedSurvivorID"))then
		if(attacker)then
			local ID = tonumber(apocalypseGetElementData(source,"InfectedSurvivorID"))

			InfectedSurvivors.createLoot(ID)
			local killed_infected_survivors = tonumber(getPlayerData("character_stats","character_id",getCharacterID(attacker),"killed_infected_survivors"))
			Characters.addStats(attacker,"killed_infected_survivors",killed_infected_survivors+1)
			InfectedSurvivors.checkAchievements(attacker)

			local xp = 25
			local skillpoint = 1
			if(SERVERBONUS.INFECTED_SURVIVORS == true)then
				xp = xp * 2
				skillpoint = skillpoint * 2
			end
			giveEXP(attacker,xp)
			givePlayerSkillpoint(attacker,skillpoint)
			setTimer(function(ID)
				if not isElement(InfectedSurvivors.Peds[ID]) then
					InfectedSurvivors.createPed(ID)
				end
			end, 300000, 1, ID)
			setTimer(function(ID)
				if isElement(InfectedSurvivors.Peds[ID]) and isPedDead(InfectedSurvivors.Peds[ID]) then
					destroyElement(InfectedSurvivors.Peds[ID])
					InfectedSurvivors.Peds[ID] = nil
				end
			end, 10000, 1, ID)
			
			outputLog(getPlayerName(attacker).." hat einen infizierte Überlebenden getötet und "..xp.." EXP erhalten","Infected Survivors",getCharacterID(attacker))
			InfectedSurvivors.updateClientDataForAll()
		end
	end
end)

function InfectedSurvivors.updateClientDataForAll()
	for _,v in pairs(getElementsByType("player"))do
		if(isCharacterLoggedIn(v))then
			triggerClientEvent(v,"updateInfectedSurvivorsData",v,InfectedSurvivors.Peds)
		end
	end
end

function InfectedSurvivors.updateClientData(player)
	if(isCharacterLoggedIn(player))then
		triggerClientEvent(player,"updateInfectedSurvivorsData",player,InfectedSurvivors.Peds)
	end
end