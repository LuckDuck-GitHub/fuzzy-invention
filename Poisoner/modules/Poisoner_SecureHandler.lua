--PoisonerMenu:Hide();
--PoisonerOptions_SettingsFrame:Hide();
Poisoner_SecureHandler = {}

local btnMinimap = CreateFrame("BUTTON", "Poisoner_FreeButton", UIParent, "SecureHandlerClickTemplate, SecureHandlerBaseTemplate, SecureHandlerEnterLeaveTemplate, Poisoner_MinimapButton");
btnMinimap:RegisterForDrag("LeftButton");
--btnMinimap:SetClampedToScreen(true);
btnMinimap:ClearAllPoints();
btnMinimap:SetPoint("CENTER",UIParent,"CENTER");

local texture = btnMinimap:CreateTexture(nil, "ARTWORK");
texture:SetTexture("Interface\\AddOns\\Poisoner\\images\\Poisoner_MMButton");
texture:SetBlendMode("BLEND");
texture:SetAllPoints(btnMinimap);
btnMinimap:SetHighlightTexture(texture);
Poisoner_TestTableInterger = {"Test-1","Test-2","Test-3"}
--[[
btnMinimap:SetAttribute("_onclick", [=[
 local show, i, ref = button == "LeftButton", 2, self:GetFrameRef("frame1");
 while ref do
  if show then ref:Show(); else ref:Hide(); end
  i, ref = i + 1, self:GetFrameRef("frame" .. i);
 end
]=]);
]]
btnMinimap:Execute([[
	poisons = table.new();
	
	Show = [=[
		print("Standard Execute - Show")
	]=]
	
	--print("Standard Execute")
]]);
btnMinimap:SetAttribute("_onenter", [=[
	menu, psf = self:GetFrameRef("frame1"), self:GetFrameRef("PoisonSlotFrame");
	
	local som = psf:GetAttribute("showmouseover")
	
	if som then
		if menu:IsVisible() then
			menu:Hide();
		elseif menu:IsShown() then
			menu:Hide();
		else
			menu:Show();
		end
	end
	
]=])
btnMinimap:SetAttribute("_onleave", [=[
	local som = psf:GetAttribute("showmouseover")
	
	if som then
		menu:Hide();
	end
]=])
btnMinimap:SetAttribute("_onclick", [=[
	local left, right, middle, menu, options, qb, psf = button == "LeftButton", button == "RightButton", button == "MiddleButton", self:GetFrameRef("frame1"), self:GetFrameRef("frame2"), self:GetFrameRef("button1"), self:GetFrameRef("PoisonSlotFrame");
	local overwrite = psf:GetAttribute("overwrite")
	
	if right then
		--[[
		if options:IsVisible() then
				options:Hide();
		elseif options:IsShown() then
			options:Hide();
		else
			options:Show();
		end
		]]
	elseif left then
		if menu:IsVisible() then
			menu:Hide();
		elseif menu:IsShown() then
			menu:Hide();
		else
			menu:Show();
		end
	elseif middle then
		--print("QuickButton updated.")
	end
	
	local poison1, poison2, poison3, poison4, poison5, poison6, poison7, poison8
	poison1 = psf:GetAttribute("Text1")
	poison2 = psf:GetAttribute("Text2")
	poison3 = psf:GetAttribute("Text3")
	poison4 = psf:GetAttribute("Text4")
	poison5 = psf:GetAttribute("Text5")
	poison6 = psf:GetAttribute("Text6")
	poison7 = psf:GetAttribute("Text7")
	poison8 = psf:GetAttribute("Text8")
	
	--print("Poisons:\n"..poison1.."\n"..poison2.."\n"..poison3.."\n"..poison4.."\n"..poison5.."\n"..poison6.."\n"..poison7.."\n"..poison8)
	
	--Poisoner_QuickButton_Text = "/use [nomodifier,button:2] "..poison5.."\n/use [modifier:shift,button:2] "..poison6.."\n/use [modifier:ctrl,button:2] "..poison7.."\n/use [modifier:alt,button:2] "..poison8.."\n/use [button:2] 17\n/use [nomodifier,button:1] "..poison1.."\n/use [modifier:shift,button:1] "..poison2.."\n/use [modifier:ctrl,button:1] "..poison3.."\n/use [modifier:alt,button:1] "..poison4.."\n/use [button:1] 16\n/click StaticPopup1Button1\n/run PoisonerOptions_CheckPoisons()"
	--print(Poisoner_QuickButton_Text)	
	--qb:SetAttribute("type", "macro");
	--qb:SetAttribute("macrotext", "/dance");
	if overwrite then
		--print("/use [nomodifier,button:2] "..poison5.."\n/use [modifier:shift,button:2] "..poison6.."\n/use [modifier:ctrl,button:2] "..poison7.."\n/use [modifier:alt,button:2] "..poison8.."\n/use [button:2] 17\n/use [nomodifier,button:1] "..poison1.."\n/use [modifier:shift,button:1] "..poison2.."\n/use [modifier:ctrl,button:1] "..poison3.."\n/use [modifier:alt,button:1] "..poison4.."\n/use [button:1] 16\n/click StaticPopup1Button1\n/run PoisonerOptions_CheckPoisons()")
		--qb:SetAttribute("macrotext", "/use [nomodifier,button:2] "..poison5.."\n/use [modifier:shift,button:2] "..poison6.."\n/use [modifier:ctrl,button:2] "..poison7.."\n/use [modifier:alt,button:2] "..poison8.."\n/use [button:2] 17\n/use [nomodifier,button:1] "..poison1.."\n/use [modifier:shift,button:1] "..poison2.."\n/use [modifier:ctrl,button:1] "..poison3.."\n/use [modifier:alt,button:1] "..poison4.."\n/use [button:1] 16\n/click StaticPopup1Button1\n/run PoisonerOptions_CheckPoisons()");
	end
	
]=]);


btnMinimap:RegisterForClicks("AnyUp");
btnMinimap:SetFrameRef("frame1", PoisonerMenu);
btnMinimap:SetFrameRef("frame2", PoisonerOptions_SettingsFrame);
btnMinimap:SetFrameRef("button1", Poisoner_QuickButton);


btnMinimap:SetScript("OnDragStart", Poisoner_OnDragStart);
btnMinimap:SetScript("OnDragStop", Poisoner_OnDragStop);
btnMinimap:SetScript("PostClick", Poisoner_SecureHandler_Update);

local function toggleoptions(self, button)
	if button == "RightButton" then
		PoisonerOptions_ToggleSettings()
	end
end
btnMinimap.ToggleOptions = toggleoptions
btnMinimap:WrapScript(btnMinimap, "PostClick", [=[
		control:CallMethod("ToggleOptions", button)
]=])

btnMinimap:SetScript("OnEvent", function(self, event, ...)
	if (type(Poisoner_SecureHandler[event]) == 'function') then
		Poisoner_SecureHandler[event](self, event, ...);
	end
end)

local pmo = CreateFrame("Frame", "Poisoner_MenuOverlay", PoisonerMenu, "SecureHandlerEnterLeaveTemplate");
pmo:ClearAllPoints();
pmo:SetAllPoints(PoisonerMenu);
pmo:SetFrameLevel(PoisonerMenu:GetFrameLevel()+1)
pmo:SetAttribute("_onenter", [=[
	menu, psf = self:GetFrameRef("frame1"), self:GetFrameRef("PoisonSlotFrame");
	
	local som = psf:GetAttribute("showmouseover")
--	print("PMO _onenter")
	if som then
		menu:Show();
	end
	
]=])
pmo:SetAttribute("_onleave", [=[
	menu, psf = self:GetFrameRef("frame1"), self:GetFrameRef("PoisonSlotFrame");
	
	local som = psf:GetAttribute("showmouseover")
--	print("PMO _onleave")
	if som then
		menu:Hide();
	end
	
]=])
pmo:SetFrameRef("frame1", PoisonerMenu);

function Poisoner_SecureHandler_Update()
	if InCombatLockdown() then
		PoisonerStateHeader.needUpdate = true
	else
		Poisoner_SecureHandler:LoadMenu()
	end
end
PoisonerSecureFrame_PSF_Onload = false
local btnMenuItem = CreateFrame("Button", "Poisoner_PoisonSlotFrame", PoisonerStateHeader, "SecureHandlerBaseTemplate, Poisoner_MenuLabelTemplate");
--local btnMenuItem = _G["Poisoner_PoisonSlotFrame"];
btnMenuItem:Show();
btnMinimap:SetFrameRef("PoisonSlotFrame", Poisoner_PoisonSlotFrame);
function Poisoner_SecureHandler:LoadMenu()
--[[	btnMinimap:Execute([=[
		poisons = table.new();
	]=]);]]
--	Poisoner_TestTable = {}
	local poisonslots = Poisoner_PoisonSlots;
--[[	local index = 1
	for k,v in pairs(poisonslots) do
		local text = v.Name
		if ( v.Name == "" ) then
			text = NONE
		end
		--print(index.." = "..text)
	--	btnMinimap:Execute([=[
	--		table.insert(poisons, text);
	--	]=]);
		table.insert(Poisoner_TestTable, index, text);
		--print("poisons "..index)
		--print(v.Name.." - "..v.Texture)
		index = index + 1
	end]]
	
	--Create section header
	if (not btnMenuItem) then
		btnMenuItem = CreateFrame("Button", "Poisoner_PoisonSlotFrame", PoisonerStateHeader, "SecureHandlerBaseTemplate, Poisoner_MenuLabelTemplate");
	end
	
	if ( POISONER_CONFIG.Preset.Overwrite == 1 ) then
		btnMenuItem:SetAttribute("overwrite", 1);
	else
		btnMenuItem:SetAttribute("overwrite", nil);
	end	
	
	if ( POISONER_CONFIG.Menu.ShowOnMouseover == 1 ) then
		btnMenuItem:SetAttribute("showmouseover", 1);
	else
		btnMenuItem:SetAttribute("showmouseover", nil);
	end	
--[[
	if ( POISONER_CONFIG.Preset.Overwrite == 0 ) or ( PoisonerSecureFrame_PSF_Onload == false ) then
		for i = 1,8 do
			if poisonslots[i] then
				local textid = "Text"..i;
				local name = poisonslots[i].Name;
				btnMenuItem:SetAttribute(textid, name);
				--print("NameString: "..poisonslots[i].Name.." TextID: "..textid.." Name "..name);
			end
		end
		PoisonerSecureFrame_PSF_Onload = true
	end
]]
	
--[[	for index = 1, table.getn(poisonslots) do 
		local section = poisonslots[index];
		
		if (not scetion) or (section == nil) then
			section = {}
		elseif (not section.Name) or (section.Name) then
			section.Name = ""
		end
		
		--btnMenuItem:SetText(section.Name);
		btnMenuItem:SetAttribute("Text"..index, section.Name)
		if ( section.Name == "" ) then
			btnMenuItem:SetAttribute("Text"..index, NONE)
		end
	end
]]
	
	--btnMenuItem:SetFrameRef("button1", Poisoner_QuickButton);
	pmo:SetFrameRef("PoisonSlotFrame", Poisoner_PoisonSlotFrame);
--[[	btnMinimap:Execute([=[
		table.insert(poisons, self:GetFrameRef("child"));
	]=]);
]]	
end

--[[
local button = CreateFrame("Button", "Poisoner_TestButton", PoisonerMenu, "ActionButtonTemplate, SecureActionButtonTemplate, SecureHandlerEnterLeaveTemplate, SecureHandlerAttributeTemplate,SecureHandlerDragTemplate,SecureHandlerMouseUpDownTemplate")
button:RegisterForDrag("LeftButton");
--button:SetClampedToScreen(true);
button:SetHeight(36)
button:SetWidth(36)
button:ClearAllPoints();
button:SetPoint("CENTER",UIParent,"CENTER");

local texture = button:CreateTexture(nil, "ARTWORK");
texture:SetTexture("Interface\\AddOns\\Poisoner\\images\\Poisoner_MMButton");
texture:SetBlendMode("BLEND");
texture:SetAllPoints(button);
button:SetHighlightTexture(texture);

button:SetAttribute("_onshow", [=[ print(self:GetName().." _onshow")]=])
button:SetAttribute("_onhide", [=[ print(self:GetName().." _onhide")]=])
button:SetAttribute("_onenter", [=[ print(self:GetName().." _onenter")]=])
button:SetAttribute("_onleave", [=[ print(self:GetName().." _onleave")]=])
button:SetFrameRef("frame1", PoisonerMenu);
]]

