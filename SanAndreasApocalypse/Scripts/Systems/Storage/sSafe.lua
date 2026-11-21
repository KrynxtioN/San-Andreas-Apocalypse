addEvent("Safe.StorageMoney_TakeOut", true)
addEventHandler("Safe.StorageMoney_TakeOut", root, function(amount)
	local amount = tonumber(amount)
	if(tonumber(apocalypseGetElementData(client, "safemoney")) >= amount)then
		apocalypseSetElementData(client, "safemoney", apocalypseGetElementData(client, "safemoney")-amount)
		givePlayerServerMoney(client,amount)
		createInfobox(client, getText(client, "SSafe2"):format(amount))
		triggerClientEvent(client, "Safe.updateLabel", client, apocalypseGetElementData(client, "safemoney"))
	else
		createInfobox(client, getText(client, "SSafe1"))
	end
end)

addEvent("Safe.StorageMoney_PutIn", true)
addEventHandler("Safe.StorageMoney_PutIn", root, function(amount)
	local amount = tonumber(amount)
	local safemoney = tonumber(apocalypseGetElementData(client,"safemoney"))
	if(safemoney + amount <= 50000)then
		if(tonumber(apocalypseGetElementData(client, "money")) >= amount)then
			apocalypseSetElementData(client, "safemoney", apocalypseGetElementData(client, "safemoney")+amount)
			apocalypseSetElementData(client, "money", apocalypseGetElementData(client, "money")-amount)
			createInfobox(client, getText(client, "SSafe4"):format(amount))
			triggerClientEvent(client, "Safe.updateLabel", client, apocalypseGetElementData(client, "safemoney"))
		else
			createInfobox(client, getText(client, "SSafe3"))
		end
	else
		NPC.MeMessage(client,getText(client,"MeMessage18"))
	end
end)

addEvent("Safe.getData", true)
addEventHandler("Safe.getData", root, function()
	local money = apocalypseGetElementData(client, "safemoney")
	triggerClientEvent(client, "Safe.updateLabel", client, money)
end)

addEventHandler("onPlayerClick", root, function(button, state, clickedElement)
	if(button == "left" and state == "down" and clickedElement)then
		if(isElement(clickedElement))then
			local x, y, z = getElementPosition(source)
			if(getDistanceBetweenPoints3D(x, y, z, getElementPosition(clickedElement)) <= 5)then
				if(getElementModel(clickedElement) == 2332 and apocalypseGetElementData(clickedElement,"SafeObject") == true)then
					triggerClientEvent(source, "PlayerSafe.openWindow", source)
				else
					if(getElementModel(clickedElement) == 2332 and apocalypseGetElementData(clickedElement,"ExplodableSafe") ~= true)then
						if(tonumber(apocalypseGetElementData(source,"level")) >= 5)then
							triggerClientEvent(source, "Safe.open", source)
						else
							createInfobox(source,getText(source,"SSafe5"))
						end
					end
				end
			end
		end
	end
end)