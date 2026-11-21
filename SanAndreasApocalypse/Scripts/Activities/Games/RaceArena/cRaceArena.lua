Racegame = {Marker = {}, Text = "", playerInLobby = 0}
local enoughPlayer = false

local screenW, screenH = guiGetScreenSize()
local alpha = 0
local fadeInSpeed = 3

local MapNames = {
	[1] = "Red County",
	[2] = "Mount Chiliad",
}

function Racegame.dxDrawInfo()
    if(alpha < 255)then alpha = math.min(alpha + fadeInSpeed, 255) end

    local fontScale = 2
    local textColor = tocolor(255, 255, 255, alpha)
	
    dxDrawText(Racegame.Text, 0, 0, screenW, screenH, textColor, fontScale, "default-bold", "center", "center")
	if(enoughPlayer == false)then
		dxDrawText(getText("CRaceArena6"):format(Racegame.playerInLobby), 0, 50, screenW, screenH, textColor, fontScale, "default-bold", "center", "center")
	end
end

addEvent("Racegame.dxDrawInfo",true)
addEventHandler("Racegame.dxDrawInfo",root,function(playerInLobby)
	Racegame.Text = getText("SRaceArena3")
	Racegame.playerInLobby = playerInLobby
	if(playerInLobby >= 5)then enoughPlayer = true end
	addEventHandler("onClientRender",root,Racegame.dxDrawInfo)
end)

addEvent("Racegame.hideDxDrawInfo",true)
addEventHandler("Racegame.hideDxDrawInfo",root,function()
	enoughPlayer = false
	removeEventHandler("onClientRender",root,Racegame.dxDrawInfo)
end)

addEvent("Racegame.updateDxDrawInfo",true)
addEventHandler("Racegame.updateDxDrawInfo",root,function(text)
	Racegame.Text = text
end)

addEvent("Racegame.updatePlayerInLobby",true)
addEventHandler("Racegame.updatePlayerInLobby",root,function(playerInLobby)
	Racegame.playerInLobby = playerInLobby
end)

addEvent("Racegame.createMarker",true)
addEventHandler("Racegame.createMarker",root,function(x1,y1,z1,x2,y2,z2)
	if(isElement(Racegame.Marker[1]))then destroyElement(Racegame.Marker[1])end
	if(isElement(Racegame.Marker[2]))then destroyElement(Racegame.Marker[2])end
	if(x1 and y1 and z1)then
		Racegame.Marker[1] = createMarker(x1,y1,z1,"checkpoint",3.5,255,0,0,255)
		setElementDimension(Racegame.Marker[1],getElementDimension(localPlayer))
		
		addEventHandler("onClientMarkerHit",Racegame.Marker[1],function(player)
			if(player == localPlayer)then
				destroyElement(source)
				triggerServerEvent("Racegame.createMarker",localPlayer)
			end
		end)
	end
	if(x2 and y2 and z2)then
		Racegame.Marker[2] = createMarker(x2,y2,z2,"checkpoint",3.5,255,0,0,125)
		setElementDimension(Racegame.Marker[2],getElementDimension(localPlayer))
	end
end)

addEvent("Racegame.createWindow",true)
addEventHandler("Racegame.createWindow",root,function()
	if(isWindowOpen())then
        GUIEditor.window[1] = guiCreateWindow(638, 386, 394, 257, getText("CRaceArena1"), false)
		setWindowData()
		guiCreateCloseButton()

        GUIEditor.button[1] = guiCreateButton(215, 155, 167, 30, getText("CRaceArena2"), false, GUIEditor.window[1])
        GUIEditor.gridlist[1] = guiCreateGridList(12, 28, 193, 157, false, GUIEditor.window[1])
        raceGridlist = guiGridListAddColumn(GUIEditor.gridlist[1], getText("CRaceArena3"), 0.9)
        GUIEditor.label[1] = guiCreateLabel(215, 28, 167, 117, getText("CRaceArena4"), false, GUIEditor.window[1])
        guiLabelSetHorizontalAlign(GUIEditor.label[1], "center", false)
        GUIEditor.label[2] = guiCreateLabel(12, 195, 370, 52, getText("CRaceArena5"), false, GUIEditor.window[1])
        guiLabelSetHorizontalAlign(GUIEditor.label[2], "center", true)
		
		triggerServerEvent("Racegame.updateRaces",localPlayer)
		
		addEventHandler("onClientGUIClick",GUIEditor.button[1],function()
			local selectedRow = guiGridListGetSelectedItem(GUIEditor.gridlist[1])
			if(selectedRow ~= -1)then
				local RaceID = guiGridListGetItemData(GUIEditor.gridlist[1], selectedRow, raceGridlist)
				if(RaceID)then
					triggerServerEvent("Racegame.addPlayer",localPlayer,localPlayer,RaceID)
					showCursor(false)
					closeWindow()
				end
			end
		end,false)
    end
end)

addEvent("Racegame.updateRaces",true)
addEventHandler("Racegame.updateRaces",root,function(races)
	if(races)then
		if(isElement(GUIEditor.window[1]))then
			guiGridListClear(GUIEditor.gridlist[1])
			
			for _,v in pairs(races)do
				local row = guiGridListAddRow(GUIEditor.gridlist[1])
				guiGridListSetItemText(GUIEditor.gridlist[1], row, raceGridlist, MapNames[v.map].." ("..#v.player..")", false, false)
				guiGridListSetItemData(GUIEditor.gridlist[1], row, raceGridlist, v.ID)
			end
		end
	end
end)