FastTravel = {
	["MatrixCoordinates"] = {
		[1] = {741.93621826172,-496.69891357422,41.820079803467,668.24462890625,-439.96673583984,5.063937664032,0,70},
		[2] = {181.49844360352,-267.59826660156,20.310394287109,247.09867858887,-204.51963806152,-21.13471031189,0,70},
		[3] = {-2202.1416015625,2294.9189453125,24.597291946411,-2233.6665039062,2385.3996582031,-4.0286741256714,0,70},
		[4] = {-1989.0570068359,198.99383544922,53.552532196045,-1958.5112304688,117.68133544922,4.0021929740906,0,70},
		[5] = {-2039.4019775391,-7538.1591796875,34.949424743652,-2074.1538085938,-7628.37109375,9.3733806610107,0,70},
		[6] = {-2051.8005371094,-2440.6025390625,54.465240478516,-2131.2590332031,-2416.2609863281,-1.1571688652039,0,70},
		[7] = {2296.14453125,89.190856933594,57.053936004639,2335.7416992188,10.496942520142,9.7323846817017,0,70},
		[8] = {332.05392456055,-2102.5708007812,33.563831329346,409.13110351562,-2052.416015625,-5.7247610092163,0,70},
		[9] = {1654.64453125,719.05358886719,34.663116455078,1613.3355712891,806.80902099609,10.320596694946,0,70},
		--[9] = {-2405.1240234375,-3065.7248535156,14.492074012756,-2310.9123535156,-3072.2705078125,-18.391002655029,0,70},
	},
	["Level"] = {
		[1] = 25,
		[2] = 25,
		[3] = 35,
		[4] = 50,
		[5] = 100,
		[6] = 20,
		[7] = 30,
		[8] = 50,
		[9] = 60,
		--[9] = 125,
	},
	["Price"] = {
		[1] = 10,
		[2] = 10,
		[3] = 10,
		[4] = 10,
		[5] = 500,
		[6] = 10,
		[7] = 10,
		[8] = 10,
		[9] = 10,
		--[9] = 500,
	},
}

addEvent("FastTravel.createWindow",true)
addEventHandler("FastTravel.createWindow",root,function(ID)
	if(isCharacterLoggedIn() and isWindowOpen())then
		addEventHandler("onClientRender",root,drawBlackBars)
		addEventHandler("onClientRender",root,FastTravel.dxDraw)
		showChat(false)
		setPlayerHudComponentVisible("radar",false)
		HUD.Visible = false
		Levelsystem.Visible = false
		FastTravel.ID = tonumber(ID)
		FastTravel.setCameraMatrix()
		bindKey("arrow_l","down",FastTravel.ArrowLeft)
		bindKey("arrow_r","down",FastTravel.ArrowRight)
		bindKey("enter","down",FastTravel.Enter)
		bindKey("backspace","down",FastTravel.Close)
		setWindowData("no")
	end
end)

function FastTravel.dxDraw()
    local screenWidth, screenHeight = guiGetScreenSize()

    local font = "default" 
    local mainTextSize = 1.5
    local subTextSize = 1
	
	local mainText = getText("CFastTravel1"):format(FastTravel["Price"][FastTravel.ID])
	local subText = getText("CFastTravel2")
    
    local mainTextWidth = dxGetTextWidth(mainText, mainTextSize, font)
    local mainTextHeight = dxGetFontHeight(mainTextSize, font)
    
    local subTextWidth = dxGetTextWidth(subText, subTextSize, font)
    local subTextHeight = dxGetFontHeight(subTextSize, font)
    
    local mainTextX = (screenWidth - mainTextWidth) / 2
    local mainTextY = 10

    local subTextX = (screenWidth - subTextWidth) / 2
    local subTextY = mainTextY + mainTextHeight + 5
    
	if(tonumber(apocalypseGetElementData(localPlayer,"level")) < FastTravel["Level"][FastTravel.ID])then
		mainText = getText("CFastTravel3"):format(FastTravel["Level"][FastTravel.ID])
		dxDrawRectangle(0, 0, screenWidth, screenHeight, tocolor(0, 0, 0, 190))
		renderBlur()
	end
    dxDrawText(mainText, mainTextX, mainTextY, mainTextX + mainTextWidth, mainTextY + mainTextHeight, tocolor(255, 255, 255, 255), 1.5, "default", "center", "top",_,_,true)
    dxDrawText(subText, subTextX, subTextY, subTextX + subTextWidth, subTextY + subTextHeight, tocolor(255, 255, 255, 255), 1, font, "center", "top",_,_,true)
end

function FastTravel.ArrowLeft()
	if(FastTravel.ID > 1)then
		FastTravel.ID = FastTravel.ID - 1
		FastTravel.setCameraMatrix()
	end
end

function FastTravel.ArrowRight()
	if(FastTravel.ID < #FastTravel["MatrixCoordinates"])then
		FastTravel.ID = FastTravel.ID + 1
		FastTravel.setCameraMatrix()
	end
end

function FastTravel.setCameraMatrix()
	local tbl = FastTravel["MatrixCoordinates"][FastTravel.ID]
	setCameraMatrix(tbl[1],tbl[2],tbl[3],tbl[4],tbl[5],tbl[6],tbl[7],tbl[8])
end

function FastTravel.Enter()
	triggerServerEvent("FastTravel.Server",localPlayer,FastTravel.ID,FastTravel["Level"][FastTravel.ID],FastTravel["Price"][FastTravel.ID])
end

function FastTravel.Close()
	unbindKey("arrow_l","down",FastTravel.ArrowLeft)
	unbindKey("arrow_r","down",FastTravel.ArrowRight)
	unbindKey("enter","down",FastTravel.Enter)
	unbindKey("backspace","down",FastTravel.Close)
	setCameraTarget(localPlayer)
	closeWindow()
	removeEventHandler("onClientRender",root,drawBlackBars)
	HUD.Visible = true
	Levelsystem.Visible = true
	removeEventHandler("onClientRender",root,FastTravel.dxDraw)
	triggerServerEvent("FastTravel.Close",localPlayer)
end
addEvent("FastTravel.Close",true)
addEventHandler("FastTravel.Close",root,FastTravel.Close)