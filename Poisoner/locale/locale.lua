--
-- Other internal strings
--

-- the pattern to search for in a tooltip for the number of charges
-- remaining on an expendable item
POISONER_PATTERN_CHARGES = "^(%d+) Charges$";

--
-- Display strings
--

POISONER_TITLE = "|cff00ff00Poisoner|r";

-- tooltip strings
POISONER_MINIMAPBUTTON_TIP1 = "Poisoner";
-- error messages
POISONER_COMMANDERROR = "Unknown poisoner command: ";
POISONER_DRAGERROR = "Error dragging poisoner button";
POISONER_POSITIONERROR = "Unknown position option";
POISONER_LOWSTOCKWARNING = "Some Poisons are below 10% stock. Visit a vendor asap!";

-- PopUp messages
POISONER_NOTAROGUE = "Your character is not a rogue.\n Enable Poisoner anyway?";
POISONER_DELSVARSCHANGED = "Your Poisoner config was deleted because of significant changes in its SavedVariables code.";
POISONER_THANKYOUTEXT = "I have to say 'Thank you!' to the following people for distributing to and testing "..POISONER_TITLE;
POISONER_WELCOME4 = "Welcome to |cff00ff00Poisoner 4|r.\n\nPoisoner4 has some new usefull features like:\n\n- toggle the Menu while in combat\n\n- a QuickButton with 4 user-defined poison sets (changeable in combat)\n\n- a Timer for your weapon enchants\n\n- a AutoBuy feature to restock poisons automatically\n\n- ButtonFacade support";

-- UI labels
PoisonerOptions_SETTINGS = "Poisoner";
PoisonerOptions_SETTINGS1 = GAMEOPTIONS_MENU; --"Options"
PoisonerOptions_SETTINGS2 = "Menu";		--"Menu"
PoisonerOptions_SETTINGS3 = "Timer";		--"Timer"
PoisonerOptions_SETTINGS4 = "AutoBuy";	--"AutoBuy"		--MINIMAP_TRACKING_VENDOR_POISON;		--"Poisons"
PoisonerOptions_SETTINGS5 = "Poison sets";		--"Poison sets"
PoisonerOptions_SETTINGS_CLOSE = "Close";
PoisonerOptions_SETTINGS_SAVE = "Save";
PoisonerOptions_LB_Scale = "Scale";
PoisonerOptions_LB_Alpha = "Alpha";

-- messages
Poisoner_ToopTipTitle_CurrentPoisonSet = "Current poison set:";

--Buttons / Menu
PoisonerOptions_LB_OptionsTitle = "-= "..GAMEOPTIONS_MENU.." =-";
PoisonerOptions_LB_Enable = "Enable |cff1eff00Poisoner|r";
PoisonerOptions_LB_MBTitle = "PoisonerButtons:";
PoisonerOptions_LB_MBName = "PoisonerMinimapButton";
PoisonerOptions_LB_FBName = "Poisoner_FreeButton";
PoisonerOptions_LB_MBShow = "Show "..PoisonerOptions_LB_MBName;
PoisonerOptions_LB_FBShow = "Show "..PoisonerOptions_LB_FBName;
PoisonerOptions_LB_FBLock = "Lock "..PoisonerOptions_LB_FBName;
PoisonerOptions_LB_FBReset = "reset position";
PoisonerOptions_LB_SOMTitle = "Menu on mouseover (FreeButton)";
PoisonerOptions_LB_SOMChkBox = "Toggle the PoisonMenu on mouseover (FreeButton)";
PoisonerOptions_LB_AHTitle = "AutoHide:"
PoisonerOptions_LB_AH_TimeChkBox = "Hide the Menu automatically after x seconds (use the slider below).";
PoisonerOptions_LB_AH_TimeSlider = "exposure time";
PoisonerOptions_LB_AH_inCombatChkBox = "Hide the Menu automatically when entering combat.";
PoisonerOptions_LB_MenuTitle = "-= Menu =-";
PoisonerOptions_LB_MenuParentTitle = "PoisonMenu parent frame:";
PoisonerOptions_LB_MenuParentOwn = "FreeButton";
PoisonerOptions_LB_MenuParentMinimap = "MinimapButton";
PoisonerOptions_LB_MPTitle = "Menu position:";
PoisonerOptions_LB_MPTop = "Top";
PoisonerOptions_LB_MPTopLeft = "TopLeft";
PoisonerOptions_LB_MPTopRight = "TopRight";
PoisonerOptions_LB_MPBottom = "Bottom";
PoisonerOptions_LB_MPBottomLeft = "BottomLeft";
PoisonerOptions_LB_MPBottomRight = "BottomRight";
PoisonerOptions_LB_MPLeft = "Left";
PoisonerOptions_LB_MPRight = "Right";
PoisonerOptions_LB_MScaleTitle = "Menu Scale:";
PoisonerOptions_LB_MSpacingTitle = "MenuButton Spacing:";

PoisonerOptions_LB_ClickSaveToProceed = "Click |cffFFD100"..PoisonerOptions_SETTINGS_SAVE.."|r to proceed.";

--ToolTip
PoisonerOptions_LB_TTTitle = "ToolTip:";
PoisonerOptions_LB_TTFull = "Full";
PoisonerOptions_LB_TTName = "Item name only";

--Overwrite Preset
PoisonerOptions_LB_OPTitle = "PoisonerMenu to QuickButton:";
PoisonerOptions_LB_OPActive = "Overwrite presets";
PoisonerOptions_LB_OPInfo = "If checked, applying poisons via the PoisonerMenu will (|cff0066fftemporarily|r) overwrite the corresponding presets of the QuickButton.";
PoisonerOptions_LB_PWChatOutput = "Post choosen Poisons in Chat";
PoisonerOptions_LB_PresetTitle = "-= Poison presets =-";

--Timer
PoisonerOptions_LB_TimerTitle = "-= Timer =-";
PoisonerOptions_LB_ShowTimer = "Show timer for expiring poisons";
PoisonerOptions_LB_Threshold = "Warning Threshold:";
PoisonerOptions_LB_TimerMinute = "(minutes)";
PoisonerOptions_LB_Timer_IgnoreWhileFishing = "Ignore warnings while fishing";
PoisonerOptions_LB_Timer_OnlyInstanced = "warn only if in Instance/Arena/Battleground";
PoisonerOptions_LB_WeaponOutput = "Weapons to check:";
PoisonerOptions_LB_TimerOutput = "Show poison timer warning via:";
PoisonerOptions_LB_TimerOutput_Aura = "Aura";
PoisonerOptions_LB_TimerOutput_Aura_Lock = "Lock / unlock Aura frame";
PoisonerOptions_LB_TimerOutput_Chat = CHAT_LABEL;	--"Chat"
PoisonerOptions_LB_TimerOutput_RaidWarning = CHAT_MSG_RAID_WARNING;	--"Raid Warning"
PoisonerOptions_LB_TimerOutput_ErrorFrame = "ErrorFrame";	--"Error Frame"

--Warning Message		!!! Do not change variables in brackets {} !!!
PoisonerOptions_LB_TimerOutput_Text_Poison = "Poison"	--Poison
PoisonerOptions_LB_TimerOutput_Text_Minutes = "min"	--min (minutes)
PoisonerOptions_LB_TimerOutput_Text_Seconds = "sec"	--sec (seconds)
PoisonerOptions_LB_TimerOutput_Message_Expiration = "{poison} on {weapon} expires in {time} {timeformat}";	--"Poison on Maindhand expires in 2 min"
PoisonerOptions_LB_TimerOutput_Message_NoPoison = "{weapon} |cffff0000not|r |cff00ff00poisoned|r";	--"Maindhand not poisoned"

--AutoBuy
PoisonerOptions_LB_AutoBuy = "Automated poison restock feature:";
PoisonerOptions_LB_AutoBuyCheckbox = "Buy poisons automatically";
PoisonerOptions_LB_AutoBuyPrompt = "Buy Poisons without confirmation";
PoisonerOptions_LB_AutoBuyCheck = "Warn if stock is below 10% of the choosen amount to buy.";
PoisonerOptions_LB_AutoBuyTitle = "-= AutoBuy Options =-";
PoisonerOptions_LB_AutoBuyAmount = "Amount to buy and check for (if below 10%)\n===================";
PoisonerOptions_LB_AutoBuyInfo = "To setup AutoBuy, choose the amount of the poison via the respective slider.\nTo save the choosen amount and enable buying, check |cffFFD100"..PoisonerOptions_LB_AutoBuyCheckbox.."|r and click |cffFFD100"..PoisonerOptions_SETTINGS_SAVE.."|r below.";

--QuickButton
PoisonerOptions_LB_QuickButton_Name = "QuickButton";
PoisonerOptions_LB_QuickButton_Lock = "Lock/Unlock QuickButton";

--Questions
PoisonerOptions_RestockQuestion = "Do you want to restock all choosen poisons?";

--Key Bindings
BINDING_HEADER_Poisoner = "|cff1eff00Poisoner|r";
_G["BINDING_NAME_CLICK Poisoner_FreeButton:LeftButton"] = "Toggle Menu";
BINDING_NAME_PoisonerToggleConfig = "Toggle Config";










