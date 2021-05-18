--[[ 

	Poisoner
	¯¯¯¯¯¯¯¯¯¯
	> Dropdown menu for poison presets

]]

local width = 150
local buttonWidth = 170

function Poisoner_DropDownMenu_CreateEntry(itemId)
	if not itemId or itemId == "" then return NONE end
	local t = POISONER_CONFIG.Poisons[itemId]
	if not t then return itemId end
	return "|T"..t.Texture..":0|t"..t.Name
end

function Poisoner_DropDownMenu_CreateFrames()

	if not POISONER_CONFIG.Poisons or not POISONER_CONFIG.Poisons[10918] then return end

	local poisons = {
		NONE,	--[1]
		Poisoner_DropDownMenu_CreateEntry(3775),	--CPName,	--[2]
		Poisoner_DropDownMenu_CreateEntry(5237),	--MPName,	--[3]
		Poisoner_DropDownMenu_CreateEntry(2892),	--DPName,	--[4]
		Poisoner_DropDownMenu_CreateEntry(6947),	--IPName,	--[5]
		Poisoner_DropDownMenu_CreateEntry(10918),	--WPName,	--[6]
	}
	
	PoisonerDropDown_CreateFrame_Normal(poisons)
	PoisonerDropDown_CreateFrame_SHIFT(poisons)
	PoisonerDropDown_CreateFrame_CTRL(poisons)
	PoisonerDropDown_CreateFrame_ALT(poisons)

end

function PoisonerDropDown_CreateFrame_Normal(poisons)
	
	--
	-- DropDownMenu - Mainhand
	--
	if not Poisoner_DropDownMenu_Mainhand then
		CreateFrame("Button", "Poisoner_DropDownMenu_Mainhand", PoisonerOptions_DropdownFrame1, "UIDropDownMenuTemplate")
	end
	 
	Poisoner_DropDownMenu_Mainhand:ClearAllPoints()
	Poisoner_DropDownMenu_Mainhand:SetPoint("TOPLEFT", PoisonerOptions_DropdownFrame1, "TOPLEFT", -20, -15)
	Poisoner_DropDownMenu_Mainhand:Show()

	local function OnClick(self)
		UIDropDownMenu_SetSelectedID(Poisoner_DropDownMenu_Mainhand, self:GetID())
		local id = self:GetID()
		PoisonerDropDown_SelectPresetPoison("Mainhand", id, "Normal")
	end
	 
	local function initialize(self, level)
		local info = UIDropDownMenu_CreateInfo()
		for k,v in pairs(poisons) do
			info = UIDropDownMenu_CreateInfo()
			info.text = v
			info.value = v
			info.func = OnClick
			UIDropDownMenu_AddButton(info, level)
		end
	end 
	 
	UIDropDownMenu_Initialize(Poisoner_DropDownMenu_Mainhand, initialize)
	UIDropDownMenu_SetWidth(Poisoner_DropDownMenu_Mainhand, width);
	UIDropDownMenu_SetButtonWidth(Poisoner_DropDownMenu_Mainhand, buttonWidth)
	UIDropDownMenu_SetSelectedID(Poisoner_DropDownMenu_Mainhand, 1)
	UIDropDownMenu_JustifyText(Poisoner_DropDownMenu_Mainhand, "LEFT")



	--
	-- DropDownMenu - Offhand
	--
	if not Poisoner_DropDownMenu_Offhand then
		CreateFrame("Button", "Poisoner_DropDownMenu_Offhand", PoisonerOptions_DropdownFrame2, "UIDropDownMenuTemplate")
	end
	 
	Poisoner_DropDownMenu_Offhand:ClearAllPoints()
	Poisoner_DropDownMenu_Offhand:SetPoint("TOPLEFT", PoisonerOptions_DropdownFrame2, "TOPLEFT", -20, -15)
	Poisoner_DropDownMenu_Offhand:Show()

	local function OnClick(self)
		UIDropDownMenu_SetSelectedID(Poisoner_DropDownMenu_Offhand, self:GetID())
		local id = self:GetID()
		PoisonerDropDown_SelectPresetPoison("Offhand", id, "Normal")
	end
	 
	local function initialize(self, level)
		local info = UIDropDownMenu_CreateInfo()
		for k,v in pairs(poisons) do
			info = UIDropDownMenu_CreateInfo()
			info.text = v
			info.value = v
			info.func = OnClick
			UIDropDownMenu_AddButton(info, level)
		end
	end 
	 
	UIDropDownMenu_Initialize(Poisoner_DropDownMenu_Offhand, initialize)
	UIDropDownMenu_SetWidth(Poisoner_DropDownMenu_Offhand, width);
	UIDropDownMenu_SetButtonWidth(Poisoner_DropDownMenu_Offhand, buttonWidth)
	UIDropDownMenu_SetSelectedID(Poisoner_DropDownMenu_Offhand, 1)
	UIDropDownMenu_JustifyText(Poisoner_DropDownMenu_Offhand, "LEFT")

end

function PoisonerDropDown_CreateFrame_SHIFT(poisons)
	
	--
	-- DropDownMenu - Mainhand
	--
	if not Poisoner_DropDownMenu_Mainhand_SHIFT then
		CreateFrame("Button", "Poisoner_DropDownMenu_Mainhand_SHIFT", PoisonerOptions_DropdownFrame_SHIFT1, "UIDropDownMenuTemplate")
	end
	 
	Poisoner_DropDownMenu_Mainhand_SHIFT:ClearAllPoints()
	Poisoner_DropDownMenu_Mainhand_SHIFT:SetPoint("TOPLEFT", PoisonerOptions_DropdownFrame_SHIFT1, "TOPLEFT", -20, -15)
	Poisoner_DropDownMenu_Mainhand_SHIFT:Show()

	local function OnClick(self)
		UIDropDownMenu_SetSelectedID(Poisoner_DropDownMenu_Mainhand_SHIFT, self:GetID())
		local id = self:GetID()
		PoisonerDropDown_SelectPresetPoison("Mainhand", id, "SHIFT")
	end
	 
	local function initialize(self, level)
		local info = UIDropDownMenu_CreateInfo()
		for k,v in pairs(poisons) do
			info = UIDropDownMenu_CreateInfo()
			info.text = v
			info.value = v
			info.func = OnClick
			UIDropDownMenu_AddButton(info, level)
		end
	end 
	 
	UIDropDownMenu_Initialize(Poisoner_DropDownMenu_Mainhand_SHIFT, initialize)
	UIDropDownMenu_SetWidth(Poisoner_DropDownMenu_Mainhand_SHIFT, width);
	UIDropDownMenu_SetButtonWidth(Poisoner_DropDownMenu_Mainhand_SHIFT, buttonWidth)
	UIDropDownMenu_SetSelectedID(Poisoner_DropDownMenu_Mainhand_SHIFT, 1)
	UIDropDownMenu_JustifyText(Poisoner_DropDownMenu_Mainhand_SHIFT, "LEFT")



	--
	-- DropDownMenu - Offhand
	--
	if not Poisoner_DropDownMenu_Offhand_SHIFT then
		CreateFrame("Button", "Poisoner_DropDownMenu_Offhand_SHIFT", PoisonerOptions_DropdownFrame_SHIFT2, "UIDropDownMenuTemplate")
	end
	 
	Poisoner_DropDownMenu_Offhand_SHIFT:ClearAllPoints()
	Poisoner_DropDownMenu_Offhand_SHIFT:SetPoint("TOPLEFT", PoisonerOptions_DropdownFrame_SHIFT2, "TOPLEFT", -20, -15)
	Poisoner_DropDownMenu_Offhand_SHIFT:Show()

	local function OnClick(self)
		UIDropDownMenu_SetSelectedID(Poisoner_DropDownMenu_Offhand_SHIFT, self:GetID())
		local id = self:GetID()
		PoisonerDropDown_SelectPresetPoison("Offhand", id, "SHIFT")
	end
	 
	local function initialize(self, level)
		local info = UIDropDownMenu_CreateInfo()
		for k,v in pairs(poisons) do
			info = UIDropDownMenu_CreateInfo()
			info.text = v
			info.value = v
			info.func = OnClick
			UIDropDownMenu_AddButton(info, level)
		end
	end 
	 
	UIDropDownMenu_Initialize(Poisoner_DropDownMenu_Offhand_SHIFT, initialize)
	UIDropDownMenu_SetWidth(Poisoner_DropDownMenu_Offhand_SHIFT, width);
	UIDropDownMenu_SetButtonWidth(Poisoner_DropDownMenu_Offhand_SHIFT, buttonWidth)
	UIDropDownMenu_SetSelectedID(Poisoner_DropDownMenu_Offhand_SHIFT, 1)
	UIDropDownMenu_JustifyText(Poisoner_DropDownMenu_Offhand_SHIFT, "LEFT")
	
end

function PoisonerDropDown_CreateFrame_CTRL(poisons)
		
	--
	-- DropDownMenu - Mainhand
	--
	if not Poisoner_DropDownMenu_Mainhand_CTRL then
		CreateFrame("Button", "Poisoner_DropDownMenu_Mainhand_CTRL", PoisonerOptions_DropdownFrame_CTRL1, "UIDropDownMenuTemplate")
	end
	 
	Poisoner_DropDownMenu_Mainhand_CTRL:ClearAllPoints()
	Poisoner_DropDownMenu_Mainhand_CTRL:SetPoint("TOPLEFT", PoisonerOptions_DropdownFrame_CTRL1, "TOPLEFT", -20, -15)
	Poisoner_DropDownMenu_Mainhand_CTRL:Show()

	local function OnClick(self)
		UIDropDownMenu_SetSelectedID(Poisoner_DropDownMenu_Mainhand_CTRL, self:GetID())
		local id = self:GetID()
		PoisonerDropDown_SelectPresetPoison("Mainhand", id, "CTRL")
	end
	 
	local function initialize(self, level)
		local info = UIDropDownMenu_CreateInfo()
		for k,v in pairs(poisons) do
			info = UIDropDownMenu_CreateInfo()
			info.text = v
			info.value = v
			info.func = OnClick
			UIDropDownMenu_AddButton(info, level)
		end
	end 
	 
	UIDropDownMenu_Initialize(Poisoner_DropDownMenu_Mainhand_CTRL, initialize)
	UIDropDownMenu_SetWidth(Poisoner_DropDownMenu_Mainhand_CTRL, width);
	UIDropDownMenu_SetButtonWidth(Poisoner_DropDownMenu_Mainhand_CTRL, buttonWidth)
	UIDropDownMenu_SetSelectedID(Poisoner_DropDownMenu_Mainhand_CTRL, 1)
	UIDropDownMenu_JustifyText(Poisoner_DropDownMenu_Mainhand_CTRL, "LEFT")



	--
	-- DropDownMenu - Offhand
	--
	if not Poisoner_DropDownMenu_Offhand_CTRL then
		CreateFrame("Button", "Poisoner_DropDownMenu_Offhand_CTRL", PoisonerOptions_DropdownFrame_CTRL2, "UIDropDownMenuTemplate")
	end
	 
	Poisoner_DropDownMenu_Offhand_CTRL:ClearAllPoints()
	Poisoner_DropDownMenu_Offhand_CTRL:SetPoint("TOPLEFT", PoisonerOptions_DropdownFrame_CTRL2, "TOPLEFT", -20, -15)
	Poisoner_DropDownMenu_Offhand_CTRL:Show()

	local function OnClick(self)
		UIDropDownMenu_SetSelectedID(Poisoner_DropDownMenu_Offhand_CTRL, self:GetID())
		local id = self:GetID()
		PoisonerDropDown_SelectPresetPoison("Offhand", id, "CTRL")
	end
	 
	local function initialize(self, level)
		local info = UIDropDownMenu_CreateInfo()
		for k,v in pairs(poisons) do
			info = UIDropDownMenu_CreateInfo()
			info.text = v
			info.value = v
			info.func = OnClick
			UIDropDownMenu_AddButton(info, level)
		end
	end 
	 
	UIDropDownMenu_Initialize(Poisoner_DropDownMenu_Offhand_CTRL, initialize)
	UIDropDownMenu_SetWidth(Poisoner_DropDownMenu_Offhand_CTRL, width);
	UIDropDownMenu_SetButtonWidth(Poisoner_DropDownMenu_Offhand_CTRL, buttonWidth)
	UIDropDownMenu_SetSelectedID(Poisoner_DropDownMenu_Offhand_CTRL, 1)
	UIDropDownMenu_JustifyText(Poisoner_DropDownMenu_Offhand_CTRL, "LEFT")
	
end

function PoisonerDropDown_CreateFrame_ALT(poisons)
		
	--
	-- DropDownMenu - Mainhand
	--
	if not Poisoner_DropDownMenu_Mainhand_ALT then
		CreateFrame("Button", "Poisoner_DropDownMenu_Mainhand_ALT", PoisonerOptions_DropdownFrame_ALT1, "UIDropDownMenuTemplate")
	end
	 
	Poisoner_DropDownMenu_Mainhand_ALT:ClearAllPoints()
	Poisoner_DropDownMenu_Mainhand_ALT:SetPoint("TOPLEFT", PoisonerOptions_DropdownFrame_ALT1, "TOPLEFT", -20, -15)
	Poisoner_DropDownMenu_Mainhand_ALT:Show()

	local function OnClick(self)
		UIDropDownMenu_SetSelectedID(Poisoner_DropDownMenu_Mainhand_ALT, self:GetID())
		local id = self:GetID()
		PoisonerDropDown_SelectPresetPoison("Mainhand", id, "ALT")
	end
	
	local function initialize(self, level)
		local info = UIDropDownMenu_CreateInfo()
		for k,v in pairs(poisons) do
			info = UIDropDownMenu_CreateInfo()
			info.text = v
			info.value = v
			info.func = OnClick
			UIDropDownMenu_AddButton(info, level)
		end
	end 
	 
	UIDropDownMenu_Initialize(Poisoner_DropDownMenu_Mainhand_ALT, initialize)
	UIDropDownMenu_SetWidth(Poisoner_DropDownMenu_Mainhand_ALT, width);
	UIDropDownMenu_SetButtonWidth(Poisoner_DropDownMenu_Mainhand_ALT, buttonWidth)
	UIDropDownMenu_SetSelectedID(Poisoner_DropDownMenu_Mainhand_ALT, 1)
	UIDropDownMenu_JustifyText(Poisoner_DropDownMenu_Mainhand_ALT, "LEFT")



	--
	-- DropDownMenu - Offhand
	--
	if not Poisoner_DropDownMenu_Offhand_ALT then
		CreateFrame("Button", "Poisoner_DropDownMenu_Offhand_ALT", PoisonerOptions_DropdownFrame_ALT2, "UIDropDownMenuTemplate")
	end
	 
	Poisoner_DropDownMenu_Offhand_ALT:ClearAllPoints()
	Poisoner_DropDownMenu_Offhand_ALT:SetPoint("TOPLEFT", PoisonerOptions_DropdownFrame_ALT2, "TOPLEFT", -20, -15)
	Poisoner_DropDownMenu_Offhand_ALT:Show()

	local function OnClick(self)
		UIDropDownMenu_SetSelectedID(Poisoner_DropDownMenu_Offhand_ALT, self:GetID())
		local id = self:GetID()
		PoisonerDropDown_SelectPresetPoison("Offhand", id, "ALT")
	end
	 
	local function initialize(self, level)
		local info = UIDropDownMenu_CreateInfo()
		for k,v in pairs(poisons) do
			info = UIDropDownMenu_CreateInfo()
			info.text = v
			info.value = v
			info.func = OnClick
			UIDropDownMenu_AddButton(info, level)
		end
	end 
	 
	UIDropDownMenu_Initialize(Poisoner_DropDownMenu_Offhand_ALT, initialize)
	UIDropDownMenu_SetWidth(Poisoner_DropDownMenu_Offhand_ALT, width);
	UIDropDownMenu_SetButtonWidth(Poisoner_DropDownMenu_Offhand_ALT, buttonWidth)
	UIDropDownMenu_SetSelectedID(Poisoner_DropDownMenu_Offhand_ALT, 1)
	UIDropDownMenu_JustifyText(Poisoner_DropDownMenu_Offhand_ALT, "LEFT")
	
end

function PoisonerDropDown_GetBaseItemId(id)
	if not id or id == 1 then return "" end
	return Poisoner_Categories[Poisoner_PoisonDropDownCats[id]][1]
end

function PoisonerDropDown_SelectPresetPoison(weapon, id, modifier)
	
	local itemId = PoisonerDropDown_GetBaseItemId(id)
	local t = POISONER_CONFIG.Poisons[itemId]
	local itemName = t and t.Name or ""
	
	
	POISONER_CONFIG.Preset[modifier][weapon] = id
	
	local buttonId = weapon == "Offhand" and 2 or 1
	Poisoner_PoisonSlots[buttonId][modifier] = {
		Name = itemName,
		Id = itemId,
		Texture = t and t.Texture or "",
		MacroText = Poisoner_CreateFullItemMacroString(id, buttonId, modifer~="Normal" and string.lower(modifier) or nil)
	}
	
	if InCombatLockdown() then
		PoisonerStateHeader.needUpdate = true
		PoisonerStateHeader.forceUpdate = true
	else
		Poisoner_GetToolTipTexture()
		Poisoner_CheckQuickButton(true)
	end
	
end


function PoisonerDropDown_UpdateDropDownText(frame, id)
	
	local itemId = PoisonerDropDown_GetBaseItemId(id)
	--local itemName = POISONER_CONFIG.Poisons[itemId].Name or ""
	
	UIDropDownMenu_SetSelectedID(frame, id)
	UIDropDownMenu_SetText(frame, Poisoner_DropDownMenu_CreateEntry(itemId))
	
end






