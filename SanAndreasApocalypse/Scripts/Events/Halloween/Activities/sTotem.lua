HalloweenTotem = {
	["Position"] = {
		[1] = {-330.8528137207,823.88067626953,13.267200469971},
		[2] = {-414.533203125,2256.5793457031,41.429698944092},
		[3] = {1555.8620605469,-38.78150177002,20.298999786377},
		[4] = {159.83839416504,736.6298828125,5.2508001327515},
		[5] = {-836.25787353516,1440.6898193359,13.149000167847},
		[6] = {-22.377199172974,2081.7358398438,16.770000457764},
		[7] = {2910.0888671875,2117.6762695312,9.770299911499},
		[8] = {-886.58941650391,2737.619140625,45.232200622559},
		[9] = {-160.591796875,2738.4846191406,61.181301116943},
		[10] = {1201.0262451172,2619.8215332031,9.8703002929688},
		[11] = {2140.1616210938,2642.9548339844,9.8452997207642},
		[12] = {1054.3767089844,959.86071777344,9.8703002929688},
		[13] = {2718.9865722656,915.30627441406,9.9236001968384},
		[14] = {2275.40625,700.98248291016,9.7763996124268},
		[15] = {2839.6652832031,1629.2154541016,9.7952995300293},
		[16] = {782.67272949219,1681.8718261719,4.3062000274658},
		[17] = {292.87451171875,1395.3741455078,9.3226003646851},
		[18] = {-316.15780639648,1594.8967285156,74.526802062988},
		[19] = {378.36419677734,2592.0986328125,15.434399604797},
		[20] = {297.42181396484,1672.5440673828,16.615600585938},
		[21] = {640.35479736328,1279.3059082031,10.71129989624},
		[22] = {1342.0723876953,1886.0168457031,9.8203001022339},
		[23] = {2179.7346191406,2332.9582519531,10.792200088501},
		[24] = {2512.5581054688,2869.6040039062,9.8452997207642},
		[25] = {1505.4418945312,905.00872802734,9.7952995300293},
	},
}

HalloweenTotem.pumpkinReward = 5
HalloweenTotem.expReward = 200

function HalloweenTotem.giveRewards()
    local characterID = getCharacterID(player)
    local playerHalloweenTotems = getPlayerData("characters", "ID", characterID, "halloween_totems")

    if playerHalloweenTotems and playerHalloweenTotems ~= "" then
        local values = split(playerHalloweenTotems, "|")
        local totemCount = 0

        for _, v in ipairs(values) do
            if v ~= "" then
                totemCount = totemCount + 1
            end
        end

        if totemCount > 0 then
            local totalEXP = HalloweenTotem.expReward * totemCount
            local totalPumpkins = HalloweenTotem.pumpkinReward * totemCount

            giveEXP(player, totalEXP)
            giveHalloweenPumpkin(player, totalPumpkins)
            outputChatBox(getText(player,"SHalloween4"):format(totalEXP,totalPumpkins), player, 255, 140, 0)
			
			outputLog(getPlayerName(player).." hat "..totalEXP.." EXP und "..totalPumpkins.." Kürbisse durch Totems erhalten","Halloween Event",getCharacterID(player))
        end
    end
end

function HalloweenTotem.load(player)
	if(HalloweenEvent == true)then
		triggerClientEvent(player,"HalloweenTotem.destroyClient",player)
		for i,v in ipairs(HalloweenTotem["Position"]) do
			if(HalloweenTotem.hasTotem(player,i) == false)then
				triggerClientEvent(player,"HalloweenTotem.createMarker",player,v[1],v[2],v[3],i)
			end
			if(HalloweenTotem.hasTotem(player,i) == true)then
				triggerClientEvent(player,"HalloweenTotem.createTotem",player,v[1],v[2],v[3],i)
			end
		end
	end
end

function HalloweenTotem.hasTotem(player,ID)
	local ID = tonumber(ID)
	local characterID = getCharacterID(player)
	local playerHalloweenTotems = getPlayerData("characters", "ID", characterID, "halloween_totems")
	
	if(not(playerHalloweenTotems))then
		dbExec(handler, "UPDATE characters SET halloween_totems = '' WHERE ID = '"..characterID.."'")
		playerHalloweenTotems = getPlayerData("characters", "ID", characterID, "halloween_totems")
	end
	
	local values = split(playerHalloweenTotems, "|")
	local hasHalloweenTotem = false

	if(playerHalloweenTotems and ID)then
		for _, v in pairs(values)do
			if(tonumber(v) == ID)then
				hasHalloweenTotem = true
				break
			end
		end
	end
	return hasHalloweenTotem
end

function HalloweenTotem.setTotem(player,ID)
	local ID = tonumber(ID)
	if(HalloweenTotem.hasTotem(player,ID) == false)then
		local characterID = getCharacterID(player)
		local playerHalloweenTotems = getPlayerData("characters", "ID", characterID, "halloween_totems")
		dbExec(handler, "UPDATE characters SET halloween_totems = '"..playerHalloweenTotems..ID.."|' WHERE ID = '"..characterID.."'")
		giveEXP(player,1000)
		givePlayerSkillpoint(player,5)
		giveHalloweenPumpkin(player,25)
		outputLog(getPlayerName(player).." hat einen Totem platziert","Halloween Event",getCharacterID(player))
	end
end
addEvent("HalloweenTotem.setTotem",true)
addEventHandler("HalloweenTotem.setTotem",root,HalloweenTotem.setTotem)

function HalloweenTotem.place(ID)
	local ID = tonumber(ID)
	if(HalloweenTotem.hasTotem(client,ID) == false)then
		if(hasPlayerItem(client,183) >= 1)then
			takeItem(client,183,1)
			HalloweenTotem.setTotem(client,ID)
			HalloweenTotem.load(client)
			createInfobox(client,getText(client,"SHalloweenTotem2"))
		else
			NPC.MeMessage(client,getText(client,"SHalloweenTotem1"))
		end
	end
end
addEvent("HalloweenTotem.place",true)
addEventHandler("HalloweenTotem.place",root,HalloweenTotem.place)