Garage = {enter_marker = {}, playerVehicles = {}, selectedVehicle = 0,
	["EnterMarker"] = {
		{681.50378417969,-445.64517211914,16.9359375},			-- // Zone 11: Dillimore's Hope Safe Zone
		{-1964.0478515625,107.52736663818,28.6875},				-- //
		{-2103.48828125,-2405.3974609375,32.396190643311},		-- //
		{-2454.9780273438,-123.05352020264,26.829398345947},	-- // Spinosaurus Club
	},
}

for i,v in ipairs(Garage["EnterMarker"])do
	Garage.enter_marker[i] = createMarker(v[1],v[2],v[3],"arrow",1,255,255,255)
	local marker = createMarker(v[1],v[2],v[3]-1,"cylinder",3,0,0,0,0)
	apocalypseSetElementData(marker,"Garage.ID",i)
	
	addEventHandler("onClientMarkerHit",marker,function(player)
		if(player == localPlayer)then
			if(getElementDimension(localPlayer) == getElementDimension(source))then
				if(getElementInterior(localPlayer) == getElementInterior(source))then
					apocalypseSetElementData(localPlayer,"Garage.ID",apocalypseGetElementData(source,"Garage.ID"))
					bindKey("e","down",Garage.checkOpen)
				end
			end
		end
	end)
	
	addEventHandler("onClientMarkerLeave",marker,function(player)
		unbindKey("e","down",Garage.checkOpen)
	end)
end

addEventHandler("onClientRender", root, function()
	if(isCharacterLoggedIn())then
		local text = getText("CGarage1")
		local smallerText = getText("CGarage2")
		local textSize = 1.5
		local smallerTextSize = 1.0
		local textColor = tocolor(255, 255, 255, 255)
		local proximityDistance = 10

		local playerX, playerY, playerZ = getElementPosition(localPlayer)

		for _, v in pairs(Garage["EnterMarker"]) do
			local posx, posy, posz = v[1], v[2], v[3]
			local sx, sy = getScreenFromWorldPosition(posx, posy, posz + 0.5)
			
			if(sx and sy)then
				local distance = getDistanceBetweenPoints3D(playerX, playerY, playerZ, posx, posy, posz)
				if(distance <= proximityDistance)then
					dxDrawText(text, sx, sy, sx, sy, textColor, textSize, "default", "center", "center")
					local smallerSx, smallerSy = getScreenFromWorldPosition(posx, posy, posz + 0.3)
					dxDrawText(smallerText, smallerSx, smallerSy, smallerSx, smallerSy, textColor, smallerTextSize, "default", "center", "center")
				end
			end
		end
	end
end)

function garageTextRender()
	if(Garage.playerVehicles[Garage.selectedVehicle])then
		local x,y = guiGetScreenSize()
		local parkstatus = Garage.playerVehicles[Garage.selectedVehicle][5]
		if(parkstatus == 0)then parkstatus = getText("CGarage6") else parkstatus = getText("CGarage7")end
		dxDrawText(getText("CGarage4"), 643*(x/1920), 1032*(y/1080), 1277*(x/1920), 1075*(y/1080), tocolor(255, 255, 255, 255), 1.20*(x/1920), "default", "center", "center", false, false, false, false, false)
		dxDrawText(getText("CGarage5"):format(getVehicleNameFromModel(Garage.playerVehicles[Garage.selectedVehicle][3]),parkstatus,Garage.playerVehicles[Garage.selectedVehicle][6],Garage.playerVehicles[Garage.selectedVehicle][4]), 10, 110, x, 180, tocolor(255, 255, 255, 255), 1.2, "default-bold")
	end
end

function Garage.checkOpen()
	local ID = apocalypseGetElementData(localPlayer,"Garage.ID")
	local x,y,z = getElementPosition(Garage.enter_marker[ID])
	if(getDistanceBetweenPoints3D(x,y,z,getElementPosition(localPlayer)) <= 3.5)then
		triggerServerEvent("Garage.checkOpen",localPlayer)
	end
	unbindKey("e","down",Garage.checkOpen)
end

function Garage.open()
	unbindKey("e","down",Garage.checkOpen)
	fadeCameraWithInformation(getText("CGarage3"))
	Garage.Gate = createObject(2774,-2054.4365234375,172.19140625,24.916500091553,0,0,90)
	setTimer(function()
		showChat(false)
		setPlayerHudComponentVisible("radar",false)
		HUD.Visible = false
		Levelsystem.Visible = false
		addEventHandler("onClientRender",root,drawBlackBars)
		setWindowData("no")
		triggerServerEvent("Garage.getPlayerVehicles",localPlayer)
		setCameraMatrix(-2028.2733154297,182.85214233398,33.286117553711,-2119.0461425781,145.4405670166,14.294427871704,0,70)
		smoothMoveCamera(-2028.2733154297,182.85214233398,33.286117553711,-2119.0461425781,145.4405670166,14.294427871704,-2041.1586914062,177.50741577148,30.6598777771,-2131.6188964844,136.11364746094,20.486707687378,7500)
		Garage.Timer = setTimer(function()
			addEventHandler("onClientRender",root,garageTextRender)
			smoothMoveCamera(-2041.1586914062,177.50741577148,30.6598777771,-2131.6188964844,136.11364746094,20.486707687378,-2045.2362060547,169.73071289062,30.21187210083,-2104.3161621094,89.058891296387,28.938056945801,5000)
		end,7500,1)
	end,1000,1)
end
addEvent("Garage.open",true)
addEventHandler("Garage.open",root,Garage.open)

local function rotateVehicle()
	if(isElement(Garage.showVehicle))then
		local rx,ry,rz = getElementRotation(Garage.showVehicle)
		setElementRotation(Garage.showVehicle,rx,ry,rz+1)
	end
end

addEvent("Garage.updatePlayerVehicles",true)
addEventHandler("Garage.updatePlayerVehicles",root,function(vehicles)
	Garage.playerVehicles = vehicles
	if(Garage.selectedVehicle == 0)then
		Garage.selectedVehicle = 1
		Garage.createSelectedVehicle(Garage.playerVehicles[1][3])
			
		bindKey("arrow_l","down",Garage.leftKey)
		bindKey("arrow_r","down",Garage.rightKey)
			
		bindKey("enter","down",Garage.park)
		addEventHandler("onClientRender",root,rotateVehicle)

		bindKey("backspace","down",Garage.closeFunction)
	end
end)

function Garage.createSelectedVehicle(model)
	if(isElement(Garage.showVehicle))then destroyElement(Garage.showVehicle)end
	Garage.showVehicle = createVehicle(model,-2050.9514160156,161.59880065918,29.608400344849,0,0,0)
end

function Garage.leftKey()
	if(Garage.selectedVehicle > 1)then
		Garage.selectedVehicle = Garage.selectedVehicle - 1
		Garage.createSelectedVehicle(Garage.playerVehicles[Garage.selectedVehicle][3])
	end
end

function Garage.rightKey()
	if(Garage.selectedVehicle < #Garage.playerVehicles)then
		Garage.selectedVehicle = Garage.selectedVehicle + 1
		Garage.createSelectedVehicle(Garage.playerVehicles[Garage.selectedVehicle][3])
	end
end

function Garage.park()
	triggerServerEvent("Garage.park",localPlayer,Garage.playerVehicles[Garage.selectedVehicle][1],apocalypseGetElementData(localPlayer,"Garage.ID"))
end

function Garage.close()
	removeCamHandler()
	unbindKey("arrow_l","down",Garage.leftKey)
	unbindKey("arrow_r","down",Garage.rightKey)
	
	unbindKey("enter","down",Garage.park)
	unbindKey("backspace","down",Garage.closeFunction)
	
	removeEventHandler("onClientRender",root,rotateVehicle)
	closeWindow()
	setCameraTarget(localPlayer)
	if(isTimer(Garage.Timer))then killTimer(Garage.Timer)end
	if(isElement(Garage.showVehicle))then destroyElement(Garage.showVehicle)end

	HUD.Visible = true
	Levelsystem.Visible = true
	removeEventHandler("onClientRender",root,drawBlackBars)
	showChat(true)
	removeEventHandler("onClientRender",root,garageTextRender)
	Garage.selectedVehicle = 0
	
	if isElement(Garage.Gate) then destroyElement(Garage.Gate) end
	Garage.Gate = nil
end
addEvent("Garage.close",true)
addEventHandler("Garage.close",root,Garage.close)

function Garage.closeFunction()
	triggerServerEvent("Garage.spawnPlayerOutside",localPlayer)
	Garage.close()
end

addEventHandler("onClientPlayerWasted",root,function(player)
	if(player == localPlayer)then
		Garage.close()
	end
end)