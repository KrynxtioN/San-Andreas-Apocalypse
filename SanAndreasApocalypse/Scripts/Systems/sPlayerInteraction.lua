PlayerInteraction = {}
TradeableItems = {1,2,3,4,6,7,8,9,12,13,14,15,16,17,18,19,19,20,21,22,23,26,27,28,29,30,31,32,33,34,35,36,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,94,95,96,97,98,99,100,101,102,105,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,133,134,135,136,137,138,139,140,141,142,143,144,146,147,148,149,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,174,175,176,177,178,179,182,184,185,186,187,192,193,194,195,196,197,198,199,200,202,203,204,205}

function PlayerInteraction.getItems(player)
	if(not(player))then player = client end
	local items = {}
	for _,v in pairs(TradeableItems)do
		if(hasPlayerItem(client,v) >= 1)then
			table.insert(items,{v,hasPlayerItem(client,v)})
		end
	end
	triggerClientEvent(client,"PlayerInteraction.updateItems",client,items)
end
addEvent("PlayerInteraction.getItems",true)
addEventHandler("PlayerInteraction.getItems",root,PlayerInteraction.getItems)

addEventHandler("onPlayerClick", root, function(button, state, clickedElement)
    if isCharacterLoggedIn(source) then
        if button == "left" and state == "down" then
            if clickedElement and isElement(clickedElement) and getElementType(clickedElement) == "player" then
				if(clickedElement ~= source)then
					local target = clickedElement
					if isCharacterLoggedIn(target) then
						local x, y, z = getElementPosition(target)
						if getDistanceBetweenPoints3D(x, y, z, getElementPosition(source)) <= 5 then
							triggerClientEvent(source, "PlayerInteraction", source)
							apocalypseSetElementData(source,"PlayerInteraction",clickedElement)
							apocalypseSetElementData(source,"PlayerInteraction_Name",getPlayerName(clickedElement))
						end
					end
				end
            end
        end
    end
end)

addEvent("PlayerInteraction.giveItem",true)
addEventHandler("PlayerInteraction.giveItem",root,function(item,amount)
	local target = apocalypseGetElementData(client,"PlayerInteraction")
	if(target)then
		if(isElement(target))then
			local item, amount = tonumber(item), tonumber(amount)
			if(hasPlayerItem(client,item) >= amount)then
				local ItemName = ItemInfos["items"][apocalypseGetElementData(client,"language") or "EN"][item]
				giveItem(target,item,amount)
				takeItem(client,item,amount)
				createInfobox(client,getText(client,"SPlayerInteraction1"):format(getPlayerName(target),amount,ItemInfos["items"][apocalypseGetElementData(client,"language") or "EN"][item]))
				createInfobox(target,getText(target,"SPlayerInteraction2"):format(getPlayerName(client),amount,ItemInfos["items"][apocalypseGetElementData(target,"language") or "EN"][item]))
				PlayerInteraction.getItems(client)
			else createInfobox(client,getText(client,"SPlayerInteraction3"))end
		else createInfobox(client,getText(client,"SPlayerInteraction4"))end
	end
end)