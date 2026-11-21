Doctor = {}

addEvent("Doctor.server",true)
addEventHandler("Doctor.server",root,function(model)
	local health = getElementHealth(client)
	if(tonumber(health) < 100)then
		local money = tonumber(apocalypseGetElementData(client,"money"))
		local costs = math.floor((100 - health) * 0.5)
		if(money >= costs)then
			setElementHealth(client,100)
			NPC.NormalMessage(client,getText(client,"SDoctor3"),_,model,"Doctor")
			apocalypseSetElementData(client,"money",money - costs)
			outputLog(getPlayerName(client).." hat sich für $"..costs.." geheilt","Healthshop-Doctor",getCharacterID(client))
		else
			NPC.NormalMessage(client,getText(client,"SDoctor2"):format(costs),_,model,"Doctor")
		end
	else
		NPC.NormalMessage(client,getText(client,"SDoctor1"),_,model,"Doctor")
	end
end)