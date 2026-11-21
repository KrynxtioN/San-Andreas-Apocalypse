local rendered = false
local x,y = guiGetScreenSize()

function BuildingsLoot.InfoRender()
	if(BuildingsLoot.text and isWindowOpen())then
		dxDrawText(BuildingsLoot.text.." ("..BuildingsLoot.looted.."/"..BuildingsLoot.total..")", 643*(x/1920), 1032*(y/1080), 1277*(x/1920), 1075*(y/1080), tocolor(255, 255, 255, 255), 1.20*(x/1920), "default", "center", "center", false, false, false, true, false)
	end
end

addEvent("BuildingsLoot.Info",true)
addEventHandler("BuildingsLoot.Info",root,function(text)
	if(text)then
		BuildingsLoot.text = text
		if(rendered == false)then
			rendered = true
			addEventHandler("onClientRender",root,BuildingsLoot.InfoRender)
		end
	else
		rendered = false
		removeEventHandler("onClientRender",root,BuildingsLoot.InfoRender)
	end
end)

addEvent("BuildingsLoot.updateAmount",true)
addEventHandler("BuildingsLoot.updateAmount",root,function(totalLoot,looted)
	BuildingsLoot.total = totalLoot
	BuildingsLoot.looted = looted
end)

addEventHandler("onClientPlayerWasted", localPlayer, function()
	if(source == localPlayer)then
		rendered = false
		removeEventHandler("onClientRender",root,BuildingsLoot.InfoRender)
	end
end)