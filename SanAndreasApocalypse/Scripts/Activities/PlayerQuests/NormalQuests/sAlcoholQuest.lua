Alcohol_Quest = {Player_Vehicle = {}}

function Alcohol_Quest.startQuest()
	if(not(isElement(Alcohol_Quest.Player_Vehicle[client])))then
		Alcohol_Quest.resetQuest(client)

		Alcohol_Quest.Player_Vehicle[client] = createVehicle(478,-101.42882537842,1337.361328125,10.167191505432,0,0,7)
		apocalypseSetElementData(Alcohol_Quest.Player_Vehicle[client],"Alcohol_Quest_VehOwner",getPlayerName(client))
		apocalypseSetElementData(client,"Alcohol_Quest_firstMsg",false)
		warpPedIntoVehicle(client,Alcohol_Quest.Player_Vehicle[client])
		
		addEventHandler("onVehicleStartEnter",Alcohol_Quest.Player_Vehicle[client],function(player)
			if(getPedOccupiedVehicleSeat(player) == 0)then
				if(apocalypseGetElementData(source,"Alcohol_Quest_VehOwner") ~= getPlayerName(player))then
					NPC.MeMessage(player,getText(player,"SAlcoholQuest1"))
					cancelEvent()
				end
			end
		end)
		
		addEventHandler("onVehicleEnter",Alcohol_Quest.Player_Vehicle[client],function(player)
			if(getPedOccupiedVehicleSeat(player) == 0)then
				if(apocalypseGetElementData(player,"Alcohol_Quest_firstMsg") == false)then
					NPC.MeMessage(player,getText(player,"SAlcoholQuest2"))
					apocalypseSetElementData(player,"Alcohol_Quest_firstMsg",true)
				end
				triggerClientEvent(player,"Alcohol_Quest.createBlip",player)
			end
		end)
		
		addEventHandler("onVehicleExit",Alcohol_Quest.Player_Vehicle[client],function(player)
			triggerClientEvent(player,"Alcohol_Quest.removeBlip",player)
		end)
	else
		createInfobox(client,getText(client,"SAlcoholQuest4"))
	end
end
addEvent("Alcohol_Quest.startQuest",true)
addEventHandler("Alcohol_Quest.startQuest",root,Alcohol_Quest.startQuest)

addEventHandler("onElementClicked", root, function(button, state, player)
    if button == "left" and state == "down" then
        if getElementType(source) == "vehicle" then
            if apocalypseGetElementData(source,"Alcohol_Quest_VehOwner") then
                if apocalypseGetElementData(source,"Alcohol_Quest_VehOwner") ~= getPlayerName(player) then
                    NPC.MeMessage(player,getText(player,"SAlcoholQuest1"))
                    return
                end
                if(apocalypseGetElementData(player,"Alcohol_Quest_Crate") == true)then
					if(not(apocalypseGetElementData(source,"Alcohol_Crates")))then
						apocalypseSetElementData(source,"Alcohol_Crates",0)
					end
					local crates = apocalypseGetElementData(source,"Alcohol_Crates")
					apocalypseSetElementData(source,"Alcohol_Crates",crates + 1)
					triggerClientEvent(player,"Alcohol_Quest.destroyCrate",player)
					if(crates + 1 >= 5)then
						NPC.MeMessage(player,getText(player,"SAlcoholQuest3"))
					end
				end
            end
        end
    end
end)

addEvent("Alcohol_Quest.Delivery",true)
addEventHandler("Alcohol_Quest.Delivery",root,function()
	if(isPedInVehicle(client))then
		local veh = getPedOccupiedVehicle(client)
		if(getPedOccupiedVehicleSeat(client) == 0)then
			if(veh == Alcohol_Quest.Player_Vehicle[client])then
				Alcohol_Quest.resetQuest(client)
				triggerClientEvent(client,"Alcohol_Quest.resetQuest",client)
				Quests.finishQuest(client,34)
			end
		end
	end
end)

function Alcohol_Quest.resetQuest(player)
	if(isElement(Alcohol_Quest.Player_Vehicle[player]))then
		destroyElement(Alcohol_Quest.Player_Vehicle[player])
		Alcohol_Quest.Player_Vehicle[player] = nil
	end
end

addEventHandler("onPlayerQuit",root,function()
	Alcohol_Quest.resetQuest(source)
end)