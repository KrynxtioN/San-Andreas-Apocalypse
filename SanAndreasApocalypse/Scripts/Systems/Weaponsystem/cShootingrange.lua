shootingRange = {}
local x,y = guiGetScreenSize()

function shootingRange.onClientPlayerWeaponFireFunc(weapon,ammo,ammoInClip,hitX,hitY,hitZ,hitElement)
	if(apocalypseGetElementData(localPlayer, "isInShootingRange") == true)then
		if(isElement(hitElement))then
			if(apocalypseGetElementData(hitElement, "target") == true)then
				if(apocalypseGetElementData(hitElement, "hitAble") == true)then
					triggerServerEvent("shootingRange.onTargetHit",localPlayer,hitElement)
				end
			end
		end
	else
	end
end
addEventHandler("onClientPlayerWeaponFire",localPlayer,shootingRange.onClientPlayerWeaponFireFunc)

function shootingRange.showStats(type)
	if(type == "create")then
		addEventHandler("onClientRender",root,shootingRange.drawTime)
	else
		removeEventHandler("onClientRender",root,shootingRange.drawTime)
	end
end
addEvent("shootingRange.showShootingsStats", true)
addEventHandler("shootingRange.showShootingsStats", getRootElement(), shootingRange.showStats)

function shootingRange.drawTime()
	HUD.Visible = false
    local hits = apocalypseGetElementData(localPlayer, "shootingrange_hits") or 0
    local totalAmmo = getPedTotalAmmo(localPlayer)
    local acc = (250 - totalAmmo) > 0 and math.floor(hits * 100 / (250 - totalAmmo)) or 0

    local baseX, baseY = x - 220, 50
    local width, height = 170, 60
    local scale = x / 1440
    dxDrawRectangle(baseX, baseY, width * scale, height * scale, tocolor(0, 0, 0, 160), false)
    dxDrawRectangle(baseX, baseY, width * scale, 3 * scale, tocolor(200,25,25, 220), false)
    dxDrawText(getText("CWeaponskills8").." "..hits.."/30", baseX + 10 * scale, baseY + 10 * scale, baseX + width * scale, baseY + 30 * scale, tocolor(255, 255, 255, 240), 1 * scale, "default-bold", "left", "top", false)
    dxDrawText(getText("CWeaponskills9").." "..acc.."%", baseX + 10 * scale, baseY + 30 * scale, baseX + width * scale, baseY + 50 * scale, tocolor(255, 255, 255, 240), 1 * scale, "default-bold", "left", "top", false)
end

addEventHandler("onClientPlayerDamage",localPlayer,function()
	if(apocalypseGetElementData(localPlayer,"isInShootingRange") == true)then
		cancelEvent()
	end
end)

addEventHandler("onClientPlayerWasted",root,function()
	if(source == localPlayer)then
		removeEventHandler("onClientRender",root,shootingRange.drawTime)
		HUD.Visible = true
	end
end)