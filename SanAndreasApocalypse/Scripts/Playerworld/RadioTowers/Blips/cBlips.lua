local BlipStatus = {}
local BlipCategoryStatus = {}
local SaveBlipsTemporary = {}
local Rendered = false

function updateBlipStatus()
	for _,v in pairs(getElementsByType("blip"))do
		if(isElement(v))then
			local BlipID = getBlipIcon(v)
			if(not(BlipStatus[BlipID]))then
				BlipStatus[BlipID] = true
			end
			if(not(BlipCategoryStatus[BlipID]))then
				if(BlipID == 38)then
					BlipCategoryStatus[BlipID] = false
					SaveBlipsTemporary[BlipID] = {}
					for _,blip in pairs(getElementsByType("blip"))do
						if(getBlipIcon(blip) == BlipID)then
							local x,y,z = getElementPosition(blip)
							table.insert(SaveBlipsTemporary[BlipID],{x,y,z,getBlipIcon(blip)})
							destroyElement(blip)
						end
					end
				else
					BlipCategoryStatus[BlipID] = true
				end
			end
		end
	end
	
	for i = 100,102 do
		if(not(BlipStatus[i]))then
			BlipStatus[i] = true
		end
		if(not(BlipCategoryStatus[i]))then
			BlipCategoryStatus[i] = false
		end
	end
end
addEvent("updateBlipStatus",true)
addEventHandler("updateBlipStatus",root,updateBlipStatus)

function BliplegendRender()
	if(isWindowOpen() and isPlayerMapVisible())then
		local x,y = guiGetScreenSize()
		local baseX, baseY = 1179 * (x / 1440), 4
		local position = 0
		for i, v in ipairs(Bliplegend[apocalypseGetElementData(localPlayer,"language") or "EN"]) do
			if(BlipStatus[v[2]] and BlipStatus[v[2]] == true)then
				position = position + 1
				local offsetY = baseY + (position - 1) * 20 * (y / 900)
				local iconSize = 16 * (x / 1440)
				local textOffsetX = 22 * (x / 1440)
				local alpha = 255
				
				if(BlipCategoryStatus[v[2]] == false)then alpha = 125 end

				dxDrawImage(baseX, offsetY, iconSize, iconSize, "Files/Images/Blips/" .. v[2] .. ".png", 0, 0, 0, tocolor(255, 255, 255, alpha), false)

				dxDrawText(v[1], baseX + textOffsetX + 1, offsetY + 1, baseX + textOffsetX + 250, offsetY + iconSize, tocolor(0, 0, 0, alpha), 0.9 * (x / 1440), "default-bold", "left", "center", false, false, false, false, false)
				dxDrawText(v[1], baseX + textOffsetX, offsetY, baseX + textOffsetX + 250, offsetY + iconSize, tocolor(255, 255, 255, alpha), 0.9 * (x / 1440), "default-bold", "left", "center", false, false, false, false, false)
			end
		end
	end
end

addEvent("BliplegendRender",true)
addEventHandler("BliplegendRender",root,function()
	updateBlipStatus()
	if(Rendered == false)then
		Rendered = true
		addEventHandler("onClientRender",root,BliplegendRender)
	end
end)

function toggleBlipCategoryClick(mouseX, mouseY)
	local x,y = guiGetScreenSize()
	local baseX, baseY = 1179 * (x / 1440), 4
	local position = 0
	
	for i, v in ipairs(Bliplegend["EN"]) do
		if(BlipStatus[v[2]] and BlipStatus[v[2]] == true)then
			position = position + 1
			local offsetY = baseY + (position - 1) * 20 * (y / 900)
			local iconSize = 16 * (x / 1440)
			local textOffsetX = 22 * (x / 1440)
			if(mouseX >= baseX + textOffsetX and mouseX <= baseX + textOffsetX + 250 and mouseY >= offsetY and mouseY <= offsetY + iconSize)then
				if(BlipCategoryStatus[v[2]] == true)then
					if(v[2] == 102)then
						triggerServerEvent("HouseLoot.showBlipsFalse",localPlayer)
					elseif(v[2] == 101)then
						triggerServerEvent("BuildingsLoot.showBlipsFalse",localPlayer)
					elseif(v[2] == 100)then
					
					else
						SaveBlipsTemporary[v[2]] = {}
						for _,blip in pairs(getElementsByType("blip"))do
							if(getBlipIcon(blip) == v[2])then
								local x,y,z = getElementPosition(blip)
								table.insert(SaveBlipsTemporary[v[2]],{x,y,z,getBlipIcon(blip)})
								destroyElement(blip)
							end
						end
					end
					BlipCategoryStatus[v[2]] = false
				else
					if(v[2] == 102)then
						triggerServerEvent("HouseLoot.showBlipsTrue",localPlayer)
					elseif(v[2] == 101)then
						triggerServerEvent("BuildingsLoot.showBlipsTrue",localPlayer)
					elseif(v[2] == 100)then
					
					else
						for _,blip in pairs(SaveBlipsTemporary[v[2]])do
							createBlip(blip[1],blip[2],blip[3],blip[4],1,0,0,0,255,0,250)
						end
					end
					BlipCategoryStatus[v[2]] = true
				end
			end
		end
	end
end

addEventHandler("onClientClick", root, function(button, state, absoluteX, absoluteY)
    if(button == "left" and state == "up")then
		if(isCharacterLoggedIn() and Rendered == true)then
			toggleBlipCategoryClick(absoluteX, absoluteY)
		end
    end
end)
	
local Blips = {}

addEvent("addPlayerBlip",true)
addEventHandler("addPlayerBlip",root,function(ID)
	local ID = tonumber(ID)
	if(BlipData[ID])then
		if(not(isElement(Blips[ID])))then
			if(BlipData[ID][5] ~= false)then
				Blips[ID] = createBlip(BlipData[ID][1],BlipData[ID][2],BlipData[ID][3],BlipData[ID][4],1,0,0,0,255,0,250)
			end
		end
	end
end)