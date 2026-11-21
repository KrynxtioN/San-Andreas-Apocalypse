local Ranks = {
    ["EN"] = {"Novice", "Scout", "Forager", "Pathfinder", "Survivalist", "Tracker", "Survivor", "Outbacker", "Ranker", "Wilderness Expert", "Survival Master", "Nomad", "Veteran Survivalist", "Lone Wolf", "Elder", "Legend"},
    ["DE"] = {"Anfänger", "Späher", "Sammler", "Wegweiser", "Überlebenskünstler", "Spurensucher", "Überlebender", "Outbacker", "Ranglistener", "Wilderness-Experte", "Überlebensmeister", "Nomade", "Veteranen-Überlebenskünstler", "Einsamer Wolf", "Ältester", "Legende"},
	["RU"] = {"Новичок", "Разведчик", "Собиратель", "Проводник", "Выживальщик", "Следопыт", "Выживший", "Обитатель пустоши", "Составитель рейтингов", "Эксперт по дикой природе", "Мастер выживания", "Кочевник", "Ветеран выживания", "Одинокий волк", "Старейшина", "Легенда"},
	["PT"] = {"Iniciante", "Explorador", "Coletor", "Guiador", "Sobrevivente", "Rastreador", "Sobrevivente", "Viajante do deserto", "Classificador", "Especialista em vida selvagem", "Mestre em sobrevivência", "Nômade", "Sobrevivente veterano", "Lobo solitário", "Ancião", "Lenda"},
}

function setPlayerRank(player)
    local Level = tonumber(apocalypseGetElementData(player,"level"))
	local rankThresholds = {0, 5, 10, 25, 50, 75, 100, 125, 150, 200, 250, 400, 500, 550, 600, 1000}
    
    local Rank = 0
    for i = #rankThresholds, 1, -1 do
        if(Level >= rankThresholds[i])then
            Rank = i - 1
            break
        end
    end
    
    local language = apocalypseGetElementData(player,"language") or "EN"
    apocalypseSetElementData(player,"rankname",Ranks[language][Rank + 1])
    apocalypseSetElementData(player,"rank",Rank)
end