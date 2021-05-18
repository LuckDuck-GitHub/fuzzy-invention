Poisoner_Categories = {
	["DP"] = {
		2892,	--Tödliches Gift
		2893,	--Tödliches Gift II
		8984,	--Tödliches Gift III
		8985,	--Tödliches Gift IV
		20844,	--Tödliches Gift V
	},
	["CP"] = {
		3775,	--Verkrüppelndes Gift
		3776,	--Verkrüppelndes Gift II
	},
	["MP"] = {
		5237,	--Gedankenbenebelndes Gift
		6951,	--Gedankenbenebelndes Gift II
		9186,	--Gedankenbenebelndes Gift III
	},
	["IP"] = {
		6947,	--Sofort wirkendes Gift
		6949,	--Sofort wirkendes Gift II
		6950,	--Sofort wirkendes Gift III
		8926,	--Sofort wirkendes Gift IV
		8927,	--Sofort wirkendes Gift V
		8928,	--Sofort wirkendes Gift VI
	},
	["WP"] = {
		10918,	--Wundgift I
		10920,	--Wundgift II
		10921,	--Wundgift III
		10922,	--Wundgift IV
	},
	
	["SS"] = {
		2862,	--Rauer Wetzstein
		2863,	--Grober Wetzstein
		2871,	--Schwerer Wetzstein
		7964,	--Robuster Wetzstein
		12404,	--Verdichteter Wetzstein
	},
	["WS"] = {
		3239,	--Rauer Gewichtsstein
		3240,	--Grober Gewichtsstein
		3241,	--Schwerer Gewichtsstein
		7965,	--Robuster Gewichtsstein
		12643,	--Verdichteter Gewichtsstein
		18262,	--Elementarwetzstein
	},
	
	["HS"] = {
		--[6948] = "HS1",
	},
}

Poisoner_Patterns = {}
for n,t in pairs(Poisoner_Categories) do
	for i=1,#t do
		Poisoner_Patterns[t[i]] = n..i
	end
end

Poisoner_SpellIDs = {
	[2823] = "DP1",	--Tödliches Gift
	[2824] = "DP2",	--Tödliches Gift II
	[11355] = "DP3",	--Tödliches Gift III
	[11356] = "DP4",	--Tödliches Gift IV
	[25351] = "DP5",	--Tödliches Gift V

	[3408] = "CP1",	--Verkrüppelndes Gift
	[11202] = "CP2",	--Verkrüppelndes Gift II

	[5761] = "MP1",	--Gedankenbenebelndes Gift
	[8693] = "MP2",	--Gedankenbenebelndes Gift II
	[11399] = "MP3",	--Gedankenbenebelndes Gift III

	[8679] = "IP1",	--Sofort wirkendes Gift
	[8686] = "IP2",	--Sofort wirkendes Gift II
	[8688] = "IP3",	--Sofort wirkendes Gift III
	[11338] = "IP4",	--Sofort wirkendes Gift IV
	[11339] = "IP5",	--Sofort wirkendes Gift V
	[11340] = "IP6",	--Sofort wirkendes Gift VI

	[13219] = "WP1",	--Wundgift
	[13225] = "WP2",	--Wundgift II
	[13226] = "WP3",	--Wundgift III
	[13227] = "WP4",	--Wundgift IV
}

Poisoner_PoisonDropDownCats = {
	"",
	"CP",
	"MP",
	"DP",
	"IP",
	"WP",
}

Poisoner_PoisonDropDownIDs = {}
for k,v in pairs(Poisoner_PoisonDropDownCats) do
	Poisoner_PoisonDropDownIDs[v] = k
end

Poisoner_Skills = {
	["IP"] = {
		{	--1
			itemId = 6947,
			spellId = 8681,
			reqLevel = 20,
			reqSkill = 1,
			materials = {
				[2928] = 1,
				[3371] = 1,
			},
		},
		{	--2
			itemId = 6949,
			spellId = 8687,
			reqLevel = 28,
			reqSkill = 120,
			materials = {
				[2928] = 3,
				[3371] = 1,
			},
		},
		{	--3
			itemId = 6950,
			spellId = 8691,
			reqLevel = 36,
			reqSkill = 160,
			materials = {
				[8924] = 1,
				[3372] = 1,
			},
		},
		{	--4
			itemId = 8926,
			spellId = 11341,
			reqLevel = 44,
			reqSkill = 200,
			materials = {
				[8924] = 2,
				[8925] = 1,
			},
		},
		{	--5
			itemId = 8927,
			spellId = 11342,
			reqLevel = 52,
			reqSkill = 240,
			materials = {
				[8924] = 3,
				[3372] = 1,
			},
		},
		{	--6
			itemId = 8928,
			spellId = 11343,
			reqLevel = 60,
			reqSkill = 280,
			materials = {
				[8924] = 4,
				[3372] = 1,
			},
		},
	},
	
	--[[
	{
		spellId = ,
		reqLevel = ,
		reqSkill = ,
		materials = {
			[] = ,
			[] = ,
		},
	},
	]]
}