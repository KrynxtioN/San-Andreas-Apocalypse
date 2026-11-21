SurvivorPass = {}

SurvivorPass.Overlay = {
    visible = true,
    data = {}
}

SurvivorPass.AboPickup = createPickup(2337.2395019531,-1066.6362304688,1049.0310058594,3,1239,50)
setElementInterior(SurvivorPass.AboPickup,6)

addEventHandler("onClientPickupHit",SurvivorPass.AboPickup,function(player)
	if localPlayer == player then
		if getElementDimension(localPlayer) == getElementDimension(source) then
			triggerServerEvent("SurvivorPass.AboOpen",localPlayer)
		end
	end
end)

addEvent("SurvivorPass.openAboWindow",true)
addEventHandler("SurvivorPass.openAboWindow",root,function(status)
	if isWindowOpen() then
        GUIEditor.window[1] = guiCreateWindow(588, 347, 500, 202, getText("CSurvivorPass25"), false)
        setWindowData()
		guiCreateCloseButton()
		
		if status == 1 then
			GUIEditor.button[1] = guiCreateButton(10, 155, 480, 37, getText("CSurvivorPass27"), false, GUIEditor.window[1])
		else
			GUIEditor.button[1] = guiCreateButton(10, 155, 480, 37, getText("CSurvivorPass28"), false, GUIEditor.window[1])
		end

        GUIEditor.label[1] = guiCreateLabel(10, 29, 480, 115, getText("CSurvivorPass26"), false, GUIEditor.window[1])
        guiSetFont(GUIEditor.label[1], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[1], "center", true)
        guiLabelSetVerticalAlign(GUIEditor.label[1], "center")
		
		addEventHandler("onClientGUIClick",GUIEditor.button[1],function()
			triggerServerEvent("SurvivorPass.Abo",localPlayer)
		end,false)

        triggerServerEvent("SurvivorPass.requestOverlayData", localPlayer)
	end
end)

addEventHandler("onClientRender", root, function()
    if not isCharacterLoggedIn() then return end

    local x1, y1, z1 = getElementPosition(SurvivorPass.AboPickup)
    local screenX1, screenY1 = getScreenFromWorldPosition(x1, y1, z1)

    if screenX1 and screenY1 and getDistanceBetweenPoints3D(x1, y1, z1, getElementPosition(localPlayer)) <= 5 then
        dxDrawText(
            getText("CSurvivorPass24"),
            screenX1 - 100, screenY1 - 20, screenX1 + 100, screenY1 + 20,
            tocolor(255,255,255), 1.2, "default-bold", "center", "center"
        )
    end
end)

function SurvivorPass.openWindow()
	if isWindowOpen() then
		triggerServerEvent("SurvivorPass.checkFinished",localPlayer)
    end
end

function SurvivorPass.windowGUI()
	if isWindowOpen() then
		GUIEditor.window[1] = guiCreateWindow(186, 200, 583, 374, getText("CSurvivorPass20"), false)
        setWindowData()
		guiCreateCloseButton()

        GUIEditor.label[1] = guiCreateLabel(10, 29, 269, 49, getText("CSurvivorPass1"), false, GUIEditor.window[1])
        guiSetFont(GUIEditor.label[1], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[1], "center", true)
        guiLabelSetVerticalAlign(GUIEditor.label[1], "center")

        GUIEditor.label[2] = guiCreateLabel(304, 29, 269, 49, getText("CSurvivorPass19"), false, GUIEditor.window[1])
        guiSetFont(GUIEditor.label[2], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[2], "center", true)
        guiLabelSetVerticalAlign(GUIEditor.label[2], "center")

        GUIEditor.label[3] = guiCreateLabel(10, 78, 235, 28, getText("CSurvivorPass2"), false, GUIEditor.window[1])
        guiSetFont(GUIEditor.label[3], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[3], "left", true)
        guiLabelSetVerticalAlign(GUIEditor.label[3], "center")

        GUIEditor.checkbox[1] = guiCreateCheckBox(255, 78, 24, 28, "", false, false, GUIEditor.window[1])

        GUIEditor.label[4] = guiCreateLabel(10, 115, 235, 28, getText("CSurvivorPass3"), false, GUIEditor.window[1])
        guiSetFont(GUIEditor.label[4], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[4], "left", true)
        guiLabelSetVerticalAlign(GUIEditor.label[4], "center")

        GUIEditor.label[5] = guiCreateLabel(10, 153, 235, 28, getText("CSurvivorPass4"), false, GUIEditor.window[1])
        guiSetFont(GUIEditor.label[5], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[5], "left", true)
        guiLabelSetVerticalAlign(GUIEditor.label[5], "center")

        GUIEditor.label[6] = guiCreateLabel(10, 191, 235, 27, getText("CSurvivorPass5"), false, GUIEditor.window[1])
        guiSetFont(GUIEditor.label[6], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[6], "left", true)
        guiLabelSetVerticalAlign(GUIEditor.label[6], "center")

        GUIEditor.label[7] = guiCreateLabel(10, 228, 235, 27, getText("CSurvivorPass6"), false, GUIEditor.window[1])
        guiSetFont(GUIEditor.label[7], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[7], "left", true)
        guiLabelSetVerticalAlign(GUIEditor.label[7], "center")

        GUIEditor.label[8] = guiCreateLabel(10, 265, 235, 27, getText("CSurvivorPass7"), false, GUIEditor.window[1])
        guiSetFont(GUIEditor.label[8], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[8], "left", true)
        guiLabelSetVerticalAlign(GUIEditor.label[8], "center")

        GUIEditor.label[9] = guiCreateLabel(10, 302, 235, 27, getText("CSurvivorPass8"), false, GUIEditor.window[1])
        guiSetFont(GUIEditor.label[9], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[9], "left", true)
        guiLabelSetVerticalAlign(GUIEditor.label[9], "center")
		
        GUIEditor.checkbox[2] = guiCreateCheckBox(255, 115, 24, 28, "", false, false, GUIEditor.window[1])
        GUIEditor.checkbox[3] = guiCreateCheckBox(255, 149, 24, 32, "", false, false, GUIEditor.window[1])
        GUIEditor.checkbox[4] = guiCreateCheckBox(255, 191, 24, 27, "", false, false, GUIEditor.window[1])
        GUIEditor.checkbox[5] = guiCreateCheckBox(255, 228, 24, 27, "", false, false, GUIEditor.window[1])
        GUIEditor.checkbox[6] = guiCreateCheckBox(255, 265, 24, 27, "", false, false, GUIEditor.window[1])
        GUIEditor.checkbox[7] = guiCreateCheckBox(255, 302, 24, 27, "", false, false, GUIEditor.window[1])
		
        GUIEditor.button[1] = guiCreateButton(10, 339, 269, 25, getText("CSurvivorPass9"), false, GUIEditor.window[1])
		
        GUIEditor.label[10] = guiCreateLabel(304, 79, 235, 27, getText("CSurvivorPass11"), false, GUIEditor.window[1])
        guiSetFont(GUIEditor.label[10], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[10], "left", true)
        guiLabelSetVerticalAlign(GUIEditor.label[10], "center")

        GUIEditor.label[11] = guiCreateLabel(304, 116, 235, 27, getText("CSurvivorPass12"), false, GUIEditor.window[1])
        guiSetFont(GUIEditor.label[11], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[11], "left", true)
        guiLabelSetVerticalAlign(GUIEditor.label[11], "center")

        GUIEditor.label[12] = guiCreateLabel(304, 154, 235, 27, getText("CSurvivorPass13"), false, GUIEditor.window[1])
        guiSetFont(GUIEditor.label[12], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[12], "left", true)
        guiLabelSetVerticalAlign(GUIEditor.label[12], "center")

        GUIEditor.label[13] = guiCreateLabel(304, 191, 235, 27, getText("CSurvivorPass14"), false, GUIEditor.window[1])
        guiSetFont(GUIEditor.label[13], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[13], "left", true)
        guiLabelSetVerticalAlign(GUIEditor.label[13], "center")

        GUIEditor.label[14] = guiCreateLabel(304, 228, 235, 27, getText("CSurvivorPass15"), false, GUIEditor.window[1])
        guiSetFont(GUIEditor.label[14], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[14], "left", true)
        guiLabelSetVerticalAlign(GUIEditor.label[14], "center")

        GUIEditor.label[15] = guiCreateLabel(304, 265, 235, 27, getText("CSurvivorPass16"), false, GUIEditor.window[1])
        guiSetFont(GUIEditor.label[15], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[15], "left", true)
        guiLabelSetVerticalAlign(GUIEditor.label[15], "center")

        GUIEditor.label[16] = guiCreateLabel(304, 302, 235, 27, getText("CSurvivorPass17"), false, GUIEditor.window[1])
        guiSetFont(GUIEditor.label[16], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[16], "left", true)
        guiLabelSetVerticalAlign(GUIEditor.label[16], "center")

        GUIEditor.button[2] = guiCreateButton(304, 339, 269, 25, getText("CSurvivorPass18"), false, GUIEditor.window[1])    
		
        GUIEditor.checkbox[8] = guiCreateCheckBox(549, 79, 24, 27, "", true, false, GUIEditor.window[1])
        GUIEditor.checkbox[9] = guiCreateCheckBox(550, 116, 23, 27, "", false, false, GUIEditor.window[1])
        GUIEditor.checkbox[10] = guiCreateCheckBox(550, 154, 23, 27, "", true, false, GUIEditor.window[1])
        GUIEditor.checkbox[11] = guiCreateCheckBox(549, 191, 23, 27, "", true, false, GUIEditor.window[1])
        GUIEditor.checkbox[12] = guiCreateCheckBox(549, 228, 23, 27, "", false, false, GUIEditor.window[1])
        GUIEditor.checkbox[13] = guiCreateCheckBox(549, 265, 23, 27, "", true, false, GUIEditor.window[1])
        GUIEditor.checkbox[14] = guiCreateCheckBox(549, 302, 23, 27, "", false, false, GUIEditor.window[1])
		
		NPC.NormalMessage(getText("CSurvivorPass10"))
		
		triggerServerEvent("SurvivorPass.check",localPlayer)
		triggerServerEvent("SurvivorPass.requestOverlayData",localPlayer)
		
		for i = 1,14 do
			guiCheckBoxSetSelected(GUIEditor.checkbox[i], false)
			guiSetEnabled(GUIEditor.checkbox[i], false)
		end
		
		addEventHandler("onClientGUIClick",GUIEditor.button[1],function()
			triggerServerEvent("SurvivorPass.givePass",localPlayer)
		end,false)
		
		addEventHandler("onClientGUIClick",GUIEditor.button[2],function()
			triggerServerEvent("SurvivorPass.givePassUpgrade",localPlayer)
		end,false)
	end
end
addEvent("SurvivorPass.windowGUI",true)
addEventHandler("SurvivorPass.windowGUI",root,SurvivorPass.windowGUI)

addEvent("SurvivorPass.updateClient",true)
addEventHandler("SurvivorPass.updateClient",root,function(quest_1,quest_2,quest_3,quest_4,quest_5,quest_6,quest_7,quest_8,quest_9,quest_10,quest_11,quest_12,quest_13,quest_14)
	if quest_1 == 1 then guiCheckBoxSetSelected(GUIEditor.checkbox[1], true) end
	if quest_2 == 1 then guiCheckBoxSetSelected(GUIEditor.checkbox[2], true) end
	if quest_3 == 1 then guiCheckBoxSetSelected(GUIEditor.checkbox[3], true) end
	if quest_4 == 1 then guiCheckBoxSetSelected(GUIEditor.checkbox[4], true) end
	if quest_5 == 1 then guiCheckBoxSetSelected(GUIEditor.checkbox[5], true) end
	if quest_6 == 1 then guiCheckBoxSetSelected(GUIEditor.checkbox[6], true) end
	if quest_7 == 1 then guiCheckBoxSetSelected(GUIEditor.checkbox[7], true) end
	if quest_8 == 1 then guiCheckBoxSetSelected(GUIEditor.checkbox[8], true) end
	if quest_9 == 1 then guiCheckBoxSetSelected(GUIEditor.checkbox[9], true) end
	if quest_10 == 1 then guiCheckBoxSetSelected(GUIEditor.checkbox[10], true) end
	if quest_11 == 1 then guiCheckBoxSetSelected(GUIEditor.checkbox[11], true) end
	if quest_12 == 1 then guiCheckBoxSetSelected(GUIEditor.checkbox[12], true) end
	if quest_13 == 1 then guiCheckBoxSetSelected(GUIEditor.checkbox[13], true) end
	if quest_14 == 1 then guiCheckBoxSetSelected(GUIEditor.checkbox[14], true) end
end)

addEvent("SurvivorPass.openLastUpgradeWindow",true)
addEventHandler("SurvivorPass.openLastUpgradeWindow",root,function()
	if isWindowOpen() then
        GUIEditor.window[1] = guiCreateWindow(528, 279, 466, 196, getText("CSurvivorPass21"), false)
        guiCreateCloseButton()
		setWindowData()

        GUIEditor.label[1] = guiCreateLabel(10, 26, 446, 55, getText("CSurvivorPass22"), false, GUIEditor.window[1])
        guiLabelSetHorizontalAlign(GUIEditor.label[1], "center", true)

        GUIEditor.label[2] = guiCreateLabel(10, 91, 446, 60, apocalypseGetElementData(localPlayer,"zombiekills").."/1000", false, GUIEditor.window[1])
        guiSetFont(GUIEditor.label[2], "sa-header")
        guiLabelSetHorizontalAlign(GUIEditor.label[2], "center", false)
        guiLabelSetVerticalAlign(GUIEditor.label[2], "center")

        GUIEditor.button[1] = guiCreateButton(10, 161, 446, 25, getText("CSurvivorPass23"), false, GUIEditor.window[1])
		
		addEventHandler("onClientGUIClick",GUIEditor.button[1],function()
			triggerServerEvent("SurvivorPass.giveLastUpgrade",localPlayer)
		end,false)

        triggerServerEvent("SurvivorPass.requestOverlayData", localPlayer)
	end
end)

addEvent("SurvivorPass.receiveOverlayData", true)
addEventHandler("SurvivorPass.receiveOverlayData", root, function(data)
    SurvivorPass.Overlay.data = data or {}
end)

function SurvivorPass.drawOverlay()
    if not isCharacterLoggedIn() then return end
    if not SurvivorPass.Overlay.visible then return end

    local data = SurvivorPass.Overlay.data
    if not data or not data.tasks or #data.tasks == 0 then return end
	
	if(isWindowOpen())then
		if(apocalypseGetElementData(localPlayer,"tutorialtask") >= 8)then
			if(NPC.TradePreview == nil)then
				local screenW, screenH = guiGetScreenSize()

				local width = 350
				local lineHeight = 18
				local headerHeight = 26
				local footerHeight = 18
				local padding = 8
				local marginRight = 20
				local marginBottom = 120

				local height = headerHeight + (#data.tasks * lineHeight) + footerHeight + (padding * 2)

				local x = screenW - width - marginRight
				local y = screenH - height - marginBottom

				dxDrawRectangle(x, y, width, height, tocolor(0, 0, 0, 120))
				dxDrawRectangle(x, y, width, headerHeight, tocolor(220,25,25, 180))

				local aboText = (tonumber(data.abo) == 1 and getText("CSurvivorPassDisplay1") or getText("CSurvivorPassDisplay2"))
				local title = getText("CSurvivorPassDisplay3") .. " | " .. getText("CSurvivorPassDisplay4") .. ": " .. tostring(data.level or 0) .. " | " .. getText("CSurvivorPassDisplay5") .. ": " .. aboText

				dxDrawText(title, x + 8, y, x + width - 8, y + headerHeight, tocolor(255,255,255), 0.95, "default-bold", "left", "center", false, false, false, true)

				local drawY = y + headerHeight + padding
				for _, task in ipairs(data.tasks) do
					local prefix = task.done and "✓ " or "• "
					local color = task.done and tocolor(100, 220, 120, 255) or tocolor(230, 230, 230, 255)

					dxDrawText(
						prefix .. task.text,
						x + 8, drawY, x + width - 8, drawY + lineHeight,
						color, 0.9, "default-bold", "left", "top", false, false, false, true
					)

					drawY = drawY + lineHeight
				end

				if data.hint and data.hint ~= "" then
					dxDrawText(
						data.hint,
						x + 8, y + height - footerHeight - 2, x + width - 8, y + height - 2,
						tocolor(255, 210, 120, 255), 0.82, "default", "left", "center", false, false, false, true
					)
				end
			end
		end
	end
end
addEventHandler("onClientRender", root, SurvivorPass.drawOverlay)

function SurvivorPass.requestOverlayData()
    if isCharacterLoggedIn() then
        triggerServerEvent("SurvivorPass.requestOverlayData", localPlayer)
    end
end
setTimer(SurvivorPass.requestOverlayData,1000,0)