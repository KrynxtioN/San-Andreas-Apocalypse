SellFish = {["Price"] = {}, boughtShells = {}}

local count = 0
function SellFish.generatePrices()
	SellFish["Price"][133] = math.random(471,500)
	SellFish["Price"][134] = math.random(436,470)
	SellFish["Price"][135] = math.random(381,435)
	SellFish["Price"][136] = math.random(336,380)
	SellFish["Price"][137] = math.random(271,335)
	SellFish["Price"][138] = math.random(241,270)
	SellFish["Price"][139] = math.random(201,240)
	SellFish["Price"][140] = math.random(176,200)
	SellFish["Price"][141] = math.random(126,175)
	SellFish["Price"][142] = math.random(100,125)
	
	local tbl = {}
	for i = 133, 142 do
		table.insert(tbl,{i,SellFish["Price"][i]})
	end
	
	if(count >= 1)then
		for _,v in pairs(getElementsByType("player"))do
			if(isCharacterLoggedIn(v))then
				triggerClientEvent(v,"SellFish.updatePrices",v,tbl)
			end
		end
	end
	count = count + 1
end
SellFish.generatePrices()

addEvent("SellFish",true)
addEventHandler("SellFish",root,function(fish,amount)
	local fish = tonumber(fish)
	local amount = tonumber(amount)
	local getPrice = SellFish["Price"][fish] * amount
	if(hasPlayerItem(client,fish) >= amount)then
		setAchievement(client,405)
		takeItem(client,fish,amount)
		givePlayerServerMoney(client,getPrice)
		NPC.NormalMessage(client,getText(client,"SSellFish2"):format(getPrice))
		outputLog(getPlayerName(client).." hat Fische verkauft und $"..getPrice.." bekommen", "Fishing", getCharacterID(client))
	else
		if(hasPlayerItem(client,fish) >= 1)then
			NPC.NormalMessage(client,getText(client,"SSellFish1"):format(hasPlayerItem(client,fish)))
		else
			NPC.NormalMessage(client,getText(client,"SSellFish3"))
		end
	end
end)

addEvent("SellFish.getPrices",true)
addEventHandler("SellFish.getPrices",root,function()
	local tbl = {}
	for i = 133, 142 do
		table.insert(tbl,{i,SellFish["Price"][i]})
	end
	triggerClientEvent(client,"SellFish.updatePrices",client,tbl)
end)

function SellFish.getShells(player)
	if(not(player))then player = client end
	if(not(SellFish.boughtShells[player]))then SellFish.boughtShells[player] = 0 end
	triggerClientEvent(player,"SellFish.updateShells",player,200 - SellFish.boughtShells[player])
end
addEvent("SellFish.getShells",true)
addEventHandler("SellFish.getShells",root,SellFish.getShells)

addEvent("SellFish.buyShell",true)
addEventHandler("SellFish.buyShell",root,function(amount)
	local amount = tonumber(amount)
	local costs = amount * 100
	if(not(SellFish.boughtShells[client]))then SellFish.boughtShells[client] = 0 end
	if(SellFish.boughtShells[client] < 200)then
		if(SellFish.boughtShells[client] + amount <= 200)then
			local money = tonumber(apocalypseGetElementData(client,"money"))
			if(money >= costs)then
				apocalypseSetElementData(client,"money",money - costs)
				giveItem(client,67,amount)
				triggerClientEvent(client, "showItemBar", client, {{67,amount}})
				NPC.NormalMessage(client,getText(client,"SSellFish6"))
				SellFish.boughtShells[client] = SellFish.boughtShells[client] + amount
				SellFish.getShells(client)
				setAchievement(client,404)
				outputLog(getPlayerName(client).." hat "..amount.." Muscheln gekauft", "Fishing", getCharacterID(client))
			else
				NPC.NormalMessage(client,getText(client,"SSellFish5"):format(costs))
			end
		else
			NPC.NormalMessage(client,getText(client,"SSellFish4"))
		end
	else
		NPC.NormalMessage(client,getText(client,"SSellFish4"))
	end
end)