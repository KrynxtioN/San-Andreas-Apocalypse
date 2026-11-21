local BuyChestData = {
	["pizzaboy"] = {
		pos = {505.6169128418,-87.975440979004,998.96826171875},
		markerPos = {505.6169128418,-87.975440979004,998.96826171875},
		trigger = "BuyPizzaboyChest",
		minLevel = 50,
		textAllowed = "CBuyChest1",
		textDenied = "CBuyChest2",
		binded = false,
		int = 11,
		dim = 0,
	},
}

for id, data in pairs(BuyChestData) do
	data.pickup = createPickup(data.pos[1], data.pos[2], data.pos[3], 3, 1274, 50)
	data.marker = createMarker(data.markerPos[1], data.markerPos[2], data.markerPos[3], "cylinder", 1.5, 0, 0, 0, 0)
	if(data.int)then
		setElementInterior(data.pickup,data.int)
		setElementInterior(data.marker,data.int)
	end
	if(data.dim)then
		setElementDimension(data.pickup,data.dim)
		setElementDimension(data.marker,data.dim)
	end

	addEventHandler("onClientPickupHit", data.pickup, function(player)
		if(player == localPlayer and not data.binded)then
			if tonumber(apocalypseGetElementData(localPlayer, "level")) >= (data.minLevel or 0) then
				if(getElementDimension(player) == getElementDimension(source))then
					bindKey("e", "down", function() BuyChestFunction(id) end)
					data.binded = true
				end
			end
		end
	end)
end

function BuyChestFunction(id)
	local data = BuyChestData[id]
	if(isElementWithinMarker(localPlayer, data.marker))then
		if(getElementDimension(localPlayer) == getElementDimension(data.marker))then
			unbindKey("e","down",BuyChestFunction)
			triggerServerEvent(data.trigger, localPlayer)
		end
	end
end

addEventHandler("onClientRender", root, function()
	if(isCharacterLoggedIn() and isWindowOpen())then
		for id, data in pairs(BuyChestData) do
			local x, y, z = unpack(data.pos)
			if getDistanceBetweenPoints3D(x, y, z, getElementPosition(localPlayer)) <= 3.5 then
				local sx, sy = getScreenFromWorldPosition(x, y, z + 0.3)
				if sx and sy then
					if tonumber(apocalypseGetElementData(localPlayer, "level")) >= (data.minLevel or 0) then
						dxDrawText(getText(data.textAllowed), sx - 100, sy - 20, sx + 100, sy + 20, tocolor(255, 255, 255), 1.2, "default-bold", "center", "center")
					else
						dxDrawText(getText(data.textDenied), sx - 100, sy - 20, sx + 100, sy + 20, tocolor(200, 50, 50), 1.2, "default-bold", "center", "center")
					end
				end
			end
		end
	end
end)