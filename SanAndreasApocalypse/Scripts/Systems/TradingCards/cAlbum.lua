local sx, sy = guiGetScreenSize()

local albumVisible = false
local albumCards = {}
local albumItemAmounts = {}
local albumFull = false
local cardTextures = {}

local scrollOffset = 0
local maxScrollOffset = 0
local albumGridRenderTarget = nil

local serverR, serverG, serverB = 220, 25, 25

local AlbumPickup = createPickup(
    487.65490722656,
    -77.893882751465,
    998.7578125,
    3,
    1239,
    50
)

setElementInterior(AlbumPickup, 11)

local function getTradingAlbumText(textName, ...)
    local text = getText(textName)

    if select("#", ...) > 0 then
        text = text:format(...)
    end

    return text
end

addEventHandler("onClientRender", root, function()
    if isCharacterLoggedIn() and isWindowOpen() then
        local x, y, z = getElementPosition(AlbumPickup)
        local screenX, screenY = getScreenFromWorldPosition(x, y, z)

        if screenX and screenY then
            if tonumber(apocalypseGetElementData(localPlayer, "level")) then
                if getDistanceBetweenPoints3D(
                    x,
                    y,
                    z,
                    getElementPosition(localPlayer)
                ) <= 5 then
                    dxDrawText(
                        getTradingAlbumText("CTradingAlbumPickup"),
                        screenX - 130,
                        screenY - 20,
                        screenX + 130,
                        screenY + 20,
                        tocolor(255, 255, 255),
                        1.2,
                        "default-bold",
                        "center",
                        "center"
                    )
                end
            end
        end
    end
end)

addEventHandler("onClientPickupHit", AlbumPickup, function(player)
    if player == localPlayer then
        if getElementDimension(player) == getElementDimension(source) then
            triggerServerEvent(
                "serverOpenTradingCardAlbum",
                localPlayer
            )
        end
    end
end)

function getTradingAlbumLayout()
    local windowW = 1050
    local windowH = 760
    local windowX = sx / 2 - windowW / 2
    local windowY = sy / 2 - windowH / 2

    local headerH = 95
    local infoH = 115
    local footerH = 95

    local gridX = windowX + 55
    local gridY = windowY + headerH + infoH + 22
    local gridW = windowW - 110
    local gridH = windowH - headerH - infoH - footerH - 55

    local cardW = 105
    local cardH = 145
    local gapX = 24
    local gapY = 34

    local cardsPerRow = math.floor(
        (gridW + gapX) / (cardW + gapX)
    )

    local totalW =
        cardsPerRow * cardW +
        (cardsPerRow - 1) * gapX

    local startX = (gridW - totalW) / 2

    return
        windowX,
        windowY,
        windowW,
        windowH,
        gridX,
        gridY,
        gridW,
        gridH,
        cardW,
        cardH,
        gapX,
        gapY,
        cardsPerRow,
        startX
end

function updateTradingCardAlbumScroll()
    local _, _, _, _, _, _, _, gridH, _, cardH, _, gapY, cardsPerRow =
        getTradingAlbumLayout()

    local rows = math.ceil(#albumCards / cardsPerRow)

    local contentH =
        rows * cardH +
        math.max(0, rows - 1) * gapY

    maxScrollOffset = math.max(0, contentH - gridH)
    scrollOffset = math.max(
        0,
        math.min(scrollOffset, maxScrollOffset)
    )
end

function createTradingCardAlbumRenderTarget()
    local _, _, _, _, _, _, gridW, gridH =
        getTradingAlbumLayout()

    if isElement(albumGridRenderTarget) then
        destroyElement(albumGridRenderTarget)
    end

    albumGridRenderTarget =
        dxCreateRenderTarget(gridW, gridH, true)
end

function loadTradingCardAlbumTextures()
    for _, card in ipairs(albumCards) do
        if
            card.image and
            not cardTextures[card.id] and
            fileExists(card.image)
        then
            local texture = dxCreateTexture(card.image)

            if texture then
                cardTextures[card.id] = texture
            end
        end
    end
end

function destroyTradingCardAlbumTextures()
    for _, texture in pairs(cardTextures) do
        if isElement(texture) then
            destroyElement(texture)
        end
    end

    cardTextures = {}
end

function openTradingCardAlbumInterface()
    if isWindowOpen() then
        if albumVisible then
            return
        end

        albumVisible = true
        showCursor(true)

        updateTradingCardAlbumScroll()
        createTradingCardAlbumRenderTarget()
        setWindowData()

        addEventHandler(
            "onClientRender",
            root,
            renderTradingCardAlbum
        )

        addEventHandler(
            "onClientClick",
            root,
            clickTradingCardAlbum
        )

        addEventHandler(
            "onClientKey",
            root,
            keyTradingCardAlbum
        )

        bindKey(
            "backspace",
            "down",
            closeTradingCardAlbumInterface
        )
    end
end

function closeTradingCardAlbumInterface()
    if not albumVisible then
        return
    end

    albumVisible = false
    showCursor(false)

    removeEventHandler(
        "onClientRender",
        root,
        renderTradingCardAlbum
    )

    removeEventHandler(
        "onClientClick",
        root,
        clickTradingCardAlbum
    )

    removeEventHandler(
        "onClientKey",
        root,
        keyTradingCardAlbum
    )

    unbindKey(
        "backspace",
        "down",
        closeTradingCardAlbumInterface
    )

    closeWindow()
    destroyTradingCardAlbumTextures()

    if isElement(albumGridRenderTarget) then
        destroyElement(albumGridRenderTarget)
        albumGridRenderTarget = nil
    end
end

function keyTradingCardAlbum(button, press)
    if not albumVisible or not press then
        return
    end

    if button == "mouse_wheel_down" then
        scrollOffset = math.min(
            scrollOffset + 45,
            maxScrollOffset
        )
    elseif button == "mouse_wheel_up" then
        scrollOffset = math.max(
            scrollOffset - 45,
            0
        )
    end
end

function drawTradingAlbumGridContent(
    gridW,
    gridH,
    cardW,
    cardH,
    gapX,
    gapY,
    cardsPerRow,
    startX
)
    for index, card in ipairs(albumCards) do
        local row = math.floor((index - 1) / cardsPerRow)
        local col = (index - 1) % cardsPerRow

        local x = startX + col * (cardW + gapX)
        local y = row * (cardH + gapY) - scrollOffset

        if y + cardH >= 0 and y <= gridH then
            local itemAmount =
                tonumber(
                    albumItemAmounts[tostring(card.id)]
                ) or 0

            local owned = itemAmount > 0

            local serverColor =
                tocolor(serverR, serverG, serverB, 255)

            local serverColorSoft =
                tocolor(serverR, serverG, serverB, 75)

            dxDrawRectangle(
                x - 4,
                y - 4,
                cardW + 8,
                cardH + 8,
                owned
                    and serverColor
                    or tocolor(50, 50, 50, 255)
            )

            dxDrawRectangle(
                x - 2,
                y - 2,
                cardW + 4,
                cardH + 4,
                tocolor(5, 5, 5, 255)
            )

            if owned then
                if isElement(cardTextures[card.id]) then
                    dxDrawImage(
                        x,
                        y,
                        cardW,
                        cardH,
                        cardTextures[card.id]
                    )
                else
                    dxDrawRectangle(
                        x,
                        y,
                        cardW,
                        cardH,
                        tocolor(35, 35, 35, 255)
                    )
                end

                -- Kartenanzahl immer sichtbar über dem Bild
                local amountBoxW = 54
                local amountBoxH = 42
                local amountBoxX = x + cardW / 2 - amountBoxW / 2
                local amountBoxY = y + cardH / 2 - amountBoxH / 2

                dxDrawRectangle(
                    amountBoxX,
                    amountBoxY,
                    amountBoxW,
                    amountBoxH,
                    tocolor(0, 0, 0, 205)
                )

                dxDrawText(
                    tostring(itemAmount),
                    amountBoxX,
                    amountBoxY,
                    amountBoxX + amountBoxW,
                    amountBoxY + amountBoxH,
                    tocolor(255, 255, 255, 255),
                    1.65,
                    "default-bold",
                    "center",
                    "center"
                )

                dxDrawRectangle(
                    x,
                    y + cardH - 24,
                    cardW,
                    24,
                    tocolor(0, 0, 0, 190)
                )

                dxDrawText(
                    getTradingAlbumText(
                        "CTradingAlbumCardNumber",
                        card.id
                    ),
                    x,
                    y + cardH - 24,
                    x + cardW,
                    y + cardH,
                    tocolor(255, 255, 255, 245),
                    0.8,
                    "default-bold",
                    "center",
                    "center"
                )
            else
                dxDrawRectangle(
                    x,
                    y,
                    cardW,
                    cardH,
                    tocolor(18, 18, 18, 255)
                )

                dxDrawRectangle(
                    x + 8,
                    y + 8,
                    cardW - 16,
                    cardH - 16,
                    tocolor(30, 30, 30, 255)
                )

                dxDrawRectangle(
                    x + 13,
                    y + 13,
                    cardW - 26,
                    cardH - 26,
                    serverColorSoft
                )

                dxDrawText(
                    "0",
                    x,
                    y + 12,
                    x + cardW,
                    y + cardH - 24,
                    tocolor(110, 110, 110, 220),
                    2.4,
                    "default-bold",
                    "center",
                    "center"
                )

                dxDrawText(
                    getTradingAlbumText(
                        "CTradingAlbumCardNumber",
                        card.id
                    ),
                    x,
                    y + cardH - 25,
                    x + cardW,
                    y + cardH,
                    tocolor(185, 185, 185, 230),
                    0.8,
                    "default-bold",
                    "center",
                    "center"
                )
            end
        end
    end
end

function renderTradingCardAlbum()
    if not albumVisible then
        return
    end

    local
        windowX,
        windowY,
        windowW,
        windowH,
        gridX,
        gridY,
        gridW,
        gridH,
        cardW,
        cardH,
        gapX,
        gapY,
        cardsPerRow,
        startX =
        getTradingAlbumLayout()

    if not isElement(albumGridRenderTarget) then
        createTradingCardAlbumRenderTarget()
    end

    local serverColor =
        tocolor(serverR, serverG, serverB, 255)

    dxDrawRectangle(
        0,
        0,
        sx,
        sy,
        tocolor(0, 0, 0, 190)
    )

    dxDrawRectangle(
        windowX - 4,
        windowY - 4,
        windowW + 8,
        windowH + 8,
        serverColor
    )

    dxDrawRectangle(
        windowX,
        windowY,
        windowW,
        windowH,
        tocolor(10, 10, 10, 248)
    )

    dxDrawRectangle(
        windowX + 14,
        windowY + 14,
        windowW - 28,
        windowH - 28,
        tocolor(24, 24, 24, 248)
    )

    dxDrawRectangle(
        windowX + 28,
        windowY + 24,
        windowW - 56,
        72,
        tocolor(8, 8, 8, 245)
    )

    dxDrawText(
        getTradingAlbumText("CTradingAlbumTitle"),
        windowX,
        windowY + 25,
        windowX + windowW,
        windowY + 94,
        tocolor(255, 255, 255, 255),
        2,
        "default-bold",
        "center",
        "center"
    )

    local ownedCount = 0

    for _, card in ipairs(albumCards) do
        local amount =
            tonumber(
                albumItemAmounts[tostring(card.id)]
            ) or 0

        if amount > 0 then
            ownedCount = ownedCount + 1
        end
    end

    local progressText =
        getTradingAlbumText(
            "CTradingAlbumProgress",
            ownedCount,
            #albumCards
        )

    dxDrawText(
        progressText,
        windowX + windowW - 250,
        windowY + 43,
        windowX + windowW - 45,
        windowY + 76,
        serverColor,
        1.15,
        "default-bold",
        "right",
        "center"
    )

    local infoX = windowX + 55
    local infoY = windowY + 112
    local infoW = windowW - 110
    local infoH = 108

    dxDrawRectangle(
        infoX,
        infoY,
        infoW,
        infoH,
        tocolor(14, 14, 14, 235)
    )

    dxDrawRectangle(
        infoX,
        infoY,
        infoW,
        2,
        tocolor(serverR, serverG, serverB, 210)
    )

    dxDrawText(
        getTradingAlbumText(
            "CTradingAlbumSystemInfoText"
        ),
        infoX + 18,
        infoY + 14,
        infoX + infoW - 18,
        infoY + infoH - 14,
        tocolor(220, 220, 220, 245),
        0.92,
        "default-bold",
        "left",
        "top",
        true,
        true
    )

    dxDrawRectangle(
        gridX - 12,
        gridY - 12,
        gridW + 24,
        gridH + 24,
        tocolor(12, 12, 12, 230)
    )

    dxSetRenderTarget(
        albumGridRenderTarget,
        true
    )

    drawTradingAlbumGridContent(
        gridW,
        gridH,
        cardW,
        cardH,
        gapX,
        gapY,
        cardsPerRow,
        startX
    )

    dxSetRenderTarget()

    dxDrawImage(
        gridX,
        gridY,
        gridW,
        gridH,
        albumGridRenderTarget
    )

    if maxScrollOffset > 0 then
        local barX = gridX + gridW + 16
        local barY = gridY
        local barW = 7
        local barH = gridH

        local thumbH = math.max(
            45,
            barH *
                (
                    gridH /
                    (gridH + maxScrollOffset)
                )
        )

        local thumbY =
            barY +
            (barH - thumbH) *
            (scrollOffset / maxScrollOffset)

        dxDrawRectangle(
            barX,
            barY,
            barW,
            barH,
            tocolor(45, 45, 45, 220)
        )

        dxDrawRectangle(
            barX,
            thumbY,
            barW,
            thumbH,
            serverColor
        )
    end

    local buttonW, buttonH = 250, 46
    local buttonSpacing = 20

    local redeemX =
        windowX +
        windowW / 2 -
        buttonW -
        buttonSpacing / 2

    local closeX =
        windowX +
        windowW / 2 +
        buttonSpacing / 2

    local redeemY = windowY + windowH - 70
    local closeY = redeemY

    dxDrawRectangle(
        redeemX - 2,
        redeemY - 2,
        buttonW + 4,
        buttonH + 4,
        albumFull
            and serverColor
            or tocolor(75, 75, 75, 255)
    )

    dxDrawRectangle(
        redeemX,
        redeemY,
        buttonW,
        buttonH,
        albumFull
            and tocolor(120, 10, 10, 245)
            or tocolor(35, 35, 35, 245)
    )

    dxDrawText(
        getTradingAlbumText(
            "CTradingAlbumRedeem"
        ),
        redeemX,
        redeemY,
        redeemX + buttonW,
        redeemY + buttonH,
        tocolor(255, 255, 255, 255),
        1.1,
        "default-bold",
        "center",
        "center"
    )

    dxDrawRectangle(
        closeX - 2,
        closeY - 2,
        buttonW + 4,
        buttonH + 4,
        tocolor(75, 75, 75, 255)
    )

    dxDrawRectangle(
        closeX,
        closeY,
        buttonW,
        buttonH,
        tocolor(35, 35, 35, 245)
    )

    dxDrawText(
        getTradingAlbumText(
            "CTradingAlbumCloseButton"
        ),
        closeX,
        closeY,
        closeX + buttonW,
        closeY + buttonH,
        tocolor(255, 255, 255, 255),
        1.1,
        "default-bold",
        "center",
        "center"
    )

    dxDrawText(
        getTradingAlbumText(
            "CTradingAlbumInfo"
        ),
        windowX + 40,
        windowY + windowH - 105,
        windowX + windowW - 40,
        windowY + windowH - 78,
        tocolor(220, 220, 220, 230),
        0.95,
        "default-bold",
        "center",
        "center"
    )
end

function clickTradingCardAlbum(
    button,
    state,
    cursorX,
    cursorY
)
    if button ~= "left" or state ~= "down" then
        return
    end

    if not albumVisible then
        return
    end

    local windowX, windowY, windowW, windowH =
        getTradingAlbumLayout()

    local buttonW, buttonH = 250, 46
    local buttonSpacing = 20

    local redeemX =
        windowX +
        windowW / 2 -
        buttonW -
        buttonSpacing / 2

    local closeX =
        windowX +
        windowW / 2 +
        buttonSpacing / 2

    local redeemY = windowY + windowH - 70
    local closeY = redeemY

    if
        cursorX >= redeemX and
        cursorX <= redeemX + buttonW and
        cursorY >= redeemY and
        cursorY <= redeemY + buttonH
    then
        triggerServerEvent(
            "serverRedeemTradingCardAlbum",
            localPlayer
        )
        return
    end

    if
        cursorX >= closeX and
        cursorX <= closeX + buttonW and
        cursorY >= closeY and
        cursorY <= closeY + buttonH
    then
        closeTradingCardAlbumInterface()
        return
    end
end

function receiveTradingCardAlbum(
    cards,
    itemAmounts,
    isFull
)
    albumCards = cards or {}
    albumItemAmounts = itemAmounts or {}
    albumFull = isFull == true
    scrollOffset = 0

    destroyTradingCardAlbumTextures()
    loadTradingCardAlbumTextures()
    updateTradingCardAlbumScroll()

    if albumVisible then
        createTradingCardAlbumRenderTarget()
    else
        openTradingCardAlbumInterface()
    end
end

function receiveTradingCardAlbumMessage(message)
    outputChatBox(message, 255, 255, 255)
end

function receiveTradingCardAlbumInfobox(message)
    if type(createInfobox) == "function" then
        createInfobox(message)
    else
        outputChatBox(message, 255, 255, 255)
    end
end

function recreateTradingCardAlbumRenderTarget()
    if albumVisible then
        createTradingCardAlbumRenderTarget()
    end
end

addEventHandler(
    "onClientRestore",
    root,
    recreateTradingCardAlbumRenderTarget
)

addEvent(
    "clientReceiveTradingCardAlbum",
    true
)

addEventHandler(
    "clientReceiveTradingCardAlbum",
    root,
    receiveTradingCardAlbum
)

addEvent(
    "clientTradingCardAlbumMessage",
    true
)

addEventHandler(
    "clientTradingCardAlbumMessage",
    root,
    receiveTradingCardAlbumMessage
)


addEvent(
    "clientTradingCardAlbumInfobox",
    true
)

addEventHandler(
    "clientTradingCardAlbumInfobox",
    root,
    receiveTradingCardAlbumInfobox
)