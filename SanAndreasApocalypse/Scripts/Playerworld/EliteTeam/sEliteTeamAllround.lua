EliteTeam = {}

EliteTeam.Entrance = createPickup(-1740.0183105469,789.80615234375,24.892105102539,3,1318,50)
EliteTeam.Leave = createPickup(-1747.7819824219,808.81726074219,162.25535583496,3,1318,50)

EliteTeam.SkillTerminal = createPickup(-1756.1450195312,789.64477539062,162.25535583496,3,1318,50)

addEventHandler("onPickupHit",EliteTeam.SkillTerminal,function(player)
	if(getElementType(player) == "player")then
		if(getElementDimension(player) == getElementDimension(source))then
			triggerClientEvent(player,"Skillsystem.openManager",player)
			if(hasPlayerItem(player,241) == 0)then
				giveItem(player,241,1)
				createInfobox(player,getText(player,"sEliteTeamAllround1"))
			end
		end
	end
end)

addEventHandler("onPickupHit",EliteTeam.Entrance,function(player)
	if(getElementType(player) == "player")then
		if(not(isPedInVehicle(player)))then
			if(getElementDimension(player) == getElementDimension(source))then
				if(getElementInterior(player) == getElementInterior(source))then
					--if(hasPlayerDocument(player,4) == true and hasPlayerDocument(player,5) == true and hasPlayerDocument(player,6) == true)then
						setElementPosition(player,-1749.611328125,808.88525390625,162.25535583496)
						setElementRotation(player,0,0,90)
						setAchievement(player,419)
					--else
					--	NPC.MeMessage(player,getText(player,"SEliteTeam1"))
					--end
				end
			end
		end
	end
end)

addEventHandler("onPickupHit",EliteTeam.Leave,function(player)
	if(getElementType(player) == "player")then
		if(not(isPedInVehicle(player)))then
			if(getElementDimension(player) == getElementDimension(source))then
				if(getElementInterior(player) == getElementInterior(source))then
					setElementPosition(player,-1737.5040283203,789.74749755859,24.892105102539)
					setElementRotation(player,0,0,270)
					setElementInterior(player,0)
				end
			end
		end
	end
end)