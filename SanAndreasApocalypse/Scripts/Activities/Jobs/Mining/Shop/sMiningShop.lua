MiningShop = {
	["Items"] = {
		["Spitzhacke"] = {350,102},
		["Pickaxe"] = {350,102},
		["Кирка"] = {350,102},
		["Picareta"] = {350,102},
	},
}

addEvent("MiningShop.buyItem",true)
addEventHandler("MiningShop.buyItem",root,function(item,amount)
	local money = tonumber(apocalypseGetElementData(client,"money"))
	local amount = tonumber(amount)
	local costs = tonumber(MiningShop["Items"][item][1]) * amount
	
	if(money >= costs)then
		apocalypseSetElementData(client,"money",money-costs)
		giveItem(client,MiningShop["Items"][item][2],amount)
		NPC.NormalMessage(client,getText(client,"SMiningshop2"))
		outputLog(getPlayerName(client).." hat das Item "..item.." für $"..costs.." "..amount.."x gekauft", "Mining Shop", getCharacterID(client))
	else
		NPC.NormalMessage(client,getText(client,"SMiningshop1"))
	end
end)