SERVERBONUS = {}

SERVERBONUS.AIRDROP = false
SERVERBONUS.BIGFOOT = false
SERVERBONUS.SPINOSAURUS = false
SERVERBONUS.FISHING = false
SERVERBONUS.ZOMBIE_KILLGAME = false
SERVERBONUS.RACE_MINIGAME = false
SERVERBONUS.RACE_ARENA = false
SERVERBONUS.SHOOTER_ARENA = false
SERVERBONUS.INFECTED_SURVIVORS = false
SERVERBONUS.ZOMBIE_NESTS = false
SERVERBONUS.JOB_ACTIVITIES = false
SERVERBONUS.METAL_DETECTOR = false
SERVERBONUS.VEHICLE_MISSIONS = false
SERVERBONUS.RHINO = false
SERVERBONUS.ANIMALS = false
SERVERBONUS.DECORATIONPEDS = false
SERVERBONUS.LOOTING = false
SERVERBONUS.VEHICLE_QUESTS = false
SERVERBONUS.SIDE_QUESTS = false
SERVERBONUS.ZOMBIES = false
SERVERBONUS.ZOMBIE_WAVES = false

SERVERBONUS.active = nil
SERVERBONUS.state = "cooldown"
SERVERBONUS.stateEndTick = 0

local BONUS_DURATION_MS    = 1800000
local COOLDOWN_DURATION_MS = 300000

local BONUS_KEYS = {
    "AIRDROP",
    "BIGFOOT",
    "SPINOSAURUS",
    "FISHING",
    "ZOMBIE_KILLGAME",
    "RACE_MINIGAME",
    "RACE_ARENA",
    "SHOOTER_ARENA",
    "INFECTED_SURVIVORS",
	"ZOMBIE_NESTS",
	"JOB_ACTIVITIES",
	"METAL_DETECTOR",
	"VEHICLE_MISSIONS",
	"RHINO",
	"ANIMALS",
	"DECORATIONPEDS",
	"LOOTING",
	"VEHICLE_QUESTS",
	"SIDE_QUESTS",
	"ZOMBIES",
	"ZOMBIE_WAVES",
}

local bonusTimer, cooldownTimer = nil, nil

local function killTimers()
    if isTimer(bonusTimer) then killTimer(bonusTimer) end
    if isTimer(cooldownTimer) then killTimer(cooldownTimer) end
    bonusTimer, cooldownTimer = nil, nil
end

local function broadcastState()
    local remaining = math.max(0, SERVERBONUS.stateEndTick - getTickCount())
    for _,p in ipairs(getElementsByType("player")) do
        triggerClientEvent(p, "SERVERBONUS.clientDraw", p, {
            mode = SERVERBONUS.state,
            key  = SERVERBONUS.active,
            remaining = remaining
        })
    end
end

local function setAllFalse()
    for _,k in ipairs(BONUS_KEYS) do
        SERVERBONUS[k] = false
    end
end

local function startCooldown()
    setAllFalse()
    SERVERBONUS.active = nil
    SERVERBONUS.state = "cooldown"
    SERVERBONUS.stateEndTick = getTickCount() + COOLDOWN_DURATION_MS
    broadcastState()
	RandomLootCrate.stopMoreDrops()

    cooldownTimer = setTimer(function()
        generateRandomServerBonus()
    end, COOLDOWN_DURATION_MS, 1)
end

function generateRandomServerBonus()
    killTimers()

    local rndKey = BONUS_KEYS[math.random(1, #BONUS_KEYS)]

    setAllFalse()
    SERVERBONUS[rndKey] = true
    SERVERBONUS.active = rndKey
	
	if(SERVERBONUS.active == "AIDROP")then
		RandomLootCrate.activateMoreDrops()
	end

    SERVERBONUS.state = "bonus"
    SERVERBONUS.stateEndTick = getTickCount() + BONUS_DURATION_MS
    broadcastState()

    bonusTimer = setTimer(function()
        startCooldown()
    end, BONUS_DURATION_MS, 1)
end
generateRandomServerBonus()

function SERVERBONUS.loadClient(player)
    local remaining = math.max(0, SERVERBONUS.stateEndTick - getTickCount())
    triggerClientEvent(player, "SERVERBONUS.clientDraw", player, {
        mode = SERVERBONUS.state,
        key  = SERVERBONUS.active,
        remaining = remaining
    })
end