WeaponSkills = {
	["AvailableSkills"] = {
		"deagleskills",
		"shotgunskills",
		"mp5skills",
		"m4skills",
	},
	["SkillStats"] = {
		["deagleskills"] = {
			69,
			70,
			71,
		},
		["shotgunskills"] = {
			72,
			73,
			74,
		},
		["mp5skills"] = {
			75,
			76,
		},
		["m4skills"] = {
			77,
			78,
			79,
		},
	},
}

function setPlayerWeaponSkills(player)
	for _,v in pairs(WeaponSkills["AvailableSkills"])do
		local stats_amount = 0
		if(tonumber(getPlayerData("character_stats","character_id",getCharacterID(player),v)) == 1)then
			stats_amount = 1000
		end
		
		for _,v in pairs(WeaponSkills["SkillStats"][v])do
			setPedStat(player,v,stats_amount)
		end
	end
end