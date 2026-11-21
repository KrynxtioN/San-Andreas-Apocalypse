local MoneyPerKill = {[22] = 5,  [23] = 6,  [24] = 7,  [25] = 8,  [26] = 9,  [27] = 10, [28] = 11, [29] = 12, [32] = 13, [30] = 14, [31] = 15, [33] = 16, [34] = 17, [35] = 250, [36] = 250, [38] = 20}
PlayerKillstreak = {}
local MoneyPickupTimer, WeaponPickupTimer = {}, {}
local MoneyPickup, WeaponPickup = {}, {}
ServerPaydayZombieKills = 0

local weaponIds = {
	[1] = 331,
	[2] = 333,
	[3] = 334,
	[4] = 335,
	[5] = 336,
	[6] = 337,
	[7] = 338,
	[8] = 339,
	[9] = 341,
	[10] = 321,
	[11] = 322,
	[12] = 323,
	[14] = 325,
	[15] = 326,
	[16] = 342,
	[17] = 343,
	[18] = 344,
	[22] = 346,
	[23] = 347,
	[24] = 348,
	[25] = 349,
	[26] = 350,
	[27] = 351,
	[28] = 352,
	[29] = 353,
	[30] = 355,
	[31] = 356,
	[32] = 372,
	[33] = 357,
	[34] = 358,
	[35] = 359,
	[36] = 360,
	[37] = 361,
	[38] = 362,
	[39] = 363,
	[41] = 365,
	[42] = 366,
	[43] = 367,
	[44] = 368,
	[45] = 369,
	[46] = 371,
}

local ZombieChips = {}
local ZombieChipsTimer = {}
local ZombieChipsTotal = 0

local ZombieChips = {}
local ZombieChipsTimer = {}
local ZombieChipsTotal = 0

local BOSS_ZOMBIE_MODEL_IDS = {2,13,31}

local BOSS_ZOMBIE_MODEL_LOOKUP = {}
for _, modelID in ipairs(BOSS_ZOMBIE_MODEL_IDS)do
	BOSS_ZOMBIE_MODEL_LOOKUP[tonumber(modelID)] = true
end

local function isBossZombieModel(modelID)
	return BOSS_ZOMBIE_MODEL_LOOKUP[tonumber(modelID)] == true
end

local BOSS_ZOMBIE_DEFAULT_HEALTH = 500
local BossZombieCounter = 0
local BossZombieRegistry = {}

local BossWeaponDamage = {
	-- Unarmed / Melee
	[0] = 5,   -- Fist
	[1] = 6,   -- Brass Knuckle
	[2] = 7,   -- Golf Club
	[3] = 8,   -- Nightstick
	[4] = 10,  -- Knife
	[5] = 11,  -- Bat
	[6] = 12,  -- Shovel
	[7] = 11,  -- Pool Cue
	[8] = 13,  -- Katana
	[9] = 14,  -- Chainsaw

	-- Pistols
	[22] = 18, -- Colt 45
	[23] = 22, -- Silenced
	[24] = 40, -- Deagle

	-- Shotguns
	[25] = 65, -- Shotgun
	[26] = 55, -- Sawed-Off
	[27] = 50, -- Combat Shotgun

	-- SMGs
	[28] = 16, -- Uzi
	[29] = 18, -- MP5

	-- Assault Rifles
	[30] = 22, -- AK47
	[31] = 24, -- M4

	-- Rifles
	[33] = 90,  -- Country Rifle
	[34] = 120, -- Sniper

	-- Heavy
	[35] = 200, -- Rocket Launcher
	[36] = 250, -- Heat-Seeking RPG

	-- Misc
	[37] = 30, -- Flamethrower
	[38] = 10, -- Minigun (pro bullet tick runtergesetzt)

	-- Thrown
	[16] = 15, -- Grenade
	[17] = 12, -- Teargas
	[18] = 20, -- Molotov
}

local function isBossZombie(ped)
	return isElement(ped)
		and getElementType(ped) == "ped"
		and getElementData(ped, "zombie") == true
		and isBossZombieModel(getElementModel(ped))
		and getElementData(ped, "BossZombie") == true
end

local function syncBossZombieVisualHealth(ped)
	if(not isBossZombie(ped))then return end

	local currentHealth = tonumber(getElementData(ped, "BossZombieHealth")) or 0
	local maxHealth = tonumber(getElementData(ped, "BossZombieMaxHealth")) or 1
	if(maxHealth < 1)then maxHealth = 1 end

	if(currentHealth <= 0)then
		setElementHealth(ped, 0)
		return
	end

	local visualHealth = (currentHealth / maxHealth) * 100
	if(visualHealth < 1)then
		visualHealth = 1
	end
	if(visualHealth > 100)then
		visualHealth = 100
	end

	setElementHealth(ped, visualHealth)
end

local function setupBossZombie(ped)
	if(not isElement(ped))then return false end
	if(getElementType(ped) ~= "ped")then return false end
	if(getElementData(ped, "zombie") ~= true)then return false end
	if(not isBossZombieModel(getElementModel(ped)))then return false end

	if(getElementData(ped, "BossZombie") == true)then
		BossZombieRegistry[ped] = true

		if(not tonumber(getElementData(ped, "BossZombieMaxHealth")))then
			setElementData(ped, "BossZombieMaxHealth", BOSS_ZOMBIE_DEFAULT_HEALTH)
		end
		if(not tonumber(getElementData(ped, "BossZombieHealth")))then
			setElementData(ped, "BossZombieHealth", tonumber(getElementData(ped, "BossZombieMaxHealth")) or BOSS_ZOMBIE_DEFAULT_HEALTH)
		end

		syncBossZombieVisualHealth(ped)
		return true
	end

	setElementData(ped, "BossZombie", true)
	setElementData(ped, "BossZombieModel", getElementModel(ped))
	setElementData(ped, "BossZombieMaxHealth", BOSS_ZOMBIE_DEFAULT_HEALTH)
	setElementData(ped, "BossZombieHealth", BOSS_ZOMBIE_DEFAULT_HEALTH)

	BossZombieRegistry[ped] = true
	syncBossZombieVisualHealth(ped)

	return true
end

local function unregisterBossZombie(ped)
	BossZombieRegistry[ped] = nil
end

local function getBossWeaponDamage(weapon, bodypart)
	weapon = tonumber(weapon) or 0
	bodypart = tonumber(bodypart) or 0

	local damage = BossWeaponDamage[weapon] or 10

	if(bodypart == 9)then
		damage = damage * 1.75
	elseif(bodypart == 3 or bodypart == 4)then
		damage = damage * 1.15
	elseif(bodypart == 5 or bodypart == 6 or bodypart == 7 or bodypart == 8)then
		damage = damage * 0.9
	end

	damage = math.floor(damage)
	if(damage < 1)then damage = 1 end

	return damage
end

local function applyBossZombieDamage(ped, attacker, weapon, bodypart)
	if(not isBossZombie(ped))then return false end

	local currentHealth = tonumber(getElementData(ped, "BossZombieHealth")) or BOSS_ZOMBIE_DEFAULT_HEALTH
	local damage = getBossWeaponDamage(weapon, bodypart)
	local newHealth = currentHealth - damage

	if(newHealth < 0)then
		newHealth = 0
	end

	setElementData(ped, "BossZombieHealth", newHealth)

	if(newHealth <= 0)then
		setElementHealth(ped, 0)
		killPed(ped, attacker, tonumber(weapon) or 0, tonumber(bodypart) or 0)
	else
		syncBossZombieVisualHealth(ped)
	end

	return true
end

addEventHandler("onResourceStart", resourceRoot, function()
	for _, ped in ipairs(getElementsByType("ped"))do
		if(getElementData(ped, "zombie") == true and isBossZombieModel(getElementModel(ped)))then
			setupBossZombie(ped)
		end
	end
end)

addEventHandler("onElementDataChange", root, function(dataName)
	if(getElementType(source) ~= "ped")then return end

	if(dataName == "zombie")then
		if(getElementData(source, "zombie") == true and isBossZombieModel(getElementModel(source)))then
			setupBossZombie(source)
		end
	end
end)

addEventHandler("onElementDestroy", root, function()
	if(getElementType(source) == "ped")then
		unregisterBossZombie(source)
	end
end)

addEvent("BossZombie.SyncDamage", true)
addEventHandler("BossZombie.SyncDamage", root, function(ped, weapon, bodypart)
	if(client ~= source)then
		return
	end

	if(not isElement(ped))then
		return
	end

	if(getElementType(ped) ~= "ped")then
		return
	end

	if(getElementData(ped, "zombie") ~= true)then
		return
	end

	if(not isBossZombieModel(getElementModel(ped)))then
		return
	end

	setupBossZombie(ped)
	rememberZombieAttacker(ped, client, weapon, bodypart)
	applyBossZombieDamage(ped, client, weapon, bodypart)
end)

local ZOMBIE_LAST_HIT_TIMEOUT = 8000

local function getPlayerFromAttacker(attacker)
	if(not attacker or not isElement(attacker))then
		return nil
	end

	local elementType = getElementType(attacker)
	if(elementType == "player")then
		return attacker
	end

	if(elementType == "vehicle")then
		local controller = getVehicleController(attacker)
		if(controller and isElement(controller) and getElementType(controller) == "player")then
			return controller
		end
	end

	return nil
end

local function normalizeRewardWeapon(player, damageWeapon)
	damageWeapon = tonumber(damageWeapon) or 0
	if(not player or not isElement(player))then
		return damageWeapon
	end

	if(MoneyPerKill[damageWeapon])then
		return damageWeapon
	end

	local currentWeapon = tonumber(getPedWeapon(player)) or 0

	if(damageWeapon == 19 or damageWeapon == 37 or damageWeapon == 51 or damageWeapon == 59 or damageWeapon == 63)then
		if(currentWeapon == 35 or currentWeapon == 36 or currentWeapon == 38)then
			return currentWeapon
		end
	end

	if(MoneyPerKill[currentWeapon])then
		return currentWeapon
	end

	return damageWeapon
end

function rememberZombieAttacker(zombie, attacker, weapon, bodypart)
	if(not isElement(zombie))then return end
	if(getElementType(zombie) ~= "ped")then return end
	if(getElementData(zombie, "zombie") ~= true)then return end

	local player = getPlayerFromAttacker(attacker)
	if(not player)then return end

	local rewardWeapon = normalizeRewardWeapon(player, weapon)

	setElementData(zombie, "lastZombieAttacker", player, false)
	setElementData(zombie, "lastZombieAttackerTick", getTickCount(), false)
	setElementData(zombie, "lastZombieAttackerWeapon", tonumber(weapon) or 0, false)
	setElementData(zombie, "lastZombieAttackerBodypart", tonumber(bodypart) or 0, false)
	setElementData(zombie, "lastZombieRewardWeapon", tonumber(rewardWeapon) or 0, false)
end

local function resolveZombieKiller(zombie, attacker, weapon, bodypart)
	local player = getPlayerFromAttacker(attacker)
	local resolvedWeapon = tonumber(weapon) or 0
	local resolvedBodypart = tonumber(bodypart) or 0
	local resolvedRewardWeapon = 0

	if(player and isElement(player))then
		resolvedRewardWeapon = normalizeRewardWeapon(player, resolvedWeapon)
		return player, resolvedWeapon, resolvedBodypart, resolvedRewardWeapon
	end

	local lastPlayer = getElementData(zombie, "lastZombieAttacker")
	local lastTick = tonumber(getElementData(zombie, "lastZombieAttackerTick")) or 0

	if(lastPlayer and isElement(lastPlayer))then
		if((getTickCount() - lastTick) <= ZOMBIE_LAST_HIT_TIMEOUT)then
			local lastWeapon = tonumber(getElementData(zombie, "lastZombieAttackerWeapon")) or resolvedWeapon
			local lastBodypart = tonumber(getElementData(zombie, "lastZombieAttackerBodypart")) or resolvedBodypart
			local lastRewardWeapon = tonumber(getElementData(zombie, "lastZombieRewardWeapon")) or normalizeRewardWeapon(lastPlayer, lastWeapon)
			return lastPlayer, lastWeapon, lastBodypart, lastRewardWeapon
		end
	end

	return nil, resolvedWeapon, resolvedBodypart, resolvedWeapon
end

addEventHandler("onPedDamage", root, function(attacker, weapon, bodypart)
	if(getElementData(source, "zombie") == true)then
		if(isBossZombieModel(getElementModel(source)) and getElementData(source, "BossZombie") ~= true)then
			setupBossZombie(source)
		end

		rememberZombieAttacker(source, attacker, weapon, bodypart)
	end
end)

local ZombieRampage = {}
local RAMPAGE_TIME = 2000

local function getRampageData(player)
	if(not ZombieRampage[player])then
		ZombieRampage[player] = {
			Active = false,
			Level = 0,
			Timer = nil,
		}
	end
	return ZombieRampage[player]
end

local function getRampageDisplayLevel(level)
	if(not level or level < 5)then return 0 end
	return level - 4
end

local function getRampageMoneyBonus(level)
	if(not level or level < 5)then return 0 end
	return math.floor((level - 4) * 0.5)
end

local function getRampageEXPBonus(level)
	if(not level or level < 5)then return 0 end
	return level - 4
end

function ZombieRampage.Stop(player)
	if(ZombieRampage[player])then
		if(isTimer(ZombieRampage[player].Timer))then
			killTimer(ZombieRampage[player].Timer)
		end

		ZombieRampage[player] = {
			Active = false,
			Level = 0,
			Timer = nil,
		}

		if(isElement(player))then
			apocalypseSetElementData(player, "ZombieRampage", 0)
			triggerClientEvent(player, "ZombieRampage.Unrender", player)
		end
	end
end

function ZombieRampage.AddKill(player)
	if(not isElement(player))then
		return 0, 0, 0
	end

	local data = getRampageData(player)

	if(isTimer(data.Timer))then
		killTimer(data.Timer)
	end

	data.Active = true
	data.Level = data.Level + 1

	local realLevel = data.Level
	local displayLevel = getRampageDisplayLevel(realLevel)
	local moneyBonus = getRampageMoneyBonus(realLevel)
	local expBonus = getRampageEXPBonus(realLevel)

	apocalypseSetElementData(player, "ZombieRampage", displayLevel)

	if(displayLevel >= 1)then
		triggerClientEvent(player, "ZombieRampage.Render", player, displayLevel, RAMPAGE_TIME, moneyBonus, expBonus)
	end

	data.Timer = setTimer(function(thePlayer)
		ZombieRampage.Stop(thePlayer)
	end, RAMPAGE_TIME, 1, player)

	return displayLevel, moneyBonus, expBonus
end

local ZombieMultiKill = {}
local MULTIKILL_TIME = 1500

local function getMultiKillData(player)
	if(not ZombieMultiKill[player])then
		ZombieMultiKill[player] = {
			Active = false,
			Kills = 0,
			Timer = nil,
			LastTier = 0,
			OverlordRewarded = false,
		}
	end
	return ZombieMultiKill[player]
end

local function getMultiKillTier(kills)
	if(kills < 2)then return 0, nil, 0, 0 end
	if(kills < 4)then return 1, "DOUBLE KILL", 5, 5 end
	if(kills < 6)then return 2, "TRIPLE KILL", 8, 8 end
	if(kills < 8)then return 3, "QUADRA KILL", 12, 12 end
	if(kills < 10)then return 4, "PENTA KILL", 16, 16 end
	if(kills < 13)then return 5, "MEGA KILL", 22, 20 end
	if(kills < 16)then return 6, "MONSTER KILL", 28, 24 end
	if(kills < 20)then return 7, "ULTRA KILL", 35, 30 end
	if(kills < 25)then return 8, "UNSTOPPABLE", 45, 38 end
	if(kills < 30)then return 9, "RAMPAGE", 55, 46 end
	if(kills < 35)then return 10, "DOMINATING", 65, 55 end
	if(kills < 40)then return 11, "GODLIKE", 80, 65 end
	if(kills < 50)then return 12, "WICKED SICK", 100, 80 end
	if(kills < 60)then return 13, "LUDICROUS KILL", 130, 100 end
	if(kills < 70)then return 14, "HOLY SHIT", 170, 130 end
	if(kills < 80)then return 15, "MASSACRE", 220, 170 end
	if(kills < 90)then return 16, "ANNIHILATION", 280, 220 end
	if(kills < 100)then return 17, "APOCALYPSE", 350, 280 end
	return 18, "ZOMBIE OVERLORD", 500, 400
end

function ZombieMultiKill.Stop(player)
	if(ZombieMultiKill[player])then
		if(isTimer(ZombieMultiKill[player].Timer))then
			killTimer(ZombieMultiKill[player].Timer)
		end

		ZombieMultiKill[player] = {
			Active = false,
			Kills = 0,
			Timer = nil,
			LastTier = 0,
			OverlordRewarded = false,
		}

		if(isElement(player))then
			apocalypseSetElementData(player, "ZombieMultiKill", 0)
			triggerClientEvent(player, "ZombieMultiKill.Unrender", player)
		end
	end
end

function ZombieMultiKill.AddKill(player)
	if(not isElement(player))then
		return 0, nil, 0, 0
	end

	local data = getMultiKillData(player)

	if(isTimer(data.Timer))then
		killTimer(data.Timer)
	end

	data.Active = true
	data.Kills = data.Kills + 1

	local kills = data.Kills
	local tier, name, moneyBonus, expBonus = getMultiKillTier(kills)

	apocalypseSetElementData(player, "ZombieMultiKill", kills)

	local shouldReward = false

	if(tier > 0)then
		if(tier == 18)then
			if(data.OverlordRewarded ~= true)then
				shouldReward = true
				data.OverlordRewarded = true
				data.LastTier = tier
			end
		elseif(tier > data.LastTier)then
			shouldReward = true
			data.LastTier = tier
		end
	end

	if(shouldReward == true and name)then
		triggerClientEvent(player, "ZombieMultiKill.Render", player, name, kills, MULTIKILL_TIME, moneyBonus, expBonus)
	else
		moneyBonus = 0
		expBonus = 0
		name = nil
	end

	data.Timer = setTimer(function(thePlayer)
		ZombieMultiKill.Stop(thePlayer)
	end, MULTIKILL_TIME, 1, player)

	return kills, name, moneyBonus, expBonus
end

function createZombieChip(x,y,z)
	ZombieChipsTotal = ZombieChipsTotal + 1
	ZombieChips[ZombieChipsTotal] = createPickup(x,y,z,3,2976,50)
	apocalypseSetElementData(ZombieChips[ZombieChipsTotal],"ZombieChipID",ZombieChipsTotal)
	ZombieChipsTimer[ZombieChipsTotal] = setTimer(function(ID)
		if(isElement(ZombieChips[ID]))then
			destroyElement(ZombieChips[ID])
		end
	end,60000,1,ID)
	
	addEventHandler("onPickupHit",ZombieChips[ZombieChipsTotal],function(player)
		if(getElementType(player) == "player")then
			if(not(isPedInVehicle(player)))then
				local ID = apocalypseGetElementData(source,"ZombieChipID")
				if(isTimer(ZombieChipsTimer[ID]))then
					killTimer(ZombieChipsTimer[ID])
				end
				destroyElement(source)
				giveItem(player,63,1)
				triggerClientEvent(player, "showItemBar", player, {{63,1}})
			end
		end
	end)
end

addEventHandler("onPedWasted", root, function(ammo, attacker, weapon, bodypart)
	if(getElementData(source, "zombie") and getElementData(source, "zombie") == true)then
		local realAttacker, realWeapon, realBodypart, realRewardWeapon = resolveZombieKiller(source, attacker, weapon, bodypart)

		if(realAttacker and getElementType(realAttacker) == "player")then
			local zx,zy,zz = getElementPosition(source)
			local Model = getElementModel(source)
			if(math.random(1,5) == 3)then createZombieChip(zx,zy,zz) end

			if(apocalypseGetElementData(source,"HalloweenPumpkin") == true)then
				local killed_pumpkin_zombies = tonumber(getPlayerData("character_stats","character_id",getCharacterID(realAttacker),"killed_pumpkin_zombies"))
				Characters.addStats(realAttacker,"killed_pumpkin_zombies",killed_pumpkin_zombies+1)
			end
			
			local ItemID = zombies["ModelItem"][Model]
			if(ItemID)then
				if(math.random(1,50) >= 45)then
					giveItem(realAttacker,ItemID,1)
					triggerClientEvent(realAttacker, "showItemBar", realAttacker, {{ItemID,1}})
				end
			end
			
			local PlayerZone = tonumber(apocalypseGetElementData(realAttacker,"PlayersZone"))
			if(PlayerZone == 7)then
				if(math.random(1,5) == 3)then
					giveItem(realAttacker,203,1)
				end
			end
			
			-- Rampage / MultiKill
			local rampageLevel, rampageMoneyBonus, rampageEXPBonus = ZombieRampage.AddKill(realAttacker)
			local multiKills, multiName, multiMoneyBonus, multiEXPBonus = ZombieMultiKill.AddKill(realAttacker)
			
			-- Basic EXP
			local rarity = apocalypseGetElementData(source,"zombieRarity") or "common"
			local experiencepoints_for_player = zombies["RarityEXP"][rarity]
			
			-- [[ BONUS ]]
			local ZombieKillBonus = 0
			
			-- Zombie Nest Bonus
			if(apocalypseGetElementData(source,"nestZombie") == true)then ZombieKillBonus = ZombieKillBonus + 5 end
			
			-- Reputation Level Bonus
			local reputationLevel = tonumber(getPlayerData("characters","ID",getCharacterID(realAttacker),"daily_zombie_kills_bonus"))
			if(reputationLevel and reputationLevel >= 1)then ZombieKillBonus = ZombieKillBonus + (reputationLevel * 2) end
			
			-- Outfit Bonus
			ZombieKillBonus = ZombieKillBonus + checkOutfitBonus(realAttacker)
			
			-- Bonus Zone
			if(Zones.isPlayerInBonusZone(realAttacker) == true)then ZombieKillBonus = ZombieKillBonus + math.random(5,10) end
			
			-- Sniper Headshot
			if(realWeapon == 34 and realBodypart == 9)then ZombieKillBonus = ZombieKillBonus + math.random(10,15) end
			
			-- Boss Zombie
			if(isBossZombieModel(Model))then ZombieKillBonus = ZombieKillBonus + 500 end
			
			-- Rank
			local rank = tonumber(apocalypseGetElementData(realAttacker,"rank")) or 0
			ZombieKillBonus = ZombieKillBonus + (rank * 2)

			-- Rampage / MultiKill EXP Bonus
			ZombieKillBonus = ZombieKillBonus + rampageEXPBonus
			ZombieKillBonus = ZombieKillBonus + multiEXPBonus

			experiencepoints_for_player = experiencepoints_for_player + ZombieKillBonus
			experiencepoints_for_player = checkDoubleExperience(realAttacker,experiencepoints_for_player)
			
			giveEXP(realAttacker, experiencepoints_for_player)
			giveColonyEXP(realAttacker, experiencepoints_for_player)
			Levelsystem.nearbyTeammates(realAttacker,experiencepoints_for_player)
			
			if(apocalypseGetElementData(realAttacker,"colony") >= 1)then
				local colony_zombie_kills = getPlayerData("colonys","ID",apocalypseGetElementData(realAttacker,"colony"),"killed_zombies")
				dbExec(handler,"UPDATE colonys SET killed_zombies = '"..colony_zombie_kills + 1 .."' WHERE ID = '"..apocalypseGetElementData(realAttacker,"colony").."'")
			end
			
			giveItem(realAttacker,1,1)
			setAchievement(realAttacker,7)
			
			ZombieMinigame.addZombie(realAttacker)
			CommunityTask.addZombieKill(realAttacker)
			ServerPaydayZombieKills = ServerPaydayZombieKills + 1
			apocalypseSetElementData(realAttacker, "zombiekills", apocalypseGetElementData(realAttacker, "zombiekills")+1)
			
			local charID = getCharacterID(realAttacker)
			local kills = tonumber(getPlayerData("characters", "ID", charID, "daily_zombie_kills")) or 0
			kills = kills + 1
			dbExec(handler, "UPDATE characters SET daily_zombie_kills = ? WHERE ID = ?", kills, charID)
			
			if(DailyTasks.playerTasks[realAttacker] and DailyTasks.playerTasks[realAttacker][1])then
				DailyTasks.updateProgress(realAttacker,1,DailyTasks.playerTasks[realAttacker][1].progress + 1)
			end
			if(WeeklyTasks.playerTasks[realAttacker] and WeeklyTasks.playerTasks[realAttacker][1])then
				WeeklyTasks.updateProgress(realAttacker,1,WeeklyTasks.playerTasks[realAttacker][1].progress + 1)
			end
			
			local ZombieKills = apocalypseGetElementData(realAttacker, "zombiekills")

			local achievements = {
				{10,17},
				{25,18},
				{50,19},
				{75,20},
				{125,21},
				{250,22},
				{500,23},
				{1000,24},
				{2500,25},
				{5000,26},
				{10000,27},
				{25000,28},
				{50000,74},
				{75000,75},
				{100000,29},
			}
			
			for _,v in pairs(achievements)do
				if(tonumber(ZombieKills) >= v[1])then
					setAchievement(realAttacker,v[2])
				end
			end
			
			if(realBodypart == 9)then
				if(not(PlayerKillstreak[realAttacker]))then
					PlayerKillstreak[realAttacker] = {
						Active = false, 
						Kills = 0, 
						Money = 0, 
						Experience = 0, 
					}
				end
	
				if(isTimer(PlayerKillstreak[realAttacker].Timer))then killTimer(PlayerKillstreak[realAttacker].Timer) end
				
				PlayerKillstreak[realAttacker].Kills = PlayerKillstreak[realAttacker].Kills + 1
				PlayerKillstreak[realAttacker].Active = true
				
				-- Events
				if(HalloweenEvent == true)then giveHalloweenPumpkin(realAttacker,1) end
				if(ChristmasEvent == true)then giveChristmasPresent(realAttacker,1) end
				if(ValentineEvent == true)then giveValentineItem(realAttacker,1) end
				if(EasterEvent == true)then giveEasterEgg(realAttacker,1) end
				
				if(PlayerKillstreak[realAttacker].Kills >= 3)then
					setAchievement(realAttacker, 8)
					local Level_Bonus_EXP = tonumber(apocalypseGetElementData(realAttacker,"level")) or 0
					if(Level_Bonus_EXP > 100)then Level_Bonus_EXP = 100 end
					local experience_bonus = 0.5 * Level_Bonus_EXP
					if(experience_bonus < 1)then experience_bonus = 1 end
					experience_bonus = checkDoubleExperience(realAttacker,1)
					giveEXP(realAttacker, experience_bonus)
					giveColonyEXP(realAttacker, experience_bonus)
					
					PlayerKillstreak[realAttacker].Money = PlayerKillstreak[realAttacker].Money + PlayerKillstreak[realAttacker].Kills
					PlayerKillstreak[realAttacker].Experience = PlayerKillstreak[realAttacker].Experience + 1
					if(PlayerKillstreak[realAttacker].Kills >= 10)then
						PlayerKillstreak[realAttacker].Kills = 0
						PlayerKillstreak[realAttacker].Money = PlayerKillstreak[realAttacker].Money + 50
						PlayerKillstreak[realAttacker].Experience = PlayerKillstreak[realAttacker].Experience + (2 * Level_Bonus_EXP)
					end
					triggerClientEvent(realAttacker, "PlayerKillstreak.Render", realAttacker, PlayerKillstreak[realAttacker].Kills, PlayerKillstreak[realAttacker].Money, PlayerKillstreak[realAttacker].Experience)
				end

				PlayerKillstreak[realAttacker].Timer = setTimer(function(player)
					PlayerKillstreak.Stop(player)
				end, 5000, 1, realAttacker)
			end

			if(MoneyPerKill[realRewardWeapon])then
				local baseMoney = MoneyPerKill[realRewardWeapon]
				local totalMoney = baseMoney + rampageMoneyBonus + multiMoneyBonus
				local money = checkDoubleMoney(realAttacker,totalMoney)
				givePlayerServerMoney(realAttacker,money)
			end

			setElementData(source, "lastZombieAttacker", nil, false)
			setElementData(source, "lastZombieAttackerTick", nil, false)
			setElementData(source, "lastZombieAttackerWeapon", nil, false)
			setElementData(source, "lastZombieAttackerBodypart", nil, false)
			setElementData(source, "lastZombieRewardWeapon", nil, false)
			unregisterBossZombie(source)
		end
	end
end)

function PlayerKillstreak.Stop(player)
	if(PlayerKillstreak[player])then
		if(PlayerKillstreak[player].Active and PlayerKillstreak[player].Active == true)then
			if(isTimer(PlayerKillstreak[player].Timer))then killTimer(PlayerKillstreak[player].Timer) end
			triggerClientEvent(player, "PlayerKillstreak.Unrender", player)
			
			local Level_Bonus_EXP = tonumber(apocalypseGetElementData(player,"level")) or 0
			if(Level_Bonus_EXP > 100)then Level_Bonus_EXP = 100 end
			local experience_bonus = 0.5 * Level_Bonus_EXP
			if(experience_bonus < 1)then experience_bonus = 1 end
			local StreakMoney = PlayerKillstreak[player].Money
			local StreakEXP = PlayerKillstreak[player].Experience + experience_bonus
			if(StreakMoney and StreakMoney >= 1)then
				local money = checkDoubleMoney(player,StreakMoney)
				givePlayerServerMoney(player, money)
				local experience = checkDoubleExperience(player,StreakEXP)
				giveEXP(player, experience)
				giveColonyEXP(player, experience)
			end

			PlayerKillstreak[player] = {Active = false, Kills = 0, Money = 0, Experience = 0}
		end
	end
end
addEvent("PlayerKillstreak.Stop", true)
addEventHandler("PlayerKillstreak.Stop", root, PlayerKillstreak.Stop)

local function destroyTimerAndPickups(player)
	if(isTimer(MoneyPickupTimer[player]))then killTimer(MoneyPickupTimer[player]) end
	if(isElement(MoneyPickup[player]))then destroyElement(MoneyPickup[player]) end
	if(isTimer(WeaponPickupTimer[player]))then killTimer(WeaponPickupTimer[player]) end
	if(isElement(WeaponPickup[player]))then destroyElement(WeaponPickup[player]) end
end

addEventHandler("onPlayerWasted", root, function(ammo, attacker, weapon, bodypart)
	if(apocalypseGetElementData(source,"Lobby") == "Shooter-Arena")then
		return
	end
	
	local x, y, z = getElementPosition(source)
	destroyTimerAndPickups(source)
	local money = tonumber(apocalypseGetElementData(source, "money")) or 0
	local lostMoney = 0
	if(money >= 1)then
		if(money >= 25)then
			if(attacker and isElement(attacker) and isPremiumActive(attacker) == true)then
				lostMoney = money/100*10
			else
				lostMoney = money/100*25
			end
		else
			lostMoney = money
		end
	end
	
	MoneyPickup[source] = createPickup(x, y, z, 3, 1212, 50)
	setElementInterior(MoneyPickup[source], getElementInterior(source))
	setElementDimension(MoneyPickup[source], getElementDimension(source))
	apocalypseSetElementData(MoneyPickup[source], "money", lostMoney)
	apocalypseSetElementData(source,"money",apocalypseGetElementData(source,"money")-lostMoney)
	
	addEventHandler("onPickupHit", MoneyPickup[source], function(player)
		if(not(isPedInVehicle(player)))then
			if(getElementInterior(player) == getElementInterior(source))then
				if(getElementDimension(player) == getElementDimension(source))then
					local pickupMoney = apocalypseGetElementData(source, "money")
					givePlayerServerMoney(player,pickupMoney)
					destroyElement(source)
				end
			end
		end
	end)

	local currentWeapon = getPedWeapon(source)
	PlayerWeapons.removeCurrentWeapon(source)
	if(weaponIds[currentWeapon])then
		WeaponPickup[source] = createPickup(x, y, z, 3, weaponIds[currentWeapon], 50)
		apocalypseSetElementData(WeaponPickup[source], "weapon", currentWeapon)
		apocalypseSetElementData(WeaponPickup[source], "ammo", getPedTotalAmmo(source))
		
		addEventHandler("onPickupHit", WeaponPickup[source], function(player)
			if(not(isPedInVehicle(player)))then
				if(getElementInterior(player) == getElementInterior(source))then
					if(getElementDimension(player) == getElementDimension(source))then
						PlayerWeapons.addNewWeapon(player, apocalypseGetElementData(source, "weapon"), apocalypseGetElementData(source, "ammo"))
						destroyElement(source)
					end
				end
			end
		end)
	end

	if(hasPlayerItem(source,192) < 1)then
		local Counter = 60
		triggerClientEvent(source, "cPlayerWasted", source, Counter)
	else
		local rx,ry,rz = getElementPosition(source)
		local int = getElementInterior(source)
		local dim = getElementDimension(source)
		apocalypseSetElementData(source,"Revival_X",rx)
		apocalypseSetElementData(source,"Revival_Y",ry)
		apocalypseSetElementData(source,"Revival_Z",rz)
		apocalypseSetElementData(source,"Revival_Int",int)
		apocalypseSetElementData(source,"Revival_Dim",dim)
		triggerClientEvent(source, "cPlayerWasted_Revival", source)
	end

	PlayerKillstreak.Stop(source)
	ZombieRampage.Stop(source)
	ZombieMultiKill.Stop(source)

	if(attacker and apocalypseGetElementData(attacker, "zombie") == true)then
		setAchievement(source, 6)
	end
	if(attacker and getElementType(attacker) == "player")then
		local playerKills = getPlayerData("character_stats","character_id",getCharacterID(attacker),"playerkills")
		Characters.addStats(attacker,"playerkills",playerKills + 1)
		local playerDeath = getPlayerData("character_stats","character_id",getCharacterID(source),"playerdeath")
		Characters.addStats(source,"playerdeath",playerDeath + 1)
	end
end)

addEvent("PlayerSpawn.TakeKit",true)
addEventHandler("PlayerSpawn.TakeKit",root,function()
	if(hasPlayerItem(client,192) >= 1)then
		takeItem(client,192,1)
	end
end)

addEvent("sPlayerDeath:Spawn", true)
addEventHandler("sPlayerDeath:Spawn", root, function(x,y,z,int,dim)
	triggerClientEvent(client, "removeCamHandler", client)
	if(x and y and z and int and dim)then
		PlayerSpawn.spawnPlayer(client,x,y,z,int,dim)
	else
		PlayerSpawn.spawnPlayer(client)
	end
	if(isPremiumActive(client) == true)then
		setElementHealth(client,100)
		return
	end
	setElementHealth(client,25)
end)