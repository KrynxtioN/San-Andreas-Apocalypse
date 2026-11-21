local rendered = false
local x,y = guiGetScreenSize()

function HouseLoot.InfoRender()
	if(HouseLoot.text and isWindowOpen())then
		dxDrawText(HouseLoot.text.." ("..HouseLoot.looted.."/"..HouseLoot.total..")", 643*(x/1920), 1032*(y/1080), 1277*(x/1920), 1075*(y/1080), tocolor(255, 255, 255, 255), 1.20*(x/1920), "default", "center", "center", false, false, false, true, false)
	end
end

addEvent("HouseLoot.Info",true)
addEventHandler("HouseLoot.Info",root,function(text)
	if(text)then
		HouseLoot.text = text
		if(rendered == false)then
			rendered = true
			addEventHandler("onClientRender",root,HouseLoot.InfoRender)
		end
	else
		rendered = false
		removeEventHandler("onClientRender",root,HouseLoot.InfoRender)
	end
end)

addEvent("HouseLoot.LootInfo",true)
addEventHandler("HouseLoot.LootInfo",root,function()
	createActivitiesInformationText(getText("CActivitiesInformation2"))
end)

addEvent("HouseLoot.updateAmount",true)
addEventHandler("HouseLoot.updateAmount",root,function(totalLoot,looted)
	HouseLoot.total = totalLoot
	HouseLoot.looted = looted
end)

addEventHandler("onClientPlayerWasted", localPlayer, function()
	if(source == localPlayer)then
		rendered = false
		removeEventHandler("onClientRender",root,HouseLoot.InfoRender)
	end
end)