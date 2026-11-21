ClothesShop = {}

addEvent("ClothesShop.buy",true)
addEventHandler("ClothesShop.buy",root,function(clothes1,clothes2,clothes3,Type)
	if(Type == "Haare")then neededItem = 53 amount = 25 end
	if(Type == "Tattoos")then neededItem = 48 amount = 25 end
	if(Type == "Shirts")then neededItem = 32 amount = 25 end
	if(Type == "Hosen")then neededItem = 32 amount = 25 end
	if(Type == "Schuhe")then neededItem = 32 amount = 25 end
	if(Type == "Kopfbedeckungen")then neededItem = 32 amount = 25 end
	if(hasPlayerItem(client,neededItem) >= amount)then
		addPedClothes(client,clothes1,clothes2,clothes3)
		savePlayerClothes(client)
		NPC.MeMessage(client,getText(client,"SClothesShop2"))
	else
		NPC.MeMessage(client,getText(client,"SClothesShop1"):format(ItemInfos["items"][apocalypseGetElementData(client,"language") or "EN"][neededItem]))
	end
end)