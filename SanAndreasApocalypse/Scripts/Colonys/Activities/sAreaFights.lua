LaboratoryFights = {Data = {}, ["Active"] = {},
	["Names"] = {
		["EN"] = {
			[1] = "Drug Laboratory of the San Fierro Rippers",
			[2] = "Drub Laboratory (Ship)",
		},
		["DE"] = {
			[1] = "Drogenlabor der San Fierro Rippers",
			[2] = "Drogenlabor (Schiff)",
		},
		["RU"] = {
			[1] = "Наркологическая лаборатория банды San Fierro Rippers",
			[2] = "Наркологическая лаборатория (Корабль)",
		},
		["PT"] = {
			[1] = "Laboratório de drogas dos San Fierro Rippers",
			[2] = "Laboratório de drogas (Navio)",
		},
	},
	["Rewards"] = {
		[1] = {
			money = 75,
			experience = 325,
			brain_mass = 50,
		},
		[2] = {
			money = 50,
			experience = 250,
			brain_mass = 25,
		},
	},
}

local PREP_MS  = 30000
local FIGHT_MS = 900000

function LaboratoryFights.getColonyRGB(colony)
	local color = getColonyColor(colony)
	if color and color[1] and color[2] and color[3] then
		return color[1], color[2], color[3]
	end
	return 255, 255, 255
end

function LaboratoryFights.setAreaOwnerColor(ID, colony)
	local r, g, b = LaboratoryFights.getColonyRGB(colony)
	setRadarAreaFlashing(LaboratoryFights[ID], false)
	setRadarAreaColor(LaboratoryFights[ID], r, g, b, 125)
end

function LaboratoryFights.broadcastMessage(ID, messageType)
	local attacker = LaboratoryFights.Data[ID]["Attacker"]
	local defender = LaboratoryFights.Data[ID]["Defender"]

	local attackerName = getPlayerData("colonys","ID",attacker,"name") or "Unbekannt"
	local defenderName = getPlayerData("colonys","ID",defender,"name") or "Unbekannt"

	for _, player in pairs(getElementsByType("player")) do
		if isCharacterLoggedIn(player) then
			local lang = apocalypseGetElementData(player, "language") or "EN"
			local areaName = LaboratoryFights["Names"][lang] and LaboratoryFights["Names"][lang][ID] or ("Labor #" .. tostring(ID))

			if messageType == "start" then
				outputChatBox(getText(player,"SLaboratoryFights12"):format(attackerName,areaName,defenderName), player, 150, 0, 0)
			elseif messageType == "attacker_win" then
				outputChatBox(getText(player,"SLaboratoryFights13"):format(attackerName,areaName,defenderName), player, 0, 150, 0)
			elseif messageType == "defender_win" then
				outputChatBox(getText(player,"SLaboratoryFights13"):format(defenderName,areaName,attackerName), player, 200, 150, 50)
			end
		end
	end
end

function LaboratoryFights.loadAreas()
	local result = dbPoll(dbQuery(handler,"SELECT * FROM colonyareas"),-1)
	if(#result >= 1)then
		for _,v in pairs(result)do
			local ID = v["ID"]
			local x1,y1 = tonumber(v["x1"]),tonumber(v["y1"])
			local x2,y2 = tonumber(v["x2"]),tonumber(v["y2"])
			local xs,ys = math.abs(x1-x2),math.abs(y1-y2)
			local owner = v["owner"]
			local px,py,pz = tonumber(v["px"]),tonumber(v["py"]),tonumber(v["pz"])
			local color = getColonyColor(owner)
			local r,g,b = color[1],color[2],color[3]

			LaboratoryFights[ID] = createRadarArea(x1,y1,xs,ys,r,g,b,125,root)
			LaboratoryFights.Data[ID] = {
				["Pickup"] = createPickup(px,py,pz,3,2976,50),
				["Owner"] = owner,
				["Colshape"] = createColCuboid(x1,y1,-50,xs,ys,7500),
				["Started"] = nil,
				["PrepStarted"] = nil,
				["ID"] = ID,
				["Active"] = false,
			}
			apocalypseSetElementData(LaboratoryFights.Data[ID]["Pickup"],"AreaID",ID)

			addEventHandler("onPickupHit",LaboratoryFights.Data[ID]["Pickup"],function(player)
				if(getElementType(player) == "player")then
					if(getElementDimension(player) == getElementDimension(source))then
						if(apocalypseGetElementData(player,"colony") >= 1)then
							if(LaboratoryFights.Data[apocalypseGetElementData(source,"AreaID")]["Active"] == false)then
								triggerClientEvent(player,"LaboratoryFights.GUI",player,apocalypseGetElementData(source,"AreaID"))
							end
						else
							createInfobox(player,getText(player,"SLaboratoryFights1"))
						end
					end
				end
			end)
		end
	end
end
LaboratoryFights.loadAreas()

function LaboratoryFights.getColonyAreas(colony)
    local colony = tonumber(colony)
    if not colony then return {} end

    local qh = dbQuery(handler, "SELECT ID FROM colonyareas WHERE owner = ?", colony)
    local result = dbPoll(qh, -1) or {}

    local ids = {}
    for _, v in ipairs(result) do
        table.insert(ids, tonumber(v.ID))
    end

    return ids
end

function LaboratoryFights.begin(ID)
	local player = client
	local colony = apocalypseGetElementData(player,"colony")

	if(not(LaboratoryFights["Active"][colony]) or LaboratoryFights["Active"][colony] == false)then
		if(not(LaboratoryFights["Active"][LaboratoryFights.Data[ID]["Owner"]]) or LaboratoryFights["Active"][LaboratoryFights.Data[ID]["Owner"]] == false)then
			if(LaboratoryFights.Data[ID]["Owner"] ~= colony)then
				if(not(LaboratoryFights.Data[ID]["Blocked"]) or LaboratoryFights.Data[ID]["Blocked"] == false)then
					local OwnerColony = LaboratoryFights.Data[ID]["Owner"]
					LaboratoryFights.Data[ID]["Attacker"] = colony
					LaboratoryFights.Data[ID]["Defender"] = OwnerColony
					LaboratoryFights.Data[ID]["Blocked"] = true
					LaboratoryFights.Data[ID]["Points"] = 0
					LaboratoryFights.Data[ID]["Active"] = true

					LaboratoryFights["Active"][colony] = true
					LaboratoryFights["Active"][OwnerColony] = true

					LaboratoryFights.Data[ID]["PrepStarted"] = getTickCount()
					LaboratoryFights.Data[ID]["Started"] = nil

					for _,v in pairs(getElementsByType("player"))do
						if(isCharacterLoggedIn(v))then
							local areaName = LaboratoryFights["Names"][apocalypseGetElementData(v,"language") or "EN"][ID]
							if(apocalypseGetElementData(v,"colony") == OwnerColony)then
								outputChatBox(getText(v,"SLaboratoryFights6"):format(areaName),v,150,0,0)
							end
							if(apocalypseGetElementData(v,"colony") == colony)then
								outputChatBox(getText(v,"SLaboratoryFights7"):format(areaName),v,0,150,0)
							end
						end
					end

					LaboratoryFights.broadcastMessage(ID, "start")

					LaboratoryFights.Data[ID]["preparationTime"] = setTimer(function(ID)
						LaboratoryFights.Data[ID]["Started"] = getTickCount()

						setRadarAreaFlashing(LaboratoryFights[ID],true)
						setRadarAreaColor(LaboratoryFights[ID],255, 150, 25,175)

						local attackerName = getPlayerData("colonys","ID",LaboratoryFights.Data[ID]["Attacker"],"name")
						local defenderName = getPlayerData("colonys","ID",LaboratoryFights.Data[ID]["Defender"],"name")

						local ar, ag, ab = LaboratoryFights.getColonyRGB(LaboratoryFights.Data[ID]["Attacker"])
						local dr, dg, db = LaboratoryFights.getColonyRGB(LaboratoryFights.Data[ID]["Defender"])

						for _,p in pairs(getElementsByType("player"))do
							if(isCharacterLoggedIn(p))then
								if(apocalypseGetElementData(p,"colony") == LaboratoryFights.Data[ID]["Attacker"]
								or apocalypseGetElementData(p,"colony") == LaboratoryFights.Data[ID]["Defender"])then
									triggerClientEvent(p,"LaboratoryFights.start",p,
										LaboratoryFights.Data[ID]["Points"],
										attackerName,
										defenderName,
										"fight",
										FIGHT_MS,
										ar, ag, ab,
										dr, dg, db
									)
								end
							end
						end

						for _,v in pairs(getElementsByType("player"))do
							if(isCharacterLoggedIn(v))then
								LaboratoryFights.CheckActiveFight(v)
							end
						end

						LaboratoryFights.Data[ID]["CheckTimer"] = setTimer(function(ID)
							local px,py,pz = getElementPosition(LaboratoryFights.Data[ID]["Pickup"])
							for _,v in pairs(getElementsByType("player"))do
								if(getElementDimension(v) == 0 and apocalypseGetElementData(v,"colony") == LaboratoryFights.Data[ID]["Attacker"])then
									if(getDistanceBetweenPoints3D(px,py,pz,getElementPosition(v)) <= 5)then
										LaboratoryFights.Data[ID]["Points"] = LaboratoryFights.Data[ID]["Points"] + 1
										for _,v2 in pairs(getElementsByType("player"))do
											if(apocalypseGetElementData(v2,"colony") == LaboratoryFights.Data[ID]["Attacker"] or apocalypseGetElementData(v2,"colony") == LaboratoryFights.Data[ID]["Defender"])then
												triggerClientEvent(v2,"LaboratoryFights.updatePoints",v2,LaboratoryFights.Data[ID]["Points"])
											end
										end

										if(LaboratoryFights.Data[ID]["Points"] >= 700)then
											LaboratoryFights.Data[ID]["Active"] = false
											LaboratoryFights["Active"][LaboratoryFights.Data[ID]["Attacker"]] = false
											LaboratoryFights["Active"][LaboratoryFights.Data[ID]["Defender"]] = false

											LaboratoryFights.Data[ID]["Owner"] = LaboratoryFights.Data[ID]["Attacker"]

											LaboratoryFights.setAreaOwnerColor(ID, LaboratoryFights.Data[ID]["Owner"])

											if(isTimer(LaboratoryFights.Data[ID]["CheckTimer"]))then
												killTimer(LaboratoryFights.Data[ID]["CheckTimer"])
											end
											if(isTimer(LaboratoryFights.Data[ID]["EndTimer"]))then
												killTimer(LaboratoryFights.Data[ID]["EndTimer"])
											end

											for _,v3 in pairs(getElementsByType("player"))do
												if(apocalypseGetElementData(v3,"colony") == LaboratoryFights.Data[ID]["Attacker"] or apocalypseGetElementData(v3,"colony") == LaboratoryFights.Data[ID]["Defender"])then
													triggerClientEvent(v3,"LaboratoryFights.stop",v3)
												end
												if(apocalypseGetElementData(v3,"colony") == LaboratoryFights.Data[ID]["Attacker"])then
													outputChatBox(getText(v3,"SLaboratoryFights8"),v3,0,150,0)
												end
												if(apocalypseGetElementData(v3,"colony") == LaboratoryFights.Data[ID]["Defender"])then
													outputChatBox(getText(v3,"SLaboratoryFights9"),v3,0,150,0)
												end
											end

											LaboratoryFights.broadcastMessage(ID, "attacker_win")

											LaboratoryFights.Data[ID]["Blocked"] = false
											LaboratoryFights.Data[ID]["Started"] = nil
											LaboratoryFights.Data[ID]["PrepStarted"] = nil
											break
										end
										break
									end
								end
							end
						end,1000,0,ID)

						LaboratoryFights.Data[ID]["EndTimer"] = setTimer(function(ID)
							LaboratoryFights.Data[ID]["Active"] = false
							LaboratoryFights["Active"][LaboratoryFights.Data[ID]["Attacker"]] = false
							LaboratoryFights["Active"][LaboratoryFights.Data[ID]["Defender"]] = false

							LaboratoryFights.setAreaOwnerColor(ID, LaboratoryFights.Data[ID]["Owner"])

							if(isTimer(LaboratoryFights.Data[ID]["CheckTimer"]))then
								killTimer(LaboratoryFights.Data[ID]["CheckTimer"])
							end

							for _,v4 in pairs(getElementsByType("player"))do
								if(apocalypseGetElementData(v4,"colony") == LaboratoryFights.Data[ID]["Attacker"] or apocalypseGetElementData(v4,"colony") == LaboratoryFights.Data[ID]["Defender"])then
									triggerClientEvent(v4,"LaboratoryFights.stop",v4)
								end
								if(apocalypseGetElementData(v4,"colony") == LaboratoryFights.Data[ID]["Attacker"])then
									outputChatBox(getText(v4,"SLaboratoryFights10"),v4,0,150,0)
								end
								if(apocalypseGetElementData(v4,"colony") == LaboratoryFights.Data[ID]["Defender"])then
									outputChatBox(getText(v4,"SLaboratoryFights11"),v4,0,150,0)
								end
							end

							LaboratoryFights.broadcastMessage(ID, "defender_win")

							LaboratoryFights.Data[ID]["Blocked"] = false
							LaboratoryFights.Data[ID]["Started"] = nil
							LaboratoryFights.Data[ID]["PrepStarted"] = nil
						end, FIGHT_MS, 1, ID)
					end, PREP_MS, 1, ID)

					triggerClientEvent(player,"closeWindow",player)
				else
					NPC.MeMessage(player,getText(player,"SLaboratoryFights5"))
				end
			else
				NPC.MeMessage(player,getText(player,"SLaboratoryFights4"))
			end
		else
			NPC.MeMessage(player,getText(player,"SLaboratoryFights3"))
		end
	else
		NPC.MeMessage(player,getText(player,"SLaboratoryFights2"))
	end
end
addEvent("LaboratoryFights.begin", true)
addEventHandler("LaboratoryFights.begin", root, LaboratoryFights.begin)

function LaboratoryFights.CheckActiveFight(player)
	if(apocalypseGetElementData(player,"colony") >= 1)then
		for _,v in pairs(LaboratoryFights.Data)do
			if(v["Active"] == true)then
				if(v["Attacker"] == apocalypseGetElementData(player,"colony") or v["Defender"] == apocalypseGetElementData(player,"colony"))then
					local attackerName = getPlayerData("colonys","ID",v["Attacker"],"name")
					local defenderName = getPlayerData("colonys","ID",v["Defender"],"name")

					local ar, ag, ab = LaboratoryFights.getColonyRGB(v["Attacker"])
					local dr, dg, db = LaboratoryFights.getColonyRGB(v["Defender"])

					local now = getTickCount()

					if(v["Started"] == nil)then
						local prepStarted = v["PrepStarted"] or now
						local remaining = math.max(0, PREP_MS - (now - prepStarted))
						triggerClientEvent(player,"LaboratoryFights.start",player,v["Points"],attackerName,defenderName,"prep",remaining,ar,ag,ab,dr,dg,db)
					else
						local remaining = math.max(0, FIGHT_MS - (now - v["Started"]))
						triggerClientEvent(player,"LaboratoryFights.start",player,v["Points"],attackerName,defenderName,"fight",remaining,ar,ag,ab,dr,dg,db)
					end
					break
				end
			end
		end
	end
end

addEvent("LaboratoryFights.getAreaData", true)
addEventHandler("LaboratoryFights.getAreaData", root, function()
	local Areas = {}
	local result = dbPoll(dbQuery(handler,"SELECT * FROM colonyareas"),-1)
	for _,v in pairs(result)do
		table.insert(Areas,{LaboratoryFights["Names"][apocalypseGetElementData(client,"language") or "EN"][v["ID"]],v["ID"]})
	end
	triggerClientEvent(client,"Colonys.updateLaboratorys",client,Areas)
end)

function LaboratoryFights.getAreaPaydayMoney(colony)
	local colony = tonumber(colony)
	local colonyAreas = LaboratoryFights.getColonyAreas(colony)

	local Money = 0
	local Experience = 0
	local Area_Brain_Mass = 0

	if(#colonyAreas >= 1)then
		for _,v in pairs(colonyAreas)do
			local tbl = LaboratoryFights["Rewards"][v]
			if tbl then
				Money = Money + tbl.money
				Experience = Experience + tbl.experience
				Area_Brain_Mass = Area_Brain_Mass + tbl.brain_mass
			end
		end
	end
	return {Money,Experience,Area_Brain_Mass,#colonyAreas}
end

addEvent("LaboratoryFights.getAreaRewards",true)
addEventHandler("LaboratoryFights.getAreaRewards",root,function(areaID)
	local areaID = tonumber(areaID)
	local Money = 0
	local Experience = 0
	local Area_Brain_Mass = 0

	local tbl = LaboratoryFights["Rewards"][areaID]
	if tbl then
		Money = Money + tbl.money
		Experience = Experience + tbl.experience
		Area_Brain_Mass = Area_Brain_Mass + tbl.brain_mass
		triggerClientEvent(client,"Colonys.updateAreaRewards",client,Money,Experience,Area_Brain_Mass)
	end
end)