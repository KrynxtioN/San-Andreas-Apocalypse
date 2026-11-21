local rarityChances = {
    COMMON = 70,
    RARE = 22,
    EPIC = 7,
    LEGENDARY = 1
}

local tradingCards = {
    COMMON = {
        { id = 1, name = "Survivor", image = "Files/Images/Cards/Survivor.png", item_id = 211 },
        { id = 2, name = "Walker", image = "Files/Images/Cards/Walker.png", item_id = 212 },
        { id = 3, name = "Walker", image = "Files/Images/Cards/Walker.png", item_id = 213 },
        { id = 4, name = "Walker", image = "Files/Images/Cards/Walker.png", item_id = 214 },
        { id = 5, name = "Walker", image = "Files/Images/Cards/Walker.png", item_id = 215 },
        { id = 6, name = "Walker", image = "Files/Images/Cards/Walker.png", item_id = 216 },
        { id = 7, name = "Walker", image = "Files/Images/Cards/Walker.png", item_id = 217 },
        { id = 8, name = "Walker", image = "Files/Images/Cards/Walker.png", item_id = 218 },
        { id = 9, name = "Walker", image = "Files/Images/Cards/Walker.png", item_id = 219 },
        { id = 10, name = "Walker", image = "Files/Images/Cards/Walker.png", item_id = 220 },
        { id = 11, name = "Walker", image = "Files/Images/Cards/Walker.png", item_id = 221 },
        { id = 12, name = "Walker", image = "Files/Images/Cards/Walker.png", item_id = 222 },
        { id = 13, name = "Walker", image = "Files/Images/Cards/Walker.png", item_id = 223 },
        { id = 14, name = "Walker", image = "Files/Images/Cards/Walker.png", item_id = 224 },
        { id = 15, name = "Walker", image = "Files/Images/Cards/Walker.png", item_id = 225 },
    },

    RARE = {
        { id = 16, name = "Police Zombie", image = "Files/Images/Cards/PoliceZombie.png", item_id = 226 },
        { id = 17, name = "Police Zombie", image = "Files/Images/Cards/PoliceZombie.png", item_id = 227 },
        { id = 18, name = "Police Zombie", image = "Files/Images/Cards/PoliceZombie.png", item_id = 228 },
        { id = 19, name = "Police Zombie", image = "Files/Images/Cards/PoliceZombie.png", item_id = 229 },
        { id = 20, name = "Police Zombie", image = "Files/Images/Cards/PoliceZombie.png", item_id = 230 },
        { id = 21, name = "Police Zombie", image = "Files/Images/Cards/PoliceZombie.png", item_id = 231 },
        { id = 22, name = "Police Zombie", image = "Files/Images/Cards/PoliceZombie.png", item_id = 232 },
        { id = 23, name = "Police Zombie", image = "Files/Images/Cards/PoliceZombie.png", item_id = 233 },
    },

    EPIC = {
        { id = 24, name = "Mutant", image = "Files/Images/Cards/Mutant.png", item_id = 234 },
        { id = 25, name = "Mutant", image = "Files/Images/Cards/Mutant.png", item_id = 235 },
        { id = 26, name = "Mutant", image = "Files/Images/Cards/Mutant.png", item_id = 236 },
        { id = 27, name = "Mutant", image = "Files/Images/Cards/Mutant.png", item_id = 237 },
        { id = 28, name = "Mutant", image = "Files/Images/Cards/Mutant.png", item_id = 238 },
    },

    LEGENDARY = {
        { id = 29, name = "CJ Apocalypse", image = "Files/Images/Cards/CJApocalypse.png", item_id = 239 },
        { id = 30, name = "CJ Apocalypse", image = "Files/Images/Cards/CJApocalypse.png", item_id = 240 },
    }
}

function getRandomTradingCardRarity()
    local totalChance = 0

    for _, chance in pairs(rarityChances) do
        totalChance = totalChance + chance
    end

    local randomValue = math.random(1, totalChance)
    local currentChance = 0

    for rarity, chance in pairs(rarityChances) do
        currentChance = currentChance + chance

        if randomValue <= currentChance then
            return rarity
        end
    end

    return "COMMON"
end

function getRandomTradingCardFromRarity(rarity)
    local cards = tradingCards[rarity]

    if not cards or #cards <= 0 then
        return nil
    end

    local card = cards[math.random(1, #cards)]

    return {
        id = card.id,
        name = card.name,
        image = card.image,
        rarity = rarity,
		item_id = card.item_id
    }
end

function getRandomTradingCard()
    local rarity = getRandomTradingCardRarity()
    local card = getRandomTradingCardFromRarity(rarity)

    if card then
        return card
    end

    return getRandomTradingCardFromRarity("COMMON")
end

function openTradingCardPack(player)
    if not isElement(player) or getElementType(player) ~= "player" then return false end

    local card = getRandomTradingCard()
    if not card then return false end

	giveItem(player,card.item_id,1)

    triggerClientEvent(player, "clientStartTradingCardPackOpening", player, card)
    return true
end

function handleOpenTradingCardPackCommand(player)
    openTradingCardPack(player)
end