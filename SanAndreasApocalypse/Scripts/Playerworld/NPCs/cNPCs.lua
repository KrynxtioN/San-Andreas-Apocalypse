NPC = {
	Peds = {}, 
	PedsData = {}, 
	Colsphere = {}, 
	AlreadyRendered = false, 
	ActiveMessage = nil, 
	SpaceText = nil, 
	RenderMessageStatus = false,
}

local NPCTemporaryImage = nil
local NPCTemporaryName = nil

NPC.RenderMessageActive = false
NPC.RenderMeMessageActive = false

local font = dxCreateFont("Files/Fonts/Wiltype.ttf",  20,  false,  "proof") or "default"
local x, y = guiGetScreenSize()

local idleAnimations = {
	{"playidles", "shift"},
	{"playidles", "shldr"},
	{"playidles", "stretch"},
	{"playidles", "strleg"},
	{"playidles", "time"},
}

local showHelpQuestion = false

local function setIdleAnimation(ped)
	setTimer(function(ped)
		local animation = math.random(1,#idleAnimations)
		if(isElement(ped))then
			setPedAnimation(ped,idleAnimations[animation][1],idleAnimations[animation][2],-1, true, false, false, false)
		end
	end,math.random(50,250),1,ped)
end

addCommandHandler("gotonpc", function(commandName, amount)
    amount = tonumber(amount)
    if NPC.Peds[amount] then
        local x, y, z = getElementPosition(NPC.Peds[amount])
        setElementPosition(localPlayer, x, y, z)
        setElementInterior(localPlayer, getElementInterior(NPC.Peds[amount]))
        setElementDimension(localPlayer, getElementDimension(NPC.Peds[amount]))
    else
        outputChatBox("Dieser NPC existiert nicht.")
    end
end)

function createNPC(ID,  x,  y,  z,  Rotation,  Model,  Name,  Interior,  Dimension,  Colspheresize)
	if(ID and x and y and z and Rotation and Model and Name and Interior and Dimension)then
		if(not(Colspheresize))then Colspheresize = 2.5 end
		if(not(isElement(NPC.Peds[ID])))then
			NPC.Peds[ID] = createPed(Model, x, y, z, Rotation)
			
			if(isElement(NPC.Peds[ID]))then
				NPC.PedsData[ID] = {
					["ID"] = ID, 
					["Name"] = Name, 
					["Model"] = Model, 
				}
			
				setElementInterior(NPC.Peds[ID], Interior)
				setElementDimension(NPC.Peds[ID], Dimension)
			
				setElementFrozen(NPC.Peds[ID], true)
				apocalypseSetElementData(NPC.Peds[ID], "NPC.ID", ID)
				setIdleAnimation(NPC.Peds[ID])
				apocalypseSetElementData(NPC.Peds[ID],"Rotation",Rotation)
				
				NPC.Colsphere[ID] = createColSphere(x,  y,  z,  Colspheresize)
				setElementInterior(NPC.Colsphere[ID], Interior)
				setElementDimension(NPC.Colsphere[ID], Dimension)
				
				addEventHandler("onClientColShapeHit", NPC.Colsphere[ID], function(player)
					if(player == localPlayer and isCharacterLoggedIn())then
						if(getElementDimension(localPlayer) == getElementDimension(source))then
							if(getElementInterior(localPlayer) == getElementInterior(source))then
								apocalypseSetElementData(localPlayer, "NPC.InteractionID", ID)
								triggerServerEvent("updateTalkData", localPlayer, apocalypseGetElementData(localPlayer, "NPC.InteractionID"))
								triggerServerEvent("NPC.requestTradePreview", localPlayer, ID)

								bindKey("space", "down", NPC.ConversationStart)
								bindKey("e", "down", NPC.Interact)

								apocalypseSetElementData(localPlayer, "ActiveNPCConversation", false)
							end
						end
					end
				end)
				
				addEventHandler("onClientColShapeLeave", NPC.Colsphere[ID], function(player)
					if(player == localPlayer)then
						closeTradePreviewRender()
						NPC.CloseTradeWindow()
						NPC.Close()
					end
				end)
			end
			return NPC.Peds[ID]
		end
	end
end
addEvent("createNPC", true)
addEventHandler("createNPC", root, createNPC)

function NPC.Interact()
	local ID = tonumber(apocalypseGetElementData(localPlayer, "NPC.InteractionID"))
	if(apocalypseGetElementData(localPlayer,"ActiveNPCConversation") == false)then
		if(isElementWithinColShape(localPlayer,NPC.Colsphere[ID]))then
			if(ID == 1)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					Bar.openMenu()
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 2)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= 5)then
					Weaponshop.openMenu(1)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 3)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					openSpinningWheel()
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 6)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					Itemshop.openMenu()
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 7)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					Armor.openMenu()
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 9)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					triggerServerEvent("Outfits.loadQuestWindow",localPlayer,1)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 10)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					triggerServerEvent("Outfits.loadQuestWindow",localPlayer,26)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 11)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					triggerServerEvent("Weaponbox.open",localPlayer)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 12)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					triggerServerEvent("Outfits.loadQuestWindow",localPlayer,31)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 13)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					triggerServerEvent("addFreespin", localPlayer)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 14)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					KeysShop.openWindow(1)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 15)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					Vehicleshop.openWindow(1)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 16)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					openCouponShop()
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 17)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					Toplist.openWindow()
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 18)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					--ItemForItem.createWindow(1,5,31,1)
					triggerServerEvent("DrBrain.Server",localPlayer)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 19)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					HalloweenRewards.openWindow()
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 20)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					triggerServerEvent("Outfits.loadQuestWindow",localPlayer,3)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 21)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					triggerServerEvent("Outfits.loadQuestWindow",localPlayer,4)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 22)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					triggerServerEvent("Outfits.loadQuestWindow",localPlayer,2)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 23)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					Shakes.createWindow(2)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 24)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					SurvivorPass.openWindow()
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 25)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					Colonys.createWindow()
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 26)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					triggerServerEvent("Outfits.loadQuestWindow",localPlayer,7)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 27)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					triggerServerEvent("Outfits.loadQuestWindow",localPlayer,30)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 28)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					triggerServerEvent("Outfits.loadQuestWindow",localPlayer,28)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 29)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					ItemForItem.createWindow(1,25,26,1)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 30)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					triggerServerEvent("Outfits.loadQuestWindow",localPlayer,5)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 31)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					HotDog.createWindow()
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 32)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					Vehicleshop.openWindow(2)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 33)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					Vehicleshop.openSpecialWindow(473)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 34)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					SafeShop.createWindow()
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 35)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					triggerServerEvent("Outfits.loadQuestWindow",localPlayer,6)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 36)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					Weaponshop.openMenu(2)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 37)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					Skillsystem.createWindow(1)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 38)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					Vehicleshop.openWindow(3)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 39)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					togglePotionShop()
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 40)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					triggerServerEvent("serverOpenTradingCardAlbum",localPlayer)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 41)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					SpecialEngine.createGarage(1)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 42)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					Skillsystem.createWindow(3)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 43)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					Vehicleshop.openSpecialWindow(512)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 44)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					Vehicleshop.openSpecialWindow(460)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 45)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					Vehicleshop.openSpecialWindow(513)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 46)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					Vehicleshop.openSpecialWindow(511)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 47)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					Vehicleshop.openSpecialWindow(593)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 48)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					Vehicleshop.openSpecialWindow(487)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 49)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					Vehicleshop.openSpecialWindow(447)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 50)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					Vehicleshop.openSpecialWindow(469)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 51)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					triggerServerEvent("Outfits.loadQuestWindow",localPlayer,9)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 52)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					triggerServerEvent("Outfits.loadQuestWindow",localPlayer,8)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 53)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					triggerServerEvent("Outfits.loadQuestWindow",localPlayer,10)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 54)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					triggerServerEvent("Outfits.loadQuestWindow",localPlayer,11)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 55)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					triggerServerEvent("Outfits.loadQuestWindow",localPlayer,12)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 56)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					triggerServerEvent("Outfits.loadQuestWindow",localPlayer,13)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 57)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					triggerServerEvent("Outfits.loadQuestWindow",localPlayer,14)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 58)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					Skillsystem.createWindow(3)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 59)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					Vehicleshop.openWindow(4)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			
			if(ID == 63)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					openSpinningWheel()
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 64)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					openSpinningWheel()
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 65)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					openSpinningWheel()
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 66)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					triggerServerEvent("PrisonQuest.checkQuest",localPlayer)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 67)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					triggerServerEvent("Outfits.loadQuestWindow",localPlayer,15)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 68)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					triggerServerEvent("Outfits.loadQuestWindow",localPlayer,16)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 69)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					triggerServerEvent("Outfits.loadQuestWindow",localPlayer,17)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 70)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					ValentinesDay.OpenMenu()
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 71)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					triggerServerEvent("Outfits.loadQuestWindow",localPlayer,19)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 72)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					Weaponshop.openMenu(5)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 73)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					triggerServerEvent("Outfits.loadQuestWindow",localPlayer,29)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 74)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					MiningShop.openWindow()
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 75)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					triggerServerEvent("claimSafeKey",localPlayer)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 76)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					FishersShop.openWindow(1)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 77)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					FishersShop.openWindow(2)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 78)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					SeedsShop.openWindow(1)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 79)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					Skillsystem.createWindow(4)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 80)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					FishersShop.openWindow(3)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 81)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					triggerServerEvent("Outfits.loadQuestWindow",localPlayer,18)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 82)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					triggerServerEvent("Outfits.loadQuestWindow",localPlayer,20)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 83)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					Party.createWindow()
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 84)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					BonuspointsShop.createWindow()
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 85)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					openWeaponskillsWindow()
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 86)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					Weaponshop.openMenu(3)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 87)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					openSpinningWheel()
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 88)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					triggerServerEvent("Outfits.loadQuestWindow",localPlayer,24)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 89)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					triggerServerEvent("Outfits.loadQuestWindow",localPlayer,21)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			
			if(ID == 90)then -- // Weapon Transport
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					triggerServerEvent("WeaponTransport.loadGUI",localPlayer)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			
			if(ID == 91)then -- // Vehicle Dismantling
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					triggerServerEvent("Outfits.loadQuestWindow",localPlayer,27)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			
			if(ID == 92)then -- // Zone 2: Bigfoot Club
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					triggerServerEvent("BigfootClub.giveSpawnpoint",localPlayer)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			
			if(ID == 93)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					triggerServerEvent("Outfits.loadQuestWindow",localPlayer,22)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			
			if(ID == 94)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					Warehouse.createWindow()
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 95)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					triggerServerEvent("Outfits.loadQuestWindow",localPlayer,23)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 96)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					OilTask.openWindow()
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 97)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					Graveyardshop.openWindow()
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 98)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					Shakes.createWindow(1)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 99)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					FishersShop.openWindow(3)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 100)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					SellFish.createWindow()
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 101)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					triggerServerEvent("Outfits.loadQuestWindow",localPlayer,25)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 102)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					Moebel.showObject()
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 103)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					HalloweenChestsUI.toggleOpen()
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 104)then
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					HalloweenShop.createWindow()
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 105)then -- Spinosuaurus Club (trade bones for clubhouse key)
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					triggerServerEvent("SpinosaurusClub.checkQuest1",localPlayer)
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			if(ID == 106)then -- Spinosuaurus Club (trade bones)
				if(apocalypseGetElementData(localPlayer, "tutorialtask") >= #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then
					SpinosaurusClub.MoneyPickup()
					apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				end
			end
			
			-- // Impala Event
			if(ID == 107)then
				if(apocalypseGetElementData(localPlayer,"tutorialtask") < #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then return end
				Chevrolet_Impala_Event.openWindow_1()
				apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
			end
			if(ID == 108)then
				if(apocalypseGetElementData(localPlayer,"tutorialtask") < #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then return end
				Chevrolet_Impala_Event.openWindow_2()
				apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
			end
			if(ID == 109)then
				if(apocalypseGetElementData(localPlayer,"tutorialtask") < #Tutorial["Tasks"][apocalypseGetElementData(localPlayer, "language") or "EN"] + 1)then return end
				Chevrolet_Impala_Event.openWindow_3()
				apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
			end
		end
	end
end

function NPC.ConversationStart()
	local ID = tonumber(apocalypseGetElementData(localPlayer, "NPC.InteractionID"))
	if(apocalypseGetElementData(localPlayer,"ActiveNPCConversation") == false and isWindowOpen())then
		if(isElement(NPC.Colsphere[ID]))then
			if(isElementWithinColShape(localPlayer,NPC.Colsphere[ID]))then
				apocalypseSetElementData(localPlayer,"NPCTalking",true)
				apocalypseSetElementData(localPlayer,"ActiveNPCConversation",true)
				bindKey("p","down",CharacterGivePresentWindow)
				setPedAnimation(NPC.Peds[ID], "PED","IDLE_CHAT")
				triggerServerEvent("NPC.ToGetToKnow", localPlayer, ID, NPC.PedsData[ID]["Name"])
			end
		end
	end
end

addEventHandler("onClientRender", root, function()
	if(isCharacterLoggedIn() and isWindowOpen() and not(isPedDead(localPlayer)))then
		for _, v in pairs(NPC.Peds)do
			if(isElement(v))then
				if(getElementDimension(localPlayer) == getElementDimension(v) and getElementInterior(localPlayer) == getElementInterior(v) and not(isPlayerMapVisible()))then
					local px, py, pz = getPedBonePosition(v, 8)
					local lx, ly, lz = getPedBonePosition(localPlayer, 8)
					
					if(getDistanceBetweenPoints3D(px, py, pz, lx, ly, lz) <= 10 and isLineOfSightClear(px, py, pz, lx, ly, lz, true, false, false, true, false))then
						if(not(isPedDead(v)))then
							if(apocalypseGetElementData(localPlayer, "TutorialEndCamera") ~= true)then
								local NPCID = apocalypseGetElementData(v, "NPC.ID")
								local Data = NPC.PedsData[NPCID]
								local worldx, worldy = getScreenFromWorldPosition(px, py, pz+0.5, 1000, true)
								
								if(getDistanceBetweenPoints3D(px, py, pz, lx, ly, lz) > 1)then
									scale = 0.6 - (getDistanceBetweenPoints3D(px, py, pz, lx, ly, lz)/70)
								else
									scale = 0.6
								end
								
								if(worldx and worldy and scale)then
									dxDrawText(Data["Name"], worldx, worldy-20, worldx, worldy, tocolor(0, 0, 0), scale, "bankgothic", "center", "center")
									dxDrawText(Data["Name"], worldx-2, (worldy-2) -20, worldx, worldy, tocolor(0, 255, 0), scale, "bankgothic", "center", "center")
									if(apocalypseGetElementData(localPlayer,"tutorialtask") < 5 or apocalypseGetElementData(localPlayer,"tutorialtask") >= 6 and apocalypseGetElementData(localPlayer,"tutorialtask") <= 7 or Data["Model"] == 287 or Data["Model"] == 171 or Data["Model"] == 163)then
										dxDrawText(getText("CNPC3"), worldx, worldy+25, worldx, worldy, tocolor(0, 0, 0), scale - 0.1, "bankgothic", "center", "center")
										dxDrawText(getText("CNPC3"), worldx-4, worldy+27, worldx, worldy, tocolor(0, 255, 0), scale - 0.1, "bankgothic", "center", "center")
									else
										if(apocalypseGetElementData(localPlayer,"ActiveNPCConversation") == false)then
											dxDrawText(getText("CNPC1"), worldx, worldy+25, worldx, worldy, tocolor(0, 0, 0), scale - 0.1, "bankgothic", "center", "center")
											dxDrawText(getText("CNPC1"), worldx-4, worldy+27, worldx, worldy, tocolor(0, 255, 0), scale - 0.1, "bankgothic", "center", "center")
										else
											if(apocalypseGetElementData(localPlayer,"NPCTalking") == true)then
												dxDrawText(getText("CNPC4"), worldx, worldy+25, worldx, worldy, tocolor(0, 0, 0), scale - 0.1, "bankgothic", "center", "center")
												dxDrawText(getText("CNPC4"), worldx-4, worldy+27, worldx, worldy, tocolor(0, 255, 0), scale - 0.1, "bankgothic", "center", "center")
											else
												dxDrawText(getText("CNPC1"), worldx, worldy+25, worldx, worldy, tocolor(0, 0, 0), scale - 0.1, "bankgothic", "center", "center")
												dxDrawText(getText("CNPC1"), worldx-4, worldy+27, worldx, worldy, tocolor(0, 255, 0), scale - 0.1, "bankgothic", "center", "center")
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
end)

function NPC.RenderMessage()
	local RecognizedID = tonumber(apocalypseGetElementData(localPlayer, "NPC.InteractionID"))
	if(NPCTemporaryImage ~= nil)then
		dxDrawImage(-20 * (x / 1920), 834 * (y / 1080), 163 * (x / 1920), 289 * (y / 1080), "Files/Images/Characters/" .. NPCTemporaryImage .. ".png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
	else
		dxDrawImage(-20 * (x / 1920), 834 * (y / 1080), 163 * (x / 1920), 289 * (y / 1080), "Files/Images/Characters/" .. NPC.PedsData[RecognizedID]["Model"] .. ".png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
	end
	
	local questionX, questionY, questionWidth, questionHeight = 86 * (x / 1920), 760 * (y / 1080), 343 * (x / 1920), 60 * (y / 1080)
	if(showHelpQuestion == true)then
		if(tonumber(apocalypseGetElementData(localPlayer,"level")) >= 5)then
			dxDrawRectangle(questionX, questionY, questionWidth, questionHeight, tocolor(0, 0, 0, 200), false)
			dxDrawText(getText("CNPC11"), questionX + 10, questionY + 15, questionX + questionWidth, questionY + questionHeight, tocolor(255, 255, 255, 255), 1 * (x / 1920), font, "left", "top", false, false, true, false, false)
		end
	end

	dxDrawRectangle(86 * (x / 1920), 860 * (y / 1080), 343 * (x / 1920), 141 * (y / 1080), tocolor(0, 0, 0, 175), false)
	if(NPCTemporaryName ~= nil)then
		dxDrawText(NPCTemporaryName, 96 * (x / 1920), 834 * (y / 1080), 405 * (x / 1920), 879 * (y / 1080), tocolor(255, 255, 255, 255), 1 * (x / 1920), font, "left", "top", false, false, true, false, false)
	else
		dxDrawText(NPC.PedsData[RecognizedID]["Name"], 96 * (x / 1920), 834 * (y / 1080), 405 * (x / 1920), 879 * (y / 1080), tocolor(255, 255, 255, 255), 1 * (x / 1920), font, "left", "top", false, false, true, false, false)
	end
	dxDrawText(NPC.ActiveMessage, 96 * (x / 1920), 869 * (y / 1080), 419 * (x / 1920), 974 * (y / 1080), tocolor(255, 255, 255, 255), 0.80 * (x / 1920), font, "left", "top", false, true, true, false, false)
	dxDrawText(NPC.SpaceText, 86 * (x / 1920), 984 * (y / 1080), 429 * (x / 1920), 1001 * (y / 1080), tocolor(255, 255, 255, 255), 1.00 * (x / 1920), "default", "center", "top", false, true, true, false, false)

	if(isMouseInPosition(questionX, questionY, questionWidth, questionHeight))then
		dxDrawRectangle(questionX, questionY, questionWidth, questionHeight, tocolor(50, 50, 50, 200), false)
	end
end

function NPC.getSomeHelp(button, state, absoluteX, absoluteY)
    if(button == "left" and state == "down")then
		if(showHelpQuestion == true)then
			if(isMouseInPosition(86 * (x / 1920), 760 * (y / 1080), 343 * (x / 1920), 60 * (y / 1080)))then
				triggerServerEvent("NPC.getSomeHelp",localPlayer)
			end
		end
	end
end

local startTick = nil
local animationDuration = 300
local isSlidingIn = false
local currentYOffset = 1080
local targetYOffset = 834
local currentOpacity = 255
local targetOpacity = 255
local isFadingOut = false

local function getMessageDuration(text)
	return 1000 + ((#tostring(text or "")) * 100)
end

local function resetMessageAnimation()
	startTick = nil
	isSlidingIn = false
	currentYOffset = 1080
	currentOpacity = 255
	targetOpacity = 255
	isFadingOut = false
end

local function clearActiveMessageUI()
	if(isTimer(NPC.TalkingTimer))then killTimer(NPC.TalkingTimer) end
	if(isTimer(NPC.TalkingTimer2))then killTimer(NPC.TalkingTimer2) end

	unbindKey("space", "down", NPC.Close)

	removeEventHandler("onClientRender", root, NPC.RenderMessage)
	removeEventHandler("onClientRender", root, NPC.RenderMeMessage)
	removeEventHandler("onClientClick", root, NPC.getSomeHelp)

	NPC.RenderMessageActive = false
	NPC.RenderMeMessageActive = false
	NPC.ActiveMessage = ""
	NPC.SpaceText = ""
	showHelpQuestion = false

	resetMessageAnimation()
end

function NPC.ToggleRenderMessage()
    startTick = getTickCount()
    isSlidingIn = not isSlidingIn
    isFadingOut = false
    if not isSlidingIn then
        isFadingOut = true
    end
end

function NPC.RenderMeMessage()
    if startTick then
        local now = getTickCount()
        local progress = math.min(1, (now - startTick) / animationDuration)

        if isSlidingIn then
            currentYOffset = interpolateBetween(1080, 0, 0, targetYOffset, 0, 0, progress, "InOutQuad")
        else
            currentYOffset = interpolateBetween(targetYOffset, 0, 0, 1080, 0, 0, progress, "InOutQuad")
        end

        if isFadingOut then
            currentOpacity = interpolateBetween(255, 0, 0, 0, 0, 0, progress, "InOutQuad")
        else
            currentOpacity = 255
        end

        if progress == 1 then
            startTick = nil
            if not isSlidingIn then
                isFadingOut = false
            end
        end
    end

    dxDrawImage(-20 * (x / 1920), currentYOffset * (y / 1080), 163 * (x / 1920), 289 * (y / 1080), "Files/Images/Characters/0.png", 0, 0, 0, tocolor(255, 255, 255, currentOpacity), true)
    dxDrawRectangle(86 * (x / 1920), (currentYOffset + 26) * (y / 1080), 343 * (x / 1920), 141 * (y / 1080), tocolor(0, 0, 0, 175 * (currentOpacity / 255)), false)
    dxDrawText(getCharacterName(), 96 * (x / 1920), currentYOffset * (y / 1080), 405 * (x / 1920), (currentYOffset + 45) * (y / 1080), tocolor(255, 255, 255, currentOpacity), 1 * (x / 1920), font, "left", "top", false, false, true, false, false)
    dxDrawText(NPC.ActiveMessage, 96 * (x / 1920), (currentYOffset + 35) * (y / 1080), 419 * (x / 1920), (currentYOffset + 140) * (y / 1080), tocolor(255, 255, 255, currentOpacity), 0.80 * (x / 1920), font, "left", "top", false, true, true, false, false)
end

function NPC.NormalMessage(Text,status,imageModelID,name)
    if imageModelID then NPCTemporaryImage = imageModelID else NPCTemporaryImage = nil end
    if name then NPCTemporaryName = name else NPCTemporaryName = nil end

	clearActiveMessageUI()

    addEventHandler("onClientRender", root, NPC.RenderMessage)
    addEventHandler("onClientClick", root, NPC.getSomeHelp)
    setPlayerHudComponentVisible("radar", false)
    NPC.RenderMessageActive = true
    showHelpQuestion = true

    NPC.ActiveMessage = ""
    NPC.SpaceText = ""
    local ID = 0

    NPC.TalkingTimer = setTimer(function()
        ID = ID + 1
        if ID <= #Text then
            NPC.ActiveMessage = NPC.ActiveMessage .. string.sub(Text, ID, ID)
        else
            NPC.SpaceText = getText("CNPC2")
            if isTimer(NPC.TalkingTimer) then killTimer(NPC.TalkingTimer) end
            bindKey("space", "down", NPC.Close)
        end
    end, 50, 0)
end
addEvent("NPC.NormalMessage", true)
addEventHandler("NPC.NormalMessage", root, NPC.NormalMessage)

function NPC.MeMessage(Text)
	clearActiveMessageUI()

    addEventHandler("onClientRender", root, NPC.RenderMeMessage)
    NPC.RenderMeMessageActive = true
	resetMessageAnimation()
    NPC.ToggleRenderMessage()
    setPlayerHudComponentVisible("radar", false)

    NPC.ActiveMessage = ""
    NPC.SpaceText = ""
    local ID = 0
	local closeTime = getMessageDuration(Text)

    NPC.TalkingTimer = setTimer(function()
        ID = ID + 1
        if ID <= #Text then
            NPC.ActiveMessage = NPC.ActiveMessage .. string.sub(Text, ID, ID)
        else
            if isTimer(NPC.TalkingTimer) then killTimer(NPC.TalkingTimer) end
        end
    end, 50, 0)

    NPC.TalkingTimer2 = setTimer(function()
		if NPC.RenderMeMessageActive then
			NPC.ToggleRenderMessage()
			setTimer(function()
				NPC.Close()
			end, animationDuration, 1)
		end
    end, closeTime, 1)
end
addEvent("NPC.MeMessage", true)
addEventHandler("NPC.MeMessage", root, NPC.MeMessage)

function NPC.Close()
	local ID = tonumber(apocalypseGetElementData(localPlayer, "NPC.InteractionID"))
	if(ID and NPC.Peds[ID] and isElement(NPC.Peds[ID]))then
		setIdleAnimation(NPC.Peds[ID])
	end

	unbindKey("space", "down", NPC.Close)
	bindKey("space","down",NPC.ConversationStart)

	clearActiveMessageUI()

    NPC.AlreadyRendered = false
	triggerServerEvent("checkCompass",localPlayer)
	apocalypseSetElementData(localPlayer,"ActiveNPCConversation",false)
	unbindKey("p","down",CharacterGivePresentWindow)
	apocalypseSetElementData(localPlayer,"NPCTalking",false)
end
addEvent("NPC.Close", true)
addEventHandler("NPC.Close", root, NPC.Close)

local pedDamageTimer = {}
local pedDamageTimer2 = {}
local pedDamageDialogues = {
	["EN"] = {
		[1] = "What is that?!",
		[2] = "Stop it, you idiot!",
		[3] = "Are you crazy?!",
		[4] = "You will regret this!",
		[5] = "I'll get you!",
		[6] = "Get lost before I get angry!",
		[7] = "Don't think you can get away with this!",
		[8] = "You're dead if I catch you!",
		[9] = "What were you thinking?!",
		[10] = "You'll pay for this!",
		[11] = "You've made a big mistake!",
		[12] = "I won't let this go unpunished!",
		[13] = "Don't think I'm scared!",
		[14] = "You're not the only one who can hit back!",
		[15] = "I'll shoot back if you don't stop!",
		[16] = "What, you think you're a hero?",
		[17] = "I'll tear you to pieces!",
		[18] = "You're really the worst!",
		[19] = "I've had enough of you!",
		[20] = "Look at that, you coward!",
		[21] = "I'll get you!",
		[22] = "I'll defend myself if I have to!",
		[23] = "What were you even thinking?!",
		[24] = "Stop it before it's too late!",
		[25] = "You're no opponent, you're a joke!",
	},
	["DE"] = {
		[1] = "Was soll das?!",
		[2] = "Hör auf, du Idiot!",
		[3] = "Bist du verrückt?!",
		[4] = "Du wirst es bereuen!",
		[5] = "Ich kriege dich!",
		[6] = "Hau ab, bevor ich wütend werde!",
		[7] = "Denk nicht, dass du damit durchkommst!",
		[8] = "Du bist tot, wenn ich dich erwische!",
		[9] = "Was hast du dir dabei gedacht?!",
		[10] = "Ich werde dir das bezahlen!",
		[11] = "Du hast einen großen Fehler gemacht!",
		[12] = "Ich lass das nicht einfach so stehen!",
		[13] = "Glaub nicht, dass ich Angst habe!",
		[14] = "Du bist nicht der Einzige, der zuschlagen kann!",
		[15] = "Ich schieße zurück, wenn du nicht aufhörst!",
		[16] = "Was, du denkst, du bist ein Held?",
		[17] = "Ich werde dich in Stücke reißen!",
		[18] = "Du bist echt der Letzte!",
		[19] = "Ich hab' genug von dir!",
		[20] = "Schau dir das an, du Feigling!",
		[21] = "Dich krieg ich!",
		[22] = "Ich schütze mich, wenn es sein muss!",
		[23] = "Was hast du dir nur dabei gedacht?!",
		[24] = "Lass das, bevor es zu spät ist!",
		[25] = "Du bist kein Gegner, du bist ein Witz!",
	},
	["RU"] = {
		[1] = "Что это было?!",
		[2] = "Прекрати, идиот!",
		[3] = "Ты с ума сошел?!",
		[4] = "Ты пожалеешь об этом!",
		[5] = "Я тебя поймаю!",
		[6] = "Убирайся, пока я не разозлился!",
		[7] = "Не думай, что сойдёт с рук!",
		[8] = "Ты умрёшь, если я тебя поймаю!",
		[9] = "О чём ты думал?!",
		[10] = "Я заставлю тебя заплатить!",
		[11] = "Ты совершил большую ошибку!",
		[12] = "Я так не оставлю!",
		[13] = "Не думай, что я боюсь!",
		[14] = "Ты не единственный, кто может ударить!",
		[15] = "Я отвечу огнём, если не прекратишь!",
		[16] = "Что, ты считаешь себя героем?",
		[17] = "Я разорву тебя на куски!",
		[18] = "Ты реально последний!",
		[19] = "Мне надоел ты!",
		[20] = "Посмотри на это, трус!",
		[21] = "Я тебя достану!",
		[22] = "Я защищусь, если придётся!",
		[23] = "О чём ты только думал?!",
		[24] = "Прекрати, пока не стало слишком поздно!",
		[25] = "Ты не противник, ты шутка!",
	},
	["PT"] = {
		[1] = "O que foi isso?!",
		[2] = "Pare, idiota!",
		[3] = "Você está louco?!",
		[4] = "Você vai se arrepender!",
		[5] = "Eu vou te pegar!",
		[6] = "Vai embora antes que eu fique bravo!",
		[7] = "Não pense que vai escapar impune!",
		[8] = "Você vai estar morto se eu te pegar!",
		[9] = "Em que você estava pensando?!",
		[10] = "Eu vou te fazer pagar!",
		[11] = "Você cometeu um grande erro!",
		[12] = "Eu não vou deixar isso passar!",
		[13] = "Não pense que tenho medo!",
		[14] = "Você não é o único que pode atacar!",
		[15] = "Vou revidar se não parar!",
		[16] = "O quê, você acha que é um herói?",
		[17] = "Vou te despedaçar!",
		[18] = "Você é realmente o último!",
		[19] = "Estou farto de você!",
		[20] = "Olhe para isso, covarde!",
		[21] = "Eu vou te pegar!",
		[22] = "Vou me defender se precisar!",
		[23] = "Em que você estava pensando?!",
		[24] = "Pare antes que seja tarde demais!",
		[25] = "Você não é um adversário, é uma piada!",
	},
}

function CharacterGivePresentWindow()
	if(isWindowOpen())then
		local ID = tonumber(apocalypseGetElementData(localPlayer, "NPC.InteractionID"))
		local Data = NPC.PedsData[ID]
	
        GUIEditor.window[1] = guiCreateWindow(736, 404, 265, 323, "", false)
        setWindowData()
		guiCreateCloseButton()

        GUIEditor.label[1] = guiCreateLabel(10, 31, 245, 52, getText("CNPC5"):format(Data["Name"]), false, GUIEditor.window[1])
        guiSetFont(GUIEditor.label[1], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[1], "center", true)
        guiLabelSetVerticalAlign(GUIEditor.label[1], "center")
        GUIEditor.gridlist[1] = guiCreateGridList(10, 93, 245, 184, false, GUIEditor.window[1])
        giftItem = guiGridListAddColumn(GUIEditor.gridlist[1], getText("CNPC6"), 0.9)
        GUIEditor.button[1] = guiCreateButton(10, 287, 245, 26, getText("CNPC7"), false, GUIEditor.window[1])
		
		triggerServerEvent("NPC.getGiftItems",localPlayer)
		
		addEventHandler("onClientGUIClick",GUIEditor.button[1],function()
			local selectedRow = guiGridListGetSelectedItem(GUIEditor.gridlist[1])
			if(selectedRow ~= -1)then
				local itemID = guiGridListGetItemData(GUIEditor.gridlist[1], selectedRow, giftItem)
				if(itemID)then
					triggerServerEvent("NPC.givePresent",localPlayer,itemID,Data["Name"],ID)
				end
			else createInfobox(getText("CNPC8"))end
		end,false)
    end
end

addEvent("NPC.updateGiftItems",true)
addEventHandler("NPC.updateGiftItems",root,function(items)
	guiGridListClear(GUIEditor.gridlist[1])
    if(items)then
        for _, v in pairs(items) do
			local row = guiGridListAddRow(GUIEditor.gridlist[1])
			guiGridListSetItemText(GUIEditor.gridlist[1], row, giftItem, v[2], false, false)
			guiGridListSetItemData(GUIEditor.gridlist[1], row, giftItem, v[1])
        end
    end
end)

addEventHandler("onClientPedDamage", root, function(attacker)
	if(apocalypseGetElementData(source, "NPC.ID"))then
		if(attacker == localPlayer)then
			if(not(isTimer(pedDamageTimer2[source])))then
				if(apocalypseGetElementData(source,"DamageTimer") ~= true)then
					local ID = apocalypseGetElementData(source,"NPC.ID")
					apocalypseSetElementData(attacker,"NPC.InteractionID",ID)
					apocalypseSetElementData(source,"DamageTimer",true)
					
					local dialogue = math.random(1,#pedDamageDialogues[apocalypseGetElementData(attacker,"language") or "EN"])
					NPC.NormalMessage(pedDamageDialogues[apocalypseGetElementData(attacker,"language") or "EN"][dialogue],"yes")
				
					local playerX, playerY, playerZ = getElementPosition(attacker)
					
					setPedAnimation(source)
					setPedAimTarget(source,playerX, playerY, playerZ)
					givePedWeapon(source, 24, 5000, true)
					setPedControlState(source, "aim_weapon", true) 
					setPedControlState(source, "fire", true)

					pedDamageTimer[source] = setTimer(function(source)
						setElementRotation(source,0,0,apocalypseGetElementData(source,"Rotation"))
						setIdleAnimation(source)
						setPedControlState(source, "aim_weapon", false) 
						setPedControlState(source,"fire",false)
					end,1000,1,source,oldRotX,oldRotY,oldRotZ)
					pedDamageTimer2[source] = setTimer(function(source)
						apocalypseSetElementData(source,"DamageTimer",false)
					end,2000,1,source)
				end
			end
		end
		cancelEvent()
	end
end)