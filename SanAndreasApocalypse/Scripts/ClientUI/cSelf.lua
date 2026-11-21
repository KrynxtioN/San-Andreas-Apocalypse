Selfmenu = {
    Images = {
        {name = "PlayerInformations", status = "normal"},
        {name = "Awards", status = "normal"},
        {name = "Vehicles", status = "normal"},
        {name = "Friendlist", status = "normal"},
        {name = "Close", status = "normal"},
    },
    selected = 1,
    anim = {
        visible = false,
        startTick = 0,
        duration = 400,
        alpha = 0,
        posX = 0,
        scale = 0.8,
    },
}

local screenWidth, screenHeight = guiGetScreenSize()

local function tween(start, ziel, elapsed, duration)
    local progress = math.min(elapsed / duration, 1)
    return start + (ziel - start) * progress
end

function Selfmenu.open()
    if not isCharacterLoggedIn() or not isWindowOpen() then return end

    Selfmenu.selected = 1
    Selfmenu.anim.visible = true
    Selfmenu.anim.startTick = getTickCount()
    Selfmenu.anim.alpha = 0
    Selfmenu.anim.scale = 0.8
    Selfmenu.anim.posX = -500
    addEventHandler("onClientRender", root, Selfmenu.render)
    bindKey("backspace", "down", Selfmenu.close)
    bindKey("arrow_l", "down", Selfmenu.selectLeft)
    bindKey("arrow_r", "down", Selfmenu.selectRight)
	Selfmenu.loadWindow()
end

function Selfmenu.close()
    removeEventHandler("onClientRender", root, Selfmenu.render)
    unbindKey("backspace", "down", Selfmenu.close)
    unbindKey("arrow_l", "down", Selfmenu.selectLeft)
    unbindKey("arrow_r", "down", Selfmenu.selectRight)
	closeWindow()
end

function Selfmenu.render()
    local now = getTickCount()
    local elapsed = now - Selfmenu.anim.startTick

    local currentAlpha = tween(0, 220, elapsed, Selfmenu.anim.duration)
    local currentScale = tween(0.8, 1.0, elapsed, Selfmenu.anim.duration)
    local currentX = tween(-500, (screenWidth - 500) / 2, elapsed, Selfmenu.anim.duration)

    local menuW, menuH = 500 * currentScale, 120 * currentScale
    local menuY = screenHeight * 0.15
    dxDrawRectangle(currentX, menuY, menuW, menuH, tocolor(30, 30, 30, currentAlpha), false)
    dxDrawLine(currentX, menuY + menuH, currentX + menuW, menuY + menuH, tocolor(255,255,255,currentAlpha), 2, false)

    local title = getText("CMe24")
    dxDrawText(title, currentX, menuY - 35 * currentScale, currentX + menuW, menuY - 5 * currentScale, tocolor(0, 255, 0, currentAlpha),
        1.2 * currentScale, "default-bold", "center", "center", false, false)
    dxDrawText(title, currentX + 2, menuY - 33 * currentScale, currentX + menuW + 2, menuY - 3 * currentScale, tocolor(0, 0, 0, currentAlpha),
        1.2 * currentScale, "default-bold", "center", "center", false, false)

    local iconSize = 70 * currentScale
    local spacing = 20 * currentScale
    local startX = currentX + spacing
    local centerY = menuY + (menuH - iconSize) / 2

    for i, item in ipairs(Selfmenu.Images) do
        local iconX = startX + (i-1) * (iconSize + spacing)
        local iconY = centerY

        local bounce = 0
        if i == Selfmenu.selected then
            bounce = math.sin((now % 1000) / 1000 * 2 * math.pi) * 8
        end

        local imageStatus = (i == Selfmenu.selected) and "colored" or "grey"
        local imagePath = "Files/Images/Selfmenue/" .. item.name .. imageStatus .. ".png"
        dxDrawImage(iconX, iconY + bounce, iconSize, iconSize, imagePath, 0, 0, 0, tocolor(255, 255, 255, currentAlpha), false)
    end
end

function Selfmenu.selectLeft()
    if Selfmenu.selected > 1 then
        Selfmenu.selected = Selfmenu.selected - 1
		Selfmenu.loadWindow()
    end
end

function Selfmenu.selectRight()
    if Selfmenu.selected < #Selfmenu.Images then
        Selfmenu.selected = Selfmenu.selected + 1
		Selfmenu.loadWindow()
    end
end

function Selfmenu.loadWindow()
	if(isElement(GUIEditor.window[1]))then destroyElement(GUIEditor.window[1]) end
	if(Selfmenu.selected == 1)then
        GUIEditor.window[1] = guiCreateWindow(871, 331, 249, 312, getText("CMe9"), false)
        setWindowData("false")
				
		local playtime = formatMinutes(apocalypseGetElementData(localPlayer,"playtime") or 0)
		local level = apocalypseGetElementData(localPlayer,"level") or 0
		local colony = apocalypseGetElementData(localPlayer,"ColonyName") or "/"
		local rank = apocalypseGetElementData(localPlayer,"rankname") or "/"
		local weekTime = formatMinutes(apocalypseGetElementData(localPlayer,"WeekTime") or 0)
		local weekTimeAFK = formatMinutes(apocalypseGetElementData(localPlayer,"WeekTimeAFK") or 0)
		local survivorPassLevel = apocalypseGetElementData(localPlayer,"survivorpass_level") or 0

        GUIEditor.label[1] = guiCreateLabel(10, 30, 229, 24, getText("CMe1"):format(playtime), false, GUIEditor.window[1])
        guiLabelSetVerticalAlign(GUIEditor.label[1], "center")
        GUIEditor.label[2] = guiCreateLabel(10, 64, 229, 34, getText("CMe2"):format(weekTime,weekTimeAFK), false, GUIEditor.window[1])
        guiLabelSetHorizontalAlign(GUIEditor.label[2], "left", true)
        guiLabelSetVerticalAlign(GUIEditor.label[2], "center")
        GUIEditor.label[3] = guiCreateLabel(10, 108, 229, 24, getText("CMe3"):format(level), false, GUIEditor.window[1])
        guiLabelSetVerticalAlign(GUIEditor.label[3], "center")
        GUIEditor.label[4] = guiCreateLabel(10, 142, 229, 24, getText("CMe4"):format(survivorPassLevel), false, GUIEditor.window[1])
        guiLabelSetVerticalAlign(GUIEditor.label[4], "center")
        GUIEditor.label[5] = guiCreateLabel(10, 176, 229, 24, getText("CMe5"):format(colony), false, GUIEditor.window[1])
        guiLabelSetVerticalAlign(GUIEditor.label[5], "center")
        --[[GUIEditor.label[6] = guiCreateLabel(10, 210, 229, 24, "Warns: 0", false, GUIEditor.window[1])
        guiLabelSetVerticalAlign(GUIEditor.label[6], "center")
        GUIEditor.label[7] = guiCreateLabel(10, 244, 229, 24, "Administrative Einträge: 5", false, GUIEditor.window[1])
        guiLabelSetVerticalAlign(GUIEditor.label[7], "center")
        GUIEditor.label[8] = guiCreateLabel(10, 278, 229, 24, "????", false, GUIEditor.window[1])
        guiLabelSetVerticalAlign(GUIEditor.label[8], "center")  ]]--
	elseif(Selfmenu.selected == 2)then
        GUIEditor.window[1] = guiCreateWindow(218, 376, 384, 328, getText("CMe10"), false)
        setWindowData("false")

        GUIEditor.gridlist[1] = guiCreateGridList(10, 29, 364, 174, false, GUIEditor.window[1])
        trophy_grid = guiGridListAddColumn(GUIEditor.gridlist[1], getText("CMe16"), 0.9)
        GUIEditor.label[1] = guiCreateLabel(10, 213, 364, 73, "", false, GUIEditor.window[1])
        GUIEditor.button[1] = guiCreateButton(10, 294, 364, 24, getText("CMe12"), false, GUIEditor.window[1])    
		
		triggerServerEvent("Selfmenu.getTrophyData",localPlayer)
		
		addEventHandler("onClientGUIClick",GUIEditor.button[1],function()
            local row = guiGridListGetSelectedItem(GUIEditor.gridlist[1])
            if row ~= -1 then
                local ID = guiGridListGetItemData(GUIEditor.gridlist[1], row, trophy_grid)
				triggerServerEvent("TrophyHouse.takeBonus",localPlayer,ID)
            end
		end,false)
		
		addEventHandler("onClientGUIClick",GUIEditor.gridlist[1],function()
            local row = guiGridListGetSelectedItem(GUIEditor.gridlist[1])
            if row ~= -1 then
                local ID = guiGridListGetItemData(GUIEditor.gridlist[1], row, trophy_grid)
				guiSetText(GUIEditor.label[1],getText("CSelfmenu1"):format(TrophyHouse["Bonus"][ID].money,TrophyHouse["Bonus"][ID].experiencePoints,TrophyHouse["Bonus"][ID].resetTimer/3600))
            end
		end)
	elseif(Selfmenu.selected == 3)then
        GUIEditor.window[1] = guiCreateWindow(218, 376, 384, 328, getText("CMe13"), false)
        setWindowData("false")

        GUIEditor.gridlist[1] = guiCreateGridList(10, 29, 364, 174, false, GUIEditor.window[1])
        vehicle_grid = guiGridListAddColumn(GUIEditor.gridlist[1], getText("CMe17"), 0.9)
        GUIEditor.label[1] = guiCreateLabel(10, 213, 364, 73, getText("CMe14"), false, GUIEditor.window[1])
        guiSetFont(GUIEditor.label[1], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[1], "left", true)  
        GUIEditor.button[1] = guiCreateButton(10, 294, 364, 24, getText("CMe15"), false, GUIEditor.window[1]) 

		triggerServerEvent("Selfmenu.getVehicleData",localPlayer)
		
		addEventHandler("onClientGUIClick",GUIEditor.button[1],function()
            local row = guiGridListGetSelectedItem(GUIEditor.gridlist[1])
            if row ~= -1 then
                local databaseID = guiGridListGetItemData(GUIEditor.gridlist[1], row, vehicle_grid)
				triggerServerEvent("Selfmenu.giveVehicle",localPlayer,databaseID)
            end
		end,false)
	elseif(Selfmenu.selected == 4)then
        GUIEditor.window[1] = guiCreateWindow(215, 533, 560, 376, getText("CMe18"), false)
        setWindowData("false")

        GUIEditor.gridlist[1] = guiCreateGridList(10, 29, 223, 337, false, GUIEditor.window[1])
        friendgrid = guiGridListAddColumn(GUIEditor.gridlist[1], getText("CMe19"), 0.9)
        GUIEditor.label[1] = guiCreateLabel(242, 29, 56, 28, getText("CMe20"), false, GUIEditor.window[1])
        guiLabelSetHorizontalAlign(GUIEditor.label[1], "center", false)
        guiLabelSetVerticalAlign(GUIEditor.label[1], "center")
        GUIEditor.edit[1] = guiCreateEdit(308, 29, 242, 28, "", false, GUIEditor.window[1])
        GUIEditor.button[1] = guiCreateButton(242, 101, 308, 23, getText("CMe21"), false, GUIEditor.window[1])
        GUIEditor.button[2] = guiCreateButton(242, 67, 308, 23, getText("CMe22"), false, GUIEditor.window[1])
        GUIEditor.label[2] = guiCreateLabel(242, 134, 308, 232, "", false, GUIEditor.window[1])
        guiLabelSetHorizontalAlign(GUIEditor.label[2], "left", true)
		
		triggerServerEvent("Friends.getData",localPlayer)
		
		addEventHandler("onClientGUIClick",GUIEditor.button[1],function()
			local clicked = guiGridListGetItemText(GUIEditor.gridlist[1],  guiGridListGetSelectedItem(GUIEditor.gridlist[1]), 1)
			if(clicked ~= "")then
				triggerServerEvent("removeFriend",localPlayer,clicked)
			end
		end,false)
		
		addEventHandler("onClientGUIClick",GUIEditor.button[2],function()
			local name = guiGetText(GUIEditor.edit[1])
			if(#name >= 1)then
				triggerServerEvent("addFriend",localPlayer,name)
			end
		end,false)
	elseif(Selfmenu.selected == 5)then
		Selfmenu.close()
	end
end

addEvent("Self.updateFriends",true)
addEventHandler("Self.updateFriends",root,function(friends)
	guiGridListClear(GUIEditor.gridlist[1])
	if(#friends >= 1)then
		for _,v in pairs(friends)do
			local row = guiGridListAddRow(GUIEditor.gridlist[1])
			guiGridListSetItemText(GUIEditor.gridlist[1], row, friendgrid, v, false, false)
		end
	end
end)

addEvent("Selfmenu.setVehicleData",true)
addEventHandler("Selfmenu.setVehicleData",root,function(vehicles)
	guiGridListClear(GUIEditor.gridlist[1])
	if(#vehicles >= 1)then
		for _,v in pairs(vehicles)do
			local row = guiGridListAddRow(GUIEditor.gridlist[1])
			guiGridListSetItemText(GUIEditor.gridlist[1], row, vehicle_grid, getVehicleNameFromModel(v[2]), false, false)
			guiGridListSetItemData(GUIEditor.gridlist[1], row, vehicle_grid, v[1])
		end
	end
end)

addEvent("Selfmenu.setTrophyData",true)
addEventHandler("Selfmenu.setTrophyData",root,function(data)
	guiGridListClear(GUIEditor.gridlist[1])
	if(#data >= 1)then
		for _,v in pairs(data)do
			local row = guiGridListAddRow(GUIEditor.gridlist[1])
			guiGridListSetItemText(GUIEditor.gridlist[1], row, trophy_grid, v[2], false, false)
			guiGridListSetItemData(GUIEditor.gridlist[1], row, trophy_grid, v[1])
		end
	end
end)

addCommandHandler("me", function()
   Selfmenu.open()
end)

addEventHandler("onClientPlayerWasted",root,function()
	if(source == localPlayer)then
		Selfmenu.close()
	end
end)