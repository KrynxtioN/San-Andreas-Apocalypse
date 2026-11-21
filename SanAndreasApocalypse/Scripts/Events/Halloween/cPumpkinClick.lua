local pumpkinImagePath = "Files/Images/Inventory/12.png"
local pumpkins = {}
local screenW, screenH = guiGetScreenSize()

function spawnPumpkin(duration)
    local pumpkin = {}
    pumpkin.w, pumpkin.h = 50, 50
    pumpkin.x = math.random(0, screenW - pumpkin.w)
    pumpkin.y = math.random(0, screenH - pumpkin.h)
    pumpkin.visible = true

    pumpkin.timer = setTimer(function()
        removePumpkin(pumpkin, false)
    end, duration, 1)

    table.insert(pumpkins, pumpkin)
end

function removePumpkin(pumpkin, clicked)
    if isTimer(pumpkin.timer) then killTimer(pumpkin.timer) end
    pumpkin.visible = false

    if clicked then
        triggerServerEvent("giveHalloweenPumpkin",localPlayer,localPlayer,5)
    end

    for i, p in ipairs(pumpkins) do
        if p == pumpkin then
            table.remove(pumpkins, i)
            break
        end
    end
end

if(HalloweenEvent == true)then
	addEventHandler("onClientRender", root,
		function()
			if(isCharacterLoggedIn())then
				for _, p in ipairs(pumpkins) do
					if p.visible then
						dxDrawImage(p.x, p.y, p.w, p.h, pumpkinImagePath)
					end
				end
			end
		end
	)

	addEventHandler("onClientClick", root,
		function(button, state, cx, cy)
			if button == "left" and state == "down" then
				if(isCharacterLoggedIn())then
					for _, p in ipairs(pumpkins) do
						if p.visible and cx >= p.x and cx <= p.x + p.w and cy >= p.y and cy <= p.y + p.h then
							removePumpkin(p, true)
							break
						end
					end
				end
			end
		end
	)

	setTimer(function()
		if math.random(1,2) == 2 then
			spawnPumpkin(5000)
			setTimer(function()
				for i = 1, 12 do
					spawnPumpkin(10000)
				end
			end, 5000, 1)
		end
	end, 600000, 0)
end