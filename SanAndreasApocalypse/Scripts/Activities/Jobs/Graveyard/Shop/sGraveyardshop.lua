Graveyardshop = {
	["Items"] = {
		["Dünger"] = {25,170},
		["Superdünger"] = {50,171},
		["Spezial Dünger"] = {500,172},
		["Schaufel"] = {250,173},
		["Gießkanne"] = {3500,191},
		
		["Fertilizer"] = {25,170},
		["Super Fertilizer"] = {50,171},
		["Special Fertilizer"] = {500,172},
		["Shovel"] = {250,173},
		["Watering Can"] = {3500,191},
		
		["Удобрение"] = {25,170},
		["Суперудобрение"] = {50,171},
		["Специальное удобрение"] = {500,172},
		["Лопата"] = {250,173},
		["Лейка"] = {3500,191},
		
		["Fertilizante"] = {25,170},
		["Superfertilizante"] = {50,171},
		["Fertilizante Especial"] = {500,172},
		["Pá"] = {250,173},
		["Regador"] = {3500,191},
	},
}

addEvent("Graveyardshop.buyItem",true)
addEventHandler("Graveyardshop.buyItem",root,function(item,amount)
	local money = tonumber(apocalypseGetElementData(client,"money"))
	local amount = tonumber(amount)
	local costs = tonumber(Graveyardshop["Items"][item][1]) * amount
	if(money >= costs)then
		if(item == "Watering Can" or item == "Gießkanne" or item == "Лейка" or item == "Regador")then
			if(tonumber(apocalypseGetElementData(client,"level")) < 75)then
				NPC.NormalMessage(client,getText(client,"SGraveyardshop3"))
				return
			end
		end
		apocalypseSetElementData(client,"money",money-costs)
		giveItem(client,Graveyardshop["Items"][item][2],amount)
		NPC.NormalMessage(client,getText(client,"SGraveyardshop2"))
		outputLog(getPlayerName(client).." hat das Item "..item.." für $"..costs.." "..amount.."x gekauft", "Graveyard Shop", getCharacterID(client))
		setAchievement(client,308)
	else
		NPC.NormalMessage(client,getText(client,"SGraveyardshop1"))
	end
end)