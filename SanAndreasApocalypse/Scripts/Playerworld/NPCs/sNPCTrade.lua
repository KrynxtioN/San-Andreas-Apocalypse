dbExec(handler,"UPDATE characters SET npc_trade_data = ''")


local NPCTradePools = {
	standard = {amount = 10, items = {1,2,3,4,6,7,8,9,13,34,39,60,61,78,79,80,81,82,83,84,86,121,122,151,152,153,154,155,156,157,158,159,160,161,162,163}},
	normal = {amount = 7, items = {19,20,21,22,40,44,45,46,47,57,63,67,92,94,95,96,97,98,100,101,117,118,133,134,135,148,149,164,165,166,167,168,182,198}},
	selten = {amount = 5, items = {30,31,23,26,27,28,29,32,33,48,49,50,51,52,53,54,55,56,59,102,105,109,110,111,136,137,138,185}},
	raritaet = {amount = 3, items = {62,70,71,72,75,87,88,89,90,91,108,112,113,114,115,139,140,141,169,174,186,192,199,200,202}},
	unglaublich = {amount = 1, items = {68,69,73,74,76,77,129,130,142,143,146,147,175,184,194,195,196,197}},
}

local function getTradeDay()
	local rt = getRealTime()
	return tostring(rt.year) .. "-" .. tostring(rt.yearday)
end

local function getItemName(player, itemID)
	local lang = apocalypseGetElementData(player, "language") or "EN"

	if ItemInfos and ItemInfos["items"] and ItemInfos["items"][lang] and ItemInfos["items"][lang][itemID] then
		return ItemInfos["items"][lang][itemID]
	end

	return "Item " .. tostring(itemID)
end

local function createRandomTradeOffer()
	local classes = {"standard", "normal", "selten", "raritaet", "unglaublich"}
	local class = classes[math.random(1, #classes)]
	local pool = NPCTradePools[class]

	local rewardItem = pool.items[math.random(1, #pool.items)]
	local priceItem = rewardItem

	while priceItem == rewardItem and #pool.items > 1 do
		priceItem = pool.items[math.random(1, #pool.items)]
	end

	return {
		day = getTradeDay(),
		item = rewardItem,
		amount = pool.amount,
		class = class,
		bought = 0,
		priceItem = priceItem,
		priceAmount = pool.amount,
	}
end

local function parseNPCTradeData(data)
	local result = {}

	for _, entry in ipairs(split(tostring(data or ""), "|")) do
		local p = split(entry, ",")
		local npcID = tonumber(p[1])

		if npcID then
			result[npcID] = {
				day = p[2],
				item = tonumber(p[3]),
				amount = tonumber(p[4]),
				class = p[5],
				bought = tonumber(p[6]) or 0,
				priceItem = tonumber(p[7]),
				priceAmount = tonumber(p[8]),
			}
		end
	end

	return result
end

local function isTradeOfferValid(offer)
	if not offer then return false end
	if not offer.day then return false end
	if not offer.class or not NPCTradePools[offer.class] then return false end
	if not tonumber(offer.item) or tonumber(offer.item) <= 0 then return false end
	if not tonumber(offer.amount) or tonumber(offer.amount) <= 0 then return false end
	if not tonumber(offer.priceItem) or tonumber(offer.priceItem) <= 0 then return false end
	if not tonumber(offer.priceAmount) or tonumber(offer.priceAmount) <= 0 then return false end
	if tonumber(offer.item) == tonumber(offer.priceItem) and #NPCTradePools[offer.class].items > 1 then return false end
	return true
end

local function buildNPCTradeData(tbl)
	local result = {}

	for npcID, data in pairs(tbl) do
		if isTradeOfferValid(data) then
			table.insert(result, table.concat({
				tostring(npcID),
				tostring(data.day),
				tostring(data.item),
				tostring(data.amount),
				tostring(data.class),
				tostring(data.bought or 0),
				tostring(data.priceItem),
				tostring(data.priceAmount),
			}, ","))
		end
	end

	return table.concat(result, "|")
end

local function getOrCreateNPCTradeOffer(player, npcID)
	local charID = getCharacterID(player)
	local data = getPlayerData("characters", "ID", charID, "npc_trade_data") or ""

	local trades = parseNPCTradeData(data)
	local today = getTradeDay()

	if not isTradeOfferValid(trades[npcID]) or trades[npcID].day ~= today then
		trades[npcID] = createRandomTradeOffer()
		dbExec(handler, "UPDATE characters SET npc_trade_data = ? WHERE ID = ?", buildNPCTradeData(trades), charID)
	end

	return trades[npcID], trades
end

local function sendNPCTradeData(player, npcID, eventName)
	local offer = getOrCreateNPCTradeOffer(player, npcID)
	if not offer then return end

	triggerClientEvent(player, eventName, player, {
		npcID = npcID,

		item = offer.item,
		itemName = getItemName(player, offer.item),
		amount = offer.amount,

		class = offer.class,
		bought = offer.bought or 0,

		price = {
			item = offer.priceItem,
			itemName = getItemName(player, offer.priceItem),
			amount = offer.priceAmount,
		},
	})
end

addEvent("NPC.requestTradePreview", true)
addEventHandler("NPC.requestTradePreview", root, function(npcID)
	if not isCharacterLoggedIn(client) then return end

	npcID = tonumber(npcID)
	if not npcID then return end

	sendNPCTradeData(client, npcID, "NPC.updateTradePreview")
end)

addEvent("NPC.requestTrade", true)
addEventHandler("NPC.requestTrade", root, function(npcID)
	if not isCharacterLoggedIn(client) then return end

	npcID = tonumber(npcID)
	if not npcID then return end

	sendNPCTradeData(client, npcID, "NPC.openTradeWindow")
end)

addEvent("NPC.buyTradeOffer", true)
addEventHandler("NPC.buyTradeOffer", root, function(npcID)
	if not isCharacterLoggedIn(client) then return end

	npcID = tonumber(npcID)
	if not npcID then return end

	local charID = getCharacterID(client)
	local offer, trades = getOrCreateNPCTradeOffer(client, npcID)

	if not offer then return end

	if tonumber(offer.bought) == 1 then
		NPC.NormalMessage(client, getText(client,"SNPCTrade3"))
		return
	end

	if hasPlayerItem(client, offer.priceItem) < offer.priceAmount then
		NPC.NormalMessage(client, getText(client,"SNPCTrade1"):format(offer.priceAmount,getItemName(client,offer.priceItem)))
		return
	end

	takeItem(client, offer.priceItem, offer.priceAmount)
	giveItem(client, offer.item, offer.amount)

	triggerClientEvent(client, "showItemBar", client, {{offer.item, offer.amount}})

	trades[npcID].bought = 1
	dbExec(handler, "UPDATE characters SET npc_trade_data = ? WHERE ID = ?", buildNPCTradeData(trades), charID)

	NPC.NormalMessage(client, getText(client,"SNPCTrade2"))
	triggerClientEvent(client, "NPC.closeTradeWindow", client)
	triggerClientEvent(client, "NPC.clearTradePreview", client)
end)