-- Update by Silentdave (Ravegrobber - Kul'Tiras EU), humfras
-- Due to various XML attribute changes in 3.0, the auto show and timer controlled hide of the PoisonerMenu no longer works. 
-- Thus added OnMouseUp to Minimapbutton in the XML file to toggle PoisonerMenu showing/hiding (linked to PoisonerMenu_Toggle() in this file
local MSQ = LibStub("Masque", true)
local player_entered_world = false


local locale = GetLocale()
local ENRAGE
if (locale == "enUS") then
	ENRAGE = "Enrage"
elseif (locale == "deDE") then
	ENRAGE = "Wut"
elseif (locale == "esES") then
	ENRAGE = "Enfurecer"
elseif (locale == "frFR") then
	ENRAGE = "Enrager"
elseif (locale == "ruRU") then
	ENRAGE = "Исступление"
else
	ENRAGE = "Enrage"
end

local _, cls = UnitClass("player");

local PBT = CreateFrame("GameTooltip","PoisonerBuffTooltip", nil, "GameTooltipTemplate")
local function ResetTooltip()
	PBT:Hide()
	PBT:SetOwner(WorldFrame, "ANCHOR_NONE")
	PBT:ClearLines()
end
-- store original versions of API calls
local old_UnitBuff = UnitBuff
local old_UnitAura = UnitAura

-- OnLoad event
function Poisoner_OnLoad(self)
	-- register for clicks
	--self:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	--self:RegisterForDrag("LeftButton");
	-- need this for the initial load
	self:RegisterEvent("ADDON_LOADED");
	self:RegisterEvent("PLAYER_ENTERING_WORLD");
	self:RegisterEvent("PLAYER_REGEN_DISABLED");
	self:RegisterEvent("PLAYER_REGEN_ENABLED");
	self:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED");
	self:RegisterEvent("BAG_UPDATE");
      -- register a slash command
        SLASH_POISONER1 = "/poisoner";
        SlashCmdList["POISONER"] = function(msg)
                Poisoner_ProcessCommand(msg);
        end;
	Poisoner_PrintDebug = false
	
	Poisoner_QuickButtonVisible = 0;
	
	StaticPopupDialogs["POISONER_QUESTION_ENABLE"] = {
		preferredIndex = STATICPOPUP_NUMDIALOGS,
		text = ""..POISONER_TITLE..":\n "..POISONER_NOTAROGUE.."",
		button1 = YES,
		button3 = NO,
		button2 = DISABLE,
		OnAccept = function() Poisoner_Enable() end,
		OnAlt = function () end,
		OnCancel = function() Poisoner_Disable() end,
		timeout = 0,
		whileDead = 0,
		hideOnEscape = 1
	}
	
	StaticPopupDialogs["POISONER_STARTED_ONCE"] = {
		preferredIndex = STATICPOPUP_NUMDIALOGS,
		text = ""..POISONER_TITLE.."\n"..OPTION_RESTART_REQUIREMENT.."",
		button1 = OKAY,
		button2 = CANCEL,
		OnAccept = function() Poisoner_RestartOnce() end,
		timeout = 0,
		whileDead = 0,
		hideOnEscape = 1
	}
	
	StaticPopupDialogs["POISONER_WELCOME_TO_V4"] = {
		preferredIndex = STATICPOPUP_NUMDIALOGS,
		text = ""..POISONER_WELCOME4.."",
		button1 = OKAY,
		timeout = 0,
		whileDead = 0,
		hideOnEscape = 1
	}
	
	Poisoner_Debug("Poisoner Loaded");

	-- hook API functions
	UnitBuff = Poisoner_UnitBuff
	
end

function Poisoner_OnEvent(self, event, ...)
	if (event == "ADDON_LOADED") then
		local arg1 = ...
		if not arg1 == "Poisoner" then return end
		PoisonerOptions_CheckDB()
		Poisoner_OnVariablesLoaded(self);
	elseif (event == "PLAYER_ENTERING_WORLD") then
		PoisonerOptions_CheckDB()
		player_entered_world = true
		local PoisonerMasque = IsAddOnLoaded("Poisoner_Masque")
		if PoisonerMasque and not Poisoner_Masque_Initiated then
			Poisoner_Masque_Init()
		end
		Poisoner_SetupPoisonSlots()
		Poisoner_CreateButtons()
		Poisoner_CheckQuickButton()
	elseif (event == "PLAYER_REGEN_DISABLED") then
		Poisoner_OnEnterCombat();
	elseif (event == "PLAYER_REGEN_ENABLED") then
		Poisoner_OnLeaveCombat();
	elseif event == "UNIT_SPELLCAST_INTERRUPTED" then
		Poisoner_UNIT_SPELLCAST_INTERRUPTED(...)
	elseif event == "BAG_UPDATE" then
		if not Poisoner_MerchantIsShown then return end
		Poisoner_ReCountPoisons()
	end
end

function Poisoner_OnVariablesLoaded(self)
	if (POISONER_CONFIG == nil) then
		POISONER_CONFIG = {};
		local _, cls = UnitClass("player");
		if (cls == "ROGUE") then
			POISONER_CONFIG.Enabled = 1;
		elseif not (cls == "ROGUE") then
			StaticPopup_Show("POISONER_QUESTION_ENABLE");
		end
	end
	if ( not POISONER_CONFIG.Enabled ) then
		local _, cls = UnitClass("player");
		if (cls == "ROGUE") then
			POISONER_CONFIG.Enabled = 1;
		elseif not (cls == "ROGUE") then
			StaticPopup_Show("POISONER_QUESTION_ENABLE");
		end
	end
	if ( not POISONER_CONFIG.StartedOnce ) then
		POISONER_CONFIG.StartedOnce = 0;
	end
	if (POISONER_CONFIG.StartedOnce == 0) and (POISONER_CONFIG.Enabled == 1) then
	--	Poisoner_GetPoisonNames();
	--	StaticPopup_Show("POISONER_STARTED_ONCE");
	end
	Poisoner_GetPoisonNames();
	
	if (POISONER_CONFIG.Menu.Scale ~= nil) then
		PoisonerMenu:SetScale(POISONER_CONFIG.Menu.Scale);
	end
	Poisoner_SetPosition(POISONER_CONFIG.Menu.Position or "bottomleft");
	
	if (POISONER_CONFIG.Enabled == 1) then
		PoisonerStateHeader:Show();
		if (POISONER_CONFIG.Buttons.FreeButton.Active == 1) then
			Poisoner_FreeButton:Show();
		elseif (POISONER_CONFIG.Buttons.FreeButton.Active == 0) then
			Poisoner_FreeButton:Hide();
		end
	else
		PoisonerStateHeader:Hide();
		Poisoner_FreeButton:Hide();
	end
	
	PoisonerStateHeader.inCombat = false;
	PoisonerStateHeader:SetAttribute("state", "0");
	self:UnregisterEvent("ADDON_LOADED");
end

function Poisoner_CheckBuff(name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellID, canApplyAura, isBossDebuff, ...)
	-- this is the only one we need specifically, but all may be needed by Enrage-checking code below
	local uid = select(1,...)
	
	-- if unitbuff/unitaura is being called on a unit that isn't target or focus, ignore it and return default data
	if (uid ~= "target" and uid ~= "focus") then
		return name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellID, canApplyAura, isBossDebuff
	end

	-- if we have borders enabled for this unit type, this class can dispel enemy buffs in general, and the unit is an enemy
	if (((uid == "target") or (uid == "focus")) and cls == "ROGUE" and (UnitIsEnemy("player", uid) or UnitCanAttack("player", uid))) then
		-- check for valid dispellable buff
		
		-- check for Enrage buffs (but only if there is no "known" debuffType and the player can even dispel them)
		-- if it is, change the "debuffType" so 1: our type-checking code is simpler and 2: other addons could potentially get this info (?)
		if (debuffType == "") then
			ResetTooltip()
			PBT:SetUnitBuff(...) -- pass exact UnitBuff/UnitAura parameters to SetUnitBuff to make things easier
			if (PoisonerBuffTooltipTextRight1:GetText() == ENRAGE_STRING) then
				debuffType = "Enrage"
			end
		end

		-- if we can dispel it
		if (debuffType == "Enrage") then
			-- give it a border
			isStealable = 1
		--	print(uid.." has ENRAGE "..name)
		end
	end

	-- return all parameters (debuffType, unitCaster, and isStealable are potentially modified)
	return name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellID, canApplyAura, isBossDebuff
end

-- API hook
-- modified in 1.3.9 to work with (unit, spellname, spellrank, filter) in addition to (unit, index, filter)
function Poisoner_UnitBuff(...)
	-- get default stuff
	local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellID, canApplyAura, isBossDebuff  = old_UnitBuff(...)

	-- if unitbuff is being called on a unit that isn't target or focus, ignore it and return default data
	local uid = select(1,...)
	if (uid ~= "target" and uid ~= "focus") then
		return name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellID, canApplyAura, isBossDebuff
	end

	-- check actual buff info and return potentially modified info based on if we can dispel or not
	return Poisoner_CheckBuff(name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellID, canApplyAura, isBossDebuff, ...)
end

-- Restart once to update locales in SavedVariables
function Poisoner_RestartOnce()
--	Poisoner_GetPoisonNames();
	POISONER_CONFIG.StartedOnce = 1;
	ReloadUI();
end

-- when entering combat we need to pregenerate the buttons, as that cannot be done during lockdown
function Poisoner_OnEnterCombat()
	Poisoner_Debug("entering combat");
	PoisonerOptions_SettingsFrame:Hide();
	if ( POISONER_CONFIG.Menu.AutoHide.inCombat == 1 ) then
		PoisonerMenu:Hide();
	end
	PoisonerStateHeader.poisonCount = Poisoner_FindPoisons();
	Poisoner_CreateButtons();
	PoisonerStateHeader.inCombat = true;
end

function Poisoner_OnLeaveCombat()
	Poisoner_Debug("leaving combat");
	PoisonerStateHeader.inCombat = false;
	if PoisonerStateHeader.needUpdate then
		Poisoner_CreateButtons();
		Poisoner_CheckQuickButton(PoisonerStateHeader.forceUpdate);
		Poisoner_SecureHandler:LoadMenu();
		PoisonerStateHeader.needUpdate = false;
		PoisonerStateHeader.forceUpdate = false;
	end
end

local checking = {}
function Poisoner_GetPoisonNames()

	--[[POISONER_CONFIG.Poisons = { 
		CPName = GetItemInfo(3775);	--Verkrüppelndes Gift
		MPName = GetItemInfo(5237);	--Gedankenbenebelndes Gift
		DPName = GetItemInfo(2892);	--Tödliches Gift
		IPName = GetItemInfo(6947);	--Sofort wirkendes Gift
		WPName = GetItemInfo(10918);	--Wundgift
	}]]
	--[[
	if not POISONER_CONFIG.Poisons.CPName or POISONER_CONFIG.Poisons.CPName == nil then --Verkrüppelndes Gift
		POISONER_CONFIG.Poisons.CPName = GetItemInfo(3775);
	end
	if not POISONER_CONFIG.Poisons.MPName or POISONER_CONFIG.Poisons.MPName == nil then --Gedankenbenebelndes Gift
		POISONER_CONFIG.Poisons.MPName = GetItemInfo(5237);
	end
	if not POISONER_CONFIG.Poisons.DPName or POISONER_CONFIG.Poisons.DPName == nil then --Tödliches Gift
		POISONER_CONFIG.Poisons.DPName = GetItemInfo(2892);
	end
	if not POISONER_CONFIG.Poisons.IPName or POISONER_CONFIG.Poisons.IPName == nil then --Sofort wirkendes Gift
		POISONER_CONFIG.Poisons.IPName = GetItemInfo(6947);
	end
	if not POISONER_CONFIG.Poisons.WPName or POISONER_CONFIG.Poisons.WPName == nil then --Wundgift
		POISONER_CONFIG.Poisons.WPName = GetItemInfo(10918);
	end
	]]
	--[[
	POISONER_CONFIG.Poisons.CPName = nil
	POISONER_CONFIG.Poisons.MPName = nil
	POISONER_CONFIG.Poisons.DPName = nil
	POISONER_CONFIG.Poisons.IPName = nil
	POISONER_CONFIG.Poisons.WPName = nil
	]]
	
	local reqReload
	local nilcount = 0
	
	if not POISONER_CONFIG.Poisons then POISONER_CONFIG.Poisons = {} end
	
	for k,v in pairs(POISONER_CONFIG.Poisons) do
		if not tonumber(k) then
			POISONER_CONFIG.Poisons[k] = nil
		end
	end
	
	for itemID,sn in pairs(Poisoner_Patterns) do
		
		if not POISONER_CONFIG.Poisons[itemID] then
			reqReload = true
			--print("Looking for",itemID,POISONER_CONFIG.Poisons[itemID])
			local itemName, _, _, _, _, _, _, _, _, itemIcon = GetItemInfo(itemID)
			
			if not itemName then
				if not checking[itemID] then 
					checking[itemID] = true
					nilcount = nilcount + 1
					local item = Item:CreateFromItemID(itemID)
					item:ContinueOnItemLoad(function()
						local itemName, _, _, _, _, _, _, _, _, itemIcon = GetItemInfo(itemID)
						--print(itemLink)
						POISONER_CONFIG.Poisons[itemID] = {
							Name = itemName,
							Texture = itemIcon
						}
						checking[itemID] = nil
						nilcount = nilcount - 1
						if nilcount <=0 then
							StaticPopup_Show("POISONER_STARTED_ONCE")
						end
					end)
				end
			else
				POISONER_CONFIG.Poisons[itemID] = {
					Name = itemName,
					Texture = itemIcon
				}
			end
		
		end
	end
	
	-- fix CP1 texture to use CP2 texture instead of WP texture
	if POISONER_CONFIG.Poisons[3775] then
		POISONER_CONFIG.Poisons[3775].Texture = 134799
	end
end

function Poisoner_SetupPoisonSlots()

	local weapon, id, modifier
	
	for modifier,pt in pairs(POISONER_CONFIG.Preset) do
	
		if type(pt) == "table" then
		
			for buttonId = 1,2 do
		
				local weapon = buttonId==2 and "Offhand" or "Mainhand"
				
				local id = pt[weapon]
				
				local itemId = PoisonerDropDown_GetBaseItemId(id)
				local t = POISONER_CONFIG.Poisons[itemId]
				local itemName = t and t.Name or ""
				
				Poisoner_PoisonSlots[buttonId][modifier] = {
					Name = itemName,
					Id = itemId,
					Texture = t and t.Texture or "",
					MacroText = Poisoner_CreateFullItemMacroString(id, buttonId, modifer~="Normal" and string.lower(modifier) or nil)
				}
				
			end
			
		end
	
	end
	
end

--Check for interrupted/failed spell cast with the registered poisons
function Poisoner_UNIT_SPELLCAST_INTERRUPTED(unit,lineID,SpellID)
	local id = Poisoner_SpellIDs[SpellID]
	if not id then return end
--	print("UNIT_SPELLCAST_INTERRUPTED")	--DEBUG
--	print(...)	--DEBUG
	PoisonerStateHeader.poisonCount = Poisoner_FindPoisons()
	local button = _G["PoisonerMenuButton__"..id]
	if button then
		button.needUpdate = true
		Poisoner_OnItemButtonUpdate(button)
	end
end

function Poisoner_ReCountPoisons()
	PoisonerStateHeader.poisonCount = Poisoner_FindPoisons()
--[[	if (not PoisonerStateHeader.inCombat) then
		Poisoner_CreateButtons()
	else]]
		for k,v in pairs(Poisoner_Patterns) do
		--	print(k,v)
			
			local tname = v
			local buttonName = "PoisonerMenuButton__"..tname;
			local button = _G[buttonName];
			
			if button and button:IsShown() then
				button.needUpdate = true
				Poisoner_OnItemButtonUpdate(button)
			end
			
		end
	--end
end

function Poisoner_OnItemButtonUpdate(button, elapsed)
	if not elapsed or elapsed == nil then elapsed = 2 end
	button.elapsed = button.elapsed + elapsed;
	if (button.needUpdate or button.elapsed > button.updateDelay) then
		-- find the current poison count for this button
		local itemName = button:GetAttribute("id")	--local _, _, itemName = string.find(button:GetName(), "^PoisonerMenuButton(.*)$");
		local count, rank;
		if (PoisonerStateHeader.poisonCount) then
			local rec = PoisonerStateHeader.poisonCount[itemName];
			if (rec) then
				count = rec.quantity;
				rank = rec.rank;
			end
		end
		
		-- and display it
		-- local cbutton = _G[button:GetName()];
		if (count and count > 0) then
			button:SetText(""..count);
			button:GetNormalTexture():SetVertexColor(1,1,1,1);
		else
			button:SetText("0");
			button:GetNormalTexture():SetVertexColor(0.5,0.5,0.5,1);
			button:GetHighlightTexture():SetVertexColor(0.5,0.5,0.5,1);
		end
		button.elapsed = 0;
		button.needUpdate = false;
	end
	--[[
	if (Poisoner_QuickButtonVisible == 1) then
		Poisoner_CheckQuickButton()
	end
	]]
end

function Poisoner_OnMenuShow()
	--print("Poisoner OnMenuShow")
	-- find the current number of poisons available
	PoisonerStateHeader.poisonCount = Poisoner_FindPoisons();
	if (not PoisonerStateHeader.inCombat) then
		-- generate the appropriate buttons
		Poisoner_CreateButtons();
		if ( POISONER_CONFIG.Menu.AutoHide.Active == 1 ) then
			local d=POISONER_CONFIG.Menu.AutoHide.Time;
			local u=GetTime()+d;
			local t=u;
			local frame = Poisoner_FreeButton
			frame:SetScript("OnUpdate",function() if GetTime()>=t then PoisonerMenu:Hide();t=nil;frame:SetScript("OnUpdate",nil)end end)
		end
    end
	for _, t in pairs(Poisoner_FindPoisons()) do
	--	local tname = string.gsub(t.name, " ", "_")
		local tname = t.shortname
		local buttonName = "PoisonerMenuButton__"..tname;
		local button = _G[buttonName];
		if button ~= nil then
			Poisoner_OnItemButtonUpdate(button, 2)
		end
	end
end

function Poisoner_OnItemButtonClick(button, click)
	local itemName = button:GetAttribute("name")	--local _, _, itemName = string.find(button:GetName(), "^PoisonerMenuButton(.*)$");
	local itemId = button:GetAttribute("id")
	if (not SpellCanTargetItem()) then
		-- Poison is applying, decrement the count
		if (PoisonerStateHeader.poisonCount) then
			local rec = PoisonerStateHeader.poisonCount[itemName];
			if (rec) then
				rec.quantity = rec.quantity - 1;
			end
		end
	else
		-- still targetting, the box was displayed
		-- TODO: need to clear the cursor here somehow
	end
	button.needUpdate = true;
	
		local isModifier = IsModifierKeyDown();
		local modifier = (IsShiftKeyDown() and "Shift" or "")..(IsControlKeyDown() and "Ctrl" or "")..(IsAltKeyDown() and "Alt" or "")
		
		--print("Poisoner: "..modifier)	--Debug
				local COLOR_GREEN = "|cff00ff00";
				local COLOR_END = "|r";
	
				if ( click=="LeftButton" ) then
						local weaponID = GetInventoryItemID("player", 16)
						local weaponName, _, weaponRarity
						if weaponID then
							weaponName, _, weaponRarity = GetItemInfo(weaponID)
						else
							weaponName, weaponRarity = "", 1
						end
						local color
						if (weaponRarity == 2) then color = "|cff1eff00"
						elseif (weaponRarity == 3) then color = "|cff0070dd"
						elseif (weaponRarity == 4) then color = "|cffa335ee"
						elseif (weaponRarity == 5) then color = "|cffff8000"
						elseif (weaponRarity == 6) or (weaponRarity == 7) then color = "|cffe6cc80"
						else color = "|cffffffff"
						end
					if ( POISONER_CONFIG.Preset.Overwrite == 1 ) then
						local slot
						if ( not isModifier ) then
							slot = 1
						elseif ( modifier == "Shift" ) then
							slot = 2
						elseif ( modifier == "Ctrl" ) then
							slot = 3
						elseif ( modifier == "Alt" ) then
							slot = 4
						end
						if slot then
							Poisoner_UpdatePoisonSlots(slot, itemName, itemId, modifier)
						end
					elseif ( POISONER_CONFIG.Preset.Overwrite == 0 ) --[[and ( isModifier ~= 1 )]] then
						modifier = "";
					end
					--if ( isModifier ~= 1 ) or ( ( isModifier == 1 ) and ( POISONER_CONFIG.Preset.Overwrite == 1 ) ) then
					if ( POISONER_CONFIG.PrintClickedPoison == 1 ) then
						print(""..INVTYPE_WEAPONMAINHAND.." "..modifier..": "..color..weaponName.."|r > "..COLOR_GREEN..itemName..COLOR_END)
					end
					--end
				elseif ( click=="RightButton" ) then
						local weaponID = GetInventoryItemID("player", 17)
						local weaponName, _, weaponRarity
						if weaponID then
							weaponName, _, weaponRarity = GetItemInfo(weaponID)
						else
							weaponName, weaponRarity = "", 1
						end
						local color
						if (weaponRarity == 2) then color = "|cff1eff00"
						elseif (weaponRarity == 3) then color = "|cff0070dd"
						elseif (weaponRarity == 4) then color = "|cffa335ee"
						elseif (weaponRarity == 5) then color = "|cffff8000"
						elseif (weaponRarity == 6) or (weaponRarity == 7) then color = "|cffe6cc80"
						else color = "|cffffffff"
						end
					if ( POISONER_CONFIG.Preset.Overwrite == 1 ) then
						local slot
						if ( not isModifier ) then
							slot = 5
						elseif ( modifier == "Shift" ) then
							slot = 6
						elseif ( modifier == "Ctrl" ) then
							slot = 7
						elseif ( modifier == "Alt" ) then
							slot = 8
						end
						if slot then
							Poisoner_UpdatePoisonSlots(slot, itemName, itemId, modifier)
						end
					elseif ( POISONER_CONFIG.Preset.Overwrite == 0 ) --[[and ( isModifier ~= 1 )]] then
						modifier = "";
					end
					if ( POISONER_CONFIG.PrintClickedPoison == 1 ) then
						print(""..INVTYPE_WEAPONOFFHAND.." "..modifier..": "..color..weaponName.."|r > "..COLOR_GREEN..itemName..COLOR_END)
					end
				else
				--	print("No click registered")
				end
				
				
	
	if InCombatLockdown() then
		PoisonerStateHeader.needUpdate = true
	else
		Poisoner_CheckQuickButton();
	end
	
end

function Poisoner_UpdatePoisonSlots(id, itemName, itemId, modifier)

	--_G["Poisoner_PoisonSlotFrame"..id]:SetAttribute("Text",itemName)
	
	local buttonId = id > 4 and 2 or 1
	
	if id==1 or id==5 then
		modifier = "Normal"
	else
		modifier = string.upper(modifier)
	end
	
	Poisoner_PoisonSlots[buttonId][modifier] = {
		Name = itemName,
		Id = itemId,
		Texture = POISONER_CONFIG.Poisons[itemId].Texture or "",
	}
	
	--Poisoner_SecureHandler:LoadMenu()
	
end

function Poisoner_ShowTooltip(self)
--	print("Poisoner_ShowTooltip")
--	print(self:GetName())
--[[	for _, t in pairs(Poisoner_FindPoisons()) do
		if t.name == self.Name then
		--	print("t.Name == self.Name")
			Poisoner_Tooltip(self,t.bag,t.bagslot,t.name)
		end
	end]]
	Poisoner_Tooltip(self,self.Bag or self.Link,self.Bagslot,self.Name)
end
function Poisoner_HideTooltip(self, ...)
--	print("Poisoner_HideTooltip")
--	print(self:GetName())
	GameTooltip:Hide()
end
function Poisoner_PostClick(self, button)
--	print("Poisoner_PostClick")
--	print(self:GetName())
--	print(button)
	Poisoner_OnItemButtonClick(self, button);
end

-- This function creates/initialises the individual buttons for each poison
-- type. Note that we re-use buttons if they had been previously created, as
-- there is no delete operation for frames.
function Poisoner_CreateButtons()
--	Poisoner_SecureHandler:LoadMenu()
	local menu = PoisonerMenu;
	--[[
	local i = 0;
	Poisoner_Debug("Children of PoisonerMenu:")
	local children = { menu:GetChildren() };
	for _, child in ipairs(children) do
		Poisoner_Debug(child:GetName());
		i = i+1;
	end
	Poisoner_Debug(i.." children");
	]]
	local x
	x = POISONER_CONFIG.Menu.Spacing
	local firstButton = true
	local previousButton
	local buttonframewidth = 0
	for _, t in pairs(Poisoner_FindPoisons()) do
	--	local tname = string.gsub(t.name, " ", "_")
		local tname = t.shortname
		local buttonName = "PoisonerMenuButton__"..tname;
		local button = _G[buttonName];
		local securebuttonName = "PoisonerSecureButton__"..tname;
		local securebutton = _G[securebuttonName];
		if (not PoisonerStateHeader.inCombat) then
			if (button == nil) then
				
				button = CreateFrame("Button", buttonName, menu, "PoisonerItemButtonTemplate")
				button:SetHeight(36)
				button:SetWidth(36)
				button:ClearAllPoints();
				button:SetPoint("CENTER",UIParent,"CENTER");
				
				if _G["Poisoner_MenuOverlay"] then
					button:SetFrameLevel(Poisoner_MenuOverlay:GetFrameLevel()+1)
				else
					button:SetFrameLevel(menu:GetFrameLevel()+2)
				end
				
				button:RegisterForClicks("AnyDown");
				
				button.ShowTooltip = Poisoner_ShowTooltip--Poisoner_Tooltip(button,t.bag,t.bagslot,t.name)
				button.HideTooltip = Poisoner_HideTooltip
				button.PostClick = Poisoner_PostClick--Poisoner_OnItemButtonClick
				button.OnItemButtonUpdate = Poisoner_OnItemButtonUpdate
				
				local bfs = button:CreateFontString(buttonName.."Text","OVERLAY","GameFontNormal");
				bfs:SetPoint("BOTTOMRIGHT");
				bfs:SetTextColor(1,1,1,1);
				bfs:SetShadowColor(0,0,0,1);
				bfs:SetShadowOffset(-2,2);
				button:SetFontString(bfs);
				
				local icon = _G[buttonName.."Icon"];
				icon:SetTexture(t.icon);
				
				-- hide button border
				button.NormalTexture:SetTexture(nil)
				
				button.elapsed = 0;
				button.updateDelay = 2;
				button.needUpdate = false;
				button.Name = t.name
			--	button.Bag = t.bag
			--	button.Bagslot = t.bagslot
				button.Link = t.link
				
				button:SetAttribute("name", t.name);
				button:SetAttribute("id", t.id);
				button:SetAttribute("type", "macro");
				button:SetAttribute("macrotext", "/use "..t.name.."\n/use [button:2] 17\n/click [button:2] "..securebuttonName.." RightButton\n/use [button:1] 16\n/click [button:1] "..securebuttonName.." LeftButton\n/click StaticPopup1Button1\n/click Poisoner_FreeButton MiddleButton");
				
			--	button:SetAttribute("_onshow", [[ print(self:GetName().." _onshow")]])
			--	button:SetAttribute("_onhide", [[ print(self:GetName().." _onhide")]])
				button:SetAttribute("_onenter", [=[
					--print(self:GetName().." _onenter")
					menu, psf = self:GetFrameRef("frame1"), self:GetFrameRef("PoisonSlotFrame");
					
					local som = psf:GetAttribute("showmouseover")
					
					if som then
						menu:Show();
					end
					
					control:CallMethod("ShowTooltip")
					
				]=])
				button:SetAttribute("_onleave", [=[
					--print(self:GetName().." _onleave")
					menu, psf = self:GetFrameRef("frame1"), self:GetFrameRef("PoisonSlotFrame");
					
					local som = psf:GetAttribute("showmouseover")
					
					if som then
						menu:Hide();
					end
					
					control:CallMethod("HideTooltip")
					
				]=])
				button:WrapScript(button, "PostClick", [=[
					control:CallMethod("PostClick", button)
					control:CallMethod("OnItemButtonUpdate", 1)
				]=])
				
				button:SetFrameRef("frame1", PoisonerMenu);
				button:SetFrameRef("PoisonSlotFrame", Poisoner_PoisonSlotFrame);
				
				--Masque/ButtonFacade
				if MSQ and Poisoner_Masque_Initiated == true then
					--Poisoner_Masque_Init()
					--print(button:GetName())
					local msqbtnGroup = MSQ:Group("Poisoner", "Menu Buttons")
					msqbtnGroup:AddButton(button)
					msqbtnGroup:ReSkin()
				end				
				
			end
			if (securebutton == nil) then
				
				securebutton = CreateFrame("BUTTON", securebuttonName, UIParent, "SecureHandlerClickTemplate, SecureHandlerBaseTemplate");
				securebutton:ClearAllPoints();
				securebutton:SetPoint("BOTTOMLEFT",PoisonerStateHeader,"TOPRIGHT");
				
				securebutton:SetAttribute("_onclick", [=[
					local left, right = button == "LeftButton", button == "RightButton"
					local fb, psf = self:GetFrameRef("FreeButton"), self:GetFrameRef("PoisonSlotFrame");
					local qb = self:GetFrameRef("QuickButton")
					local shift, ctrl, alt = IsShiftKeyDown(), IsControlKeyDown(), IsAltKeyDown();
					
					local poison = self:GetAttribute("id")
					--print(self:GetName().." _onclick")
					--print("Poison: "..poison)
					
					local id
					if left then
						if (not shift and not ctrl and not alt) then
							--print("Left Click")
							id = 1
						elseif shift then
							--print("Left Shift Click")
							id = 2
						elseif ctrl then
							--print("Left Ctrl Click")
							id = 3
						elseif alt then
							--print("Left Alt Click")
							id = 4
						end
					elseif right then
						if (not shift and not ctrl and not alt) then
							--print("Right Click")
							id = 5
						elseif shift then
							--print("Right Shift Click")
							id = 6
						elseif ctrl then
							--print("Right Ctrl Click")
							id = 7
						elseif alt then
							--print("Right Alt Click")
							id = 8
						end
					end
					
					local overwrite = psf:GetAttribute("overwrite")
					if id and overwrite then
						psf:SetAttribute("Text"..id, poison)
						qb:SetAttribute("Text"..id, poison)
					end
					
				]=]);
				
				securebutton:RegisterForClicks("AnyDown");
				securebutton:SetAttribute("name", t.name);
				securebutton:SetAttribute("id", t.id);
				securebutton:SetFrameRef("FreeButton", Poisoner_FreeButton);
				securebutton:SetFrameRef("PoisonSlotFrame", Poisoner_PoisonSlotFrame);
				securebutton:SetFrameRef("QuickButton", Poisoner_QuickButton);
				
			end
			button:Hide();
			button:ClearAllPoints();			
			if (t.quantity and t.quantity>0) then
				button.Name = t.name
			--	button.Bag = t.bag
			--	button.Bagslot = t.bagslot
				
			--	Poisoner_AnchorButton(button, previousButton)
			--	previousButton = button;
				buttonframewidth = buttonframewidth + POISONER_CONFIG.Menu.Spacing + button:GetWidth()
				button:Show();
			else
				--	print("Button hidden: "..button:GetName()) --debug
			end
			button.needUpdate = true;
		end
	end
	if (POISONER_CONFIG.Menu.Position == "top") or (POISONER_CONFIG.Menu.Position == "bottom") then
		PoisonerMenu:SetWidth(36)
		PoisonerMenu:SetHeight(buttonframewidth)
	else
		PoisonerMenu:SetWidth(buttonframewidth)
		PoisonerMenu:SetHeight(36)
	end
	Poisoner_SortButtons()
	
	Poisoner_SecureHandler:LoadMenu()
	
	--[[local testbuttonName = PoisonerTestButton;
	if (testbutton == nil) then
	testbutton = CreateFrame("Button", "PoisonerTestButton", menu, "PoisonerItemButtonTemplate2");

				testbutton:SetNormalTexture("Interface\\Icons\\Spell_Nature_Reincarnation");
				testbutton:SetHighlightTexture("Interface\\Icons\\Spell_Nature_Reincarnation");
				testbutton:GetNormalTexture():SetVertexColor(1,1,1,1);
				testbutton:GetHighlightTexture():SetVertexColor(0.5,0.5,1,1);

				testbutton:SetAttribute("type", "macro");
				testbutton:SetAttribute("macrotext", "/use Sofort wirkendes Gift IX\n/use [button:2] 17\n/use [button:1] 16\n/click StaticPopup1Button1\n/say Poisoner TEST");
				
			--testbutton:Hide();
			testbutton:ClearAllPoints();
			testbutton:Show();
			if (POISONER_CONFIG.Menu.Position == "right") then
				testbutton:SetPoint("TOPLEFT", x, 0);
				x = x + button:GetWidth() + 4;
			else
				testbutton:SetPoint("TOPRIGHT", x, 0);
				x = x - button:GetWidth() - 4;
			end
			testbutton:Show();
	
	end
	]]
end


function Poisoner_SortButtons()
	if PoisonerStateHeader.inCombat then PoisonerStateHeader.needUpdate = true; return end

	local prevbutton = nil
	
--	for k,v in ipairs(POISONER_CONFIG.Menu.Sorting) do
	for i = 1, #POISONER_CONFIG.Menu.Sorting do
		local v = POISONER_CONFIG.Menu.Sorting[i]
	--	print(k,v)
		for j = 6,1,-1 do
		--	local tname = string.gsub(v, " ", "_")
			local tname = v
			local buttonName = "PoisonerMenuButton__"..tname..j;
			local button = _G[buttonName];
			
			if button and button:IsShown() then
				Poisoner_AnchorButton(button, prevbutton)
				prevbutton = button
			end
		end
	end
	
end

function Poisoner_AnchorButton(button, previousButton)
	
	local x = POISONER_CONFIG.Menu.Spacing
	local firstButton
	if not previousButton or previousButton == nil then firstButton = true end
	
	if (POISONER_CONFIG.Menu.Position == "top") then
		local ofsy = x
		if firstButton then
			button:SetPoint("BOTTOM", 0, ofsy);
			firstButton = false;
		else
			button:SetPoint("BOTTOM", previousButton, "TOP", 0, ofsy);
		end
	elseif (POISONER_CONFIG.Menu.Position == "bottom") then
		local ofsy = x*-1
		if firstButton then
			button:SetPoint("TOP", 0, ofsy);
			firstButton = false;
		else
			button:SetPoint("TOP", previousButton, "BOTTOM", 0, ofsy);
		end
	elseif (POISONER_CONFIG.Menu.Position == "right") or (POISONER_CONFIG.Menu.Position == "bottomright") or (POISONER_CONFIG.Menu.Position == "topright") then
		local ofsx = x
		if firstButton then
			button:SetPoint("TOPLEFT", ofsx, 0);
			firstButton = false;
		else
			button:SetPoint("TOPLEFT", previousButton, "TOPRIGHT", ofsx, 0);
		end
	else
		local ofsx = -x
		if firstButton then
			button:SetPoint("TOPRIGHT", ofsx, 0);
			firstButton = false;
		else
			button:SetPoint("TOPRIGHT", previousButton, "TOPLEFT", ofsx, 0);
		end
	end
	
end


--
-- Find available poisons
-- Returns an table keyed by poison name, value a table containing texture and quantity
--
function Poisoner_FindPoisons()
	local itemId, --[[itemLink,]] bagSlots, bagId, icon, quantity;
	local ret = {}
	--[==[
	for i=0, 4 do
		bagSlots = GetContainerNumSlots(i)
		if (bagSlots > 0) then
			for j=1, bagSlots do
				itemId = GetContainerItemID(i, j)
				icon, quantity = GetContainerItemInfo(i, j)
				if Poisoner_Patterns[itemId] then
					--local itemName, itemRank
					
					local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(itemId)
					
					if (itemName ~= nil) then
						-- if the quantity is 1, we either have a single consumable item, or an expendable item
						if (quantity == 1) then
							local charges = Poisoner_CountCharges(i, j)
							if (charges ~= nil) then
								quantity = charges
							end
						end

						local t = ret[itemName];
						if (t == nil) then
							t = { name=itemName, icon=icon, quantity=0, --[[rank=itemRank,]] id=itemId, bag=i, bagslot=j, shortname=Poisoner_Patterns[itemId] }
							ret[itemName] = t
						end
						t.quantity = t.quantity + quantity
						Poisoner_PoisonsEverSeen[itemName] = {}
						Poisoner_PoisonsEverSeen[itemName].icon = icon
						Poisoner_PoisonsEverSeen[itemName].shortname = Poisoner_Patterns[itemId]
					end
				end
			end
		end
	end
	]==]
	local poisons = Poisoner_Patterns
	for itemId, shortName in pairs(poisons) do
		local quantity = GetItemCount(itemId)
		if quantity > 0 then
			local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(itemId)
			local lt = POISONER_CONFIG.Poisons[itemId]
			itemName = itemName or lt and lt.Name
			itemTexture = itemTexture or lt and lt.Texture
			local t = ret[itemId];
			if (t == nil) then
				t = { name=itemName, icon=itemTexture, quantity=0, --[[rank=itemRank,]] id=itemId, link=itemLink, shortname=poisons[itemId] }
				ret[itemId] = t
			end
			t.name = itemName
			t.link = itemLink or "item:"..itemId
			t.quantity = quantity
			Poisoner_PoisonsEverSeen[itemId] = {}
			Poisoner_PoisonsEverSeen[itemId].icon = itemTexture
			Poisoner_PoisonsEverSeen[itemId].shortname = poisons[itemId]
		end
	end
	
	-- include zero counts for previously seen items we no longer have
	for prevItemName, tble in pairs(Poisoner_PoisonsEverSeen) do
		local t = ret[prevItemName]
		if (t == nil) then
			--t = { name=prevItemName, icon=tble.icon, quantity=0, bag=-1, bagslot=-1, shortname=tble.shortname }
			t = { name=(GetItemInfo(prevItemName)) or "", icon=tble.icon, quantity=0, id=prevItemName, shortname=tble.shortname }
			ret[prevItemName] = t
		end
	end
	return ret
end
-- since we cannot destroy frames, we must always remember everything we've seen
Poisoner_PoisonsEverSeen = {};

-- Use a tooltip to scan for the number of 'charges' on expendable items.
-- Returns the number of charges, or nil if it could not be found.
function Poisoner_CountCharges(bagId, bagSlot)
Poisoner_Debug("Looking for charges of "..bagId..","..bagSlot);
	local ret = nil;
	PoisonerScannerTooltip:SetOwner(UIParent, "ANCHOR_NONE");
	PoisonerScannerTooltip:SetBagItem(bagId, bagSlot);
	for i=1,PoisonerScannerTooltip:NumLines() do
		local field = _G["PoisonerScannerTooltipTextLeft"..i];
		if (field ~= nil) then
			local text = field:GetText();
			if (text) then
				local _, _, charges = string.find(text, POISONER_PATTERN_CHARGES);
				if (charges) then
					ret = tonumber(charges);
					break;
				end
			end
		end
	end
	PoisonerScannerTooltip:Hide();
	return ret;
end


function Poisoner_CreateItemMacroString(itemId, buttonId, modifier)
	if not itemId then return "" end
	
	if true then
		return "\n/use item:"..itemId
	end
	
	local mod = modifier and "mod:"..modifier or "nomod"
	local but = "button:"..buttonId
	
	return "\n/use ["..mod..","..but.."] item:"..itemId
end

function Poisoner_CreateFullItemMacroString(id, buttonId, modifier)
	if not id or (tonumber(id) and id == 1) or tostring(id) == "" then return "" end
	local cat = id < 100 and Poisoner_PoisonDropDownCats[id] or string.match(Poisoner_Patterns[id],"%a+")
	local t = Poisoner_Categories[cat]
	
	local str = ""
	for i=1,#t do
		local itemId = t[i]
		local nstr = Poisoner_CreateItemMacroString(itemId, buttonId, modifier)
		str = str..nstr
	end
	return str
end


--
-- Quick reapply button
--

function Poisoner_CheckQuickButton(force)
	if InCombatLockdown() then PoisonerStateHeader.needUpdate = true; return end
	
	if (POISONER_CONFIG.Enabled == 1) then
		local n16,n17 = Poisoner_PoisonSlots[1].Normal.Name, Poisoner_PoisonSlots[2].Normal.Name
		if ((n16 ~= nil and n16 ~= "") and (n17 ~= nil and n17 ~= "")) then
			if (Poisoner_QuickButtonVisible == 0) then
				Poisoner_CreateQuickButton()
				return "Create"
			elseif (Poisoner_QuickButtonVisible == 1) then
				Poisoner_UpdateQuickButton(force)
				return "Update"
			end
		elseif ((n16 == nil or n16 == "") and (n17 == nil or n17 == "")) then
			Poisoner_QuickButton:Hide();
			return "Hide"
		end
	elseif (POISONER_CONFIG.Enabled == 0) then
		Poisoner_QuickButton:Hide();
		return "Disabled"
	end
	
end

function Poisoner_GetToolTipTexture()
	
	local NoTexture = ""	--"Interface\\Icons\\INV_Misc_QuestionMark"

	for k,v in pairs(Poisoner_PoisonSlots) do
		if not v.Id then v.Id = "" end
		local t = POISONER_CONFIG.Poisons[v.Id]
		if not v.Name then v.Name = t and t.Name or "" end
		if not v.Texture or v.Texture == "" then v.Texture = t and t.Texture or GetItemIcon(v.Id) or "" end
	end
	
end

function Poisoner_CreateQuickButton()

	--local btn = CreateFrame("Button", "Poisoner_QuickButton", UIParent, "PoisonerReapplyTemplate");
	local btn = Poisoner_QuickButton
	local icon = Poisoner_QuickButtonIcon
	
	btn:RegisterForClicks("LeftButtonDown", "RightButtonDown");
	btn:SetNormalTexture("Interface\\Icons\\Ability_Creature_Poison_06");
	btn:SetHighlightTexture("Interface\\Icons\\Ability_Creature_Poison_06");
	btn:GetNormalTexture():SetVertexColor(1,1,1,1);
	btn:GetHighlightTexture():SetVertexColor(0.5,0.5,1,1);
	icon:SetTexture("Interface\\Icons\\Ability_Creature_Poison_06")
	
	Poisoner_GetToolTipTexture()

	--btn:SetAttribute("type", "macro");
	--btn:SetAttribute("macrotext", ""..p17.."\n"..p17s.."\n"..p17c.."\n"..p17a.."\n/use [button:2] 17\n"..p16.."\n"..p16s.."\n"..p16c.."\n"..p16a.."\n/use [button:1] 16\n/click StaticPopup1Button1\n/run PoisonerOptions_CheckPoisons()");
	--[[
	btn:SetAttribute("*type1", "macro");
	btn:SetAttribute("macrotext1", p16.."\n"..p16s.."\n"..p16c.."\n"..p16a.."\n/use [button:1] 16\n/click StaticPopup1Button1\n/run PoisonerOptions_CheckPoisons()")
	
	btn:SetAttribute("*type2", "macro");
	btn:SetAttribute("macrotext2", p17.."\n"..p17s.."\n"..p17c.."\n"..p17a.."\n/use [button:2] 17\n/click StaticPopup1Button1\n/run PoisonerOptions_CheckPoisons()")
	]]
	btn:SetScript("OnEnter", function() Poisoner_QuickButton_Tooltip(btn) end);	
	btn:SetScript("OnLeave", function() GameTooltip:Hide() end);
	
	btn:ClearAllPoints();
	btn:SetPoint("CENTER", Poisoner_QuickButton_Overlay, "CENTER");
	btn:Show();
	Poisoner_QuickButtonVisible = 1;
	
	btn:SetFrameRef("PoisonSlotFrame", Poisoner_PoisonSlotFrame)
	
	btn:Execute([[
		poison = table.new()
		mods = table.new("","shift-","ctrl-","alt-")
	]])
	
	btn:SetAttribute("_onattributechanged", [=[	--_onattributechanged(self, name, value)
		
		if string.find(name, "type") or string.find(name, "macrotext") then
			return
		end
		
		--print("_onattributechanged", self, name, value)
		
		--local psf = self:GetFrameRef("PoisonSlotFrame")
		--local overwrite = psf:GetAttribute("overwrite")
		--if not overwrite then return end
		
		local suffix = "\n/click StaticPopup1Button1\n/run PoisonerOptions_CheckPoisons()"
		
		local i = string.match(name, "%d")
		if not i then
			--print("i not a number", i)
			return
		end
		
		i = tonumber(i)
		local offhand = i > 4
		local mod = mods[(offhand and i-4) or i]
		local btnId = offhand and 2 or 1
		local slot = offhand and 17 or 16
		
		if tonumber(value) then
			self:SetAttribute(mod.."type"..btnId, "macro");
			self:SetAttribute(mod.."macrotext"..btnId, "/use item:"..value.."\n/use "..slot..suffix)
		elseif value then
			self:SetAttribute(mod.."type"..btnId, "macro");
			self:SetAttribute(mod.."macrotext"..btnId, value.."\n/use "..slot..suffix)
		end
		
	--
		if true then return end
	--
		
		for i=1,8 do
			local text = self:GetAttribute("Text"..i)
			--print(i,text,tonumber(text))
			poison[i] = tonumber(text) and "/use item:"..text or text or ""
		end
		
		--print("Poisons:\n"..poison[1].."\n"..poison[2].."\n"..poison[3].."\n"..poison[4].."\n"..poison[5].."\n"..poison[6].."\n"..poison[7].."\n"..poison[8])
		
		for i = 1,4 do
			local mod = mods[i]
			self:SetAttribute(mod.."type1", "macro");
			self:SetAttribute(mod.."macrotext1", poison[i].."\n/use 16"..suffix)
		end
		
		for i = 5,8 do
			local mod = mods[i-4]
			self:SetAttribute(mod.."type2", "macro");
			self:SetAttribute(mod.."macrotext2", poison[i].."\n/use 17"..suffix)
		end
		
		
		
	]=])
		
	local t = Poisoner_PoisonSlots
	local cfm = Poisoner_CreateFullItemMacroString
	local itemstring = "item:"
	local p17 = cfm(t[2].Normal.Id, 2, nil)	--itemstring..(t[2].Normal.Id or "")
	local p17s = cfm(t[2].SHIFT.Id, 2, "shift")	--itemstring..(t[2].SHIFT.Id or "")
	local p17c = cfm(t[2].CTRL.Id, 2, "ctrl")	--itemstring..(t[2].CTRL.Id or "")
	local p17a = cfm(t[2].ALT.Id, 2, "alt")	--itemstring..(t[2].ALT.Id or "")
	local p16 = cfm(t[1].Normal.Id, 1, nil)	--itemstring..(t[1].Normal.Id or "")
	local p16s = cfm(t[1].SHIFT.Id, 1, "shift")	--itemstring..(t[1].SHIFT.Id or "")
	local p16c = cfm(t[1].CTRL.Id, 1, "ctrl")	--itemstring..(t[1].CTRL.Id or "")
	local p16a = cfm(t[1].ALT.Id, 1, "alt")	--itemstring..(t[1].ALT.Id or "")
	
	btn:SetAttribute("Text1",p16)
	btn:SetAttribute("Text2",p16s)
	btn:SetAttribute("Text3",p16c)
	btn:SetAttribute("Text4",p16a)
	btn:SetAttribute("Text5",p17)
	btn:SetAttribute("Text6",p17s)
	btn:SetAttribute("Text7",p17c)
	btn:SetAttribute("Text8",p17a)
	
	local mods = {"","shift-","ctrl-","alt-"}
	local suffix = "\n/click StaticPopup1Button1\n/run PoisonerOptions_CheckPoisons()"
	for i = 1,8 do
		local value = btn:GetAttribute("Text"..i)
		local offhand = i > 4
		local mod = mods[(offhand and i-4) or i]
		local btnId = offhand and 2 or 1
		local slot = offhand and 17 or 16
		
		btn:SetAttribute(mod.."type"..btnId, "macro");
		btn:SetAttribute(mod.."macrotext"..btnId, value.."\n/use "..slot..suffix)
	end

	--Masque/ButtonFacade
	if MSQ and Poisoner_Masque_Initiated == true then
		--Poisoner_Masque_Init()
	--	print(btn:GetName())
		MSQ:Group("Poisoner", "QuickButton"):AddButton(btn)
		MSQ:Group("Poisoner", "QuickButton"):ReSkin()
	end

	print("|cff00ff00Poisoner:|r QuickButton created.")
	
	-- Tooltip layout
	
	local COLOR_GREEN = "|cff00ff00";
	local COLOR_GREY = "|cff808080";
	local COLOR_END = "|r";
	
	local t = Poisoner_PoisonSlots
	local pt16 = t[1].Normal.Texture or ""
	local pt16s = t[1].SHIFT.Texture or ""
	local pt16c = t[1].CTRL.Texture or ""
	local pt16a = t[1].ALT.Texture or ""
	local pt17 = t[2].Normal.Texture or ""
	local pt17s = t[2].SHIFT.Texture or ""
	local pt17c = t[2].CTRL.Texture or ""
	local pt17a = t[2].ALT.Texture or ""
	
	Poisoner_QuickButton_Text_MH = "|T"..pt16..":0|t |T"..pt16s..":0|t |T"..pt16c..":0|t |T"..pt16a..":0|t"
	Poisoner_QuickButton_Text_OH = "|T"..pt17..":0|t |T"..pt17s..":0|t |T"..pt17c..":0|t |T"..pt17a..":0|t"
	
	Poisoner_QuickButton_Text_Slots = ""..INVTYPE_WEAPONMAINHAND..": \n"..INVTYPE_WEAPONOFFHAND..": "
	Poisoner_QuickButton_Text_Textures = ""..Poisoner_QuickButton_Text_MH.."\n"..Poisoner_QuickButton_Text_OH..""
	
	Poisoner_QuickButton:Show();
	
end

function Poisoner_UpdateQuickButton(force)
	local btn = Poisoner_QuickButton
	local icon = Poisoner_QuickButtonIcon
	
	--Masque/ButtonFacade
		if MSQ and Poisoner_Masque_Initiated == true then
			--Poisoner_Masque_Init()
		--	print(btn:GetName())
			MSQ:Group("Poisoner", "QuickButton"):AddButton(btn)
			MSQ:Group("Poisoner", "QuickButton"):ReSkin()
		end
	
	if POISONER_CONFIG.Preset.Overwrite == 0 or force then
		local t = Poisoner_PoisonSlots
		local cfm = Poisoner_CreateFullItemMacroString
		local itemstring = "item:"
		local p17 = cfm(t[2].Normal.Id, 2, nil)	--itemstring..(t[2].Normal.Id or "")
		local p17s = cfm(t[2].SHIFT.Id, 2, "shift")	--itemstring..(t[2].SHIFT.Id or "")
		local p17c = cfm(t[2].CTRL.Id, 2, "ctrl")	--itemstring..(t[2].CTRL.Id or "")
		local p17a = cfm(t[2].ALT.Id, 2, "alt")	--itemstring..(t[2].ALT.Id or "")
		local p16 = cfm(t[1].Normal.Id, 1, nil)	--itemstring..(t[1].Normal.Id or "")
		local p16s = cfm(t[1].SHIFT.Id, 1, "shift")	--itemstring..(t[1].SHIFT.Id or "")
		local p16c = cfm(t[1].CTRL.Id, 1, "ctrl")	--itemstring..(t[1].CTRL.Id or "")
		local p16a = cfm(t[1].ALT.Id, 1, "alt")	--itemstring..(t[1].ALT.Id or "")
		
		--btn:SetAttribute("type", "macro");
		--btn:SetAttribute("macrotext", ""..p17.."\n"..p17s.."\n"..p17c.."\n"..p17a.."\n/use [button:2] 17\n"..p16.."\n"..p16s.."\n"..p16c.."\n"..p16a.."\n/use [button:1] 16\n/click StaticPopup1Button1\n/run PoisonerOptions_CheckPoisons()");
		--[[
		btn:SetAttribute("*type1", "macro");
		btn:SetAttribute("macrotext1", p16.."\n"..p16s.."\n"..p16c.."\n"..p16a.."\n/use [button:1] 16\n/click StaticPopup1Button1\n/run PoisonerOptions_CheckPoisons()")
		
		btn:SetAttribute("*type2", "macro");
		btn:SetAttribute("macrotext2", p17.."\n"..p17s.."\n"..p17c.."\n"..p17a.."\n/use [button:2] 17\n/click StaticPopup1Button1\n/run PoisonerOptions_CheckPoisons()")
		]]
		
		btn:SetAttribute("Text1",p16)
		btn:SetAttribute("Text2",p16s)
		btn:SetAttribute("Text3",p16c)
		btn:SetAttribute("Text4",p16a)
		btn:SetAttribute("Text5",p17)
		btn:SetAttribute("Text6",p17s)
		btn:SetAttribute("Text7",p17c)
		btn:SetAttribute("Text8",p17a)
	end
	
	Poisoner_GetToolTipTexture()
	
	-- Tooltip layout
	
	local COLOR_GREEN = "|cff00ff00";
	local COLOR_GREY = "|cff808080";
	local COLOR_END = "|r";
	
	local t = Poisoner_PoisonSlots
	local pt16 = t[1].Normal.Texture or ""
	local pt16s = t[1].SHIFT.Texture or ""
	local pt16c = t[1].CTRL.Texture or ""
	local pt16a = t[1].ALT.Texture or ""
	local pt17 = t[2].Normal.Texture or ""
	local pt17s = t[2].SHIFT.Texture or ""
	local pt17c = t[2].CTRL.Texture or ""
	local pt17a = t[2].ALT.Texture or ""
	
	Poisoner_QuickButton_Text_MH = "|T"..pt16..":0|t |T"..pt16s..":0|t |T"..pt16c..":0|t |T"..pt16a..":0|t"
	Poisoner_QuickButton_Text_OH = "|T"..pt17..":0|t |T"..pt17s..":0|t |T"..pt17c..":0|t |T"..pt17a..":0|t"
	
	Poisoner_QuickButton_Text_Slots = ""..INVTYPE_WEAPONMAINHAND..": \n"..INVTYPE_WEAPONOFFHAND..": "
	Poisoner_QuickButton_Text_Textures = ""..Poisoner_QuickButton_Text_MH.."\n"..Poisoner_QuickButton_Text_OH..""
	
	Poisoner_QuickButton:Show();
end


--
-- Slash command processing
--
function Poisoner_ProcessCommand(msg)
	local cmd, param1 = Poisoner_ParamParser(msg);
	local subcmd1, param2 = Poisoner_ParamParser(param1);
	local subcmd2, param3 = Poisoner_ParamParser(param2);
	local subcmd3 = Poisoner_ParamParser(param3);
--[[
	if cmd == nil then cmd = "cmd" end
	if param1 == nil then param1 = "param1" end
	if param2 == nil then param2 = "param2" end
	if param3 == nil then param3 = "param3" end
	if subcmd1 == nil then subcmd1 = "subcmd1" end
	if subcmd2 == nil then subcmd2 = "subcmd2" end
	if subcmd3 == nil then subcmd3 = "subcmd3" end
	print("Poisoner >"..cmd.."< >"..param1.."<")
	print(">"..subcmd1.."< >"..subcmd2.."< >"..subcmd3.."<")
]]
	--Poisoner main
	if (cmd == "") then
		PoisonerOptions_ToggleSettings();
	elseif (cmd == "enable") then
		Poisoner_Enable();
	elseif (cmd == "disable") then
		Poisoner_Disable();
	elseif (cmd == "config") then
		PoisonerOptions_ToggleSettings();
	elseif (cmd == "quickbutton") then
		local msg = "qb "..param1
		Poisoner_ProcessCommand(msg)
	--FreeButton
	elseif (cmd:lower() == "freebutton") or (string.match(cmd:lower(), "fb")) then
		if (string.match(subcmd1:lower(), "enable")) then
			POISONER_CONFIG.Buttons.FreeButton.Active = 1;
			Poisoner_FreeButton:Show();
		elseif (string.match(subcmd1:lower(), "disable")) then
			POISONER_CONFIG.Buttons.FreeButton.Active = 0;
			Poisoner_FreeButton:Hide();
		elseif (string.match(subcmd1:lower(), "lock")) then
			Poisoner_DragLock();
		elseif (string.match(subcmd1:lower(), "unlock")) then
			Poisoner_DragUnlock();
		elseif (string.match(subcmd1:lower(), "reset")) then
			Poisoner_DragReset();
		elseif (string.match(subcmd1:lower(), "scale")) then
			if ( (subcmd2 ~=nil) and (tonumber(subcmd2) ~= nil) and tonumber(subcmd2) >=0.1 and tonumber(subcmd2)<=2 ) then
				local arg = tonumber(subcmd2);
				Poisoner_FreeButton:SetScale(arg);
				POISONER_CONFIG.Buttons.FreeButton.Scale = arg;
			end
		elseif (string.match(subcmd1:lower(), "alpha")) then
			if ( (subcmd2 ~=nil) and (tonumber(subcmd2) ~= nil) and tonumber(subcmd2) >=0.1 and tonumber(subcmd2)<=1 ) then
				local arg = tonumber(subcmd2);
				Poisoner_FreeButton:SetAlpha(arg);
				POISONER_CONFIG.Buttons.FreeButton.Alpha = arg;
			end
		end
	--Menu
	elseif (string.match(cmd:lower(), "menu")) then
		--parent
		if (string.match(subcmd1:lower(), "parent")) then
			if (string.match(subcmd2:lower(), "own")) or (string.match(param2:lower(), "own frame")) then
				POISONER_CONFIG.Menu.Parent = "Poisoner_FreeButton";
				Poisoner_SetPosition()
				--print("|cff00ff00Poisoner|r: "..OPTION_RESTART_REQUIREMENT.."")
				--StaticPopup_Show("POISONER_STARTED_ONCE");
			elseif (string.match(subcmd2:lower(), "minimap")) then
				POISONER_CONFIG.Menu.Parent = "Minimap";
				Poisoner_SetPosition()
				--print("|cff00ff00Poisoner|r: "..OPTION_RESTART_REQUIREMENT.."")
				--StaticPopup_Show("POISONER_STARTED_ONCE");
			end
		--position
		elseif (string.match(subcmd1:lower(), "position")) then
			if (string.match(subcmd2:lower(), "top")) then
				POISONER_CONFIG.Menu.Position = "top";
				Poisoner_SetPosition("top")
			elseif (string.match(subcmd2:lower(), "topleft")) then
				POISONER_CONFIG.Menu.Position = "topleft";
				Poisoner_SetPosition("topleft")
			elseif (string.match(subcmd2:lower(), "topright")) then
				POISONER_CONFIG.Menu.Position = "topright";
				Poisoner_SetPosition("topright")
			elseif (string.match(subcmd2:lower(), "left")) then
				POISONER_CONFIG.Menu.Position = "left";
				Poisoner_SetPosition("left")
			elseif (string.match(subcmd2:lower(), "right")) then
				POISONER_CONFIG.Menu.Position = "right";
				Poisoner_SetPosition("right")
			elseif (string.match(subcmd2:lower(), "bottom")) then
				POISONER_CONFIG.Menu.Position = "bottom";
				Poisoner_SetPosition("bottom")
			elseif (string.match(subcmd2:lower(), "bottomleft")) then
				POISONER_CONFIG.Menu.Position = "bottomleft";
				Poisoner_SetPosition("bottomleft")
			elseif (string.match(subcmd2:lower(), "bottomright")) then
				POISONER_CONFIG.Menu.Position = "bottomright";
				Poisoner_SetPosition("bottomright")
			end
		--scale
		elseif (string.match(subcmd1:lower(), "scale")) then
			if ( (subcmd2 ~=nil) and (tonumber(subcmd2) ~= nil) and tonumber(subcmd2) >=0.1 and tonumber(subcmd2)<=2 ) then
				local arg = string.match(subcmd2, "([%d%.]+)");
				Poisoner_SetScale(tonumber(subcmd2))
			end
		--Overwrite Presets
		elseif (string.match(subcmd1:lower(), "overwrite")) then
			if (string.match(subcmd2:lower(), "true")) or ( tonumber(subcmd2) == 1 ) then
				POISONER_CONFIG.Preset.Overwrite = 1;
			elseif (string.match(subcmd2:lower(), "false")) or ( tonumber(subcmd2) == 0 ) then
				POISONER_CONFIG.Preset.Overwrite = 0;
			end
		--reset
		elseif (string.match(subcmd1:lower(), "reset")) then
			Poisoner_SetScale(1.0);
			Poisoner_SetPosition("left");
		end
	--ToolTip
	elseif (string.match(cmd:lower(), "tooltip")) then
		if (string.match(subcmd1:lower(), "full")) then
			POISONER_CONFIG.TooltipType = "full";
		elseif (string.match(subcmd1:lower(), "name")) then
			POISONER_CONFIG.TooltipType = "name";
		end
	elseif (string.match(cmd:lower(), "tt")) then
		if (string.match(subcmd1:lower(), "full")) then
			POISONER_CONFIG.TooltipType = "full";
		elseif (string.match(subcmd1:lower(), "name")) then
			POISONER_CONFIG.TooltipType = "name";
		end
	--Post Poison
	elseif (string.match(cmd:lower(), "postpoison")) then
		if (string.match(subcmd1:lower(), "true")) or ( tonumber(subcmd1) == 1 ) then
			POISONER_CONFIG.PrintClickedPoison = 1;
		elseif (string.match(subcmd1:lower(), "false")) or ( tonumber(subcmd1) == 0 ) then
			POISONER_CONFIG.PrintClickedPoison = 0;
		end
	--Timer
	elseif (string.match(cmd:lower(), "timer")) then
		if (string.match(subcmd1:lower(), "enable")) then
			POISONER_CONFIG.Timer.Active = 1;
			PoisonerOptions_CallUpdate();
		elseif (string.match(subcmd1:lower(), "disable")) then
			POISONER_CONFIG.Timer.Active = 0;
		elseif (string.match(subcmd1:lower(), "warningthreshold")) or (string.match(subcmd1:lower(), "wt")) then
			if ( (subcmd2 ~=nil) and (tonumber(subcmd2) ~= nil) and tonumber(subcmd2) >=1 and tonumber(subcmd2)<=25 ) then
				local arg = string.match(subcmd2, "([%d%.]+)");
				Poisoner_WarningThreshold = tonumber(subcmd2);
				POISONER_CONFIG.Timer.WarningThreshold = tonumber(subcmd2);
			else
				Poisoner_WarningThreshold = 5;
				POISONER_CONFIG.Timer.WarningThreshold = 5;
			end
		--output
		elseif (string.match(subcmd1:lower(), "output")) then
			if (string.match(subcmd2:lower(), "audio")) then
				if (string.match(subcmd3:lower(), "1")) or (string.match(subcmd3:lower(), "true")) then
					POISONER_CONFIG.Timer.Output.Audio = 1;
					PoisonerOptions_CallUpdate();
				elseif (string.match(subcmd3:lower(), "0")) or (string.match(subcmd3:lower(), "false")) then
					POISONER_CONFIG.Timer.Output.Audio = 0;
				end
			elseif (string.match(subcmd2:lower(), "chat")) then
				if (string.match(subcmd3:lower(), "1")) or (string.match(subcmd3:lower(), "true")) then
					POISONER_CONFIG.Timer.Output.Chat = 1;
					PoisonerOptions_CallUpdate();
				elseif (string.match(subcmd3:lower(), "0")) or (string.match(subcmd3:lower(), "false")) then
					POISONER_CONFIG.Timer.Output.Chat = 0;
				end
			elseif (string.match(subcmd2:lower(), "errorframe")) or (string.match(subcmd2:lower(), "error")) then
				if (string.match(subcmd3:lower(), "1")) or (string.match(subcmd3:lower(), "true")) then
					POISONER_CONFIG.Timer.Output.ErrorFrame = 1;
					PoisonerOptions_CallUpdate();
				elseif (string.match(subcmd3:lower(), "0")) or (string.match(subcmd3:lower(), "false")) then
					POISONER_CONFIG.Timer.Output.ErrorFrame = 0;
				end
			elseif (string.match(subcmd2:lower(), "aura")) then
				if (string.match(subcmd3:lower(), "1")) or (string.match(subcmd3:lower(), "true")) then
					POISONER_CONFIG.Timer.Output.Aura = 1;
					PoisonerOptions_CallUpdate();
				elseif (string.match(subcmd3:lower(), "0")) or (string.match(subcmd3:lower(), "false")) then
					POISONER_CONFIG.Timer.Output.Aura = 0;
					PoisonerTimer_Mainhand:Hide();
					PoisonerTimer_Offhand:Hide();
				end
			elseif (string.match(subcmd2:lower(), "mainhand") or string.match(subcmd2:lower(), "mh")) then
				if (string.match(subcmd3:lower(), "1")) or (string.match(subcmd3:lower(), "true")) then
					POISONER_CONFIG.Timer.Weapon.MainHand = 1;
					Poisoner_NoPoison_Warning1 = false
					Poisoner_MinWarning1 = false
				elseif (string.match(subcmd3:lower(), "0")) or (string.match(subcmd3:lower(), "false")) then
					POISONER_CONFIG.Timer.Weapon.MainHand = 0;
					PoisonerTimer_Mainhand:Hide();
				end
			elseif (string.match(subcmd2:lower(), "offhand") or string.match(subcmd2:lower(), "oh")) then
				if (string.match(subcmd3:lower(), "1")) or (string.match(subcmd3:lower(), "true")) then
					POISONER_CONFIG.Timer.Weapon.OffHand = 1;
					Poisoner_NoPoison_Warning2 = false
					Poisoner_MinWarning2 = false
				elseif (string.match(subcmd3:lower(), "0")) or (string.match(subcmd3:lower(), "false")) then
					POISONER_CONFIG.Timer.Weapon.OffHand = 0;
					PoisonerTimer_Offhand:Hide();
				end
			end
		--aura options
		elseif (string.match(subcmd1:lower(), "aura")) then
			if (string.match(subcmd2:lower(), "lock")) then
				POISONER_CONFIG.Timer.Lock = 1;
				PoisonerTimer_UpdateLock();
			elseif (string.match(subcmd2:lower(), "unlock")) then
				POISONER_CONFIG.Timer.Lock = 0;
				PoisonerTimer_UpdateLock();
			elseif (string.match(subcmd2:lower(), "scale")) then
				if ( (subcmd3 ~=nil) and (tonumber(subcmd3) ~= nil) and tonumber(subcmd3) >=0.1 and tonumber(subcmd3)<=2 ) then
					local arg = string.match(subcmd3, "([%d%.]+)");
					PoisonerTimer_IconFrameScale = tonumber(subcmd3);
					PoisonerTimer_IconFrame:SetScale(PoisonerTimer_IconFrameScale);
					POISONER_CONFIG.Timer.Scale = PoisonerTimer_IconFrameScale;
					PoisonerOptions_CallUpdate();
				end
			elseif (string.match(subcmd2:lower(), "alpha")) then
				if ( (subcmd3 ~=nil) and (tonumber(subcmd3) ~= nil) and tonumber(subcmd3) >=0.1 and tonumber(subcmd3)<=1 ) then
					local arg = string.match(subcmd3, "([%d%.]+)");
					PoisonerTimer_IconFrameAlpha = tonumber(subcmd3);
					PoisonerTimer_IconFrame:SetAlpha(PoisonerTimer_IconFrameAlpha);
					POISONER_CONFIG.Timer.Alpha = PoisonerTimer_IconFrameAlpha;
					PoisonerOptions_CallUpdate();
				end
			end
		end
	--AutoBuy
	elseif (string.match(cmd:lower(), "autobuy")) then
		if (string.match(subcmd1:lower(), "enable")) then
			POISONER_CONFIG.Buy.Active = 1;
		elseif (string.match(subcmd1:lower(), "disable")) then
			POISONER_CONFIG.Buy.Active = 0;
		elseif (string.match(subcmd1:lower(), "confirm")) then
			POISONER_CONFIG.Buy.Prompt = 0;
		elseif (string.match(subcmd1:lower(), "auto")) then
			POISONER_CONFIG.Buy.Prompt = 1;
		elseif (string.match(subcmd1:lower(), "check")) then
			if (subcmd2 == "true") or ( tonumber(subcmd2) == 1 ) then
				POISONER_CONFIG.Buy.Check = 1;
			elseif (subcmd2 == "false") or ( tonumber(subcmd2) == 0 ) then
				POISONER_CONFIG.Buy.Check = 0;
			end
		elseif (string.match(subcmd1:lower(), "cp")) then
			if ( (subcmd2 ~=nil) and (tonumber(subcmd2) ~= nil) and tonumber(subcmd2) >=0 and tonumber(subcmd2)<=100 ) then
				local arg = string.match(subcmd2, "([%d%.]+)");
				POISONER_CONFIG.Buy.CP = tonumber(subcmd2);
			end
		elseif (string.match(subcmd1:lower(), "dp")) then
			if ( (subcmd2 ~=nil) and (tonumber(subcmd2) ~= nil) and tonumber(subcmd2) >=0 and tonumber(subcmd2)<=100 ) then
				local arg = string.match(subcmd2, "([%d%.]+)");
				POISONER_CONFIG.Buy.DP = tonumber(subcmd2);
			end
		elseif (string.match(subcmd1:lower(), "ip")) then
			if ( (subcmd2 ~=nil) and (tonumber(subcmd2) ~= nil) and tonumber(subcmd2) >=0 and tonumber(subcmd2)<=100 ) then
				local arg = string.match(subcmd2, "([%d%.]+)");
				POISONER_CONFIG.Buy.IP = tonumber(subcmd2);
			end
		elseif (string.match(subcmd1:lower(), "mp")) then
			if ( (subcmd2 ~=nil) and (tonumber(subcmd2) ~= nil) and tonumber(subcmd2) >=0 and tonumber(subcmd2)<=100 ) then
				local arg = string.match(subcmd2, "([%d%.]+)");
				POISONER_CONFIG.Buy.MP = tonumber(subcmd2);
			end
		elseif (string.match(subcmd1:lower(), "wp")) then
			if ( (subcmd2 ~=nil) and (tonumber(subcmd2) ~= nil) and tonumber(subcmd2) >=0 and tonumber(subcmd2)<=100 ) then
				local arg = string.match(subcmd2, "([%d%.]+)");
				POISONER_CONFIG.Buy.WP = tonumber(subcmd2);
			end
		end
	--Presets
	elseif (string.match(cmd:lower(), "presets")) then
		if (string.match(subcmd1:lower(), "reset")) then
			PoisonerOptions_ResetPresets()
		end
	--QuickButton
	elseif (string.match(cmd:lower(), "qb")) then
		if (subcmd1:lower() == "lock") then
			POISONER_CONFIG.Buttons.QuickButton.Lock = 1;
			Poisoner_QuickButton_UpdateLock();
		elseif (subcmd1:lower() == "unlock") then
			POISONER_CONFIG.Buttons.QuickButton.Lock = 0;
			Poisoner_QuickButton_UpdateLock();
		elseif (string.match(subcmd1:lower(), "reset")) then
			Poisoner_QuickButton_Reset();
		elseif (string.match(subcmd1:lower(), "alpha")) then
			if ( (subcmd2 ~=nil) and (tonumber(subcmd2) ~= nil) and tonumber(subcmd2) >=0.1 and tonumber(subcmd2)<=1 ) then
				local arg = string.match(subcmd2, "([%d%.]+)");
				POISONER_CONFIG.Buttons.QuickButton.Alpha = tonumber(subcmd2);
				Poisoner_QuickButton_Overlay:SetAlpha(tonumber(subcmd2));
			end
		elseif (string.match(subcmd1:lower(), "scale")) then
			if ( (subcmd2 ~=nil) and (tonumber(subcmd2) ~= nil) and tonumber(subcmd2) >=0.1 and tonumber(subcmd2)<=2 ) then
				local arg = string.match(subcmd2, "([%d%.]+)");
				POISONER_CONFIG.Buttons.QuickButton.Scale = tonumber(subcmd2);
				Poisoner_QuickButton_Overlay:SetScale(tonumber(subcmd2));
			end
		end
	--Thanks
	elseif (string.match(cmd:lower(), "thanks")) then
		Poisoner_Thanks()
	--else
	else
		DEFAULT_CHAT_FRAME:AddMessage(POISONER_COMMANDERROR..cmd, 1.0, 1.0, 0.5);
	end
	PoisonerOptions_LoadSettings()
end

function Poisoner_ParamParser(msg)
	if msg then
 		local a,b,c=strfind(msg, "(%S+)"); --contiguous string of non-space characters
 		if a then
 			return c, strsub(msg, b+2);
 		else	
 			return "";
 		end
 	end
end

function Poisoner_Disable()
	--print(""..POISONER_TITLE..": "..DISABLE.."...")	--Debug
	POISONER_CONFIG.Enabled = 0;
	--if (PoisonerMenu:IsShown()) then
		PoisonerMenu:Hide();
	--end
	Poisoner_FreeButton:Hide();
	Poisoner_QuickButton:Hide();
end

function Poisoner_Enable()
	POISONER_CONFIG.Enabled = 1;
	Poisoner_FreeButton:Show();
	if (POISONER_CONFIG.StartedOnce == 0) then
		StaticPopup_Show("POISONER_STARTED_ONCE");
	end
	Poisoner_CheckQuickButton()
end

function PoisonerMenu_Toggle()
	local menu = PoisonerMenu;
	if (PoisonerMenu:IsShown()) then
		PoisonerMenu:Hide();
	else
		--[[local parent = POISONER_CONFIG.Menu.Parent
		local parentFrame
		local position = POISONER_CONFIG.Menu.Position
		local p, rp;
		if (position == "top") then
			menu:SetWidth("36");
			menu:SetHeight("240");
			p = "BOTTOM";
			rp = "TOP";
		elseif (position == "topleft") then
			menu:SetWidth("240");
			menu:SetHeight("36");
			p = "BOTTOMRIGHT";
			rp = "TOPLEFT";
		elseif (position == "topright") then
			menu:SetWidth("240");
			menu:SetHeight("36");
			p = "BOTTOMLEFT";
			rp = "TOPRIGHT";
		elseif (position == "left") then
			menu:SetWidth("240");
			menu:SetHeight("36");
			p = "RIGHT";
			rp = "LEFT";
		elseif (position == "right") then
			menu:SetWidth("240");
			menu:SetHeight("36");
			p = "LEFT";
			rp = "RIGHT";		
		elseif (position == "bottom") then
			menu:SetWidth("36");
			menu:SetHeight("240");
			p = "TOP";
			rp = "BOTTOM";
		elseif (position == "bottomleft") then
			menu:SetWidth("240");
			menu:SetHeight("36");
			p = "TOPRIGHT";
			rp = "BOTTOMLEFT";
		elseif (position == "bottomright") then
			menu:SetWidth("240");
			menu:SetHeight("36");
			p = "TOPLEFT";
			rp = "BOTTOMRIGHT";
		else
			menu:SetWidth("240");
			menu:SetHeight("36");
			p = "TOPRIGHT";
			rp = "LEFT";
		end
		PoisonerMenu:ClearAllPoints()
		if ((parent == "Minimap") and (LibDBIcon10_Poisoner)) then
			parentFrame = "LibDBIcon10_Poisoner"
		else
			parentFrame = "Poisoner_FreeButton"
		end
		PoisonerMenu:SetPoint(p, parentFrame, rp);
		POISONER_CONFIG.Menu.Parent = parent]]
		PoisonerMenu:Show();
	end
end

--
-- Dragging
--

-- Start dragging the poison button
function Poisoner_OnDragStart(self)
	if (POISONER_CONFIG.Buttons.FreeButton.Lock == 0 and not Poisoner_BeingDragged) then
		self:StartMoving();
		Poisoner_BeingDragged = true;
	else
		DEFAULT_CHAT_FRAME:AddMessage(POISONER_DRAGERROR, 1.0, 1.0, 0.5);
	end
end

-- Stop dragging the poison button
function Poisoner_OnDragStop(self)
	if (Poisoner_BeingDragged) then
		self:StopMovingOrSizing()
		Poisoner_BeingDragged = false
		POISONER_CONFIG.Buttons.FreeButton.Position.Anchor, _, POISONER_CONFIG.Buttons.FreeButton.Position.RelativePoint, POISONER_CONFIG.Buttons.FreeButton.Position.XPos, POISONER_CONFIG.Buttons.FreeButton.Position.YPos = self:GetPoint()
	end
end

function Poisoner_DragLock()
	POISONER_CONFIG.Buttons.FreeButton.Lock = 1;
end

function Poisoner_DragUnlock()
	POISONER_CONFIG.Buttons.FreeButton.Lock = 0;
	Poisoner_BeingDragged = false;
end

function Poisoner_DragReset()
	if not InCombatLockdown() then
		Poisoner_FreeButton:ClearAllPoints();
		--Poisoner_FreeButton:SetPoint("BOTTOM", Minimap, -72, 112);
		Poisoner_FreeButton:SetPoint("CENTER",UIParent,"CENTER",0,0)
	end
end


-- 
-- Scaling and position options
--

function Poisoner_SetScale(scale)
	POISONER_CONFIG.Menu.Scale = scale;
	PoisonerMenu:SetScale(scale);
end

function Poisoner_SetPosition(position)
	local menu = PoisonerMenu;
	if not position then
		position = POISONER_CONFIG.Menu.Position
	end
	if (position == "left" or position == "right" or position == "bottom" or position == "bottomright" or position == "bottomleft" or position == "topright" or position == "topleft" or position == "top") then
		POISONER_CONFIG.Menu.Position = position;
		PoisonerMenu:ClearAllPoints();
		local parent = POISONER_CONFIG.Menu.Parent
		local parentFrame
		local p, rp;
		if (position == "top") then
			menu:SetWidth("36");
			menu:SetHeight("240");
			p = "BOTTOM";
			rp = "TOP";
		elseif (position == "topleft") then
			menu:SetWidth("240");
			menu:SetHeight("36");
			p = "BOTTOMRIGHT";
			rp = "LEFT";
		elseif (position == "topright") then
			menu:SetWidth("240");
			menu:SetHeight("36");
			p = "BOTTOMLEFT";
			rp = "RIGHT";
		elseif (position == "left") then
			menu:SetWidth("240");
			menu:SetHeight("36");
			p = "RIGHT";
			rp = "LEFT";
		elseif (position == "right") then
			menu:SetWidth("240");
			menu:SetHeight("36");
			p = "LEFT";
			rp = "RIGHT";		
		elseif (position == "bottom") then
			menu:SetWidth("36");
			menu:SetHeight("240");
			p = "TOP";
			rp = "BOTTOM";
		elseif (position == "bottomleft") then
			menu:SetWidth("240");
			menu:SetHeight("36");
			p = "TOPRIGHT";
			rp = "LEFT";
		elseif (position == "bottomright") then
			menu:SetWidth("240");
			menu:SetHeight("36");
			p = "TOPLEFT";
			rp = "RIGHT";
		else
			menu:SetWidth("240");
			menu:SetHeight("36");
			p = "TOPRIGHT";
			rp = "LEFT";
		end
		PoisonerMenu:ClearAllPoints()
		if ((parent == "Minimap") and (LibDBIcon10_Poisoner)) then
			parentFrame = "LibDBIcon10_Poisoner"
		else
			parentFrame = "Poisoner_FreeButton"
		end
		PoisonerMenu:SetPoint(p, parentFrame, rp);
		POISONER_CONFIG.Menu.Parent = parent
		--PoisonerMenu:SetPoint(p, Poisoner_FreeButton, rp);
	else
		-- error
		DEFAULT_CHAT_FRAME:AddMessage(POISONER_POSITIONERROR, 1.0, 1.0, 0.5);
	end
	if player_entered_world then
		Poisoner_CreateButtons();
	end
end


--
-- ToolTips for type "full"/"name only"
--

function Poisoner_Tooltip(self,pbagid,pbagslot,pttip)
	GameTooltip:SetOwner(self,"BOTTOMLEFT");
	if (POISONER_CONFIG.TooltipType == "full") then
		if pbagid and pbagslot then
			GameTooltip:SetBagItem(pbagid,pbagslot);
		else
			GameTooltip:SetHyperlink(pbagid)
		end
	else
		GameTooltip:SetText(pttip, 1.00, 1.00, 1.00);
	end
	GameTooltip:Show();
end


--
-- ToolTips for QuickButton
--

function Poisoner_QuickButton_Tooltip(self)
	GameTooltip:SetOwner(self,"BOTTOMLEFT");
	GameTooltip:ClearLines();
	--GameTooltip:AddLine(Poisoner_QuickButton_Text, 1.00, 1.00, 1.00);
	--GameTooltip:SetText(Poisoner_QuickButton_Text, 1.00, 1.00, 1.00);
	--GameTooltip:AddLine("|T"..Texture..":0|t ")
	GameTooltip:AddDoubleLine(Poisoner_QuickButton_Text_Slots, Poisoner_QuickButton_Text_Textures, 1,1,1, 1,1,1);
	GameTooltip:Show();
end


--
-- QuickButton DragHandler
--
function Poisoner_QuickButton_CreateOverlay()
	--	Overlay
	--[[local f = CreateFrame("Frame", "Poisoner_QuickButton_Overlay", UIParent)
	f:SetFrameStrata("DIALOG")
	f:SetWidth(30) 
	f:SetHeight(30)]]
	
	local t = Poisoner_QuickButton_Overlay:CreateTexture("Poisoner_QuickButton_OverlayBackground","BACKGROUND")
	t:SetColorTexture(1,1,1,0)
	t:SetAllPoints(Poisoner_QuickButton_Overlay)
	Poisoner_QuickButton_Overlay.texture = t
	
	Poisoner_QuickButton_Overlay:Show()
end

function Poisoner_QuickButton_UpdateLock()
	
	if (POISONER_CONFIG.Buttons.QuickButton.Lock == 1) then
		Poisoner_QuickButton_Overlay:RegisterForDrag()
		Poisoner_QuickButton_OverlayBackground:SetColorTexture(0,1,0,0)
		Poisoner_QuickButton_Overlay:SetMovable(false)
		Poisoner_QuickButton_Overlay:EnableMouse(false)
		Poisoner_QuickButton_Overlay:SetScript("OnDragStart", nil)
		Poisoner_QuickButton_Overlay:SetScript("OnDragStop", nil)		
	else
		Poisoner_QuickButton_Overlay:Show()
		Poisoner_QuickButton_Overlay:RegisterForDrag("LeftButton")
		Poisoner_QuickButton_OverlayBackground:SetColorTexture(0,1,0,0.5)
		Poisoner_QuickButton_Overlay:SetMovable(true)
		Poisoner_QuickButton_Overlay:EnableMouse(true)
		Poisoner_QuickButton_Overlay:SetScript("OnDragStart", Poisoner_QuickButton_OnDragStart)
		Poisoner_QuickButton_Overlay:SetScript("OnDragStop", Poisoner_QuickButton_OnDragStop)
	end
end


-- Start dragging QuickButton
function Poisoner_QuickButton_OnDragStart(self)
	
	self:StartMoving();
	Poisoner_QuickButton_BeingDragged = true;
	
end

-- Stop dragging QuickButton
function Poisoner_QuickButton_OnDragStop(self)
	if (Poisoner_QuickButton_BeingDragged) then
		self:StopMovingOrSizing()
		POISONER_CONFIG.Buttons.QuickButton.Position.Anchor, _, POISONER_CONFIG.Buttons.QuickButton.Position.RelativePoint, POISONER_CONFIG.Buttons.QuickButton.Position.XPos, POISONER_CONFIG.Buttons.QuickButton.Position.YPos = Poisoner_QuickButton_Overlay:GetPoint();
		Poisoner_QuickButton_BeingDragged = false;
	end
end

function Poisoner_QuickButton_Reset()
	POISONER_CONFIG.Buttons.QuickButton.Position = { 
		XPos = 0,
		YPos = 0,
		Anchor = "CENTER",
		RelativeTo = "UIParent",
		RelativePoint = "CENTER",
		Parent = nil,
		}
	
	Poisoner_QuickButton_Overlay:ClearAllPoints()
	Poisoner_QuickButton_Overlay:SetPoint(POISONER_CONFIG.Buttons.QuickButton.Position.Anchor, "UIParent", POISONER_CONFIG.Buttons.QuickButton.Position.RelativeTo, POISONER_CONFIG.Buttons.QuickButton.Position.XPos, POISONER_CONFIG.Buttons.QuickButton.Position.YPos)
	Poisoner_QuickButton_Overlay:SetScale(POISONER_CONFIG.Buttons.QuickButton.Scale)
	Poisoner_QuickButton_Overlay:SetAlpha(POISONER_CONFIG.Buttons.QuickButton.Alpha)
	Poisoner_QuickButton_Overlay:Show()
	POISONER_CONFIG.Buttons.QuickButton.Lock = 0
	Poisoner_QuickButton_UpdateLock()
end


--
-- Debugging : set to true if ya want it on
--

function Poisoner_Debug(message)
	if (Poisoner_PrintDebug) then
		if (message == nil) then
			message = "<nil>";
		end
		DEFAULT_CHAT_FRAME:AddMessage(message);
	end
end


--
-- Saying THANK YOU
--

function Poisoner_Thanks()
	local people = {
		"Nyss / Horstl",
		"Ysinthe / Ryjnjohl",
		"TrAsHeR",
		"Itonohito",
		"- Me and Myself -",
	}
	
	print(POISONER_THANKYOUTEXT)
	for k,v in pairs(people) do
		print(" "..v)
	end
	
end


--
--	DataBroker and LDBIcon
--
local LDB		= LibStub("LibDataBroker-1.1")
local LDBIcon	= LibStub("LibDBIcon-1.0")
local data_obj

function Poisoner_LDB_OnEnable()
	data_obj = LDB:NewDataObject("Poisoner", {
		type	= "data source",
		label	= "Poisoner",
		text	= " ",
		icon	= "Interface\\Icons\\Spell_Nature_CorrosiveBreath",
		OnEnter	= function()				  
			  end,
		-- OnLeave is an empty function because some LDB displays refuse to display a plugin that has an OnEnter but no OnLeave.
		OnLeave	= function()
			  end,
		OnClick = function(display, button)
				  if button == "RightButton" then
					PoisonerOptions_ToggleSettings()
				  elseif button == "LeftButton" then
					PoisonerMenu_Toggle()
				  elseif button == "MiddleButton" then
					print("Poisoner_LDB: MiddleButton")
				  end
			  end,
	})
	--UpdateDataFeed()

	if LDBIcon then
		LDBIcon:Register("Poisoner", data_obj, POISONER_CONFIG.Buttons.LDBIcon)
	end
end

function Poisoner_LDB_Enable()
	POISONER_CONFIG.Buttons.LDBIcon.hide = "false"
	LDBIcon:Show("Poisoner")
	Poisoner_ShowLDBIcon = 1
	Poisoner_SetPosition()
	PoisonerStateHeader:SetScript("OnUpdate", nil);
end
function Poisoner_LDB_Disable()
	POISONER_CONFIG.Buttons.LDBIcon.hide = "true"
	LDBIcon:Hide("Poisoner")
	Poisoner_ShowLDBIcon = 0
	Poisoner_SetPosition()
	PoisonerStateHeader:SetScript("OnUpdate", nil);
end


function Poisoner_TestPoisons()
	local continue = true
	for itemId,sn in pairs(Poisoner_Patterns) do
		local name = GetItemInfo(itemId)
		if not name then
			continue = false
		end
	end
	if not continue then return end
	function GetItemCount() return 10 end
	Poisoner_CreateButtons()
end

