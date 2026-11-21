Sharks = {Objects = {}, Marker = {},
	["Positions"] = {
		{467.28100585938,-3495.0126953125,0},
		{132.822265625,-1939.583984375,0},
		{161.23350524902,-2207.2939453125,0},
		{477.0546875,-2309.0107421875,0},
		{54.478500366211,-1563.5487060547,0},
		{1047.705078125,-2408.0068359375,0},
		{1133.1171875,-2543.9108886719,0},
		{-20.812099456787,-2898.0900878906,0},
		{603.1103515625,-2564.6962890625,0},
		{813.18359375,-2045.8408203125,0},
		{832.6767578125,-2778.7041015625,0},
		{894.91259765625,-2514.1413574219,0},
		{402.36630249023,-1956.7835693359,0},
		{722.830078125,-1599.9140625,0},
		{409.48431396484,-2103.740234375,0},
	},
}

function Sharks.load()
	for i,v in pairs(Sharks["Positions"])do
		Sharks.Objects[i] = createObject(1608,v[1],v[2],v[3],0,0,math.random(0,360))
		apocalypseSetElementData(Sharks.Objects[i],"SharkID",i)
		setObjectScale(Sharks.Objects[i],0.6)
		
		Sharks.Marker[i] = createMarker(v[1],v[2],v[3],"cylinder",3,255,255,255,0)
		apocalypseSetElementData(Sharks.Marker[i],"SharkID",i)
		
		addEventHandler("onMarkerHit",Sharks.Marker[i],function(player)
			if(getElementType(player) == "player")then
				if(not(isPedInVehicle(player)))then
					if(getElementDimension(player) == getElementDimension(source))then
						if(not(apocalypseGetElementData(player,"SharkBind")))then
							bindKey(player,"e","down",Sharks.giveShells)
							apocalypseSetElementData(player,"SharkBind",true)
						end
						if(Sharks.hasPlayerShark(player,apocalypseGetElementData(source,"SharkID")) == false)then
							triggerClientEvent(player,"createActivitiesInformationText",player,getText(player,"SSharks1"))
						end
					end
				end
			end
		end)
		
		addEventHandler("onMarkerLeave",Sharks.Marker[i],function(player)
			unbindKey(player,"e","down",Sharks.giveShells)
			apocalypseSetElementData(player,"SharkBind",false)
		end)
	end
end
Sharks.load()

function Sharks.giveShells(player)
	local SharkID = nil
	for _,v in pairs(Sharks.Marker)do
		if(isElementWithinMarker(player,v))then
			SharkID = apocalypseGetElementData(v,"SharkID")
			break
		end
	end
	if(SharkID ~= nil)then
		local Shark = Sharks.Objects[SharkID]
		if(Sharks.hasPlayerShark(player,SharkID) == false)then
			if(hasPlayerItem(player,67) >= 10)then
				takeItem(player,67,10)
				Sharks.givePlayerShark(player,SharkID)
				NPC.MeMessage(player,getText(player,"SSharks3"))
				giveItem(player,144,1)
				triggerClientEvent(player, "showItemBar", player, {{144,1}})
				setAchievement(player,284)
				giveEXP(player,2500)
				givePlayerSkillpoints(player,5)
			else
				NPC.MeMessage(player,getText(player,"SSharks2"))
			end
		end
	end
end

function Sharks.givePlayerShark(player,SharkID)
	local ID = tonumber(SharkID)
	if(Sharks.hasPlayerShark(player,ID) == false)then
		local playerSharks = getPlayerData("characters","ID",getCharacterID(player),"sharks")
		dbExec(handler,"UPDATE characters SET sharks = '"..playerSharks..ID.."|' WHERE ID = '"..getCharacterID(player).."'")
		Sharks.loadPlayerData(player)
		outputLog(getPlayerName(player).." hat einen Hai gefüttert (ID: "..ID..")", "Shark", getCharacterID(player))
	end
end

function Sharks.hasPlayerShark(player,SharkID)
	local ID = tonumber(SharkID)
	local playerSharks = getPlayerData("characters","ID",getCharacterID(player),"sharks")
	if(not(playerSharks))then
		dbExec(handler,"UPDATE characters SET sharks = '' WHERE ID = '"..getCharacterID(player).."'")
		playerSharks = getPlayerData("characters","ID",getCharacterID(player),"sharks")
	end
	
	local values = split(playerSharks,"|")
	local hasShark = false
	
	if(playerSharks and ID)then
		for _,v in pairs(values)do
			local sharkID = tonumber(v)
			if(sharkID == ID)then
				hasShark = true
				break
			end
		end
	end
	return hasShark
end

function Sharks.loadPlayerData(player)
	local Data = {}
	for i = 1,#Sharks["Positions"] do
		local Table = Sharks["Positions"][i]
		if(Sharks.hasPlayerShark(player,i) == true)then
			table.insert(Data,{Table[1],Table[2],Table[3],getText(player,"SSharks5")})
		else
			table.insert(Data,{Table[1],Table[2],Table[3],getText(player,"SSharks4")})
		end
		triggerClientEvent(player,"Sharks.clientRender",player,Data)
	end
end