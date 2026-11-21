Animals = {
    peds = {},
    pedTimer = {},
    pedAngle = {},
    markers = {},
	
    ["Spawns"] = {
        {-2802.7260742188, -1606.8200683594, 141.43353271484,"bear"},
        {-2784.4968261719, -1415.2591552734, 136.4864654541,"bear"},
        {-2699.6301269531, -1271.8903808594, 155.07452392578,"bear"},
        {-2793.8325195312, -1802.5379638672, 139.15158081055,"bear"},
        {-2780.9243164062, -1516.2700195312, 138.90686035156,"bear"},
        {-2831.822265625, -1504.2288818359, 138.81774902344,"bear"},
        {-2815.3833007812, -1468.2091064453, 136.91860961914,"bear"},
        {-2816.3525390625, -1370.5465087891, 132.32168579102,"bear"},
        {-2781.4699707031, -1300.74609375, 125.43470001221,"bear"},
        {-2727.0500488281, -1313.0828857422, 150.44416809082,"bear"},
		
		{-1433.0628662109,-1210.8323974609,105.63841247559,"bear"},
		{-1427.15234375,-1242.154296875,107.29593658447,"bear"},
		{-1404.6784667969,-1254.7946777344,108.7094039917,"bear"},
		{-1372.8344726562,-1248.9140625,110.0277633667,"bear"},
		{-1357.4534912109,-1220.7468261719,113.70207977295,"bear"},
		{-1335.2371826172,-1235.7659912109,121.26434326172,"bear"},
		{-1322.7468261719,-1259.1795654297,123.8450088501,"bear"},
		{-1339.2980957031,-1286.2563476562,126.28028869629,"bear"},
		{-1363.6383056641,-1292.8566894531,129.04389953613,"bear"},
		{-1402.8465576172,-1310.4420166016,121.36827087402,"bear"},
		
		{-2015.8997802734,-2435.1342773438,30.625,"cow1"},
		{-2036.1920166016,-2400.42578125,30.625,"cow2"},
		{-2088.4514160156,-2367.4729003906,30.625,"cow1"},
		{-2054.6076660156,-2331.513671875,30.625,"cow2"},
		{-1979.2904052734,-2473.8566894531,31.063547134399,"cow1"},
		{-1928.3072509766,-2441.7805175781,30.625,"cow2"},
		{-1908.3171386719,-2402.2060546875,30.947441101074,"cow1"},
		{-1938.8505859375,-2485.6459960938,31.499296188354,"cow2"},
		{-2007.3310546875,-2483.2990722656,32.176090240479,"cow1"},
		{-2047.0952148438,-2476.1040039062,30.625,"cow2"},
		{-1875.0950927734,-2447.1950683594,32.538215637207,"cow1"},
		{-1965.3806152344,-2445.8791503906,30.625,"cow2"},
		{-2222.9897460938,-2522.8337402344,30.852975845337,"cow1"},
		{-2268.033203125,-2494.8676757812,27.919593811035,"cow2"},
		{-2291.626953125,-2439.7353515625,26.320838928223,"cow1"},
		{-2304.3381347656,-2374.3056640625,33.629554748535,"cow2"},
		{-2290.0832519531,-2318.244140625,25.006084442139,"cow1"},
		{-2261.7583007812,-2301.0380859375,27.775917053223,"cow2"},
		{-2241.7036132812,-2266.734375,30.659032821655,"cow1"},
		{-2214.1423339844,-2236.0107421875,31.152591705322,"cow2"},
		
		{286.97378540039,-290.60989379883,4.2532353401184,"cow1"},
		{312.32269287109,-290.62408447266,5.2034320831299,"cow2"},
		{331.27032470703,-260.04113769531,6.0339684486389,"cow1"},
		
		{2401.8234863281,-95.318695068359,26.143026351929,"cow2"},
		{2366.6750488281,-96.574378967285,26.727193832397,"cow1"},
		{2349.7639160156,-124.60972595215,27.185382843018,"cow2"},
		{2363.1535644531,-144.66410827637,27.043361663818,"cow1"},
		{2392.8244628906,-155.26168823242,26.641567230225,"cow2"},
		{2416.9157714844,-148.85656738281,29.743492126465,"cow1"},
		{2438.6745605469,-148.15649414062,31.987796783447,"cow2"},
		{2466.48828125,-137.52529907227,32.681468963623,"cow1"},
		{2466.3374023438,-111.55842590332,31.084924697876,"cow2"},
		{2467.5651855469,-78.818069458008,28.589797973633,"cow1"},
		
		{-260.67889404297,-2182.7055664062,28.986824035645, "bigfoot"},
		
		{2493.7717285156,-755.23327636719,99.932678222656,"wolf"},
		{2378.6245117188,-764.46899414062,127.42937469482,"wolf"},
		{2327.2971191406,-697.74841308594,132.17671203613,"wolf"},
		{2314.5668945312,-586.55767822266,130.74406433105,"wolf"},
		{2241.5305175781,-623.99273681641,125.06167602539,"wolf"},
		{2285.2595214844,-701.66448974609,130.78511047363,"wolf"},
		{2331.916015625,-606.37072753906,129.55158996582,"wolf"},
		{2327.1428222656,-521.12072753906,123.57652282715,"wolf"},
		{2446.2749023438,-517.89245605469,104.87564086914,"wolf"},
		{2454.2192382812,-435.087890625,78.154937744141,"wolf"},
		{2429.3688964844,-384.22384643555,68.103202819824,"wolf"},
		{2589.9213867188,-353.56900024414,63.008201599121,"wolf"},
		{2659.3833007812,-386.29302978516,53.680728912354,"wolf"},
		{2717.7346191406,-475.08160400391,52.572158813477,"wolf"},
		{2741.3732910156,-678.87066650391,70.281135559082,"wolf"},
		
		{579.31146240234,190.28663635254,20.95464515686,"wolf"},
		{599.15960693359,211.19746398926,22.902612686157,"wolf"},
		{633.40631103516,207.74925231934,22.650106430054,"wolf"},
		{655.18243408203,210.63581848145,23.99028968811,"wolf"},
		{669.92724609375,228.2502746582,24.970699310303,"wolf"},
		{659.42303466797,262.70593261719,21.426849365234,"wolf"},
		{668.81182861328,282.92590332031,19.979724884033,"wolf"},
		{700.36206054688,263.23233032227,22.111759185791,"wolf"},
		{731.13433837891,253.72372436523,26.765121459961,"wolf"},
		{750.59796142578,222.05262756348,30.17459487915,"wolf"},
		{755.59478759766,199.76788330078,31.842386245728,"wolf"},
		{752.42529296875,175.45104980469,37.341835021973,"wolf"},
		{740.20111083984,158.96003723145,38.14225769043,"wolf"},
		{712.57928466797,140.72015380859,30.937999725342,"wolf"},
		{678.61712646484,111.75760650635,21.97635269165,"wolf"},
		
		{-1661.3968505859,2583.0622558594,83.092704772949,"goat"},
		{-1706.8082275391,2657.0375976562,63.715759277344,"goat"},
		{-1764.5487060547,2714.5764160156,59.475700378418,"goat"},
		{-1643.5120849609,2701.9260253906,56.676094055176,"goat"},
		{-1564.64453125,2683.1081542969,55.727630615234,"goat"},
		{-1492.4907226562,2697.3654785156,55.840278625488,"goat"},
		{-1412.9476318359,2622.9870605469,55.8359375,"goat"},
		{-1362.6484375,2656.3759765625,51.49719619751,"goat"},
		{-1340.9270019531,2735.8122558594,52.751556396484,"goat"},
		{-1423.7785644531,2776.4760742188,76.781539916992,"goat"},
		{-1540.2293701172,2846.4650878906,97.834091186523,"goat"},
		{-1537.7821044922,2516.5427246094,55.990394592285,"goat"},
		{-1505.1733398438,2485.8413085938,55.719772338867,"goat"},
		{-1400.2725830078,2568.6145019531,58.799819946289,"goat"},
		{-1311.1591796875,2665.6975097656,50.0625,"goat"},
		
		{-166.7943572998,201.46910095215,10.473273277283,"goat"},
		{-190.50239562988,204.52340698242,11.734250068665,"goat"},
		{-220.30546569824,221.80145263672,12.061420440674,"goat"},
		{-235.5007019043,214.6282043457,12.08970451355,"goat"},
		{-254.59074401855,210.67211914062,10.530563354492,"goat"},
		{-273.13461303711,224.34394836426,11.678600311279,"goat"},
		{-287.58361816406,214.13543701172,8.7488346099854,"goat"},
		{-290.78024291992,193.91746520996,6.4085884094238,"goat"},
		{-284.34118652344,166.24705505371,5.1785202026367,"goat"},
		{-273.15747070312,145.96997070312,5.2157516479492,"goat"},
		
		{2427.1496582031,-1838.8968505859,1245.7523193359,"spinosaurus"},
		
		{364.15335083008,-446.77062988281,25.276416778564,"fox"},
		{387.58776855469,-418.82757568359,25.488208770752,"fox"},
		{410.77767944336,-429.88989257812,26.856985092163,"fox"},
		{406.79730224609,-461.01599121094,30.156572341919,"fox"},
		{438.75537109375,-470.49298095703,37.030570983887,"fox"},
		{431.11370849609,-493.58193969727,41.009384155273,"fox"},
		{416.96591186523,-521.21826171875,42.222099304199,"fox"},
		{401.68505859375,-533.77081298828,40.540267944336,"fox"},
		{377.69357299805,-539.29949951172,39.780944824219,"fox"},
		{366.9274597168,-558.30236816406,42.433353424072,"fox"},
		{366.66360473633,-498.30218505859,20.399110794067,"fox"},
		{346.02554321289,-524.50244140625,15.503620147705,"fox"},
		{329.76495361328,-532.72308349609,12.445936203003,"fox"},
		{311.79772949219,-521.09185791016,10.560314178467,"fox"},
		{303.16525268555,-499.90353393555,11.894836425781,"fox"},
		
		{-584.56170654297,-2374.9936523438,27.927127838135,"fox"},
		{-573.71166992188,-2348.0446777344,27.574138641357,"fox"},
		{-546.75836181641,-2321.9753417969,28.893348693848,"fox"},
		{-531.95812988281,-2299.6772460938,30.341110229492,"fox"},
		{-534.94409179688,-2271.3166503906,31.4049949646,"fox"},
		{-554.41192626953,-2255.8298339844,29.881244659424,"fox"},
		{-582.01171875,-2255.7497558594,26.053142547607,"fox"},
		{-613.24987792969,-2270.2368164062,25.81254196167,"fox"},
		{-631.66119384766,-2278.2788085938,27.032577514648,"fox"},
		{-652.89624023438,-2289.9729003906,30.20408821106,"fox"},
    },
	["Models"] = {
		["bear"] = 237,
		["goat"] = 238,
		["wolf"] = 243,
		["cow1"] = 244,
		["cow2"] = 245,
		["bigfoot"] = 9,
		["spinosaurus"] = 94,
		["chicken"] = 251,
		["fox"] = 252,
	},
}

local Achievements = {
	{10,98},
	{25,99},
	{50,100},
	{100,101},
	{175,102},
	{250,103},
}

function Animals.load()
    local radius = 3
    for i, spawn in ipairs(Animals["Spawns"]) do
		if(not(isElement(Animals.peds[i])))then
			local cx, cy, cz = spawn[1], spawn[2], spawn[3]
			local startAngle = math.random(0, 359)
			Animals.pedAngle[i] = startAngle
			local rad = math.rad(startAngle)
			local startX = cx + radius * math.cos(rad)
			local startY = cy + radius * math.sin(rad)
			
			local rotation = (startAngle + 90) % 360
			local model = Animals["Models"][spawn[4]]

			Animals.peds[i] = createPed(model, startX, startY, cz, rotation)
			apocalypseSetElementData(Animals.peds[i], "Animal", true)
			apocalypseSetElementData(Animals.peds[i], "AnimalID", i)
			apocalypseSetElementData(Animals.peds[i], "AnimalType", spawn[4])
			setPedAnimation(Animals.peds[i], "ped", "Player_Sneak", -1, true, true, true)
			if(spawn[5])then setElementInterior(Animals.peds[i],spawn[5])end

			if(spawn[4] ~= "bigfoot")then
				Animals.markers[i] = createMarker(startX, startY, cz-0.75, "cylinder", 5, 255, 255, 255, 0)
				attachElements(Animals.markers[i], Animals.peds[i], 0, 0, 0)
				apocalypseSetElementData(Animals.markers[i], "animalPed", Animals.peds[i])

				if(spawn[5])then
					setElementInterior(Animals.markers[i], spawn[5])
					setElementInterior(Animals.peds[i], spawn[5])
				end
				setElementDimension(Animals.markers[i], getElementDimension(Animals.peds[i]))
			end

			local marker = Animals.markers[i]
			if(marker)then
				addEventHandler("onMarkerHit", marker, function(hitElement, matchingDimension)
					if(not matchingDimension)then return end
					if(getElementType(hitElement) ~= "player")then return end
					if(isPedInVehicle(hitElement))then return end

					apocalypseSetElementData(hitElement, "AnimalMarker", source)

					if(apocalypseGetElementData(hitElement,"AnimalKeyBound"))then return end
					apocalypseSetElementData(hitElement,"AnimalKeyBound",true)

					bindKey(hitElement,"e","down",Animals.Kill)
					triggerClientEvent(hitElement,"createActivitiesInformationText",hitElement,getText(hitElement,"SAnimals2"))
				end)

				addEventHandler("onMarkerLeave", marker, function(leaveElement, matchingDimension)
					if(not matchingDimension)then return end
					if(getElementType(leaveElement) ~= "player")then return end

					unbindKey(leaveElement, "e", "down", Animals.Kill)
					apocalypseSetElementData(leaveElement,"AnimalKeyBound",false)
					apocalypseSetElementData(leaveElement, "AnimalMarker", false)
				end)
			end
			
			local index = i
			Animals.pedTimer[i] = setTimer(function(ped)
				if(not(isPedDead(ped)))then
					local currentAngle = Animals.pedAngle[index]
					local delta = math.random(65, 120)
					local newAngle = (currentAngle + delta) % 360
					Animals.pedAngle[index] = newAngle
					local rad = math.rad(newAngle)
					local newX = cx + radius * math.cos(rad)
					local newY = cy + radius * math.sin(rad)
					local newRotation = (newAngle + 90) % 360
					setElementRotation(ped, 0, 0, newRotation)
					setPedAnimation(ped, "ped", "Player_Sneak", -1, true, true, true)
				end
			end, 5000, 0, Animals.peds[i])
		end
    end
end

function Animals.Kill(player)
	local marker = apocalypseGetElementData(player,"AnimalMarker")
	local animalPed = apocalypseGetElementData(marker, "animalPed")
	if(animalPed and not apocalypseGetElementData(animalPed, "dead"))then
		if(not(isPedInVehicle(player)))then
			if(not(isPedDead(player)))then
				if(hasPlayerItem(player,107) >= 1)then
					local animalType = apocalypseGetElementData(animalPed,"AnimalType")
					setElementFrozen(player,true)
					setPedAnimation(player,"knife","knife_"..math.random(1,4))
					setTimer(function(player)
						setPedAnimation(player,"knife","knife_"..math.random(1,4))
					end,600,3,player)
					
					local itemAmount = 1
					
					local Level_Bonus_EXP = tonumber(apocalypseGetElementData(player,"level"))
					if(Level_Bonus_EXP > 100)then Level_Bonus_EXP = 100 end
	
					local EXP = 25 + (Level_Bonus_EXP * 1)
					if(SERVERBONUS.ANIMAL == true)then
						itemAmount = 2
						EXP = EXP * 2
					end
					
					unbindKey(player, "e", "down", Animals.Kill)
					apocalypseSetElementData(player,"AnimalKeyBound",false)
					apocalypseSetElementData(player, "AnimalMarker", false)
					
					setTimer(function(player,animalType,itemAmount,EXP)
						setElementFrozen(player,false)
						setPedAnimation(player)
						
						local killed_animals = getPlayerData("character_stats","character_id",getCharacterID(player),"killed_animals")
						Characters.addStats(player,"killed_animals",killed_animals + 1)
						
						if(DailyTasks.playerTasks[player][7])then
							DailyTasks.updateProgress(player,7,DailyTasks.playerTasks[player][7].progress + 1)
						end
						if(WeeklyTasks.playerTasks[player][7])then
							WeeklyTasks.updateProgress(player,7,WeeklyTasks.playerTasks[player][7].progress + 1)
						end
						
						for _,v in pairs(Achievements)do
							if((killed_animals + 1) >= v[1])then
								setAchievement(player,v[2])
							end
						end
						
						if(animalType == "bear")then
							giveItem(player,108,itemAmount)
							setAchievement(player,96)
							triggerClientEvent(player, "showItemBar", player, {{108,itemAmount},{117,itemAmount}})
							outputLog(getPlayerName(player).." hat ein Tier ("..animalType..") getötet und "..EXP.." EXP und "..itemAmount.."x das Item 108 und 117 erhalten","Animals",getCharacterID(player))
						end
						if(animalType == "cow1" or animalType == "cow2")then
							giveItem(player,118,itemAmount)
							setAchievement(player,97)
							triggerClientEvent(player, "showItemBar", player, {{118,itemAmount},{117,itemAmount}})
							outputLog(getPlayerName(player).." hat ein Tier ("..animalType..") getötet und "..EXP.." EXP und "..itemAmount.."x das Item 117 und 118 erhalten","Animals",getCharacterID(player))
						end
						giveItem(player,117,itemAmount)
						giveEXP(player,EXP)
						NPC.MeMessage(player,getText(player,"SAnimals3"))
						if(animalType ~= "bear" and animalType ~= "cow1" and animalType ~= "cow2")then
							outputLog(getPlayerName(player).." hat ein Tier ("..animalType..") getötet und "..EXP.." EXP und "..itemAmount.."x das Item 117 erhalten","Animals",getCharacterID(player))
						end
					end,3000,1,player,animalType,itemAmount,EXP)
					
					apocalypseSetElementData(animalPed, "dead", true)
					local ID = apocalypseGetElementData(animalPed, "AnimalID")
					killTimer(Animals.pedTimer[ID])
					destroyElement(Animals.markers[ID])
					killPed(Animals.peds[ID])
										
					setTimer(function(ID)
						destroyElement(Animals.peds[ID])
					end,300000,1,ID)
				else
					NPC.MeMessage(player,getText(player,"SAnimals1"))
				end
			end
		end
	end
end
Animals.load()
setTimer(Animals.load,1800000,0)