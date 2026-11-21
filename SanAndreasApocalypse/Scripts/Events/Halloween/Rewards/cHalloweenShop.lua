HalloweenShop = {
    ["Items"] = {
        ["DE"] = {
            {key = "totemBlips", name = "Totem Standorte", cost = 100},
            {key = "totem", name = "Totem", cost = 10},
            {key = "pumpkinSeed", name = "Kürbissamen", cost = 1},
            {key = "vehicleSlot", name = "Fahrzeugslot", cost = 1250},

            {key = "vehicle", name = "Fahrzeug: Voodoo", cost = 15000, model = 539},
            {key = "vehicle", name = "Fahrzeug: Hotknife", cost = 20000, model = 434},
            {key = "vehicle", name = "Fahrzeug: Slamvan", cost = 20000, model = 535},
            {key = "vehicle", name = "Fahrzeug: Taxi", cost = 20000, model = 420},
            {key = "vehicle", name = "Fahrzeug: BF Injection", cost = 20000, model = 424},
            {key = "vehicle", name = "Fahrzeug: Bloodring Banger", cost = 20000, model = 504},
            {key = "vehicle", name = "Fahrzeug: Sandking", cost = 25000, model = 495},
            {key = "vehicle", name = "Fahrzeug: Monster Truck", cost = 25000, model = 444},
        },
        ["EN"] = {
            {key = "totemBlips", name = "Totem Locations", cost = 100},
            {key = "totem", name = "Totem", cost = 10},
            {key = "pumpkinSeed", name = "Pumpkin Seed", cost = 1},
            {key = "vehicleSlot", name = "Vehicle Slot", cost = 1250},

            {key = "vehicle", name = "Vehicle: Voodoo", cost = 15000, model = 539},
            {key = "vehicle", name = "Vehicle: Hotknife", cost = 20000, model = 434},
            {key = "vehicle", name = "Vehicle: Slamvan", cost = 20000, model = 535},
            {key = "vehicle", name = "Vehicle: Taxi", cost = 20000, model = 420},
            {key = "vehicle", name = "Vehicle: BF Injection", cost = 20000, model = 424},
            {key = "vehicle", name = "Vehicle: Bloodring Banger", cost = 20000, model = 504},
            {key = "vehicle", name = "Vehicle: Sandking", cost = 25000, model = 495},
            {key = "vehicle", name = "Vehicle: Monster Truck", cost = 25000, model = 444},
        },
		["RU"] = {
			{key = "totemBlips", name = "Места тотемов", cost = 100},
			{key = "totem", name = "Тотем", cost = 10},
			{key = "pumpkinSeed", name = "Семена тыквы", cost = 1},
			{key = "vehicleSlot", name = "Слот для транспорта", cost = 1250},

			{key = "vehicle", name = "Транспорт: Voodoo", cost = 15000, model = 539},
			{key = "vehicle", name = "Транспорт: Hotknife", cost = 20000, model = 434},
			{key = "vehicle", name = "Транспорт: Slamvan", cost = 20000, model = 535},
			{key = "vehicle", name = "Транспорт: Taxi", cost = 20000, model = 420},
			{key = "vehicle", name = "Транспорт: BF Injection", cost = 20000, model = 424},
			{key = "vehicle", name = "Транспорт: Bloodring Banger", cost = 20000, model = 504},
			{key = "vehicle", name = "Транспорт: Sandking", cost = 25000, model = 495},
			{key = "vehicle", name = "Транспорт: Monster Truck", cost = 25000, model = 444},
		},

		["PT"] = {
			{key = "totemBlips", name = "Localizações dos totens", cost = 100},
			{key = "totem", name = "Totem", cost = 10},
			{key = "pumpkinSeed", name = "Sementes de abóbora", cost = 1},
			{key = "vehicleSlot", name = "Vaga de veículo", cost = 1250},

			{key = "vehicle", name = "Veículo: Voodoo", cost = 15000, model = 539},
			{key = "vehicle", name = "Veículo: Hotknife", cost = 20000, model = 434},
			{key = "vehicle", name = "Veículo: Slamvan", cost = 20000, model = 535},
			{key = "vehicle", name = "Veículo: Taxi", cost = 20000, model = 420},
			{key = "vehicle", name = "Veículo: BF Injection", cost = 20000, model = 424},
			{key = "vehicle", name = "Veículo: Bloodring Banger", cost = 20000, model = 504},
			{key = "vehicle", name = "Veículo: Sandking", cost = 25000, model = 495},
			{key = "vehicle", name = "Veículo: Monster Truck", cost = 25000, model = 444},
		},
    },
}

local screenW, screenH = guiGetScreenSize()
local scrollOffset = 0
local lineHeight = 55
local maxVisibleItems = 5

local function isMouseInPosition(x, y, w, h)
    if not isCursorShowing() then return false end
    local cx, cy = getCursorPosition()
    cx, cy = cx * screenW, cy * screenH
    return (cx >= x and cx <= x + w and cy >= y and cy <= y + h)
end

function HalloweenShop.createWindow()
    setWindowData()
    showCursor(true)
    scrollOffset = 0

    addEventHandler("onClientRender", root, HalloweenShop.dxDraw)
    addEventHandler("onClientClick", root, HalloweenShop.Click)

    bindKey("mouse_wheel_up", "down", HalloweenShop.bindKeyUp)
    bindKey("mouse_wheel_down", "down", HalloweenShop.bindKeyDown)
end

function HalloweenShop.bindKeyUp()
	scrollOffset = math.max(scrollOffset - lineHeight, 0)
end

function HalloweenShop.bindKeyDown()
    local items = HalloweenShop["Items"][apocalypseGetElementData(localPlayer, "language") or "EN"]
    local maxScroll = math.max(0, (#items - maxVisibleItems) * lineHeight)
    scrollOffset = math.min(scrollOffset + lineHeight, maxScroll)
end

function HalloweenShop.closeWindow()
    closeWindow()
    removeEventHandler("onClientRender", root, HalloweenShop.dxDraw)
    removeEventHandler("onClientClick", root, HalloweenShop.Click)
    unbindKey("mouse_wheel_up", "down", HalloweenShop.bindKeyUp)
    unbindKey("mouse_wheel_down", "down", HalloweenShop.bindKeyDown)
end

function HalloweenShop.Click(button, state)
    if button == "left" and state == "up" then
        local w, h = 500, 350
        local x, y = (screenW - w) / 2, (screenH - h) / 2
        local startY = y + 60
        local items = HalloweenShop["Items"][apocalypseGetElementData(localPlayer, "language") or "EN"]

        local firstVisible = math.floor(scrollOffset / lineHeight) + 1
        local lastVisible = math.min(firstVisible + maxVisibleItems - 1, #items)

        for i = firstVisible, lastVisible do
            local item = items[i]
            local qY = startY + (i - firstVisible) * lineHeight
            if isMouseInPosition(x + w - 130, qY, 100, 25) then
                local model = item.model or 0
                triggerServerEvent("HalloweenShop.buy", localPlayer, item.key, item.cost, model)
            end
        end

        if isMouseInPosition(x + w - 35, y + 5, 30, 30) then
            HalloweenShop.closeWindow()
        end
    end
end

function HalloweenShop.dxDraw()
    local w, h = 500, 350
    local x, y = (screenW - w) / 2, (screenH - h) / 2
    dxDrawRectangle(x, y, w, h, tocolor(20, 20, 20, 220), true)
    dxDrawText(getText("CHalloweenShop1"), x, y, x + w, y + 40, tocolor(255, 140, 0, 255), 1.3, "default-bold", "center", "center", true, false, true)
	dxDrawText(getText("CHalloweenShop5"), x, y + 40, x + w, y + 60, tocolor(200, 200, 200, 255), 1, "default", "center", "top", true, false, true)

    local startY = y + 60
    local items = HalloweenShop["Items"][apocalypseGetElementData(localPlayer, "language") or "EN"]
    local firstVisible = math.floor(scrollOffset / lineHeight) + 1
    local lastVisible = math.min(firstVisible + maxVisibleItems - 1, #items)

    for i = firstVisible, lastVisible do
        local item = items[i]
        local qY = startY + (i - firstVisible) * lineHeight
        dxDrawText(item.name, x + 10, qY, x + w - 150, qY + 20, tocolor(255, 255, 255, 255), 1, "default-bold", "left", "top", true, false, true)
        dxDrawText(item.cost .. " " .. getText("CHalloweenShop2"), x + 10, qY + 20, x + w - 150, qY + 40, tocolor(200, 200, 200, 255), 1, "default", "left", "top", true, false, true)

        dxDrawRectangle(x + w - 130, qY, 100, 25, tocolor(80, 40, 0, 220), true)
        dxDrawText(getText("CHalloweenShop3"), x + w - 130, qY, x + w - 30, qY + 25, tocolor(255, 200, 0, 255), 1, "default-bold", "center", "center", true, false, true)
    end

    dxDrawRectangle(x + w - 35, y + 5, 30, 30, tocolor(200, 50, 50, 220), true)
    dxDrawText("X", x + w - 35, y + 5, x + w - 5, y + 35, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "center", true, false, true)
end