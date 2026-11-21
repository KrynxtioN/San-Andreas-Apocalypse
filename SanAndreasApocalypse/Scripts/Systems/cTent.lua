Tents = {}

itemTXD = engineLoadTXD("Files/Mods/tent.txd")
engineImportTXD(itemTXD, 3243)
itemDFF = engineLoadDFF("Files/Mods/tent.dff", 3243)
engineReplaceModel(itemDFF, 3243)
itemCOL = engineLoadCOL("Files/Mods/tent.col")
engineReplaceCOL(itemCOL,3243)

addEvent("Tents.openWindow",true)
addEventHandler("Tents.openWindow",root,function()
	if(isWindowOpen())then
        GUIEditor.window[1] = guiCreateWindow(351, 443, 261, 82, getText("CTents1"), false)
        setWindowData()
		guiCreateCloseButton()

        GUIEditor.button[1] = guiCreateButton(9, 34, 242, 38, getText("CTents2"), false, GUIEditor.window[1]) 
		
		addEventHandler("onClientGUIClick",GUIEditor.button[1],function()
			triggerServerEvent("PlayerSpawn.set",localPlayer,7)
		end,false)
	end
end)

function requestTentPlace()
    local x, y, z = getElementPosition(localPlayer)
    local rz = getPedRotation(localPlayer)
    local offsetRot = math.rad(rz + 90)
    local vx = x + 3 * math.cos(offsetRot)
    local vy = y + 3 * math.sin(offsetRot)
    local vz = getGroundPosition(vx, vy, z + 50)
    local vrot = rz + 180

    triggerServerEvent("Tents.Place", localPlayer, vx, vy, vz, vrot)
end
addCommandHandler("tent", requestTentPlace)