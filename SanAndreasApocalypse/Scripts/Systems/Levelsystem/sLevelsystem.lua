Levelsystem = {}

function giveEXP(player, amount, isRecursive)
    if isCharacterLoggedIn(player) then
        if player and amount then
            amount = tonumber(amount)

            if amount and amount >= 1 then

                -- Bonus nur beim ersten EXP-Aufruf berechnen
                if not isRecursive then
                    local cardBonus = tonumber(getPlayerData(
                        "accounts",
                        "ID",
                        apocalypseGetElementData(player, "AccountID"),
                        "card_bonus"
                    )) or 0

                    amount = amount + (amount / 100 * cardBonus)
                end

                if not isRecursive then
                    outputLog(
                        "[EXP] "..getPlayerName(player).." "..getCharacterID(player)..
                        " hat "..amount.." EXP bekommen",
                        "EXP",
                        getCharacterID(player)
                    )
                end

                local level = apocalypseGetElementData(player, "level")
                local experiencePoints = apocalypseGetElementData(player, "experiencepoints")
                local needExperience = 250 * (level + 1) + ((level + 1) * 25)

                if experiencePoints + amount >= needExperience then
                    local PlayersEXP = needExperience - experiencePoints

                    apocalypseSetElementData(player, "experiencepoints", 0)
                    apocalypseSetElementData(player, "level", level + 1)

                    level = apocalypseGetElementData(player, "level")

                    triggerClientEvent(player, "onPlayerLevelUp", player, level)

                    local restEXP = amount - PlayersEXP

                    if restEXP > 0 then
                        giveEXP(player, restEXP, true)
                    end

                    setPlayerRank(player)
                    Levelsystem.setAchievement(player)
                    triggerClientEvent(player, "createLevelUpStuff", player, level)

                    if level >= 10 then
                        QuestSeries.giveQuest(player, 1)
                    end

                    if level >= 25 then
                        triggerClientEvent(player, "Skillsystem.destroyGate", player)
                    end
                else
                    apocalypseSetElementData(
                        player,
                        "experiencepoints",
                        experiencePoints + amount
                    )

                    apocalypseSetElementData(
                        player,
                        "experiencepointstotal",
                        apocalypseGetElementData(player, "experiencepointstotal") + amount
                    )
                end

                triggerClientEvent(
                    player,
                    "showFloatingText",
                    player,
                    "+ "..amount.." EXP",
                    200, 200, 0
                )
            end
        end
    end
end
addEvent("giveEXP",true)
addEventHandler("giveEXP", root, giveEXP)

function Levelsystem.nearbyTeammates(player,experience)
	for _,v in pairs(getElementsByType("player"))do
		if(isCharacterLoggedIn(v))then
			if(getPlayerName(v) ~= getPlayerName(player))then
				if(tonumber(apocalypseGetElementData(v,"colony")) >= 1)then
					if(tonumber(apocalypseGetElementData(v,"colony")) == tonumber(apocalypseGetElementData(player,"colony")))then
						local x,y,z = getElementPosition(v)
						local exp_distance = tonumber(getPlayerData("colonys","ID",apocalypseGetElementData(player,"colony"),"exp_distance"))
						if(getDistanceBetweenPoints3D(x,y,z,getElementPosition(player)) <= exp_distance)then
							giveEXP(v,experience/100*50)
						end
					end
				else
					if(isPlayerInParty(v) == true)then
						if(tonumber(apocalypseGetElementData(v,"PartyID")) == tonumber(apocalypseGetElementData(player,"PartyID")))then
							local x,y,z = getElementPosition(v)
							if(getDistanceBetweenPoints3D(x,y,z,getElementPosition(player)) <= 15)then
								giveEXP(v,experience/100*25)
							end
						end
					end
				end
			end
		end
	end
end

function Levelsystem.setAchievement(player)
	local level = apocalypseGetElementData(player, "level")
	if(level >= 10)then setAchievement(player,104) end
	if(level >= 25)then setAchievement(player,105) end
	if(level >= 50)then setAchievement(player,106) end
	if(level >= 100)then setAchievement(player,107) end
	if(level >= 250)then setAchievement(player,108) end
	if(level >= 500)then setAchievement(player,109) end
	if(level >= 1000)then setAchievement(player,110) end
end