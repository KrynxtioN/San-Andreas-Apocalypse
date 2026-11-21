pirateTXD = engineLoadTXD("Files/Skins/pirate.txd")
engineImportTXD(pirateTXD,40)
pirateDFF = engineLoadDFF("Files/Skins/pirate.dff")
engineReplaceModel(pirateDFF,40)

NPCDialogs_New = {
	{
		id = "pirate_guard",
		model = 4,
		position = {-2033.7023925781, -7642.5620117188, 2.0408191680908},
		rotation = 358.85549926758,
		interactDistance = 5,

		name = {
			["DE"] = "Piratenwächter",
			["EN"] = "Pirate Guard",
			["RU"] = "Страж пиратов",
			["PT"] = "Guarda Pirata",
		},

		dialog = {
			start = "start",

			nodes = {
				start = {
					title = {
						["DE"] = "Piratenwächter",
						["EN"] = "Pirate Guard",
						["RU"] = "Страж пиратов",
						["PT"] = "Guarda Pirata",
					},

					text = {
						["DE"] = "Arrr! Willkommen auf der Pirateninsel. Um deinen Besuch bei uns nie zu vergessen, solltest du eine meiner exklusiven Pirateninsel Postkarten mitnehmen. Für gerade einmal $1250 verkaufe ich dir eine. Was sagst du?",
						["EN"] = "Arrr! Welcome to Pirate Island. To never forget your visit here, you should take one of my exclusive Pirate Island postcards with you. For only $1250, I will sell you one. What do you say?",
						["RU"] = "Аррр! Добро пожаловать на Пиратский остров. Чтобы никогда не забыть свой визит сюда, тебе стоит взять одну из моих эксклюзивных открыток Пиратского острова. Всего за $1250 я продам тебе одну. Что скажешь?",
						["PT"] = "Arrr! Bem-vindo à Ilha Pirata. Para nunca esquecer sua visita aqui, você deveria levar um dos meus cartões-postais exclusivos da Ilha Pirata. Por apenas $1250, eu vendo um para você. O que me diz?",
					},

					options = {
						{
							text = {
								["DE"] = "Wer bist du?",
								["EN"] = "Who are you?",
								["RU"] = "Кто ты?",
								["PT"] = "Quem é você?",
							},
							next = "who"
						},

						{
							text = {
								["DE"] = "Pirateninsel Postkarte kaufen.",
								["EN"] = "Buy Pirate Island postcard.",
								["RU"] = "Купить открытку Пиратского острова.",
								["PT"] = "Comprar cartão-postal da Ilha Pirata.",
							},

							callback = function(npc)
								triggerServerEvent("PirateIsland.claimReward", localPlayer)
							end
						},

						{
							text = {
								["DE"] = "So viel Geld für ein Stück Pappe?! Das hättest du wohl gern!",
								["EN"] = "That much money for a piece of cardboard?! In your dreams!",
								["RU"] = "Столько денег за кусок картона?! Размечтался!",
								["PT"] = "Tudo isso por um pedaço de papelão?! Sonha!",
							}
						}
					}
				},

				who = {
					title = {
						["DE"] = "Piratenwächter",
						["EN"] = "Pirate Guard",
						["RU"] = "Страж пиратов",
						["PT"] = "Guarda Pirata",
					},

					text = {
						["DE"] = "Ich bin einer der Wächter dieser Insel. Und nebenbei verkaufe ich Postkarten. Also, wie sieht es aus? Willst du eine haben?",
						["EN"] = "I am one of the guardians of this island. And on the side, I sell postcards. So, what do you say? Want one?",
						["RU"] = "Я один из стражей этого острова. А ещё я продаю открытки. Ну так что? Хочешь одну?",
						["PT"] = "Sou um dos guardiões desta ilha. E nas horas vagas vendo cartões-postais. Então, o que acha? Quer um?",
					},

					options = {
						{
							text = {
								["DE"] = "Pirateninsel Postkarte kaufen.",
								["EN"] = "Buy Pirate Island postcard.",
								["RU"] = "Купить открытку Пиратского острова.",
								["PT"] = "Comprar cartão-postal da Ilha Pirata.",
							},

							callback = function(npc)
								triggerServerEvent("PirateIsland.claimReward", localPlayer)
							end
						},

						{
							text = {
								["DE"] = "Zurück.",
								["EN"] = "Back.",
								["RU"] = "Назад.",
								["PT"] = "Voltar.",
							},

							next = "start"
						},

						{
							text = {
								["DE"] = "Deine Postkarten sind hässlich. Tschüss.",
								["EN"] = "Your postcards are ugly. Goodbye.",
								["RU"] = "Твои открытки ужасны. Пока.",
								["PT"] = "Seus cartões-postais são horríveis. Tchau.",
							}
						}
					}
				},
			}
		}
	},
}

LoadedNPCDialogs_New = {}

DialogSystem = {
	active = false,
	npc = nil,
	element = nil,
	data = nil,
	currentNode = nil,
	selectedOption = 1,
	dialogKeysBound = false,
	interactKeyBound = false,
	nearNPC = nil
}

function getCurrentDialogLanguage()
	local lang = getElementData(localPlayer, "Language") or getElementData(localPlayer, "language") or "EN"
	lang = tostring(lang):upper()

	if lang ~= "DE" and lang ~= "EN" and lang ~= "RU" and lang ~= "PT" then
		lang = "EN"
	end

	return lang
end

function getDialogLanguageText(data)
	if type(data) ~= "table" then
		return tostring(data or "")
	end

	local lang = getCurrentDialogLanguage()
	return data[lang] or data["EN"] or data["DE"] or "Missing Translation"
end

function loadNPCDialogs_New()
	for _, npc in ipairs(NPCDialogs_New) do
		local x, y, z = unpack(npc.position)

		npc.element = createPed(npc.model, x, y, z, npc.rotation or 0)
		setPedAnimation(npc.element,"cop_ambient","coplook_loop")
		setElementFrozen(npc.element, true)

		if npc.interior then
			setElementInterior(npc.element, npc.interior)
		end

		if npc.dimension then
			setElementDimension(npc.element, npc.dimension)
		end

		addEventHandler("onClientPedDamage", npc.element, function()
			cancelEvent()
		end)

		table.insert(LoadedNPCDialogs_New, npc)
	end
end

function bindDialogInteractKey()
	if DialogSystem.interactKeyBound then return end
	bindKey("e", "down", NPCDialog_KeyInteract)
	DialogSystem.interactKeyBound = true
end

function unbindDialogInteractKey()
	if not DialogSystem.interactKeyBound then return end
	unbindKey("e", "down", NPCDialog_KeyInteract)
	DialogSystem.interactKeyBound = false
end

function bindDialogControlKeys()
	if DialogSystem.dialogKeysBound then return end

	bindKey("arrow_u", "down", NPCDialog_KeyUp)
	bindKey("arrow_d", "down", NPCDialog_KeyDown)
	bindKey("num_8", "down", NPCDialog_KeyUp)
	bindKey("num_2", "down", NPCDialog_KeyDown)
	bindKey("enter", "down", NPCDialog_KeyConfirm)
	bindKey("num_enter", "down", NPCDialog_KeyConfirm)
	bindKey("space", "down", NPCDialog_KeyConfirm)
	bindKey("backspace", "down", NPCDialog_KeyClose)

	for i = 1, 9 do
		bindKey(tostring(i), "down", NPCDialog_KeyNumber)
	end

	DialogSystem.dialogKeysBound = true
end

function unbindDialogControlKeys()
	if not DialogSystem.dialogKeysBound then return end

	unbindKey("arrow_u", "down", NPCDialog_KeyUp)
	unbindKey("arrow_d", "down", NPCDialog_KeyDown)
	unbindKey("num_8", "down", NPCDialog_KeyUp)
	unbindKey("num_2", "down", NPCDialog_KeyDown)
	unbindKey("enter", "down", NPCDialog_KeyConfirm)
	unbindKey("num_enter", "down", NPCDialog_KeyConfirm)
	unbindKey("space", "down", NPCDialog_KeyConfirm)
	unbindKey("backspace", "down", NPCDialog_KeyClose)

	for i = 1, 9 do
		unbindKey(tostring(i), "down", NPCDialog_KeyNumber)
	end

	DialogSystem.dialogKeysBound = false
end

function NPCDialog_KeyInteract()
	if DialogSystem.active then return end

	local npc = DialogSystem.nearNPC or getNearestDialogNPC()

	if npc then
		DialogSystem:start(npc)
	end
end

function NPCDialog_KeyUp()
	if DialogSystem.active then
		DialogSystem:selectUp()
	end
end

function NPCDialog_KeyDown()
	if DialogSystem.active then
		DialogSystem:selectDown()
	end
end

function NPCDialog_KeyConfirm()
	if DialogSystem.active then
		DialogSystem:chooseOption(DialogSystem.selectedOption)
	end
end

function NPCDialog_KeyClose()
	if DialogSystem.active then
		DialogSystem:stop()
	end
end

function NPCDialog_KeyNumber(key)
	if not DialogSystem.active then return end

	local number = tonumber(key)

	if number then
		DialogSystem:chooseOption(number)
	end
end

function DialogSystem:start(npc)
	if self.active then return end
	if not npc or not isElement(npc.element) then return end

	self.active = true
	self.npc = npc
	self.element = npc.element
	self.data = npc.dialog
	self.currentNode = npc.dialog.start or "start"
	self.selectedOption = 1

	unbindDialogInteractKey()
	bindDialogControlKeys()

	showCursor(true)

	local x, y, z = getElementPosition(npc.element)
	local _, _, rz = getElementRotation(npc.element)

	local angle = math.rad(rz)
	local camDist = npc.cameraDistance or 3.2
	local camHeight = npc.cameraHeight or 1.05
	local lookHeight = npc.cameraLookHeight or 0.85

	local camX = x - math.sin(angle) * camDist
	local camY = y + math.cos(angle) * camDist
	local camZ = z + camHeight

	setCameraMatrix(camX, camY, camZ, x, y, z + lookHeight)
end

function DialogSystem:stop()
	if not self.active then return end

	self.active = false
	self.npc = nil
	self.element = nil
	self.data = nil
	self.currentNode = nil
	self.selectedOption = 1

	unbindDialogControlKeys()

	showCursor(false)
	setCameraTarget(localPlayer)
end

function DialogSystem:getCurrentNode()
	if not self.data or not self.currentNode then return nil end
	return self.data.nodes[self.currentNode]
end

function DialogSystem:chooseOption(index)
	local node = self:getCurrentNode()
	if not node or not node.options then return end

	local option = node.options[index]
	if not option then return end

	if option.callback then
		option.callback(self.npc, option, node)
	end

	if option.next then
		self.currentNode = option.next
		self.selectedOption = 1
	else
		self:stop()
	end
end

function DialogSystem:selectUp()
	local node = self:getCurrentNode()
	if not node or not node.options then return end

	self.selectedOption = self.selectedOption - 1

	if self.selectedOption < 1 then
		self.selectedOption = #node.options
	end
end

function DialogSystem:selectDown()
	local node = self:getCurrentNode()
	if not node or not node.options then return end

	self.selectedOption = self.selectedOption + 1

	if self.selectedOption > #node.options then
		self.selectedOption = 1
	end
end

function getNearestDialogNPC()
	local nearestNPC = nil
	local nearestDistance = 99999

	local lx, ly, lz = getElementPosition(localPlayer)
	local playerInterior = getElementInterior(localPlayer)
	local playerDimension = getElementDimension(localPlayer)

	for _, npc in ipairs(LoadedNPCDialogs_New) do
		if isElement(npc.element) then
			if getElementInterior(npc.element) == playerInterior and getElementDimension(npc.element) == playerDimension then
				local px, py, pz = getElementPosition(npc.element)
				local distance = getDistanceBetweenPoints3D(px, py, pz, lx, ly, lz)

				if distance <= (npc.interactDistance or 3) and distance < nearestDistance then
					nearestNPC = npc
					nearestDistance = distance
				end
			end
		end
	end

	return nearestNPC
end

addEventHandler("onClientRender", root, function()
	local sx, sy = guiGetScreenSize()

	if not DialogSystem.active then
		local nearNPC = getNearestDialogNPC()
		DialogSystem.nearNPC = nearNPC

		if nearNPC then
			bindDialogInteractKey()
		else
			unbindDialogInteractKey()
		end

		for _, npc in ipairs(LoadedNPCDialogs_New) do
			if isElement(npc.element) then
				local playerInterior = getElementInterior(localPlayer)
				local playerDimension = getElementDimension(localPlayer)

				if getElementInterior(npc.element) == playerInterior and getElementDimension(npc.element) == playerDimension then
					local px, py, pz = getElementPosition(npc.element)
					local lx, ly, lz = getElementPosition(localPlayer)

					if getDistanceBetweenPoints3D(px, py, pz, lx, ly, lz) <= (npc.interactDistance or 3) then
						local screenX, screenY = getScreenFromWorldPosition(px, py, pz + 1.15)

						if screenX and screenY then
							local interactText = getDialogLanguageText({
								["DE"] = "Drücke E zum Interagieren",
								["EN"] = "Press E to interact",
								["RU"] = "Нажмите E для взаимодействия",
								["PT"] = "Pressione E para interagir",
							})

							dxDrawText(interactText, screenX - 180, screenY - 24, screenX + 180, screenY + 20, tocolor(0, 0, 0, 220), 1.15, "default-bold", "center", "center")
							dxDrawText(interactText, screenX - 180, screenY - 26, screenX + 180, screenY + 18, tocolor(255, 255, 255, 255), 1.15, "default-bold", "center", "center")
						end
					end
				end
			end
		end
	else
		unbindDialogInteractKey()
	end

	if DialogSystem.active then
		local node = DialogSystem:getCurrentNode()
		if not node then return end

		local boxW, boxH = 780, 285
		local boxX, boxY = sx / 2 - boxW / 2, sy - boxH - 40

		dxDrawRectangle(boxX + 7, boxY + 7, boxW, boxH, tocolor(0, 0, 0, 130))
		dxDrawRectangle(boxX, boxY, boxW, boxH, tocolor(14, 14, 22, 240))

		dxDrawRectangle(boxX, boxY, boxW, 48, tocolor(225, 25, 25, 245))
		dxDrawRectangle(boxX, boxY + 48, boxW, 2, tocolor(220, 25, 25, 230))

		dxDrawText(
			getDialogLanguageText(node.title or DialogSystem.npc.name or "Dialog"),
			boxX + 24,
			boxY,
			boxX + boxW - 24,
			boxY + 48,
			tocolor(255, 255, 255, 255),
			1.25,
			"default-bold",
			"left",
			"center",
			false,
			false,
			false,
			true
		)

		dxDrawText(
			getDialogLanguageText(node.text or ""),
			boxX + 28,
			boxY + 68,
			boxX + boxW - 28,
			boxY + 130,
			tocolor(245, 245, 245, 255),
			1.08,
			"default-bold",
			"left",
			"top",
			true,
			true
		)

		if node.options then
			for i, option in ipairs(node.options) do
				local optX = boxX + 28
				local optY = boxY + 140 + (i - 1) * 37
				local optW = boxW - 56
				local optH = 31

				if i == DialogSystem.selectedOption then
					dxDrawRectangle(optX, optY, optW, optH, tocolor(220, 25, 25, 235))
					dxDrawRectangle(optX, optY, 4, optH, tocolor(220, 25, 25, 255))
					dxDrawText("➤", optX + 10, optY, optX + 35, optY + optH, tocolor(255,255,255), 1, "default-bold", "center", "center")
				else
					dxDrawRectangle(optX, optY, optW, optH, tocolor(35, 35, 48, 210))
				end

				dxDrawText(
					getDialogLanguageText(option.text),
					optX + 45,
					optY,
					optX + optW - 12,
					optY + optH,
					tocolor(255, 255, 255, 255),
					1,
					"default-bold",
					"left",
					"center"
				)
			end
		end

		local controlsText = getDialogLanguageText({
			["DE"] = "↑/↓ auswählen   ENTER/SPACE bestätigen   BACKSPACE schließen",
			["EN"] = "↑/↓ select   ENTER/SPACE confirm   BACKSPACE close",
			["RU"] = "↑/↓ выбрать   ENTER/SPACE подтвердить   BACKSPACE закрыть",
			["PT"] = "↑/↓ selecionar   ENTER/SPACE confirmar   BACKSPACE fechar",
		})

		dxDrawText(
			controlsText,
			boxX,
			boxY + boxH - 30,
			boxX + boxW,
			boxY + boxH - 8,
			tocolor(255,255,255, 255),
			0.85,
			"default",
			"center",
			"center"
		)
	end
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
	loadNPCDialogs_New()
end)

addEventHandler("onClientResourceStop", resourceRoot, function()
	unbindDialogInteractKey()
	unbindDialogControlKeys()

	if DialogSystem.active then
		showCursor(false)
		setCameraTarget(localPlayer)
	end
end)