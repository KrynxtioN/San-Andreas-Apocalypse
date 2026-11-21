WeaponTransport = {
	["Seller"] = {
		[1] = {
			{2954.4497070312,-1492.7591552734,0.025000000372529},
			{2952.0378417969,-1488.6433105469,1.6218999624252,260},
		},
	},
	ActiveVehicles = {},
	RenderActive = false,
}

local function formatWeaponTransportTime(sec)
	if sec < 0 then sec = 0 end
	local m = math.floor(sec / 60)
	local s = sec % 60
	return string.format("%02d:%02d", m, s)
end

function WeaponTransport.renderTimedVehicles()
	local now = getRealTime().timestamp
	local hasAny = false

	for vehicle, expireAt in pairs(WeaponTransport.ActiveVehicles) do
		if isElement(vehicle) then
			hasAny = true

			local x, y, z = getElementPosition(vehicle)
			local sx, sy = getScreenFromWorldPosition(x, y, z + 2.6)

			if sx and sy then
				local remaining = expireAt - now
				local text = getText("CMoneyTransporter2"):format(formatWeaponTransportTime(remaining))

				dxDrawText(
					text,
					sx + 1, sy + 1, sx + 1, sy + 1,
					tocolor(0,0,0,220),
					1.2,
					"default-bold",
					"center",
					"center"
				)

				dxDrawText(
					text,
					sx, sy, sx, sy,
					tocolor(255, 180, 80,255),
					1.2,
					"default-bold",
					"center",
					"center"
				)
			end
		else
			WeaponTransport.ActiveVehicles[vehicle] = nil
		end
	end

	if not hasAny and WeaponTransport.RenderActive then
		removeEventHandler("onClientRender", root, WeaponTransport.renderTimedVehicles)
		WeaponTransport.RenderActive = false
	end
end

addEvent("WeaponTransport.addTimedVehicle", true)
addEventHandler("WeaponTransport.addTimedVehicle", root, function(vehicle, expireAt)
	if not isElement(vehicle) then return end

	WeaponTransport.ActiveVehicles[vehicle] = expireAt

	if not WeaponTransport.RenderActive then
		addEventHandler("onClientRender", root, WeaponTransport.renderTimedVehicles)
		WeaponTransport.RenderActive = true
	end
end)

addEvent("WeaponTransport.removeTimedVehicle", true)
addEventHandler("WeaponTransport.removeTimedVehicle", root, function(vehicle)
	WeaponTransport.ActiveVehicles[vehicle] = nil

	local hasAny = false
	for _ in pairs(WeaponTransport.ActiveVehicles) do
		hasAny = true
		break
	end

	if not hasAny and WeaponTransport.RenderActive then
		removeEventHandler("onClientRender", root, WeaponTransport.renderTimedVehicles)
		WeaponTransport.RenderActive = false
	end
end)

addEvent("WeaponTransport.loadGUI",true)
addEventHandler("WeaponTransport.loadGUI",root,function(wpPlayer)
    if(isWindowOpen())then
        GUIEditor.window[1] = guiCreateWindow(688, 290, 450, 254, getText("CWeaponTransport1"), false)
        setWindowData()
        guiCreateCloseButton()

        GUIEditor.gridlist[1] = guiCreateGridList(9, 50, 195, 194, false, GUIEditor.window[1])
        marker_player = guiGridListAddColumn(GUIEditor.gridlist[1], getText("CWeaponTransport2"), 0.9)
        GUIEditor.button[1] = guiCreateButton(214, 144, 50, 28, ">>", false, GUIEditor.window[1])
        GUIEditor.label[1] = guiCreateLabel(9, 24, 195, 16, getText("CWeaponTransport3"), false, GUIEditor.window[1])
        guiLabelSetVerticalAlign(GUIEditor.label[1], "center")
        GUIEditor.button[2] = guiCreateButton(214, 182, 50, 28, "<<", false, GUIEditor.window[1])
        GUIEditor.gridlist[2] = guiCreateGridList(274, 50, 166, 160, false, GUIEditor.window[1])
        guiGridListAddColumn(GUIEditor.gridlist[2], getText("CWeaponTransport2"), 0.9)
        GUIEditor.button[3] = guiCreateButton(274, 220, 166, 24, getText("CWeaponTransport4"), false, GUIEditor.window[1])
        GUIEditor.label[2] = guiCreateLabel(274, 24, 166, 16, getText("CWeaponTransport5"), false, GUIEditor.window[1])
        guiLabelSetVerticalAlign(GUIEditor.label[2], "center")
        GUIEditor.button[4] = guiCreateButton(214, 220, 50, 24, getText("CWeaponTransport6"), false, GUIEditor.window[1])
        
        guiGridListClear(GUIEditor.gridlist[1])
        guiGridListClear(GUIEditor.gridlist[2])
        
        for _,v in pairs(wpPlayer) do
            local row = guiGridListAddRow(GUIEditor.gridlist[1])
            guiGridListSetItemText(GUIEditor.gridlist[1], row, marker_player, v, false, false)
        end
        
        addEventHandler("onClientGUIClick", GUIEditor.button[1], function()
            local selRow, selCol = guiGridListGetSelectedItem(GUIEditor.gridlist[1])
            if selRow ~= -1 then
                local name = guiGridListGetItemText(GUIEditor.gridlist[1], selRow, marker_player)
                local exists = false
                for i=0, guiGridListGetRowCount(GUIEditor.gridlist[2]) - 1 do
                    if guiGridListGetItemText(GUIEditor.gridlist[2], i, 1) == name then
                        exists = true
                        break
                    end
                end
                if not exists then
                    local newRow = guiGridListAddRow(GUIEditor.gridlist[2])
                    guiGridListSetItemText(GUIEditor.gridlist[2], newRow, 1, name, false, false)
                end
            end
        end, false)
        
        addEventHandler("onClientGUIClick", GUIEditor.button[2], function()
            local selRow, selCol = guiGridListGetSelectedItem(GUIEditor.gridlist[2])
            if selRow ~= -1 then
                guiGridListRemoveRow(GUIEditor.gridlist[2], selRow)
            end
        end, false)

        addEventHandler("onClientGUIClick", GUIEditor.button[3], function()
            local participants = {}
            for i=0, guiGridListGetRowCount(GUIEditor.gridlist[2]) - 1 do
                local name = guiGridListGetItemText(GUIEditor.gridlist[2], i, 1)
                if name and name ~= "" then
                    table.insert(participants, name)
                end
            end
            triggerServerEvent("WeaponTransport.start", localPlayer, participants)
        end, false)

        addEventHandler("onClientGUIClick", GUIEditor.button[4], function()
            triggerServerEvent("WeaponTransport.refreshGUI", localPlayer)
        end, false)
    end
end)

addEvent("WeaponTransport.refreshGUI",true)
addEventHandler("WeaponTransport.refreshGUI",root,function(wpPlayer)
    if(wpPlayer)then
        guiGridListClear(GUIEditor.gridlist[1])
        guiGridListClear(GUIEditor.gridlist[2])
        for _,v in pairs(wpPlayer) do
            local row = guiGridListAddRow(GUIEditor.gridlist[1])
            guiGridListSetItemText(GUIEditor.gridlist[1], row, marker_player, v, false, false)
        end
    end
end)

addEvent("WeaponTransport.deleteClient",true)
addEventHandler("WeaponTransport.deleteClient",root,function()
    if(isElement(WeaponTransport.deliveryMarker))then destroyElement(WeaponTransport.deliveryMarker) end
    if(isElement(WeaponTransport.sellerPed))then destroyElement(WeaponTransport.sellerPed) end
    if(isElement(WeaponTransport.deliveryBlip))then destroyElement(WeaponTransport.deliveryBlip) end
    if(isElement(WeaponTransport.deliveryPickup))then destroyElement(WeaponTransport.deliveryPickup) end
end)

addEvent("WeaponTransport.createDeliveryWarehouse",true)
addEventHandler("WeaponTransport.createDeliveryWarehouse",root,function(x,y,z)
    WeaponTransport.deliveryMarker = createMarker(x,y,z,"cylinder",2,255,0,0,50)
	WeaponTransport.deliveryBlip = createBlip(x,y,z,51)
	WeaponTransport.deliveryPickup = createPickup(x,y,z+0.5,3,1318,50)
    
    addEventHandler("onClientMarkerHit",WeaponTransport.deliveryMarker,function(player)
        if(player == localPlayer)then
            triggerServerEvent("WeaponTransport.Delivery",localPlayer)
			triggerServerEvent("WeaponTransport.DeliveryWarehouse",localPlayer)
        end
    end)
end)

addEvent("WeaponTransport.createSeller",true)
addEventHandler("WeaponTransport.createSeller",root,function(ID)
	local Table1 = WeaponTransport["Seller"][ID][1]
	local Table2 = WeaponTransport["Seller"][ID][2]
    WeaponTransport.sellerPed = createPed(possibleSkinsDecorationPeds[math.random(1,#possibleSkinsDecorationPeds)],Table2[1],Table2[2],Table2[3],Table2[4])
	setPedAnimation(WeaponTransport.sellerPed,"shop","smoke_ryd")
	setElementFrozen(WeaponTransport.sellerPed,true)
	WeaponTransport.deliveryMarker = createMarker(Table1[1],Table1[2],Table1[3],"cylinder",2,255,0,0,25)
	WeaponTransport.deliveryPickup = createPickup(Table1[1],Table1[2],Table1[3]+0.5,3,1318,50)
	WeaponTransport.deliveryBlip = createBlip(Table1[1],Table1[2],Table1[3],51)
	
	addEventHandler("onClientPedDamage",WeaponTransport.sellerPed,function() cancelEvent() end)
	
	addEventHandler("onClientMarkerHit",WeaponTransport.deliveryMarker,function(player)
		if(player == localPlayer)then
			triggerServerEvent("WeaponTransport.Delivery",localPlayer)
			triggerServerEvent("WeaponTransport.DeliverySeller",localPlayer)
		end
	end)
end)

addEventHandler("onClientPedDamage",root,function()
    if(source == WeaponTransport.sellerPed)then cancelEvent() end
end)