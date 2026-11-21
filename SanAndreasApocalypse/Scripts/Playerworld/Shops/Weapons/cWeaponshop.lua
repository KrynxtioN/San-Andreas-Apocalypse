local x, y = guiGetScreenSize()

Weaponshop = { Timer = {},
	["Weapons"] = {
			[1] = {346, 347, 348, 349, 350, 351},
			[2] = {352,353,372,355,356},
			[3] = {357,358},
			[4] = {331,333,334,336,337,338},
			[5] = {359,360,361},
		},
	["Weapon:Data"] = {
		[1] = {
			[346] = {22, 255, 85, "Colt 45", 0}, 
			[347] = {23, 306, 85, "Silenced", 5}, 
			[348] = {24, 147, 35, "Deagle", 10}, 
			[349] = {25, 24, 5, "Shotgun", 15}, 
			[350] = {26, 54, 10, "Sawed-off", 20}, 
			[351] = {27, 210, 35, "Combat Shotgun", 25}, 
		},
		[2] = {
			[352] = {28, 330, 50, "Uzi", 25},
			[353] = {29, 360, 50, "MP5", 30},
			[372] = {32, 390, 50, "Tec-9", 35},
			[355] = {30, 420, 50, "AK-47", 40},
			[356] = {31, 450, 50, "M4", 45},
		},
		[3] = {
			[357] = {33, 240, 25, "Rifle", 50},
			[358] = {34, 255, 25, "Sniper", 75},
		},
		[4] = {
			[331] = {1, 25, 1, "Brassknuckle", 5},
			[333] = {2, 30, 1, "Golfclub", 5},
			[334] = {3, 60, 1, "Nightstick", 5},
			[336] = {5, 45, 1, "Bat", 5},
			[337] = {6, 10, 1, "Shovel", 5},
			[338] = {7, 15, 1, "Poolstick", 5},
		},
		[5] = {
			[359] = {35,1000,1,"Rocket Launcher",25},
			[360] = {36,1000,1,"Rocket Launcher HS",25},
			[361] = {37,1000,50,"Flamethrower",25},
		},
	},
	["Weapon:CameraMatrix"] = {
		[1] = {
			{692.02661132812, -445.41998291016, 18.877058029175, 613.76110839844, -491.38818359375, -23.092418670654},
			{692.02661132812, -445.41998291016, 18.877058029175, 653.89782714844, -528.93389892578, -20.76658821106},
			{691.47326660156, -446.75021362305, 18.246015548706, 655.84063720703, -533.41717529297, -16.670309066772},
		},
		[2] = {
			{-1964.7434082031,119.7041015625,30.361730575562,-2020.279296875,44.36336517334,-4.8453650474548},
			{-1966.8454589844,117.80361938477,29.377395629883,-2034.6632080078,52.045181274414,-3.4339530467987},
			{-1968.2478027344,117.03820037842,29.093868255615,-1975.7479248047,31.499101638794,-22.158546447754},
		},
		[3] = {
			{-2080.1926269531,-2432.5505371094,31.508365631104,-2090.3579101562,-2530.6052246094,14.717747688293},
			{-2077.7783203125,-2434.3139648438,31.705438613892,-2171.2456054688,-2438.7094726562,-3.5727257728577},
			{-2079.3464355469,-2434.5041503906,31.241241455078,-2151.5119628906,-2497.2795410156,2.0629529953003},
		},
		[4] = {
		
		},
		[5] = {
			{2719.22265625,-1422.8291015625,19.520595550537,2791.986328125,-1391.0657958984,-41.278503417969},
			{2721.9614257812,-1422.0197753906,18.079452514648,2805.7404785156,-1394.0307617188,-28.800148010254},
			{2724.1640625,-1422.6119384766,17.285522460938,2727.9150390625,-1324.5036621094,-1.7061669826508},
		},
	},
	["Weapon:ObjectPos"] = {
		[1] = {690.72814941406, -448.33831787109, 17.266925811768, 0, 0, 180},
		[2] = {-1968.3336181641,115.42990112305,28.284999847412,338.50012207031,6.103515625e-05,180},
		[3] = {-2080.0698242188,-2434.7895507812,30.942899703979,1.4753723144531,359.62945556641,349.50573730469},
		[4] = {},
		[5] = {2724.1613769531,-1420.9495849609,16.891799926758,0,0,352},
	},
}

function Weaponshop.openMenu(ID)
	if(apocalypseGetElementData(localPlayer, "tutorialtask") >= 5)then
		if(isWindowOpen())then
			if(not(isElement(Weaponshop.gunObject)))then
				showChat(false)
				setWindowData("no")
				HUD.Visible = false
				NPC.NormalMessage(getText("CWeaponshop4"))
				setElementFrozen(localPlayer, true)
				Weaponshop.selectedGun = 1
				toggleAllControls(false)
				Weaponshop.RenderAlpha = 0
				Weaponshop.RenderState = false
				fadeCamera(false)
				Weaponshop.SelectedShopID = ID
				Weaponshop.Timer["WeaponZoom"] = setTimer(function()
					local tbl = Weaponshop["Weapon:CameraMatrix"][Weaponshop.SelectedShopID]
					fadeCamera(true)
					bindKey("arrow_l", "down", Weaponshop.switchLeft)
					bindKey("arrow_r", "down", Weaponshop.switchRight)
					bindKey("backspace", "down", Weaponshop.close)
					bindKey("enter", "down", Weaponshop.buyGun)
					Weaponshop.createGunObject(Weaponshop.SelectedShopID)
						
					addEventHandler("onClientRender", root, Weaponshop.RenderMenu)
					setCameraMatrix(tbl[1][1],tbl[1][2],tbl[1][3],tbl[1][4],tbl[1][5],tbl[1][6], 0, 70)
					smoothMoveCamera(tbl[1][1],tbl[1][2],tbl[1][3],tbl[1][4],tbl[1][5],tbl[1][6], tbl[2][1],tbl[2][2],tbl[2][3],tbl[2][4],tbl[2][5],tbl[2][6], 5000)
					Weaponshop.Timer["WeaponZoom"] = setTimer(function()
						smoothMoveCamera( tbl[2][1],tbl[2][2],tbl[2][3],tbl[2][4],tbl[2][5],tbl[2][6], tbl[3][1],tbl[3][2],tbl[3][3],tbl[3][4],tbl[3][5],tbl[3][6], 5000)
						Weaponshop.Timer["WeaponZoom"] = setTimer(function()
							Weaponshop.RenderState = true
						end, 5000, 1)
					end, 5000, 1)
				end, 1000, 1)
			end
		end
	end
end
addEvent("Weaponshop.openMenu", true)
addEventHandler("Weaponshop.openMenu", root, Weaponshop.openMenu)

function Weaponshop.createGunObject(ID)
	local ID = tonumber(ID)
	local ObjectID = Weaponshop["Weapons"][Weaponshop.SelectedShopID][Weaponshop.selectedGun]
	local pos = Weaponshop["Weapon:ObjectPos"][ID]
	if(isElement(Weaponshop.gunObject))then
		setElementModel(Weaponshop.gunObject, ObjectID)
	else
		Weaponshop.gunObject = createObject(ObjectID, pos[1], pos[2], pos[3], pos[4], pos[5], pos[6])
	end
end

function Weaponshop.RenderMenu()	
	local screenWidth, screenHeight = guiGetScreenSize()
	local scale = math.min(screenWidth / 1920, screenHeight / 1080)

    if Weaponshop.RenderState == true then
        local gun = Weaponshop["Weapon:Data"][Weaponshop.SelectedShopID][Weaponshop["Weapons"][Weaponshop.SelectedShopID][Weaponshop.selectedGun]]
		if(gun[1] == 22 and tonumber(apocalypseGetElementData(localPlayer,"tutorialtask")) == 5)then
			costs = 0
		else
			costs = gun[2]
		end
        if Weaponshop.RenderAlpha < 255 then 
            Weaponshop.RenderAlpha = math.min(Weaponshop.RenderAlpha + 5, 255) 
        end

        local rectX, rectY, rectWidth, rectHeight = math.floor(1529 * scale), math.floor(94 * scale), math.floor(381 * scale), math.floor(144 * scale)
        dxDrawRectangle(rectX, rectY, rectWidth, rectHeight, tocolor(0, 0, 0, Weaponshop.RenderAlpha), false)

        local text1 = getText("CWeaponshop1"):format(gun[4], gun[3], gun[5], costs)
        dxDrawText(
            text1, 
            rectX + math.floor(10 * scale),
            rectY + math.floor(10 * scale), 
            rectX + rectWidth - math.floor(10 * scale), 
            rectY + math.floor(54 * scale), 
            tocolor(255, 255, 255, Weaponshop.RenderAlpha), 
            1.20 * scale, 
            "default", 
            "left", 
            "center", 
            false, 
            true, 
            false
        )

        local text2 = getText("CWeaponshop2")
        dxDrawText(
            text2, 
            rectX + math.floor(10 * scale), 
            rectY + math.floor(110 * scale), 
            rectX + rectWidth - math.floor(10 * scale), 
            rectY + math.floor(140 * scale), 
            tocolor(255, 255, 255, Weaponshop.RenderAlpha), 
            0.80 * scale, 
            "default", 
            "center", 
            "center", 
            false, 
            true, 
            false
        )

        local playerMoney = apocalypseGetElementData(localPlayer, "money")
        local text3 = getText("CWeaponshop3"):format(playerMoney)
        dxDrawText(
            text3, 
            rectX + math.floor(10 * scale), 
            rectY + math.floor(85 * scale), 
            rectX + rectWidth - math.floor(10 * scale), 
            rectY + math.floor(110 * scale), 
            tocolor(255, 255, 255, Weaponshop.RenderAlpha), 
            1.00 * scale, 
            "default", 
            "center", 
            "center", 
            false, 
            true, 
            false
        )
    end

    local WeaponshopHeight = math.floor(100 * scale)
    dxDrawRectangle(0, 0, screenWidth, WeaponshopHeight, tocolor(0, 0, 0, 255))
    dxDrawRectangle(0, screenHeight - WeaponshopHeight, screenWidth, WeaponshopHeight, tocolor(0, 0, 0, 255))
	setPlayerHudComponentVisible("radar", false)
end

function Weaponshop.switchLeft()
	if(Weaponshop.RenderState == true)then
		if(isElement(Weaponshop.gunObject))then
			if(Weaponshop.selectedGun > 1)then
				Weaponshop.selectedGun = Weaponshop.selectedGun - 1
				Weaponshop.createGunObject()
			end
		end
	end
end

function Weaponshop.switchRight()
	if(Weaponshop.RenderState == true)then
		if(isElement(Weaponshop.gunObject))then
			if(Weaponshop.selectedGun < #Weaponshop["Weapons"][Weaponshop.SelectedShopID])then
				Weaponshop.selectedGun = Weaponshop.selectedGun + 1
				Weaponshop.createGunObject()
			end
		end
	end
end

function Weaponshop.close()
	if(isElement(Weaponshop.gunObject))then destroyElement(Weaponshop.gunObject)end
	setCameraTarget(localPlayer)
	toggleAllControls(true)
	HUD.Visible = true
	showChat(true)
	closeWindow()
		
	unbindKey("arrow_l", "down", Weaponshop.switchLeft)
	unbindKey("arrow_r", "down", Weaponshop.switchRight)
	unbindKey("backspace", "down", Weaponshop.close)
	unbindKey("enter", "down", Weaponshop.buyGun)
		
	removeEventHandler("onClientRender", root, Weaponshop.RenderMenu)
	removeCamHandler()
	Weaponshop.RenderAlpha = 0
	Weaponshop.RenderState = false
	if(isTimer(Weaponshop.Timer["WeaponZoom"]))then killTimer(Weaponshop.Timer["WeaponZoom"]) end
	
	NPC.Close()
	setElementFrozen(localPlayer, false)
	apocalypseSetElementData(localPlayer, "OpenWindow", false)
end
addEvent("Weaponshop.close", true)
addEventHandler("Weaponshop.close", root, Weaponshop.close)

addEventHandler("onClientPlayerWasted", localPlayer, function()
	if(source == localPlayer)then
		Weaponshop.close()
	end
end)

function Weaponshop.buyGun()
	if(Weaponshop.RenderState == true)then
		local gun = Weaponshop["Weapon:Data"][Weaponshop.SelectedShopID][Weaponshop["Weapons"][Weaponshop.SelectedShopID][Weaponshop.selectedGun]]
		if(gun[1] == 22 and tonumber(apocalypseGetElementData(localPlayer,"tutorialtask")) == 5)then
			costs = 0
		else
			costs = gun[2]
		end
		triggerServerEvent("Weaponshop.buyGun", localPlayer, gun[1], gun[4], gun[3], gun[2], gun[5])
	end
end