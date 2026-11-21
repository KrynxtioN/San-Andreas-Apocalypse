local sx, sy = guiGetScreenSize()

local packPath = "Files/Images/TradingCardPack.png"

local rarityColors = {
    COMMON = tocolor(220, 220, 220, 255),
    RARE = tocolor(80, 150, 255, 255),
    EPIC = tocolor(170, 80, 255, 255),
    LEGENDARY = tocolor(255, 170, 40, 255)
}

local cardPack = {
    active = false,
    opening = false,
    opened = false,
    startTick = 0,
    animTime = 1800,
    selectedCard = nil,
    selectedTexture = nil,
    packTexture = nil
}

function drawTradingCardPackPlaceholder(x, y, w, h, alpha)
    dxDrawRectangle(x, y, w, h, tocolor(25, 25, 25, alpha))
    dxDrawRectangle(x + 6, y + 6, w - 12, h - 12, tocolor(90, 60, 35, alpha))
    dxDrawText(getText("CTradingCard1"), x, y, x + w, y + h, tocolor(255,255,255,alpha), 1.5, "default-bold", "center", "center")
end

function drawTradingCardPlaceholder(x, y, w, h, card)
    dxDrawRectangle(x, y, w, h, tocolor(35, 35, 35, 255))
    dxDrawRectangle(x + 8, y + 8, w - 16, h - 16, tocolor(70, 70, 70, 255))
    dxDrawText(card.name or getText("CTradingCard2"), x, y, x + w, y + h, tocolor(255,255,255,255), 1.4, "default-bold", "center", "center")
end

function renderTradingCardPackOpening()
    if not cardPack.active then return end

    local cx, cy = sx / 2, sy / 2
    dxDrawRectangle(0, 0, sx, sy, tocolor(0, 0, 0, 175))

    if cardPack.opening then
        local progress = math.min((getTickCount() - cardPack.startTick) / cardPack.animTime, 1)

        local shake = math.sin(getTickCount() / 35) * 10 * (1 - progress)
        local scale = 1 + progress * 0.25
        local alpha = 255 * (1 - progress)

        local pw, ph = 320 * scale, 460 * scale
        local px, py = cx - pw / 2 + shake, cy - ph / 2

        if isElement(cardPack.packTexture) then
            dxDrawImage(px, py, pw, ph, cardPack.packTexture, 0, 0, 0, tocolor(255,255,255,alpha))
        else
            drawTradingCardPackPlaceholder(px, py, pw, ph, alpha)
        end

        dxDrawText(getText("CTradingCard3"), 0, cy + 270, sx, sy, tocolor(255,255,255,230), 1.25, "default-bold", "center")

        if progress >= 1 then
            cardPack.opening = false
            cardPack.opened = true
        end

        return
    end

    if cardPack.opened and cardPack.selectedCard then
        local cw, ch = 300, 420
        local x, y = cx - cw / 2, cy - ch / 2

        local rarity = cardPack.selectedCard.rarity or "COMMON"
        local rarityColor = rarityColors[rarity] or tocolor(255,255,255,255)

        dxDrawText(getText("CTradingCardRarity_" .. rarity), x, y - 55, x + cw, y, rarityColor, 1.6, "default-bold", "center")

        if isElement(cardPack.selectedTexture) then
            dxDrawImage(x, y, cw, ch, cardPack.selectedTexture)
        else
            drawTradingCardPlaceholder(x, y, cw, ch, cardPack.selectedCard)
        end

        dxDrawText(cardPack.selectedCard.name or getText("CTradingCard2"), 0, cy + ch / 2 + 20, sx, sy, tocolor(255,255,255,235), 1.2, "default-bold", "center")
        dxDrawText(getText("CTradingCard4"), 0, cy + ch / 2 + 55, sx, sy, tocolor(200,200,200,220), 1, "default-bold", "center")
    end
end

function closeTradingCardPackOpening()
    if not cardPack.active then return end

    removeEventHandler("onClientRender", root, renderTradingCardPackOpening)
    unbindKey("backspace", "down", closeTradingCardPackOpening)

    if isElement(cardPack.selectedTexture) then
        destroyElement(cardPack.selectedTexture)
    end

    if isElement(cardPack.packTexture) then
        destroyElement(cardPack.packTexture)
    end

    cardPack.active = false
    cardPack.opening = false
    cardPack.opened = false
    cardPack.startTick = 0
    cardPack.selectedCard = nil
    cardPack.selectedTexture = nil
    cardPack.packTexture = nil
	
	Inventory.close()
end

function startTradingCardPackOpening(cardData)
    if cardPack.active then return false end
    if type(cardData) ~= "table" then return false end

    cardPack.selectedCard = cardData
    cardPack.packTexture = dxCreateTexture(packPath)
    cardPack.selectedTexture = nil

    if cardData.image then
        cardPack.selectedTexture = dxCreateTexture(cardData.image)
    end

    cardPack.active = true
    cardPack.opening = true
    cardPack.opened = false
    cardPack.startTick = getTickCount()

    removeEventHandler("onClientRender", root, renderTradingCardPackOpening)
    addEventHandler("onClientRender", root, renderTradingCardPackOpening)

    unbindKey("backspace", "down", closeTradingCardPackOpening)
    bindKey("backspace", "down", closeTradingCardPackOpening)

    return true
end

function handleTradingCardPackOpeningEvent(cardData)
    startTradingCardPackOpening(cardData)
end

addEvent("clientStartTradingCardPackOpening", true)
addEventHandler("clientStartTradingCardPackOpening", root, handleTradingCardPackOpeningEvent)