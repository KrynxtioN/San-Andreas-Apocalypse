function getText(var)
	local language = apocalypseGetElementData(localPlayer,"language")
	if(not(language))then language = "EN" end
	if(Language["Languages"][language])then
		if(Language["Texts"][language])then
			return Language["Texts"][language][var]
		else
			return Language["Texts"]["EN"][var]
		end
	end
end