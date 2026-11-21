GraveyardQuest = {Marker = {}, Pickups = {},
	["Graves"] = {
		{-35.665885925293,2420.5588378906,16.494806289673},
		{-191.52973937988,2535.4794921875,30.455158233643},
		{-391.27725219727,2487.5847167969,41.168411254883},
		{-555.11047363281,2539.0727539062,54.247425079346},
		{-552.31829833984,2689.8127441406,65.683158874512},
		{-501.81741333008,2842.0317382812,82.818420410156},
		{-361.75662231445,2713.8359375,64.272735595703},
		{-175.07427978516,2379.4470214844,54.815826416016},
		{-254.79257202148,1928.8452148438,53.004455566406},
		{-440.83294677734,1838.6433105469,66.477165222168},
		{-153.66152954102,1675.2587890625,15.124800682068},
		{-174.93992614746,1609.3500976562,15.406450271606},
		{-144.32775878906,1563.5562744141,18.630285263062},
		{14.076686859131,1457.5275878906,14.69776725769},
		{347.01693725586,1164.3920898438,8.1220731735229},
		{545.31085205078,1211.9422607422,11.71875},
		{749.86413574219,1397.8692626953,20.997915267944},
		{823.09497070312,1670.3155517578,5.2870330810547},
		{767.95257568359,1929.0854492188,5.5545530319214},
		{805.41522216797,2132.9333496094,11.296397209167},
		{827.11224365234,2404.318359375,19.480545043945},
		{611.70904541016,2511.6032714844,32.968063354492},
		{500.29040527344,2613.6633300781,61.094654083252},
		{449.35736083984,2744.0004882812,73.107009887695},
		{315.52676391602,2818.6750488281,57.562431335449},
		{240.25389099121,2727.2106933594,30.96036529541},
		{134.81480407715,2624.7763671875,16.481967926025},
		{-83.198844909668,2594.6318359375,21.73363494873},
		{-123.12419128418,2749.2194824219,68.253662109375},
		{-617.44696044922,2316.2551269531,75.577125549316},
		{-745.04333496094,2477.6618652344,125.29596710205},
		{-659.84185791016,2330.212890625,138.64820861816},
		{-823.08697509766,2281.8959960938,118.97688293457},
		{-803.49591064453,2426.240234375,157.03677368164},
		{889.14801025391,939.046875,13.3515625},
		{564.34197998047,646.6728515625,4.363245010376},
		{220.23303222656,845.22961425781,14.122103691101},
		{39.032901763916,898.79559326172,24.052606582642},
		{-217.16036987305,811.34527587891,19.859251022339},
		{-408.13479614258,1225.8526611328,2.4431886672974},
		{-242.20722961426,1252.1934814453,24.298385620117},
		{-276.39700317383,1316.1737060547,50.508991241455},
		{82.582710266113,1465.0068359375,11.17592716217},
		{224.95649719238,1589.7322998047,26.679550170898},
		{402.36578369141,1437.2991943359,7.3195180892944},
		{548.99456787109,1627.0590820312,5.8797655105591},
		{463.09808349609,1745.1589355469,31.686847686768},
		{951.52374267578,1604.9676513672,11.271871566772},
		{1094.6685791016,1180.0360107422,10.8203125},
	},
}

local Achievements = {
	{1,309},
	{5,310},
	{10,311},
	{15,312},
	{20,313},
	{25,314},
	{50,315},
	{100,316},
}

local GraveyardEXPPickup = createPickup(823.591796875,-1097.3814697266,25.7890625,3,1239,50)

addEventHandler("onPickupHit",GraveyardEXPPickup,function(player)
	if(getElementType(player) == "player")then
		if(getElementDimension(player) == getElementDimension(source))then
			if(getElementInterior(player) == getElementInterior(source))then
				if(not(isPedInVehicle(player)))then
					local exp_flower = getPlayerData("character_stats","character_id",getCharacterID(player),"flower_exp")
					if(tonumber(exp_flower) >= 1)then
						if(apocalypseGetElementData(player,"ClaimFlowerEXPBindkey") ~= true)then
							createInfobox(player,getText(player,"SGraveyardFlower1"):format(exp_flower))
							bindKey(player,"e","down",claimGraveyardFlowerEXP)
							apocalypseSetElementData(player,"ClaimFlowerEXPBindkey",true)
						end
					else
						createInfobox(player,getText(player,"SGraveyardFlower3"))
					end
				end
			end
		end
	end
end)

function claimGraveyardFlowerEXP(player)
	unbindKey(player,"e","down",claimGraveyardFlowerEXP)
	apocalypseSetElementData(player,"ClaimFlowerEXPBindkey",false)
	if(getDistanceBetweenPoints3D(823.591796875,-1097.3814697266,25.7890625,getElementPosition(player)) <= 5)then
		local exp_flower = getPlayerData("character_stats","character_id",getCharacterID(player),"flower_exp")
		if(tonumber(exp_flower) >= 1)then
			giveEXP(player,exp_flower)
			dbExec(handler,"UPDATE character_stats SET flower_exp = '0' WHERE character_id = '"..getCharacterID(player).."'")
			createInfobox(player,getText(player,"SGraveyardFlower2"):format(exp_flower))
		else
			createInfobox(player,getText(player,"SGraveyardFlower3"))
		end
	end
end

local GraveyardQuestDocument = createPickup(819.33227539062,-1092.0118408203,31.140625,3,2894,50)

addEventHandler("onPickupHit",GraveyardQuestDocument,function(player)
	if(getElementDimension(player) == getElementDimension(source))then
		if(getElementInterior(player) == getElementInterior(source))then
			if(not(isPedInVehicle(player)))then
				triggerClientEvent(player,"GraveyardQuest.showDocumentInfo",player)
				giveRadioData(player, 22)
			end
		end
	end
end)

for i,v in pairs(GraveyardQuest["Graves"])do
	GraveyardQuest.Pickups[i] = createPickup(v[1],v[2],v[3],3,1254,50)
	GraveyardQuest.Marker[i] = createMarker(v[1],v[2],v[3],"cylinder",3,0,0,0,0)
	apocalypseSetElementData(GraveyardQuest.Marker[i],"LootableGrave",true)
	apocalypseSetElementData(GraveyardQuest.Marker[i],"LootGraveID",i)
	
	addEventHandler("onPickupHit",GraveyardQuest.Pickups[i],function(player)
		if(not(isPedInVehicle(player)))then
			if(getElementDimension(player) == getElementDimension(source))then
				if(getElementInterior(player) == getElementInterior(source))then
					createInfobox(player,getText(player,"SGraveyardQuest4"))
					if(apocalypseGetElementData(player,"GraveyardBindKey") ~= true)then
						bindKey(player,"e","down",GraveyardQuest.lootGrave)
						apocalypseSetElementData(player,"GraveyardBindKey",true)
					end
				end
			end
		end
	end)
end

function GraveyardQuest.lootGrave(player)
	for _,v in pairs(GraveyardQuest.Marker)do
		if(isElementWithinMarker(player,v))then
			local ID = apocalypseGetElementData(v,"LootGraveID")
			if(apocalypseGetElementData(v,"LootableGrave") == true)then
				if(hasPlayerItem(player,173) >= 1)then
					unbindKey(player,"e","down",GraveyardQuest.lootGrave)
					setElementFrozen(player,true)
					setPedAnimation(player, "BOMBER", "BOM_Plant_Loop", -1, true, false, false, true)
					apocalypseSetElementData(v,"LootableGrave",false)
					takeItem(player,173,1)
					setTimer(function(player)
						if(isElement(player))then
							if(math.random(1,4) == 2)then
								giveItem(player,174,1)
								NPC.MeMessage(player,getText(player,"SGraveyardQuest1"))
							end
							giveEXP(player,250)
							givePlayerSkillpoint(player,5)
							setElementFrozen(player,false)
							giveLootItems(player, 10)
							setPedAnimation(player)
							apocalypseSetElementData(player,"GraveyardBindKey",false)
							local looted_graves = getPlayerData("character_stats","character_id",getCharacterID(player),"looted_graves")
							Characters.addStats(player,"looted_graves",looted_graves + 1)
							
							for _,v in pairs(Achievements)do
								if(looted_graves + 1 >= v[1])then
									setAchievement(player,v[2])
								end
							end
							
							if(DailyTasks.playerTasks[player][18])then
								DailyTasks.updateProgress(player,18,DailyTasks.playerTasks[player][18].progress + 1)
							end
							
							if(WeeklyTasks.playerTasks[player][18])then
								WeeklyTasks.updateProgress(player,18,WeeklyTasks.playerTasks[player][18].progress + 1)
							end
							
							outputLog(getPlayerName(player).." hat ein Grap gepflegt", "Graves", getCharacterID(player))
						end
					end,7500,1,player)
					setTimer(function(ID)
						apocalypseSetElementData(GraveyardQuest.Marker[ID],"LootableGrave",true)
					end,450000,1,ID)
				else
					NPC.MeMessage(player,getText(player,"SGraveyardQuest2"))
				end
			else
				NPC.MeMessage(player,getText(player,"SGraveyardQuest3"))
			end
			return
		end
	end
end