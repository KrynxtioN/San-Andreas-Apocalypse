CommunityTask = {
	["Pickups"] = {
		{708.42071533203,-466.86419677734,16.3359375},
	},
}

addEventHandler("onClientRender",root,function()
	if(isCharacterLoggedIn() and isWindowOpen())then
		for _,v in pairs(CommunityTask["Pickups"])do
			local x1,y1,z1 = v[1],v[2],v[3]
			local screenX1,screenY1 = getScreenFromWorldPosition(x1,y1,z1)
			
			if(screenX1 and screenY1)then
				if(getDistanceBetweenPoints3D(x1,y1,z1,getElementPosition(localPlayer)) <= 5)then
					dxDrawText(getText("CCommunityTask1"), screenX1 - 100, screenY1 - 20, screenX1 + 100, screenY1 + 20, tocolor(255, 255, 255), 1.2, "default-bold", "center", "center")
				end
			end
		end
	end
end)

local topList = {}
local myRank = nil
local isVisible = false
local screenW, screenH = guiGetScreenSize()
local font = "default-bold"

for _,v in pairs(CommunityTask["Pickups"])do
	local pickup = createPickup(v[1],v[2],v[3],3,1239,50)
	
	addEventHandler("onClientPickupHit",pickup,function(player)
		if(player == localPlayer)then
			if(getElementDimension(localPlayer) == getElementDimension(source))then
				if(getElementInterior(localPlayer) == getElementInterior(source))then
					triggerServerEvent("CommunityTask.loadZombieKills",localPlayer)
				end
			end
		end
	end)
end

addEvent("CommunityTask.loadClientZombieKills", true)
addEventHandler("CommunityTask.loadClientZombieKills", localPlayer, function(top, my)
    topList = top or {}
    myRank = my
	
	addEventHandler("onClientRender", root, CommunityTask.render)
end)

function CommunityTask.render()
    local x, y, w, h = screenW/2 - 250, screenH/2 - 200, 500, 400
    dxDrawRectangle(x, y, w, h, tocolor(0, 0, 0, 200))
    dxDrawText(getText("CCommunityTask2"), x, y - 25, x + w, y, tocolor(255, 255, 255, 255), 1.2, font, "center", "bottom")

    dxDrawText(getText("CCommunityTask3"), x + 10, y + 10, x + 60, y + 40, tocolor(255, 200, 0, 255), 1, font)
    dxDrawText(getText("CCommunityTask4"), x + 70, y + 10, x + 300, y + 40, tocolor(255, 200, 0, 255), 1, font)
    dxDrawText(getText("CCommunityTask5"), x + 310, y + 10, x + 490, y + 40, tocolor(255, 200, 0, 255), 1, font)

    for i, entry in ipairs(topList) do
        local name = entry[1]
        local kills = entry[2]
        local offsetY = y + 40 + (i - 1) * 30
        dxDrawText(i .. ".", x + 10, offsetY, x + 60, offsetY + 30, tocolor(255, 255, 255, 255), 1, font)
        dxDrawText(name, x + 70, offsetY, x + 300, offsetY + 30, tocolor(255, 255, 255, 255), 1, font)
        dxDrawText(kills, x + 310, offsetY, x + 490, offsetY + 30, tocolor(255, 255, 255, 255), 1, font)
    end

    if myRank and myRank.rank > 10 then
        dxDrawText(getText("CCommunityTask6"):format(myRank.rank,myRank.kills), x, y + h + 5, x + w, y + h + 25, tocolor(200, 200, 200, 255), 1, font, "center", "top")
    end
	
	if(getDistanceBetweenPoints3D(708.42071533203,-466.86419677734,16.3359375,getElementPosition(localPlayer)) > 2.5)then
		removeEventHandler("onClientRender",root,CommunityTask.render)
	end
end