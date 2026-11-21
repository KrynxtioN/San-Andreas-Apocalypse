WrenchGame = {
    wrenches      = {},
    imageSize     = 128,
    minSpawn      = 500,
    maxSpawn      = 900,
    nextSpawn     = 0,
    lastSpawn     = 0,
    minSpeed      = 3,
    maxSpeed      = 8,
    score         = 0,
    goal          = 20,
    misses        = 0,
    maxMisses     = 5,
    active        = false,
    texture       = nil,
    screenW       = nil,
    screenH       = nil,
}

function WrenchGame.onRender()
    local G = WrenchGame
    if not G.active then return end

    if getTickCount() >= G.nextSpawn then
        local x = math.random(0, G.screenW - G.imageSize)
        local speed = math.random(G.minSpeed, G.maxSpeed)
        table.insert(G.wrenches, { x = x, y = -G.imageSize, speed = speed })
        G.lastSpawn = getTickCount()
        G.nextSpawn = G.lastSpawn + math.random(G.minSpawn, G.maxSpawn)
    end

    for i = #G.wrenches, 1, -1 do
        local w = G.wrenches[i]
        w.y = w.y + w.speed
        dxDrawImage(w.x, w.y, G.imageSize, G.imageSize, G.texture)
        if w.y > G.screenH then
            table.remove(G.wrenches, i)
            G.misses = G.misses + 1
            if G.misses >= G.maxMisses then
                NPC.MeMessage(getText("CWrenchGame3"))
                G:stop()
                return
            end
        end
    end

    dxDrawText(
		getText("CWrenchGame2"):format(G.score,G.goal,G.misses,G.maxMisses),
        20, 20
    )
end

function WrenchGame.onClick(button, state, cx, cy)
    local G = WrenchGame
    if not G.active or button ~= "left" or state ~= "down" then return end

    for i = #G.wrenches, 1, -1 do
        local w = G.wrenches[i]
        if cx >= w.x and cx <= w.x + G.imageSize
        and cy >= w.y and cy <= w.y + G.imageSize then
            table.remove(G.wrenches, i)
            G.score = G.score + 1
            if G.score >= G.goal then
                triggerServerEvent("VehicleEngineQuest.giveEngine",localPlayer)
                G:stop()
            end
            break
        end
    end
end

function WrenchGame:start()
	if(isWindowOpen())then
		setWindowData("no")
		showCursor(true)
		createActivitiesInformationText(getText("CWrenchGame1"))
		if self.active then return end
		self.active    = true
		self.score     = 0
		self.misses    = 0
		self.wrenches  = {}
		self.screenW, self.screenH = guiGetScreenSize()

		self.texture = dxCreateTexture("Files/Images/Inventory/27.png")
		if not self.texture then
			self.active = false
			return
		end

		self.lastSpawn = getTickCount()
		self.nextSpawn = self.lastSpawn + math.random(self.minSpawn, self.maxSpawn)

		addEventHandler("onClientRender", root, WrenchGame.onRender)
		addEventHandler("onClientClick",  root, WrenchGame.onClick)
	end
end
addEvent("WrenchGame:start",true)
addEventHandler("WrenchGame:start", root, function()
    WrenchGame:start()
end)

function WrenchGame:stop()
	closeWindow()
    if not self.active then return end
    self.active = false
    removeEventHandler("onClientRender", root, WrenchGame.onRender)
    removeEventHandler("onClientClick",  root, WrenchGame.onClick)
    self.wrenches = {}
    if self.texture then destroyElement(self.texture); self.texture = nil end
end

addEventHandler("onClientPlayerWasted",root,function()
	if(source == localPlayer)then
		WrenchGame:stop()
	end
end)