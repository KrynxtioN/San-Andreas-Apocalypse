BonuspointsShop = {}

addEvent("BonuspointsShop.buy",true)
addEventHandler("BonuspointsShop.buy",root,function(costs,id,bonuspoints,Type)
	local costs, id = tonumber(costs), tonumber(id)
	local bonuspoints = tonumber(bonuspoints)
	if(tonumber(apocalypseGetElementData(client,"money")) >= costs)then
		if(hasPlayerItem(client,180) >= bonuspoints)then
			if(Type == "Document")then
				if(hasPlayerDocument(client,id) == false)then
					takeItem(client,180,bonuspoints)
					setDocument(client,id)
					apocalypseSetElementData(client,"money",apocalypseGetElementData(client,"money")-costs)
					NPC.NormalMessage(client,getText(client,"SBonuspointsShop2"))
					outputLog(getPlayerName(client).." hat das Dokument mit der ID "..id.." gekauft","Bonuspointshop",getCharacterID(client))
				else
					NPC.NormalMessage(client,getText(client,"SBonuspointsShop3"))
				end
			elseif(Type == "Tent")then
				takeItem(client,180,bonuspoints)
				giveItem(client,181,1)
				apocalypseSetElementData(client,"money",apocalypseGetElementData(client,"money")-costs)
				NPC.NormalMessage(client,getText(client,"SBonuspointsShop5"))
				outputLog(getPlayerName(client).." hat ein Zelt gekauft","Bonuspointshop",getCharacterID(client))
			elseif(Type == "CraftingRecipe")then
				if(hasPlayerCraftingRecipe(client,id) == false)then
					takeItem(client,180,bonuspoints)
					addPlayerCraftingRecipe(client,id)
					apocalypseSetElementData(client,"money",apocalypseGetElementData(client,"money")-costs)
					NPC.NormalMessage(client,getText(client,"SBonuspointsShop6"))
					outputLog(getPlayerName(client).." hat das Craftingrezept mit der ID "..id.." gekauft","Bonuspointshop",getCharacterID(client))
				else
					NPC.NormalMessage(client,getText(client,"SBonuspointsShop7"))
				end
			elseif(Type == "Coordinates")then
				if(hasRadioLocation(client,id) == false)then
					takeItem(client,180,bonuspoints)
					giveRadioData(client,id)
					apocalypseSetElementData(client,"money",apocalypseGetElementData(client,"money")-costs)
					NPC.NormalMessage(client,getText(client,"SBonuspointsShop8"))
					outputLog(getPlayerName(client).." hat die Funkgerätdaten mit der ID "..id.." gekauft","Bonuspointshop",getCharacterID(client))
				else
					NPC.NormalMessage(client,getText(client,"SBonuspointsShop9"))
				end
			elseif(Type == "Notes")then
				if(hasPlayerItem(client,206) < 1)then
					takeItem(client,180,bonuspoints)
					giveItem(client,206,1)
					apocalypseSetElementData(client,"money",apocalypseGetElementData(client,"money")-costs)
					NPC.NormalMessage(client,getText(client,"SBonuspointsShop10"))
					outputLog(getPlayerName(client).." hat das Notizbuch gekauft","Bonuspointshop",getCharacterID(client))
				else
					NPC.NormalMessage(client,getText(client,"SBonuspointsShop11"))
				end
			end
		else
			NPC.NormalMessage(client,getText(client,"SBonuspointsShop4"))
		end
	else
		NPC.NormalMessage(client,getText(client,"SBonuspointsShop1"))
	end
end)