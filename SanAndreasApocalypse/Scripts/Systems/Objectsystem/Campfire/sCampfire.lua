Campfire = {
    HealMarker = {},
    HealTimer = {},
    HealedAmount = {},
}

function createCampfire(object)
    local ID = apocalypseGetElementData(object, "ServerObjectID")
    local x, y, z = getElementPosition(object)
	local int, dim = getElementInterior(object), getElementDimension(object)

    Campfire.HealMarker[ID] = createMarker(x, y, z, "cylinder", 5, 255, 255, 255, 0)
    Campfire.HealedAmount[ID] = {}
	apocalypseSetElementData(Campfire.HealMarker[ID],"CampfireHealID",ID)
	setElementInterior(Campfire.HealMarker[ID],int)
	setElementDimension(Campfire.HealMarker[ID],dim)

    addEventHandler("onMarkerHit", Campfire.HealMarker[ID], function(player)
        if getElementType(player) == "player" then
			local ID = apocalypseGetElementData(source,"CampfireHealID")
            if not Campfire.HealedAmount[ID][player] then
                Campfire.HealedAmount[ID][player] = 0
            end

            Campfire.HealTimer[player] = setTimer(function(player)
				if(player and isElement(player) and not(isPedDead(player)))then
					local healed = Campfire.HealedAmount[ID][player] or 0
					if healed < 50 then
						local currentHealth = getElementHealth(player)
						local newHealth = math.min(currentHealth + 1, 100)

						local healedThisTick = newHealth - currentHealth
						Campfire.HealedAmount[ID][player] = healed + healedThisTick

						setElementHealth(player, newHealth)

						if Campfire.HealedAmount[ID][player] >= 50 then
							setTimer(function(player)
								Campfire.HealedAmount[ID][player] = 0
							end, 600000, 1, player)
							killTimer(Campfire.HealTimer[player])
						end

						if newHealth >= 100 then
							if(isTimer(Campfire.HealTimer[player]))then
								killTimer(Campfire.HealTimer[player])
							end
						end
					else
						if(isTimer(Campfire.HealTimer[player]))then
							killTimer(Campfire.HealTimer[player])
						end
					end
				end
            end, 1000, 0,player)
        end
    end)

    addEventHandler("onMarkerLeave", Campfire.HealMarker[ID], function(player)
        if isTimer(Campfire.HealTimer[player]) then
            killTimer(Campfire.HealTimer[player])
        end
    end)

    for _, v in pairs(getElementsByType("player")) do
		triggerClientEvent(v, "updateCampfiresForAll", v)
    end
end

local cookFishTimer = {}
local amountFish = {
	[133] = 7,
	[134] = 7,
	[135] = 7,
	[136] = 4,
	[137] = 4,
	[138] = 4,
	[139] = 4,
	[140] = 2,
	[141] = 2,
	[142] = 2,
	[209] = 15,
}

local fishAchievements = {
	{1,350},
	{5,351},
	{10,352},
	{25,353},
	{50,354},
	{75,355},
	{125,356},
	{175,357},
	{250,358},
}

function Campfire.cookItem(player,item)
	local itemID = tonumber(item)
	local marker = nil
	for _,v in pairs(Campfire.HealMarker)do
		if(isElementWithinMarker(player,v))then
			marker = v
			break
		end
	end
	if(marker ~= nil)then
		if(not(isTimer(cookFishTimer[player])))then
			setElementFrozen(player, true)
			setPedAnimation(player, "BOMBER", "BOM_Plant_Loop", -1, true, false, false, true)
			triggerClientEvent(player,"createProgressBar",player,6)
			takeItem(player,itemID,1)
			cookFishTimer[player] = setTimer(function(player,itemID)
				if(itemID == 133 or itemID == 134 or itemID == 135 or itemID == 136 or itemID == 137 or itemID == 138 or itemID == 139 or itemID == 140 or itemID == 141 or itemID == 142 or itemID == 209)then
					local cooked_fish = getPlayerData("character_stats","character_id",getCharacterID(player),"cooked_fish")
					Characters.addStats(player,"cooked_fish",cooked_fish + 1)
					for _,v in pairs(fishAchievements)do
						if(cooked_fish + 1 >= v[1])then
							setAchievement(player,v[2])
						end
					end
					giveItem(player,182,amountFish[itemID])
					triggerClientEvent(player, "showItemBar", player, {{182,amountFish[itemID]}})
				end
				if(itemID == 117)then
					local meat_amount = math.random(2,3)
					giveItem(player,198,meat_amount)
					triggerClientEvent(player, "showItemBar", player, {{198,meat_amount}})
				end
				NPC.MeMessage(player,getText(player,"SCampfire2"))
				setElementFrozen(player, false)
				setPedAnimation(player)
			end,6000,1,player,itemID)
		end
	else
		NPC.MeMessage(player,getText(player,"SCampfire1"))
	end
end

addEventHandler("onPlayerWasted", root, function()
    if isTimer(Campfire.HealTimer[source]) then
        killTimer(Campfire.HealTimer[source])
    end
end)

addEventHandler("onPlayerQuit", root, function()
    if isTimer(Campfire.HealTimer[source]) then
        killTimer(Campfire.HealTimer[source])
    end
end)