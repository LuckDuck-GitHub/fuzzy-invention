
local ExpPoison = "Poisoner_ExpPoison_EnUS-EnGB.ogg"
local NoPoison = "Poisoner_NoPoison_EnUS-EnGB.ogg"
local LowStock = "Poisoner_Stock_EnUS-EnGB.ogg"

if (GetLocale() == "deDE") then
	ExpPoison = "Poisoner_ExpPoison_deDE.ogg"
	NoPoison = "Poisoner_NoPoison_deDE.ogg"
	LowStock = "Poisoner_Stock_deDE.ogg"
elseif (GetLocale() == "frFR") then
	ExpPoison = "Poisoner_ExpPoison_frFR.ogg"
	--NoPoison = "Poisoner_NoPoison_frFR.ogg"
	LowStock = "Poisoner_Stock_frFR.ogg"
else
	ExpPoison = "Poisoner_ExpPoison_EnUS-EnGB.ogg"
	NoPoison = "Poisoner_NoPoison_EnUS-EnGB.ogg"
	LowStock = "Poisoner_Stock_EnUS-EnGB.ogg"
end

local soundfolder = "Interface\\AddOns\\Poisoner\\sounds\\";

PoisonerSound_ExpirationDelay = 0
PoisonerSound_NoPoisonDelay = 0
function PoisonerSound_PlaySound(cmd)
	if (cmd == "expiring") then
		if PoisonerSound_ExpirationDelay == 0 then
			PlaySoundFile(soundfolder..ExpPoison, "Master");
			
			PoisonerSound_ExpirationDelay = 1
			local d=30;
			local u=GetTime()+d;
			local t=u;
			local frame = PoisonerSound_Frame
			frame:SetScript("OnUpdate",function() if GetTime()>=t then PoisonerSound_ExpirationDelay=0;PoisonerSound_NoPoisonDelay=0;t=nil;frame:SetScript("OnUpdate",nil)end end)
		end
	elseif (cmd == "nopoison") then
		if PoisonerSound_NoPoisonDelay == 0 then
			PlaySoundFile(soundfolder..NoPoison, "Master");
		
			PoisonerSound_NoPoisonDelay = 1
			local d=30;
			local u=GetTime()+d;
			local t=u;
			local frame = PoisonerSound_Frame
			frame:SetScript("OnUpdate",function() if GetTime()>=t then PoisonerSound_ExpirationDelay=0;PoisonerSound_NoPoisonDelay=0;t=nil;frame:SetScript("OnUpdate",nil)end end)

		end
	elseif (cmd == "lowstock") then
		PlaySoundFile(soundfolder..LowStock, "Master");
	end
end