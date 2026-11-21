zombies = {
    speed = 2,
    limit = 50,
    moancount = 0,
    moanlimit = 10,
    everyZombie = {},

    ["Speed"] = {
        [1] = {"WALK_drunk",2000},
        [2] = {"run_old",1000},
        [3] = {"Run_Wuzi",680},
    },
	
	["Skins"] = {2,14,21,32,33,38,39,93,102,103,104,121,122,123,132,133,167,194,205,211,233,249,258,259,260},

    -- 5 Seltenheitsstufen
    -- Beispiel: 400/300/150/100/50 = 40% / 30% / 15% / 10% / 5%
    ["RarityWeights"] = {
        common    = 400,
        uncommon  = 300,
        rare      = 150,
        epic      = 100,
        legendary = 50,
    },
	
    ["RaritySkins"] = {
        common    = {14,21,233,38,39,258,194},
        uncommon  = {32,33,93,132,133,211,259},
        rare      = {102,103,104,121,122,123},
        epic      = {167,205,249,260},
        legendary = {2,13,31},
    },
	
	["RarityEXP"] = {
		common	  = 5,
		uncommon  = 10,
		rare 	  = 15,
		epic	  = 20,
		legendary = 25,
	},
	
	["ModelItem"] = {
		[2] = 205, 	-- Collectible Trading Card Pack
		[13] = 205, -- Collectible Trading Card Pack
		[31] = 205, -- Collectible Trading Card Pack
	},

    ["WeaponChance"] = 12,
    ["WeaponList"] = {
		1, -- Brassknuckle
		2, -- Golfclub
		3, -- Nightstick
		4, -- Knife
		5, -- Bat
		6, -- Shovel
		7, -- Poolstick
		8, -- Katana
    },
}

-- //

local ZombiePumpkinHead = {}

local Moan_Count = 0
local Moan_Limit = 10

local function weightedRarityPick(weights)
    local total = 0
    for _, w in pairs(weights) do
        total = total + tonumber(w or 0)
    end
    if total <= 0 then
        return "common"
    end

    local rnd = math.random(1, total)
    local acc = 0
    for rarity, w in pairs(weights) do
        acc = acc + tonumber(w or 0)
        if rnd <= acc then
            return rarity
        end
    end

    return "common"
end

local function pickZombieSkinByRarity()
    local rarity = weightedRarityPick(zombies["RarityWeights"])
    local list = zombies["RaritySkins"][rarity] or zombies["RaritySkins"]["common"]

    if not list or #list == 0 then
        rarity = "common"
        list = zombies["RaritySkins"]["common"]
    end

    local skin = list[math.random(1, #list)]
    return skin, rarity
end

local function giveRandomZombieWeapon(zomb)
    if not isElement(zomb) then return end

    local chance = tonumber(zombies["WeaponChance"]) or 0
    if math.random(1,100) > chance then
        return
    end

    local list = zombies["WeaponList"] or {}
    if #list <= 0 then return end

    local weaponID = list[math.random(1, #list)]
    giveWeapon(zomb, weaponID, 1, true)
    setElementData(zomb, "zombieWeapon", weaponID)
end

function ReduceMoancount()
	Moan_Count = math.max(0, Moan_Count - 1)
end

function zombies.setAnimation(zombie,anim)
	if(not(isElement(zombie)))then return end

	if(not(anim))then
		local rnd = math.random(1,10)
		if(rnd >= 1 and rnd <= 5)then anim = 2 end
		if(rnd >= 6 and rnd <= 8)then anim = 1 end
		if(rnd > 8)then anim = 3 end
	end
	anim = tonumber(anim)
	apocalypseSetElementData(zombie,"zomb_anim",zombies["Speed"][anim][1])
	apocalypseSetElementData(zombie,"zomb_checkspeed",zombies["Speed"][anim][2])
end

function zombies.moan(zombie)
	if(Moan_Count < Moan_Limit)then
		Moan_Count = Moan_Count + 1
		triggerClientEvent("zombies.moan",root,zombie)
		setTimer(ReduceMoancount,800,1)
	end
end

local function initializeZombie(zomb, rot, interior, dimension, rarity)
    if not isElement(zomb) then return false end

    if not interior then interior = 0 end
    if not dimension then dimension = 0 end
    if not rot then rot = math.random(1,359) end

    apocalypseSetElementData(zomb, "zombieRarity", rarity or "common")
    setElementData(zomb, "zombie", true)
    setElementData(zomb, "status", "spawning")
    setElementData(zomb, "target", nil, false)
    setElementData(zomb, "Tx", false, false)
    setElementData(zomb, "Ty", false, false)
    setElementData(zomb, "Tz", false, false)
    setElementData(zomb, "forcedtoexist", false)
    setElementData(zomb, "zombieStuckTicks", 0)

    zombies.setAnimation(zomb)

    setElementInterior(zomb, tonumber(interior))
    setElementDimension(zomb, tonumber(dimension))
    table.insert(zombies.everyZombie, zomb)

    giveRandomZombieWeapon(zomb)

    triggerClientEvent("zombies.deactivateVoice", getRootElement(), zomb)

    setTimer(function(z, r)
        if isElement(z) then
            setPedRotation(z, r)
        end
    end, 500, 1, zomb, rot)

    setTimer(function(z)
        if isElement(z) then
            setPedAnimation(z, "ped", apocalypseGetElementData(z, "zomb_anim"), -1, true, true, true)
        end
    end, 1000, 1, zomb)

    setTimer(function(z)
        if isElement(z) then
            setElementData(z, "status", "idle")
        end
    end, 2000, 1, zomb)

    return true
end

function createZombie(x,y,z,interior,dimension)
	if(not x)then return false end
	if(not y)then return false end
	if(not z)then return false end

	local rot = math.random(1,359)
	local skin, rarity = pickZombieSkinByRarity()

	if(not interior)then interior = 0 end
	if(not dimension)then dimension = 0 end

	local zomb = createPed(tonumber(skin), tonumber(x), tonumber(y), tonumber(z))
	if(not zomb or zomb == false)then
		return false
	end

    initializeZombie(zomb, rot, interior, dimension, rarity)
	return zomb
end

function zombies.clear(ped)
	if(isElement(ped))then
		if(getElementData(ped,"zombie") == true)then
			for theKey,thePed in ipairs(zombies.everyZombie)do
				if(ped == thePed)then
					table.remove(zombies.everyZombie,theKey)
					break
				end
			end
			if(isElement(ZombiePumpkinHead[ped]))then
				destroyElement(ZombiePumpkinHead[ped])
			end
			destroyElement(ped)
		end
	end
end

addEvent("zombies.headshot",true)
addEventHandler("zombies.headshot",root,function(ped,attacker,weapon,bodypart)
	if(getElementData(ped,"zombie") == true)then
		setPedHeadless(ped,true)
		killPed(ped,attacker,weapon,bodypart)
	end
end)

addEvent("zombies.lostPlayer",true)
addEventHandler("zombies.lostPlayer",root,function(x,y,z)
	setElementData(source,"Tx",x,false)
	setElementData(source,"Ty",y,false)
	setElementData(source,"Tz",z,false)
end)

addEvent("zombies.forceChase", true)
addEventHandler("zombies.forceChase", root, function(ped, target)
    if not isElement(ped) then return end
    if getElementType(ped) ~= "ped" then return end
    if getElementData(ped, "zombie") ~= true then return end
    if isPedDead(ped) then return end

    if isElement(target) then
        setElementData(ped, "target", target)
    end

    setElementData(ped, "status", "chasing")
    local px, py, pz = getElementPosition(ped)
    setTimer(zombies.Zomb_chase, 250, 1, ped, px, py, pz)
end)

function zombies.setangle()
	for theKey,ped in ipairs(zombies.everyZombie)do
		if(isElement(ped))then
			if(getElementData(ped,"status") == "chasing")then
				local x,y,z
				local px,py,pz
				if(getElementData(ped,"target") ~= nil)then
					if(isElement(getElementData(ped,"target")))then
						x,y,z = getElementPosition(getElementData(ped,"target"))
						px,py,pz = getElementPosition(ped)
					else
						setElementData(ped,"status","idle")
						x,y,z = getElementPosition(ped)
						px,py,pz = getElementPosition(ped)
					end
					local zombangle = (360-math.deg(math.atan2((x-px),(y-py))))%360
					setPedRotation(ped,zombangle)
				elseif(getElementData(ped,"target") == nil and getElementData(ped,"Tx") ~= false)then
					x = getElementData(ped,"Tx")
					y = getElementData(ped,"Ty")
					z = getElementData(ped,"Tz")
					px,py,pz = getElementPosition(ped)
					local zombangle = (360-math.deg(math.atan2((x-px),(y-py))))%360
					setPedRotation(ped,zombangle)
				end
			end
		end
	end
end

function zombies.clearFarZombies()
	if(newZombieLimit ~= false)then
		local toofarzombies = {}
		local allplayers = getElementsByType("player")
		for zombKey,theZomb in ipairs(zombies.everyZombie)do
			if(isElement(theZomb))then
				if(getElementData(theZomb,"zombie") == true)then
					local far = 1
					local Zx,Zy,Zz = getElementPosition(theZomb)
					for _,thePlayer in ipairs(allplayers)do
						local Px,Py,Pz = getElementPosition(thePlayer)
						local distance = getDistanceBetweenPoints3D(Px,Py,Pz,Zx,Zy,Zz)
						if(distance < 75)then
							far = 0
							break
						end
					end
					if(far == 1)then
						table.insert(toofarzombies,theZomb)
					end
				end
			else
				table.remove(zombies.everyZombie,zombKey)
			end
		end
		if(table.getn(toofarzombies) > 1)then
			for _,theZomb in ipairs(toofarzombies)do
				if(isElement(theZomb) and getElementData(theZomb,"zombie") == true and getElementData(theZomb,"forcedtoexist") ~= true)then
					zombies.clear(theZomb)
				end
			end
		end
	end
end

function zombies.idle(ped)
	if(isElement(ped))then
		if(getElementData(ped,"status") == "idle" and isPedDead(ped) == false and getElementData(ped,"zombie") == true)then
			local action = math.random(1,5)
			if(action < 5)then
				setPedRotation(ped,math.random(1,359))
				setPedAnimation(ped,"PED","Player_Sneak",-1,true,true,true)
				setTimer(zombies.idle,7000,1,ped)
			elseif(action == 5)then
				setPedAnimation(ped)
				setTimer(zombies.idle,4000,1,ped)
			end
			
			local x,y,z = getElementPosition(ped)
			local moneyPickup = createPickup(x,y,z,3,1212,50)
			addEventHandler("onPickupHit",moneyPickup,function(player)
				if(not(isPedInVehicle(player)))then
					if(getElementDimension(player) == getElementDimension(source))then
						givePlayerServerMoney(player,math.random(3,5))
						destroyElement(source)
					end
				end
			end)
			
			setTimer(function(pickup)
				if(isElement(pickup))then
					destroyElement(pickup)
				end
			end,15000,1,moneyPickup)
		end
	end
end

function zombies.bitten(player,attacker)
	if(not isElement(player) or not isElement(attacker))then return end

	local Zx,Zy,Zz = getElementPosition(attacker)
	local Px,Py,Pz = getElementPosition(player)
	local distance = getDistanceBetweenPoints3D(Px,Py,Pz,Zx,Zy,Zz)
	if(distance < 1)then
		killPed(player,attacker)
	else
		setPedAnimation(player)
	end
end

function zombies.outbreak()
	newZombieLimit = zombies.limit
	
	if(zombies.speed == 2)then
		MainTimer1 = setTimer(zombies.setangle,200,0)
	else
		MainTimer1 = setTimer(zombies.setangle,400,0)
	end
	MainTimer3 = setTimer(zombies.clearFarZombies,3000,0)
	MainTimer2 = setTimer(zombies.spawnZombie,2500,0)
end
setTimer(zombies.outbreak,1000,1)

function zombies.spawnZombie()
	local pacecount = 0
	while pacecount < 5 do
		if(table.getn(zombies.everyZombie)+pacecount < newZombieLimit)then
			local xcoord = 0
			local ycoord = 0
			local xdirection = math.random(1,2)
			if(xdirection == 1)then
				xcoord = math.random(15,40)
			else
				xcoord = math.random(-40,-15)
			end
			local ydirection = math.random(1,2)
			if(ydirection == 1)then
				ycoord = math.random(15,40)
			else
				ycoord = math.random(-40,-15)
			end
			
			local liveplayers = getAlivePlayers()
			if(table.getn(liveplayers) > 0)then
				local lowestcount = 99999
				local lowestguy = nil
				for _,thePlayer in ipairs(liveplayers)do
					if(isElement(thePlayer))then
						if(isCharacterLoggedIn(thePlayer) and getElementData(thePlayer,"inSafezone") == false and getElementInterior(thePlayer) == 0 and getElementDimension(thePlayer) == 0)then
							if(not(getElementData(thePlayer,"dangercount")))then
								setElementData(thePlayer,"dangercount",0)
							end
							if(getElementData(thePlayer,"dangercount") < lowestcount)then
								lowestguy = thePlayer
								lowestcount = getElementData(thePlayer,"dangercount")
							end
						end
					end
				end
				pacecount = pacecount + 1
				if(isElement(lowestguy))then
					triggerClientEvent("zombies.spawnPlacement",lowestguy,xcoord,ycoord)
				else
					pacecount = pacecount + 1
				end
			else
				pacecount = pacecount + 1
			end
		else
			pacecount = pacecount + 1
		end
	end
end

addEvent("zombies.onZombieSpawn",true)
addEventHandler("zombies.onZombieSpawn",root,function(gx,gy,gz,rot)
	if(table.getn(zombies.everyZombie) < newZombieLimit)then
		if(not(rot))then rot = math.random(1,359)end
		local skin, rarity = pickZombieSkinByRarity()
		local zomb = createPed(tonumber(skin), gx, gy, gz)

		if zomb and zomb ~= false then
			if(HalloweenEvent == true and math.random(1,2) == 2)then
				if(isElement(ZombiePumpkinHead[zomb]))then destroyElement(ZombiePumpkinHead[zomb])end
				ZombiePumpkinHead[zomb] = createObject(1935,0,0,0)
				exports.bone_attach:attachElementToBone(ZombiePumpkinHead[zomb],zomb,2,0,0,0.2,0,0,195)
				setElementCollisionsEnabled(ZombiePumpkinHead[zomb],false)
				setObjectScale(ZombiePumpkinHead[zomb],0.75)
				apocalypseSetElementData(zomb,"HalloweenPumpkin",true)
			end
		
			for _,v in pairs(Safezone["ZoneCoordinate"])do
				if(isPointInRectangle(gx,gy,v[1],v[2],v[3],v[4]))then
					destroyElement(zomb)
					if(isElement(ZombiePumpkinHead[zomb]))then
						destroyElement(ZombiePumpkinHead[zomb])
					end
					return
				end
			end

            initializeZombie(zomb, rot, 0, 0, rarity)
		end
	end
end)

addEvent("zombies.playereaten",true)
addEventHandler("zombies.playereaten",root,function(player,attacker,weapon,bodypart)
	killPed(player,attacker,weapon,bodypart)
end)

function zombies.reduceMoancount()
    zombies.moancount = zombies.moancount - 1
end

addEventHandler("onElementDataChange",root,function(dataName)
	if(getElementType(source) == "ped" and dataName == "status")then
		if(getElementData(source,"zombie") == true)then
			if(isPedDead(source) == false)then
				if(getElementData(source,"status") == "chasing")then
					local Zx,Zy,Zz = getElementPosition(source)
					setTimer(zombies.Zomb_chase,250,1,source,Zx,Zy,Zz)
					local newtarget = getElementData(source,"target")

					if(isElement(newtarget))then
						if(getElementType(newtarget) == "player")then
							setElementSyncer(source,newtarget)
						end
					end
					zombies.moan(source)
				elseif(getElementData(source,"status") == "idle")then
					setTimer(zombies.idle,1000,1,source)
				elseif(getElementData(source,"status") == "throatslashing")then
					local tx,ty,tz = getElementPosition(source)
					local ptarget = getElementData(source,"target")
					if(isElement(ptarget))then
						local vx,vy,vz = getElementPosition(ptarget)
						local zombiedistance = getDistanceBetweenPoints3D(tx,ty,tz,vx,vy,vz)
						if(zombiedistance < 0.8)then
							zombies.moan(source)
							if(isZombieImmuneActive(ptarget) == false and tonumber(apocalypseGetElementData(ptarget,"tutorialtask")) >= 8 and apocalypseGetElementData(ptarget,"WindowOpen") ~= true)then
								setPedAnimation(source,"knife","KILL_Knife_Player",-1,false,false,true)
								setPedAnimation(ptarget,"knife","KILL_Knife_Ped_Damage",-1,false,false,true)
								setTimer(zombies.bitten,2300,1,ptarget,source)
								setTimer(function(ped)
									if(isElement(ped))then
										setElementData(ped,"status","idle")
									end
								end,5000,1,source)
								for _,v in pairs(getElementsByType("player"))do
									if(isCharacterLoggedIn(v))then
										local x,y,z = getElementPosition(ptarget)
										triggerClientEvent(v,"throatslashingEffect",v,x,y,z)
									end
								end
							end
						else
							setElementData(source,"status","idle")
						end
					else
						setElementData(source,"status","idle")
					end
				end
			elseif(getElementData(source,"status") == "dead")then
				setTimer(zombies.clear,10000,1,source)
			end
		end
	end
end)

function zombies.Zomb_chase(ped,Zx,Zy,Zz)
	if(isElement(ped))then
		if(getElementData(ped,"status") == "chasing" and getElementData(ped,"zombie") == true)then
            local x,y,z = getElementPosition(ped)

            -- Anti-Stuck: wenn Zombie sich kaum bewegt, Chase hart neu anstoßen
            local movedDistance = getDistanceBetweenPoints3D(x,y,z,Zx or x,Zy or y,Zz or z)
            local stuckTicks = tonumber(getElementData(ped,"zombieStuckTicks")) or 0

            if movedDistance < 0.08 then
                stuckTicks = stuckTicks + 1
            else
                stuckTicks = 0
            end
            setElementData(ped, "zombieStuckTicks", stuckTicks, false)

            if stuckTicks >= 3 then
                setPedAnimation(ped, "ped", apocalypseGetElementData(ped,"zomb_anim"), -1, true, true, true)
                setTimer(zombies.Zomb_chase, 500, 1, ped, x, y, z)
                return
            end

			if(getElementData(ped,"target") == nil and getElementData(ped,"Tx") ~= false)then
				local Px = getElementData(ped,"Tx")
				local Py = getElementData(ped,"Ty")
				local Pz = getElementData(ped,"Tz")
				local Pdistance = getDistanceBetweenPoints3D(Px,Py,Pz,x,y,z)
				if(Pdistance < 1.5)then
					setTimer(function(p)
						if(isElement(p))then
							setElementData(p,"status","idle")
						end
					end,2000,1,ped)
				end
			end

			local distance = getDistanceBetweenPoints3D(x,y,z,Zx,Zy,Zz)
			if(distance < 1)then
				if(getElementData(ped,"target") == nil)then
					local giveup = math.random(1,15)
					if(giveup == 1)then
						setElementData(ped,"status","idle")
					else
						local action = math.random(1,2)
						if(action == 1)then
							setPedAnimation(ped)
							triggerClientEvent("zombies.zombPunch",root,ped)
							setTimer(function(p)
								if(isElement(p))then
									setPedAnimation(p,"ped",apocalypseGetElementData(p,"zomb_anim"),-1,true,true,true)
								end
							end,800,1,ped)
							setTimer(zombies.Zomb_chase,1200,1,ped,x,y,z)
						elseif(action == 2)then
							setPedAnimation(ped)
							triggerClientEvent("zombies.zombJump",root,ped)
							setTimer(function(p)
								if(isElement(p))then
									setPedAnimation(p,"ped",apocalypseGetElementData(p,"zomb_anim"),-1,true,true,true)
								end
							end,900,1,ped)
							setTimer(zombies.Zomb_chase,1800,1,ped,x,y,z)
						end
					end
				else
					local Ptarget = getElementData(ped,"target")
					if(isElement(Ptarget))then
						if(isZombieImmuneActive(Ptarget) == false)then
							if(apocalypseGetElementData(Ptarget,"WindowOpen") ~= true)then
								local Px,Py,Pz = getElementPosition(Ptarget)
								local Pdistance = getDistanceBetweenPoints3D(Px,Py,Pz,Zx,Zy,Zz)
								if(Pdistance < 1.2)then
									if(isPedDead(Ptarget))then
										setPedAnimation(ped)
										setPedAnimation(ped,"MEDIC","cpr",-1,false,true,false)
										setTimer(function(p)
											if(isElement(p))then
												setElementData(p,"status","idle")
											end
										end,10000,1,ped)
										setTimer(function(p)
											if(isElement(p))then
												setPedRotation(p,getPedRotation(p)-180)
											end
										end,10000,1,ped)
										zombies.moan(ped)
									else
										local action = math.random(1,6)
										if(action == 1)then
											setPedAnimation(ped)
											triggerClientEvent("zombies.zombJump",root,ped)
											setTimer(function(p)
												if(isElement(p))then
													setPedAnimation(p,"ped",apocalypseGetElementData(p,"zomb_anim"),-1,true,true,true)
												end
											end,900,1,ped)
											setTimer(zombies.Zomb_chase,1200,1,ped,x,y,z)
										else
											setPedAnimation(ped)
											triggerClientEvent("zombies.zombPunch",root,ped)
											setTimer(function(p)
												if(isElement(p))then
													setPedAnimation(p,"ped",apocalypseGetElementData(p,"zomb_anim"),-1,true,true,true)
												end 
											end,800,1,ped)
											setTimer(zombies.Zomb_chase,1200,1,ped,x,y,z)
										end
									end
								else
									if(isPedDead(Ptarget))then
										setTimer(function(p)
											if(isElement(p))then
												setElementData(p,"status","idle")
											end
										end,2000,1,ped)
										setTimer(function(p)
											if(isElement(p))then
												setPedRotation(p,getPedRotation(p)-180)
											end
										end,1800,1,ped)
									else
										local action = math.random(1,2)
										if(action == 1)then
											setPedAnimation(ped)
											triggerClientEvent("zombies.zombPunch",root,ped)
											setTimer(function(p)
												if(isElement(p))then
													setPedAnimation(p,"ped",apocalypseGetElementData(p,"zomb_anim"),-1,true,true,true)
												end
											end,800,1,ped)
											setTimer(zombies.Zomb_chase,1200,1,ped,x,y,z)
										elseif(action == 2)then
											setPedAnimation(ped)
											triggerClientEvent("zombies.zombJump",root,ped)
											setTimer(function(p)
												if(isElement(p))then
													setPedAnimation(p,"ped",apocalypseGetElementData(p,"zomb_anim"),-1,true,true,true)
												end
											end,900,1,ped)
											setTimer(zombies.Zomb_chase,1200,1,ped,x,y,z)
										end
									end
								end
							end
						end
					else
						setElementData(ped,"status","idle")
					end
				end
			else
				setPedAnimation(ped,"ped",apocalypseGetElementData(ped,"zomb_anim"),-1,true,true,true)
				setTimer(zombies.Zomb_chase,math.max(350, tonumber(apocalypseGetElementData(ped,"zomb_checkspeed")) or 1000),1,ped,x,y,z)
			end
		end
	end
end