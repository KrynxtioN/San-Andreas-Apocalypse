local achievementsY = 1080
local x, y = guiGetScreenSize()
local achievementQueue = {}
local isDisplaying = false

function Achievements.reached(name, reward, messageType)
   if(name and reward) then
		local image = "Files/Images/Achievement.png"
		if(messageType)then
			image = "Files/Images/"..messageType..".png"
		end
        table.insert(achievementQueue, {name = name, reward = reward, image = image})
        if(not(isDisplaying))then
            Achievements.displayNext()
        end
    end
end
addEvent("Achievements.reached", true)
addEventHandler("Achievements.reached", root, Achievements.reached)

function Achievements.displayNext()
    if(#achievementQueue > 0)then
        local nextAchievement = table.remove(achievementQueue, 1)
        Achievements.rewardEXP = nextAchievement.reward[1]
        Achievements.rewardMoney = nextAchievement.reward[2]
        Achievements.name = nextAchievement.name
		Achievements.image = nextAchievement.image
        
        achievementsY = 1080
        isDisplaying = true

        addEventHandler("onClientRender", root, Achievements.render)
        playSound("Files/Sounds/ReachedAchievement.wav")
        
        if(isTimer(Achievements.timer1)) then killTimer(Achievements.timer1) end
        if(isTimer(Achievements.timer2)) then killTimer(Achievements.timer2) end
        
        Achievements.timer1 = setTimer(function()
            removeEventHandler("onClientRender", root, Achievements.render)
            addEventHandler("onClientRender", root, Achievements.renderout)
            
            Achievements.timer2 = setTimer(function()
                removeEventHandler("onClientRender", root, Achievements.renderout)
                isDisplaying = false
                Achievements.displayNext()
            end,1500,1)
        end,5000,1)
    end
end

function Achievements.render()
    achievementsY = achievementsY - 1
    if(achievementsY <= 1001) then achievementsY = 1001 end
    
    dxDrawRectangle(1670 * (x / 1920), achievementsY * (y / 1080), 250 * (x / 1920), 79 * (y / 1080), tocolor(0, 0, 0, 200), false)
    dxDrawImage(1675 * (x / 1920), (achievementsY + 5) * (y / 1080), 69 * (x / 1920), 69 * (y / 1080), Achievements.image, 0, 0, 0, tocolor(255, 255, 255, 255), true)
    dxDrawText(Achievements.name, 1749 * (x / 1920), (achievementsY + 5) * (y / 1080), 1912 * (x / 1920), ((achievementsY + 5) + 13) * (y / 1080), tocolor(255, 255, 255, 255), 1.00, "default-bold", "center", "center", false, false, true)
    dxDrawText(getText("CAchievements1"):format(Achievements.rewardEXP, Achievements.rewardMoney), 1749 * (x / 1920), ((achievementsY + 5) + 19) * (y / 1080), 1912 * (x / 1920), ((achievementsY + 5) + 68) * (y / 1080), tocolor(255, 255, 255, 255), 1.00, "default-bold", "center", "center", false, false, true)
end

function Achievements.renderout()
    achievementsY = achievementsY + 1
    
    if(achievementsY >= 1080)then
        achievementsY = 1080
        removeEventHandler("onClientRender", root, Achievements.renderout)
    end
    
    dxDrawRectangle(1670 * (x / 1920), achievementsY * (y / 1080), 250 * (x / 1920), 79 * (y / 1080), tocolor(0, 0, 0, 200), false)
    dxDrawImage(1675 * (x / 1920), (achievementsY + 5) * (y / 1080), 69 * (x / 1920), 69 * (y / 1080), Achievements.image, 0, 0, 0, tocolor(255, 255, 255, 255), true)
    dxDrawText(Achievements.name, 1749 * (x / 1920), (achievementsY + 5) * (y / 1080), 1912 * (x / 1920), ((achievementsY + 5) + 13) * (y / 1080), tocolor(255, 255, 255, 255), 1.00, "default-bold", "center", "center", false, false, true)
    dxDrawText(getText("CAchievements1"):format(Achievements.rewardEXP, Achievements.rewardMoney), 1749 * (x / 1920), ((achievementsY + 5) + 19) * (y / 1080), 1912 * (x / 1920), ((achievementsY + 5) + 68) * (y / 1080), tocolor(255, 255, 255, 255), 1.00, "default-bold", "center", "center", false, false, true)
end