local languageData = {
	["English"] = "EN",
	["German"] = "DE",
	["Pусский"] = "RU",
	["Português"] = "PT",
}


local Text = {
	["English"] = "Your language was changed.",
	["German"] = "Deine Sprache wurde geändert.",
	["Pусский"] = "Ваш язык был изменен.",
	["Português"] = "Seu idioma foi alterado.",
}

function getText(player,var)
	local language = apocalypseGetElementData(player,"language")
	if(not(language))then language = "EN" end
	if(Language["Languages"][language])then
		if(Language["Texts"][language])then
			return Language["Texts"][language][var]
		else
			return Language["Texts"]["EN"][var]
		end
	end
end

function getTextOffline(language,var)
	if(Language["Languages"][language])then
		if(Language["Texts"][language])then
			return Language["Texts"][language][var]
		else
			return Language["Texts"]["EN"][var]
		end
	end
end

addEvent("changeLanguage",true)
addEventHandler("changeLanguage",root,function(language)
	if(language and isCharacterLoggedIn(client))then
		if(languageData[language])then
			apocalypseSetElementData(client,"language",languageData[language])
			createInfobox(client,Text[language])
		end
	end
end)