Bar = {DrinkObjects = {}, Timer = {},
	["Bar:Drinks"] = {
		{1544,-224.11004638672,1404.1185302734,27.706981658936,0,0,0},
		{1950,-224.09684753418,1403.6517333984,27.895149230957,0,0,187.98596191406},
	},
	["Bar:Camera"] = {
		{-224.88340759277,1404.1212158203,28.250595092773,-130.53735351562,1405.2268066406,-4.87943983078,0,70},
		{-224.87707519531,1403.5786132812,28.250595092773,-130.97236633301,1412.7603759766,-4.87943983078,0,70},
	},
	["Bar:Data"] = {
		["Names"] = {
			["DE"] = {"Limonade", "Bier"},
			["EN"] = {"Lemonade", "Beer"},
			["RU"] = {"Лимонад", "Пиво"},
			["PT"] = {"Limonada", "Cerveja"},
		},
		["Data"] = {
			-- Price, Thirst, Armor, Needed Level
			{20,10,1,0},
			{28,15,2,5},
		},
	},
}

local x,y = guiGetScreenSize()

function Bar.openMenu()
	if(isWindowOpen())then
		showChat(false)
		NPC.NormalMessage(getText("CBar5"))
		Bar.selectedDrink = 1
		HUD.Visible = false
		fadeCamera(false)
		Bar.RenderAlpha = 0
		setElementFrozen(localPlayer,true)
		setWindowData("no")
		showCursor(true)
		Bar.Timer["SwitchState"] = setTimer(function()
			for i,v in pairs(Bar["Bar:Drinks"])do
				Bar.DrinkObjects[i] = createObject(v[1],v[2],v[3],v[4],v[5],v[6],v[7])
				setElementInterior(Bar.DrinkObjects[i],18)
				setElementDimension(Bar.DrinkObjects[i],0)
			end
		
			fadeCamera(true)
			bindKey("arrow_l","down",Bar.switchLeft)
			bindKey("arrow_r","down",Bar.switchRight)
			bindKey("backspace","down",Bar.Close)
			bindKey("enter","down",Bar.buyDrink)
			Bar.SwitchState = false
			Bar.RenderState = false
			toggleAllControls(false)
			
			addEventHandler("onClientRender",root,Bar.RenderMenu)
			setCameraMatrix(-224.90980529785,1404.5545654297,28.250595092773,-129.73155212402,1411.92578125,-1.5280048847198,0,70)
			smoothMoveCamera(-224.90980529785,1404.5545654297,28.250595092773,-129.73155212402,1411.92578125,-1.5280048847198,-224.88340759277,1404.1212158203,28.250595092773,-130.53735351562,1405.2268066406,-4.87943983078,5000)
			
			Bar.Timer["SwitchState"] = setTimer(function()
				Bar.RenderState = true
				Bar.SwitchState = true
			end,5000,1)
		end,1000,1)
	end
end
addEvent("Bar.openMenu",true)
addEventHandler("Bar.openMenu",root,Bar.openMenu)

function Bar.RenderMenu()
	local screenWidth, screenHeight = guiGetScreenSize()
	local scale = math.min(screenWidth / 1920, screenHeight / 1080)
	
	if Bar.RenderState == true then
		local drink = Bar["Bar:Data"]["Data"][Bar.selectedDrink]
		local name = Bar["Bar:Data"]["Names"][apocalypseGetElementData(localPlayer,"language") or "EN"][Bar.selectedDrink]
  
        if Bar.RenderAlpha < 255 then 
            Bar.RenderAlpha = math.min(Bar.RenderAlpha + 5, 255) 
        end

        local rectX, rectY, rectWidth, rectHeight = math.floor(1529 * scale), math.floor(94 * scale), math.floor(381 * scale), math.floor(144 * scale)
        dxDrawRectangle(rectX, rectY, rectWidth, rectHeight, tocolor(0, 0, 0, Bar.RenderAlpha), false)

        local text1 = getText("CBar1"):format(name,drink[4],drink[1],drink[2],drink[3])
        dxDrawText(
            text1, 
            rectX + math.floor(10 * scale),
            rectY + math.floor(10 * scale), 
            rectX + rectWidth - math.floor(10 * scale), 
            rectY + math.floor(54 * scale), 
            tocolor(255, 255, 255, Bar.RenderAlpha), 
            1.20 * scale, 
            "default", 
            "left", 
            "center", 
            false, 
            true, 
            false
        )

        local text2 = getText("CBar2")
        dxDrawText(
            text2, 
            rectX + math.floor(10 * scale), 
            rectY + math.floor(110 * scale), 
            rectX + rectWidth - math.floor(10 * scale), 
            rectY + math.floor(140 * scale), 
            tocolor(255, 255, 255, Bar.RenderAlpha), 
            0.80 * scale, 
            "default", 
            "center", 
            "center", 
            false, 
            true, 
            false
        )

        local playerMoney = apocalypseGetElementData(localPlayer, "money")
        local text3 = getText("CBar3"):format(playerMoney)
        dxDrawText(
            text3, 
            rectX + math.floor(10 * scale), 
            rectY + math.floor(85 * scale), 
            rectX + rectWidth - math.floor(10 * scale), 
            rectY + math.floor(110 * scale), 
            tocolor(255, 255, 255, Bar.RenderAlpha), 
            1.00 * scale, 
            "default", 
            "center", 
            "center", 
            false, 
            true, 
            false
        )
    end

    local BarHeight = math.floor(100 * scale)
    dxDrawRectangle(0, 0, screenWidth, BarHeight, tocolor(0, 0, 0, 255))
    dxDrawRectangle(0, screenHeight - BarHeight, screenWidth, BarHeight, tocolor(0, 0, 0, 255))
	setPlayerHudComponentVisible("radar", false)
end

function Bar.switchLeft()
	if(Bar.selectedDrink > 1 and Bar.SwitchState == true)then
		if(Bar.RenderState == true)then
			Bar.SwitchState = false
			local Data = Bar["Bar:Camera"][Bar.selectedDrink]
			local NewData = Bar["Bar:Camera"][Bar.selectedDrink - 1]
			smoothMoveCamera(Data[1],Data[2],Data[3],Data[4],Data[5],Data[6],NewData[1],NewData[2],NewData[3],NewData[4],NewData[5],NewData[6],2000)
			Bar.selectedDrink = Bar.selectedDrink - 1
			Bar.Timer["SwitchState"] = setTimer(function() Bar.SwitchState = true end,2000,1)
		end
	end
end

function Bar.switchRight()
	if(Bar.selectedDrink < #Bar["Bar:Drinks"] and Bar.SwitchState == true)then
		if(Bar.RenderState == true)then
			Bar.SwitchState = false
			local Data = Bar["Bar:Camera"][Bar.selectedDrink]
			local NewData = Bar["Bar:Camera"][Bar.selectedDrink + 1]
			smoothMoveCamera(Data[1],Data[2],Data[3],Data[4],Data[5],Data[6],NewData[1],NewData[2],NewData[3],NewData[4],NewData[5],NewData[6],2000)
			Bar.selectedDrink = Bar.selectedDrink + 1
			Bar.Timer["SwitchState"] = setTimer(function() Bar.SwitchState = true end,2000,1)
		end
	end
end

function Bar.buyDrink()
	if(Bar.RenderState == true)then
		local drink = Bar["Bar:Data"]["Data"][Bar.selectedDrink]
		triggerServerEvent("Bar.buyDrink",localPlayer,drink[1],drink[2],drink[3],drink[4])
	end
end

function Bar.Close()
	showChat(true)
	setCameraTarget(localPlayer)
	toggleAllControls(true)
	HUD.Visible = true
	closeWindow()
		
	unbindKey("arrow_l","down",Bar.switchLeft)
	unbindKey("arrow_r","down",Bar.switchRight)
	unbindKey("backspace","down",Bar.close)
	unbindKey("enter","down",Bar.buyDrink)
		
	for _,v in ipairs(Bar.DrinkObjects)do
		destroyElement(v)
	end

	removeEventHandler("onClientRender",root,Bar.RenderMenu)
	removeCamHandler()
	Bar.SwitchState = false
	Bar.RenderState = false
	Bar.RenderAlpha = 0
	if(isTimer(Bar.Timer["SwitchState"]))then killTimer(Bar.Timer["SwitchState"]) end
	
	NPC.Close()
	setElementFrozen(localPlayer,false)
	apocalypseSetElementData(localPlayer,"OpenWindow",false)
end
addEvent("Bar.Close",true)
addEventHandler("Bar.Close",root,Bar.Close)

function Bar.BenchInfos()
	dxDrawText(getText("CBar4"), 643*(x/1920), 1032*(y/1080), 1277*(x/1920), 1075*(y/1080), tocolor(255, 255, 255, 255), 1.20*(x/1920), "default", "center", "center", false, false, false, false, false)
end

addEvent("Bar.RenderBenchInfo",true)
addEventHandler("Bar.RenderBenchInfo",root,function()
	addEventHandler("onClientRender",root,Bar.BenchInfos)
end)

addEvent("Bar.UnrenderBenchInfo",true)
addEventHandler("Bar.UnrenderBenchInfo",root,function()
	removeEventHandler("onClientRender",root,Bar.BenchInfos)
end)