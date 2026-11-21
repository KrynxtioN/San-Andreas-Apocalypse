Bigfoot = {
	Object_Data = {},
	["SpawnsBigfoot"] = {
		[1] = {2611.9143066406,-1990.7252197266,596.95452880859,0},
	},
	["PlayerSpawn"] = {
		[1] = {2633.1889648438,-1952.8070068359,596.96228027344,160},
	},
	["InMarker"] = {
		[1] = {-2683.4306640625,-1678.8780517578,260.08279418945},
	},
	["OutMarker"] = {
		[1] = {2633.4995117188,-1950.6071777344,596.96234130859},
	},
	["OutSpawn"] = {
		[1] = {-2680.4323730469,-1682.3292236328,261.41510009766},
	},
	["Objects"] = {
		[1] = {
			{17029,2626.9541015625,-1940.1083984375,588.49768066406,0,0,0},
			{17029,2643.49609375,-1968.5087890625,588.49768066406,0,0,275.99853515625},
			{17029,2624.0224609375,-2000.2021484375,588.49768066406,0,0,233.99780273438},
			{17029,2597.326171875,-1960.4296875,588.49768066406,0,0,87.994995117188},
			{17029,2597.568359375,-1991.9990234375,588.49768066406,0,0,141.99279785156},
			{17030,2645.751953125,-1947.9248046875,604.81402587891,29.4873046875,313.83544921875,3.9166259765625},
			{17030,2642.8857421875,-1993.7470703125,604.81402587891,29.481811523438,313.82995605469,301.90979003906},
			{17030,2602.5244140625,-2003.9052734375,604.81402587891,29.481811523438,313.82995605469,207.91076660156},
			{17030,2584.9296875,-1963.9716796875,604.81402587891,29.481811523438,313.82995605469,143.90991210938},
			{17030,2612.2314453125,-1930.6123046875,604.81402587891,29.481811523438,313.82995605469,75.904541015625},
			{10562,2621.2822265625,-1974.9580078125,595.88421630859,0,0,0},
			{10562,2626.001953125,-1975.1953125,595.88421630859,0,0,180},
			{759,2619.6025390625,-1979.6015625,595.94317626953,0,0,0},
			{759,2607.2646484375,-1980.5556640625,595.94317626953,0,0,0},
			{759,2631.7392578125,-1964.9228515625,595.94317626953,0,0,0},
			{759,2611.5859375,-1964.28125,595.94317626953,0,0,0},
			{800,2615.1904296875,-1975.0712890625,597.82440185547,0,0,0},
			{800,2612.08984375,-1990.185546875,597.82440185547,0,0,0},
			{800,2628.4482421875,-1958.8681640625,597.82440185547,0,0,0},
			{802,2620.1689453125,-1969.7373046875,596.31292724609,0,0,0},
			{802,2616.376953125,-1951.4375,596.26580810547,0,0,0},
			{802,2625.390625,-1987.234375,596.330078125,0,0,0},
			{815,2615.97265625,-1966.91015625,595.8779296875,0,0,0},
			{820,2617.93359375,-1957.65234375,595.89068603516,0,0,0},
			{820,2626.9345703125,-1974.046875,595.92181396484,0,0,0},
			{820,2620.462890625,-1985.79296875,595.95452880859,0,0,0},
			{820,2636.341796875,-1959.1865234375,595.95452880859,0,0,0},
			{820,2605.0390625,-1970.57421875,595.92919921875,0,0,0},
			{17299,2611.21484375,-1997.283203125,628.5703125,321.99829101562,179.99450683594,180},
			{17299,2589.87890625,-1958.7080078125,628.5703125,321.99279785156,179.99450683594,129.990234375},
			{17299,2620.8447265625,-1946.6591796875,628.5703125,321.99279785156,179.99450683594,43.9892578125},
			{17299,2637.0654296875,-1988.361328125,628.5703125,321.99279785156,179.99450683594,297.98767089844},
			{17299,2634.5927734375,-1955.3486328125,637.3203125,321.99279785156,179.99450683594,179.99450683594},
			{17299,2620.2724609375,-1973.1943359375,637.3203125,321.99279785156,179.99450683594,179.99450683594},
			{17299,2607.884765625,-1973.978515625,637.3203125,321.99279785156,179.99450683594,179.99450683594},
			{17299,2618.064453125,-1962.234375,637.3203125,321.99279785156,179.99450683594,179.99450683594},
		},
	},
}

local Killed_Bigfoot_Counter_Pickup = 0

addEvent("Killed_Bigfoot_Counter_Pickup_Update",true)
addEventHandler("Killed_Bigfoot_Counter_Pickup_Update",root,function(amount)
	Killed_Bigfoot_Counter_Pickup = amount
end)

local MinigunPickup = { -- x,y,z,int,dim
	{-2817.76171875,-1521.9071044922,140.84375,0,0},
	{322.56936645508,317.0087890625,999.1484375,5,0},
}

addEventHandler("onClientRender", root, function()
    if not (isCharacterLoggedIn() and isWindowOpen()) then return end
	
	for _,v in pairs(MinigunPickup)do
		if(getElementInterior(localPlayer) == v[4] and getElementDimension(localPlayer) == v[5])then
			local x1, y1, z1 = v[1],v[2],v[3]
			local screenX1, screenY1 = getScreenFromWorldPosition(x1, y1, z1)

			if screenX1 and screenY1 and getDistanceBetweenPoints3D(x1, y1, z1, getElementPosition(localPlayer)) <= 5 then
				dxDrawText(getText("CBigfoot13"):format(Killed_Bigfoot_Counter_Pickup),
					screenX1 - 100, screenY1 - 20, screenX1 + 100, screenY1 + 20,
					tocolor(255,255,255), 1.2, "default-bold", "center", "center")
			end
		end
	end
end)

addEvent("Bigfoot.createPhotoMarker",true)
addEventHandler("Bigfoot.createPhotoMarker",root,function()
	Bigfoot.PhotoMarker = createMarker(-2816.6999511719,-1516.1999511719,139.90000305176,"cylinder",1,255,255,255,75)
	Bigfoot.PhotoPickup = createPickup(-2816.6999511719,-1516.1999511719,139.50000305176,3,1239,50)
	
	addEventHandler("onClientPickupHit",Bigfoot.PhotoPickup,function(player)
		if(player == localPlayer)then
			triggerServerEvent("Bigfoot.givePlayerPhoto",localPlayer)
			destroyElement(source)
			destroyElement(Bigfoot.PhotoMarker)
		end
	end)
end)

local animalTXD = engineLoadTXD("Files/Models/Animals/bigfoot.txd")
engineImportTXD(animalTXD,9)
local animalDFF = engineLoadDFF("Files/Models/Animals/bigfoot.dff",9)
engineReplaceModel(animalDFF,9)

local function findRotation( x1, y1, x2, y2 ) 
    local t = -math.deg( math.atan2( x2 - x1, y2 - y1 ) )
    return t < 0 and t + 360 or t
end

local bossAlpha, nametagAlpha, effectSize = 0, 0, 0

local screenW, screenH = guiGetScreenSize()
local bossName = "Bigfoot"

local function animateBossIntro()
    local animTime = 2000
    local startTime = getTickCount()
    local renderFunc
    renderFunc = function()
        local progress = (getTickCount() - startTime) / animTime
        if(progress > 1)then progress = 1 end
        bossAlpha = interpolateBetween(0, 0, 0, 255, 0, 0, progress, "OutQuad")
        effectSize = interpolateBetween(10, 0, 0, 0, 0, 0, progress, "OutQuad")
        if(progress >= 1)then
            removeEventHandler("onClientRender", root, renderFunc)
        end
    end
    addEventHandler("onClientRender", root, renderFunc)
end

local function startBossFight()
    bossAlpha = 0
    nametagAlpha = 0
    effectSize = 0
    animateBossIntro()
end

function Bigfoot.createLobby(ID)
	local tbl = Bigfoot["SpawnsBigfoot"][ID]
	Bigfoot.ped = createPed(9,tbl[1],tbl[2],tbl[3],tbl[4])
	setElementDimension(Bigfoot.ped,getElementDimension(localPlayer))
	playSound("Files/Sounds/Bigfoot_Roar.mp3")
	
	Bigfoot.status = "chasing"
	Bigfoot.health = 1000
	Bigfoot.HitsTillIdle = 10
	
	startBossFight()
	addEventHandler("onClientRender",root,Bigfoot.movement)
	addEventHandler("onClientRender",root,Bigfoot.healthUI)
end

function Bigfoot.movement()
	if(isElement(Bigfoot.ped))then
		local bx, by, bz = getElementPosition(Bigfoot.ped)
		local px, py, pz = getElementPosition(localPlayer)
		if(Bigfoot.status == "chasing")then
			if(getDistanceBetweenPoints3D(bx, by, bz, px, py, pz) > 3)then
				setPedControlState(Bigfoot.ped,"forwards",true)
			else
				if(getPedControlState(Bigfoot.ped,"fire") == true)then
					setPedControlState(Bigfoot.ped,"fire",false)
				else
					setPedControlState(Bigfoot.ped,"fire",true)
				end
				setPedControlState(Bigfoot.ped,"forwards",false)
			end
			
			local distance = getDistanceBetweenPoints3D(px, py, pz, bx, by, bz)
			local rotation = findRotation(bx, by, px, py)
			setPedRotation(Bigfoot.ped, rotation)
			setPedLookAt(Bigfoot.ped, px, py, pz + 5)
			setPedAimTarget(Bigfoot.ped, px, py, pz)
		end
	end
end

addEventHandler("onClientPlayerWasted",root,function()
	if(source == localPlayer)then
		if(isElement(Bigfoot.ped))then
			Bigfoot.CleanUp()
		end
	end
end)

function Bigfoot.CleanUp()
	if isElement(Bigfoot.leaveMarker) then
		destroyElement(Bigfoot.leaveMarker)
	end
	destroyElement(Bigfoot.ped)
	removeEventHandler("onClientRender",root,Bigfoot.movement)
	removeEventHandler("onClientRender",root,Bigfoot.healthUI)
	Bigfoot.destroyObjects(apocalypseGetElementData(localPlayer,"BigfootID"))
	if(isElement(Bigfoot.specialHitMarker))then
		destroyElement(Bigfoot.specialHitMarker)
	end
	if(isTimer(Bigfoot.idleTimer))then killTimer(Bigfoot.idleTimer)end
	Levelsystem.Visible = true
	if(isElement(Bigfoot.headPickup))then destroyElement(Bigfoot.headPickup)end
end

addEventHandler("onClientPedDamage",root,function(attacker,weapon,bodypart)
	if source ~= Bigfoot.ped then return end
	if attacker ~= localPlayer then return end

	cancelEvent()
			
	if(Bigfoot.status == "chasing" or Bigfoot.status == "gothit")then
		Bigfoot.health = Bigfoot.health - 1
		if(Bigfoot.health < 1)then
			killPed(Bigfoot.ped)
			removeEventHandler("onClientRender",root,Bigfoot.movement)
			removeEventHandler("onClientRender",root,Bigfoot.healthUI)
			Levelsystem.Visible = true
			Bigfoot.createPickup()
		end
	end
		
	if(Bigfoot.status == "chasing")then
		if(math.random(1,5) < 3 and not(isTimer(Bigfoot.resetHitTimer)))then
			setPedAnimation(Bigfoot.ped,"fight_c","hitc_3",-1,false)
			Bigfoot.status = "gothit"
			
			Bigfoot.resetHitTimer = setTimer(function()
				setPedAnimation(Bigfoot.ped)
				Bigfoot.status = "chasing"
				Bigfoot.resetHitTimer = setTimer(function() end,5000,1)
			end,2500,1)
		end
		if(Bigfoot.HitsTillIdle > 0)then
			Bigfoot.HitsTillIdle = Bigfoot.HitsTillIdle - 1
		end
		if(Bigfoot.HitsTillIdle < 1)then
			if(isTimer(Bigfoot.resetHitTimer))then killTimer(Bigfoot.resetHitTimer)end
			Bigfoot.HitsTillIdle = 10
			local x,y,z = getElementPosition(Bigfoot.ped)
			Bigfoot.specialHitMarker = createMarker(x,y,z,"cylinder",2,255,0,0,0)
			setElementDimension(Bigfoot.specialHitMarker,getElementDimension(localPlayer))
			NPC.MeMessage(getText("CBigfoot3"))
			playSound("Files/Sounds/Bigfoot_Damage.mp3")
		
			addEventHandler("onClientMarkerHit",Bigfoot.specialHitMarker,function(player)
				if(player == localPlayer)then
					if(getElementDimension(localPlayer) == getElementDimension(source))then
						Bigfoot.specialHit()
						destroyElement(source)
						if(isTimer(Bigfoot.idleTimer))then
							killTimer(Bigfoot.idleTimer)
						end
						setElementFrozen(Bigfoot.ped,false)
					end
				end
			end)
		
			Bigfoot.status = "idle"
			setPedAnimation(Bigfoot.ped)
			local rnd = math.random(1,4)
			setElementFrozen(Bigfoot.ped,true)
			setPedAnimation(Bigfoot.ped,"crack","crckidle"..rnd)
			setTimer(function()
				setPedAnimation(Bigfoot.ped,"crack","crckidle"..rnd)
			end,250,1)
			Bigfoot.idleTimer = setTimer(function()
				setPedAnimation(Bigfoot.ped)
				Bigfoot.status = "chasing"
				if(isElement(Bigfoot.specialHitMarker))then
					destroyElement(Bigfoot.specialHitMarker)
				end
				setElementFrozen(Bigfoot.ped,false)
			end,6500,1)
		end
	end
end)

function Bigfoot.specialHit()
	if(isTimer(Bigfoot.idleTimer))then killTimer(Bigfoot.idleTimer)end
	setPedAnimation(localPlayer,"Fight_B","FightB_G",-1,false)
	setTimer(function()
		setPedAnimation(localPlayer)
		Bigfoot.health = Bigfoot.health - 100
		if(Bigfoot.health < 1)then
			Bigfoot.createPickup()
			killPed(Bigfoot.ped)
			removeEventHandler("onClientRender",root,Bigfoot.movement)
			removeEventHandler("onClientRender",root,Bigfoot.healthUI)
			Levelsystem.Visible = true
		else
			setTimer(function()
				setPedAnimation(Bigfoot.ped)
				Bigfoot.status = "chasing"
				setElementFrozen(Bigfoot.ped,false)
			end,1000,1)
		end
	end,1000,1)
end

function Bigfoot.createPickup()
	local x,y,z = getElementPosition(Bigfoot.ped)
	Bigfoot.headPickup = createPickup(x,y,z,3,1254,50)
	setElementDimension(Bigfoot.headPickup,getElementDimension(Bigfoot.ped))
	triggerServerEvent("Bigfoot.Task",localPlayer)
	
	addEventHandler("onClientPickupHit",Bigfoot.headPickup,function(player)
		if(player == localPlayer)then
			destroyElement(source)
			triggerServerEvent("Bigfoot.collectHead",localPlayer)
		end
	end)
end

function Bigfoot.healthUI()
	if(isWindowOpen())then
		Levelsystem.Visible = false
		dxDrawRectangle(screenW/2 - 300, 50, 600, 30, tocolor(0, 0, 0, bossAlpha))
		 
		local healthWidth = (Bigfoot.health / 1000) * 600
		dxDrawRectangle(screenW/2 - 300, 50, healthWidth, 30, tocolor(200, 0, 0, bossAlpha))

		dxDrawRectangle(screenW/2 - 302, 48, 604, 2, tocolor(255, 50, 50, bossAlpha))
		dxDrawRectangle(screenW/2 - 302, 80, 604, 2, tocolor(255, 50, 50, bossAlpha))
		dxDrawRectangle(screenW/2 - 302, 50, 2, 30, tocolor(255, 50, 50, bossAlpha))
		dxDrawRectangle(screenW/2 + 300, 50, 2, 30, tocolor(255, 50, 50, bossAlpha))

		dxDrawText(bossName, screenW/2, 20, screenW/2, 20, tocolor(255, 0, 0, bossAlpha), 2, "pricedown", "center", "top")
		dxDrawText(bossName, screenW/2 + math.random(-effectSize, effectSize), 20 + math.random(-effectSize, effectSize), screenW/2, 20, tocolor(255, 100, 100, bossAlpha/2), 2.2, "pricedown", "center", "top")
	end
end

for i,v in ipairs(Bigfoot["InMarker"])do
	local marker = createMarker(v[1],v[2],v[3],"cylinder",3,0,0,0,0)
	apocalypseSetElementData(marker,"BigfootID",i)
	
	addEventHandler("onClientMarkerHit",marker,function(player)
		if(player == localPlayer and getElementType(player) == "player")then
			if(not(isPedInVehicle(localPlayer)))then
				if(getElementDimension(localPlayer) == getElementDimension(source))then
					if(hasPlayerItem(102) >= 1)then
						local dim = getFreeDimension()
						local ID = tonumber(apocalypseGetElementData(marker,"BigfootID"))
						local tbl = Bigfoot["PlayerSpawn"][ID]
						local outMarker = Bigfoot["OutMarker"][ID]
						
						Bigfoot.Object_Data[ID] = {}
						for _,v in pairs(Bigfoot["Objects"][ID])do
							local object = createObject(v[1],v[2],v[3],v[4],v[5],v[6],v[7])
							setElementDimension(object,dim)
							table.insert(Bigfoot.Object_Data[ID],object)
						end
						setTimer(function(ID)
							setElementPosition(localPlayer,tbl[1],tbl[2],tbl[3])
							setElementDimension(localPlayer,dim)
							apocalypseSetElementData(localPlayer,"BigfootID",ID)
							Bigfoot.createLobby(ID)
							
							Bigfoot.leaveMarker = createPickup(outMarker[1],outMarker[2],outMarker[3],3,1318,50)
							setElementDimension(Bigfoot.leaveMarker,getElementDimension(localPlayer))
							NPC.MeMessage(getText("MeMessage23"))
							
							addEventHandler("onClientPickupHit",Bigfoot.leaveMarker,function(player)
								if(player == localPlayer)then
									if(isPedDead(Bigfoot.ped))then
										if(not(isElement(Bigfoot.headPickup)))then
											local pos = Bigfoot["OutSpawn"][ID]
											setElementPosition(localPlayer,pos[1],pos[2],pos[3])
											setElementDimension(localPlayer,0)
											Bigfoot.CleanUp()
										else
											createInfobox(getText("CBigfoot1"))
										end
									else
										createInfobox(getText("CBigfoot2"))
									end
								end
							end)
							
							setTimer(function()
								NPC.MeMessage(getText("MeMessage24"))
							end,5000,1)
						end,500,1,ID)
					else
						NPC.MeMessage(getText("CBigfoot4"))
					end
				end
			end
		end
	end)
end

function Bigfoot.destroyObjects(ID)
	for _,v in pairs(Bigfoot.Object_Data[ID])do
		if(isElement(v))then
			destroyElement(v)
		end
	end
end