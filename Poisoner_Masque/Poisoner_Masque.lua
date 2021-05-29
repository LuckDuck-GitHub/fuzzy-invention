local MSQ = LibStub("Masque", true)
local PoisonerEnabled = IsAddOnLoaded("Poisoner")
--if not MSQ or not PoisonerEnabled then return end

function Poisoner_Masque_OnLoad(self)
--	self:RegisterEvent("ADDON_LOADED")
	self:RegisterEvent("VARIABLES_LOADED")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
end

function Poisoner_Masque_OnEvent(self,event)
	if event == "VARIABLES_LOADED" then
		if MSQ and PoisonerEnabled then
			Poisoner_Masque_Init()
		end
	elseif event == "ADDON_LOADED" then
		--nothing
	elseif event == "PLAYER_ENTERING_WORLD" then
		if MSQ and PoisonerEnabled then
			Poisoner_Masque_Init()
		--	Poisoner_CreateButtons()	--Ensure that all available buttons are created
			--print("|cff00ff00Poisoner|r_|cff808080Masque|r loaded.")
		else
			print("|cff00ff00Poisoner|r_|cff808080Masque|r could NOT be loaded because Masque is not loaded/installed.")
		end
	end
end
--[[
function Poisoner_Masque_LoadDefault()
	Poisoner_Masque = {}
	Poisoner_Masque["Menu Buttons"] = {}
	Poisoner_Masque["Menu Buttons"]["SkinID"] = "Blizzard"
	Poisoner_Masque["QuickButton"] = {}
	Poisoner_Masque["QuickButton"]["SkinID"] = "Blizzard"
end

function Poisoner_Masque_CheckSavedVariables()
	if not Poisoner_Masque["Menu Buttons"] then
		Poisoner_Masque["Menu Buttons"] = {}
	end
	if not Poisoner_Masque["Menu Buttons"]["SkinID"] then
		Poisoner_Masque["Menu Buttons"]["SkinID"] = "Blizzard"
	end
	if not Poisoner_Masque["QuickButton"] then
		Poisoner_Masque["QuickButton"] = {}
	end
	if not Poisoner_Masque["QuickButton"]["SkinID"] then
		Poisoner_Masque["QuickButton"]["SkinID"] = "Blizzard"
	end
end
]]
--[[
function Poisoner_Masque_FindPoisons()
	local i, itemLink, bagSlots, bagId, icon, quantity;
	local ret = {};
	for i=0, 4 do
		itemLink = nil;
		bagSlots = GetContainerNumSlots(i);
		if (bagSlots > 0) then
			for j=1, bagSlots do
				itemLink = nil;
				itemLink = GetContainerItemLink(i, j);
				icon, quantity = GetContainerItemInfo(i, j)
				if (itemLink) then
					local itemId = nil;
					local itemName = nil;
					local itemRank = nil;
					local idx,pattern;
					for idx, pattern in ipairs(Poisoner_Patterns) do
						_, _, itemId, itemName, itemRank = string.find(itemLink, "item:(%d+).*%[("..pattern..")%]");
						if (itemName ~= nil) then
							break;
						end
					end
					
					if (itemName ~= nil) then
						-- if the quantity is 1, we either have a single consumable item, or an expendable item
						if (quantity == 1) then
							local charges = Poisoner_CountCharges(i, j);
							if (charges ~= nil) then
								quantity = charges;
							end
						end

						local t = ret[itemName];
						if (t == nil) then
							t = { name=itemName, icon=icon, quantity=0, rank=itemRank, id=itemId, bag=i, bagslot=j };
							ret[itemName] = t;
						end
						t.quantity = t.quantity + quantity;
						Poisoner_PoisonsEverSeen[itemName] = icon;
					end
				end
			end
		end
	end
	-- include zero counts for previously seen items we no longer have
	for prevItemName, prevIcon in pairs(Poisoner_PoisonsEverSeen) do
		local t = ret[prevItemName];
		if (t == nil) then
			t = { name=prevItemName, icon=prevIcon, quantity=0, bag=-1, bagslot=-1 };
			ret[prevItemName] = t;
		end
	end
	return ret;
end
]]

function Poisoner_Masque_Init()

--	print("Poisoner Masque Init")

	MSQ:Group("Poisoner", "Menu Buttons")
	MSQ:Group("Poisoner", "QuickButton")
	Poisoner_Masque_Initiated = true
--[[
    for _, t in pairs(Poisoner_Masque_FindPoisons()) do
		local tname = string.gsub(t.name, " ", "_");
		local btn = _G["PoisonerMenuButton__"..tname]
		if btn then
			MSQ:Group("Poisoner", "Menu Buttons"):AddButton(btn)
			print(btn:GetName())
		end
    end
	
	if POISONER_CONFIG then
		if POISONER_CONFIG.Poisons then
			for _, v in pairs(POISONER_CONFIG.Poisons) do
				if v ~= 0 then
					local name = string.gsub(v, " ", "_");
					local btn = _G["PoisonerMenuButton__"..name]
					if btn then
						MSQ:Group("Poisoner", "Menu Buttons"):AddButton(btn)
						print(btn:GetName())
					end
				end
			end
		end
	end
	
	local qb = _G["Poisoner_QuickButton"]
	if qb then
		MSQ:Group("Poisoner", "QuickButton"):AddButton(qb)
	end
	]]
	
	--[[
	local function Poisoner_Masque_SkinCallback(arg, SkinID, Gloss, Backdrop, Group, Button, Colors, ...)
		if not Group then
			Poisoner_Masque.SkinID = SkinID
			Poisoner_Masque.Gloss = Gloss
			Poisoner_Masque.Backdrop = Backdrop
			Poisoner_Masque.Colors = Colors
		else
			Poisoner_Masque[Group]["SkinID"] = SkinID
			Poisoner_Masque[Group]["Gloss"] = Gloss
			Poisoner_Masque[Group]["Backdrop"] = Backdrop
			Poisoner_Masque[Group]["Colors"] = Colors
		end
		if Poisoner_Masque["Menu Buttons"]["SkinID"] == "Blizzard" then
			for _, t in pairs(Poisoner_Masque_FindPoisons()) do
				local tname = string.gsub(t.name, " ", "_");
				local buttonName = "PoisonerMenuButton"..tname;
				local button = _G[buttonName];
				if (button ~= nil) then
					_G[buttonName.."Icon"]:ClearAllPoints()
					_G[buttonName.."Icon"]:SetPoint("CENTER",button,"CENTER",-0.5,-0.5)
				end
			end
		end
		if Poisoner_Masque["QuickButton"]["SkinID"] == "Blizzard" then
			Poisoner_QuickButtonIcon:ClearAllPoints()
			Poisoner_QuickButtonIcon:SetPoint("CENTER",Poisoner_QuickButton,"CENTER",-0.5,-0.5)
		end
	end
	
	MSQ:RegisterSkinCallback("Poisoner", Poisoner_Masque_SkinCallback, self)
	
	if Poisoner_Masque["Menu Buttons"]["SkinID"] == "Blizzard" then
		for _, t in pairs(Poisoner_Masque_FindPoisons()) do
			local tname = string.gsub(t.name, " ", "_");
			local buttonName = "PoisonerMenuButton"..tname;
			local button = _G[buttonName];
			if (button ~= nil) then
				_G[buttonName.."Icon"]:ClearAllPoints()
				_G[buttonName.."Icon"]:SetPoint("CENTER",button,"CENTER",-0.5,-0.5)
			end
		end
	end
	if Poisoner_Masque["QuickButton"]["SkinID"] == "Blizzard" then
		Poisoner_QuickButtonIcon:ClearAllPoints()
		Poisoner_QuickButtonIcon:SetPoint("CENTER",Poisoner_QuickButton,"CENTER",-0.5,-0.5)
	end
	]]
end

