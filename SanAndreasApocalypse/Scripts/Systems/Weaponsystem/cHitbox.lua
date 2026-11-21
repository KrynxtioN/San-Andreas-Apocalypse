local weaponDamage = {0,1,2,3,4,5,6,7,8,22,23,24,25,26,27,28,29,32,30,31,33,34,35,36,37,38,16,17,18,39,41,42,10,11,12,14,15}

local function isWeaponDamage(weaponID)
	local available = false
	for _,v in pairs(weaponDamage)do
		if(v == weaponID)then
			available = true
			break
		end
	end
	return available
end

local Bloodscreen
function createBloodscreen()
	Bloodscreen = guiCreateStaticImage(0,0,1,1,"Files/Images/Bloodscreen.png",true)
	guiSetEnabled(Bloodscreen,false)
	guiSetAlpha(Bloodscreen,0)
end
createBloodscreen()

function showBloodFlash()
	if(isElement(Bloodscreen))then
		guiSetEnabled(Bloodscreen,true)
		if(isTimer(bloodTimer))then killTimer(bloodTimer)end
		bloodTimer = setTimer(bloodFlash,50,0)
		guiSetAlpha(Bloodscreen,1)
	end
end
addEvent("showBloodFlash",true)
addEventHandler("showBloodFlash",root,showBloodFlash)

function bloodFlash()
	if(isElement(Bloodscreen))then
		guiSetEnabled(Bloodscreen,true)
		if(isTimer(bloodTimer))then killTimer(bloodTimer)end
		bloodTimer = setTimer(function()
			local alpha = guiGetAlpha(Bloodscreen)
			if(alpha == 0)then
				killTimer(bloodTimer)
				guiSetEnabled(Bloodscreen,false)
			else
				guiSetAlpha(Bloodscreen,alpha-0.1)
			end
		end,50,0)
		guiSetAlpha(Bloodscreen,1)
	end
end

addEventHandler("onClientPlayerDamage", root, function(attacker, weapon, bodypart, loss)
    if apocalypseGetElementData(source, "inSafezone") == true or getElementInterior(source) > 0 then
        cancelEvent()
        return
    end
	
	if apocalypseGetElementData(source, "InBonusZone") ~= true or apocalypseGetElementData(attacker, "InBonusZone") ~= true then
		cancelEvent()
		return
	end
	

    if attacker == localPlayer and source ~= localPlayer then
        local sound = playSound("Files/Sounds/Hitsound.mp3")
        setSoundVolume(sound, 0.3)
    end

    if attacker and isWeaponDamage(weapon) == true and isElement(attacker) then
        local x, y, z = getElementPosition(attacker)
        triggerServerEvent("damageCalcServer", localPlayer, x, y, z, weapon, bodypart, loss, source)
    end

    if source == localPlayer and not isPedDead(localPlayer) then
        if apocalypseGetElementData(localPlayer, "DivingSuitUse") == true then
            return
        end
        showBloodFlash()
    end

    if isWeaponDamage(weapon) == true then
        cancelEvent()
    end
end)

local reddot = 0

function reddot_func()
	if(reddot == 0)then
		reddot = 1
		addEventHandler("onClientRender",root,reddot_render)
	else
		reddot = 0
		removeEventHandler("onClientRender",root,reddot_render)
	end
end
addEvent("reddot_func",true)
addEventHandler("reddot_func",root,reddot_func)

function reddot_render()
	if(isWindowOpen())then
		local weaponslot = getPedWeaponSlot(localPlayer)
		if(weaponslot and weaponslot <= 7 and weaponslot >= 2)then
			if(getPedControlState(localPlayer,"aim_weapon"))then
				local x1,y1,z1 = getPedWeaponMuzzlePosition(localPlayer)
				x1 = x1 + 0.01
				y1 = y1 + 0.01
				z1 = z1 + 0.01
				local x2,y2,z2 = getPedTargetEnd(localPlayer)
				local x3,y3,z3 = getPedTargetCollision(localPlayer)
				if(x3)then
					dxDrawLine3D(x1,y1,z1,x3,y3,z3,tocolor(255,0,0,150),4,false)
				else
					dxDrawLine3D(x1,y1,z1,x2,y2,z2,tocolor(255,0,0,150),4,false)
				end
			end
		end
	end
end