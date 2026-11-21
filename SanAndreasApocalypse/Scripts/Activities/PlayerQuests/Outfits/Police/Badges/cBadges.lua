PoliceBadges = {marker = {}}
local x,y = guiGetScreenSize()

local BadgeID = nil

function PoliceBadges.InfoRender()
	if(PoliceBadges.text and isWindowOpen())then
		dxDrawText(PoliceBadges.text, 643*(x/1920), 1032*(y/1080), 1277*(x/1920), 1075*(y/1080), tocolor(255, 255, 255, 255), 1.20*(x/1920), "default", "center", "center", false, false, false, true, false)
	end
end

addEvent("PoliceBadges.createMarker",true)
addEventHandler("PoliceBadges.createMarker",root,function(id,x,y,z,size,int,dim)
	if(not(isElement(PoliceBadges.marker[id])))then
		PoliceBadges.marker[id] = createMarker(x,y,z,"cylinder",2,255,255,255,0)
		setElementInterior(PoliceBadges.marker[id],int)
		setElementDimension(PoliceBadges.marker[id],dim)
		apocalypseSetElementData(PoliceBadges.marker[id],"PoliceBadge",id)
		
		addEventHandler("onClientMarkerHit",PoliceBadges.marker[id],function(player)
			if(player == localPlayer)then
				if(getElementDimension(player) == getElementDimension(source))then
					if(getElementInterior(player) == getElementInterior(source))then
						if(not(isPedInVehicle(player)))then
							BadgeID = id
							PoliceBadges.text = getText("CQuests6")
							addEventHandler("onClientRender",root,PoliceBadges.InfoRender)
							bindKey("e","down",PoliceBadges.collect)
						end
					end
				end
			end
		end)
		
		addEventHandler("onClientMarkerLeave",PoliceBadges.marker[id],function(player)
			if(player == localPlayer)then
				removeEventHandler("onClientRender",root,PoliceBadges.InfoRender)
				unbindKey("e","down",PoliceBadges.collect)
			end
		end)
	end
end)

function PoliceBadges.collect()
	removeEventHandler("onClientRender",root,PoliceBadges.InfoRender)
	unbindKey("e","down",PoliceBadges.collect)
	triggerServerEvent("givePoliceBadge",localPlayer,BadgeID)
	if(isElement(PoliceBadges.marker[BadgeID]))then
		destroyElement(PoliceBadges.marker[BadgeID])
	end
end