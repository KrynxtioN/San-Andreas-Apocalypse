Shooterarena = {state = false, player = 0, killFeed = {}}
local screenW, screenH = guiGetScreenSize()

local TXD = engineLoadTXD("Files/mods/nitro.txd")
engineImportTXD(TXD, 1947)
local DFF = engineLoadDFF("Files/mods/nitro.dff")
engineReplaceModel(DFF, 1947)

function Shooterarena.render()
	local playerCount = Shooterarena.player
	local vehicle = getPedOccupiedVehicle(localPlayer)
	local vehicleHP = tonumber(apocalypseGetElementData(vehicle, "Shooterarena.Hits")) or 3
	local isDead = isPedDead(localPlayer)

	local x = screenW / 2 - 200
	local y = 20
	local w = 400
	local h = 80
	local padding = 10

	dxDrawRectangle(x + 2, y + 2, w, h, tocolor(0, 0, 0, 160), true)
	dxDrawRectangle(x, y, w, h, tocolor(30, 30, 30, 220), true)

	dxDrawLine(x + w/2, y + 10, x + w/2, y + h - 10, tocolor(100, 100, 100, 200), 1.5, true)

	dxDrawText(getText("CShooterArena1"), x + padding, y + 15, 0, 0, tocolor(180, 180, 255, 255), 1.1, "default-bold", "left", "top", false, false, true)
	dxDrawText(playerCount, x + padding, y + 38, 0, 0, tocolor(255, 255, 255, 255), 1.2, "default-bold", "left", "top", false, false, true)

	dxDrawText(getText("CShooterArena2"), x + w/2 + padding, y + 15, 0, 0, tocolor(180, 255, 180, 255), 1.1, "default-bold", "left", "top", false, false, true)
	dxDrawText(vehicleHP.."/3", x + w/2 + padding, y + 38, 0, 0, tocolor(255, 255, 255, 255), 1.2, "default-bold", "left", "top", false, false, true)

	if isDead then
		fadeCamera(false)
		dxDrawText(
			getText("CShooterArena3"),
			screenW/2 - 220, y + h + 10, screenW/2 + 220, y + h + 40,
			tocolor(255, 80, 80, 255), 1.3, "default-bold", "center", "top", false, false, true
		)
	end

	local feedWidth = 320
	local feedHeight = 28
	local feedX = screenW - feedWidth - 25
	local startY = screenH / 2 - 100

	for i = #Shooterarena.killFeed, 1, -1 do
		local entry = Shooterarena.killFeed[i]
		local aliveTime = getTickCount() - entry.tick

		if aliveTime > 7000 then
			table.remove(Shooterarena.killFeed, i)
		end
	end

	for i, entry in ipairs(Shooterarena.killFeed) do
		local drawY = startY + ((i - 1) * (feedHeight + 6))

		dxDrawRectangle(feedX + 2, drawY + 2, feedWidth, feedHeight, tocolor(0, 0, 0, 140), true)
		dxDrawRectangle(feedX, drawY, feedWidth, feedHeight, tocolor(20, 20, 20, 190), true)

		dxDrawText(
			entry.text,
			feedX + 10, drawY, feedX + feedWidth - 10, drawY + feedHeight,
			tocolor(255, 255, 255, 255), 1.0, "default-bold", "right", "center", false, false, true
		)
	end
end

function Shooterarena.respawn()
	if isPedDead(localPlayer) then
		triggerServerEvent("Shooterarena.join", localPlayer, localPlayer)
	end
end

addEvent("Shooterarena.openWindow", true)
addEventHandler("Shooterarena.openWindow", root, function(players)
	if isWindowOpen() then
		GUIEditor.window[1] = guiCreateWindow(720, 284, 224, 144, getText("CShooterArena4"), false)

		GUIEditor.label[1] = guiCreateLabel(10, 32, 204, 62, getText("CShooterArena5"):format(players), false, GUIEditor.window[1])
		GUIEditor.button[1] = guiCreateButton(10, 104, 204, 30, getText("CShooterArena6"), false, GUIEditor.window[1])
		setWindowData()
		guiCreateCloseButton()

		addEventHandler("onClientGUIClick", GUIEditor.button[1], function()
			triggerServerEvent("Shooterarena.join", localPlayer, localPlayer)
			closeWindow()
		end, false)
	end
end)

function Shooterarena.trackProjectile(projectile, shooterVeh)
	if not isElement(projectile) then return end
	if not isElement(shooterVeh) then return end

	local hitReported = false
	local startTick = getTickCount()
	local timer = nil

	timer = setTimer(function()
		if hitReported then
			if isTimer(timer) then killTimer(timer) end
			return
		end

		if not isElement(projectile) then
			if isTimer(timer) then killTimer(timer) end
			return
		end

		if getTickCount() - startTick > 5000 then
			if isTimer(timer) then killTimer(timer) end
			return
		end

		local px, py, pz = getElementPosition(projectile)

		for _, veh in ipairs(getElementsByType("vehicle")) do
			if veh ~= shooterVeh and apocalypseGetElementData(veh, "shooterVehicle") == true then
				if getElementDimension(veh) == getElementDimension(localPlayer) then
					local vx, vy, vz = getElementPosition(veh)
					local dist = getDistanceBetweenPoints3D(px, py, pz, vx, vy, vz)

					if dist <= 6 then
						hitReported = true
						triggerServerEvent("Shooterarena.vehicleHit", localPlayer, veh)

						if isTimer(timer) then killTimer(timer) end
						break
					end
				end
			end
		end
	end, 50, 0)
end

function Shooterarena.shoot()
	if isPedInVehicle(localPlayer) == true then
		local veh = getPedOccupiedVehicle(localPlayer)

		if apocalypseGetElementData(veh, "shooterVehicle") == true and Shooterarena.state == false then
			local projectile = createProjectile(veh, 19)
			Shooterarena.state = true

			if projectile then
				Shooterarena.trackProjectile(projectile, veh)
			end

			setTimer(function()
				Shooterarena.state = false
			end, 2100, 1)
		end
	end
end

addEvent("Shooterarena.join", true)
addEventHandler("Shooterarena.join", root, function(typ)
	unbindKey("mouse1", "down", Shooterarena.shoot)
	unbindKey("r", "down", Shooterarena.respawn)
	Levelsystem.Visible = true
	createActivitiesInformationText(getText("CShooterArena7"))
	removeEventHandler("onClientRender", root, Shooterarena.render)

	if typ then
		bindKey("mouse1", "down", Shooterarena.shoot)
		Levelsystem.Visible = false
		addEventHandler("onClientRender", root, Shooterarena.render)
		bindKey("r", "down", Shooterarena.respawn)
	end
end)

addEvent("Shooterarena.refreshPlayer", true)
addEventHandler("Shooterarena.refreshPlayer", root, function(player)
	Shooterarena.player = player
end)

function Shooterarena.addKillFeed(killer, victim)
	killer = tostring(killer or "Unbekannt")
	victim = tostring(victim or "Unbekannt")

	table.insert(Shooterarena.killFeed, 1, {
		text = getText("CShooterArena8"):format(killer, victim),
		tick = getTickCount()
	})

	if #Shooterarena.killFeed > 6 then
		table.remove(Shooterarena.killFeed, #Shooterarena.killFeed)
	end
end
addEvent("Shooterarena.addKillFeed", true)
addEventHandler("Shooterarena.addKillFeed", root, Shooterarena.addKillFeed)

addEventHandler("onClientVehicleDamage", root, function()
	if apocalypseGetElementData(source, "shooterVehicle") == true then
		cancelEvent()
	end
end)