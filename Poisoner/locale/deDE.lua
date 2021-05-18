if  (GetLocale() == "deDE") then
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
POISONER_COMMANDERROR = "Unbekannter Poisoner Befehl: ";
POISONER_DRAGERROR = "Fehler beim Bewegen des Poisoner-Buttons";
POISONER_POSITIONERROR = "Unbekannte Position-Operation";
POISONER_LOWSTOCKWARNING = "Einige Gift-Vorräte sind unter 10%. Suche einen Händler auf!";

-- PopUp messages
POISONER_NOTAROGUE = "Der Charakter ist kein Schurke.\n Poisoner trotzdem aktivieren?";
POISONER_DELSVARSCHANGED = "Deine Poisoner-Einstellungen wurden aufgrund gravierender Änderungen zurückgesetzt.";
POISONER_THANKYOUTEXT = "Vielen Dank an alle folgenden Personen für Anregungen, Tests, Bug-Reports und Übersetzungen zu "..POISONER_TITLE;
POISONER_WELCOME4 = "Welcome to |cff00ff00Poisoner 4|r.\n\nPoisoner4 has some new usefull features like:\n\n- toggle the Menu while in combat\n\n- a QuickButton with 4 user-defined poison sets (changeable in combat)\n\n- a Timer for your weapon enchants\n\n- a AutoBuy feature to restock poisons automatically\n\n- ButtonFacade support";

-- UI labels
PoisonerOptions_SETTINGS = "Poisoner";
PoisonerOptions_SETTINGS1 = GAMEOPTIONS_MENU; --"Options"
PoisonerOptions_SETTINGS2 = "Menu";		--"Menu"
PoisonerOptions_SETTINGS3 = "Timer";		--"Timer"
PoisonerOptions_SETTINGS4 = "AutoBuy";	--"AutoBuy"		--MINIMAP_TRACKING_VENDOR_POISON;		--"Poisons"
PoisonerOptions_SETTINGS5 = "Gift-Sets";		--"Poison sets"
PoisonerOptions_SETTINGS_CLOSE = "Schließen";
PoisonerOptions_SETTINGS_SAVE = "Speichern";
PoisonerOptions_LB_Scale = "Skalierung";
PoisonerOptions_LB_Alpha = "Alpha";

-- messages
Poisoner_ToopTipTitle_CurrentPoisonSet = "Momentanes Gift-Set:";

--Buttons / Menu
PoisonerOptions_LB_OptionsTitle = "-= "..GAMEOPTIONS_MENU.." =-";
PoisonerOptions_LB_Enable = "Aktiviere |cff1eff00Poisoner|r";
PoisonerOptions_LB_MBTitle = "PoisonerButtons:";
PoisonerOptions_LB_MBName = "PoisonerMinimapButton";
PoisonerOptions_LB_FBName = "Poisoner_FreeButton";
PoisonerOptions_LB_MBShow = "Show "..PoisonerOptions_LB_MBName;
PoisonerOptions_LB_FBShow = "Show "..PoisonerOptions_LB_FBName;
PoisonerOptions_LB_FBLock = "Lock "..PoisonerOptions_LB_FBName;
PoisonerOptions_LB_FBReset = "reset position";
PoisonerOptions_LB_SOMTitle = "Menu bei mouseover (FreeButton)";
PoisonerOptions_LB_SOMChkBox = "Öffne/schließe das Giftmenü bei mouseover (FreeButton)";
PoisonerOptions_LB_AHTitle = "AutoHide:"
PoisonerOptions_LB_AH_ChkBox = "Hide the Menu automatically after x seconds (use the slider below).";
PoisonerOptions_LB_AH_TimeSlider = "Verweildauer";
PoisonerOptions_LB_AH_inCombatChkBox = "Verberge das Menü automatisch wenn im Kampf.";
PoisonerOptions_LB_MenuTitle = "-= Menu =-";
PoisonerOptions_LB_MenuParentTitle = "PoisonMenu Parent frame:";
PoisonerOptions_LB_MenuParentOwn = "FreeButton";
PoisonerOptions_LB_MenuParentMinimap = "MinimapButton";
PoisonerOptions_LB_MPTitle = "Menü-Position:";
PoisonerOptions_LB_MPTop = "Oben";
PoisonerOptions_LB_MPTopLeft = "ObenLinks";
PoisonerOptions_LB_MPTopRight = "ObenRechts";
PoisonerOptions_LB_MPBottom = "Unten";
PoisonerOptions_LB_MPBottomLeft = "UntenLinks";
PoisonerOptions_LB_MPBottomRight = "UntenRechts";
PoisonerOptions_LB_MPLeft = "Links";
PoisonerOptions_LB_MPRight = "Rechts";
PoisonerOptions_LB_MScaleTitle = "Menu-Skalierung:";
PoisonerOptions_LB_MSpacingTitle = "MenuButton-Abstand:";

PoisonerOptions_LB_ClickSaveToProceed = "Klicke |cffFFD100"..PoisonerOptions_SETTINGS_SAVE.."|r zum Übernehmen.";

--ToolTip
PoisonerOptions_LB_TTTitle = "ToolTip:";
PoisonerOptions_LB_TTFull = "Komplett";
PoisonerOptions_LB_TTName = "Nur den Item-Namen";

--Overwrite Preset
PoisonerOptions_LB_OPTitle = "PoisonerMenu to QuickButton:";
PoisonerOptions_LB_OPActive = "Überschreibe presets";
PoisonerOptions_LB_OPInfo = "Falls markiert, wird das Anwenden von Giften via des PoisonerMenu die entspr. presets des QuickButton (|cff0066fftemporär|r) überschreiben.";
PoisonerOptions_LB_PWChatOutput = "Poste gewählte Gifte im Chat";
PoisonerOptions_LB_PresetTitle = "-= Gift-Voreinstellungen =-";

--Timer
PoisonerOptions_LB_TimerTitle = "-= Timer =-";
PoisonerOptions_LB_ShowTimer = "Zeige Warnung für auslaufende Gifte";
PoisonerOptions_LB_Threshold = "Warnschwelle:";
PoisonerOptions_LB_TimerMinute = "(Minuten)";
PoisonerOptions_LB_Timer_IgnoreWhileFishing = "Ignoriere Warnung beim Angeln";
PoisonerOptions_LB_Timer_OnlyInstanced = "nur in Instanzen/Arenen/BGs warnen";
PoisonerOptions_LB_WeaponOutput = "Waffen, die überprüft werden:";
PoisonerOptions_LB_TimerOutput = "Zeige Gift-Timer-Warnung via:";
PoisonerOptions_LB_TimerOutput_Aura = "Aura";
PoisonerOptions_LB_TimerOutput_Aura_Lock = "Aura frame ent-/sperren";
PoisonerOptions_LB_TimerOutput_Chat = CHAT_LABEL;	--"Chat"
PoisonerOptions_LB_TimerOutput_RaidWarning = CHAT_MSG_RAID_WARNING;	--"Raid Warning"
PoisonerOptions_LB_TimerOutput_ErrorFrame = "ErrorFrame";	--"Error Frame"

--Warning Message		!!! Do not change variables in brackets {} !!!
PoisonerOptions_LB_TimerOutput_Text_Poison = "Gift"	--Poison
PoisonerOptions_LB_TimerOutput_Text_Minutes = "min"	--min (minutes)
PoisonerOptions_LB_TimerOutput_Text_Seconds = "sek"	--sec (seconds)
PoisonerOptions_LB_TimerOutput_Message_Expiration = "{poison} auf der {weapon} endet in {time} {timeformat}";	--"Poison on Maindhand expires in 2 min"
PoisonerOptions_LB_TimerOutput_Message_NoPoison = "{weapon} |cffff0000nicht|r |cff00ff00vergiftet|r";	--"Maindhand not poisoned"

--AutoBuy
PoisonerOptions_LB_AutoBuy = "Automatischer Gift-Einkauf:";
PoisonerOptions_LB_AutoBuyCheckbox = "Gifte automatisch kaufen";
PoisonerOptions_LB_AutoBuyPrompt = "Gifte ohne Nachfrage kaufen";
PoisonerOptions_LB_AutoBuyCheck = "Warne, falls Gift-Anzahl unter 10% des gewählten Betrags";
PoisonerOptions_LB_AutoBuyTitle = "-= AutoBuy Optionen =-";
PoisonerOptions_LB_AutoBuyAmount = "Menge, die gekauft & überprüft werden soll (falls unter 10%)\n===================";
PoisonerOptions_LB_AutoBuyInfo = "Um AutoBuy zu nutzen, wähle die Menge Gifte mit Hilfe der entspr. Slider.\nUm die Einstellungen zu speichern und AutoBuy zu aktivieren, hake |cffFFD100"..PoisonerOptions_LB_AutoBuyCheckbox.."|r an und klick unten auf |cffFFD100"..PoisonerOptions_SETTINGS_SAVE.."|r.";

--QuickButton
PoisonerOptions_LB_QuickButton_Name = "QuickButton";
PoisonerOptions_LB_QuickButton_Lock = "Ent-/Sperre den QuickButton";

--Questions
PoisonerOptions_RestockQuestion = "Alle ausgewählten Gifte auffüllen?";

--Key Bindings
BINDING_HEADER_Poisoner = "|cff1eff00Poisoner|r";
_G["BINDING_NAME_CLICK Poisoner_FreeButton:LeftButton"] = "Menu zeigen/verbergen.";
BINDING_NAME_PoisonerToggleConfig = "Konfiguration öffnen/schließen";










end