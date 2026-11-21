local skinsReplace = {{"spinosaurus", 94}}

local function replaceModel()
    for _, v in ipairs(skinsReplace) do
        local txd = engineLoadTXD("Files/Models/Animals/" .. v[1] .. ".txd", v[2])
        engineImportTXD(txd, v[2])
        local dff = engineLoadDFF("Files/Models/Animals/" .. v[1] .. ".dff", v[2])
        engineReplaceModel(dff, v[2])
    end
end
replaceModel()

Spinosaurus = {
    status = "chasing",
    Object_Data = {},
	player_dynamite = 0,
    ["Objects"] = {
        {4845, 1905.9128, -1249.9904, 1165.1519, 0, 0, 0},
        {17026, 1994.9923, -1293.5649, 1169.6772, 0, 0, 0},
        {17026, 2006.1984, -1330.3741, 1169.0272, 0, 0, -44},
        {17026, 1997.3707, -1371.4456, 1166.8271, 0, 0, -52},
        {17026, 1970.703, -1391.7465, 1166.1022, 0, 0, -124.004},
        {17026, 1926.9504, -1385.5155, 1166.1022, 0, 0, -138.008},
        {17026, 1886.5717, -1366.1844, 1166.1022, 0, 0, -158.01},
        {17026, 1848.2592, -1343.0177, 1166.1022, 0, 0, -152.011},
        {17026, 1838.4829, -1317.9174, 1166.1022, 0, 0, 113.988},
        {17026, 1871.1649, -1285.9653, 1166.1022, 0, 0, 93.983},
        {17026, 1897.9878, -1253.549, 1166.1022, 0, 0, 113.983},
        {17026, 1962.458, -1257.2554, 1166.1022, 0, 0, 17.978},
        {17026, 1922.7354, -1237.0752, 1166.1022, 0, 0, 41.973},
        {17026, 1957.6935, -1275.1256, 1166.1022, 0, 0, -94.026},
        {17026, 1882.3785, -1241.0433, 1178.3522, 23.978, -90, 138},
        {17026, 1856.6021, -1279.4633, 1178.3522, 23.972, -90, 143.999},
        {17026, 1827.7438, -1311.1746, 1178.3522, 23.972, -90, 153.998},
        {17026, 1843.3451, -1355.1798, 1178.3522, 23.972, -90, -144.005},
        {17026, 1883.3475, -1380.3081, 1178.3522, 23.972, -90, -128.009},
        {17026, 1925.1018, -1396.7686, 1178.3522, 23.972, -90, -100.013},
        {17026, 1918.5116, -1222.7931, 1178.3522, 23.972, -90, 79.999},
        {17026, 1960.5864, -1237.5822, 1178.3522, 23.972, -90, 53.997},
        {17026, 1994.5974, -1267.8687, 1178.3522, 23.972, -90, 39.992},
        {17026, 2017.0272, -1304.4115, 1178.3522, 23.972, -90, 15.99},
        {17026, 2021.1125, -1350.5579, 1178.3522, 23.972, -90, -26.015},
        {17026, 2000.0884, -1394.019, 1178.3522, 23.972, -90, -66.016},
        {17026, 1959.1512, -1411.0101, 1178.3522, 23.972, -90, -102.017},
    },
}

Spinosaurus.dynamiteSpawns = {
    {1871.8453369141,-1338.5587158203,1170.0134277344},
    {1917.6566162109,-1363.3616943359,1165.6497802734},
    {1964.5291748047,-1367.5889892578,1170.5863037109},
    {1988.2091064453,-1331.7954101562,1171.4464111328},
    {1972.4250488281,-1300.9061279297,1171.2791748047},
    {1939.5864257812,-1311.4129638672,1164.4328613281},
    {1910.6783447266,-1307.2163085938,1170.2185058594},
    {1913.0120849609,-1275.8937988281,1172.2532958984},
    {1939.873046875,-1260.7451171875,1170.8016357422},
    {1909.2358398438,-1286.0676269531,1172.4971923828},
    {1892.5205078125,-1305.0909423828,1172.044921875},
    {1940.3256835938,-1337.201171875,1159.3590087891},
    {1939.4685058594,-1315.9581298828,1163.3218994141},
    {1894.9326171875,-1282.1555175781,1174.0665283203},
    {1879.7523193359,-1303.2895507812,1173.4487304688},
    {1939.5065917969,-1351.0122070312,1161.5673828125},
    {1974.3933105469,-1354.3728027344,1171.4683837891},
    {1910.4593505859,-1319.0040283203,1164.3558349609},
    {1906.1414794922,-1270.4127197266,1172.2231445312},
    {1902.3276367188,-1348.3562011719,1165.7564697266},
}

local Dynamite_Objects = {}
local Dynamite_Marker = {}

Spinosaurus.maxDynamite = 5

function Spinosaurus.createDynamite(id)
    local currentCount = 0
    for k,v in pairs(Dynamite_Objects) do
        if isElement(v) then
            currentCount = currentCount + 1
        end
    end

    if currentCount >= Spinosaurus.maxDynamite then
        return
    end

    local rnd = math.random(1,#Spinosaurus.dynamiteSpawns)
    if id then rnd = id end

    if not isElement(Dynamite_Objects[rnd]) then
        local tbl = Spinosaurus.dynamiteSpawns[rnd]
        local x,y,z = tbl[1],tbl[2],tbl[3]
        Dynamite_Objects[rnd] = createPickup(x,y,z,3,1654,50)
        Dynamite_Marker[rnd] = createMarker(x,y,z,"corona",0.5,255,0,0)
        setElementDimension(Dynamite_Objects[rnd], getElementDimension(localPlayer))
        setElementDimension(Dynamite_Marker[rnd], getElementDimension(localPlayer))
        apocalypseSetElementData(Dynamite_Objects[rnd], "DynamiteID", rnd)

        addEventHandler("onClientPickupHit", Dynamite_Objects[rnd], function(player)
            if player == localPlayer and getElementType(player) == "player" and getElementDimension(localPlayer) == getElementDimension(source) then
                local ID = apocalypseGetElementData(source, "DynamiteID")
                destroyElement(source)
                destroyElement(Dynamite_Marker[ID])
                Dynamite_Objects[ID] = nil
                Dynamite_Marker[ID] = nil
                Spinosaurus.player_dynamite = Spinosaurus.player_dynamite + 1
            end
        end)
    else
        Spinosaurus.createDynamite()
    end
end

function Spinosaurus.destroyDynamite()
	for _,v in pairs(Dynamite_Objects)do
		destroyElement(v)
	end
	for _,v in pairs(Dynamite_Marker)do
		destroyElement(v)
	end
	Dynamite_Objects = {}
	Dynamite_Marker = {}
end

local dynamiteMarkers = {}
local dynamiteObjects = {}
local DYNAMITE_DAMAGE  = 50

Spinosaurus.lastAttack = 0
Spinosaurus.attackCooldown = 2000
Spinosaurus.devourLock = false

Spinosaurus.spawnPoints = {
    {1859.26,-1335.16,1169.88},
    {1944.74,-1374.00,1169.56},
    {1986.43,-1326.52,1171.41},
    {1938.59,-1301.97,1171.45},
    {1943.12,-1263.12,1170.81},
}

local function placeDynamite()
    if not isElement(Spinosaurus.ped) then return end
	if(Spinosaurus.player_dynamite >= 1)then
		local x, y, z = getElementPosition(localPlayer)
		local groundZ  = getGroundPosition(x, y, z + 1) or z
		local marker   = createMarker(x, y, groundZ, "cylinder", 5, 255, 150, 0, 0)
		setElementDimension(marker,getElementDimension(localPlayer))
		local bomb = createObject(1654,x-0.5,y,z-0.85,-90,0,0)
		setElementDimension(bomb,getElementDimension(localPlayer))
		setObjectBreakable(bomb,false)
		table.insert(dynamiteMarkers, marker)
		table.insert(dynamiteObjects, bomb)
		Spinosaurus.player_dynamite = Spinosaurus.player_dynamite - 1
	else
		NPC.MeMessage(getText("SDinosaur2"))
	end
end

local function checkDynamiteHits()
    if not isElement(Spinosaurus.ped) then return end
    local bx, by, bz = getElementPosition(Spinosaurus.ped)
    for i = #dynamiteMarkers, 1, -1 do
        local marker = dynamiteMarkers[i]
        local bomb = dynamiteObjects[i]
        if isElement(marker) then
            local mx, my, mz = getElementPosition(marker)
            local size = getMarkerSize(marker)
            if getDistanceBetweenPoints3D(mx,my,mz,bx,by,bz) <= size then
                Spinosaurus.health = math.max(0, Spinosaurus.health - DYNAMITE_DAMAGE)
                Spinosaurus.status = "damaged"
				playSound("Files/Sounds/Spinosaurus_Roar.wav")
                setTimer(function()
                    if isElement(Spinosaurus.ped) then
                        Spinosaurus.status = "chasing"
                    end
                end,1500,1)
                if Spinosaurus.health < 1 then
					local x,y,z = getElementPosition(Spinosaurus.ped)
                    killPed(Spinosaurus.ped)
                    removeEventHandler("onClientRender",root,Spinosaurus.movement)
                    removeEventHandler("onClientRender",root,Spinosaurus.healthUI)
					Levelsystem.Visible = true
                    triggerServerEvent("Spinosaurus.died",localPlayer)
					
					Spinosaurus.collectBonePickup = createPickup(x,y,z,3,1254,50)
					
					addEventHandler("onClientPickupHit",Spinosaurus.collectBonePickup,function(player)
						if(player == localPlayer)then
							destroyElement(source)
							triggerServerEvent("Spinosaurus.collectBone",localPlayer)
						end
					end)
                end
                local effect = createExplosion(mx, my, mz, 5)
                destroyElement(marker)
                destroyElement(bomb)
                table.remove(dynamiteMarkers,i)
                table.remove(dynamiteObjects,i)
            end
        else
            table.remove(dynamiteMarkers,i)
        end
    end
end

local function findRotation(x1, y1, x2, y2)
    local t = -math.deg(math.atan2(x2 - x1, y2 - y1))
    return t < 0 and t + 360 or t
end

local bossAlpha, nametagAlpha, effectSize = 0, 0, 0
local screenW, screenH = guiGetScreenSize()
local bossName = "Spinosaurus"

local function animateBossIntro()
    local animTime, startTime = 2000, getTickCount()
    local function renderFunc()
        local progress = (getTickCount() - startTime) / animTime
        if progress > 1 then progress = 1 end
        bossAlpha  = interpolateBetween(0,0,0, 255,0,0, progress, "OutQuad")
        effectSize = interpolateBetween(10,0,0, 0,0,0, progress, "OutQuad")
        if progress >= 1 then
            removeEventHandler("onClientRender", root, renderFunc)
        end
    end
    addEventHandler("onClientRender", root, renderFunc)
end

function Spinosaurus.drawDynamiteCount()
    local count = Spinosaurus.player_dynamite

    local x = screenW / 2
    local y = 50 + 30 + 10

    dxDrawText(getText("CDinosaur2") .. ": " .. count,x, y, x, y,tocolor(255, 200, 0, bossAlpha),1.5, "default-bold", "center", "top")
end

local function startBossFight()
    bossAlpha, nametagAlpha, effectSize = 0, 0, 0
    animateBossIntro()
    bindKey("e", "down", placeDynamite)
    addEventHandler("onClientRender", root, checkDynamiteHits)
end

function Spinosaurus.createLobby(dim)
    Spinosaurus.Object_Data = {}
    for _,v in pairs(Spinosaurus["Objects"])do
        local object = createObject(v[1],v[2],v[3],v[4],v[5],v[6],v[7])
        setElementDimension(object,dim)
        table.insert(Spinosaurus.Object_Data,object)
    end

    setTimer(function(dim)
        setElementPosition(localPlayer,1848.46484375,-1326.1469726562,1170.1273193359)
        setElementRotation(localPlayer,0,0,300)
        setElementDimension(localPlayer,dim)

        Spinosaurus.leaveMarker = createPickup(1840.986328125,-1329.2569580078,1169.9731445312,3,1318,50)
        setElementDimension(Spinosaurus.leaveMarker,getElementDimension(localPlayer))

        Spinosaurus.ped = createPed(94, 1922.9307861328,-1267.0358886719,1171.7885742188, 0)
        setElementDimension(Spinosaurus.ped, getElementDimension(localPlayer))
        setElementInterior (Spinosaurus.ped, getElementInterior (localPlayer))
        Spinosaurus.status = "chasing"
        Spinosaurus.health = 1000
		Spinosaurus.player_dynamite = 0
		Spinosaurus.createDynamite(15)
		Spinosaurus.openTutorial()
		Spinosaurus.spawnDynamiteTimer = setTimer(function()
			Spinosaurus.createDynamite()
		end,10000,0)
		addEventHandler("onClientRender", root, Spinosaurus.drawDynamiteCount)

        startBossFight()
        addEventHandler("onClientRender", root, Spinosaurus.movement)
        addEventHandler("onClientRender", root, Spinosaurus.healthUI)

        addEventHandler("onClientPickupHit",Spinosaurus.leaveMarker,function(player)
            if(player == localPlayer)then
                if(isPedDead(Spinosaurus.ped))then
                    apocalypseSetElementData(localPlayer,"cantentercave",true)
                    triggerServerEvent("Spinosaurus.leaveCave",localPlayer)
				else
					NPC.MeMessage(getText("CDinosaur4"))
                end
            end
        end)
    end,500,1,dim)
end
addEvent("Spinosaurus.createLobby",true)
addEventHandler("Spinosaurus.createLobby",root,Spinosaurus.createLobby)

function Spinosaurus.movement()
    local dino = Spinosaurus.ped
    if not isElement(dino) then return end
    if isPedDead(dino) then return end

    if Spinosaurus.devourLock then
		setPedControlState(dino, "forwards", false)
		setPedControlState(dino, "fire", false)
        return
	else
		setPedAnimation(Spinosaurus.ped)
    end

    local bx, by, bz = getElementPosition(dino)
    local px, py, pz = getElementPosition(localPlayer)
    local dist = getDistanceBetweenPoints3D(bx, by, bz, px, py, pz)

    local rot = findRotation(bx, by, px, py)
    setPedRotation(dino, rot)
    setPedLookAt(dino, px, py, pz + 1.5)
    setPedAimTarget(dino, px, py, pz + 1.2)
	
	if(Spinosaurus.tutorialWindowOpen == false)then
		if dist > 6 then
			setPedControlState(dino, "forwards", true)
			setPedControlState(dino, "fire", false)
		elseif dist <= 6 then
			if not Spinosaurus.devourLock then
				Spinosaurus.devourPlayer()
			end
		end
	else
		setPedControlState(dino, "forwards", false)
		setPedControlState(dino, "fire", false)
	end
end

function Spinosaurus.openTutorial()
	Spinosaurus.tutorialWindowOpen = true
	addEventHandler("onClientRender",root,Spinosaurus.dxDrawTutorial)
	bindKey("enter","down",Spinosaurus.closeTutorial)
	setElementFrozen(localPlayer,true)
end

function Spinosaurus.dxDrawTutorial()
	local screenW, screenH = guiGetScreenSize()
    local text = getText("CDinosaur3")

    local width, height = 400, 100
    local x, y = (screenW - width) / 2, (screenH - height) / 2
    dxDrawRectangle(x, y, width, height, tocolor(0,0,0,200))

    dxDrawText(text, x + 10, y + 10, x + width - 10, y + height - 10,
               tocolor(255,255,255,255), 1, "default-bold", "center", "top", true, true, true)
end

function Spinosaurus.closeTutorial()
	Spinosaurus.tutorialWindowOpen = false
	removeEventHandler("onClientRender",root,Spinosaurus.dxDrawTutorial)
	unbindKey("enter","down",Spinosaurus.closeTutorial)
	setElementFrozen(localPlayer,false)
	NPC.MeMessage(getText("CDinosaur1"))
end

function Spinosaurus.destroy()
    if isElement(Spinosaurus.ped) then
        destroyElement(Spinosaurus.ped)
    end
    removeEventHandler("onClientRender", root, Spinosaurus.movement)
    removeEventHandler("onClientRender", root, Spinosaurus.healthUI)
    for _, m in ipairs(dynamiteMarkers) do
		if isElement(m) then destroyElement(m) end
    end
    dynamiteMarkers = {}
    for _, m in ipairs(dynamiteObjects) do
		if isElement(m) then destroyElement(m) end
    end
    dynamiteObjects = {}
	Spinosaurus.destroyObjects()
	unbindKey("e", "down", placeDynamite)
	Spinosaurus.resetAfterDevour()
	Spinosaurus.destroyDynamite()
	Spinosaurus.closeTutorial()
	setElementFrozen(localPlayer,false)
	if(isElement(Spinosaurus.leaveMarker))then destroyElement(Spinosaurus.leaveMarker) end
	removeEventHandler("onClientRender", root, Spinosaurus.drawDynamiteCount)
	if(isTimer(Spinosaurus.spawnDynamiteTimer))then killTimer(Spinosaurus.spawnDynamiteTimer)end
end
addEvent("Spinosaurus.destroy",true)
addEventHandler("Spinosaurus.destroy",root,Spinosaurus.destroy)

addEventHandler("onClientPlayerWasted", root, function()
    if source ~= localPlayer then return end
    Spinosaurus.destroy()
end)

function Spinosaurus.healthUI()
	Levelsystem.Visible = false
    dxDrawRectangle(screenW/2 - 300, 50, 600, 30, tocolor(0,0,0,bossAlpha))
    local healthWidth = (Spinosaurus.health / 1000) * 600
    dxDrawRectangle(screenW/2 - 300, 50, healthWidth, 30, tocolor(200,0,0,bossAlpha))
    dxDrawRectangle(screenW/2 - 302, 48, 604, 2, tocolor(255,50,50,bossAlpha))
    dxDrawRectangle(screenW/2 - 302, 80, 604, 2, tocolor(255,50,50,bossAlpha))
    dxDrawRectangle(screenW/2 - 302, 50, 2, 30, tocolor(255,50,50,bossAlpha))
    dxDrawRectangle(screenW/2 + 300, 50, 2, 30, tocolor(255,50,50,bossAlpha))
    dxDrawText(bossName, screenW/2, 20, screenW/2, 20,
               tocolor(255,0,0,bossAlpha), 2, "pricedown", "center", "top")
    dxDrawText(bossName,
               screenW/2 + math.random(-effectSize,effectSize),
               20 + math.random(-effectSize,effectSize), screenW/2, 20,
               tocolor(255,100,100,bossAlpha/2), 2.2, "pricedown", "center", "top")
end

function Spinosaurus.destroyObjects()
	for _,v in pairs(Spinosaurus.Object_Data)do
		if(isElement(v))then
			destroyElement(v)
		end
	end
	Spinosaurus.Object_Data = {}
end

function Spinosaurus.devourPlayer()
    if Spinosaurus.devourLock then return end
    if not isElement(Spinosaurus.ped) then return end
    if isPedDead(Spinosaurus.ped) then return end

    local dino = Spinosaurus.ped
    local dx, dy, dz = getElementPosition(dino)
    local rotDeg = getPedRotation(dino)
    local rot = math.rad(rotDeg)

    Spinosaurus.devourLock = true
    Spinosaurus.status = "devour"

    local px = dx + math.cos(rot) * 3.5
    local py = dy + math.sin(rot) * 3.5
    local pz = dz + 3.5
    setElementPosition(localPlayer, px, py, pz)
    setPedRotation(localPlayer, rotDeg + 180)
    setElementAlpha(localPlayer, 0)
    toggleAllControls(false)

    setPedAnimation(dino,"ped","BIKE_elbowR",4000,false,false,false)
	playSound("Files/Sounds/Spinosaurus_Roar.wav")

    setTimer(function()
        if not isElement(localPlayer) then return end
        local lx, ly, lz = getElementPosition(localPlayer)
        for i = 1, 8 do
            local angle = (i/8)*math.pi*2
            local bx = lx + math.cos(angle)*0.5
            local by = ly + math.sin(angle)*0.5
            local bz = lz - 0.5 + math.random()*0.3
            local eff = createEffect("blood_heli", bx, by, bz)
            setTimer(destroyElement, 3500, 1, eff)
        end
    end, 1200, 1)

    local startTick = getTickCount()
    local duration = 4000
    local camHandler
    camHandler = function()
        if not isElement(dino) then
            removeEventHandler("onClientRender", root, camHandler)
            return
        end
        local progress = (getTickCount() - startTick) / duration
        if progress > 1 then progress = 1 end

        local angle = progress * math.pi * 2
        local radius = 12
        local dx, dy, dz = getElementPosition(dino)
        local camX = dx + math.cos(angle) * radius
        local camY = dy + math.sin(angle) * radius
        local camZ = dz + 18
        setCameraMatrix(camX, camY, camZ, dx, dy, dz + 6)

        if progress >= 1 then
            removeEventHandler("onClientRender", root, camHandler)
        end
    end
    addEventHandler("onClientRender", root, camHandler)

    setTimer(function()
        if not isElement(dino) then return end

        removeEventHandler("onClientRender", root, camHandler)
        setCameraTarget(localPlayer)
		setElementHealth(localPlayer,getElementHealth(localPlayer)-25)

        Spinosaurus.status = "chasing"
        Spinosaurus.devourLock = false

        local farthest = nil
        local maxDist = -1
        local dx, dy, dz = getElementPosition(dino)
        for _,v in ipairs(Spinosaurus.spawnPoints) do
            local dist = getDistanceBetweenPoints3D(dx, dy, dz, unpack(v))
            if dist > maxDist then
                maxDist = dist
                farthest = v
            end
        end
        if farthest then
            local tx, ty, tz = unpack(farthest)
            setElementPosition(localPlayer, tx, ty, tz)
            setElementRotation(localPlayer, 0, 0, math.random(0, 360))
        end
        setElementAlpha(localPlayer, 255)
        toggleAllControls(true)

    end, duration, 1)
end

function Spinosaurus.startDevourCamera()
    local dino = Spinosaurus.ped
    if not isElement(dino) then return end

    local startTick = getTickCount()
    local duration = 4000

    local function camRender()
        if not isElement(dino) then
            removeEventHandler("onClientRender", root, camRender)
            return
        end

        local progress = (getTickCount() - startTick)/duration
        if progress > 1 then progress = 1 end

        local dx, dy, dz = getElementPosition(dino)
        local angle = progress*math.pi*2
        local radius = 12
        local camX = dx + math.cos(angle)*radius
        local camY = dy + math.sin(angle)*radius
        local camZ = dz + 18

        setCameraMatrix(camX, camY, camZ, dx, dy, dz + 6)

        if progress >= 1 then
            removeEventHandler("onClientRender", root, camRender)
        end
    end

    addEventHandler("onClientRender", root, camRender)
end

function Spinosaurus.resetAfterDevour()
    setCameraTarget(localPlayer)
    toggleAllControls(true)
    Spinosaurus.status = "chasing"
    Spinosaurus.devourLock = false
end

addEventHandler("onClientPedDamage",root,function()
	if(source == Spinosaurus.ped)then
		cancelEvent()
	end
end)

addEventHandler("onClientPlayerDamage", root, function()
    if source ~= localPlayer then return end
    if not isElement(Spinosaurus.ped) then return end
    if Spinosaurus.devourLock then return end

    cancelEvent()
    Spinosaurus.devourPlayer()
end)