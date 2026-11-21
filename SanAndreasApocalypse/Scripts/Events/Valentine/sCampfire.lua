ValentinesDayCampfire = {
	Fire_Object = {},
	Peds = {},
	["Spawn"] = {
		{663.74371337891,-680.16656494141,15.96808052063},
		{770.82232666016,-620.03442382812,15.55110168457},
		{747.18762207031,-310.58447265625,9.3786373138428},
		{1033.591796875,-346.96893310547,73.9921875},
		{1118.2330322266,-571.77325439453,104.9140625},
		{1323.3262939453,-563.03460693359,93.767196655273},
		{1270.6585693359,-370.98956298828,2.6312570571899},
		{829.34924316406,-202.86715698242,19.943548202515},
		{416.00555419922,-513.99157714844,41.867607116699},
		{544.84997558594,-960.75659179688,88.883949279785},
	},
}

function ValentinesDayCampfire.updateFire()
	if(ValentineEvent == true)then
		for _, v in pairs(getElementsByType("player")) do
			if(isCharacterLoggedIn(v))then
				triggerClientEvent(v, "ValentinesDayCampfireUpdate", v)
			end
		end
	end
end

function ValentinesDayCampfire.load()
	if(ValentineEvent == true)then
		for i, v in ipairs(ValentinesDayCampfire["Spawn"]) do
			if(not(isElement(ValentinesDayCampfire.Fire_Object[i])))then
				ValentinesDayCampfire.Fire_Object[i] = createObject(1463, v[1], v[2], v[3]-0.65, 0, 0, math.random(330,360))
				local object = ValentinesDayCampfire.Fire_Object[i]
				apocalypseSetElementData(object, "ValentinesDayCampfireID", i)
				setObjectBreakable(ValentinesDayCampfire.Fire_Object[i],false)
				
				local Ped1 = createPed(possibleSkinsDecorationPeds[math.random(1,#possibleSkinsDecorationPeds)], v[1], v[2], v[3], 170)
				local Ped2 = createPed(possibleSkinsDecorationPeds[math.random(1,#possibleSkinsDecorationPeds)], v[1], v[2], v[3], 150)
				table.insert(ValentinesDayCampfire.Peds, Ped1)
				table.insert(ValentinesDayCampfire.Peds, Ped2)
				apocalypseSetElementData(Ped1, "ValentinesDayCampfireID", i)
				apocalypseSetElementData(Ped2, "ValentinesDayCampfireID", i)
				
				attachElements(Ped1, object, 0, 2, 0.75)
				attachElements(Ped2, object, 1, 2, 0.75)
				
				setPedAnimation(Ped1, "sunbathe", "parksit_m_idlea", -1, true, false, false, true)
				setPedAnimation(Ped2, "sunbathe", "parksit_m_idlea", -1, true, false, false, true)
			end
		end
		setTimer(function() ValentinesDayCampfire.updateFire() end,2500,1)
	end
end

if(ValentineEvent == true)then
	ValentinesDayCampfire.load()
	setTimer(ValentinesDayCampfire.load,300000,0)
end

addEventHandler("onPedWasted", root, function(_, attacker)
	if(ValentineEvent == true)then
		if attacker and getElementType(attacker) == "player" then
			local amount = 0
			local ID = tonumber(apocalypseGetElementData(source, "ValentinesDayCampfireID"))
			if ID then
				giveValentineItem(attacker,5)
				for _, v in pairs(ValentinesDayCampfire.Peds) do
					if apocalypseGetElementData(v, "ValentinesDayCampfireID") == ID then
						if not isPedDead(v) then
							amount = amount + 1
						end
					end
				end
				if amount == 0 then
					setTimer(function(ID)
						for i = #ValentinesDayCampfire.Peds, 1, -1 do
							local ped = ValentinesDayCampfire.Peds[i]
							if apocalypseGetElementData(ped, "ValentinesDayCampfireID") == ID then
								destroyElement(ped)
								table.remove(ValentinesDayCampfire.Peds, i)
							end
						end
						destroyElement(ValentinesDayCampfire.Fire_Object[ID])
						for _,v in pairs(getElementsByType("player"))do
							ValentinesDayCampfire.updateFire(v)
						end
					end,12500,1,ID)
				end
			end
		end
	end
end)