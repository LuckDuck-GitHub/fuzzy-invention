--[[ 

	Poisoner
	¯¯¯¯¯¯¯¯¯¯
	> Options

]]


PoisonerOptions = {};
PoisonerOptions.needUpdate = false;
PoisonerBF_Initiated = false;

Poisoner_PoisonSlots = {
	[1] = {
		["Normal"] = {},
		["SHIFT"] = {},
		["CTRL"] = {},
		["ALT"] = {},
	},
	[2] = {
		["Normal"] = {},
		["SHIFT"] = {},
		["CTRL"] = {},
		["ALT"] = {},
	},
}

function Poisoner_round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

function Poisoner_roundToNextX(num,idp,X)
	return Poisoner_round(num/X, idp)*X
end

function Poisoner_GetBoolean(val)
	if tonumber(val) == 1 then
		return true
	elseif tonumber(val) == 0 then
		return false
	end
end

-- load current profile onto settings
function PoisonerOptions_LoadSettings()
	
	local OptionsTSWidth = PoisonerOptions_SettingsFrameTitleString:GetWidth();
	local TSTextureWidth = OptionsTSWidth + 50;
	PoisonerOptions_SettingsFrameTitleBorder:SetWidth(TSTextureWidth);
	
	PoisonerOptions_GetPoisonNames()
	
	local IP = POISONER_CONFIG.Buy.IP
	local CP = POISONER_CONFIG.Buy.CP
	local WP = POISONER_CONFIG.Buy.WP
	local DP = POISONER_CONFIG.Buy.DP
	local MP = POISONER_CONFIG.Buy.MP

	PoisonerOptions_Slider_IP:SetValue(IP)
	PoisonerOptions_Slider_CP:SetValue(CP)
	PoisonerOptions_Slider_WP:SetValue(WP)
	PoisonerOptions_Slider_DP:SetValue(DP)
	PoisonerOptions_Slider_MP:SetValue(MP)
	
	PoisonerOptions_TextIP:SetText(IP)
	PoisonerOptions_TextCP:SetText(CP)
	PoisonerOptions_TextWP:SetText(WP)
	PoisonerOptions_TextDP:SetText(DP)
	PoisonerOptions_TextMP:SetText(MP)
	
	if (POISONER_CONFIG.Enabled == 1) then
		PoisonerOptions_ChkBox_Enable:SetChecked(true)
	else
		PoisonerOptions_ChkBox_Enable:SetChecked(false)
	end
	
	if (POISONER_CONFIG.Buttons.LDBIcon.hide == "false") then
		PoisonerOptions_ChkBox_MBShow:SetChecked(true)
	else
		PoisonerOptions_ChkBox_MBShow:SetChecked(false)
	end
	if (POISONER_CONFIG.Buttons.FreeButton.Active == 1) then
		PoisonerOptions_ChkBox_FBShow:SetChecked(true)
	else
		PoisonerOptions_ChkBox_FBShow:SetChecked(false)
	end
	if (POISONER_CONFIG.Buttons.FreeButton.Lock == 1) then
		PoisonerOptions_ChkBox_FBLock:SetChecked(true)
	else
		PoisonerOptions_ChkBox_FBLock:SetChecked(false)
	end	
	if ( POISONER_CONFIG.Menu.Parent == "Poisoner_FreeButton" ) then
		PoisonerOptions_ChkBox_MenuParentOwn:SetChecked(true)
		PoisonerOptions_ChkBox_MenuParentMinimap:SetChecked(false)
	elseif ( POISONER_CONFIG.Menu.Parent == "Minimap" ) then
		PoisonerOptions_ChkBox_MenuParentOwn:SetChecked(false)
		PoisonerOptions_ChkBox_MenuParentMinimap:SetChecked(true)
	end	
	if ( POISONER_CONFIG.Menu.Position == "top" ) then
		PoisonerOptions_UpdateMenuPositionCheckbox(PoisonerOptions_ChkBox_MPTop)
	elseif ( POISONER_CONFIG.Menu.Position == "topleft" ) then
		PoisonerOptions_UpdateMenuPositionCheckbox(PoisonerOptions_ChkBox_MPTopLeft)
	elseif ( POISONER_CONFIG.Menu.Position == "topright" ) then
		PoisonerOptions_UpdateMenuPositionCheckbox(PoisonerOptions_ChkBox_MPTopRight)
	elseif ( POISONER_CONFIG.Menu.Position == "left" ) then
		PoisonerOptions_UpdateMenuPositionCheckbox(PoisonerOptions_ChkBox_MPLeft)
	elseif ( POISONER_CONFIG.Menu.Position == "right" ) then
		PoisonerOptions_UpdateMenuPositionCheckbox(PoisonerOptions_ChkBox_MPRight)
	elseif ( POISONER_CONFIG.Menu.Position == "bottom" ) then
		PoisonerOptions_UpdateMenuPositionCheckbox(PoisonerOptions_ChkBox_MPBottom)
	elseif ( POISONER_CONFIG.Menu.Position == "bottomleft" ) then
		PoisonerOptions_UpdateMenuPositionCheckbox(PoisonerOptions_ChkBox_MPBottomLeft)
	elseif ( POISONER_CONFIG.Menu.Position == "bottomriht" ) then
		PoisonerOptions_UpdateMenuPositionCheckbox(PoisonerOptions_ChkBox_MPBottomRight)
	end
	
	if ( POISONER_CONFIG.TooltipType == "full" ) then
		PoisonerOptions_ChkBox_ToolTipFull:SetChecked(true)
		PoisonerOptions_ChkBox_ToolTipName:SetChecked(false)
	elseif ( POISONER_CONFIG.TooltipType == "name" ) then
		PoisonerOptions_ChkBox_ToolTipFull:SetChecked(false)	
		PoisonerOptions_ChkBox_ToolTipName:SetChecked(true)
	end
	
	PoisonerOptions_ChkBox_OverwritePreset:SetChecked(Poisoner_GetBoolean(POISONER_CONFIG.Preset.Overwrite));
	PoisonerOptions_ChkBox_PoisonWeaponChatOuput:SetChecked(Poisoner_GetBoolean(POISONER_CONFIG.PrintClickedPoison));
	
	PoisonerOptions_ChkBox_ShowOnMouseover:SetChecked(Poisoner_GetBoolean(POISONER_CONFIG.Menu.ShowOnMouseover));
	PoisonerOptions_ChkBox_AutoHide_inCombat:SetChecked(Poisoner_GetBoolean(POISONER_CONFIG.Menu.AutoHide.inCombat));
	
	PoisonerDropDown_UpdateDropDownText(Poisoner_DropDownMenu_Mainhand, POISONER_CONFIG.Preset.Normal.Mainhand)
	PoisonerDropDown_UpdateDropDownText(Poisoner_DropDownMenu_Offhand, POISONER_CONFIG.Preset.Normal.Offhand)
	
	PoisonerDropDown_UpdateDropDownText(Poisoner_DropDownMenu_Mainhand_SHIFT, POISONER_CONFIG.Preset.SHIFT.Mainhand)
	PoisonerDropDown_UpdateDropDownText(Poisoner_DropDownMenu_Offhand_SHIFT, POISONER_CONFIG.Preset.SHIFT.Offhand)
	
	PoisonerDropDown_UpdateDropDownText(Poisoner_DropDownMenu_Mainhand_CTRL, POISONER_CONFIG.Preset.CTRL.Mainhand)
	PoisonerDropDown_UpdateDropDownText(Poisoner_DropDownMenu_Offhand_CTRL, POISONER_CONFIG.Preset.CTRL.Offhand)
	
	PoisonerDropDown_UpdateDropDownText(Poisoner_DropDownMenu_Mainhand_ALT, POISONER_CONFIG.Preset.ALT.Mainhand)
	PoisonerDropDown_UpdateDropDownText(Poisoner_DropDownMenu_Offhand_ALT, POISONER_CONFIG.Preset.ALT.Offhand)
	
	PoisonerOptions_ChkBox_ShowTimer:SetChecked(Poisoner_GetBoolean(POISONER_CONFIG.Timer.Active));
	PoisonerOptions_ChkBox_TimerOutput_IgnoreWhileFishing:SetChecked(Poisoner_GetBoolean(POISONER_CONFIG.Timer.IgnoreWhileFishing));
	PoisonerOptions_ChkBox_TimerOutput_OnlyInstanced:SetChecked(Poisoner_GetBoolean(POISONER_CONFIG.Timer.OnlyInstanced));
	PoisonerOptions_ChkBox_TimerOutput_MainHand:SetChecked(Poisoner_GetBoolean(POISONER_CONFIG.Timer.Weapon.MainHand));
	PoisonerOptions_ChkBox_TimerOutput_OffHand:SetChecked(Poisoner_GetBoolean(POISONER_CONFIG.Timer.Weapon.OffHand));
	
	PoisonerOptions_ChkBox_TimerOutput_Aura:SetChecked(Poisoner_GetBoolean(POISONER_CONFIG.Timer.Output.Aura));
	PoisonerOptions_ChkBox_TimerOutput_Aura_Lock:SetChecked(Poisoner_GetBoolean(POISONER_CONFIG.Timer.Lock));
	PoisonerOptions_ChkBox_TimerOutput_Audio:SetChecked(Poisoner_GetBoolean(POISONER_CONFIG.Timer.Output.Audio));
	PoisonerOptions_ChkBox_TimerOutput_Chat:SetChecked(Poisoner_GetBoolean(POISONER_CONFIG.Timer.Output.Chat));
	PoisonerOptions_ChkBox_TimerOutput_ErrorFrame:SetChecked(Poisoner_GetBoolean(POISONER_CONFIG.Timer.Output.ErrorFrame));
	
	PoisonerOptions_ChkBox_AutoBuy:SetChecked(Poisoner_GetBoolean(POISONER_CONFIG.Buy.Active));
	PoisonerOptions_ChkBox_AutoBuy_Prompt:SetChecked(Poisoner_GetBoolean(POISONER_CONFIG.Buy.Prompt));	
	PoisonerOptions_ChkBox_AutoBuy_Check:SetChecked(Poisoner_GetBoolean(POISONER_CONFIG.Buy.Check));
	
	PoisonerOptions_PoisonTimerSlider:SetValue(Poisoner_WarningThreshold)	
	
	PoisonerOptions_PoisonTimerScaleSlider:SetValue(POISONER_CONFIG.Timer.Scale);
	PoisonerOptions_PoisonTimerAlphaSlider:SetValue(POISONER_CONFIG.Timer.Alpha);
	
	PoisonerOptions_ChkBox_QuickButton_Lock:SetChecked(Poisoner_GetBoolean(POISONER_CONFIG.Buttons.QuickButton.Lock));
	
	PoisonerOptions_FB_ScaleSlider:SetValue(tonumber(POISONER_CONFIG.Buttons.FreeButton.Scale));
	PoisonerOptions_FB_AlphaSlider:SetValue(tonumber(POISONER_CONFIG.Buttons.FreeButton.Alpha));
	
	PoisonerOptions_QB_ScaleSlider:SetValue(POISONER_CONFIG.Buttons.QuickButton.Scale);
	PoisonerOptions_QB_AlphaSlider:SetValue(POISONER_CONFIG.Buttons.QuickButton.Alpha);
	
	PoisonerOptions_Menu_ScaleSlider:SetValue(POISONER_CONFIG.Menu.Scale);
	PoisonerOptions_Menu_SpacingSlider:SetValue(POISONER_CONFIG.Menu.Spacing);
		
end

-- save current profile settings
function PoisonerOptions_SaveSettings()
	POISONER_CONFIG.Buy.IP = PoisonerOptions_Slider_IP:GetValue()
	POISONER_CONFIG.Buy.CP = PoisonerOptions_Slider_CP:GetValue()
	POISONER_CONFIG.Buy.WP = PoisonerOptions_Slider_WP:GetValue()
	POISONER_CONFIG.Buy.DP = PoisonerOptions_Slider_DP:GetValue()
	POISONER_CONFIG.Buy.MP = PoisonerOptions_Slider_MP:GetValue()

	local IP = POISONER_CONFIG.Buy.IP
	local CP = POISONER_CONFIG.Buy.CP
	local WP = POISONER_CONFIG.Buy.WP
	local DP = POISONER_CONFIG.Buy.DP
	local MP = POISONER_CONFIG.Buy.MP
	
	PoisonerOptions_TextIP:SetText(IP)
	PoisonerOptions_TextCP:SetText(CP)
	PoisonerOptions_TextWP:SetText(WP)
	PoisonerOptions_TextDP:SetText(DP)
	PoisonerOptions_TextMP:SetText(MP)
	
	POISONER_CONFIG.Buttons.FreeButton.Scale = PoisonerOptions_FB_ScaleSlider:GetValue();
	
	Poisoner_WarningThreshold = PoisonerOptions_PoisonTimerSlider:GetValue()
	POISONER_CONFIG.Timer.WarningThreshold = Poisoner_WarningThreshold
	
	if ( PoisonerOptions_ChkBox_Enable:GetChecked() ) then
		POISONER_CONFIG.Enabled = 1;
		Poisoner_Enable();
	else
		POISONER_CONFIG.Enabled = 0;
		Poisoner_Disable();
	end
	
	
	if ( PoisonerOptions_ChkBox_MBShow:GetChecked() ) then
		POISONER_CONFIG.Buttons.LDBIcon.hide = "false";
		Poisoner_LDB_Enable();
	else
		POISONER_CONFIG.Buttons.LDBIcon.hide = "true";
		Poisoner_LDB_Disable();
		POISONER_CONFIG.Menu.Parent = "Poisoner_FreeButton";
		Poisoner_SetPosition();
	end
	if ( PoisonerOptions_ChkBox_FBShow:GetChecked() ) then
		POISONER_CONFIG.Buttons.FreeButton.Active = 1
		if ( POISONER_CONFIG.Enabled == 1 ) then
			Poisoner_FreeButton:Show()
		end
	else
		POISONER_CONFIG.Buttons.FreeButton.Active = 0
		Poisoner_FreeButton:Hide()
	end
	if ( PoisonerOptions_ChkBox_FBLock:GetChecked() ) then
		POISONER_CONFIG.Buttons.FreeButton.Lock = 1
	else
		POISONER_CONFIG.Buttons.FreeButton.Lock = 0
	end	
	if ( PoisonerOptions_ChkBox_MenuParentOwn:GetChecked() ) then
		POISONER_CONFIG.Menu.Parent = "Poisoner_FreeButton";
		--POISONER_CONFIG.Buttons.FreeButton.Position.RelativeTo = "UIParent";
	elseif ( PoisonerOptions_ChkBox_MenuParentMinimap:GetChecked() ) then
		POISONER_CONFIG.Menu.Parent = "Minimap";
		--POISONER_CONFIG.Buttons.FreeButton.Position.RelativeTo = "Minimap";
	end
	if ( PoisonerOptions_ChkBox_MPTop:GetChecked() ) then
		POISONER_CONFIG.Menu.Position = "top";
		Poisoner_SetPosition("top")
	elseif ( PoisonerOptions_ChkBox_MPTopLeft:GetChecked() ) then
		POISONER_CONFIG.Menu.Position = "topleft";
		Poisoner_SetPosition("topleft")
	elseif ( PoisonerOptions_ChkBox_MPTopRight:GetChecked() ) then
		POISONER_CONFIG.Menu.Position = "topright";
		Poisoner_SetPosition("topright")
	elseif ( PoisonerOptions_ChkBox_MPLeft:GetChecked() ) then
		POISONER_CONFIG.Menu.Position = "left";
		Poisoner_SetPosition("left")
	elseif ( PoisonerOptions_ChkBox_MPRight:GetChecked() ) then
		POISONER_CONFIG.Menu.Position = "right";
		Poisoner_SetPosition("right")
	elseif ( PoisonerOptions_ChkBox_MPBottom:GetChecked() ) then
		POISONER_CONFIG.Menu.Position = "bottom";
		Poisoner_SetPosition("bottom")
	elseif ( PoisonerOptions_ChkBox_MPBottomLeft:GetChecked() ) then
		POISONER_CONFIG.Menu.Position = "bottomleft";
		Poisoner_SetPosition("bottomleft")
	elseif ( PoisonerOptions_ChkBox_MPBottomRight:GetChecked() ) then
		POISONER_CONFIG.Menu.Position = "bottomright";
		Poisoner_SetPosition("bottomright")
	end
	
	if ( PoisonerOptions_ChkBox_ToolTipFull:GetChecked() ) then
		POISONER_CONFIG.TooltipType = "full";
	elseif ( PoisonerOptions_ChkBox_ToolTipName:GetChecked() ) then
		POISONER_CONFIG.TooltipType = "name";
	end
	
	if ( PoisonerOptions_ChkBox_OverwritePreset:GetChecked() ) then
		POISONER_CONFIG.Preset.Overwrite = 1;
	else
		POISONER_CONFIG.Preset.Overwrite = 0;
	end
	if ( PoisonerOptions_ChkBox_PoisonWeaponChatOuput:GetChecked() ) then
		POISONER_CONFIG.PrintClickedPoison = 1;
	else
		POISONER_CONFIG.PrintClickedPoison = 0;
	end
	
	if ( PoisonerOptions_ChkBox_ShowOnMouseover:GetChecked() ) then
		POISONER_CONFIG.Menu.ShowOnMouseover = 1;
	else
		POISONER_CONFIG.Menu.ShowOnMouseover = 0;
	end
	if ( PoisonerOptions_ChkBox_AutoHide_inCombat:GetChecked() ) then
		POISONER_CONFIG.Menu.AutoHide.inCombat = 1;
	else
		POISONER_CONFIG.Menu.AutoHide.inCombat = 0;
	end
	
	if ( PoisonerOptions_ChkBox_ShowTimer:GetChecked() ) then
		POISONER_CONFIG.Timer.Active = 1;
		PoisonerTimer_Frame:SetScript("OnUpdate", PoisonerTimer_OnUpdate)
	else
		POISONER_CONFIG.Timer.Active = 0;
		PoisonerTimer_Frame:SetScript("OnUpdate", nil)
		PoisonerTimer_Disable()
	end
	if ( PoisonerOptions_ChkBox_TimerOutput_IgnoreWhileFishing:GetChecked() ) then
		POISONER_CONFIG.Timer.IgnoreWhileFishing = 1;
	else
		POISONER_CONFIG.Timer.IgnoreWhileFishing = 0;
	end	
	if ( PoisonerOptions_ChkBox_TimerOutput_OnlyInstanced:GetChecked() ) then
		POISONER_CONFIG.Timer.OnlyInstanced = 1;
	else
		POISONER_CONFIG.Timer.OnlyInstanced = 0;
	end
	if ( PoisonerOptions_ChkBox_TimerOutput_MainHand:GetChecked() ) then
		POISONER_CONFIG.Timer.Weapon.MainHand = 1;
	else
		POISONER_CONFIG.Timer.Weapon.MainHand = 0;
	end
	if ( PoisonerOptions_ChkBox_TimerOutput_OffHand:GetChecked() ) then
		POISONER_CONFIG.Timer.Weapon.OffHand = 1;
	else
		POISONER_CONFIG.Timer.Weapon.OffHand = 0;
	end
	
	if ( PoisonerOptions_ChkBox_TimerOutput_Aura:GetChecked() ) then
		POISONER_CONFIG.Timer.Output.Aura = 1;
	else
		POISONER_CONFIG.Timer.Output.Aura = 0;
		PoisonerTimer_Mainhand:Hide()
		PoisonerTimer_Offhand:Hide()
	end
	if ( PoisonerOptions_ChkBox_TimerOutput_Aura_Lock:GetChecked() ) then
		POISONER_CONFIG.Timer.Lock = 1;
		PoisonerTimer_UpdateLock();
	else
		POISONER_CONFIG.Timer.Lock = 0;
		PoisonerTimer_UpdateLock();
	end
	if ( PoisonerOptions_ChkBox_TimerOutput_Audio:GetChecked() ) then
		POISONER_CONFIG.Timer.Output.Audio = 1;
	else
		POISONER_CONFIG.Timer.Output.Audio = 0;
	end
	if ( PoisonerOptions_ChkBox_TimerOutput_Chat:GetChecked() ) then
		POISONER_CONFIG.Timer.Output.Chat = 1;
	else
		POISONER_CONFIG.Timer.Output.Chat = 0;
	end
	if ( PoisonerOptions_ChkBox_TimerOutput_ErrorFrame:GetChecked() ) then
		POISONER_CONFIG.Timer.Output.ErrorFrame = 1;
	else
		POISONER_CONFIG.Timer.Output.ErrorFrame = 0;
	end
	
	if ( PoisonerOptions_ChkBox_AutoBuy:GetChecked() ) then
		POISONER_CONFIG.Buy.Active = 1;
	else
		POISONER_CONFIG.Buy.Active = 0;
	end
	if ( PoisonerOptions_ChkBox_AutoBuy_Prompt:GetChecked() ) then
		POISONER_CONFIG.Buy.Prompt = 1;
	else
		POISONER_CONFIG.Buy.Prompt = 0;
	end
	if ( PoisonerOptions_ChkBox_AutoBuy_Check:GetChecked() ) then
		POISONER_CONFIG.Buy.Check = 1;
	else
		POISONER_CONFIG.Buy.Check = 0;
	end
	
	if ( PoisonerOptions_ChkBox_QuickButton_Lock:GetChecked() ) then
		POISONER_CONFIG.Buttons.QuickButton.Lock = 1;
		Poisoner_QuickButton_UpdateLock();
	else
		POISONER_CONFIG.Buttons.QuickButton.Lock = 0;
		Poisoner_QuickButton_UpdateLock();
	end
	
	POISONER_CONFIG.Buttons.FreeButton.Position.Anchor, _, POISONER_CONFIG.Buttons.FreeButton.Position.RelativePoint, POISONER_CONFIG.Buttons.FreeButton.Position.XPos, POISONER_CONFIG.Buttons.FreeButton.Position.YPos = Poisoner_FreeButton:GetPoint()
	
	POISONER_CONFIG.Buttons.FreeButton.Scale = PoisonerOptions_FB_ScaleSlider:GetValue();
	POISONER_CONFIG.Buttons.FreeButton.Alpha = PoisonerOptions_FB_AlphaSlider:GetValue();
	
	POISONER_CONFIG.Buttons.QuickButton.Scale = PoisonerOptions_QB_ScaleSlider:GetValue();
	POISONER_CONFIG.Buttons.QuickButton.Alpha = PoisonerOptions_QB_AlphaSlider:GetValue();
	
	POISONER_CONFIG.Menu.Scale = PoisonerOptions_Menu_ScaleSlider:GetValue();
	POISONER_CONFIG.Menu.Spacing = PoisonerOptions_Menu_SpacingSlider:GetValue();
	
	Poisoner_CreateButtons();
	
end

function PoisonerOptions_ToggleSettings(force)
	if not InCombatLockdown() or force then -- not in combat
		if ( PoisonerOptions_SettingsFrame:IsVisible() ) then
			--PoisonerOptions_SaveSettings();
			PoisonerOptions_SettingsFrame:Hide();
		else
			PoisonerOptionsTab_OnClick(nil, 1);
			PoisonerOptions_LoadSettings();
			PoisonerOptions_SettingsFrame:ClearAllPoints();
			PoisonerOptions_SettingsFrame:SetPoint("CENTER");
			PoisonerOptions_SettingsFrame:Show();
		end
	else 
		PoisonerOptions_SettingsFrame:Hide();
	end
end

function PoisonerOptions_CallUpdate()
	PoisonerOptions.needUpdate = true;
	Poisoner_NoPoison_Warning1 = false;
	Poisoner_NoPoison_Warning2 = false;
	Poisoner_NoPoison_Warning3 = false;
end

function PoisonerOptions_GetPoisonNames()
	--patched out with 4.0.1	--PoisonerOptions_APtitle = SetText(GetItemInfo(21835));	--Beruhigendes Gift
	local t = POISONER_CONFIG.Poisons
	PoisonerOptions_CP_Title:SetText(t[3775].Name or "");	--Verkrüppelndes Gift
	PoisonerOptions_MP_Title:SetText(t[5237].Name or "");	--Gedankenbenebelndes Gift
	PoisonerOptions_DP_Title:SetText(t[2892].Name or "");	--Tödliches Gift
	PoisonerOptions_IP_Title:SetText(t[6947].Name or "");	--Sofort wirkendes Gift
	PoisonerOptions_WP_Title:SetText(t[10918].Name or "");	--Wundgift
	
	--patched out with 4.0.1	--PoisonerOptions_APtitle = SetTextColor(0,0.8,0,1);	--Beruhigendes Gift
	PoisonerOptions_CP_Title:SetTextColor(0,0.8,0,1);	--Verkrüppelndes Gift
	PoisonerOptions_MP_Title:SetTextColor(0,0.8,0,1);	--Gedankenbenebelndes Gift
	PoisonerOptions_DP_Title:SetTextColor(0,0.8,0,1);	--Tödliches Gift
	PoisonerOptions_IP_Title:SetTextColor(0,0.8,0,1);	--Sofort wirkendes Gift
	PoisonerOptions_WP_Title:SetTextColor(0,0.8,0,1);	--Wundgift
end

local PoisonerOptions_BeingDragged
-- Start dragging the frame
function PoisonerOptions_OnDragStart(self)
	self:StartMoving();
	PoisonerOptions_BeingDragged = true;
end

-- Stop dragging the frame
function PoisonerOptions_OnDragStop(self)
	if (PoisonerOptions_BeingDragged) then
		self:StopMovingOrSizing()
		PoisonerOptions_BeingDragged = false;
	end
end

function PoisonerOptionsScaleSlider_OnValueChanged(value)
	PoisonerOptions_CONFIG.Scale = value;
	PoisonerOptions_MainFrame:SetScale(PoisonerOptions_CONFIGScale);
end

function PoisonerOptionsAlphaSlider_OnValueChanged(value)
	PoisonerOptions_CONFIG.Alpha = value;
	PoisonerOptions_MainFrame:SetAlpha(PoisonerOptions_CONFIGAlpha);
end

function PoisonerOptionsTab_OnClick(self, index)
	if ( not index ) then
		index = self:GetID();
	end

	if ( PoisonerOptions_SettingsFrame.numTabs == nil) then
		PanelTemplates_SetNumTabs(PoisonerOptions_SettingsFrame, 5);
	end

	PanelTemplates_SetTab(PoisonerOptions_SettingsFrame, index);
	PoisonerOptions_HideAllSettingFrames();
	if ( index == 1 ) then
		PoisonerOptions_SettingsFrame1:Show();
	elseif ( index == 2 ) then
		PoisonerOptions_SettingsFrame2:Show();
	elseif ( index == 3 ) then
		PoisonerOptions_SettingsFrame3:Show();
	elseif ( index == 4 ) then
		PoisonerOptions_SettingsFrame4:Show();
	elseif ( index == 5 ) then
		PoisonerOptions_SettingsFrame5:Show();
	end
end

function PoisonerOptions_HideAllSettingFrames()
		PoisonerOptions_SettingsFrame1:Hide();
		PoisonerOptions_SettingsFrame2:Hide();
		PoisonerOptions_SettingsFrame3:Hide();
		PoisonerOptions_SettingsFrame4:Hide();
		PoisonerOptions_SettingsFrame5:Hide();
end

-- Move Handler

function PoisonerOptions_MoveSettingsHandler_OnMouseDown(arg1)
	if (arg1 == "LeftButton") then
		PoisonerOptions_SettingsFrame:StartMoving();
	end
end

function PoisonerOptions_MoveSettingsHandler_OnMouseUp(arg1)
	if (arg1 == "LeftButton") then
		PoisonerOptions_SettingsFrame:StopMovingOrSizing();
	end
end


function PoisonerOptions_greyout()

	if (POISONER_CONFIG.Buy.Active == 1) then
		PoisonerOptions_ChkBox_AutoBuy_PromptText:SetTextColor(0.94, 0.77, 0, 1)
	elseif (POISONER_CONFIG.Buy.Active == 0) then
		PoisonerOptions_ChkBox_AutoBuy_PromptText:SetTextColor(0.37647058823529411764705882352941, 0.37647058823529411764705882352941, 0.37647058823529411764705882352941, 1)
	end

end

function PoisonerOptions_ResetPresets()
	
	POISONER_CONFIG.Preset.Normal = {};
	POISONER_CONFIG.Preset.SHIFT = {};
	POISONER_CONFIG.Preset.CTRL = {};
	POISONER_CONFIG.Preset.ALT = {};
	
	POISONER_CONFIG.Preset.Normal = {
		Mainhand = 1,
		Offhand = 1,
		}
	POISONER_CONFIG.Preset.SHIFT = {
		Mainhand = 1,
		Offhand = 1,
		}
	POISONER_CONFIG.Preset.CTRL = {
		Mainhand = 1,
		Offhand = 1,
		}
	POISONER_CONFIG.Preset.ALT = {
		Mainhand = 1,
		Offhand = 1,
		}
	
	PoisonerDropDown_SelectPresetPoison("Mainhand", POISONER_CONFIG.Preset.Normal.Mainhand, "Normal")
	PoisonerDropDown_SelectPresetPoison("Mainhand", POISONER_CONFIG.Preset.SHIFT.Mainhand, "SHIFT")
	PoisonerDropDown_SelectPresetPoison("Mainhand", POISONER_CONFIG.Preset.CTRL.Mainhand, "CTRL")
	PoisonerDropDown_SelectPresetPoison("Mainhand", POISONER_CONFIG.Preset.ALT.Mainhand, "ALT")
	
	PoisonerDropDown_SelectPresetPoison("Offhand", POISONER_CONFIG.Preset.Normal.Offhand, "Normal")
	PoisonerDropDown_SelectPresetPoison("Offhand", POISONER_CONFIG.Preset.SHIFT.Offhand, "SHIFT")
	PoisonerDropDown_SelectPresetPoison("Offhand", POISONER_CONFIG.Preset.CTRL.Offhand, "CTRL")
	PoisonerDropDown_SelectPresetPoison("Offhand", POISONER_CONFIG.Preset.ALT.Offhand, "ALT")
	
end

PoisonerOptions_DoCheckPoisons = 1;
function PoisonerOptions_CheckPoisons()
	
	if ( POISONER_CONFIG.Buy.Check == 1 ) and ( PoisonerOptions_DoCheckPoisons == 1 ) then
	
		local IP = POISONER_CONFIG.Buy.IP
		local CP = POISONER_CONFIG.Buy.CP
		local WP = POISONER_CONFIG.Buy.WP
		local DP = POISONER_CONFIG.Buy.DP
		local MP = POISONER_CONFIG.Buy.MP
		
		local IPc = GetItemCount(6947)
		local CPc = GetItemCount(3775)
		local WPc = GetItemCount(10918)
		local DPc = GetItemCount(2892)
		local MPc = GetItemCount(5237)
	
		if (( IPc ~= 0 ) and ( IPc <= Poisoner_round((IP/10),0) ))
		or (( CPc ~= 0 ) and ( CPc <= Poisoner_round((CP/10),0) ))
		or (( WPc ~= 0 ) and ( WPc <= Poisoner_round((WP/10),0) ))
		or (( DPc ~= 0 ) and ( DPc <= Poisoner_round((DP/10),0) ))
		or (( MPc ~= 0 ) and ( MPc <= Poisoner_round((MP/10),0) ))
		then
			print("|cff00ff00Poisoner|r: "..POISONER_LOWSTOCKWARNING)
			PoisonerSound_PlaySound("lowstock")
			PoisonerOptions_DoCheckPoisons = 0;
			local d=30;
			local u=GetTime()+d;
			local t=u;
			local frame = PoisonerStateHeader
			frame:SetScript("OnUpdate",function() if GetTime()>=t then PoisonerOptions_DoCheckPoisons = 1;t=nil;frame:SetScript("OnUpdate",nil)end end)
		end
		
	end
	
end

function PoisonerOptions_MoveFrame(frame, direction, integer)
--[[

/run PoisonerOptions_MoveFrame(Poisoner_FreeButton, "up", 5)

]]
	local point, relativeTo, relativePoint, xOfs, yOfs = frame:GetPoint()
	local frameName = frame:GetName()
	local relativeToName
	if relativeTo == nil then
		relativeToName = "nil"
	else
		relativeToName = relativeTo:GetName()
	end
	print(frameName..": "..point..", "..relativeToName..", "..relativePoint..", "..Poisoner_round(xOfs,2)..", "..Poisoner_round(yOfs,2))	--Debug
	
	local newX = xOfs
	local newY = yOfs
	
	if direction == "up" then
		newY = yOfs + integer
	elseif direction == "down" then
		newY = yOfs - integer
	elseif direction == "left" then
		newX = xOfs - integer
	elseif direction == "right" then
		newX = xOfs + integer
	end

	frame:SetPoint(point, relativeTo, relativePoint, newX, newY)
	print("New:\n"..frameName..": "..point..", "..relativeToName..", "..relativePoint..", "..Poisoner_round(newX,2)..", "..Poisoner_round(newY,2))	--Debug
end

Poisoner_ShowLDBIcon = 0
function PoisonerOptions_UpdateLDBIcon()
	if (( Poisoner_ShowLDBIcon == 0 ) and ( POISONER_CONFIG.Buttons.LDBIcon.hide == "false" ))then
		PoisonerStateHeader:SetScript("OnUpdate", Poisoner_LDB_Enable);
	else
		PoisonerStateHeader:SetScript("OnUpdate", nil);
		Poisoner_SetPosition()
	end
end

function PoisonerOptions_UpdateMenuPositionCheckbox(checkedBox)

	local boxes = {
		PoisonerOptions_ChkBox_MPTop,
		PoisonerOptions_ChkBox_MPTopLeft,
		PoisonerOptions_ChkBox_MPTopRight,
		PoisonerOptions_ChkBox_MPBottom,
		PoisonerOptions_ChkBox_MPBottomLeft,
		PoisonerOptions_ChkBox_MPBottomRight,
		PoisonerOptions_ChkBox_MPLeft,
		PoisonerOptions_ChkBox_MPRight,
	}

	if not checkedBox or checkedBox == nil then
		checkedBox = PoisonerOptions_ChkBox_MPLeft
	end
	
	checkedBoxName = checkedBox:GetName();
	
	for k,v in pairs(boxes) do
		if v ~= nil then
			vName = v:GetName()
			if vName ~= checkedBoxName then
				v:SetChecked(false)
			end
		end
	end
	checkedBox:SetChecked(true)
	
end

--[[
for k,v in pairs({PoisonerOptions_ChkBox_MPTop,PoisonerOptions_ChkBox_MPBottom,PoisonerOptions_ChkBox_MPLeft,PoisonerOptions_ChkBox_MPRight,}) do _G["v"] end
]]

function PoisonerOptions_ToggleSortingFrames()
	
	local f = _G["PoisonerOptions_SortingFrame"]
	
	if not f or not f:IsVisible() then
		PoisonerOptions_CreateSortingFrames()
	else
		f:Hide()
	end
	
end
local function showTooltip(self, btn)
	GameTooltip:SetOwner(self,"BOTTOMLEFT");
	if (POISONER_CONFIG.TooltipType == "full") then
		GameTooltip:SetBagItem(pbagid,pbagslot);
	else
		GameTooltip:SetText(pttip, 1.00, 1.00, 1.00);
	end
	GameTooltip:Show();
end
function PoisonerOptions_CreateSortingFrames()

	local firstframe = true
	local previousframe
	local minid, maxid = 1, #POISONER_CONFIG.Menu.Sorting
	
	local pf = _G["PoisonerOptions_SortingFrame"]
	if not pf then
		pf = CreateFrame("Frame", "PoisonerOptions_SortingFrame", PoisonerOptions_SettingsFrame2)
		pf:SetPoint("TOPLEFT",_G["PoisonerOptions_SettingsFrame"],"TOPRIGHT",0,-10)
		pf:SetWidth(64)
		pf:SetHeight(((maxid+1)*64))
		
		
	end	
	pf:Show()
	
	local f = _G["PoisonerOptions_SortingFrame_Title"]
	if not f then
		f = CreateFrame("Frame", "PoisonerOptions_SortingFrame_Title", PoisonerOptions_SortingFrame)
		f:SetPoint("TOP",_G["PoisonerOptions_SortingFrame"],"TOP",0,0)
		f:SetWidth(64)
		f:SetHeight(64)
		
		local tmpTexture = f:CreateTexture(f:GetName().."_Icon", "ARTWORK")
		tmpTexture:SetTexture("Interface\\AddOns\\Poisoner\\images\\Poisoner_MMButton")
		tmpTexture:SetAllPoints(f)
		
	end	
	f:Show()
	
	local ItemIDTable = {}
	for itemId,v in pairs(Poisoner_Patterns) do
		if string.match(v, "%d+") == "1" then
			ItemIDTable[string.match(v, "%a+")] = itemId
		end
	end
	
--	for k,v in ipairs(POISONER_CONFIG.Menu.Sorting) do
	for k = 1, #POISONER_CONFIG.Menu.Sorting do
		local v = POISONER_CONFIG.Menu.Sorting[k]
		
		local f = _G["PoisonerOptions_SortingFrame_"..v]
		if not f then
			f = CreateFrame("Frame", "PoisonerOptions_SortingFrame_"..v, PoisonerOptions_SortingFrame, BackdropTemplateMixin and "BackdropTemplate")
			f:SetFrameStrata("BACKGROUND")
			f:SetWidth(64)
			f:SetHeight(64)
			
			
			--Backdrop
			f:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", 
										edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
										tile = true, tileSize = 16, edgeSize = 16, 
										insets = { left = 4, right = 4, top = 4, bottom = 4 }});
			f:SetBackdropColor(0,0,0,1);
			
			local item = POISONER_CONFIG.Poisons[ItemIDTable[v]]
			local text = item.Name
			f:SetScript("OnEnter", function(self)
				GameTooltip:SetOwner(self,"BOTTOMLEFT");
				GameTooltip:SetText(text, 1.00, 1.00, 1.00);
				GameTooltip:Show();
			end)
			f:SetScript("OnLeave", function(self)
				GameTooltip:Hide();
			end)
			
			local texture = item.Texture
			local tmpTexture = f:CreateTexture(f:GetName().."_Icon", "ARTWORK")
			tmpTexture:SetTexture(texture or "Interface\\Icons\\INV_Misc_QuestionMark")
			tmpTexture:SetAllPoints(f)
			
			local upbutton = CreateFrame("Button", "PoisonerOptions_SortingFrame_"..v.."UP", f)
				upbutton:SetWidth(32)
				upbutton:SetHeight(32)
				upbutton:SetNormalTexture("Interface\\Glues\\CharacterSelect\\Glue-Char-Up")
				upbutton:SetHighlightTexture("Interface\\Glues\\CharacterSelect\\Glue-Char-Up-Glow")
				upbutton:SetPoint("TOPLEFT",f,"TOPRIGHT",0,0)
				upbutton:SetScript("OnClick", function()
					local id = f:GetID()
					if id > minid then
						local newID = id - 1 
						f:SetID(newID)
						local self = POISONER_CONFIG.Menu.Sorting[id]
						POISONER_CONFIG.Menu.Sorting[id] = POISONER_CONFIG.Menu.Sorting[newID]
						POISONER_CONFIG.Menu.Sorting[newID] = self
						PoisonerOptions_CreateSortingFrames()
						Poisoner_SortButtons()
					end
				end)
			local downbutton = CreateFrame("Button", "PoisonerOptions_SortingFrame_"..v.."DOWN", f)
				downbutton:SetWidth(32)
				downbutton:SetHeight(32)
				downbutton:SetPoint("BOTTOMLEFT",f,"BOTTOMRIGHT",0,0)
				downbutton:SetNormalTexture("Interface\\Glues\\CharacterSelect\\Glue-Char-Down")
				downbutton:SetHighlightTexture("Interface\\Glues\\CharacterSelect\\Glue-Char-Down-Glow")
				downbutton:SetScript("OnClick", function()
					local id = f:GetID()
					if id < maxid then
						local newID = id + 1 
						f:SetID(newID)
						local self = POISONER_CONFIG.Menu.Sorting[id]
						POISONER_CONFIG.Menu.Sorting[id] = POISONER_CONFIG.Menu.Sorting[newID]
						POISONER_CONFIG.Menu.Sorting[newID] = self
						PoisonerOptions_CreateSortingFrames()
						Poisoner_SortButtons()
					end
				end)
			
		end
		
		f:SetID(k)	
		
		f:ClearAllPoints()
		if firstframe then
			f:SetPoint("TOP",_G["PoisonerOptions_SortingFrame_Title"],"BOTTOM",0,0)
			firstframe = false
		else
			f:SetPoint("TOP",previousframe,"BOTTOM",0,0)
		end

		--Show Frame
		f:Show()
		
		previousframe = f
		
	end
	
end















function PoisonerOptions_OnLoad(self)
		  Poisoner_IsAPVendor = false;
		  Poisoner_IsIPVendor = false;
		  Poisoner_IsCPVendor = false;
		  Poisoner_IsWPVendor = false;
		  Poisoner_IsDPVendor = false;  
		  Poisoner_IsMPVendor = false;
		  Poisoner_IsReagentVendor = false;
	--print("PoisonerOptions_OnLoad");
	self:RegisterEvent("PLAYER_ENTERING_WORLD");
	self:RegisterEvent("MERCHANT_SHOW");
	self:RegisterEvent("MERCHANT_CLOSED");
	self:RegisterEvent('ADDON_LOADED');
	

	StaticPopupDialogs["POISONER_RESTOCK_POISON"] = {
		preferredIndex = STATICPOPUP_NUMDIALOGS,
		text = PoisonerOptions_RestockQuestion,
		button1 = YES,
		button2 = NO,
		OnAccept = function() PoisonerOptions_RestockReagents()  end,
		timeout = 0,
		whileDead = 0,
		hideOnEscape = 1
	}
	
	if not self.SetBackdrop then
		Mixin(self, BackdropTemplateMixin)
		self:SetBackdrop({
			bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
			edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
			edgeSize = 32,
			insets = {left=11, right=12, top=12, bottom=11},
			tile = true,
			tileEdge = true,
			tileSize = 32,
		})
	end
	
end

function PoisonerOptions_CheckDB()
	if (POISONER_CONFIG == nil) then
		POISONER_CONFIG = {};
		POISONER_CONFIG.Version = sub_ver;
		if ( release_ver == ver ) then
			POISONER_CONFIG.Version = release_ver;
		end
		local _, cls = UnitClass("player");
		if (cls == "ROGUE") then
			POISONER_CONFIG.Enabled = 1;
		end
	end
	
	
	if (not POISONER_CONFIG.TooltipType) then
		POISONER_CONFIG.TooltipType = "full";
	end
	
	
	if (not POISONER_CONFIG.Buttons) then
		POISONER_CONFIG.Buttons = {
			FreeButton = { 
				Active = 1,
				Lock = 0,
				Scale = 1,
				Alpha = 1,
				Position = { 
					XPos = 0,
					YPos = 0,
					Anchor = "CENTER",
					RelativeTo = "UIParent",
					RelativePoint = "CENTER",
				},
			},
			LDBIcon = {
				hide = "true",
				},
		}
	end
	if (not POISONER_CONFIG.Buttons.FreeButton.Scale) then
		POISONER_CONFIG.Buttons.FreeButton.Scale = 1;
	end
	if (not POISONER_CONFIG.Buttons.FreeButton.Alpha) then
		POISONER_CONFIG.Buttons.FreeButton.Alpha = 1;
	end
	
	if (not POISONER_CONFIG.Menu) then
		POISONER_CONFIG.Menu = {
			Parent = "Poisoner_FreeButton",
			Position = "bottomleft",
			Scale = 1,
			Spacing = 0,
			AutoHide = {
				Active = 0,
				Time = 10,
			},
			ShowOnMouseover = 0,
		}
	end
	if ( not POISONER_CONFIG.Menu.Scale ) or ( POISONER_CONFIG.Menu.Scale == nil ) then
		POISONER_CONFIG.Menu.Scale = 1;
		PoisonerMenu:SetScale(1.0);
	end
	if ( not POISONER_CONFIG.Menu.Spacing ) or ( POISONER_CONFIG.Menu.Spacing == nil ) then
		POISONER_CONFIG.Menu.Spacing = 0;
	end
	if (POISONER_CONFIG.Menu.Scale ~= nil) then
		PoisonerMenu:SetScale(POISONER_CONFIG.Menu.Scale);
	end
	if ( not POISONER_CONFIG.Menu.AutoHide ) then
		POISONER_CONFIG.Menu.AutoHide = {
			Active = 0,
			Time = 10,
			inCombat = 0,
		}
	end
	if not POISONER_CONFIG.Menu.ShowOnMouseover then
		POISONER_CONFIG.Menu.ShowOnMouseover = 0
	end
	if ( not POISONER_CONFIG.Menu.AutoHide.Active ) then
		POISONER_CONFIG.Menu.AutoHide.Active = 0;
	end
	if ( not POISONER_CONFIG.Menu.AutoHide.Time ) then
		POISONER_CONFIG.Menu.AutoHide.Time = 10;
	end
	if ( not POISONER_CONFIG.Menu.AutoHide.inCombat ) then
		POISONER_CONFIG.Menu.AutoHide.inCombat = 0;
	end
	
	local sorting = {
			[1] = "IP",--"Sofort wirkendes Gift",
			[2] = "DP",--"Tödliches Gift",
			[3] = "WP",--"Wundgift",
			[4] = "MP",--"Gedankenbenebelndes Gift",
			[5] = "CP",--"Verkrüppelndes Gift",
			[6] = "SS",--Wetzsteine
			[7] = "WS",--Gewichtssteine
		}
	if not POISONER_CONFIG.Menu.Sorting then
		POISONER_CONFIG.Menu.Sorting = sorting
	elseif #sorting > #POISONER_CONFIG.Menu.Sorting then
		for i=1,#sorting do
			local entry = sorting[i]
			local found
			for k,v in pairs(POISONER_CONFIG.Menu.Sorting) do
				if v == entry then
					found = true
					break
				end
			end
			if not found then
				table.insert(POISONER_CONFIG.Menu.Sorting, entry)
			end
		end
	end
	

	if (not POISONER_CONFIG.PrintClickedPoison) then
		POISONER_CONFIG.PrintClickedPoison = 1;
	end
	
	
	if (POISONER_CONFIG.Preset == nil) then
		POISONER_CONFIG.Preset = {};
	end
	if (POISONER_CONFIG.Preset.Overwrite == nil) then
		POISONER_CONFIG.Preset.Overwrite = 0;
	end
	if (POISONER_CONFIG.Preset.Normal == nil) then
		POISONER_CONFIG.Preset.Normal = {};
	end
	if (POISONER_CONFIG.Preset.SHIFT == nil) then
		POISONER_CONFIG.Preset.SHIFT = {};
	end
	if (POISONER_CONFIG.Preset.CTRL == nil) then
		POISONER_CONFIG.Preset.CTRL = {};
	end
	if (POISONER_CONFIG.Preset.ALT == nil) then
		POISONER_CONFIG.Preset.ALT = {};
	end
	if ( not POISONER_CONFIG.Preset.Normal.Mainhand ) then
		POISONER_CONFIG.Preset.Normal.Mainhand = 1;
	end
	if ( not POISONER_CONFIG.Preset.Normal.Offhand ) then
		POISONER_CONFIG.Preset.Normal.Offhand = 1;
	end
	
	if ( not POISONER_CONFIG.Preset.SHIFT.Mainhand ) then
		POISONER_CONFIG.Preset.SHIFT.Mainhand = 1;
	end
	if ( not POISONER_CONFIG.Preset.SHIFT.Offhand ) then
		POISONER_CONFIG.Preset.SHIFT.Offhand = 1;
	end
	
	if ( not POISONER_CONFIG.Preset.CTRL.Mainhand ) then
		POISONER_CONFIG.Preset.CTRL.Mainhand = 1;
	end
	if ( not POISONER_CONFIG.Preset.CTRL.Offhand ) then
		POISONER_CONFIG.Preset.CTRL.Offhand = 1;
	end
	
	if ( not POISONER_CONFIG.Preset.ALT.Mainhand ) then
		POISONER_CONFIG.Preset.ALT.Mainhand = 1;
	end
	if ( not POISONER_CONFIG.Preset.ALT.Offhand ) then
		POISONER_CONFIG.Preset.ALT.Offhand = 1;
	end
	
	
	if (POISONER_CONFIG.Timer == nil) then
		POISONER_CONFIG.Timer = {};
	end		
	if (not POISONER_CONFIG.Timer.Position) then
	POISONER_CONFIG.Timer.Position = { 
		XPos = 0,
		YPos = 100,
		Anchor = "CENTER",
		RelativeTo = "UIParent",
		RelativePoint = "CENTER",
		Parent = nil,
		OnlyInstanced = 0,
		}
	end
	if (not POISONER_CONFIG.Timer.Output) then
	POISONER_CONFIG.Timer.Output = {
		Audio = 1,
		Chat = 1,
		ErrorFrame = 1,
		Aura = 1,
		}
	end
	if (not POISONER_CONFIG.Timer.Weapon) then
	POISONER_CONFIG.Timer.Weapon = {
		MainHand = 1,
		OffHand = 1,
		}
	end
	if ( not POISONER_CONFIG.Timer.Scale ) then
		POISONER_CONFIG.Timer.Scale = 1;
	end
	if ( not POISONER_CONFIG.Timer.Alpha ) then
		POISONER_CONFIG.Timer.Alpha = 1;
	end
	if ( not POISONER_CONFIG.Timer.Active ) then
		POISONER_CONFIG.Timer.Active = 1;
	end
	if ( not POISONER_CONFIG.Timer.Lock ) then
		POISONER_CONFIG.Timer.Lock = 1;
	end
	if ( not POISONER_CONFIG.Timer.Output.Audio ) then
		POISONER_CONFIG.Timer.Output.Audio = 1;
	end
	if ( not POISONER_CONFIG.Timer.Output.Chat ) then
		POISONER_CONFIG.Timer.Output.Chat = 1;
	end
	if ( not POISONER_CONFIG.Timer.Output.ErrorFrame ) then
		POISONER_CONFIG.Timer.Output.ErrorFrame = 1;
	end
	if ( not POISONER_CONFIG.Timer.Output.Aura ) then
		POISONER_CONFIG.Timer.Output.Aura = 1;
	end
	if ( not POISONER_CONFIG.Timer.IgnoreWhileFishing ) then
		POISONER_CONFIG.Timer.IgnoreWhileFishing = 0;
	end
	if ( not POISONER_CONFIG.Timer.OnlyInstanced ) then
		POISONER_CONFIG.Timer.OnlyInstanced = 0;
	end
	
	
	if (POISONER_CONFIG.Buttons.QuickButton == nil) then
		POISONER_CONFIG.Buttons.QuickButton = {};
	end		
	if ( not POISONER_CONFIG.Buttons.QuickButton.Lock ) then
		POISONER_CONFIG.Buttons.QuickButton.Lock = 1;
	end
	if (not POISONER_CONFIG.Buttons.QuickButton.Position) then
	POISONER_CONFIG.Buttons.QuickButton.Position = { 
		XPos = 0,
		YPos = 0,
		Anchor = "CENTER",
		RelativeTo = "UIParent",
		RelativePoint = "CENTER",
		Parent = nil,
		}
	end
	if ( not POISONER_CONFIG.Buttons.QuickButton.Scale ) then
		POISONER_CONFIG.Buttons.QuickButton.Scale = 1;
	end
	if ( not POISONER_CONFIG.Buttons.QuickButton.Alpha ) then
		POISONER_CONFIG.Buttons.QuickButton.Alpha = 1;
	end
	
	
	if (not POISONER_CONFIG.Poisons) then
		POISONER_CONFIG.Poisons = {}
		Poisoner_GetPoisonNames();
	end

	if (POISONER_CONFIG.Buy == nil) then
		POISONER_CONFIG.Buy = {};
	end
	if ( not POISONER_CONFIG.Buy.Active) then
		POISONER_CONFIG.Buy.Active = 1;
	end
	if ( not POISONER_CONFIG.Buy.Prompt) then
		POISONER_CONFIG.Buy.Prompt = 0;
	end
	if ( not POISONER_CONFIG.Buy.Check) then
		POISONER_CONFIG.Buy.Check = 1;
	end
	if (not POISONER_CONFIG.Buy.IP) then POISONER_CONFIG.Buy.IP = 0 end
	if (not POISONER_CONFIG.Buy.CP) then POISONER_CONFIG.Buy.CP = 0 end
	if (not POISONER_CONFIG.Buy.WP) then POISONER_CONFIG.Buy.WP = 0 end
	if (not POISONER_CONFIG.Buy.DP) then POISONER_CONFIG.Buy.DP = 0 end
	if (not POISONER_CONFIG.Buy.MP) then POISONER_CONFIG.Buy.MP = 0 end
	if (not POISONER_CONFIG.Timer.WarningThreshold) then POISONER_CONFIG.Timer.WarningThreshold = 2 end
	
end

function PoisonerOptions_OnEvent(self, event, arg1)
	if event == "ADDON_LOADED" and arg1 == "Poisoner" then
		
		PoisonerOptions_CheckDB()
		
		if (POISONER_CONFIG.Buttons.FreeButton.Active == 1) then
			Poisoner_FreeButton:Show()
		elseif (POISONER_CONFIG.Buttons.FreeButton.Active == 0) then			
			Poisoner_FreeButton:Hide()
		end
		
		Poisoner_LDB_OnEnable();
		if (POISONER_CONFIG.Buttons.LDBIcon.hide == "false") then
			PoisonerOptions_UpdateLDBIcon();
		end
		if (POISONER_CONFIG.Menu.Parent == "Minimap") then
			POISONER_CONFIG.Buttons.LDBIcon.hide = "false";
			PoisonerOptions_UpdateLDBIcon();
			print("Poisoner: Parent=Minimap => LDB_Enable");
		elseif (POISONER_CONFIG.Menu.Parent == "Poisoner_FreeButton") then
			--POISONER_CONFIG.Buttons.LDBIcon.hide = "true";
			--Poisoner_FreeButton:Show();
		end
		
		Poisoner_WarningThreshold = POISONER_CONFIG.Timer.WarningThreshold
		PoisonerOptions_PoisonTimerSlider:SetValue(Poisoner_WarningThreshold)
		
		Poisoner_FreeButton:ClearAllPoints()
		Poisoner_FreeButton:SetPoint(POISONER_CONFIG.Buttons.FreeButton.Position.Anchor, POISONER_CONFIG.Buttons.FreeButton.Position.RelativeTo, POISONER_CONFIG.Buttons.FreeButton.Position.RelativePoint, POISONER_CONFIG.Buttons.FreeButton.Position.XPos, POISONER_CONFIG.Buttons.FreeButton.Position.YPos)
		Poisoner_FreeButton:SetScale(POISONER_CONFIG.Buttons.FreeButton.Scale)
		Poisoner_FreeButton:SetAlpha(POISONER_CONFIG.Buttons.FreeButton.Alpha)
		Poisoner_FreeButton:Show()
		
		PoisonerTimer_IconFrame:ClearAllPoints()
		PoisonerTimer_IconFrame:SetPoint(POISONER_CONFIG.Timer.Position.Anchor, POISONER_CONFIG.Timer.Position.RelativeTo, POISONER_CONFIG.Timer.Position.RelativePoint, POISONER_CONFIG.Timer.Position.XPos, POISONER_CONFIG.Timer.Position.YPos)
		PoisonerTimer_IconFrame:SetScale(POISONER_CONFIG.Timer.Scale)
		PoisonerTimer_IconFrame:SetAlpha(POISONER_CONFIG.Timer.Alpha)
		PoisonerTimer_IconFrame:Show()
		
		Poisoner_QuickButton_CreateOverlay();
		Poisoner_QuickButton_UpdateLock();		
		Poisoner_QuickButton_Overlay:ClearAllPoints()
		Poisoner_QuickButton_Overlay:SetPoint(POISONER_CONFIG.Buttons.QuickButton.Position.Anchor, POISONER_CONFIG.Buttons.QuickButton.Position.RelativeTo, POISONER_CONFIG.Buttons.QuickButton.Position.RelativePoint, POISONER_CONFIG.Buttons.QuickButton.Position.XPos, POISONER_CONFIG.Buttons.QuickButton.Position.YPos)
		Poisoner_QuickButton_Overlay:SetScale(POISONER_CONFIG.Buttons.QuickButton.Scale)
		Poisoner_QuickButton_Overlay:SetAlpha(POISONER_CONFIG.Buttons.QuickButton.Alpha)
		Poisoner_QuickButton_Overlay:Show()
		
		Poisoner_GetPoisonNames();
		
		Poisoner_DropDownMenu_CreateFrames();
		
		PoisonerDropDown_SelectPresetPoison("Mainhand", POISONER_CONFIG.Preset.Normal.Mainhand, "Normal")
		PoisonerDropDown_SelectPresetPoison("Mainhand", POISONER_CONFIG.Preset.SHIFT.Mainhand, "SHIFT")
		PoisonerDropDown_SelectPresetPoison("Mainhand", POISONER_CONFIG.Preset.CTRL.Mainhand, "CTRL")
		PoisonerDropDown_SelectPresetPoison("Mainhand", POISONER_CONFIG.Preset.ALT.Mainhand, "ALT")
		
		PoisonerDropDown_SelectPresetPoison("Offhand", POISONER_CONFIG.Preset.Normal.Offhand, "Normal")
		PoisonerDropDown_SelectPresetPoison("Offhand", POISONER_CONFIG.Preset.SHIFT.Offhand, "SHIFT")
		PoisonerDropDown_SelectPresetPoison("Offhand", POISONER_CONFIG.Preset.CTRL.Offhand, "CTRL")
		PoisonerDropDown_SelectPresetPoison("Offhand", POISONER_CONFIG.Preset.ALT.Offhand, "ALT")
		
		if ( POISONER_CONFIG.Timer.Active == 1 ) and (POISONER_CONFIG.Enabled == 1) then
			PoisonerTimer_Frame:SetScript("OnUpdate", PoisonerTimer_OnUpdate)
		end
		
		PoisonerOptions_SettingsFrameTitleString:SetText("Poisoner |cff8080ff"..GetAddOnMetadata("Poisoner", "Version").."|r")
		
		PoisonerOptionsTab_OnClick(self, 1);
		PoisonerOptions_SettingsFrame:Hide();
		Poisoner_SetPosition();
		
		self:UnregisterEvent("ADDON_LOADED");
		
	elseif (event == "MERCHANT_SHOW") then
			--print("PoisonerOptions_MerchantShow")
			Poisoner_MerchantIsShown = true
			
			Poisoner_ReagentsMissing = false 
			Poisoner_IsAPVendor = false 
			Poisoner_IsIPVendor = false
			Poisoner_IsCPVendor = false 
			Poisoner_IsWPVendor = false 
			Poisoner_IsDPVendor = false
			Poisoner_IsMPVendor = false  
			Poisoner_IsReagentVendor = false
			
			local IP = POISONER_CONFIG.Buy.IP
			local CP = POISONER_CONFIG.Buy.CP
			local WP = POISONER_CONFIG.Buy.WP
			local DP = POISONER_CONFIG.Buy.DP
			local MP = POISONER_CONFIG.Buy.MP

			if GetItemCount(6947) < IP
			or GetItemCount(3775) < CP
			or GetItemCount(10918) < WP
			or GetItemCount(2892) < DP
			or GetItemCount(5237) < MP

			then Poisoner_ReagentsMissing = true
			end

			for i = 1, GetMerchantNumItems(), 1 do
				local name, texture, price, quantity, numAvailable, isUsable, extendedCost = GetMerchantItemInfo(i)
				if name then
					if name == GetItemInfo(6947) then
						Poisoner_IsIPVendor = true 
					elseif name == GetItemInfo(3775) then
						Poisoner_IsCPVendor = true 
					elseif name == GetItemInfo(10918) then
						Poisoner_IsWPVendor = true 
					elseif name == GetItemInfo(2892) then
						Poisoner_IsDPVendor = true 
					elseif name == GetItemInfo(5237) then
						Poisoner_IsMPVendor = true 
					end
				end
			end

			if (Poisoner_IsAPVendor or Poisoner_IsIPVendor or Poisoner_IsCPVendor or Poisoner_IsWPVendor or Poisoner_IsDPVendor or Poisoner_IsMPVendor) then 
				Poisoner_IsReagentVendor = true
			end
			
			if (Poisoner_IsReagentVendor and Poisoner_ReagentsMissing and (POISONER_CONFIG.Buy.Prompt == 0) and (POISONER_CONFIG.Buy.Active == 1)) then
				StaticPopup_Show("POISONER_RESTOCK_POISON")
			elseif (Poisoner_IsReagentVendor and Poisoner_ReagentsMissing and (POISONER_CONFIG.Buy.Active == 1)) then
				PoisonerOptions_RestockReagents()
			end
		
	elseif (event == "MERCHANT_CLOSED") then
		--print("PoisonerOptions_MerchantClosed")
		Poisoner_MerchantIsShown = false
		StaticPopup_Hide("POISONER_RESTOCK_POISON")
		Poisoner_ReCountPoisons()
		Poisoner_CreateButtons()
	end
end


	

function PoisonerOptions_RestockReagents()

	--DEFAULT_CHAT_FRAME:AddMessage("RestockReagents")
	
	local IP = POISONER_CONFIG.Buy.IP
	local CP = POISONER_CONFIG.Buy.CP
	local WP = POISONER_CONFIG.Buy.WP
	local DP = POISONER_CONFIG.Buy.DP
	local MP = POISONER_CONFIG.Buy.MP
	
	local IPIndex, CPIndex, WPIndex, DPIndex, MPIndex
	for i = 1, GetMerchantNumItems(), 1 do
		local name, texture, price, quantity, numAvailable, isUsable, extendedCost = GetMerchantItemInfo(i)
		if name then
			if name == GetItemInfo(6947) then
				IPIndex = i
			end
			if name == GetItemInfo(3775) then
				CPIndex = i
			end
			if name == GetItemInfo(10918) then
				WPIndex = i
			end
			if name == GetItemInfo(2892) then
				DPIndex = i
			end
			if name == GetItemInfo(5237) then
				MPIndex = i
			end
		end
	end

 
		local tempIP = GetItemCount(6947)
		if tempIP < IP and Poisoner_IsIPVendor then
			local calcIP = IP - tempIP
			while calcIP > 20 do
				BuyMerchantItem(IPIndex, 20)
				calcIP = calcIP - 20
			end
			BuyMerchantItem(IPIndex, calcIP)
		end
		local tempCP = GetItemCount(3775)
		if tempCP < CP and Poisoner_IsCPVendor then
			local calcCP = CP - tempCP
			while calcCP > 20 do
				BuyMerchantItem(CPIndex, 20)
				calcCP = calcCP - 20
			end
			BuyMerchantItem(CPIndex, calcCP)
		end	

		local tempWP = GetItemCount(10918)
		 if tempWP < WP and Poisoner_IsWPVendor then
			local calcWP = WP - tempWP
			while calcWP > 20 do
				BuyMerchantItem(WPIndex, 20)
				calcWP = calcWP - 20
			end
			BuyMerchantItem(WPIndex, calcWP)
		end
  
		local tempDP = GetItemCount(2892)
		if tempDP < DP and Poisoner_IsDPVendor then
			local calcDP = DP - tempDP
			while calcDP > 20 do
				BuyMerchantItem(DPIndex, 20)
				calcDP = calcDP - 20
			end
			BuyMerchantItem(DPIndex, calcDP)
		end
  
		local tempMP = GetItemCount(5237)
		if tempMP < MP and Poisoner_IsMPVendor then
			local calcMP = MP - tempMP
			while calcMP > 20 do
				BuyMerchantItem(MPIndex, 20)
				calcMP = calcMP - 20
			end
			BuyMerchantItem(MPIndex, calcMP)
		end
	
end
