HalloweenRewards = {
	["Costs"] = {
		[1] = 500,
		[2] = 1000,
		[3] = 2000,
		[4] = 3000,
		[5] = 3500,
		[6] = 5000,
		[7] = 6500,
		[8] = 8000,
		[9] = 9000,
		[10] = 11500,
	},
	["Rewards"] = {
		[1] = {experience = 1250, money = 2500, candy = 5},
		[2] = {experience = 2500, money = 5000, candy = 10},
		[3] = {experience = 5000, money = 10000, candy = 15},
		[4] = {experience = 7500, money = 15000, candy = 20},
		[5] = {experience = 8750, money = 17500, candy = 25},
		[6] = {experience = 12500, money = 25000, candy = 30},
		[7] = {experience = 16250, money = 32500, candy = 35},
		[8] = {experience = 20000, money = 40000, candy = 40},
		[9] = {experience = 22500, money = 45000, candy = 45},
		[10] = {experience = 28750, money = 57500, candy = 50},
	},
	["SpecialRewards"] = {
		["EN"] = {
			[1] = "Double Experience Coupon (1x)",
			[2] = "Double Money Coupon (1x)",
			[3] = "Pumpkinhead",
			[4] = "Immune to Zombies Coupon (1x)",
			[5] = "Vehicle: Romero (+ Vehicle Slot)",
			[6] = "Double Experience Coupon (2x)",
			[7] = "Double Money Coupon (2x)",
			[8] = "Vehicle: Mr. Whoopee (+ Vehicle Slot)",
			[9] = "Immune to Zombies Coupon (2x)",
			[10] = "Vehicle: Monster 1 (+ Vehicle Slot)",
		},
		["DE"] = {
			[1] = "Doppelte Erfahrungspunkte Coupon (1x)",
			[2] = "Doppeltes Geld Coupon (1x)",
			[3] = "Kürbiskopf",
			[4] = "Immun gegen Zombies Coupon (1x)",
			[5] = "Fahrzeug: Romero (+ Fahrzeugslot)",
			[6] = "Doppelte Erfahrungspunkte Coupon (2x)",
			[7] = "Doppeltes Geld Coupon (2x)",
			[8] = "Fahrzeug: Mr. Whoopee (+ Fahrzeugslot)",
			[9] = "Immun gegen Zombies Coupon (2x)",
			[10] = "Fahrzeug: Monster 1 (+ Fahrzeugslot)",
		},
		["RU"] = {
			[1] = "Купон на двойной опыт (1x)",
			[2] = "Купон на двойные деньги (1x)",
			[3] = "Тыквенная голова",
			[4] = "Купон на иммунитет к зомби (1x)",
			[5] = "Транспорт: Romero (+ слот для транспорта)",
			[6] = "Купон на двойной опыт (2x)",
			[7] = "Купон на двойные деньги (2x)",
			[8] = "Транспорт: Mr. Whoopee (+ слот для транспорта)",
			[9] = "Купон на иммунитет к зомби (2x)",
			[10] = "Транспорт: Monster 1 (+ слот для транспорта)",
		},

		["PT"] = {
			[1] = "Cupom de experiência em dobro (1x)",
			[2] = "Cupom de dinheiro em dobro (1x)",
			[3] = "Cabeça de abóbora",
			[4] = "Cupom de imunidade a zumbis (1x)",
			[5] = "Veículo: Romero (+ vaga de veículo)",
			[6] = "Cupom de experiência em dobro (2x)",
			[7] = "Cupom de dinheiro em dobro (2x)",
			[8] = "Veículo: Mr. Whoopee (+ vaga de veículo)",
			[9] = "Cupom de imunidade a zumbis (2x)",
			[10] = "Veículo: Monster 1 (+ vaga de veículo)",
		},
	},
}

function HalloweenRewards.giveReward(amount)
	local amount = tonumber(amount)
	local result = dbPoll(dbQuery(handler,"SELECT * FROM halloween_data WHERE character_id = '"..getCharacterID(client).."'"),-1)
	if(#result == 0)then
		dbExec(handler,"INSERT INTO halloween_data (character_id,deliveredPumpkins,shopLevel) VALUES ('"..getCharacterID(client).."','0','0')")
	end
	local halloweenData = dbPoll(dbQuery(handler,"SELECT * FROM halloween_data WHERE character_id = '"..getCharacterID(client).."'"),-1)
	local shopLevel = tonumber(halloweenData[1]["shopLevel"])
	if(shopLevel+1 <= 10)then
		local deliveredPumpkins = tonumber(halloweenData[1]["deliveredPumpkins"])
		local costs = tonumber(HalloweenRewards["Costs"][shopLevel + 1])
		local active_costs = costs - deliveredPumpkins
	
		if(amount > active_costs)then amount = active_costs end
		
		if(hasPlayerItem(client,12) >= amount)then
			local experience = HalloweenRewards["Rewards"][shopLevel + 1].experience
			local money = HalloweenRewards["Rewards"][shopLevel + 1].money
			local candy = HalloweenRewards["Rewards"][shopLevel + 1].candy
			takeItem(client,12,amount)
			dbExec(handler,"UPDATE halloween_data SET deliveredPumpkins = '"..deliveredPumpkins + amount.."' WHERE character_id = '"..getCharacterID(client).."'")
			local deliveredPumpkins = tonumber(getPlayerData("halloween_data","character_id",getCharacterID(client),"deliveredPumpkins"))
			if(deliveredPumpkins >= costs)then
				local specialReward = shopLevel + 1
				giveItem(client,18,candy)
				giveEXP(client,experience)
				givePlayerServerMoney(client,money)
				if(specialReward == 1)then giveItem(client,15,1) end
				if(specialReward == 2)then giveItem(client,16,1) end
				if(specialReward == 3)then
					givePlayerHead(client,1)
				end
				if(specialReward == 4)then giveItem(client,17,1) end
				if(specialReward == 5)then
					local vehicle_slots = getPlayerData("characters","ID",getCharacterID(client),"vehicle_slots")
					dbExec(handler,"UPDATE characters SET vehicle_slots = '"..vehicle_slots + 1 .."' WHERE ID = '"..getCharacterID(client).."'")
					addPlayerVehicle(client,442)
				end
				if(specialReward == 6)then giveItem(client,15,2) end
				if(specialReward == 7)then giveItem(client,16,2) end
				if(specialReward == 8)then
					local vehicle_slots = getPlayerData("characters","ID",getCharacterID(client),"vehicle_slots")
					dbExec(handler,"UPDATE characters SET vehicle_slots = '"..vehicle_slots + 1 .."' WHERE ID = '"..getCharacterID(client).."'")
					addPlayerVehicle(client,423)
				end
				if(specialReward == 9)then giveItem(client,17,2) end
				if(specialReward == 10)then
					local vehicle_slots = getPlayerData("characters","ID",getCharacterID(client),"vehicle_slots")
					dbExec(handler,"UPDATE characters SET vehicle_slots = '"..vehicle_slots + 1 .."' WHERE ID = '"..getCharacterID(client).."'")
					addPlayerVehicle(client,444)
				end
				triggerClientEvent(client,"NPC.NormalMessage",client,getText(client,"SHalloween3"))
				dbExec(handler,"UPDATE halloween_data SET deliveredPumpkins = '0', shopLevel = '"..shopLevel + 1 .."' WHERE character_id = '"..getCharacterID(client).."'")
			end
			HalloweenRewards.updateData(client)
		else triggerClientEvent(client,"NPC.NormalMessage",client,getText(client,"SHalloween2"))end
	else triggerClientEvent(client,"NPC.NormalMessage",client,getText(client,"SHalloween1"))end
end
addEvent("HalloweenRewards.giveReward",true)
addEventHandler("HalloweenRewards.giveReward",root,HalloweenRewards.giveReward)

function HalloweenRewards.updateData(player)
	if(not(player))then player = client end
	local result = dbPoll(dbQuery(handler,"SELECT * FROM halloween_data WHERE character_id = '"..getCharacterID(player).."'"),-1)
	if(#result == 0)then
		dbExec(handler,"INSERT INTO halloween_data (character_id,deliveredPumpkins,shopLevel) VALUES ('"..getCharacterID(player).."','0','0')")
	end
	local halloweenData = dbPoll(dbQuery(handler,"SELECT * FROM halloween_data WHERE character_id = '"..getCharacterID(player).."'"),-1)
	local shopLevel = halloweenData[1]["shopLevel"]
	local deliveredPumpkins = halloweenData[1]["deliveredPumpkins"]
	if(shopLevel > 10)then
		triggerClientEvent(player,"closeWindow",player)
		triggerClientEvent(player,"NPC.NormalMessage",player,getText(player,"SHalloween1"))
	else
		triggerClientEvent(player,"HalloweenRewards.updateClientData",player,shopLevel,deliveredPumpkins)
	end
end
addEvent("HalloweenRewards.updateData",true)
addEventHandler("HalloweenRewards.updateData",root,HalloweenRewards.updateData)