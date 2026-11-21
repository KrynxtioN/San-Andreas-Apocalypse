local x,y = guiGetScreenSize()

WoodPlank = {
	["Coordinates"] = {
		{0,    0, 1920, 95},
		{0,   95, 1920, 95},
		{0,  190, 1920, 95},
		{0,  285, 1920, 95},
		{0,  380, 1920, 95},
		{0,  475, 1920, 95},
		{0,  570, 1920, 95},
		{0,  665, 1920, 95},
		{0,  760, 1920, 95},
		{0,  760, 1920, 95},
		{0,  855, 1920, 95},
		{0,  950, 1920, 95},
		{0, 1045, 1920, 35},
	},
}

function WoodPlank.Render()
    if (#WoodPlank.ChoosedCoordinates >= 1) then
        for _, plank in ipairs(WoodPlank.ChoosedCoordinates) do
            local tbl = WoodPlank["Coordinates"][plank.id]
            local plankX = tbl[1] * (x / 1920)
            local plankY = tbl[2] * (y / 1080)
            local plankWidth = tbl[3] * (x / 1920)
            local plankHeight = tbl[4] * (y / 1080)

            local rotation = 0
            if plank.wobbleStart then
                local elapsedTime = getTickCount() - plank.wobbleStart
                if elapsedTime < plank.wobbleDuration then
                    local direction = plank.wobbleDirection
                    rotation = math.sin(elapsedTime / 100) * 5 * direction
                else
                    plank.wobbleStart = nil
                end
            end

            dxDrawImage(plankX, plankY, plankWidth, plankHeight, "Files/Images/Activities/WoodPlank.png", rotation, 0, 0, tocolor(255, 255, 255, 255), false)
        end
    end

    for index, plank in ipairs(WoodPlank.FallingPlanks) do
        plank.ySpeed = plank.ySpeed + 0.5
        plank.y = plank.y + plank.ySpeed
        plank.rotation = plank.rotation + plank.rotationSpeed

        dxDrawImage(plank.x, plank.y, plank.width, plank.height, plank.image, plank.rotation, 0, 0, tocolor(255, 255, 255, 255), false)
    end
end

function WoodPlank.Click(button, state, clickX, clickY)
    if(button == "left" and state == "down")then
        for index, plank in ipairs(WoodPlank.ChoosedCoordinates) do
            local tbl = WoodPlank["Coordinates"][plank.id]
            local plankX = tbl[1] * (x / 1920)
            local plankY = tbl[2] * (y / 1080)
            local plankWidth = tbl[3] * (x / 1920)
            local plankHeight = tbl[4] * (y / 1080)

            if(clickX >= plankX and clickX <= plankX + plankWidth and clickY >= plankY and clickY <= plankY + plankHeight)then
                plank.wobbleStart = getTickCount()
                plank.wobbleDuration = 300
                plank.wobbleDirection = math.random(0, 1) == 0 and -1 or 1

                plank.clickCount = plank.clickCount + 1

                if(plank.clickCount >= plank.maxClicks)then
                    playSound("Files/Sounds/Activities/WoodPlankFalling.mp3")
                    triggerServerEvent("giveEXP", localPlayer, localPlayer, 1)
					triggerServerEvent("giveItem", localPlayer, localPlayer, 34, 1)
					showItemBar({{34,1}})
					triggerServerEvent("sWoodPlanks",localPlayer)

                    table.insert(WoodPlank.FallingPlanks, {
                        x = plankX,
                        y = plankY,
                        width = plankWidth,
                        height = plankHeight,
                        ySpeed = math.random(2, 5),
                        rotation = 0,
                        rotationSpeed = math.random(-3, 3),
                        image = "Files/Images/Activities/WoodPlank.png",
                    })
                    table.remove(WoodPlank.ChoosedCoordinates, index)

                    if (#WoodPlank.ChoosedCoordinates == 0) then
                        triggerServerEvent(WoodPlank.Type, localPlayer, localPlayer)
                        closeWoodPlankGame()
                    end
                end
                break
            end
        end
    end
end

local function ChooseWoodPlankCoordinate()
    if (#WoodPlank.ChoosedCoordinates < WoodPlank.PossiblePlanks) then
        local ID = math.random(1, #WoodPlank["Coordinates"])
        if (#WoodPlank.ChoosedCoordinates < 1) then
            table.insert(WoodPlank.ChoosedCoordinates, {
                id = ID,
                clickCount = 0,
                maxClicks = math.random(3, 6),
                wobbleStart = nil,
                wobbleDuration = 0,
                wobbleDirection = 0,
            })
        else
            for _, plank in pairs(WoodPlank.ChoosedCoordinates) do
                if (plank.id ~= ID) then
                    table.insert(WoodPlank.ChoosedCoordinates, {
                        id = ID,
                        clickCount = 0,
                        maxClicks = math.random(3, 6),
                        wobbleStart = nil,
                        wobbleDuration = 0,
                        wobbleDirection = 0,
                    })
                    break
                end
            end
        end
        ChooseWoodPlankCoordinate()
    else
        addEventHandler("onClientRender", root, WoodPlank.Render)
        addEventHandler("onClientClick", root, WoodPlank.Click)
    end
end

function createWoodPlankGame(Type)
	WoodPlank.Type = Type
	WoodPlank.ActiveGame = true
	WoodPlank.FallingPlanks = {}
	WoodPlank.ChoosedCoordinates = {}
	WoodPlank.PossiblePlanks = math.random(3,6)
	setWindowData("no")
	showCursor(true)
	createActivitiesInformationText(getText("CActivitiesInformation1"))
	
	ChooseWoodPlankCoordinate()
end
addEvent("createWoodPlankGame",true)
addEventHandler("createWoodPlankGame",root,createWoodPlankGame)

function closeWoodPlankGame()
	closeWindow()
	removeEventHandler("onClientRender",root,WoodPlank.Render)
	removeEventHandler("onClientClick",root,WoodPlank.Click)
end
addEvent("closeWoodPlankGame",true)
addEventHandler("closeWoodPlankGame",root,closeWoodPlankGame)

addEventHandler("onClientPlayerWasted",root,function()
	if(source == localPlayer)then
		closeWoodPlankGame()
	end
end)