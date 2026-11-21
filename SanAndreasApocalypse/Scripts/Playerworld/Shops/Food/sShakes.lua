Shakes = {animationTimer = {}, availableBrainmassShakes = 5, playerBought = {},
	["Time"] = {
		[2] = 300,
		[3] = 600,
		[4] = 14400,
	},
}

addEvent("Shakes.buy",true)
addEventHandler("Shakes.buy",root,function(price, text, thirst, id)
	local id = tonumber(id)
	local price = tonumber(price)
	if(tonumber(apocalypseGetElementData(client,"money")) >= price)then
		giveThirst(client, tonumber(thirst))
		NPC.NormalMessage(client,text)
		apocalypseSetElementData(client,"money",apocalypseGetElementData(client,"money")-price)
		Shakes.animation(client)
		if(id > 1)then
			Shakes.addNoThirstTimer(client,Shakes["Time"][id])
		end
	end
end)

function Shakes.animation(player)
	if(isTimer(Shakes.animationTimer[player]))then killTimer(Shakes.animationTimer[player])end
	setPedAnimation(player,"food","eat_burger",-1,true,false,false,true)
	Shakes.animationTimer[player] = setTimer(function(player)
		setPedAnimation(player)
	end,3500,1,player)
end

addEvent("Shakes.takeAway",true)
addEventHandler("Shakes.takeAway",root,function(price,text,id)
	local price = tonumber(price)
	if(tonumber(apocalypseGetElementData(client,"money")) >= price)then
		local id = tonumber(id)
		if(id == 1)then
			giveItem(client,176,1)
		elseif(id == 2)then
			giveItem(client,177,1)
		elseif(id == 3)then
			giveItem(client,178,1)
		elseif(id == 4)then
			giveItem(client,179,1)
		end
		outputLog(getPlayerName(client).." hat sich einen Shake für $"..price.." gekauft","Shake Shop",getCharacterID(client))
		apocalypseSetElementData(client,"money",apocalypseGetElementData(client,"money")-price)
		NPC.NormalMessage(client,text)
	end
end)

addEvent("Shakes.checkBrainmassShake",true)
addEventHandler("Shakes.checkBrainmassShake",root,function()
	if(Shakes.availableBrainmassShakes == 0)then
		NPC.NormalMessage(client,getText(client,"CShakes13"))
	else
		NPC.NormalMessage(client,getText(client,"CShakes4"))
	end
end)

function Shakes.addNoThirstTimer(player,newTime)
    local charID = getCharacterID(player)
    outputDebugString("CHARACTER ID: "..tostring(charID))

    local result = tonumber(getPlayerData("characters", "ID", charID, "nothirsttimer")) or 0

    local currentTime = getRealTime().timestamp
    local couponDuration = newTime

    if result == nil then
        return
    end

    if result == 0 then
        dbExec(handler, "UPDATE characters SET nothirsttimer = '"..currentTime + couponDuration.."' WHERE ID = '"..charID.."'")
    else
        dbExec(handler, "UPDATE characters SET nothirsttimer = '"..result + couponDuration.."' WHERE ID = '"..charID.."'")
    end
    activatenothirsttimer(player)
end

function activatenothirsttimer(player)
	local nothirsttimer = tonumber(getPlayerData("characters","ID",getCharacterID(player),"nothirsttimer"))
	if(nothirsttimer and nothirsttimer > 0)then
		triggerClientEvent(player,"addTimer",player,nothirsttimer,"Keinen Durst","nothirsttimer")
	end
end

function isNoThirstTimerActive(player)
	local result = getPlayerData("characters","ID",getCharacterID(player),"nothirsttimer")
	if(result)then
		if(tonumber(result) > getRealTime().timestamp)then
			return true
		else
			dbExec(handler,"UPDATE characters SET nothirsttimer = 0 WHERE ID = '"..getCharacterID(player).."'")
			return false
		end
	end
end