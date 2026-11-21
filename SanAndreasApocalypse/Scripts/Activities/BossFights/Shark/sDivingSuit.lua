local Pickup = createPickup(358.39147949219,-2072.0600585938,10.6953125,3,1239,50)
local Daily_Oxygen_Bonus = createPickup(353.70391845703,-2068.8413085938,10.6953125,3,1239,50)
local Daily_Oxygen_Bonus_Picked = {}

addEventHandler("onPickupHit",Daily_Oxygen_Bonus,function(player)
	if(getElementType(player) == "player")then
		if(getElementDimension(player) == 0)then
			if(getElementInterior(player) == 0)then
				if(not(Daily_Oxygen_Bonus_Picked[player]))then
					giveItem(player,105,2)
					triggerClientEvent(player, "showItemBar", client, {{105,2}})
					createInfobox(player,getText(player,"SDailyOxygenBonus1"))
					Daily_Oxygen_Bonus_Picked[player] = true
				else
					NPC.MeMessage(player,getText(player,"SDailyOxygenBonus2"))
				end
			end
		end
	end
end)

addEventHandler("onPickupHit",Pickup,function(player)
	if(getElementType(player) == "player")then
		if(getElementDimension(player) == 0)then
			if(getElementInterior(player) == 0)then
				apocalypseSetElementData(player,"rentedDivingSuit",false)
				triggerClientEvent(player,"delDivingArea",player)
				if(apocalypseGetElementData(player,"DivingSuitUse") ~= true)then
					--createInfobox(player,getText(player,"CDivingSuit2"))
					apocalypseSetElementData(player,"rentedDivingSuit",true)
					triggerClientEvent(player,"createDivingArea",player)
					triggerClientEvent(player,"JobInformation.createWindow",player,8)
				end
				triggerClientEvent(player,"useDivingSuit",player)
			end
		end
	end
end)

addEventHandler("onPlayerWasted",root,function()
	if(apocalypseGetElementData(source,"DivingSuitUse") == true)then
		triggerClientEvent(source,"useDivingSuit",source)
		apocalypseSetElementData(source,"rentedDivingSuit",false)
	end
	triggerClientEvent(source,"delDivingArea",source)
end)