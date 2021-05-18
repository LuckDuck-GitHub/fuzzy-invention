if  (GetLocale() == "koKR") then
--
-- Other internal strings
--

-- the pattern to search for in a tooltip for the number of charges
-- remaining on an expendable item
POISONER_PATTERN_CHARGES = "^(%d+) 변경$";

--
-- Display strings
--

POISONER_TITLE = "|cff00ff00Poisoner|r";

-- tooltip strings
POISONER_MINIMAPBUTTON_TIP1 = "Poisoner";
-- error messages
POISONER_COMMANDERROR = "알 수 없는 poisoner 명령어: ";
POISONER_DRAGERROR = "poisoner 단추 끌기 오류";
POISONER_POSITIONERROR = "알 수 없는 위치 설정";
POISONER_LOWSTOCKWARNING = "일부 독의 재고가 10% 미만입니다. 어서 상인을 방문하세요!";

-- PopUp messages
POISONER_NOTAROGUE = "캐릭터가 도적이 아닙니다.\n 상관없이 Poisoner를 활성화하시겠습니까?";
POISONER_DELSVARSCHANGED = "저장된 변수 코드가 크게 변경되어 Poisoner 구성이 삭제되었습니다.";
POISONER_THANKYOUTEXT = POISONER_TITLE.."를 배포하고 테스트한 다음 사람들에게 '감사합니다!'.";
POISONER_WELCOME4 = "|cff00ff00Poisoner4|r에 온 것을 환영합니다.\n\nPoisoner4에는 다음과 같은 유용한 새 기능이 있습니다:\n\n- 전투중에 메뉴 전환\n\n- 4개의 사용자 정의 독 설정이 있는 빠른 단추 (전투중에 변경 가능)\n\n- 무기 마법부여를 위한 타이머\n\n- 독을 자동으로 재구매하는 자동 구매 기능\n\n- 단추 외관 지원";

-- UI labels
PoisonerOptions_SETTINGS = "Poisoner";
PoisonerOptions_SETTINGS1 = GAMEOPTIONS_MENU; --"Options"
PoisonerOptions_SETTINGS2 = "메뉴";		--"Menu"
PoisonerOptions_SETTINGS3 = "타이머";		--"Timer"
PoisonerOptions_SETTINGS4 = "자동 구매";	--"AutoBuy"		--MINIMAP_TRACKING_VENDOR_POISON;		--"Poisons"
PoisonerOptions_SETTINGS5 = "독 설정";		--"Poison sets"
PoisonerOptions_SETTINGS_CLOSE = "닫기";
PoisonerOptions_SETTINGS_SAVE = "저장";
PoisonerOptions_LB_Scale = "크기";
PoisonerOptions_LB_Alpha = "투명도";

-- messages
Poisoner_ToopTipTitle_CurrentPoisonSet = "현재 독 설정:";

--Buttons / Menu
PoisonerOptions_LB_OptionsTitle = "-= "..GAMEOPTIONS_MENU.." =-";
PoisonerOptions_LB_Enable = "|cff1eff00Poisoner|r 활성화";
PoisonerOptions_LB_MBTitle = "Poisoner 단추:";
PoisonerOptions_LB_MBName = "Poisoner 미니맵 단추";
PoisonerOptions_LB_FBName = "Poisoner 자유 단추";
PoisonerOptions_LB_MBShow = PoisonerOptions_LB_MBName.." 표시";
PoisonerOptions_LB_FBShow = PoisonerOptions_LB_FBName.." 표시";
PoisonerOptions_LB_FBLock = PoisonerOptions_LB_FBName.." 잠금";
PoisonerOptions_LB_FBReset = "위치 재설정";
PoisonerOptions_LB_SOMTitle = "마우스를 올리면 메뉴 (자유 단추)";
PoisonerOptions_LB_SOMChkBox = "마우스를 올리면 독메뉴 전환 (자유 단추)";
PoisonerOptions_LB_AHTitle = "자동 숨김:"
PoisonerOptions_LB_AH_TimeChkBox = "x 초 후에 메뉴를 자동으로 숨깁니다 (아래 슬라이더 사용).";
PoisonerOptions_LB_AH_TimeSlider = "노출 시간";
PoisonerOptions_LB_AH_inCombatChkBox = "전투에 들어가면 메뉴를 자동으로 숨깁니다.";
PoisonerOptions_LB_MenuTitle = "-= 메뉴 =-";
PoisonerOptions_LB_MenuParentTitle = "독메뉴 부모 프레임:";
PoisonerOptions_LB_MenuParentOwn = "자유 단추";
PoisonerOptions_LB_MenuParentMinimap = "미니맵 단추";
PoisonerOptions_LB_MPTitle = "메뉴 위치:";
PoisonerOptions_LB_MPTop = "위쪽";
PoisonerOptions_LB_MPTopLeft = "왼쪽 위";
PoisonerOptions_LB_MPTopRight = "오른쪽 위";
PoisonerOptions_LB_MPBottom = "아래";
PoisonerOptions_LB_MPBottomLeft = "왼쪽 아래";
PoisonerOptions_LB_MPBottomRight = "오른쪽 아래";
PoisonerOptions_LB_MPLeft = "왼쪽";
PoisonerOptions_LB_MPRight = "오른쪽";
PoisonerOptions_LB_MScaleTitle = "메뉴 크기:";
PoisonerOptions_LB_MSpacingTitle = "메뉴 단추 간격:";

PoisonerOptions_LB_ClickSaveToProceed = "진행하려면 |cffFFD100"..PoisonerOptions_SETTINGS_SAVE.."|r을 클릭하세요.";

--ToolTip
PoisonerOptions_LB_TTTitle = "툴팁:";
PoisonerOptions_LB_TTFull = "전부";
PoisonerOptions_LB_TTName = "아이템 이름만";

--Overwrite Preset
PoisonerOptions_LB_OPTitle = "Poisoner 메뉴의 빠른 단추:";
PoisonerOptions_LB_OPActive = "사전 설정 덮어쓰기";
PoisonerOptions_LB_OPInfo = "이 것을 선택하고, Poisoner 메뉴를 통해 독을 적용하면 (|cff0066ff일시적으로|r) 빠른 단추의 해당 사전 설정을 덮어씁니다.";
PoisonerOptions_LB_PWChatOutput = "대화창에 선택한 독 알림";
PoisonerOptions_LB_PresetTitle = "-= 독 사전 설정 =-";

--Timer
PoisonerOptions_LB_TimerTitle = "-= 타이머 =-";
PoisonerOptions_LB_ShowTimer = "만료되는 독의 타이머 표시";
PoisonerOptions_LB_Threshold = "경고 임계 값:";
PoisonerOptions_LB_TimerMinute = "(분)";
PoisonerOptions_LB_Timer_IgnoreWhileFishing = "낚시 중 경고 무시";
PoisonerOptions_LB_Timer_OnlyInstanced = "인스턴스/투기장/전장에 있을 때에만 경고";
PoisonerOptions_LB_WeaponOutput = "확인할 무기:";
PoisonerOptions_LB_TimerOutput = "다음을 통해 독 타이머 경고 표시:";
PoisonerOptions_LB_TimerOutput_Aura = "효과";
PoisonerOptions_LB_TimerOutput_Aura_Lock = "효과 프레임 잠금 / 잠금해제";
PoisonerOptions_LB_TimerOutput_Chat = CHAT_LABEL;	--"Chat"
PoisonerOptions_LB_TimerOutput_RaidWarning = CHAT_MSG_RAID_WARNING;	--"Raid Warning"
PoisonerOptions_LB_TimerOutput_ErrorFrame = "오류창";	--"Error Frame"

--Warning Message		!!! Do not change variables in brackets {} !!!
PoisonerOptions_LB_TimerOutput_Text_Poison = "독"	--Poison
PoisonerOptions_LB_TimerOutput_Text_Minutes = "분"	--min (minutes)
PoisonerOptions_LB_TimerOutput_Text_Seconds = "초"	--sec (seconds)
PoisonerOptions_LB_TimerOutput_Message_Expiration = "{time} {timeformat} 내에 {weapon}의 {poison}이 만료됩니다";	--"Poison on Maindhand expires in 2 min"
PoisonerOptions_LB_TimerOutput_Message_NoPoison = "{weapon}의 |cff00ff00독이|r |cffff0000없습니다|r";	--"Maindhand not poisoned"

--AutoBuy
PoisonerOptions_LB_AutoBuy = "자동화된 독 재구매 기능:";
PoisonerOptions_LB_AutoBuyCheckbox = "자동으로 독 구매";
PoisonerOptions_LB_AutoBuyPrompt = "확인절차 없이 독 구매";
PoisonerOptions_LB_AutoBuyCheck = "재고가 구매할 수량의 10% 미만인 경우 경고합니다.";
PoisonerOptions_LB_AutoBuyTitle = "-= 자동 구매 설정 =-";
PoisonerOptions_LB_AutoBuyAmount = "구매량과 점검 (10% 미만일 경우)\n===================";
PoisonerOptions_LB_AutoBuyInfo = "자동 구매를 설정하려면, 해당 슬라이더를 통해 독의 양을 선택하세요. 선택한 양을 저장하고 구매를 활성화하려면 |cffFFD100"..PoisonerOptions_LB_AutoBuyCheckbox.."|r을 선택하고, 아래의 |cffFFD100"..PoisonerOptions_SETTINGS_SAVE.."|r을 클릭합니다.";

--QuickButton
PoisonerOptions_LB_QuickButton_Name = "빠른 단추";
PoisonerOptions_LB_QuickButton_Lock = "빠른 단추 잠금/잠금해제";

--Questions
PoisonerOptions_RestockQuestion = "선택한 독을 모두 재구매 하시겠습니까?";

--Key Bindings
BINDING_HEADER_Poisoner = "|cff1eff00Poisoner|r";
_G["BINDING_NAME_CLICK Poisoner_FreeButton:LeftButton"] = "메뉴 전환";
BINDING_NAME_PoisonerToggleConfig = "구성 전환";


end
