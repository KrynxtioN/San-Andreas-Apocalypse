zombies = {["Skins"] = {2,13,14,21,31,32,33,38,39,93,102,103,104,121,122,123,132,133,167,194,205,211,233,249,258,259,260}}
	
myZombies = {}

function zombies.zombRelease()
	for k,v in pairs(myZombies)do
		if(isElement(v))then
			if(getElementData(v,"zombie") == true)then
				setElementData(v,"target",nil)
				setElementData(v,"status","idle")
				table.remove(myZombies,k)
			end
		end
	end
end

function zombies.resetalertspacer()
	zombies.alertspacer = nil
end

local function canBeSentToServerAsTarget(element)
	if not isElement(element) then return false end

	local elementType = getElementType(element)
	if elementType == "player" then
		return true
	end

	if elementType == "ped" and getElementData(element, "zombie") == true then
		return true
	end

	return false
end

local function forceZombieChaseSafe(theZomb, target)
	if not isElement(theZomb) then return end
	if getElementData(theZomb, "zombie") ~= true then return end
	if not isElement(target) then return end

	if canBeSentToServerAsTarget(target) then
		setElementData(theZomb, "target", target)
		triggerServerEvent("zombies.forceChase", localPlayer, theZomb, target)
	else
		local x, y, z = getElementPosition(target)
		setElementData(theZomb, "target", nil)
		triggerServerEvent("zombies.lostPlayer", theZomb, x, y, z)
		setElementData(theZomb, "status", "chasing")
	end
end

function zombies.ensureChase(theZomb)
	if not isElement(theZomb) then return end
	if getElementData(theZomb,"zombie") ~= true then return end
	if isPedDead(localPlayer) then return end

	local alreadyThere = false
	for _,ped in pairs(myZombies) do
		if ped == theZomb then
			alreadyThere = true
			break
		end
	end

	setElementData(theZomb,"status","chasing")
	setElementData(theZomb,"target",localPlayer)
	triggerServerEvent("zombies.forceChase", localPlayer, theZomb, localPlayer)

	if not alreadyThere then
		table.insert(myZombies,theZomb)
	end
end

function zombies.checkplayermoved(zomb,px,py,pz)
	if(isElement(zomb))then
		local nx,ny,nz = getElementPosition(localPlayer)
		local distance = getDistanceBetweenPoints3D(px,py,pz,nx,ny,nz)
		if(distance < 0.7 and isPedDead(localPlayer) == false)then
			setElementData(zomb,"status","throatslashing")
		end
	end
end

addEvent("throatslashingEffect",true)
addEventHandler("throatslashingEffect",root,function(x,y,z)
	local eff = createEffect("blood_heli", x, y, z + 1)
	setTimer(destroyElement, 2000, 1, eff)
end)

addEvent("zombies.spawnPlacement",true)
addEventHandler("zombies.spawnPlacement",root,function(xCoord, yCoord, posX, posY, posZ)
	local x, y, z = getElementPosition(localPlayer)
	if(posX and posY and posZ)then
		x, y, z = posX, posY, posZ
	else
		x, y, z = x + xCoord, y + yCoord, z
	end
	local gz = getGroundPosition(x ,y ,z + 500)
	triggerServerEvent("zombies.onZombieSpawn", localPlayer, x, y, gz + 1)
end)

addEvent("zombies.zombPunch",true)
addEventHandler("zombies.zombPunch",root,function(ped)
	if(isElement(ped))then
		setPedControlState(ped,"fire",true)
		setTimer(function(p)
			if(isElement(p))then
				setPedControlState(p,"fire",false)
			end
		end,800,1,ped)
	end
end)

function zombiesRadiusalert(theElement)
	local Px,Py,Pz = getElementPosition(theElement)
	local allPeds = getElementsByType("ped")
	for _,theZomb in ipairs(allPeds)do
		if(isElement(theZomb))then
			if(getElementData(theZomb,"zombie") == true)then
				if(getElementData(theZomb,"status") == "idle")then
					local Zx,Zy,Zz = getElementPosition(theZomb)
					local distance = getDistanceBetweenPoints3D(Px,Py,Pz,Zx,Zy,Zz)
					if(distance < 10 and isPedDead(localPlayer) == false)then
						local isthere = "no"
						for _,ped in pairs(myZombies)do
							if(ped == theZomb)then
								isthere = "yes"
								break
							end
						end
						if(isthere == "no" and getElementData(localPlayer,"zombie") ~= true)then
							if(getElementType(theElement) == "ped")then
								local isclear = isLineOfSightClear(Px,Py,Pz,Zx,Zy,Zz,true,false,false,true,false,false,false) 
								if(isclear == true)then
									zombies.ensureChase(theZomb)
								end
							else
								zombies.ensureChase(theZomb)
							end
						end
					end
				end
			end
		end
	end
end

addEventHandler("onClientPlayerWeaponFire",localPlayer,function(weapon,ammo,ammoInClip,hitX,hitY,hitZ,hitElement)
	if(zombies.alertspacer ~= 1)then
		if(weapon == 9)then
			zombies.alertspacer = 1
			setTimer(zombies.resetalertspacer,5000,1)
			zombiesRadiusalert(localPlayer)
		elseif(weapon > 21 and weapon ~= 23)then
			zombies.alertspacer = 1
			setTimer(zombies.resetalertspacer,5000,1)
			zombiesRadiusalert(localPlayer)
		end
	end

	if(hitElement)then
		if(getElementType(hitElement) == "ped")then
			if(getElementData(hitElement,"zombie") == true)then
				zombies.ensureChase(hitElement)
				zombiesRadiusalert(hitElement)
			end
		end
	end
end)

addEvent("zombies.zombJump",true)
addEventHandler("zombies.zombJump",root,function(ped)
	if(isElement(ped))then
		setPedControlState(ped,"jump",true)
		setTimer(function(p)
			if(isElement(p))then
				setPedControlState(p,"jump",false)
			end
		end,800,1,ped)
	end
end)

function zombies.check()
	if(getElementData(localPlayer,"zombie") ~= true and isPedDead(localPlayer) == false)then
		local zombiePeds = getElementsByType("ped",root,true)
		local Px,Py,Pz = getElementPosition(localPlayer)
		if(isPedDucked(localPlayer))then
			Pz = Pz-1
		end

		for theKey,theZomb in ipairs(zombiePeds)do
			if(isElement(theZomb))then
				local Zx,Zy,Zz = getElementPosition(theZomb)
				if(getDistanceBetweenPoints3D(Px,Py,Pz,Zx,Zy,Zz) < 45)then
					if(getElementData(theZomb,"zombie") == true)then
						if(getElementData(theZomb,"status") == "idle")then
							local isclear = isLineOfSightClear(Px,Py,Pz+1,Zx,Zy,Zz+1,true,false,false,true,false,false,false)
							if(isclear == true)then
								zombies.ensureChase(theZomb)
								table.remove(zombiePeds,theKey)
								zombiesRadiusalert(theZomb)
							end
						elseif(getElementData(theZomb,"status") == "chasing" and getElementData(theZomb,"target") == nil)then
							local isclear = isLineOfSightClear(Px,Py,Pz+1,Zx,Zy,Zz+1,true,false,false,true,false,false,false)
							if(isclear == true)then
								zombies.ensureChase(theZomb)
								table.remove(zombiePeds,theKey)
							end
						elseif(getElementData(theZomb,"target") == localPlayer)then
							local isclear = isLineOfSightClear(Px,Py,Pz+1,Zx,Zy,Zz+1,true,false,false,true,false,false,false)
							if(isclear == false)then
								setElementData(theZomb,"target",nil)
								triggerServerEvent("zombies.lostPlayer",theZomb,oldPx,oldPy,oldPz)
							else
								triggerServerEvent("zombies.forceChase", localPlayer, theZomb, localPlayer)
							end
						end
					end
				end
			end
		end
	
		local nonzombies = getElementsByType("ped", root, true)
		for _,theZomb in ipairs(zombiePeds)do
			if(isElement(theZomb))then
				if(getElementData(theZomb,"zombie") == true)then
					local Zx,Zy,Zz = getElementPosition(theZomb)
					for _,theNonZomb in ipairs(nonzombies)do
						if(getElementData(theNonZomb,"zombie") ~= true)then
							local nPx,nPy,nPz = getElementPosition(theNonZomb)
							if(getDistanceBetweenPoints3D(nPx,nPy,nPz,Zx,Zy,Zz) < 45)then
								local isclear = isLineOfSightClear(nPx,nPy,nPz+1,Zx,Zy,Zz+1,true,false,false,true,false,false,false)
								if(isclear == true and getElementHealth(theNonZomb) > 0)then
									if(getElementData(theZomb,"status") == "idle")then
										triggerServerEvent("zombies.lostPlayer",theZomb,nPx,nPy,nPz)
										setElementData(theZomb,"status","chasing")
										forceZombieChaseSafe(theZomb, theNonZomb)
										zombiesRadiusalert(theZomb)
									elseif(getElementData(theZomb,"status") == "chasing" and getElementData(theZomb,"target") == nil)then
										triggerServerEvent("zombies.lostPlayer",theZomb,nPx,nPy,nPz)
										forceZombieChaseSafe(theZomb, theNonZomb)
									end
								end					
							end		
							if(getElementData(theZomb,"target") == theNonZomb)then
								local pX,pY,pZ = getElementPosition(theNonZomb)
								if(getDistanceBetweenPoints3D(pX,pY,pZ,Zx,Zy,Zz) < 45)then
									local isclear = isLineOfSightClear(pX,pY,pZ+1,Zx,Zy,Zz+1,true,false,false,true,false,false,false)
									if(isclear == false)then
										triggerServerEvent("zombies.lostPlayer",theZomb,pX,pY,pZ)
										setElementData(theZomb,"target",nil)
									else
										if canBeSentToServerAsTarget(theNonZomb) then
											triggerServerEvent("zombies.forceChase", localPlayer, theZomb, theNonZomb)
										else
											triggerServerEvent("zombies.lostPlayer",theZomb,pX,pY,pZ)
											setElementData(theZomb,"target",nil)
											setElementData(theZomb,"status","chasing")
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end

	for k,ped in pairs(myZombies)do
		if(isElement(ped) == false)then
			table.remove(myZombies,k)
		end
	end

	oldPx,oldPy,oldPz = getElementPosition(localPlayer)
end

addEventHandler("onClientPlayerWasted",localPlayer,function()
	setTimer(zombies.zombRelease,4000,1)
end)

addEventHandler("onClientPedWasted",root,function(killer,weapon,bodypart)
	if(getElementData(source,"zombie") == true and getElementData(source,"status") ~= "dead")then
		setElementData(source,"target",nil)
		setElementData(source,"status","dead")
		setElementCollisionsEnabled(source,false)
	end
end)

addEventHandler("onClientPedDamage",root,function(attacker,weapon,bodypart)
	if(getElementType(source) == "ped")then
		if(getElementData(source,"zombie") == true)then
			zombies.ensureChase(source)
			if(bodypart == 9)then
				if(getElementModel(source) ~= 2 and getElementModel(source) ~= 13 and getElementModel(source) ~= 31)then
					triggerServerEvent("zombies.headshot",source,source,attacker,weapon,bodypart)
				end
			end
		end
	end
end)

addEventHandler("onClientPlayerDamage",localPlayer,function(attacker,weapon,bodypart)
	if(attacker)then
		if(getElementType(attacker) == "ped")then
			if(getElementData(attacker,"zombie") == true)then
				local playerHealth = getElementHealth(localPlayer)
				if(playerHealth < 15)then
					triggerServerEvent("zombies.playereaten",source,source,attacker,weapon,bodypart)
				end
			end
		end
	end
end)

addEventHandler("onClientElementDataChange",root,function(dataName)
	if(getElementType(source) == "ped" and dataName == "status")then
		local thestatus = getElementData(source,"status")
		if(thestatus == "idle" or thestatus == "dead")then
			for k,ped in pairs(myZombies)do
				if(ped == source and getElementData(ped,"zombie") == true)then
					setElementData(ped,"target",nil)
					table.remove(myZombies,k)
					setElementData(localPlayer,"dangercount",tonumber(table.getn(myZombies)))
					break
				end
			end
		elseif(thestatus == "chasing") then
			local found = false
			for _,ped in pairs(myZombies) do
				if ped == source then
					found = true
					break
				end
			end
			if not found and getElementData(source,"target") == localPlayer then
				table.insert(myZombies, source)
				setElementData(localPlayer,"dangercount",tonumber(table.getn(myZombies)))
			end
		end
	end
end)

function zombies.clientsetup()
	oldPx,oldPy,oldPz = getElementPosition(localPlayer)
	throatcol = createColSphere(0,0,0,0.3)
	
	addEventHandler("onClientColShapeHit",throatcol,function(theElement,matchingDimension)
		if(getElementType(theElement) == "ped" and isPedDead(localPlayer) == false)then
			if(getElementData(theElement,"target") == localPlayer and getElementData(theElement,"zombie") == true)then
				local px,py,pz = getElementPosition(localPlayer)
				setTimer(zombies.checkplayermoved,600,1,theElement,px,py,pz)
			end
		end
	end)
	
	for _,v in pairs(zombies["Skins"])do
		local skin_txd = engineLoadTXD("Files/Skins/Zombies/"..v..".txd")
		if(skin_txd)then
			engineImportTXD(skin_txd,v)
		end
		local skin_dff = engineLoadDFF("Files/Skins/Zombies/"..v..".dff")
		if(skin_dff)then
			engineReplaceModel(skin_dff,v)
		end
	end
end

function movethroatcol ()
	if isElement(throatcol) then
		local playerrot = getPedRotation ( getLocalPlayer () )
		local radRot = math.rad ( playerrot )
		local radius = 1
		local px,py,pz = getElementPosition( getLocalPlayer () )
		local tx = px + radius * math.sin(radRot)
		local ty = py + -(radius) * math.cos(radRot)
		local tz = pz
		setElementPosition ( throatcol, tx, ty, tz )
	end
end
addEventHandler ( "onClientRender", getRootElement(), movethroatcol )

function drawNearZombies()
	if(isWindowOpen())then
		if(InformationHelpBarOpen == false)then
			local screenWidth, screenHeight = guiGetScreenSize()
			local dcount = tostring(table.getn( myZombies ))
			dxDrawText( dcount, screenWidth-40, screenHeight -50, screenWidth, screenHeight, tocolor ( 0, 0, 0, 255 ), 1.44, "pricedown" )
			dxDrawText( dcount, screenWidth-42, screenHeight -52, screenWidth, screenHeight, tocolor ( 200, 15, 15, 255 ), 1.4, "pricedown" )
		end
	end
end

local NearZombiesDrawed = false

addEvent("drawNearZombies",true)
addEventHandler("drawNearZombies",root,function()
	if(NearZombiesDrawed == false)then
		NearZombiesDrawed = true
		addEventHandler("onClientRender",root,drawNearZombies)
	end
end)

function zombies.clientsetupload()
	setTimer(zombies.clientsetup,1500,1)
	MainClientTimer1 = setTimer(zombies.check,1000,0)
end
zombies.clientsetupload()

addEvent("zombies.moan",true)
addEventHandler("zombies.moan",root,function(ped)
	if(isElement(ped))then
		local zx,zy,zz = getElementPosition(ped)
		local sound = playSound3D("Files/Sounds/Zombies/mgroan"..math.random(1,10)..".ogg",zx,zy,zz,false)
		setSoundMaxDistance(sound,20)
	end
end)

addEvent("zombies.deactivateVoice",true)
addEventHandler("zombies.deactivateVoice",root,function(ped)
	if(isElement(ped))then
		setPedVoice(ped, "PED_TYPE_DISABLED")
	end
end)