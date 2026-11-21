PrisonQuest = {GateObject = {}, GateMarker = {}, plantTimer = {}, BombObject = {}, ExplodeTimer = {}, Destroyed = 0,
	["Gates"] = {
		{2930,266.32189941406,88.767097473145,1002.6759033203,0,0,0,6,0},
		{2930,266.32751464844,84.117301940918,1002.6759033203,0,0,0,6,0},
	},
}

local InformationMarker = createMarker(261.03924560547,90.888252258301,1001.7841186523,"cylinder",3,0,0,0,0)
setElementInterior(InformationMarker,6)

addEventHandler("onMarkerHit",InformationMarker,function(player)
	if(getElementType(player) == "player")then
		if(getElementDimension(player) == getElementDimension(source))then
			if(getElementInterior(player) == getElementInterior(source))then
				NPC.MeMessage(player,getText(player,"SPrisonQuest4"))
			end
		end
	end
end)

function PrisonQuest.createGates()
	PrisonQuest.Destroyed = 0
	if(#PrisonQuest.GateObject >= 1)then for _,v in pairs(PrisonQuest.GateObject)do destroyElement(v) end end
	if(#PrisonQuest.GateMarker >= 1)then for _,v in pairs(PrisonQuest.GateMarker)do destroyElement(v) end end
	if(#PrisonQuest.BombObject >= 1)then for _,v in pairs(PrisonQuest.BombObject)do destroyElement(v) end end
	PrisonQuest.GateObject = {}
	PrisonQuest.GateMarker = {}
	PrisonQuest.BombObject = {}
	
	for i,v in ipairs(PrisonQuest["Gates"])do
		PrisonQuest.GateObject[i] = createObject(v[1],v[2],v[3],v[4],v[5],v[6],v[7])
		setElementInterior(PrisonQuest.GateObject[i],v[8])
		setElementDimension(PrisonQuest.GateObject[i],v[9])
		
		PrisonQuest.GateMarker[i] = createMarker(v[2]+0.25,v[3]-1,v[4]-2.5,"cylinder",1.5,255,0,0,50)
		setElementInterior(PrisonQuest.GateMarker[i],v[8])
		setElementDimension(PrisonQuest.GateMarker[i],v[9])
		apocalypseSetElementData(PrisonQuest.GateMarker[i],"PrisonGateID",i)
		apocalypseSetElementData(PrisonQuest.GateMarker[i],"BombPlanted",false)
		
		addEventHandler("onMarkerHit",PrisonQuest.GateMarker[i],function(player)
			if(getElementType(player) == "player")then
				if(getElementDimension(player) == getElementDimension(source))then
					triggerClientEvent(player,"createActivitiesInformationText",player,getText(player,"SNests1"))
					if(apocalypseGetElementData(player,"PrisonQuestBind") ~= true)then
						bindKey(player,"e","down",PrisonQuest.plantBomb)
						apocalypseSetElementData(player,"PrisonQuestBind",true)
					end
					apocalypseSetElementData(player,"PrisonGateID",apocalypseGetElementData(source,"PrisonGateID"))
				end
			end
		end)
	end
end
PrisonQuest.createGates()

function PrisonQuest.plantBomb(player)
	if(not(isTimer(PrisonQuest.plantTimer[player])))then
		local PrisonGateID = apocalypseGetElementData(player,"PrisonGateID")
		if(not(isTimer(PrisonQuest.ExplodeTimer[PrisonGateID])))then
			if(isElement(PrisonQuest.GateMarker[PrisonGateID]) and isElementWithinMarker(player,PrisonQuest.GateMarker[PrisonGateID]))then
				if(apocalypseGetElementData(PrisonQuest.GateMarker[PrisonGateID],"BombPlanted") == false)then
					if(hasPlayerItem(player,26) >= 1)then
						local x,y,z = getElementPosition(player)
						takeItem(player,26,1)
						setElementFrozen(player,true)
						setPedAnimation(player,"BOMBER", "BOM_Plant_Loop",-1,true,false,false,true)
						PrisonQuest.BombObject[PrisonGateID] = createObject(1654,x-0.5,y,z-0.85,-90,0,0)
						setElementInterior(PrisonQuest.BombObject[PrisonGateID],getElementInterior(player))
						setElementDimension(PrisonQuest.BombObject[PrisonGateID],getElementDimension(player))
						apocalypseSetElementData(PrisonQuest.GateMarker[PrisonGateID],"BombPlanted",true)
						unbindKey(player,"e","down",PrisonQuest.plantBomb)
						apocalypseSetElementData(player,"PrisonQuestBind",false)
						
						PrisonQuest.plantTimer[player] = setTimer(function(player,id)
							if(isElement(player))then
								setPedAnimation(player)
								setElementFrozen(player,false)
								NPC.MeMessage(player,getText(player,"SPrisonQuest1"))
							end
							
							PrisonQuest.ExplodeTimer[id] = setTimer(function(id)
								PrisonQuest.Destroyed = PrisonQuest.Destroyed + 1
								local x,y,z = getElementPosition(PrisonQuest.BombObject[id])
								destroyElement(PrisonQuest.GateMarker[id])
								destroyElement(PrisonQuest.BombObject[id])
								destroyElement(PrisonQuest.GateObject[id])
								createExplosion(x,y,z,9)
								
								if(PrisonQuest.Destroyed >= #PrisonQuest["Gates"])then
									setTimer(function()
										PrisonQuest.createGates()
									end,900000,1)
								end
							end,7500,1,id)
						end,5000,1,player,PrisonGateID)
					else
						createInfobox(player,getText(player,"SNests4"))
					end
				end
			end
		end
	end
end

addEvent("PrisonQuest.checkQuest",true)
addEventHandler("PrisonQuest.checkQuest",root,function()
	setQuest(client,18)
	if(getQuest(client,18) <= 1)then
		if(KnowNPC(client,71) == false)then
			NPC.NormalMessage(client,getText(client,"SPrisonQuest2"))
			giveRadioData(client,2)
		else
			NPC.NormalMessage(client,getText(client,"SPrisonQuest3"))
			Quests.finishQuest(client,18)
		end
	else
		triggerClientEvent(client,"NPC.NormalMessage",client,getText(client,"SOutfits3"))
	end
end)

addEventHandler("onPlayerWasted",root,function()
	unbindKey(source,"e","down",PrisonQuest.plantBomb)
	apocalypseSetElementData(player,"PrisonQuestBind",false)
end)