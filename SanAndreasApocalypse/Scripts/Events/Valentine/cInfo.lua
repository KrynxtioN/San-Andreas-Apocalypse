local valentineData = nil

local function onKeyHit(key, press)
    if key == "enter" and press and valentineData and valentineData.stage == "info" then
        local elapsed = getTickCount() - valentineData.infoAppearTime
        if elapsed >= valentineData.progressBarDuration then
            valentineData.stage = "closing"
            valentineData.closingTimer = 0
            valentineData.closingStartX = valentineData.infoWindowTargetX
        end
    end
end

local function onClientRenderHandler()
    if not valentineData then
        return
    end

    local currentTick = getTickCount()
    local dt = (currentTick - valentineData.lastTick) / 1000
    valentineData.lastTick = currentTick

    if valentineData.stage == "falling" then
        for i = #valentineData.hearts, 1, -1 do
            local heart = valentineData.hearts[i]
            heart.vy = heart.vy + valentineData.gravity * dt
            heart.y = heart.y + heart.vy * dt

            local removeThis = false
            if heart.y + valentineData.heartSize >= valentineData.screenHeight then
                if not heart.hasBounced then
                    heart.y = valentineData.screenHeight - valentineData.heartSize
                    heart.vy = -heart.vy * valentineData.bounceFactor
                    heart.hasBounced = true
                elseif heart.y > valentineData.screenHeight then
                    removeThis = true
                end
            end

            if removeThis then
                table.remove(valentineData.hearts, i)
            else
                dxDrawImage(heart.x, heart.y, valentineData.heartSize, valentineData.heartSize, heart.texture)
            end
        end

        if valentineData.textAnimationTimer < valentineData.textAnimationDuration then
            valentineData.textAnimationTimer = valentineData.textAnimationTimer + dt
        end
        local t = math.min(valentineData.textAnimationTimer / valentineData.textAnimationDuration, 1)
        local currentTextY = valentineData.textInitialY + (valentineData.textTargetY - valentineData.textInitialY) * t
        local currentAlpha = 255 * t
        dxDrawText(valentineData.texts.animatedText[valentineData.currentLanguage],
            valentineData.textTargetX, currentTextY,
            valentineData.textTargetX + valentineData.txtWidth, currentTextY + valentineData.txtHeight,
            tocolor(255, 255, 255, currentAlpha), 2, "default-bold", "center", "center", false, true)

        if #valentineData.hearts == 0 then
            if valentineData.skipInfo then
                valentineData.stage = "closed"
                removeEventHandler("onClientRender", root, onClientRenderHandler)
                unbindKey("enter", "down", onKeyHit)
                valentineData = nil
            else
                valentineData.stage = "transition"
                valentineData.transitionTimer = 0
            end
        end

    elseif valentineData.stage == "transition" then
        valentineData.transitionTimer = valentineData.transitionTimer + dt
        local frac = math.min(valentineData.transitionTimer / valentineData.transitionDuration, 1)
        local currentTextX = valentineData.textTransitionStartX + (valentineData.textTransitionEndX - valentineData.textTransitionStartX) * frac
        local currentTextAlpha = 255 * (1 - frac)
        dxDrawText(valentineData.texts.animatedText[valentineData.currentLanguage],
            currentTextX, valentineData.textTargetY,
            currentTextX + valentineData.txtWidth, valentineData.textTargetY + valentineData.txtHeight,
            tocolor(255, 255, 255, currentTextAlpha), 2, "default-bold", "center", "center", false, true)

        local currentInfoWindowX = valentineData.infoWindowStartX + (valentineData.infoWindowTargetX - valentineData.infoWindowStartX) * frac
        dxDrawRectangle(currentInfoWindowX, valentineData.infoWindowY, valentineData.infoWindowWidth, valentineData.infoWindowHeight, tocolor(0, 0, 0, 200))
        dxDrawImage(currentInfoWindowX + valentineData.margin, valentineData.infoImg1Y, valentineData.infoImgWidth, valentineData.infoImgHeight, valentineData.infoTexture1)
        dxDrawImage(currentInfoWindowX + valentineData.margin, valentineData.infoImg2Y, valentineData.infoImgWidth, valentineData.infoImgHeight, valentineData.infoTexture2)
        dxDrawText(valentineData.texts.infoText[valentineData.currentLanguage],
            currentInfoWindowX + valentineData.infoImgWidth + (valentineData.margin * 2), valentineData.infoTextY,
            currentInfoWindowX + valentineData.infoImgWidth + (valentineData.margin * 2) + valentineData.infoTextWidth, valentineData.infoTextY + valentineData.infoTextHeight,
            tocolor(255, 255, 255, 255), 1.2, "default-bold", "left", "top", true, true, false)

        if frac >= 1 then
            valentineData.stage = "info"
            valentineData.infoAppearTime = getTickCount()
        end

    elseif valentineData.stage == "info" then
        dxDrawRectangle(valentineData.infoWindowTargetX, valentineData.infoWindowY, valentineData.infoWindowWidth, valentineData.infoWindowHeight, tocolor(0, 0, 0, 200))
        dxDrawImage(valentineData.infoImg1X, valentineData.infoImg1Y, valentineData.infoImgWidth, valentineData.infoImgHeight, valentineData.infoTexture1)
        dxDrawImage(valentineData.infoImg2X, valentineData.infoImg2Y, valentineData.infoImgWidth, valentineData.infoImgHeight, valentineData.infoTexture2)
        dxDrawText(valentineData.texts.infoText[valentineData.currentLanguage],
            valentineData.infoTextX, valentineData.infoTextY,
            valentineData.infoTextX + valentineData.infoTextWidth, valentineData.infoTextY + valentineData.infoTextHeight,
            tocolor(255, 255, 255, 255), 1.2, "default-bold", "left", "top", true, true, false)

        local elapsed = getTickCount() - valentineData.infoAppearTime
        local progressFrac = math.min(elapsed / valentineData.progressBarDuration, 1)
        local barMargin = 10
        local barHeight = 30
        local barX = valentineData.infoWindowTargetX + valentineData.margin
        local barY = valentineData.infoWindowY + valentineData.infoWindowHeight - barMargin - barHeight
        local barWidth = valentineData.infoWindowWidth - 2 * valentineData.margin

        dxDrawRectangle(barX, barY, barWidth, barHeight, tocolor(50, 50, 50, 200))
        dxDrawRectangle(barX, barY, barWidth * progressFrac, barHeight, tocolor(100, 255, 100, 255))

        if progressFrac >= 1 then
            local closeTextWidth = dxGetTextWidth(valentineData.texts.closeMessage[valentineData.currentLanguage], 1.2, "default-bold")
            local closeTextHeight = dxGetFontHeight(1.2, "default-bold")
            local closeTextX = valentineData.infoWindowTargetX + (valentineData.infoWindowWidth - closeTextWidth) / 2
            local closeTextY = barY + (barHeight - closeTextHeight) / 2
            dxDrawText(valentineData.texts.closeMessage[valentineData.currentLanguage],
                closeTextX, closeTextY,
                closeTextX + closeTextWidth, closeTextY + closeTextHeight,
                tocolor(0, 0, 0, 255), 1.2, "default-bold", "center", "center", false, true)
        end

    elseif valentineData.stage == "closing" then
        valentineData.closingTimer = valentineData.closingTimer + dt
        local frac = math.min(valentineData.closingTimer / valentineData.closingDuration, 1)
        local currentInfoWindowX = valentineData.closingStartX + (valentineData.closingEndX - valentineData.closingStartX) * frac

        dxDrawRectangle(currentInfoWindowX, valentineData.infoWindowY, valentineData.infoWindowWidth, valentineData.infoWindowHeight, tocolor(0, 0, 0, 200))
        dxDrawImage(currentInfoWindowX + valentineData.margin, valentineData.infoImg1Y, valentineData.infoImgWidth, valentineData.infoImgHeight, valentineData.infoTexture1)
        dxDrawImage(currentInfoWindowX + valentineData.margin, valentineData.infoImg2Y, valentineData.infoImgWidth, valentineData.infoImgHeight, valentineData.infoTexture2)
        dxDrawText(valentineData.texts.infoText[valentineData.currentLanguage],
            currentInfoWindowX + valentineData.infoImgWidth + (valentineData.margin * 2), valentineData.infoTextY,
            currentInfoWindowX + valentineData.infoImgWidth + (valentineData.margin * 2) + valentineData.infoTextWidth, valentineData.infoTextY + valentineData.infoTextHeight,
            tocolor(255, 255, 255, 255), 1.2, "default-bold", "left", "top", true, true, false)

        if frac >= 1 then
            valentineData.stage = "closed"
            removeEventHandler("onClientRender", root, onClientRenderHandler)
            unbindKey("enter", "down", onKeyHit)
            valentineData = nil
        end
    end
end

function openValentineEventInfo()
    if valentineData then return end
    local screenWidth, screenHeight = guiGetScreenSize()
    valentineData = {}
    valentineData.screenWidth = screenWidth
    valentineData.screenHeight = screenHeight
    valentineData.stage = "falling"
    valentineData.lastTick = getTickCount()

    local heartImagePaths = {
        "Scripts/Events/Valentine/Files/Images/Drop1.png", 
        "Scripts/Events/Valentine/Files/Images/Drop2.png", 
        "Scripts/Events/Valentine/Files/Images/Drop3.png", 
        "Scripts/Events/Valentine/Files/Images/Drop4.png",
    }
    local heartTextures = {}
    for i, path in ipairs(heartImagePaths) do
        local texture = dxCreateTexture(path)
        if texture then
            table.insert(heartTextures, texture)
        end
    end
    valentineData.heartTextures = heartTextures
    local numHearts = math.random(30, 40)
    valentineData.heartSize = 64
    valentineData.gravity = 600
    valentineData.bounceFactor = 0.5
    valentineData.hearts = {}
    for i = 1, numHearts do
        local heart = {}
        heart.x = math.random(0, screenWidth - valentineData.heartSize)
        heart.y = math.random(-300, -valentineData.heartSize)
        heart.vy = math.random(200, 400)
        heart.hasBounced = false
        heart.texture = heartTextures[math.random(1, #heartTextures)]
        table.insert(valentineData.hearts, heart)
    end

    valentineData.texts = {
        animatedText = {
            EN = "The Valentine's Event is live!",
            DE = "Das Valentins Event ist aktiv!"
        },
        infoText = {
            EN = "The event runs until February 23 (CET). Until then, you can collect chocolate boxes by killing zombies, looting, or completing event activities. Additionally, you will receive some chocolate boxes with every payday.\n\nChocolate boxes are required to complete event tasks, which reward you with event coins and other items. Event coins can be used to purchase exclusive vehicles, among other things. Visit the event stand to learn more—you can find it in the safe zone of Dillimore Hopes in Zone 11.\n\nKeep an eye out for couples at campfires. Kill them to obtain Valentine's cards. These can be gifted to characters in exchange for chocolate boxes.",
            DE = "Das Event läuft bis zum 23 Februar (CET). Bis dahin kann man Pralinenschachteln sammeln, indem man Zombies tötet, Plünderung Aktivitäten nachgeht oder die Event-Aktivitäten erledigt. Außerdem erhält man zu jedem Zahltag einige Pralinenschachteln.\n\nPralinenschachteln werden benötigt, um die Event Aufgaben erledigen zu können, welche Event-Coins und weitere Dinge als Belohnung bringen. Mit Event-Coins können unter anderem exklusive Fahrzeuge gekauft werden. Besuche den Event-Stand, um mehr zu erfahren. Du findest ihn in der Schutzzone der Dillimore Hopes in Zone 11.\n\nAchte auf die Pärchen an einem Lagerfeuer. Töte sie und erhalte Valentinstagskarten. Valentinstagskarten können an Charaktere verschenkt werden. Dies bringt einige Pralinenschachteln."
        },
        closeMessage = {
            EN = "Press ENTER to close the window.",
            DE = "Drücke ENTER, um das Fenster zu schließen."
        }
    }
    valentineData.currentLanguage = apocalypseGetElementData(localPlayer, "language") or "EN"

    valentineData.txtWidth, valentineData.txtHeight = 400, 50
    valentineData.textAnimationDuration = 1.0
    valentineData.textAnimationTimer = 0
    valentineData.textInitialY = -100
    valentineData.textTargetY = (screenHeight - valentineData.txtHeight) / 2
    valentineData.textTargetX = (screenWidth - valentineData.txtWidth) / 2

    valentineData.transitionDuration = 1.5
    valentineData.transitionTimer = 0
    valentineData.textTransitionStartX = valentineData.textTargetX
    valentineData.textTransitionEndX = -valentineData.txtWidth

    valentineData.infoWindowWidth = 1100
    valentineData.infoWindowHeight = 600
    valentineData.infoWindowTargetX = (screenWidth - valentineData.infoWindowWidth) / 2
    valentineData.infoWindowY = (screenHeight - valentineData.infoWindowHeight) / 2
    valentineData.infoWindowStartX = screenWidth

    valentineData.infoTexture1 = dxCreateTexture("Scripts/Events/Valentine/Files/Images/Image1.png")
    valentineData.infoTexture2 = dxCreateTexture("Scripts/Events/Valentine/Files/Images/Image2.png")
    valentineData.margin = 20

    valentineData.infoImgWidth, valentineData.infoImgHeight = 500, 250
    valentineData.infoImg1X = valentineData.infoWindowTargetX + valentineData.margin
    valentineData.infoImg1Y = valentineData.infoWindowY + valentineData.margin
    valentineData.infoImg2X = valentineData.infoWindowTargetX + valentineData.margin
    valentineData.infoImg2Y = valentineData.infoWindowY + valentineData.margin + valentineData.infoImgHeight + valentineData.margin

    valentineData.infoTextX = valentineData.infoWindowTargetX + valentineData.infoImgWidth + (valentineData.margin * 2)
    valentineData.infoTextY = valentineData.infoWindowY + valentineData.margin
    valentineData.infoTextWidth = valentineData.infoWindowWidth - valentineData.infoImgWidth - (valentineData.margin * 3)
    valentineData.infoTextHeight = valentineData.infoWindowHeight - (valentineData.margin * 2)

    valentineData.infoAppearTime = nil
    valentineData.progressBarDuration = 10000

    valentineData.closingDuration = 1.0
    valentineData.closingTimer = 0
    valentineData.closingStartX = nil
    valentineData.closingEndX = -valentineData.infoWindowWidth

    if fileExists("ValentineInfo.xml") then
        valentineData.skipInfo = true
    else
        valentineData.skipInfo = false
        local file = fileCreate("ValentineInfo.xml")
        fileWrite(file, "off")
        fileClose(file)
    end

    addEventHandler("onClientRender", root, onClientRenderHandler)
    bindKey("enter", "down", onKeyHit)
end
addEvent("openValentineEventInfo", true)
addEventHandler("openValentineEventInfo", root, openValentineEventInfo)