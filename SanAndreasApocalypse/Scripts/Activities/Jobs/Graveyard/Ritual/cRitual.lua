Ritual = {}

local screenW, screenH = guiGetScreenSize()

local ritualData = {
    textLines = {
        "In tenebris nos vocamus.",
        "Daemonium antiqui temporis.",
        "Sanguinem donamus in nocte.",
        "Aperi portas inferni.",
        "Fiat voluntas malorum."
    },
    currentLine = 1,
    charIndex = 0,
    displayText = "",
    requiredKey = "",
    waitingForKey = false,
    barHeight = 0,
    barMax = screenH * 0.15,
    animDone = false,
    active = false,
    failed = false,
    success = false,
    lastCharTick = 0,
    charDelay = 50,
    holdingSpace = false,
    status = "Starte Ritual...",
    introShown = false,
    introStarted = false,
}

local spacePressedOnce = false
local inputKeys = {"W", "A", "S", "D"}

function Ritual.start()
    setCameraMatrix(919.9140625,-1101.8732910156,33.974643707275,827.61102294922,-1101.5076904297,-4.4963450431824,0,70)
    smoothMoveCamera(919.9140625,-1101.8732910156,33.974643707275,827.61102294922,-1101.5076904297,-4.4963450431824,904.58966064453,-1101.8125,27.58842086792,812.28662109375,-1101.4468994141,-10.882567405701,30000)

    if isElement(Ritual.ped) then destroyElement(Ritual.ped) end
    Ritual.ped = createPed(0, 895.59008789062, -1101.8315429688, 25.843799591064)

    ritualData.currentLine = 1
    ritualData.charIndex = 0
    ritualData.displayText = ""
    ritualData.barHeight = 0
    ritualData.animDone = false
    ritualData.waitingForKey = false
    ritualData.requiredKey = ""
    ritualData.failed = false
    ritualData.success = false
    ritualData.active = true
    ritualData.lastCharTick = getTickCount()
    ritualData.holdingSpace = false
    ritualData.introShown = true
    ritualData.introStarted = false
    ritualData.status = getText("CRitual2")
    spacePressedOnce = false
	
	bindKey("e","down",Ritual.bindKeyPress)
	bindKey("e","down",Ritual.bindKeyUnpress)

    setWindowData("no")
    HUD.Visible = false
    closeWindow()
    setPlayerHudComponentVisible("radar", false)

    removeEventHandler("onClientRender", root, Ritual.dxDraw)
    addEventHandler("onClientRender", root, Ritual.dxDraw)
end

local function nextLine()
    ritualData.currentLine = ritualData.currentLine + 1
    if ritualData.currentLine > #ritualData.textLines then
        ritualData.success = true
        ritualData.status = getText("CRitual3")
        ritualData.active = false
        Ritual.cleanup()
        Ritual.stop()
        triggerServerEvent("Ritual.finished", localPlayer)
    else
        ritualData.charIndex = 0
        ritualData.displayText = ""
        ritualData.waitingForKey = false
        ritualData.requiredKey = ""
        ritualData.status = getText("CRitual4")
    end
end

function Ritual.stop()
	if ritualData.active then
		ritualData.active = false
		ritualData.failed = true
		removeCamHandler()
		setCameraTarget(localPlayer)
	end
end
addEvent("Ritual.stop", true)
addEventHandler("Ritual.stop", root, Ritual.stop)

addEvent("Ritual.openWindow", true)
addEventHandler("Ritual.openWindow", root, function()
    if isWindowOpen() then
        GUIEditor.window[1] = guiCreateWindow(677, 536, 382, 138, getText("CRitual12"), false)
        guiCreateCloseButton()
        setWindowData()

        GUIEditor.button[1] = guiCreateButton(10, 102, 362, 26, getText("CRitual13"), false, GUIEditor.window[1])
        GUIEditor.label[1] = guiCreateLabel(10, 28, 362, 64, getText("CRitual14"), false, GUIEditor.window[1])
        guiSetFont(GUIEditor.label[1], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[1], "center", true)
        guiLabelSetVerticalAlign(GUIEditor.label[1], "center")

        addEventHandler("onClientGUIClick", GUIEditor.button[1], function()
            triggerServerEvent("Ritual.start", localPlayer)
        end, false)
    end
end)

function Ritual.dxDraw()
    if Ritual.ped and isElement(Ritual.ped) then
        local rx, ry, rz = getElementRotation(Ritual.ped)
        setElementRotation(Ritual.ped, rx, ry, rz + 1)
    end

    HUD.Visible = false
    setPlayerHudComponentVisible("radar", false)
    showChat(false)

    if ritualData.barHeight < ritualData.barMax then
        ritualData.barHeight = math.min(ritualData.barHeight + 10, ritualData.barMax)
    else
        ritualData.animDone = true
    end
    dxDrawRectangle(0, 0, screenW, ritualData.barHeight, tocolor(10, 10, 10, 230))
    dxDrawRectangle(0, screenH - ritualData.barHeight, screenW, ritualData.barHeight, tocolor(10, 10, 10, 230))

    local current = ritualData.textLines[ritualData.currentLine]
    local y = screenH / 2
    if ritualData.active and ritualData.holdingSpace and not ritualData.waitingForKey then
        if getTickCount() - ritualData.lastCharTick > ritualData.charDelay and ritualData.charIndex < #current then
            ritualData.charIndex = ritualData.charIndex + 1
            ritualData.displayText = string.sub(current, 1, ritualData.charIndex)
            ritualData.lastCharTick = getTickCount()
        elseif ritualData.charIndex >= #current and ritualData.requiredKey == "" then
            ritualData.waitingForKey = true
            ritualData.requiredKey = inputKeys[math.random(1, #inputKeys)]
            ritualData.status = getText("CRitual8")
        end
    end

    for i=-2,2 do
        for j=-2,2 do
            dxDrawText(ritualData.displayText, 0+i, y-25+j, screenW+i, y+25+j, tocolor(0,0,0,180), 2, "default-bold", "center", "center")
        end
    end
    dxDrawText(ritualData.displayText, 0, y-25, screenW, y+25, tocolor(255, 255, 255), 2, "default-bold", "center", "center")


    dxDrawText(getText("CRitual5"):format(ritualData.status), 20, 20, 400, 50, tocolor(255, 255, 255), 1.3, "default-bold")

    dxDrawText(getText("CRitual6"):format(ritualData.currentLine, #ritualData.textLines), 20, 50, 400, 80, tocolor(255, 255, 255), 1.2, "default-bold")

    if ritualData.waitingForKey and ritualData.requiredKey then
        local keyText = getText("CRitual17"):format(ritualData.requiredKey)
        for i=-2,2 do
            for j=-2,2 do
                dxDrawText(keyText, screenW/2+i, y+60+j, screenW/2+i, y+100+j, tocolor(0,0,0,180), 2, "default-bold", "center", "top")
            end
        end
        dxDrawText(keyText, screenW/2, y+60, screenW/2, y+100, tocolor(255,200,50), 2, "default-bold", "center", "top")
    end

    if ritualData.introShown and not ritualData.introStarted then
        dxDrawRectangle(screenW*0.2, screenH*0.3, screenW*0.6, screenH*0.4, tocolor(0,0,0,220))
        dxDrawText(getText("CRitual1"), screenW*0.2 + 20, screenH*0.3 + 20, screenW*0.8 - 20, screenH*0.7 - 20, tocolor(255, 255, 255), 1.4, "default-bold", "center", "center", false, true)
    end
end

function Ritual.cleanup()
    if isElement(Ritual.ped) then destroyElement(Ritual.ped) end
    removeEventHandler("onClientRender", root, Ritual.dxDraw)
    removeCamHandler()
    setCameraTarget(localPlayer)
    HUD.Visible = true
    closeWindow()
    showChat(true)
    setPlayerHudComponentVisible("radar",true)
	unbindKey("e","down",Ritual.bindKeyPress)
	unbindKey("e","down",Ritual.bindKeyUnpress)
end

function Ritual.bindKeyPress()
    if ritualData.active then
        if ritualData.introShown and not ritualData.introStarted then
            ritualData.introShown = false
            ritualData.introStarted = true
            ritualData.status = getText("CRitual9")
        end
        ritualData.holdingSpace = true
        spacePressedOnce = true
    end
end

function Ritual.bindKeyUnpress()
    if ritualData.active and ritualData.introStarted and spacePressedOnce then
        ritualData.holdingSpace = false
        ritualData.status = getText("CRitual10")
        ritualData.failed = true
        ritualData.active = false
        Ritual.cleanup()
        NPC.MeMessage(getText("CRitual16"))
    end
end

addEventHandler("onClientKey", root, function(key, press)
    if not press or not ritualData.active or not ritualData.waitingForKey then return end
    if key:upper() == ritualData.requiredKey then
        ritualData.waitingForKey = false
        ritualData.requiredKey = nil
        ritualData.status = getText("CRitual15")
        setTimer(nextLine, 500, 1)
    elseif key:lower() == "w" or key:lower() == "a" or key:lower() == "s" or key:lower() == "d" then
        ritualData.status = getText("CRitual11")
        ritualData.failed = true
        ritualData.active = false
        Ritual.cleanup()
        Ritual.stop()
        NPC.MeMessage(getText("CRitual16"))
    end
end)