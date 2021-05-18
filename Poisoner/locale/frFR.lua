if  (GetLocale() == "frFR") then

-- Contributors: humfras, TrAsHeR

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
POISONER_COMMANDERROR = "Commande inconnue : ";
POISONER_DRAGERROR = "Une erreur est survenue en faisant glisser le bouton";
POISONER_POSITIONERROR = "Option de position inconnue";
POISONER_LOWSTOCKWARNING = "Certaines piles de poisons sont inférieurs à 10%. Veuillez vous rendre à un vendeur dès que possible.";

-- PopUp messages
POISONER_NOTAROGUE = "Votre personnage n'est pas un voleur.\n Souhaitez-vous activer Poisoner tout de même ?";
POISONER_DELSVARSCHANGED = "La configuration de Poisoner a été supprimée en raison de changements importants dans son code SavedVariables.";
POISONER_THANKYOUTEXT = "Un grand Merci aux personnes suivantes pour leur implication et test de "..POISONER_TITLE;
POISONER_WELCOME4 = "Bienvenue sur |cff00ff00Poisoner 4|r.\n\nPoisoner4 a quelques nouvelles fonctionnalités utiles telles que :\n\n- Possibilité d'afficher / masquer le menu en combat\n\n- Un bouton rapide avec 4 possibilités de sets\n\n- Un timer pour vos enchantements d'armes\n\n- Achat automatique des poisons\n\n- Support de ButtonFacade";

-- UI labels
PoisonerOptions_SETTINGS = "Poisoner";
PoisonerOptions_SETTINGS1 = GAMEOPTIONS_MENU; --"Options"
PoisonerOptions_SETTINGS2 = "Menu";		--"Menu"
PoisonerOptions_SETTINGS3 = "Timer";		--"Timer"
PoisonerOptions_SETTINGS4 = "AutoBuy";	--"AutoBuy"		--MINIMAP_TRACKING_VENDOR_POISON;		--"Poisons"
PoisonerOptions_SETTINGS5 = "Sets de poison";		--"Poison sets"
PoisonerOptions_SETTINGS_CLOSE = "Fermer";
PoisonerOptions_SETTINGS_SAVE = "Sauvegarder";
PoisonerOptions_LB_Scale = "Échelle";
PoisonerOptions_LB_Alpha = "Alpha";

-- messages
Poisoner_ToopTipTitle_CurrentPoisonSet = "Set de poison actuel :";

--Buttons / Menu
PoisonerOptions_LB_OptionsTitle = "-= "..GAMEOPTIONS_MENU.." =-";
PoisonerOptions_LB_Enable = "Activer Poisoner";
PoisonerOptions_LB_MBTitle = "Bouton sur la mini-carte :";
PoisonerOptions_LB_MBName = "Bouton Poisoner sur la mini-carte";
PoisonerOptions_LB_FBName = "Bouton libre";
PoisonerOptions_LB_MBShow = "Afficher le bouton Poisoner sur la mini-carte";
PoisonerOptions_LB_FBShow = "Afficher le bouton libre";
PoisonerOptions_LB_FBLock = "Bloquer le bouton libre";
PoisonerOptions_LB_FBReset = "Réinitialiser la position";
PoisonerOptions_LB_SOMTitle = "Menu après survole (Bouton libre) :";
PoisonerOptions_LB_SOMChkBox = "Afficher le menu lorsque l'on passe la souris sur dessus";
PoisonerOptions_LB_AHTitle = "Masquer automatiquement :"
PoisonerOptions_LB_AH_TimeChkBox = "Hide the Menu automatically after x seconds (use the slider below).";
PoisonerOptions_LB_AH_TimeSlider = "Durée de visibilité";
PoisonerOptions_LB_AH_inCombatChkBox = "Masquer le menu automatiquement lors de l'entrée en combat";
PoisonerOptions_LB_MenuTitle = "-= Menu =-";
PoisonerOptions_LB_MenuParentTitle = "Cadre parent du menu des poisons :";
PoisonerOptions_LB_MenuParentOwn = "Bouton libre";
PoisonerOptions_LB_MenuParentMinimap = "Bouton sur la mini-carte";
PoisonerOptions_LB_MPTitle = "Position du menu :";
PoisonerOptions_LB_MPTop = "En haut";
PoisonerOptions_LB_MPTopLeft = "En haut à gauche";
PoisonerOptions_LB_MPTopRight = "En haut à droite";
PoisonerOptions_LB_MPBottom = "En bas";
PoisonerOptions_LB_MPBottomLeft = "En bas à gauche";
PoisonerOptions_LB_MPBottomRight = "En bas à droite";
PoisonerOptions_LB_MPLeft = "Gauche";
PoisonerOptions_LB_MPRight = "Droite";
PoisonerOptions_LB_MScaleTitle = "Échelle du menu :";
PoisonerOptions_LB_MSpacingTitle = "Espacement entre les boutons :";
 
PoisonerOptions_LB_ClickSaveToProceed = "Cliquez sur |cffFFD100"..PoisonerOptions_SETTINGS_SAVE.."|r pour prendre en compte la modification.";

--ToolTip
PoisonerOptions_LB_TTTitle = "Bulle d'aide :";
PoisonerOptions_LB_TTFull = "Entière";
PoisonerOptions_LB_TTName = "Nom uniquement";

--Overwrite Preset
PoisonerOptions_LB_OPTitle = "Menu de Poisoner face au bouton rapide :";
PoisonerOptions_LB_OPActive = "Écraser les sets préétablis";
PoisonerOptions_LB_OPInfo = "Si coché, l'application de poison via le PoisonerMenu écrasera (|cff0066fftemporairement|r) les sets préétablis correspondant du bouton rapide.";
PoisonerOptions_LB_PWChatOutput = "Afficher les poisons choisis sur le chat";
PoisonerOptions_LB_PresetTitle = "-= Poison presets =-";

--Timer
PoisonerOptions_LB_TimerTitle = "-= Timer =-";
PoisonerOptions_LB_ShowTimer = "Afficher le temps restant pour les poisons expirants";
PoisonerOptions_LB_Threshold = "Seuil d'avertissement :";
PoisonerOptions_LB_TimerMinute = "(minutes)";
PoisonerOptions_LB_Timer_IgnoreWhileFishing = "Ignorer les avertissements lors de la pêche";
PoisonerOptions_LB_Timer_OnlyInstanced = "avertir si seulement dans une instance, un aréna ou champ de bataille";
PoisonerOptions_LB_WeaponOutput = "Armes à vérifier :";
PoisonerOptions_LB_TimerOutput = "Afficher un avertissement du temps des poisons via :";
PoisonerOptions_LB_TimerOutput_Aura = "Aura";
PoisonerOptions_LB_TimerOutput_Aura_Lock = "Bloquer / Débloquer la frame d'aura";
PoisonerOptions_LB_TimerOutput_Chat = CHAT_LABEL;       --"Chat"
PoisonerOptions_LB_TimerOutput_RaidWarning = CHAT_MSG_RAID_WARNING;     --"Raid Warning"
PoisonerOptions_LB_TimerOutput_ErrorFrame = "Frame d'erreur";   --"Error Frame"

--Warning Message               !!! Do not change variables in brackets {} !!!
PoisonerOptions_LB_TimerOutput_Text_Poison = "Poison"   --Poison
PoisonerOptions_LB_TimerOutput_Text_Minutes = "min"     --min (minutes)
PoisonerOptions_LB_TimerOutput_Text_Seconds = "sec"     --sec (seconds)
PoisonerOptions_LB_TimerOutput_Message_Expiration = "{poison} sur {weapon} expire dans {time} {timeformat}";    --"Poison on Maindhand expires in 2 min"
PoisonerOptions_LB_TimerOutput_Message_NoPoison = "{weapon} |cffff0000n'a pas de|r |cff00ff00poison|r"; --"Maindhand not poisoned"

--AutoBuy
PoisonerOptions_LB_AutoBuy = "Fonctionnalité de re-stockage auto. du poison :";
PoisonerOptions_LB_AutoBuyCheckbox = "Acheter les poisons automatiquement";
PoisonerOptions_LB_AutoBuyPrompt = "Acheter les poisons sans confirmation";
PoisonerOptions_LB_AutoBuyCheck = "Avertir si le stock de poison est en dessous de 10%";
PoisonerOptions_LB_AutoBuyTitle = "-= Options d'AutoBuy =-";
PoisonerOptions_LB_AutoBuyAmount = "Quantité à acheter et à vérifier (si > 10%)\n===================";
PoisonerOptions_LB_AutoBuyInfo = "Pour paramétrer AutoBuy, choississez la quantité de poison via le curseur correspondant.\nPour sauvegarder la quantité choisie et activer l'achat, vérifier |cffFFD100"..PoisonerOptions_LB_AutoBuyCheckbox.." |r et cliquez sur |cffFFD100"..PoisonerOptions_SETTINGS_SAVE.."|r ci-dessous.";

--QuickButton
PoisonerOptions_LB_QuickButton_Name = "Bouton rapide";
PoisonerOptions_LB_QuickButton_Lock = "Bloquer / Débloquer le bouton rapide";

--Questions
PoisonerOptions_RestockQuestion = "Voulez-vous réapprovisionner tous les poisons choisis ?";

--Key Bindings
BINDING_HEADER_Poisoner = "|cff1eff00Poisoner|r";
_G["BINDING_NAME_CLICK Poisoner_FreeButton:LeftButton"] = "Afficher / Cacher le menu";
BINDING_NAME_PoisonerToggleConfig = "Afficher / Cacher la config.";

end