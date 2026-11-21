ValentineQuest = {}

ValentineQuest["Flowers"] = {
	{-545.90264892578,-75.594749450684,62.859375},
}

ValentineQuest["Ped"] = {
	{621.37408447266,-1097.68359375,46.807415008545,214},
}

local Text = {
	["EN"] = {
		[1] = "George: I just need a damn bouquet! Do you have one for me?",
		[2] = "George: As I can see, you don’t have anything! Where are the flowers?",
		[3] = "George: Thank you! Here, 100 boxes of pralines.",
		[4] = "Quest started. The destination has been marked on the map.",
		[5] = "A bouquet has been marked on the map.",
	},
	["DE"] = {
		[1] = "George: Ich brauche doch nur einen verdammten Blumenstrauß! Hast du einen für mich?",
		[2] = "George: Wie ich sehe, hast du nichts! Wo bleiben die Blumen?",
		[3] = "George: Danke! Hier, 100 Pralinenschachteln.",
		[4] = "Quest gestartet. Der Zielort wurde auf der Karte markiert.",
		[5] = "Ein Blumenstrauß wurde auf der Karte markiert.",
	},
	["PT"] = {
		[1] = "George: Eu só preciso de um maldito buquê! Você tem um para mim?",
		[2] = "George: Pelo que vejo, você não tem nada! Onde estão as flores?",
		[3] = "George: Obrigado! Aqui, 100 caixas de pralinés.",
		[4] = "Missão iniciada. O destino foi marcado no mapa.",
		[5] = "Um buquê foi marcado no mapa.",
	},

	["RU"] = {
		[1] = "Джордж: Мне просто нужен чёртов букет! У тебя есть один для меня?",
		[2] = "Джордж: Как я вижу, у тебя ничего нет! Где цветы?",
		[3] = "Джордж: Спасибо! Вот, 100 коробок пралине.",
		[4] = "Задание начато. Место назначения отмечено на карте.",
		[5] = "Букет отмечен на карте.",
	},
}

function ValentineQuest.loadQuest()
	ValentineQuest.Data = {
		Stage = 1,
		hasFlowers = 0,
	}
	ValentineQuest.checkStage()
	createInfobox(Text[apocalypseGetElementData(localPlayer,"language") or "EN"][4])
end
addEvent("ValentineQuest.loadQuest",true)
addEventHandler("ValentineQuest.loadQuest",root,ValentineQuest.loadQuest)

function ValentineQuest.checkStage()
	if(ValentineQuest.Data.Stage)then
		if(ValentineQuest.Data.Stage == 1)then
			local rnd = math.random(1,#ValentineQuest["Ped"])
			local tbl = ValentineQuest["Ped"][rnd]
			local x,y,z,rz = tbl[1],tbl[2],tbl[3],tbl[4]
			ValentineQuest.Ped = createPed(0,x,y,z,rz)
			setPedAnimation(ValentineQuest.Ped,"on_lookers","wave_loop")
			ValentineQuest.PedMarker = createMarker(x,y,z,"cylinder",2.5,0,0,0,0)
			ValentineQuest.PedBlip = createBlip(x,y,z,41,0,0,0,255)
			local language = apocalypseGetElementData(localPlayer,"language") or "EN"
			
			addEventHandler("onClientMarkerHit",ValentineQuest.PedMarker,function(player)
				if(player == localPlayer)then
					if(getElementDimension(localPlayer) == getElementDimension(source))then
						if(not(isPedInVehicle(localPlayer)))then
							if(ValentineQuest.Data.hasFlowers == 0)then
								ValentineQuest.Data.hasFlowers = 1
								outputChatBox(Text[language][1],255,255,255)
								
								createInfobox(Text[language][5])
								
								local rnd = math.random(1,#ValentineQuest["Flowers"])
								local tbl = ValentineQuest["Flowers"][rnd]
								local x,y,z = tbl[1],tbl[2],tbl[3]
								ValentineQuest.Flowers = createPickup(x,y,z,3,325,50)
								ValentineQuest.FlowersBlip = createBlip(x,y,z,41,0,0,0,255)
								
								addEventHandler("onClientPickupHit",ValentineQuest.Flowers,function(player)
									if(player == localPlayer)then
										if(getElementDimension(localPlayer) == getElementDimension(source))then
											if(not(isPedInVehicle(localPlayer)))then
												destroyElement(source)
												destroyElement(ValentineQuest.FlowersBlip)
												ValentineQuest.Data.hasFlowers = 2
											end
										end
									end
								end)
							elseif(ValentineQuest.Data.hasFlowers == 1)then
								outputChatBox(Text[language][2],255,255,255)
							elseif(ValentineQuest.Data.hasFlowers == 2)then
								outputChatBox(Text[language][3],255,255,255)
								destroyElement(ValentineQuest.Ped)
								destroyElement(ValentineQuest.PedMarker)
								destroyElement(ValentineQuest.PedBlip)
								triggerServerEvent("ValentineQuest.finished",localPlayer)
							end
						end
					end
				end
			end)
		end
	end
end

addEventHandler("onClientPedDamage",root,function()
	if(source == ValentineQuest.Ped)then
		cancelEvent()
	end
end)