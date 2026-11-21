SellTrash = {
	["ItemPrices"] = {
		[151] = 2, [152] = 2, [153] = 3, [154] = 1, [155] = 3, [156] = 4,
		[157] = 2, [158] = 1, [159] = 3, [160] = 4, [161] = 5, [162] = 3,
		[163] = 8, [164] = 7, [165] = 5, [166] = 6, [167] = 9, [168] = 4,
	}
}

addEvent("SellTrash.sellItems", true)
addEventHandler("SellTrash.sellItems", root, function(cart)
	if client ~= source then return end
	if type(cart) ~= "table" then return end

	local totalMoney = 0
	local soldItems = 0

	for itemID, amount in pairs(cart) do
		itemID = tonumber(itemID)
		amount = tonumber(amount)

		if itemID and amount and amount > 0 and SellTrash.ItemPrices[itemID] then
			local playerAmount = hasPlayerItem(source, itemID) or 0

			if playerAmount >= amount then
				takeItem(source, itemID, amount)

				totalMoney = totalMoney + (amount * SellTrash.ItemPrices[itemID])
				soldItems = soldItems + amount
			end
		end
	end

	if totalMoney <= 0 then
		NPC.NormalMessage(client,getText(client,"SSellTrash1"))
		return
	end

	givePlayerServerMoney(source, totalMoney)
	outputChatBox("Du hast " .. soldItems .. " Items für $" .. totalMoney .. " verkauft.", source, 220, 25, 25)
	NPC.NormalMessage(client,getText(client,"SSellTrash2"):format(soldItems,totalMoney))
end)