local textColor = tocolor(255, 255, 255, 255)
local textFont = "default-bold"
local textScale = 1.2
local textDistance = 20
local message = nil

local function getPedAmount()
	local amount = 0
	for _,v in pairs(VehicleMissions.HurtSurvivorPed)do
		if(isElement(v))then
			amount = amount + 1
		end
	end
	return amount
end

function VehicleMissions.renderHurtSurvivor()
	if(message ~= nil)then
		local playerVehicle = getPedOccupiedVehicle(localPlayer)
		if(not(playerVehicle))then return end

		local vehicleX, vehicleY, vehicleZ = getElementPosition(playerVehicle)
		local _, _, vehicleHeight = getElementBoundingBox(playerVehicle)
			
		local textX, textY, textZ = vehicleX, vehicleY, vehicleZ + vehicleHeight + textDistance * 0.01

		local screenX, screenY = getScreenFromWorldPosition(textX, textY, textZ)
		if(screenX and screenY)then
			local hurt_survivor = apocalypseGetElementData(playerVehicle,"HurtSurvivor") or 0
			dxDrawText(getText(message):format(hurt_survivor), screenX, screenY, screenX, screenY, textColor, textScale, textFont, "center", "center")
		end
	end
end

function VehicleMissions.createHurtSurvivor()
	if getPedAmount() >= 25 then return end

	local veh = getPedOccupiedVehicle(localPlayer)
	if not veh then return end

	local playerX, playerY, playerZ = getElementPosition(localPlayer)

	local candidatesNear = {}
	local candidatesAll = {}

	for i, coord in ipairs(VehicleMissions["HurtSurvivors"]) do
		if not isElement(VehicleMissions.HurtSurvivorPed[i]) then
			local dx = coord[1] - playerX
			local dy = coord[2] - playerY
			local distance = dx*dx + dy*dy

			table.insert(candidatesAll, {id = i, distance = distance})

			if distance >= 100 and distance <= 500 then
				table.insert(candidatesNear, {id = i, distance = distance})
			end
		end
	end

	if #candidatesAll == 0 then return end

	local selectedCandidate = nil
	local tries = 0
	local maxTries = 10

	while tries < maxTries and not selectedCandidate do
		tries = tries + 1

		local candidate

		if #candidatesNear > 0 then
			candidate = candidatesNear[math.random(1, #candidatesNear)]
		else
			candidate = candidatesAll[math.random(1, #candidatesAll)]
		end

		if candidate and not isElement(VehicleMissions.HurtSurvivorPed[candidate.id]) then
			selectedCandidate = candidate
		end
	end

	if not selectedCandidate then return end

	local ID = selectedCandidate.id
	local Tbl = VehicleMissions["HurtSurvivors"][ID]

	local Model = zombies["Skins"][math.random(1, #zombies["Skins"])]
	VehicleMissions.HurtSurvivorPed[ID] = createPed(Model, Tbl[1], Tbl[2], Tbl[3], math.random(0, 360))
	setElementCollisionsEnabled(VehicleMissions.HurtSurvivorPed[ID], false)

	setTimer(function(ped)
		if isElement(ped) then
			setPedAnimation(ped, "crack", "crckidle1", -1, true, false, false, false)
		end
	end, 50, 1, VehicleMissions.HurtSurvivorPed[ID])

	VehicleMissions.HurtSurvivorBlip[ID] = createBlip(Tbl[1], Tbl[2], Tbl[3], 0, 1, 255, 255, 0)
	VehicleMissions.HurtSurvivorMarker[ID] = createMarker(Tbl[1], Tbl[2], Tbl[3] - 1, "cylinder", 2, 255, 255, 0, 0)
	apocalypseSetElementData(VehicleMissions.HurtSurvivorMarker[ID], "ID", ID)

	VehicleMissions.HurtSurvivorPickup[ID] = createPickup(Tbl[1], Tbl[2], Tbl[3] + 1, 3, 1318, 50)

	addEventHandler("onClientMarkerHit", VehicleMissions.HurtSurvivorMarker[ID], function(player)
		if player == localPlayer then
			local hitID = apocalypseGetElementData(source, "ID")
			VehicleMissions.destroyHurtSurvivor(hitID)
			triggerServerEvent("addHurtSurvivor", localPlayer)
		end
	end)
end
addEvent("VehicleMissions.createHurtSurvivor", true)
addEventHandler("VehicleMissions.createHurtSurvivor", root, VehicleMissions.createHurtSurvivor)

addEvent("VehicleMissions.createHurtSurvivorDelivery",true)
addEventHandler("VehicleMissions.createHurtSurvivorDelivery",root,function(Type)
	if(Type)then
		local Table = VehicleMissions[Type]
		for i,v in ipairs(Table)do
			if(not(isElement(VehicleMissions.HurtSurvivorDeliveryMarker[i])))then
				VehicleMissions.HurtSurvivorDeliveryMarker[i] = createMarker(v[1],v[2],v[3],"cylinder",v[4],255,255,255,25)
				
				addEventHandler("onClientMarkerHit",VehicleMissions.HurtSurvivorDeliveryMarker[i],function(player)
					if(player == localPlayer)then
						triggerServerEvent("VehicleMissions.hurtSurvivorDelivery",localPlayer)
					end
				end)
			end
		end
	end
end)

addEvent("createHurtSurvivorDxDraw",true)
addEventHandler("createHurtSurvivorDxDraw",root,function(Type)
	message = Type
	removeEventHandler("onClientRender",root,VehicleMissions.renderHurtSurvivor)
	addEventHandler("onClientRender",root,VehicleMissions.renderHurtSurvivor)
end)

function VehicleMissions.destroyHurtSurvivor(ID)
	if(ID)then
		if(isElement(VehicleMissions.HurtSurvivorPed[ID]))then
			destroyElement(VehicleMissions.HurtSurvivorPed[ID])
			destroyElement(VehicleMissions.HurtSurvivorBlip[ID])
			destroyElement(VehicleMissions.HurtSurvivorMarker[ID])
			destroyElement(VehicleMissions.HurtSurvivorPickup[ID])
		end
	else
		for _,v in pairs(VehicleMissions.HurtSurvivorPed)do
			if(isElement(v))then
				destroyElement(v)
			end
		end
		for _,v in pairs(VehicleMissions.HurtSurvivorBlip)do
			if(isElement(v))then
				destroyElement(v)
			end
		end
		for _,v in pairs(VehicleMissions.HurtSurvivorMarker)do
			if(isElement(v))then
				destroyElement(v)
			end
		end
		for _,v in pairs(VehicleMissions.HurtSurvivorDeliveryMarker)do
			if(isElement(v))then
				destroyElement(v)
			end
		end
		for _,v in pairs(VehicleMissions.HurtSurvivorPickup)do
			if(isElement(v))then
				destroyElement(v)
			end
		end
		removeEventHandler("onClientRender",root,VehicleMissions.renderHurtSurvivor)
	end
end
addEvent("VehicleMissions.destroyHurtSurvivor",true)
addEventHandler("VehicleMissions.destroyHurtSurvivor",root,VehicleMissions.destroyHurtSurvivor)