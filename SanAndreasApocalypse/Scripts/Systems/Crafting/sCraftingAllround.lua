CraftingRecipes = {
	["Data"] = {
		["EN"] = {
			[1] = {"Camera","Take a picture and hold on to memories."}, --//
			[2] = {"Knife","A sharp blade, useful for close combat and survival."}, --//
			[3] = {"Fire Extinguisher","Can put out fires or be used as a blunt weapon."}, --//
			[4] = {"First Aid Kit","Contains medical supplies to treat injuries."}, --//
			[5] = {"Dynamite","A powerful explosive, highly dangerous."}, --//
			[6] = {"Handcuffs","Used to restrain individuals."}, --//
			[7] = {"Axe","Can be used for chopping wood or as a weapon."}, --//
			[8] = {"Joint","A rolled cannabis cigarette, provides relaxation."}, --//
			[9] = {"Diving Suit", "Explore the waters of San Andreas."}, --//
			[10] = {"Syringe","Take blood samples from infected survivors."}, --//
			[11] = {"Iron Armor", "The condition of your armor is increased by 10%."}, --//
			[12] = {"Gold Armor", "The condition of your armor is increased by 25%."}, --//
			[13] = {"Campfire", "Heals you and allows you to cook fish."}, --//
			[14] = {"Bundle of Fish","Can be used for fishing and cooked at the campfire."},
		},
		["DE"] = {
			[1] = {"Kamera","Schieß ein Foto und halte Erinnerungen fest."},
			[2] = {"Messer","Eine scharfe Klinge, nützlich im Nahkampf und zum Überleben."},
			[3] = {"Feuerlöscher","Kann Feuer löschen oder als Schlagwaffe verwendet werden."},
			[4] = {"Erste Hilfe Set","Enthält medizinische Utensilien zur Behandlung von Verletzungen."},
			[5] = {"Dynamit","Ein starkes Explosivmittel, äußerst gefährlich."},
			[6] = {"Handschellen","Dienen zum Fesseln von Personen."},
			[7] = {"Axt","Zum Holzhacken oder als Waffe nutzbar."},
			[8] = {"Joint","Ein gerollter Cannabis-Joint, sorgt für Entspannung."},
			[9] = {"Tauchanzug","Erkunde die Gewässer von San Andreas."},
			[10] = {"Spritze","Nimm Blutbroben von infizierten Überlebenden."},
			[11] = {"Eisenrüstung","Der Zustand deiner Rüstung wird um 10% erhöht."},
			[12] = {"Goldrüstung","Der Zustand deiner Rüstung wird um 25% erhöht."},
			[13] = {"Lagerfeuer","Heilt dich und ermöglicht die Zubereitung von Fisch."},
			[14] = {"Fischbündel","Kann zum Angeln benutzt werden und am Lagefeuer gebraten werden."},
		},
		["RU"] = {
			[1] = {"Камера","Сделай фото и сохрани воспоминания."},
			[2] = {"Нож","Острое лезвие, полезно в ближнем бою и для выживания."},
			[3] = {"Огнетушитель","Может тушить огонь или использоваться как ударное оружие."},
			[4] = {"Аптечка","Содержит медицинские принадлежности для лечения ран."},
			[5] = {"Динамит","Мощное взрывчатое вещество, крайне опасное."},
			[6] = {"Наручники","Используются для связывания людей."},
			[7] = {"Топор","Подходит для рубки дерева или как оружие."},
			[8] = {"Косяк","Скрученный косяк каннабиса, помогает расслабиться."},
			[9] = {"Гидрокостюм","Исследуй воды Сан-Андреаса."},
			[10] = {"Шприц","Бери образцы крови у заражённых выживших."},
			[11] = {"Железная броня","Состояние твоей брони увеличивается на 10%."},
			[12] = {"Золотая броня","Состояние твоей брони увеличивается на 25%."},
			[13] = {"Костёр","Лечит тебя и позволяет готовить рыбу."},
			[14] = {"Связка рыбы","Можно использовать для рыбалки и приготовить на костре."},
		},

		["PT"] = {
			[1] = {"Câmera","Tire uma foto e registre memórias."},
			[2] = {"Faca","Uma lâmina afiada, útil em combate corpo a corpo e sobrevivência."},
			[3] = {"Extintor","Pode apagar fogo ou ser usado como arma de impacto."},
			[4] = {"Kit de primeiros socorros","Contém itens médicos para tratar ferimentos."},
			[5] = {"Dinamite","Um explosivo poderoso, extremamente perigoso."},
			[6] = {"Algemas","Usadas para imobilizar pessoas."},
			[7] = {"Machado","Pode ser usado para cortar madeira ou como arma."},
			[8] = {"Baseado","Um cigarro de cannabis enrolado, proporciona relaxamento."},
			[9] = {"Roupa de mergulho","Explore as águas de San Andreas."},
			[10] = {"Seringa","Colete amostras de sangue de sobreviventes infectados."},
			[11] = {"Armadura de ferro","A durabilidade da sua armadura aumenta em 10%."},
			[12] = {"Armadura de ouro","A durabilidade da sua armadura aumenta em 25%."},
			[13] = {"Fogueira","Cura você e permite cozinhar peixe."},
			[14] = {"Pacote de Peixes","Pode ser usado para pescar e cozinhado na fogueira."},
		},
	},
}

function addPlayerCraftingRecipe(player, ID)
	local ID = tonumber(ID)
	if(hasPlayerCraftingRecipe(player,ID) == false)then
		local playerCraftrecipes = getPlayerData("characters","ID",getCharacterID(player),"craftrecipes")
		dbExec(handler, "UPDATE characters SET craftrecipes = '"..playerCraftrecipes..ID.."|' WHERE ID = '"..getCharacterID(player).."'")
	end
end

function hasPlayerCraftingRecipe(player, ID)
	local ID = tonumber(ID)
	local playerCraftrecipes = getPlayerData("characters","ID",getCharacterID(player),"craftrecipes")
	
	if(not(playerCraftrecipes))then
		dbExec(handler, "UPDATE characters SET craftrecipes = '' WHERE ID = '"..getCharacterID(player).."'")
		playerCraftrecipes = getPlayerData("characters", "ID", getCharacterID(player), "craftrecipes")
	end
	
	local values = split(playerCraftrecipes, "|")
	local hasCraftrecipe = false
	
	if(playerCraftrecipes and ID)then
		for _,v in pairs(values)do
			if(tonumber(v) == ID)then
				hasCraftrecipe = true
				break
			end
		end
	end
	return hasCraftrecipe
end

addEvent("CraftingRecipes.getData",true)
addEventHandler("CraftingRecipes.getData",root,function()
	local Data = {}
	local playerRecipes = getPlayerData("characters","ID",getCharacterID(client),"craftrecipes")
	if(playerRecipes)then
		local values = split(playerRecipes, "|")
		for _,v in pairs(values)do
			local RecipeID = tonumber(v)
			local Table = CraftingRecipes["Data"][apocalypseGetElementData(client,"language") or "EN"][RecipeID]
			if(Table)then
				table.insert(Data,{
					name = Table[1],
					description = Table[2],
					id = RecipeID,
				})
			end
		end
		triggerClientEvent(client,"Collectibles.updateData",client,Data)
	end
end)