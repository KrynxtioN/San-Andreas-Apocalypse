addEvent("checkStartSpin", true)
addEventHandler("checkStartSpin", root, function()
	if(apocalypseGetElementData(client, "freespins") >= 1)then
		apocalypseSetElementData(client, "freespins", apocalypseGetElementData(client, "freespins") - 1)
		triggerClientEvent(client, "startSpin", client)
	else
		if(tonumber(apocalypseGetElementData(client, "money")) >= 1000 and hasPlayerItem(client, 1) >= 50)then
			takeItem(client, 1, 50)
			apocalypseSetElementData(client, "money", apocalypseGetElementData(client, "money") - 1000)
			triggerClientEvent(client, "startSpin", client)
		else NPC.NormalMessage(client, getText(client, "SSpinningWheel5"))end
	end
end)

addEvent("giveSpinPrice", true)
addEventHandler("giveSpinPrice", root, function(price)
	setAchievement(client, 12)
	if(price == "EXP")then
		local amount = math.random(500,1250)
		giveEXP(client, amount)
		NPC.NormalMessage(client, getText(client, "SSpinningWheel2"):format(amount))
	elseif(price == "Money")then
		local amount = math.random(500,1000)
		givePlayerServerMoney(client,amount)
		NPC.NormalMessage(client, getText(client, "SSpinningWheel3"):format(amount))
	elseif(price == "Brainmass")then
		local amount = math.random(100,200)
		giveItem(client, 1, amount)
		triggerClientEvent(client, "showItemBar", client, {{1,amount}})
		NPC.NormalMessage(client, getText(client, "SSpinningWheel6"):format(amount))
	elseif(price == "Freespin")then
		NPC.NormalMessage(client, getText(client, "SSpinningWheel4"))
		apocalypseSetElementData(client, "freespins", apocalypseGetElementData(client, "freespins")+1)
	elseif(price == "Coupon")then
		local couponID = math.random(1,3)
		local itemID = 0
		if(couponID == 1)then itemID = 15 end
		if(couponID == 2)then itemID = 16 end
		if(couponID == 3)then itemID = 17 end
		if(item ~= 0)then
			giveItem(client,itemID,1)
			triggerClientEvent(client, "showItemBar", client, {{itemID,1}})
			NPC.NormalMessage(client, getText(client, "SSpinningWheel7"))
		end
	elseif(price == "SpecialItem")then
		local amount = math.random(50,100)
		NPC.NormalMessage(client, getText(client, "SSpinningWheel8"):format(amount))
		giveLootItems(client,amount)
	elseif(price == "SACoinChest")then
		giveItem(client,68,1)
		triggerClientEvent(client, "showItemBar", client, {{68,1}})
		NPC.NormalMessage(client, getText(client, "SSpinningWheel9"))
		setAchievement(client,90)
	elseif(price == "VehicleChest")then
		giveItem(client,69,1)
		triggerClientEvent(client, "showItemBar", client, {{69,1}})
		NPC.NormalMessage(client, getText(client, "SSpinningWheel10"))
		setAchievement(client,89)
	end
end)

function addFreespin()
	local time = getRealTime()
	local currentTimestamp = time.timestamp

	local dailyspin = tonumber(getPlayerData("characters", "ID", getCharacterID(client), "dailyspin"))
	if (not dailyspin) then
		dailyspin = 0
	end

	if ((currentTimestamp - dailyspin) >= 14400) then
		setAchievement(client, 46)
		apocalypseSetElementData(client, "freespins", apocalypseGetElementData(client, "freespins") + 1)
		
		dbExec(handler, "UPDATE characters SET dailyspin = '" .. currentTimestamp .. "' WHERE ID = '" .. getCharacterID(client) .. "'")
		
		NPC.NormalMessage(client, getText(client, "SSpinningWheell1"))
	else
		local timeLeft = 14400 - (currentTimestamp - dailyspin)
		NPC.NormalMessage(client, getText(client, "SSpinningWheel1"):format(formatTimeLeft(timeLeft)))
	end
end
addEvent("addFreespin", true)
addEventHandler("addFreespin", root, addFreespin)