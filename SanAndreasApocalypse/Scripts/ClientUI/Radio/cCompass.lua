local CompassRendered = false

function drawCompass()
	if(isWindowOpen() and not(isPedDead(localPlayer)) and not(isPlayerMapVisible()) and not(isTimer(animationWeaponbarTimer1)) and DialogSystem.active == false)then
		if(InformationHelpBarOpen == false)then
			local screenW, screenH = guiGetScreenSize()
			local playerRotation = getPedCameraRotation(localPlayer) % 360
			
			local centerX = screenW * 0.5
			local compassY = screenH * 0.95
			
			local directions = {
				{angle = 0, label = "N"}, 
				{angle = 45, label = "NE"}, 
				{angle = 90, label = "E"}, 
				{angle = 135, label = "SE"}, 
				{angle = 180, label = "S"}, 
				{angle = 225, label = "SW"}, 
				{angle = 270, label = "W"}, 
				{angle = 315, label = "NW"},
			}
			
			for i = -90, 90, 15 do
				local angle = (playerRotation + i) % 360
				local posX = centerX + (i * (screenW * 0.4/180))
				
				local label = nil
				for _,v in pairs(directions)do
					if(math.abs(angle - v.angle) < 7.5)then
						label = v.label
						break
					end
				end
				
				if(label)then
					dxDrawText(label, posX - 10, compassY + 15, posX + 10, compassY, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "center")
				else
					dxDrawText(tostring(math.floor(angle)), posX - 10, compassY + 15, posX + 10, compassY, tocolor(255, 255, 255, 200), 0.8, "default-bold", "center", "center")
				end
			end
		end
	end
end

local radar_disabled = false
local disable_radar_rendered = false

local function disableRadar()
	radar_disabled = true
	toggleControl("radar",false)
	setPlayerHudComponentVisible("radar",false)
end

addEvent("renderCompass",true)
addEventHandler("renderCompass",root,function()
	if(CompassRendered == false)then
		CompassRendered = true
		addEventHandler("onClientRender",root,drawCompass)
	end
end)

function DisableF11()
	if(radar_disabled == false)then
		if(disable_radar_rendered == false)then
			disable_radar_rendered = true
			addEventHandler("onClientRender",root,disableRadar)
		end
	end
end
addEvent("DisableF11",true)
addEventHandler("DisableF11",root,DisableF11)

function ActivateF11()
	removeEventHandler("onClientRender",root,disableRadar)
	radar_disabled = false
	toggleControl("radar",true)
	disable_radar_rendered = false
	setPlayerHudComponentVisible("radar",true)
end
addEvent("ActivateF11",true)
addEventHandler("ActivateF11",root,ActivateF11)