Holzfaeller = {
	stamm = {},
	vehicle = {},
	sawing = false,
	woodSaw = false,
	timer = {},
	stammtimer = {},
	active = {},

	trees = {},
	woodObjects = {},

	["Trees"] = {
	
		-- Forest 1
		{615, -628.79999, -683.5, 39.7},
		{615, -642.09998, -670.90002, 40.9},
		{615, -638.40002, -680.29999, 42.4},
		{615, -629.79999, -663.40002, 35.4},
		{615, -621.59998, -675.40002, 36.3},
		{615, -610.70001, -671.59998, 33},
		{615, -631, -676.29999, 39},
		{615, -640.09998, -658.90002, 37.2},
		{615, -650, -669.59998, 43.2},
		{615, -650.90002, -659.29999, 40.4},
		{615, -663.79999, -661.59998, 45.2},
		{615, -674.40002, -661.29999, 48.6},
		{615, -662.59998, -653, 42.2},
		{615, -673.29999, -652.59998, 45.4},
		{615, -649.20001, -647.40002, 37.3},
		{615, -638.5, -650.90002, 35.5},
		{615, -632.40002, -655.20001, 34.7},
		{615, -619.59998, -660.40002, 32.6},
		{615, -618.5, -671.79999, 34.8},
		{615, -607.29999, -664.20001, 30.2},
		{615, -657.5, -642.29999, 38.4},
		{615, -666.5, -642, 40.8},
		{615, -675.70001, -643.09998, 43.6},
		{615, -682.70001, -638.09998, 44.4},
		{615, -693.5, -641.09998, 47.8},
		{615, -683.5, -648.70001, 47.5},
		{615, -690.90002, -651.09998, 50},
		{615, -684, -656.90002, 49.8},
		
		-- Forest 2
		{615, -2606.599609375, -2212.3994140625, 25.299999237061},
		{615, -2597.1999511719, -2198.3999023438, 26.299999237061},
		{615, -2602, -2226, 24.299999237061},
		{615, -2592.099609375, -2216.099609375, 26.799999237061},
		{615, -2590.8999023438, -2233.1999511719, 24.299999237061},
		{615, -2570, -2180.8999023438, 28.89999961853},
		{615, -2577, -2190.3994140625, 28.200000762939},
		{615, -2584.3994140625, -2205.2998046875, 27.39999961853},
		{615, -2581.5, -2219.6999511719, 27.60000038147},
		{615, -2578.1000976563, -2233.1000976563, 25.89999961853},
		{615, -2569.7001953125, -2228.7998046875, 27.700000762939},
		{615, -2565.3999023438, -2214.5, 29},
		{615, -2573.8999023438, -2208.3000488281, 28.39999961853},
		{615, -2566.8999023438, -2200.8999023438, 28.89999961853},
		{615, -2565.1000976563, -2189.5, 29},
		
		-- Forest 3
		{615, -1865.4000244141, -2666.6999511719, 53.900001525879},
		{615, -1852.0999755859, -2662.8000488281, 53.700000762939},
		{615, -1840, -2659.1999511719, 53.200000762939},
		{615, -1873.9000244141, -2658.1999511719, 54.400001525879},
		{615, -1863, -2651.8000488281, 54.299999237061},
		{615, -1848.5, -2650.099609375, 53.799999237061},
		{615, -1835.400390625, -2647.3994140625, 53.900001525879},
		{615, -1874.4000244141, -2646.6000976563, 54.200000762939},
		{615, -1860.2001953125, -2639.7998046875, 54.200000762939},
		{615, -1870.0999755859, -2634.3999023438, 54},
		{615, -1860.5, -2628.3999023438, 54.799999237061},
		{615, -1846.3000488281, -2636.6000976563, 54.599998474121},
		{615, -1850.5999755859, -2625.8999023438, 55.400001525879},
		{615, -1839, -2623.7001953125, 55.5},
		{615, -1827.900390625, -2623.2001953125, 54.900001525879},
		{615, -1831.8000488281, -2635.8999023438, 54.700000762939},
		{615, -1820.0999755859, -2644.8000488281, 54.099998474121},
		{615, -1826.3000488281, -2657.5, 53.700000762939},
		{615, -1816.099609375, -2622.7001953125, 54},
		{615, -1814.5999755859, -2634.3999023438, 53.799999237061},
		{615, -1806.2001953125, -2643.5, 53.099998474121},
		{615, -1814.400390625, -2656.099609375, 53.700000762939},
		{615, -1804.5, -2625.3999023438, 52.599998474121},
		{615, -1792.0999755859, -2631, 51.099998474121},
		{615, -1797.8000488281, -2637.6999511719, 52.200000762939},
		{615, -1782, -2638, 50.099998474121},
		{615, -1800.900390625, -2654.8994140625, 53},
		{615, -1789.599609375, -2649.3994140625, 52.200000762939},
		{615, -1778, -2650.3999023438, 50.700000762939},
	},
	["Staemme"] = {
		[1] = {1.1, -2.3, 0.3, 0, 45, 0},
		[2] = {0.5, -2.3, 0.3, 0, 90, 0},
		[3] = {-0.1, -2.3, 0.3, 0, 135, 0},
		[4] = {-0.7, -2.3, 0.3, 0, 180, 0},
		[5] = {-1.0, -2.3, 0.7, 0, 225, 0},
		[6] = {-0.4, -2.3, 0.7, 0, 270, 0},
		[7] = {0.2, -2.3, 0.7, 0, 315, 0},
		[8] = {0.8, -2.3, 0.7, 0, 0, 0},
	},
}

Holzfaeller.saw = createObject(1962, -2015.6, -2349.5, 31.3, 0, 0, 135)
setObjectScale(Holzfaeller.saw, 1.5)

local Achievements = {
	{1,238},
	{5,239},
	{10,240},
	{25,241},
	{50,242},
	{75,243},
	{125,244},
	{127,245},
	{250,246},
}

local Achievements2 = {
	{1,247},
	{5,248},
	{10,249},
	{25,250},
	{50,251},
	{75,252},
	{125,253},
	{175,254},
	{250,255},
}

function Holzfaeller.cTree(id, model, x, y, z)
	local baum = createObject(model, x, y, z, 0, 0, math.random(0, 360))
	local ped = createPed(0, x, y, z, 0)
	setElementFrozen(ped, true)
	setElementAlpha(ped, 0)
	attachElements(ped, baum)
	apocalypseSetElementData(baum, "baum", true)
	apocalypseSetElementData(ped, "baum", true)
	apocalypseSetElementData(ped, "attached", baum)
	apocalypseSetElementData(ped, "hits", 0)
	apocalypseSetElementData(baum, "baumID", id)
	apocalypseSetElementData(ped, "baumID", id)
	Holzfaeller.trees[id] = {baum = baum, ped = ped}
end

function Holzfaeller.takeStammFromGround(player)
	local veh = getPedOccupiedVehicle(player)
	local Staemme = apocalypseGetElementData(veh, "Staemme")
	if(veh)then
		if Staemme and Staemme < 8 then
			local Stamm = createObject(684, 0, 0, 0)
			setObjectScale(Stamm, 0.7)
			setElementCollisionsEnabled(Stamm, false)
			local Position = Staemme + 1
			local tbl = Holzfaeller["Staemme"][Position]
			attachElements(Stamm, veh, tbl[1], tbl[2], tbl[3], tbl[4], tbl[5], tbl[6])
			apocalypseSetElementData(Stamm, "holzfaellerOwner", getPlayerName(player))
			apocalypseSetElementData(veh, "Staemme", Staemme + 1)
			apocalypseSetElementData(Stamm, "id", apocalypseGetElementData(veh, "Staemme"))
			local owner = getPlayerName(player)
			if not Holzfaeller.woodObjects[owner] then
				Holzfaeller.woodObjects[owner] = {}
			end
			table.insert(Holzfaeller.woodObjects[owner], Stamm)
		end
	end
end

function Holzfaeller.fellTree(ped, faeller)
	local baum = apocalypseGetElementData(ped, "attached")
	local x, y, z = getElementPosition(baum)
	moveObject(baum, 3500, x, y, z, 0, 80, 0)
	setElementCollisionsEnabled(baum, false)
	local baumID = apocalypseGetElementData(baum, "baumID")
	
	local cut_trees = tonumber(getPlayerData("character_stats","character_id",getCharacterID(faeller),"cut_trees"))
	Characters.addStats(faeller,"cut_trees",cut_trees + 1)
	
	for _,v in pairs(Achievements)do
		if(cut_trees + 1 >= v[1])then
			setAchievement(faeller,v[2])
		end
	end
	
	if(DailyTasks.playerTasks[faeller][19])then
		DailyTasks.updateProgress(faeller,19,DailyTasks.playerTasks[faeller][19].progress + 1)
	end
	
	if(WeeklyTasks.playerTasks[faeller][19])then
		WeeklyTasks.updateProgress(faeller,19,WeeklyTasks.playerTasks[faeller][19].progress + 1)
	end
	
	setTimer(function(baum, baumID, faeller)
		apocalypseSetElementData(baum, "baumOwner", getPlayerName(faeller))
		apocalypseSetElementData(baum, "fallen", true)
		setElementCollisionsEnabled(baum, true)
		
		Holzfaeller.timer[baumID] = setTimer(function(baum)
			if isElement(baum) then
				local entry = Holzfaeller.trees[baumID]
				if entry then
					if isElement(entry.baum) then destroyElement(entry.baum) end
					if isElement(entry.ped) then destroyElement(entry.ped) end
					Holzfaeller.trees[baumID] = nil
				end
				Holzfaeller.cTree(baumID, 615, x, y, z)
			end
		end, 120000, 1, baum)
	end, 3500, 1, baum, baumID, faeller)
	destroyElement(ped)
end

for i, v in pairs(Holzfaeller["Trees"]) do
	Holzfaeller.cTree(i, v[1], v[2], v[3], v[4])
end

function Holzfaeller.baumDamage(ped, attacker)
	if isElement(ped) then
		if(Holzfaeller.active[attacker] == true)then
			if apocalypseGetElementData(ped, "baum") == true then
				apocalypseSetElementData(ped, "hits", apocalypseGetElementData(ped, "hits") + 1)
				if apocalypseGetElementData(ped, "hits") >= 25 then
					Holzfaeller.fellTree(ped, attacker)
				end
			end
		end
	end
end
addEvent("Holzfaeller.baumDamage", true)
addEventHandler("Holzfaeller.baumDamage", root, Holzfaeller.baumDamage)

addEvent("Holzfaeller.holzAbgabe", true)
addEventHandler("Holzfaeller.holzAbgabe", root, function()
	if isPedInVehicle(client) then
		local veh = getPedOccupiedVehicle(client)
		if(veh)then
			if apocalypseGetElementData(veh, "holztruck") == true then
				local Staemme = apocalypseGetElementData(veh, "Staemme")
				if Staemme >= 1 then
					local money = Staemme * 100
					local owner = getPlayerName(client)
					local xp = Staemme * 50
					local skillpoint = Staemme * 2
					if(SERVERBONUS.JOB_ACTIVITIES == true)then
						money = money * 2
						xp = xp * 2
						skillpoint = skillpoint * 2
					end
					
					if Holzfaeller.woodObjects[owner] then
						for _, v in ipairs(Holzfaeller.woodObjects[owner]) do
							if isElement(v) then
								destroyElement(v)
							end
						end
						Holzfaeller.woodObjects[owner] = {}
					end
					givePlayerServerMoney(client, money)
					giveEXP(client, xp)
					givePlayerSkillpoint(client, skillpoint)
					apocalypseSetElementData(veh, "Staemme", 0)
					outputLog(getPlayerName(client).." hat "..xp .." EXP, $"..money .." und "..skillpoint.." Skillpunkte bekommen", "Holzfafeller", getCharacterID(client))
				end
			end
		end
	end
end)

function startLumberjackJob(player)
	if(getDistanceBetweenPoints3D(-2003.8640136719,-2362.8515625,30.625,getElementPosition(player)) <= 5)then
		if not isElement(Holzfaeller.vehicle[player]) then
			Holzfaeller.active[player] = true
			Holzfaeller.vehicle[player] = createVehicle(455, -1989.4000244141, -2384, 31.200000762939, 0, 0, 315)
			apocalypseSetElementData(Holzfaeller.vehicle[player], "holztruck", true)
			setVehicleVariant(Holzfaeller.vehicle[player], 3, 255)
			warpPedIntoVehicle(player, Holzfaeller.vehicle[player])
			apocalypseSetElementData(Holzfaeller.vehicle[player], "holzfaellerOwner", getPlayerName(player))
			apocalypseSetElementData(Holzfaeller.vehicle[player], "Staemme", 0)
			triggerClientEvent(player, "Holzfaeller.createMarker", player, "create")
			
			addEventHandler("onVehicleExplode", Holzfaeller.vehicle[player], function()
				local holzfaellerOwner = getPlayerFromName(apocalypseGetElementData(source, "holzfaellerOwner"))
				Holzfaeller.destroy(holzfaellerOwner)
			end)
			
			addEventHandler("onVehicleStartEnter", Holzfaeller.vehicle[player], function(player)
				if isElement(Holzfaeller.stamm[player]) then
					cancelEvent()
				else
					if getPlayerName(player) ~= apocalypseGetElementData(source, "holzfaellerOwner") then
						if getPedOccupiedVehicleSeat(player) == 0 then
							cancelEvent()
						end
					end
				end
			end)
			bindKey(player, "backspace", "down", Holzfaeller.destroy)
			triggerClientEvent(player,"JobInformation.createWindow",player,1)
			addEventHandler("onElementClicked", Holzfaeller.vehicle[player], Holzfaeller.takeStammFromTransporter)
		end
	end
end

function Holzfaeller.takeStammFromTransporter(button, state, player)
	if button == "left" and state == "down" then
		if not isPedInVehicle(player) then
			local holzfaellerOwner = apocalypseGetElementData(source, "holzfaellerOwner")
			if getPlayerName(player) == holzfaellerOwner then
				local veh = Holzfaeller.vehicle[player]
				local Staemme = apocalypseGetElementData(veh, "Staemme")
				if Staemme >= 1 then
					if getDistanceBetweenPoints3D(-2012.6279296875, -2350.1589355469, 30.625 - 1, getElementPosition(player)) <= 25 then
						if not isElement(Holzfaeller.stamm[player]) then
							local owner = getPlayerName(player)
							if Holzfaeller.woodObjects[owner] then
								for index, v in ipairs(Holzfaeller.woodObjects[owner]) do
									if apocalypseGetElementData(v, "id") == apocalypseGetElementData(veh, "Staemme") then
										destroyElement(v)
										table.remove(Holzfaeller.woodObjects[owner], index)
										break
									end
								end
							end
							apocalypseSetElementData(veh, "Staemme", Staemme - 1)
							Holzfaeller.stamm[player] = createObject(684, -2013.1999511719, -2351.8999023438, 31.10000038147, 0, 0, 0)
							setObjectScale(Holzfaeller.stamm[player], 0.7)
							attachElements(Holzfaeller.stamm[player], player, 0.4, 0, -0.1)
							apocalypseSetElementData(Holzfaeller.stamm[player], "baumstamm", true)
							setElementCollisionsEnabled(Holzfaeller.stamm[player], false)
							toggleControl(player, "sprint", false)
							apocalypseSetElementData(veh, "Staemme", apocalypseGetElementData(veh, "Staemme") - 1)
						end
						
						Holzfaeller.stammtimer[player] = setTimer(function(player)
							if isElement(Holzfaeller.stamm[player]) then
								if getDistanceBetweenPoints3D(-2012.6279296875, -2350.1589355469, 30.625 - 1, getElementPosition(player)) >= 25 then
									destroyElement(Holzfaeller.stamm[player])
									if isTimer(Holzfaeller.stammtimer[player]) then
										killTimer(Holzfaeller.stammtimer[player])
										Holzfaeller.takeStammFromGround(player)
									end
								end
							end
						end, 1000, 0, player)
					end
				end
			end
		end
	end
end

function Holzfaeller.turnSaw()
	if Holzfaeller.sawing == true then
		moveObject(Holzfaeller.saw, 250, -2015.6, -2349.5, 31.3, 0, -360, 0)
	end
	setTimer(function() Holzfaeller.turnSaw() end, 250, 1)
end

addEvent("Holzfaeller.cutWood", true)
addEventHandler("Holzfaeller.cutWood", root, function()
	if Holzfaeller.woodSaw == false then
		if isElement(Holzfaeller.stamm[client]) then
			Holzfaeller.woodSaw = true
			toggleControl(client, "sprint", true)
			local StammTable = getAttachedElements(client)
			for _, v in pairs(StammTable) do
				if apocalypseGetElementData(v, "baumstamm") == true then
					destroyElement(v)
				end
			end
			Holzfaeller.turnSaw()
			local HolzfaellerStamm = createObject(684, -2013.1999511719, -2351.8999023438, 31.10000038147, 0, 0, 45)
			setObjectScale(HolzfaellerStamm, 0.7)
			setTimer(function(client)
				moveObject(HolzfaellerStamm, 30000, -2017.8000488281, -2347.3000488281, 31.10000038147, 0, 0, 0)
                setTimer(function(client)
                    moveObject(HolzfaellerStamm, 2500, -2018.4000244141, -2346.5, 30.5, -14, 0, 0)
                    setTimer(function(client)
                        Holzfaeller.sawing = false
                        Holzfaeller.woodSaw = false
                        destroyElement(HolzfaellerStamm)
						Holzfaeller.addWood(client)
						
						local trees_to_wood = tonumber(getPlayerData("character_stats","character_id",getCharacterID(client),"trees_to_wood"))
						Characters.addStats(client,"trees_to_wood",trees_to_wood + 1)
						
						for _,v in pairs(Achievements2)do
							if(trees_to_wood + 1 >= v[1])then
								setAchievement(client,v[2])
							end
						end
                    end, 2700, 1, client)
                end, 30100, 1, client)
                Holzfaeller.sawing = true
			end, 1000, 1, client)
			if isTimer(Holzfaeller.stammtimer[client]) then killTimer(Holzfaeller.stammtimer[client]) end
		end
	end
end)

function Holzfaeller.addWood(player)
	local wood = math.random(7,15)
	local xp,skillpoint = 75,5
	if(SERVERBONUS.JOB_ACTIVITIES == true)then
		xp = xp * 2
		skillpoint = skillpoint * 2
		wood = wood * 2
	end
	giveItem(player,34,wood)
	giveEXP(player,xp)
	givePlayerSkillpoint(player,skillpoint)
	outputLog(getPlayerName(player).." hat "..wood .."x Holz, "..xp.." EXP und "..skillpoint.." Skillpoints bekommen", "Holzfafeller", getCharacterID(player))
end

function Holzfaeller.destroy(player)
	if isElement(Holzfaeller.vehicle[player]) then 
		destroyElement(Holzfaeller.vehicle[player])
	end
	if isElement(Holzfaeller.stamm[player]) then 
		destroyElement(Holzfaeller.stamm[player])
	end

	local owner = getPlayerName(player)
	if Holzfaeller.woodObjects[owner] then
		for _, wood in ipairs(Holzfaeller.woodObjects[owner]) do
			if isElement(wood) then
				destroyElement(wood)
			end
		end
		Holzfaeller.woodObjects[owner] = {}
	end
	
	if isTimer(Holzfaeller.stammtimer[player]) then 
		killTimer(Holzfaeller.stammtimer[player])
	end
	Holzfaeller.active[player] = false
	takeWeapon(player, 9)
	unbindKey(player, "backspace", "down", Holzfaeller.destroy)
	triggerClientEvent(player, "Holzfaeller.createMarker", player)
end

addEventHandler("onPlayerClick",root,function(button,state,clickedElement)
	if(state == "down" and button == "left")then
		if(clickedElement and isElement(clickedElement))then
			local x,y,z = getElementPosition(source)
			local ox,oy,oz = getElementPosition(clickedElement)
			local model = getElementModel(clickedElement)
				
			if(clickedElement)then
				if(model == 615 and apocalypseGetElementData(clickedElement,"fallen") == true)then
					if(getDistanceBetweenPoints3D(ox,oy,oz,x,y,z) <= 15)then
						if(isPedInVehicle(source))then
							if(apocalypseGetElementData(getPedOccupiedVehicle(source),"holztruck") == true)then
								if(apocalypseGetElementData(clickedElement,"baumOwner") == getPlayerName(source))then
									destroyElement(clickedElement)
									Holzfaeller.takeStammFromGround(source)
								end
							end
						end
					end
				end
			end
		end
	end
end)

addEventHandler("onPlayerQuit", root, function() 
	Holzfaeller.destroy(source) 
end)

addEventHandler("onPlayerWasted", root, function() 
	Holzfaeller.destroy(source) 
end)