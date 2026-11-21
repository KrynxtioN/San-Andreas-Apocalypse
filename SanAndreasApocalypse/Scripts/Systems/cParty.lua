Party = {Blips = {}, partyMembers}

apocalypseSetElementData(localPlayer,"ActiveParty",nil)
apocalypseSetElementData(localPlayer,"IsInParty",nil)
apocalypseSetElementData(localPlayer,"PartyID",nil)

local screenW, screenH = guiGetScreenSize()
local listWidth, listHeight = 250, 150
local listX, listY = 10, (screenH * 0.5) - (listHeight * 0.5)
local rowHeight = 30

local function getPartyMembers()
    local partyID = apocalypseGetElementData(localPlayer, "PartyID")
    if not partyID then return {} end  

    local members = {}
    for _, player in ipairs(getElementsByType("player")) do
        if apocalypseGetElementData(player, "PartyID") == partyID then
            table.insert(members, getPlayerName(player))
        end
    end
    return members
end

function Party.createWindow()
	if(isWindowOpen())then
		if(apocalypseGetElementData(localPlayer,"ActiveParty") == true)then
			GUIEditor.window[1] = guiCreateWindow(665, 345, 274, 69, getText("CParty5"), false)
			guiWindowSetSizable(GUIEditor.window[1], false)

			GUIEditor.button[1] = guiCreateButton(10, 33, 254, 26, getText("CParty4"), false, GUIEditor.window[1])    
			
			addEventHandler("onClientGUIClick",GUIEditor.button[1],function()
				triggerServerEvent("Party.delete",localPlayer)
			end,false)
		else
			GUIEditor.window[1] = guiCreateWindow(516, 363, 599, 180, getText("CParty5"), false)

			GUIEditor.label[1] = guiCreateLabel(10, 36, 579, 57, getText("CParty1"), false, GUIEditor.window[1])
			guiSetFont(GUIEditor.label[1], "default-bold-small")
			guiLabelSetHorizontalAlign(GUIEditor.label[1], "left", true)
			guiLabelSetVerticalAlign(GUIEditor.label[1], "center")
			GUIEditor.label[2] = guiCreateLabel(10, 103, 579, 35, getText("CParty2"), false, GUIEditor.window[1])
			guiSetFont(GUIEditor.label[2], "default-bold-small")
			guiLabelSetHorizontalAlign(GUIEditor.label[2], "left", true)
			guiLabelSetVerticalAlign(GUIEditor.label[2], "center")
			GUIEditor.button[1] = guiCreateButton(10, 148, 579, 22, getText("CParty3"), false, GUIEditor.window[1])
			
			addEventHandler("onClientGUIClick",GUIEditor.button[1],function()
				triggerServerEvent("Party.create",localPlayer)
			end,false)
		end
		guiCreateCloseButton()
		setWindowData()
    end
end
addEvent("Party.createWindow",true)
addEventHandler("Party.createWindow",root,Party.createWindow)

function Party.drawList()
	if(isCharacterLoggedIn() and isWindowOpen())then
		if(apocalypseGetElementData(localPlayer,"IsInParty") == true)then
			if(DailyTasks.isHovering == false)then
			
				local offsetX = 50
				
				Party.partyMembers = getPartyMembers()
				dxDrawRectangle(listX + offsetX, listY, listWidth, listHeight, tocolor(20, 20, 20, 200))

				for i = 1, 5 do
					if Party.partyMembers[i] then
						local yPos = listY + (i - 1) * rowHeight
						
						local bgColor = tocolor(30, 30, 30, 180)
						dxDrawRectangle(listX + offsetX, yPos, listWidth, rowHeight, bgColor)

						dxDrawText(
							Party.partyMembers[i],
							listX + offsetX + 10,
							yPos,
							listX + offsetX + listWidth,
							yPos + rowHeight,
							tocolor(255, 255, 255, 255),
							1,
							"default-bold",
							"left",
							"center"
						)
					end
				end
			end
		end
	end
end
addEventHandler("onClientRender",root,Party.drawList)

function Party.updateBlips()
	if(Party.Blips)then
		for _,v in pairs(Party.Blips)do
			if(isElement(v))then
				destroyElement(v)
			end
		end
		Party.Blips = {}
	end
	
	for i,v in ipairs(getElementsByType("player"))do
		if(apocalypseGetElementData(v,"IsInParty") == true)then
			if(apocalypseGetElementData(v,"PartyID") == apocalypseGetElementData(localPlayer,"PartyID"))then
				if(v ~= localPlayer)then
					Party.Blips[i] = createBlipAttachedTo(v,0,2,200,200,0)
				end
			end
		end
	end
end
addEvent("Party.updateBlips",true)
addEventHandler("Party.updateBlips",root,Party.updateBlips)

bindKey("f7","down",function()
	if(isWindowOpen())then
		if(apocalypseGetElementData(localPlayer,"ActiveParty") == true)then
			GUIEditor.window[1] = guiCreateWindow(803, 222, 239, 400, getText("CParty5"), false)
			setWindowData()
			guiCreateCloseButton()

			GUIEditor.gridlist[1] = guiCreateGridList(12, 31, 217, 223, false, GUIEditor.window[1])
			memberGridlist = guiGridListAddColumn(GUIEditor.gridlist[1], getText("CParty6"), 0.9)
			GUIEditor.button[1] = guiCreateButton(12, 328, 217, 26, getText("CParty7"), false, GUIEditor.window[1])
			GUIEditor.button[2] = guiCreateButton(12, 364, 217, 26, getText("CParty8"), false, GUIEditor.window[1])
			GUIEditor.label[1] = guiCreateLabel(12, 264, 217, 17, getText("CParty9"), false, GUIEditor.window[1])
			guiSetFont(GUIEditor.label[1], "default-bold-small")
			guiLabelSetHorizontalAlign(GUIEditor.label[1], "center", false)
			guiLabelSetVerticalAlign(GUIEditor.label[1], "center")
			GUIEditor.edit[1] = guiCreateEdit(12, 291, 217, 27, "", false, GUIEditor.window[1])
			
			Party.updateGridlist()
			
			addEventHandler("onClientGUIClick",GUIEditor.button[1],function()
				local character_name = guiGetText(GUIEditor.edit[1])
				if(#character_name >= 1)then
					triggerServerEvent("Party.addPlayer",localPlayer,character_name,localPlayer)
				end
			end,false)
			
			addEventHandler("onClientGUIClick",GUIEditor.button[2],function()
				local clicked = guiGridListGetItemText(GUIEditor.gridlist[1],  guiGridListGetSelectedItem(GUIEditor.gridlist[1]),  1)
				if(clicked ~= "")then
					triggerServerEvent("Party.removePlayer",localPlayer,clicked)
				end
			end,false)
		end
	end
end)

function Party.updateGridlist()
	guiGridListClear(GUIEditor.gridlist[1])
		
	for _,v in pairs(getElementsByType("player"))do
		if(apocalypseGetElementData(v,"IsInParty") == true)then
			if(tonumber(apocalypseGetElementData(v,"PartyID")) == getCharacterID())then
				local row = guiGridListAddRow(GUIEditor.gridlist[1])
				guiGridListSetItemText(GUIEditor.gridlist[1], row, memberGridlist, getPlayerName(v), false, false)
			end
		end
	end
end
addEvent("Party.updateGridlist",true)
addEventHandler("Party.updateGridlist",root,Party.updateGridlist)