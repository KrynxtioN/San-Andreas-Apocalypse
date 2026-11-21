function loadPlayerClothes(player)
    if(getElementModel(player) == 0)then
        local characterID = getCharacterID(player)
        local clothesData = getPlayerData("characters", "ID", characterID, "clothes")

        for i = 0, 17 do
            local wstring = gettok(clothesData, i + 1, string.byte("|"))
            if(wstring and wstring ~= "")then
                local wstring1, wstring2 = wstring:match("([^,]+),([^,]+)")
                if(wstring1 and wstring2)then
                    addPedClothes(player, wstring1, wstring2, i)
                end
            end
        end
		
		setPedStat(player,21,apocalypseGetElementData(player,"player_fat"))
		setPedStat(player,23,apocalypseGetElementData(player,"player_muscles"))
    end
end

function savePlayerClothes(player)
    local clothesData = ""
    for i = 0, 17 do
        local clothesTexture, clothesModel = getPedClothes(player, i)
        clothesTexture = clothesTexture or "nil"
        clothesModel = clothesModel or "nil"
        clothesData = clothesData .. "|" .. clothesTexture .. "," .. clothesModel
    end
    clothesData = clothesData .. "|"
    dbExec(handler, "UPDATE characters SET clothes = ? WHERE ID = ?", clothesData, getCharacterID(player))
end