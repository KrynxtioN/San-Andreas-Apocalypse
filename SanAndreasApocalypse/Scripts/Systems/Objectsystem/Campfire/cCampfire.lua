local effects = {}

local Decocampfire = {
	{689.42071533203,-429.15798950195,16.059900283813,0,0,312},
	{216.80360412598,-253.76370239258,0.90009999275208,0,0,312},
	{-1983.2330322266,199.11999511719,27.009399414062,0,0,260},
	{-2202.4318847656,2404.9899902344,4.2824001312256,0,0,260},
	{1101.4708251953,-311.24609375,73.314102172852,0,0,346},
}

addEvent("updateCampfiresForAll",true)
addEventHandler("updateCampfiresForAll",root,function()
	for _,v in pairs(effects)do destroyElement(v) end
	effects = {}
	for _,v in pairs(getElementsByType("object"))do
		if(getElementModel(v) == 1463 and getElementData(v,"ServerObjectID"))then
			local x,y,z = getElementPosition(v)
			local ID = getElementData(v,"ServerObjectID")
			effects[ID] = createEffect("fire_med", x,y,z, 0, 0, 0)
		end
	end
end)

for _,v in pairs(Decocampfire)do
	local object = createObject(1463,v[1],v[2],v[3],v[4],v[5],v[6])
	createEffect("fire_med",v[1],v[2],v[3],0,0,0)
end