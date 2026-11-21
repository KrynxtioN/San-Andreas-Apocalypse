OceanCleaner = { vehicle = {}, progress = {} }

local Achievements = {
	{100,190},{250,191},{500,192},{1000,193},{2500,194},{5000,195},
	{10000,196},{25000,197},{50000,198},{75000,199},{125000,200},{175000,201},{250000,202},
}

local OCEAN_MAX = {}
local TICK_MS = 1000
local DROP_X, DROP_Y, DROP_Z = 2671.7863769531, -2320.2060546875, -0.125
local DROP_RADIUS = 7

local function OceanCleanerStartTracking(player)
	if not isElement(player) then return end
	local veh = OceanCleaner.vehicle[player]
	if not isElement(veh) then return end

	OceanCleaner.progress[player] = OceanCleaner.progress[player] or {}
	local st = OceanCleaner.progress[player]
	st.cleaned = 0
	OCEAN_MAX[player] = 5000
	if(getSkillLevel(player, 6) >= 1)then
		OCEAN_MAX[player] = getSkillLevel(player, 6) * 10000
	end
	triggerClientEvent(player,"OceanCleaner.ocean_max",player,OCEAN_MAX[player])

	local x,y,z = getElementPosition(veh)
	st.lastX, st.lastY, st.lastZ = x,y,z

	if isTimer(st.timer) then killTimer(st.timer) end
	st.timer = setTimer(function(p)
		if not isElement(p) then return end
		local v = OceanCleaner.vehicle[p]
		local s = OceanCleaner.progress[p]
		if (not isElement(v)) or (not s) then
			if s and isTimer(s.timer) then killTimer(s.timer) end
			return
		end

		if getPedOccupiedVehicle(p) ~= v then
			return
		end

		local nx,ny,nz = getElementPosition(v)
		local dist = getDistanceBetweenPoints3D(s.lastX, s.lastY, s.lastZ, nx, ny, nz)

		if s.cleaned < OCEAN_MAX[p] then
			s.cleaned = math.floor(s.cleaned + (dist/2))
			if s.cleaned > OCEAN_MAX[p] then s.cleaned = OCEAN_MAX[p] end
		end

		s.lastX, s.lastY, s.lastZ = nx,ny,nz

		triggerClientEvent(p, "OceanCleaner.sync", p, s.cleaned)
	end, TICK_MS, 0, player)
end

local function OceanCleanerStopTracking(player)
	local st = OceanCleaner.progress[player]
	if st then
		if isTimer(st.timer) then killTimer(st.timer) end
	end
	OceanCleaner.progress[player] = nil
end

function OceanCleaner.start(player)
	if(getDistanceBetweenPoints3D(2721.7790527344,-2322.0744628906,3,getElementPosition(player)) <= 5)then
		if(not(isElement(OceanCleaner.vehicle[player])))then
			if(tonumber(apocalypseGetElementData(player,"level")) >= 50)then
				OceanCleaner.vehicle[player] = createVehicle(453,2738.0041503906,-2325.1088867188,0,0,0,0)
				warpPedIntoVehicle(player,OceanCleaner.vehicle[player])
				triggerClientEvent(player,"OceanCleaner.start",player)
				triggerClientEvent(player,"JobInformation.createWindow",player,2)
				apocalypseSetElementData(OceanCleaner.vehicle[player],"oceanCleanerOwner",getPlayerName(player))

				OceanCleanerStartTracking(player)

				addEventHandler("onVehicleExit",OceanCleaner.vehicle[player],function(p)
					OceanCleaner.stop(p)
				end)

				addEventHandler("onVehicleExplode",OceanCleaner.vehicle[player],function()
					local owner = apocalypseGetElementData(source,"oceanCleanerOwner")
					local p = getPlayerFromName(owner)
					if(isElement(p))then
						OceanCleaner.stop(p)
					end
					destroyElement(source)
				end)
			end
		end
	end
end

function OceanCleaner.stop(player)
	OceanCleanerStopTracking(player)

	if(isElement(OceanCleaner.vehicle[player]))then
		destroyElement(OceanCleaner.vehicle[player])
		OceanCleaner.vehicle[player] = nil
		if(not(isPedDead(player)))then
			setTimer(function(p)
				setElementPosition(p,2722.6235351562,-2323.330078125,3)
				setElementRotation(p,0,0,270)
			end,50,1,player)
		end
		triggerClientEvent(player,"OceanCleaner.destroy",player)
	end
end

addEvent("OceanCleaner.finish",true)
addEventHandler("OceanCleaner.finish",root,function()
	if(getPedOccupiedVehicle(client) ~= OceanCleaner.vehicle[client]) then
		return
	end

	local veh = OceanCleaner.vehicle[client]
	local vx,vy,vz = getElementPosition(veh)
	if getDistanceBetweenPoints3D(vx,vy,vz, DROP_X, DROP_Y, DROP_Z) > DROP_RADIUS then
		return
	end

	local st = OceanCleaner.progress[client]
	local cleaned = (st and tonumber(st.cleaned)) or 0
	cleaned = math.max(0, math.min(OCEAN_MAX, cleaned))

	local Level_Bonus_EXP = tonumber(apocalypseGetElementData(client,"level"))
	if(Level_Bonus_EXP > 100)then Level_Bonus_EXP = 100 end

	NPC.MeMessage(client,getText(client,"SOceanCleaner1"):format(cleaned))

	local level_bonus = math.floor(cleaned/250)
	local skillPoints = math.floor(cleaned / 500)
	local shells = math.floor(cleaned/100*1)
	local xp = math.floor(cleaned/2) + (Level_Bonus_EXP * level_bonus)
	local money = math.floor(cleaned/100*25)

	if(SERVERBONUS.JOB_ACTIVITIES == true)then
		skillPoints = skillPoints * 2
		shells = shells * 2
		xp = xp * 2
		money = money * 2
	end

	if(skillPoints > 0)then
		givePlayerSkillpoint(client, skillPoints)
	end
	givePlayerServerMoney(client,money)
	giveEXP(client,xp)
	if(shells >= 1)then
		giveItem(client,67,shells)
		triggerClientEvent(client, "showItemBar", client, {{67,shells}})
	end

	local ocean_cleaned = tonumber(getPlayerData("character_stats","character_id",getCharacterID(client),"ocean_cleaned"))
	Characters.addStats(client,"ocean_cleaned",ocean_cleaned + cleaned)
	outputLog(getPlayerName(client).." hat $"..(cleaned/100*25) ..", "..math.floor(cleaned/2).." EXP und "..skillPoints.." Skillpunkte bekommen", "Ocean Cleaner", getCharacterID(client))

	for _,v in pairs(Achievements)do
		if(ocean_cleaned + cleaned >= v[1])then
			setAchievement(client,v[2])
		end
	end

	if(DailyTasks.playerTasks[client][16])then
		DailyTasks.updateProgress(client,16,DailyTasks.playerTasks[client][16].progress + cleaned)
	end

	if(WeeklyTasks.playerTasks[client][16])then
		WeeklyTasks.updateProgress(client,16,WeeklyTasks.playerTasks[client][16].progress + cleaned)
	end

	if st then st.cleaned = 0 end
end)

addEventHandler("onPlayerQuit",root,function()
	OceanCleanerStopTracking(source)
	if(isElement(OceanCleaner.vehicle[source]))then
		destroyElement(OceanCleaner.vehicle[source])
	end
end)

addEventHandler("onPlayerWasted",root,function()
	OceanCleaner.stop(source)
end)