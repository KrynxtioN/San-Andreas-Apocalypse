local BuyObjectData = {
	["weaponbox"] = {
		pos = {705.386, -440.125, 16.336},
		markerPos = {705.653, -439.963, 16.336},
		trigger = "BuyWeaponboxObject",
		minLevel = 10,
		textAllowed = "CBuyObjects1",
		textDenied = "CBuyObjects2",
		binded = false,
	},
	["blackboard"] = {
		pos = {-2061.1328125,-2433.9609375,30.625},
		markerPos = {-2061.1328125,-2433.9609375,30.625},
		trigger = "BuyBlackBoardObject",
		minLevel = 20,
		textAllowed = "CBuyObjects3",
		textDenied = "CBuyObjects4",
		binded = false,
	},
	["safe"] = {
		pos = {2324.1076660156,6.0029997825623,26.558406829834},
		markerPos = {2324.1076660156,6.0029997825623,26.558406829834},
		trigger = "BuySafeObject",
		minLevel = 30,
		textAllowed = "CBuyObjects5",
		textDenied = "CBuyObjects6",
		binded = false,
	},
	["waterDispenser"] = {
		pos = {1842.5482177734,-1851.3293457031,13.3828125},
		markerPos = {1842.5482177734,-1851.3293457031,13.3828125},
		trigger = "BuyWaterDispenser",
		minLevel = 25,
		textAllowed = "CBuyObjects7",
		textDenied = "CBuyObjects8",
		binded = false,
	},
	["storageCrate"] = {
		pos = {-1967.0041503906,161.40235900879,27.694049835205},
		markerPos = {-1967.0041503906,161.40235900879,27.694049835205},
		trigger = "BuyStorageCrate",
		minLevel = 35,
		textAllowed = "CBuyObjects9",
		textDenied = "CBuyObjects10",
		binded = false,
	},
}

for id, data in pairs(BuyObjectData) do
	data.pickup = createPickup(data.pos[1], data.pos[2], data.pos[3], 3, 1274, 50)
	data.marker = createMarker(data.markerPos[1], data.markerPos[2], data.markerPos[3], "cylinder", 1.5, _, _, _, 0)

	addEventHandler("onClientPickupHit", data.pickup, function(player)
		if(player == localPlayer and not data.binded)then
			if tonumber(apocalypseGetElementData(localPlayer, "level")) >= (data.minLevel or 0) then
				bindKey("e", "down", function() BuyObjectFunction(id) end)
				data.binded = true
			end
		end
	end)
end

function BuyObjectFunction(id)
	local data = BuyObjectData[id]
	if(isElementWithinMarker(localPlayer, data.marker))then
		if(getElementDimension(localPlayer) == getElementDimension(data.marker))then
			triggerServerEvent(data.trigger, localPlayer)
		end
	end
end

addEventHandler("onClientRender", root, function()
	if(isCharacterLoggedIn() and isWindowOpen())then
		for id, data in pairs(BuyObjectData) do
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