SpecialEngine = {
	["Price"] = {
		[1] = 25000,
		[2] = 30000,
		[3] = 35000,
		[4] = 40000,
		[5] = 50000,
	},
}

addEvent("SpecialEngine.add",true)
addEventHandler("SpecialEngine.add",root,function(veh)
	if(veh)then
		local vehID = apocalypseGetElementData(veh,"VehicleID_Database")
		if(vehID)then
			local level = tonumber(getPlayerData("vehicles","ID",vehID,"special_engine"))
			if(level < 5)then
				level = level + 1
				local money = SpecialEngine["Price"][level]
				local vehicleParts = SpecialEngine["Price"][level]/100*5
				local brainmass = SpecialEngine["Price"][level]/100*5
				if(tonumber(apocalypseGetElementData(client,"money")) >= money)then
					if(hasPlayerItem(client,21) >= vehicleParts)then
						if(hasPlayerItem(client,1) >= brainmass)then
							apocalypseSetElementData(client,"money",apocalypseGetElementData(client,"money")-money)
							takeItem(client,21,vehicleParts)
							NPC.NormalMessage(client,getText(client,"SSpecialEngine5"))
							takeItem(client,1,brainmass)
							dbExec(handler,"UPDATE vehicles SET special_engine = '"..level.."' WHERE ID = '"..vehID.."'")
							SpecialEngine.load(veh)
							setAchievement(client,266)
							outputLog(getPlayerName(client).." hat einen Spezialmotor (Level "..level..") gekauft","Special Engine",getCharacterID(client))
						else NPC.NormalMessage(client,getText(client,"SSpecialEngine4"))end
					else NPC.NormalMessage(client,getText(client,"SSpecialEngine3"))end
				else NPC.NormalMessage(client,getText(client,"SSpecialEngine2"))end
			else
				NPC.NormalMessage(client,getText(client,"SSpecialEngine1"))
			end
		end
	end
end)

addEvent("SpecialEngine.getPrice",true)
addEventHandler("SpecialEngine.getPrice",root,function(veh)
	if(veh)then
		local vehID = apocalypseGetElementData(veh,"VehicleID_Database")
		if(vehID)then
			local level = tonumber(getPlayerData("vehicles","ID",vehID,"special_engine"))

			local money = SpecialEngine["Price"][level+1]
			local vehicleParts = math.floor(money/100*5)
			local brainmass = math.floor(money/100*5)
			
			triggerClientEvent(client,"SpecialEngine.updateText",client,level,money,vehicleParts,brainmass)
		end
	end
end)

function SpecialEngine.load(veh)
	if(veh)then
		local vehID = apocalypseGetElementData(veh,"VehicleID_Database")
		if(vehID)then
			local level = tonumber(getPlayerData("vehicles","ID",vehID,"special_engine"))
			if(level > 0)then
				local speed = 100 + (level * 10)
				setVehicleHandling(veh,"engineAcceleration",(getVehicleHandling(veh)["engineAcceleration"]/100*(speed)))
				setVehicleHandling(veh,"maxVelocity",(getVehicleHandling(veh)["maxVelocity"]/100*(speed)))
			end
		end
	end
end