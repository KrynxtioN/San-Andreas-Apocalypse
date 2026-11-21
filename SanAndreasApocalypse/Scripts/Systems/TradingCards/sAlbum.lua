local albumCards = {}

for itemId = 211, 240 do
    albumCards[#albumCards + 1] = {
        id = itemId,
        image = "Files/Images/Cards/" .. itemId .. ".png"
    }
end

local function isValidPlayer(player)
    return isElement(player) and getElementType(player) == "player"
end

local function getPlayerCardAmount(player, cardId)
    local amount = hasPlayerItem(player, cardId)

    if type(amount) == "boolean" then
        return amount and 1 or 0
    end

    return math.max(0, tonumber(amount) or 0)
end

local function getTradingCardAlbumItemAmounts(player)
    local amounts = {}

    for _, card in ipairs(albumCards) do
        amounts[tostring(card.id)] = getPlayerCardAmount(player, card.id)
    end

    return amounts
end

local function isTradingCardAlbumFull(itemAmounts)
    for _, card in ipairs(albumCards) do
        if (tonumber(itemAmounts[tostring(card.id)]) or 0) < 1 then
            return false
        end
    end

    return true
end

local function getLocalizedAlbumCards(player)
    local cards = {}

    for _, card in ipairs(albumCards) do
        cards[#cards + 1] = {
            id = card.id,
            name = getText(player, "CTradingAlbumCardName"):format(card.id),
            image = card.image
        }
    end

    return cards
end

local function sendTradingCardAlbumInfobox(player, textName, ...)
    if not isValidPlayer(player) then
        return
    end

    local text = getText(player, textName)

    if select("#", ...) > 0 then
        text = text:format(...)
    end

    triggerClientEvent(
        player,
        "clientTradingCardAlbumInfobox",
        player,
        text
    )
end

local function sendTradingCardAlbumToPlayer(player)
    if not isValidPlayer(player) then
        return
    end

    local itemAmounts = getTradingCardAlbumItemAmounts(player)

    triggerClientEvent(
        player,
        "clientReceiveTradingCardAlbum",
        player,
        getLocalizedAlbumCards(player),
        itemAmounts,
        isTradingCardAlbumFull(itemAmounts)
    )
end

local function removeOneAlbumCard(player, cardId)
    local success, result = pcall(takeItem, player, cardId)

    if not success then
        outputDebugString(
            "[TradingCardAlbum] takeItem Fehler bei Item "
                .. tostring(cardId)
                .. ": "
                .. tostring(result),
            1
        )

        return false
    end

    if result == false then
        return false
    end

    return true
end

local function takeOneOfEveryAlbumCard(player)
    local amounts = getTradingCardAlbumItemAmounts(player)

    if not isTradingCardAlbumFull(amounts) then
        return false, "missing"
    end

    for _, card in ipairs(albumCards) do
        if not removeOneAlbumCard(player, card.id) then
            return false, card.id
        end
    end

    return true
end

local function giveTradingCardAlbumReward(player)
	local cardBonus = getPlayerData("accounts","ID",apocalypseGetElementData(player,"AccountID"),"card_bonus")
	dbExec(handler,"UPDATE accounts SET card_bonus = '"..cardBonus + 1 .."' WHERE ID = '"..apocalypseGetElementData(player,"AccountID").."'")
	createInfobox(player,getText(player,"SCardBonus2"))
    return true
end

function openTradingCardAlbum(player)
    if not isValidPlayer(player) then
        return
    end

    sendTradingCardAlbumToPlayer(player)
end

function redeemTradingCardAlbum(player)
    if not isValidPlayer(player) then
        return
    end
	
	local cardBonus = getPlayerData("accounts","ID",apocalypseGetElementData(player,"AccountID"),"card_bonus")
	if(tonumber(cardBonus) >= 5)then
		createInfobox(player,getText(player,"SCardBonus1"))
		return
	end

    local itemAmounts = getTradingCardAlbumItemAmounts(player)

    if not isTradingCardAlbumFull(itemAmounts) then
        sendTradingCardAlbumInfobox(
            player,
            "CTradingAlbumNotFull"
        )
        return
    end

    local removed, failedCardId =
        takeOneOfEveryAlbumCard(player)

    if not removed then
        if failedCardId == "missing" then
            sendTradingCardAlbumInfobox(
                player,
                "CTradingAlbumNotFull"
            )
        else
            sendTradingCardAlbumInfobox(
                player,
                "CTradingAlbumRemoveError",
                tostring(failedCardId)
            )
        end

        sendTradingCardAlbumToPlayer(player)
        return
    end

    if not giveTradingCardAlbumReward(player) then
        sendTradingCardAlbumInfobox(
            player,
            "CTradingAlbumRewardError"
        )

        sendTradingCardAlbumToPlayer(player)
        return
    end

    sendTradingCardAlbumInfobox(
        player,
        "CTradingAlbumRedeemed"
    )

    sendTradingCardAlbumToPlayer(player)
end

addEvent("serverOpenTradingCardAlbum", true)
addEventHandler("serverOpenTradingCardAlbum", root, function()
    if client ~= source then
        return
    end

    openTradingCardAlbum(client)
end)

addEvent("serverRedeemTradingCardAlbum", true)
addEventHandler("serverRedeemTradingCardAlbum", root, function()
    if client ~= source then
        return
    end

    redeemTradingCardAlbum(client)
end)