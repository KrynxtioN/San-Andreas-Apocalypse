HotDog = {animationTimer = {}, availableBrainmassDogs = 5, playerBought = {},
	["Time"] = {
		[2] = 300,
		[3] = 600,
		[4] = 14400,
	},
}

addEvent("HotDog.buy",true)
addEventHandler("HotDog.buy",root,function(price, text, hunger, id)
	local id = tonumber(id)
	local price = tonumber(price)
	if(tonumber(apocalypseGetElementData(client,"money")) >= price)then
		giveHunger(client, tonumber(hunger))
		NPC.NormalMessage(client,text)
		apocalypseSetElementData(client,"money",apocalypseGetElementData(client,"money")-price)
		HotDog.animation(client)
		if(id > 1)then
			HotDog.addNoFoodTimer(client,HotDog["Time"][id])
		end
	end
end)

function HotDog.animation(player)
	if(isTimer(HotDog.animationTimer[player]))then killTimer(HotDog.animationTimer[player])end
	setPedAnimation(player,"food","eat_burger",-1,true,false,false,true)
	HotDog.animationTimer[player] = setTimer(function(player)
		setPedAnimation(player)
	end,3500,1,player)
end

addEvent("HotDog.takeAway",true)
addEventHandler("HotDog.takeAway",root,function(price,text,id)
	local price = tonumber(price)
	if(tonumber(apocalypseGetElementData(client,"money")) >= price)then
		local id = tonumber(id)
		if(id == 1)then
			giveItem(client,42,1)
		elseif(id == 2)then
			giveItem(client,124,1)
		elseif(id == 3)then
			giveItem(client,125,1)
		elseif(id == 4)then
			giveItem(client,126,1)
		end
		outputLog(getPlayerName(client).." hat sich einen Hotdog für $"..price.." gekauft","Hot Dog Shop",getCharacterID(client))
		apocalypseSetElementData(client,"money",apocalypseGetElementData(client,"money")-price)
		NPC.NormalMessage(client,text)
	end
end)

addEvent("HotDog.checkBrainmassDog",true)
addEventHandler("HotDog.checkBrainmassDog",root,function()
	if(HotDog.availableBrainmassDogs == 0)then
		NPC.NormalMessage(client,getText(client,"CHotDog13"))
	else
		NPC.NormalMessage(client,getText(client,"CHotDog4"))
	end
end)

function HotDog.addNoFoodTimer(player,newTime)
    local result = tonumber(getPlayerData("characters", "ID", getCharacterID(player), "nofoodtimer"))
    local currentTime = getRealTime().timestamp
    local couponDuration = newTime

    if(result == 0) then
        dbExec(handler, "UPDATE characters SET nofoodtimer = '"..currentTime + couponDuration.."' WHERE ID = '"..getCharacterID(player).."'")
    else
        dbExec(handler, "UPDATE characters SET nofoodtimer = '"..result + couponDuration.."' WHERE ID = '"..getCharacterID(player).."'")
    end
	activateNoFoodTimer(player)
end

function activateNoFoodTimer(player)
	local nofoodtimer = tonumber(getPlayerData("characters","ID",getCharacterID(player),"nofoodtimer"))
	if(nofoodtimer and nofoodtimer > 0)then
		triggerClientEvent(player,"addTimer",player,nofoodtimer,"Keinen Hunger","nofoodtimer")
	end
end

function isNoFoodTimerActive(player)
	local result = getPlayerData("characters","ID",getCharacterID(player),"nofoodtimer")
	if(result)then
		if(tonumber(result) > getRealTime().timestamp)then
			return true
		else
			dbExec(handler,"UPDATE characters SET nofoodtimer = 0 WHERE ID = '"..getCharacterID(player).."'")
			return false
		end
	end
end