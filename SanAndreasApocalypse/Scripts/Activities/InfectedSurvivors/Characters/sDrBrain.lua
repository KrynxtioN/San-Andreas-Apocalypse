DrBrain = {
	["Items"] = { -- Name, Costs {Item, Amount}
		["EN"] = {
			["Syringe"] = {1,5},
			["Syringe Crafting Recipe"] = {30,50},
		},
		["DE"] = {
			["Spritze"] = {1,5},
			["Spritze Herstellungsrezept"] = {30,50},
		},
		["RU"] = {
			["Шприц"] = {1,5},
			["Рецепт изготовления шприца"] = {30,50},
		},
		["PT"] = {
			["Seringa"] = {1,5},
			["Receita para fabricar seringa"] = {30,50},
		},
	},
}

addEvent("DrBrain.Buy",true)
addEventHandler("DrBrain.Buy",root,function(item, amount)
	if(isCharacterLoggedIn(client))then
		if(item and amount)then
			local amount = tonumber(amount)
			local ItemIDCosts = tonumber(DrBrain["Items"][apocalypseGetElementData(client,"language") or "EN"][item][1])
			local Costs = tonumber(DrBrain["Items"][apocalypseGetElementData(client,"language") or "EN"][item][2])
			if(hasPlayerItem(client,ItemIDCosts) >= Costs)then
				if(item == "Syringe Crafting Recipe" or item == "Spritze Herstellungsrezept" or item == "Рецепт изготовления шприца" or item == "Receita para fabricar seringa")then
					if(hasPlayerCraftingRecipe(client,10) == false)then
						takeItem(client,ItemIDCosts,Costs)
						NPC.NormalMessage(client,getText(client,"SDrBrain2"))
						addPlayerCraftingRecipe(client,10)
						outputLog(getPlayerName(client).." hat das Herstellungsrezept für eine Spritze gekauft", "Dr. Brain (Shop)", getCharacterID(client))
					else
						NPC.NormalMessage(client,getText(client,"SDrBrain3"))
					end
				else
					giveItem(client,31,amount)
					takeItem(client,ItemIDCosts,Costs)
					NPC.NormalMessage(client,getText(client,"SDrBrain1"):format(amount))
					outputLog(getPlayerName(client).." ("..getCharacterID(client)..") hat eine Spritze gekauft", "Dr. Brain (Shop)", getCharacterID(client))
				end
				setAchievement(client,83)
			else
				NPC.NormalMessage(client,getText(client,"SDrBrain4"))
			end
		end
	end
end)

addEvent("DrBrain.Server",true)
addEventHandler("DrBrain.Server",root,function()
	if(hasPlayerPhoto(client,1) == true and hasRadioLocation(client,8) == false)then
		giveRadioData(client,8)
		NPC.NormalMessage(client,getText(client,"SDrBrain7"))
		AreaCard.loadData(client)
	else
		triggerClientEvent(client,"DrBrain.Interact",client)
	end
end)