VehicleDealer = {
	["InformationPeds"] = {
		{673.73559570312,-466.06185913086,16.536296844482,90},
	},
}

local open = false
local startTick = 0
local duration = 30000
local screenW, screenH = guiGetScreenSize()

local btn = {
    width = 140,
    height = 30,
    padding = 10,
}

local ui = {
    x = 20,
    y = 20,
    w = 300,
    h = 180,
}

for _,v in pairs(VehicleDealer["InformationPeds"])do
	local model = 0
	local Ped = createPed(model,v[1],v[2],v[3],v[4])
	apocalypseSetElementData(Ped,"VehicleDealerInformationPed",true)
	local marker = createMarker(v[1],v[2],v[3],"cylinder",1.5,0,0,0,0)
	
	addEventHandler("onClientMarkerHit",marker,function(player)
		if(player == localPlayer)then
			if(not(isPedInVehicle(localPlayer)))then
				if(getElementInterior(localPlayer) == getElementInterior(source))then
					if(getElementDimension(localPlayer) == getElementDimension(source))then
						if(open == false)then
							VehicleDealer.createGUI()
						end
					end
				end
			end
		end
	end)
end

local function isHover(x, y, w, h)
    local cx, cy = getCursorPosition()
    if not cx then return false end
    local absX, absY = cx * screenW, cy * screenH
    return absX >= x and absX <= x + w and absY >= y and absY <= y + h
end

function VehicleDealer.createGUI()
	open = true
	showChat(false)
    startTick = getTickCount()
    addEventHandler("onClientRender", root, VehicleDealer.renderUI)
    addEventHandler("onClientClick", root, VehicleDealer.clickUI)
end

function VehicleDealer.renderUI()
    local now = getTickCount()
    local elapsed = now - startTick
    if elapsed >= duration then
        VehicleDealer.hideUI()
        return
    end

    dxDrawRectangle(ui.x, ui.y, ui.w, ui.h, tocolor(0, 0, 0, 180), false)
    dxDrawRectangle(ui.x + 2, ui.y + 2, ui.w - 4, ui.h - 4, tocolor(30, 30, 30, 200), false)

    local msg = getText("CVehicleDealer1")
    dxDrawText(msg, ui.x + 10, ui.y + 10, ui.x + ui.w - 10, ui.y + 80, tocolor(255, 255, 255, 255), 1, "default-bold", "left", "top", _, true)

    local barX = ui.x + 10
    local barY = ui.y + 90
    local barW = ui.w - 20
    local barH = 20
    dxDrawRectangle(barX, barY, barW, barH, tocolor(50, 50, 50, 200), false)
    local progress = (duration - elapsed) / duration
    dxDrawRectangle(barX, barY, barW * progress, barH, tocolor(0, 150, 255, 200), false)

    local secondsLeft = math.ceil((duration - elapsed) / 1000)
    dxDrawText(secondsLeft .. "s", barX + barW + 15, barY, barX + barW + 60, barY + barH, tocolor(255, 255, 255, 255), 1, "default-bold", "left", "center")

    local acceptX = ui.x + btn.padding
    local acceptY = ui.y + ui.h - btn.height - btn.padding
    local declineX = ui.x + ui.w - btn.width - btn.padding
    local declineY = acceptY

    local hoverAccept = isHover(acceptX, acceptY, btn.width, btn.height)
    local hoverDecline = isHover(declineX, declineY, btn.width, btn.height)

    dxDrawRectangle(acceptX, acceptY, btn.width, btn.height,
        tocolor(hoverAccept and 0 or 0, hoverAccept and 200 or 150, hoverAccept and 0 or 50, 220), false)
    dxDrawText(getText("CVehicleDealer2"), acceptX, acceptY, acceptX + btn.width, acceptY + btn.height,
        tocolor(255, 255, 255, 255), 1, "default-bold", "center", "center")

    dxDrawRectangle(declineX, declineY, btn.width, btn.height,
        tocolor(hoverDecline and 200 or 150, hoverDecline and 0 or 50, 0, 220), false)
    dxDrawText(getText("CVehicleDealer3"), declineX, declineY, declineX + btn.width, declineY + btn.height,
        tocolor(255, 255, 255, 255), 1, "default-bold", "center", "center")
end

function VehicleDealer.clickUI(button, state)
    if button == "left" and state == "down" then
        local now = getTickCount()
        local elapsed = now - startTick
        if elapsed >= duration then return end

        if isHover(ui.x + btn.padding, ui.y + ui.h - btn.height - btn.padding, btn.width, btn.height) then
            VehicleDealer.hideUI()
			triggerServerEvent("VehicleDealer.showPositions",localPlayer)
        end
        if isHover(ui.x + ui.w - btn.width - btn.padding, ui.y + ui.h - btn.height - btn.padding, btn.width, btn.height) then
            VehicleDealer.hideUI()
        end
    end
end

function VehicleDealer.hideUI()
	open = false
	showChat(true)
    removeEventHandler("onClientRender", root, VehicleDealer.renderUI)
    removeEventHandler("onClientClick", root, VehicleDealer.clickUI)
end

addEvent("VehicleDealer.createBlip",true)
addEventHandler("VehicleDealer.createBlip",root,function(x,y,z)
	if(isElement(VehicleDealer.blip))then destroyElement(VehicleDealer.blip)end
	if(isTimer(VehicleDealer.timer))then killTimer(VehicleDealer.timer)end
	VehicleDealer.blip = createBlip(x,y,z, 11, 0, 0, 0, 255, 255,0, 50)
	VehicleDealer.timer = setTimer(function()
		destroyElement(VehicleDealer.blip)
	end,300000,1)
end)

addEventHandler("onClientPedDamage",root,function()
	if(apocalypseSetElementData(source,"VehicleDealerID"))then
		cancelEvent()
	end
end)