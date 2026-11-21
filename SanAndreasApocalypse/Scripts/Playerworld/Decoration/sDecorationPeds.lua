DecorationPedEXP = {playerTimer = {}}

addEvent("giveDecorationPedEXP",true)
addEventHandler("giveDecorationPedEXP",root,function(ID)
	if(not(DecorationPedEXP.playerTimer[client]))then
		DecorationPedEXP.playerTimer[client] = {}
	end
	local ID = tonumber(ID)
	if(not ID)then return end
	if(not(DecorationPedEXP[client]))then DecorationPedEXP[client] = {} end
	if(not(DecorationPedEXP[client][ID]))then
		DecorationPedEXP[client][ID] = false
	end
	if(DecorationPedEXP[client][ID] == false)then
		DecorationPedEXP[client][ID] = true
		local EXP = 25
		local Level_Bonus_EXP = tonumber(apocalypseGetElementData(client,"level"))
		if(Level_Bonus_EXP > 100)then Level_Bonus_EXP = 100 end
		EXP = EXP + (1 * Level_Bonus_EXP)
		
		if(SERVERBONUS.DECORATIONPEDS == true)then EXP = EXP * 2 end
		giveEXP(client,EXP)
		if(isTimer(DecorationPedEXP.playerTimer[client][ID]))then
			killTimer(DecorationPedEXP.playerTimer[client][ID])
		end
		DecorationPedEXP.playerTimer[client][ID] = setTimer(function(client,ID)
			DecorationPedEXP[client][ID] = false
		end,300000,1,client,ID)
	end
end)

addEventHandler("onPlayerQuit", root, function()
	DecorationPedEXP[source] = nil
	DecorationPedEXP.playerTimer[source] = nil
end)