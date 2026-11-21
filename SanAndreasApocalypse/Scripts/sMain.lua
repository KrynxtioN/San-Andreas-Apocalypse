setFPSLimit(65)
setGameType("San Andreas Apocalypse - "..SanAndreasApocalypseVersion)

handler = dbConnect("mysql","dbname=s2757_SanAndreasApocalypse;host=localhost","root","")
if(not(handler))then outputDebugString("[SAA] No database connection!") end

local Crack_Palace_Wall=createObject(3059, 2522, -1272.93, 35.61)
local Crack_Palace_Ground=createObject(17946, 2533.81, -1290.55, 36.946)

HalloweenEvent = false
ValentineEvent = false
EasterEvent = false
ChristmasEvent = false

local function date_time()
	local time = getRealTime()
	local year,month,day = time.year+1900,time.month+1,time.monthday
	local hour,minute,second = time.hour,time.minute,time.second+1
	return {day,month,year,hour,minute,second}
end

function setPlayerAnimationStatus(player)
	setElementFrozen(player,true)
	toggleAllControls(player,false)
end

function resetPlayerAnimationStatus(player)
	setElementFrozen(player,false)
	toggleAllControls(player,true)
	setPedAnimation(player)
end

function formatTimeLeft(seconds)
	if seconds < 0 then seconds = 0 end
	local hours = math.floor(seconds / 3600)
	local minutes = math.floor((seconds % 3600) / 60)
	return string.format("%02d:%02d", hours, minutes)
end

setTimer(function()
	for _,v in pairs(getElementsByType("player"))do
		if(isCharacterLoggedIn(v))then
			local language = apocalypseGetElementData(v,"language") or "EN"
			local EXPBonus = (0.25 * apocalypseGetElementData(v,"level")) * allPlayersOnline()
			local EXPBonusPlayers = allPlayersOnline() * 100
			outputChatBox("_____| San Andreas Apocalypse |_____", v, 0, 255, 0)
			outputChatBox(getText(v,"SMain1"):format(allPlayersOnline(),EXPBonus + EXPBonusPlayers), v, 255, 255, 255)
			outputChatBox(getText(v,"SMain2"):format(SanAndreasApocalypseVersion), v , 255, 255, 255)
			giveEXP(v,EXPBonus + EXPBonusPlayers)
		end
	end
end,900000,0)

function allPlayersOnline()
	local amount = 0
	for _,v in pairs(getElementsByType("player"))do
		if(isCharacterLoggedIn(v))then
			amount = amount + 1
		end
	end
	return amount
end

function checkDoubleExperience(player,amount)
	local amount = tonumber(amount)
	if(isDoubleExperienceActive(player) == true and DoubleExperience == true)then
		amount = amount * 2 * 2
	end
	if(isDoubleExperienceActive(player) == true)then
		amount = amount * 2
	end
	if(DoubleExperience == true)then
		amount = amount * 2
	end
	return amount
end

function checkDoubleMoney(player,amount)
	local amount = tonumber(amount)
	if(isDoubleMoneyActive(player) == true)then
		amount = amount * 2
	end
	return amount
end

function DoubleExperienceMessage(player)
	if(DoubleExperience == true)then
		outputChatBox(getText(player,"SMain3"), player, 0, 255, 0)
		outputChatBox(getText(player,"SMain4"), player, 255, 255, 255)
		outputChatBox(getText(player,"SMain5"), player, 255, 255, 255)
	end
end

local Timer = {}

for i = 1,50 do outputChatBox(" ",root)end

addEvent("changePlayerSpawn",true)
addEventHandler("changePlayerSpawn",root,function(x,y,z,rotz,int,dim,keyID,markerID)
	if(tonumber(markerID) == 39)then
		if(hasPlayerPhoto(client,2) == false)then
			createInfobox(client,getText(client,"STeleporter1"))
			return
		end
	end

	if(keyID == 0 or hasPlayerKey(client,keyID) >= 1)then
		if(not(isTimer(Timer[client])))then
			fadeCamera(client,false)
			Timer[client] = setTimer(function(client)
				if(isElement(client))then
					fadeCamera(client,true)
					setElementPosition(client,x,y,z)
					setElementRotation(client,0,0,rotz,"default",true)
					setElementInterior(client,int)
					setElementDimension(client,dim)
				end
			end,1500,1,client)
		end
	else createInfobox(client,getText(client,"STeleporter1"))end
end)

function loggedInPlayers()
	local amount = 0
	for _, v in pairs(getElementsByType("player"))do
		if(isCharacterLoggedIn(v))then
			amount = amount + 1
		end
	end
	return amount
end

setTimer(function()
	local generatorBonusEXP = getWorkingGenerators() * 100
	local zombieBonusEXP = math.floor(ServerPaydayZombieKills/100*25)
	
	for _,v in pairs(getElementsByType("player"))do
		if(isCharacterLoggedIn(v))then
			outputChatBox("_____| "..getText(v,"SServerPayday1").." |_____",v,0,255,0)
			if(getWorkingGenerators() >= 1)then
				outputChatBox(getText(v,"SServerPayday3"):format(getWorkingGenerators(),generatorBonusEXP,ServerPaydayZombieKills,zombieBonusEXP),v,255,255,255)
				giveEXP(v,(generatorBonusEXP + zombieBonusEXP))
			else
				outputChatBox(getText(v,"SServerPayday2"),v,200,0,0)
			end
		end
	end
	
	ServerPaydayZombieKills = 0
end,3600000,0)

function givePlayerServerMoney(player,money)
	if(isCharacterLoggedIn(player))then
		apocalypseSetElementData(player,"money",math.floor(tonumber(apocalypseGetElementData(player,"money"))+money))
		triggerClientEvent(player,"showFloatingText",player,"$"..money,0,200,0)
	end
end

addEventHandler("onPlayerChangeNick",root,function() cancelEvent() end)

function applySpawnProtection(player, spawnProtectionTime)
    if not isElement(player) then return end
    local vehicle = getPedOccupiedVehicle(player)

	triggerClientEvent(player,"Collision.false",player)

    setElementAlpha(player, 100)
    if vehicle then setElementAlpha(vehicle, 100) end

    setTimer(function(player,vehicle)
		triggerClientEvent(player,"Collision.true",player)
        setElementAlpha(player, 255)
        if vehicle then
            setElementAlpha(vehicle, 255)
        end
    end, (spawnProtectionTime * 1000), 1,player,vehicle)

    if spawnProtectionTime > 4 then
        setTimer(function(player,vehicle)
            local blinkInterval = 500
            local blinkTime = 3000

            setTimer(function(player,vehicle)
                local currentAlpha = (getElementAlpha(player) == 100) and 255 or 100
                setElementAlpha(player, currentAlpha)
                if vehicle then
                    setElementAlpha(vehicle, currentAlpha)
                end
            end, blinkInterval, blinkTime / blinkInterval,player,vehicle)

            setTimer(function(player,vehicle)
                setElementAlpha(player, 255)
                if vehicle then
                    setElementAlpha(vehicle, 255)
                end
            end, blinkTime, 1,player,vehicle)
        end, (spawnProtectionTime - 4) * 1000, 1,player,vehicle)
    end
end

function getSecTime(duration)
	local time = getRealTime()
	local year = time.year
	local day = time.yearday
	local hour = time.hour
	local minute = time.minute
	local total = year*365*24*60+day*24*60+(hour+duration)*60+minute
	
	return total
end

local Daily_Server_Restart = false

function DailyScriptRestart()
	local time = getRealTime()
	local hours, minutes = time.hour, time.minute
	
	if(hours == 05 and minutes >= 55)then
		if(Daily_Server_Restart == false)then
			Daily_Server_Restart = true
			killTimer(Daily_Script_Restart_Timer)
			
			for _,v in pairs(getElementsByType("player"))do
				if(isCharacterLoggedIn(v))then
					outputChatBox(getText(v,"Daily_Server_Restart1"),v,250,0,0)
				end
			end
			
			setTimer(function()
				for _,v in pairs(getElementsByType("player"))do
					if(isCharacterLoggedIn(v))then
						outputChatBox(getText(v,"Daily_Server_Restart2"),v,250,0,0)
					end
				end
			end,900000,1)
			
			setTimer(function()
				for _,v in pairs(getElementsByType("player"))do
					if(isCharacterLoggedIn(v))then
						outputChatBox(getText(v,"Daily_Server_Restart3"),v,250,0,0)
					end
				end
				
				setTimer(function()
					for _,v in pairs(getElementsByType("player"))do
						Characters.SaveData(v)
						kickPlayer(v,"System","Server Restart")
					end
				
					local Days = {"Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"}
					local Time = getRealTime()
					if(Days[Time.weekday + 1] == "Sunday")then
						local result = dbPoll(dbQuery(handler, "SELECT character_id, WeekTime FROM character_stats WHERE WeekTime > 0"), -1)
						if result and #result > 0 then
							for _, row in ipairs(result) do
								local charID = tonumber(row["character_id"])
								local weekTime = tonumber(row["WeekTime"]) or 0

								local charExists = dbPoll(dbQuery(handler, "SELECT ID FROM characters WHERE ID = ?", charID), -1)
								if charExists and #charExists > 0 then
									local experiencePoints = tonumber(getPlayerData("characters", "ID", charID, "experiencepoints")) or 0
									local experiencePointsTotal = tonumber(getPlayerData("characters", "ID", charID, "experiencepointstotal")) or 0
									local player_Money = tonumber(getPlayerData("characters", "ID", charID, "money")) or 0
									local player_Level = tonumber(getPlayerData("characters", "ID", charID, "level")) or 0
									local player_owner_account = tonumber(getPlayerData("characters", "ID", charID, "owner_account_id"))
									local player_language = getPlayerData("accounts","ID",player_owner_account,"language")

									if weekTime >= 600 then
										local experience = 250 * player_Level
										local money = 50 * player_Level

										local amount = experience
										while amount > 0 do
											local needExperience = 250 * (player_Level + 1) + ((player_Level + 1) * 25)
											if experiencePoints + amount >= needExperience then
												local needed = needExperience - experiencePoints
												amount = amount - needed
												experiencePoints = 0
												player_Level = player_Level + 1
												addOfflineMessage(charID, getTextOffline(player_language,"SOfflineMessage1"):format(player_Level))
											else
												experiencePoints = experiencePoints + amount
												amount = 0
											end
										end
	
										addOfflineMessage(charID, getTextOffline(player_language,"SOfflineMessage1"):format(math.floor(weekTime/60),experience,money))

										dbExec(handler,
											"UPDATE characters SET experiencepoints = ?, experiencepointstotal = ?, money = ?, level = ? WHERE ID = ?",
											experiencePoints, experiencePointsTotal + experience, player_Money + money, player_Level, charID
										)
									end
								end
							end
						end
					
						WeeklyTasks.deleteAllTasks()
						CommunityTask.giveZombieRewards()
						dbExec(handler,"UPDATE character_stats SET WeekTime = '0' AND WeekTimeAFK = '0'")
						DailyLogin.resetAllPlayers()
					end

					dbExec(handler,"UPDATE characters SET daily_zombie_kills_bonus = '0'")
					dbExec(handler,"UPDATE characters SET daily_weapon_bonus = '0'")
					local result = dbPoll(dbQuery(handler, "SELECT ID, name, daily_zombie_kills FROM characters WHERE daily_zombie_kills > 0"), -1)
					if result and #result > 0 then
						for _, row in ipairs(result) do
							local charID = tonumber(row["ID"])
							local kills = tonumber(row["daily_zombie_kills"])
							local player = getPlayerFromCharacterID(charID)
							local player_owner_account = tonumber(getPlayerData("characters", "ID", charID, "owner_account_id"))
							local player_language = getPlayerData("accounts","ID",player_owner_account,"language")

							local level = math.min(math.floor(kills / 250), 10)

							dbExec(handler, "UPDATE characters SET daily_zombie_kills_bonus = ? WHERE ID = ?", level, charID)
							if player and isCharacterLoggedIn(player) then
								outputChatBox(getText(player,"SOfflineMessage6"):format(level,level*2), player, 0, 255, 0)
							else
								addOfflineMessage(charID, getTextOffline(player_language,"SOfflineMessage6"):format(level,level*2))
							end
						end
					end
					dbExec(handler,"UPDATE characters SET daily_zombie_kills = '0'")

					DailyTasks.deleteAllTasks()
		
					restartResource(getThisResource())
				end,60000,1)
			end,180000,1)
		end
	end
end

Daily_Script_Restart_Timer = setTimer(function()
	DailyScriptRestart()
end,60000,0)

addEventHandler("onPlayerDamage", root, function(attacker, weapon, bodypart, loss)
    if attacker and getElementType(attacker) == "vehicle" and weapon == 49 then
        cancelEvent()
    end
end)