local Timer1 = {}
local Timer2 = {}
local AnimationTime1 = 4500 -- // 4,5s
local AnimationTime2 = 2500 -- // 2,5s

EatableItems = {18,29,33,36,42,43,49,50,51,52,59,60,61,85,124,125,126,182,198,202}
DrinkableItems = {41,95,96,97,98,99,100,101,176,177,178,179}

function getRandomFoodThirstItem(player)
    local allItems = {18,29,33,36,42,43,49,50,51,52,59,60,61,85,124,125,126,182,41,95,96,97,98,99,100,101,176,177,178,179,198,202}

    for i = 1, #allItems do
        local itemID = allItems[math.random(#allItems)]

        if hasPlayerItem(player, itemID) >= 1 then
            return itemID
        end
    end

    return false
end

function isItemEatable(item)
	local status = false
	local item = tonumber(item)
	for _,v in pairs(EatableItems)do
		if(v == item)then
			status = true
			break
		end
	end
	return status
end

function isItemDrinkable(item)
	local status = false
	local item = tonumber(item)
	for _,v in pairs(DrinkableItems)do
		if(v == item)then
			status = true
			break
		end
	end
	return status
end

local Hunger = {
	[18] = 15, -- Halloween Candy
	[29] = 10, -- Pizza
	[33] = 10, -- Bonbons
	[36] = 15, -- Gingerbread Man
	[42] = 10, -- Hot Dog (normal)
	[43] = 10, -- Chips
	[49] = 10, -- Hamburger
	[50] = 10, -- Donut
	[51] = 10, -- Wine
	[52] = 10, -- Chicken Leg
	[59] = 15, -- Ice Cream
	[60] = 10, -- Apple
	[61] = 10, -- Orange
	[124] = 15, -- Chilli Cheese Dog
	[125] = 20, -- BBQ Hot Dog
	[126] = 100, -- Brainmass Hot Dog
	[182] = 20, -- Fried Fish
	[198] = 20, -- Cooked Meat
	
	[202] = 50,
}

local Thirst = {
	[41] = 10, -- Water
	[95] = 15, -- Beer
	[96] = 10, -- Soda Can
	[97] = 10, -- Coffee
	[98] = 10, -- Pumpkin Spice Latte
	[99] = 25, -- Love Potion
	[100] = 25, -- Apple Juice
	[101] = 25, -- Orange Juice
	[176] = 15, -- Classic Shake
	[177] = 20, -- Chocolate Shake
	[178] = 20, -- Vanilla Shake
	[179] = 100, -- Brainmass Shake
}

function setPlayerEating(player,item)
	if(player and item)then
		local item = tonumber(item)
		if(Hunger[item] and hasPlayerItem(player,item) >= 1)then
			if(not(isTimer(Timer1[player])) and not(isTimer(Timer2[player])))then
				if(not(isPedDead(player)))then
					takeItem(player,item,1)
					--toggleAllControls(player,false)
					setPedAnimation(player,"food","eat_burger")
					Timer1[player] = setTimer(function(player)
						if(player and isElement(player))then
							if(not(isPedDead(player)))then
								setPedAnimation(player)
								giveHunger(player,Hunger[item])
								if(item == 202)then
									giveThirst(player,Hunger[item])
								end
								setPedAnimation(player,"playidles","stretch")
								Timer2[player] = setTimer(function(player)
									setPedAnimation(player)
									--toggleAllControls(player,true)
								end,AnimationTime2,1,player)
							end
						end
					end,AnimationTime1,1,player)
				end
			end
		end
	end
end

function setPlayerDrinking(player,item)
	if(player and item)then
		local item = tonumber(item)
		if(Thirst[item] and hasPlayerItem(player,item) >= 1)then
			if(not(isTimer(Timer1[player])) and not(isTimer(Timer2[player])))then
				if(not(isPedDead(player)))then
					takeItem(player,item,1)
					--toggleAllControls(player,false)
					setPedAnimation(player,"vending","vend_drink2_p")
					Timer1[player] = setTimer(function(player)
						if(player and isElement(player))then
							if(not(isPedDead(player)))then
								setPedAnimation(player)
								giveThirst(player,Thirst[item])
								setPedAnimation(player,"playidles","stretch")
								Timer2[player] = setTimer(function(player)
									setPedAnimation(player)
									--toggleAllControls(player,true)
								end,AnimationTime2,1,player)
							end
						end
					end,AnimationTime1,1,player)
				end
			end
		end
	end
end

local HungryWarningTimer = {}
local ThirstWarningTimer = {}
local WarningTime = 20000 -- // 20s

function giveHunger(player,amount)
	if(isCharacterLoggedIn(player))then
		local amount = tonumber(amount)
		local currentHunger = apocalypseGetElementData(player,"hunger")
		local newHunger = currentHunger + amount
		
		if(newHunger > 100)then
			newHunger = 100
		end
		
		addFat(player, math.max(1, math.floor(amount/2)))
		
		apocalypseSetElementData(player,"hunger",newHunger)
		
		if(newHunger >= 1)then
			if(isTimer(HungryWarningTimer[player]))then
				killTimer(HungryWarningTimer[player])
			end
		end
	end
end
addEvent("giveHunger",true)
addEventHandler("giveHunger",root,giveHunger)

function giveThirst(player, amount)
	if(isCharacterLoggedIn(player))then
		local amount = tonumber(amount) or math.random(1,3)
		local currentThirst = apocalypseGetElementData(player,"thirst")
		local newThirst = currentThirst + amount
		
		if(newThirst > 100)then
			newThirst = 100
		end
		
		addFat(player, math.max(1, math.floor(amount/2)))
		
		apocalypseSetElementData(player,"thirst",newThirst)
		
		if(newThirst >= 1)then
			if(isTimer(ThirstWarningTimer[player]))then
				killTimer(ThirstWarningTimer[player])
			end
		end
	end
end
addEvent("giveThirst",true)
addEventHandler("giveThirst",root,giveThirst)

function takeHunger(player,amount)
    if(isCharacterLoggedIn(player))then
        local amount = tonumber(amount)
        local currentHunger = apocalypseGetElementData(player,"hunger")
		local newHunger = currentHunger - amount
        
        if(currentHunger >= 1)then
            apocalypseSetElementData(player,"hunger",newHunger)
        end
        if(newHunger < 5)then
            createHungryWarning(player)
        end
		if(newHunger < 1)then
			apocalypseSetElementData(player,"hunger",0)
		end
    end
end

function takeThirst(player, amount)
    if(isCharacterLoggedIn(player))then
        local amount = tonumber(amount)
        local currentThirst = apocalypseGetElementData(player,"thirst")
		local newThirst = currentThirst - amount
        
        if(currentThirst >= 1)then
            apocalypseSetElementData(player,"thirst",newThirst)
        end
        if(newThirst < 5)then
            createThirstWarning(player)
        end
		if(newThirst < 1)then
			apocalypseSetElementData(player,"thirst",0)
		end
    end
end

function createHungryWarning(player)
	if(not(isTimer(HungryWarningTimer[player])))then
		HungryWarningTimer[player] = setTimer(function(player)
			if(isElement(player))then
				setElementHealth(player,getElementHealth(player)-1)
				NPC.MeMessage(player,getText(player,"SHungry1"))
			else
				if(isTimer(HungryWarningTimer))then killTimer(HungryWarningTimer[player])end
			end
		end,WarningTime,0,player)
	end
end

function createThirstWarning(player)
	if(not(isTimer(ThirstWarningTimer[player])))then
		ThirstWarningTimer[player] = setTimer(function(player)
			if(isElement(player))then
				setElementHealth(player,getElementHealth(player)-1)
				NPC.MeMessage(player,getText(player,"SHungry2"))
			else
				killTimer(ThirstWarningTimer[player])
			end
		end,WarningTime,0,player)
	end
end

addEventHandler("onPlayerQuit",root,function()
	if(isTimer(HungryWarningTimer[source]))then
		killTimer(HungryWarningTimer[source])
	end
	if(isTimer(ThirstWarningTimer[source]))then
		killTimer(ThirstWarningTimer[source])
	end
end)