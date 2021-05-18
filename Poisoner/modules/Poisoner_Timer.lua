--[[ 

	Poisoner
	¯¯¯¯¯¯¯¯¯¯
	> Timer

]]
-- Colours


local COLOR_BLUE = "|cff0000ff";
local COLOR_GOLD = "|cffcfb52b";
local COLOR_GREEN = "|cff00ff00";	-- Poison
local COLOR_GREY = "|cff808080";
local COLOR_NEON_BLUE = "|cff4d4dff";
local COLOR_ORANGE = "|cffff6d00";
local COLOR_PURPLE = "|cff700090";
local COLOR_RED = "|cffff0000";		-- "not"
local COLOR_WHITE = "|cffffffff";	-- WeaponName
local COLOR_YELLOW = "|cffffff00";
local COLOR_END = "|r";

local function nope() end

local UnitInVehicle = UnitInVehicle or nope

local GetItemInfo = GetItemInfo
local GetItemInfoInstant = GetItemInfoInstant
local GetInventoryItemID = GetInventoryItemID

local _, _, isfishingpole, _, _, fishingPoleId, fishingPoleSubId = GetItemInfoInstant(6256)

local Poisoner_PoisonTimeLeft1, Poisoner_PoisonTimeLeft2
local mainHand_isWeapon, offHand_isWeapon

local MainHand_ID, OffHand_ID
local MainHand_itemType, MainHand_itemSubType, OffHand_itemType, OffHand_itemSubType

local chargeThreshold = 10

--states
local isResting
local inInstance
local isfishing
local inVehicle
local isDead


local EnchantIDsToIgnore = {
	[1783] = true,	--Windfury Totem 1
	[563] = true,	--Windfury Totem 2
	[564] = true,	--Windfury Totem 3
}

local updateDelay, nextUpdate = 1, 1

function PoisonerTimer_OnUpdate(self, elapsed)

	nextUpdate = nextUpdate - elapsed
	if nextUpdate > 0 then
		return
	else
		nextUpdate = updateDelay
	end
	
	local ignorewhilefishing
	--local isfishingpole = select(7,GetItemInfo(6256))
	if (POISONER_CONFIG.Timer.IgnoreWhileFishing == 1) and isfishing then
		ignorewhilefishing = true
	else
		ignorewhilefishing = false
	end
	
	local hasMainHandEnchant, mainHandExpiration, mainHandCharges, mainHandEnchantID, hasOffHandEnchant, offHandExpiration, offHandCharges, offHandEnchantId = GetWeaponEnchantInfo()

	if (POISONER_CONFIG.Enabled == 1) and (POISONER_CONFIG.Timer.Active == 1) and (UnitLevel("player") >= 20) then
		local WarningThreshold = math.floor(Poisoner_WarningThreshold*60000)
		
		if IsMounted() then
			PoisonerTimer_Mainhand:Hide()
			PoisonerTimer_Offhand:Hide()
		elseif isResting
		or UnitInVehicle("player") 
		or UnitIsDead("player") 
		or ignorewhilefishing 
		or (not inInstance and POISONER_CONFIG.Timer.OnlyInstanced == 1)
		or (POISONER_CONFIG.Timer.Weapon.MainHand == 0 and POISONER_CONFIG.Timer.Weapon.OffHand == 0) then
			PoisonerTimer_Disable()
		else
				-- Mainhand weapon
			if mainHand_isWeapon and POISONER_CONFIG.Timer.Weapon.MainHand == 1 and not EnchantIDsToIgnore[mainHandEnchantID] then
				PoisonerTimer_UpdateIconTexture(PoisonerTimer_Mainhand, PoisonerTimer_MainhandIcon, 16)
				if hasMainHandEnchant then 
					Poisoner_PoisonTimeLeft1 = Poisoner_round((mainHandExpiration/60000), 0);	--math.floor(mainHandExpiration/60000)
					local timeformat = PoisonerOptions_LB_TimerOutput_Text_Minutes
					if mainHandExpiration <= 30000 then
						Poisoner_PoisonTimeLeft1 = Poisoner_round((mainHandExpiration/1000), 0);
						timeformat = PoisonerOptions_LB_TimerOutput_Text_Seconds
					end
					Poisoner_NoPoison_Warning1 = false
					
					if mainHandExpiration >= WarningThreshold and (mainHandCharges == 0 or mainHandCharges > chargeThreshold) then
						Poisoner_MinWarning1 = false
						PoisonerTimer_Mainhand:Hide()
					end 
					if (not Poisoner_MinWarning1) and mainHandExpiration <= WarningThreshold and ( Poisoner_PoisonTimeLeft1 ~= 0 ) and mainHandExpiration > 0 then
						if (POISONER_CONFIG.Timer.Output.Audio == 1) and (not Poisoner_MinWarning1) then
							PoisonerSound_PlaySound("expiring")
						end
						if (POISONER_CONFIG.Timer.Output.Chat == 1) and (not Poisoner_MinWarning1) then
							PoisonerTimer_Print("Poisoner_ExpirationWarning", DEFAULT_CHAT_FRAME, INVTYPE_WEAPONMAINHAND, Poisoner_PoisonTimeLeft1, timeformat, 33)
						end
						if (POISONER_CONFIG.Timer.Output.ErrorFrame == 1) and (not Poisoner_MinWarning1) then
							PoisonerTimer_Print("Poisoner_ExpirationWarning", UIErrorsFrame, INVTYPE_WEAPONMAINHAND, Poisoner_PoisonTimeLeft1, timeformat, 33)
						end
						if (POISONER_CONFIG.Timer.Output.Aura == 1) and (not Poisoner_MinWarning1) then
							PoisonerTimer_UpdateIconFrame(PoisonerTimer_Mainhand, PoisonerTimer_MainhandIcon, 16, 0.5, mainHandCharges)
						end
						Poisoner_MinWarning1 = true
					elseif (not Poisoner_MinWarning1) and (mainHandExpiration <= WarningThreshold) then
						Poisoner_MinWarning1 = true
					end
					
				else
					if (not Poisoner_NoPoison_Warning1) then
						if (POISONER_CONFIG.Timer.Output.Audio == 1) then
							PoisonerSound_PlaySound("nopoison")
						end
						if (POISONER_CONFIG.Timer.Output.Chat == 1) then
							PoisonerTimer_Print("Poisoner_NoPoison_Warning", DEFAULT_CHAT_FRAME, INVTYPE_WEAPONMAINHAND, _, _, 33)
						end
						if (POISONER_CONFIG.Timer.Output.ErrorFrame == 1) then
							PoisonerTimer_Print("Poisoner_NoPoison_Warning", UIErrorsFrame, INVTYPE_WEAPONMAINHAND, _, _, 33)
						end
						Poisoner_NoPoison_Warning1 = true
					end
					if (POISONER_CONFIG.Timer.Output.Aura == 1) then
						PoisonerTimer_UpdateIconFrame(PoisonerTimer_Mainhand, PoisonerTimer_MainhandIcon, 16, 1)
					end
				end
			else
				--print("NO mainhand weapon equipped")
				PoisonerTimer_Mainhand:Hide()
				Poisoner_MinWarning1 = false
				Poisoner_NoPoison_Warning1 = false
			end
				
				-- Offhand weapon
			if offHand_isWeapon and POISONER_CONFIG.Timer.Weapon.OffHand == 1 then
				PoisonerTimer_UpdateIconTexture(PoisonerTimer_Offhand, PoisonerTimer_OffhandIcon, 17)
				if hasOffHandEnchant then 
					Poisoner_PoisonTimeLeft2 = Poisoner_round((offHandExpiration/60000), 0)	--math.floor(offHandExpiration/60000)
					local timeformat = PoisonerOptions_LB_TimerOutput_Text_Minutes
					if offHandExpiration <= 30000 then
						Poisoner_PoisonTimeLeft2 = Poisoner_round((offHandExpiration/1000), 0)
						timeformat = PoisonerOptions_LB_TimerOutput_Text_Seconds
					end
					Poisoner_NoPoison_Warning2 = false
					
					if offHandExpiration >= WarningThreshold and (offHandCharges == 0 or offHandCharges > chargeThreshold) then
						Poisoner_MinWarning2 = false
						PoisonerTimer_Offhand:Hide()
					end 
					if (not Poisoner_MinWarning2) and offHandExpiration <= WarningThreshold and ( Poisoner_PoisonTimeLeft2 ~= 0 ) and offHandExpiration > 0 then
						if (POISONER_CONFIG.Timer.Output.Audio == 1) and (not Poisoner_MinWarning2) then
							PoisonerSound_PlaySound("expiring")
						end
						if (POISONER_CONFIG.Timer.Output.Chat == 1) and (not Poisoner_MinWarning2) then
							PoisonerTimer_Print("Poisoner_ExpirationWarning", DEFAULT_CHAT_FRAME, INVTYPE_WEAPONOFFHAND, Poisoner_PoisonTimeLeft2, timeformat, 33)
						end
						if (POISONER_CONFIG.Timer.Output.ErrorFrame == 1) and (not Poisoner_MinWarning2) then
							PoisonerTimer_Print("Poisoner_ExpirationWarning", UIErrorsFrame, INVTYPE_WEAPONOFFHAND, Poisoner_PoisonTimeLeft2, timeformat, 34)
						end
						if (POISONER_CONFIG.Timer.Output.Aura == 1) and (not Poisoner_MinWarning2) then
							PoisonerTimer_UpdateIconFrame(PoisonerTimer_Offhand, PoisonerTimer_OffhandIcon, 17, 0.5, offHandCharges)
						end
						Poisoner_MinWarning2 = true
					elseif (not Poisoner_MinWarning2) and (offHandExpiration <= WarningThreshold) then
						Poisoner_MinWarning2 = true
					end
					
				else
					if (not Poisoner_NoPoison_Warning2) then
						if (POISONER_CONFIG.Timer.Output.Audio == 1) then
							PoisonerSound_PlaySound("nopoison")
						end
						if (POISONER_CONFIG.Timer.Output.Chat == 1) then
							PoisonerTimer_Print("Poisoner_NoPoison_Warning", DEFAULT_CHAT_FRAME, INVTYPE_WEAPONOFFHAND, _, _, 34)
						end
						if (POISONER_CONFIG.Timer.Output.ErrorFrame == 1) then
							PoisonerTimer_Print("Poisoner_NoPoison_Warning", UIErrorsFrame, INVTYPE_WEAPONOFFHAND, _, _, 34)
						end
						Poisoner_NoPoison_Warning2 = true
					end
					if (POISONER_CONFIG.Timer.Output.Aura == 1) then
						PoisonerTimer_UpdateIconFrame(PoisonerTimer_Offhand, PoisonerTimer_OffhandIcon, 17, 1)
					end
				end
			else
				--print("NO offhand weapon equipped")
				PoisonerTimer_Offhand:Hide()
				Poisoner_MinWarning2 = false
				Poisoner_NoPoison_Warning2 = false
			end
				
		end
	else
		PoisonerTimer_Disable()
	end
end

function PoisonerTimer_Disable()
	PoisonerTimer_Mainhand:Hide()
	PoisonerTimer_Offhand:Hide()
	Poisoner_MinWarning1 = false
	Poisoner_NoPoison_Warning1 = false
	Poisoner_MinWarning2 = false
	Poisoner_NoPoison_Warning2 = false
	Poisoner_MinWarning3 = false
	Poisoner_NoPoison_Warning3 = false
end

function PoisonerTimer_Print(msgtype, targetframe, slot, timeleft, timeformat, id)

	if (msgtype == "Poisoner_NoPoison_Warning") then
	
		local message = string.gsub(PoisonerOptions_LB_TimerOutput_Message_NoPoison, "{weapon}", slot)			
		if targetframe == UIErrorsFrame then
			--UIErrorsFrame:AddMessage(""..slot.." "..COLOR_RED.."not"..COLOR_END.." "..COLOR_GREEN.."poisoned"..COLOR_END.."", 1,1,1, id, 9);
			UIErrorsFrame:AddMessage(message, 1,1,1, id, 9);
		else
			--targetframe:AddMessage(""..slot.." "..COLOR_RED.."not"..COLOR_END.." "..COLOR_GREEN.."poisoned"..COLOR_END.."")
			targetframe:AddMessage(message);
		end
	
	elseif (msgtype == "Poisoner_ExpirationWarning") then
	
		local messagestring = COLOR_GREY..PoisonerOptions_LB_TimerOutput_Message_Expiration..COLOR_END
		local message = string.gsub(string.gsub(string.gsub(string.gsub(messagestring, "{poison}", ""..COLOR_GREEN..PoisonerOptions_LB_TimerOutput_Text_Poison..COLOR_END..COLOR_GREY..""), "{weapon}", ""..COLOR_END..slot..COLOR_GREY..""), "{time}", ""..COLOR_END..timeleft..COLOR_GREY..""), "{timeformat}", ""..COLOR_END..timeformat..COLOR_GREY.."")
		
		if (timeleft == nil) then
			timeleft = "0";
		end
		if (targetframe == UIErrorsFrame) then
			UIErrorsFrame:AddMessage(message, 1,1,1, id, 9);
		else
			--targetframe:AddMessage(""..COLOR_GREEN.."Poison"..COLOR_END..COLOR_GREY.." on "..COLOR_END..slot..COLOR_GREY.." expires in "..COLOR_END..timeleft)
			targetframe:AddMessage(message);
		end
		
	end
	
end



function PoisonerTimer_CreateIconFrame()

--	IconFrame
	local f = CreateFrame("Frame", "PoisonerTimer_IconFrame", UIParent)
	f:SetFrameStrata("BACKGROUND")
	f:SetWidth(128) 
	f:SetHeight(64)
	
	local t = f:CreateTexture("PoisonerTimer_IconFrameBackground","BACKGROUND")
	t:SetColorTexture(1,1,1,0)
	t:SetAllPoints(f)
	f.texture = t
	
	f:SetPoint("CENTER","UIParent","CENTER",0,0)
	f:Show()
	
--	Mainhand
	local mh = CreateFrame("Frame", "PoisonerTimer_Mainhand", PoisonerTimer_IconFrame)
	mh:SetFrameStrata("BACKGROUND")
	mh:SetWidth(64) 
	mh:SetHeight(64)
	
	local t = mh:CreateTexture("PoisonerTimer_MainhandIcon","ARTWORK")
	--t:SetTexture(1,1,1,1)
	t:SetAllPoints(mh)
	mh.texture = t
	
	local bfs = mh:CreateFontString("PoisonerTimer_MainhandText","OVERLAY");
	bfs:SetFont("Fonts\\FRIZQT__.TTF", 20, "");
	bfs:SetPoint("BOTTOMLEFT");
	bfs:SetTextColor(1,1,1,1);
	bfs:SetShadowColor(0,0,0,1);
	bfs:SetShadowOffset(2,-2);
	bfs:SetText("")
	bfs:Show()
	mh.text = bfs
	
	mh:SetPoint("TOPLEFT",PoisonerTimer_IconFrame,"TOPLEFT",0,0)
	mh:Hide()
	
--	Offhand
	local oh = CreateFrame("Frame", "PoisonerTimer_Offhand", PoisonerTimer_IconFrame)
	oh:SetFrameStrata("BACKGROUND")
	oh:SetWidth(64) 
	oh:SetHeight(64)
	
	local t = oh:CreateTexture("PoisonerTimer_OffhandIcon","ARTWORK")
	--t:SetTexture(1,1,1,1)
	t:SetAllPoints(oh)
	oh.texture = t
	
	local bfs = oh:CreateFontString("PoisonerTimer_OffhandText","OVERLAY");
	bfs:SetFont("Fonts\\FRIZQT__.TTF", 20, "");
	bfs:SetPoint("BOTTOMRIGHT");
	bfs:SetTextColor(1,1,1,1);
	bfs:SetShadowColor(0,0,0,1);
	bfs:SetShadowOffset(2,-2);
	bfs:SetText("")
	bfs:Show()
	oh.text = bfs
	
	oh:SetPoint("TOPRIGHT",PoisonerTimer_IconFrame,"TOPRIGHT",0,0)
	oh:Hide()
	
end

function PoisonerTimer_UpdateIconFrame(frame, icon, id, alpha, charges)
	
	local configAlpha = POISONER_CONFIG.Timer.Alpha
	local RealAlpha = alpha * configAlpha
	local weaponID = GetInventoryItemID("player", id)
	local weaponName, weaponLink, weaponRarity, weaponLevel, weaponMinLevel, weaponType, weaponSubType, weaponStackCount, weaponEquipLoc, weaponTexture, weaponSellPrice = GetItemInfo(weaponID or 0)
	icon:SetTexture(weaponTexture or "")
	icon:SetAlpha(RealAlpha);
	frame.text:SetText((charges and charges > 0 and charges) or "")
	frame:Show()
	
end

function PoisonerTimer_UpdateIconTexture(frame, icon, id)
	
	local weaponID = GetInventoryItemID("player", id)
	local weaponName, weaponLink, weaponRarity, weaponLevel, weaponMinLevel, weaponType, weaponSubType, weaponStackCount, weaponEquipLoc, weaponTexture, weaponSellPrice = GetItemInfo(weaponID or 0)
	icon:SetTexture(weaponTexture or "")
	
end


function PoisonerTimer_UpdateLock()
	
	if (POISONER_CONFIG.Timer.Lock == 1) then
		PoisonerTimer_IconFrame:RegisterForDrag()
		PoisonerTimer_IconFrameBackground:SetColorTexture(0,1,0,0)
		PoisonerTimer_IconFrame:SetMovable(false)
		PoisonerTimer_IconFrame:EnableMouse(false)
		PoisonerTimer_IconFrame:SetScript("OnDragStart", nil)
		PoisonerTimer_IconFrame:SetScript("OnDragStop", nil)
	else
		PoisonerTimer_IconFrame:Show()
		PoisonerTimer_IconFrame:RegisterForDrag("LeftButton")
		PoisonerTimer_IconFrameBackground:SetColorTexture(0,1,0,1)
		PoisonerTimer_IconFrame:SetMovable(true)
		PoisonerTimer_IconFrame:EnableMouse(true)
		PoisonerTimer_IconFrame:SetScript("OnDragStart", PoisonerTimer_OnDragStart)
		PoisonerTimer_IconFrame:SetScript("OnDragStop", PoisonerTimer_OnDragStop)
	end
end


-- Start dragging MainFrame / Toolbar
function PoisonerTimer_OnDragStart(self)
	
	self:StartMoving();
	PoisonerTimer_BeingDragged = true;
	
end

-- Stop dragging MainFrame / Toolbar
function PoisonerTimer_OnDragStop(self)
	if (PoisonerTimer_BeingDragged) then
		self:StopMovingOrSizing()
		POISONER_CONFIG.Timer.Position.Anchor, POISONER_CONFIG.Timer.Position.RelativeTo, POISONER_CONFIG.Timer.Position.RelativePoint, POISONER_CONFIG.Timer.Position.XPos, POISONER_CONFIG.Timer.Position.YPos = PoisonerTimer_IconFrame:GetPoint();
		PoisonerTimer_BeingDragged = false;
	end
end


--handle events
local f = PoisonerTimer_Frame or CreateFrame("Frame")
f.events = {}
f:SetScript("OnEvent", function(self,event,...)

	f.events[event](self,event,...)

end)

function f.events.UNIT_INVENTORY_CHANGED(self,event,unit,...)
	
	if unit ~= "player" then return end
	
	local hasMainHandEnchant, mainHandExpiration, mainHandCharges, mainHandEnchantID, hasOffHandEnchant, offHandExpiration, offHandCharges, offHandEnchantId = GetWeaponEnchantInfo()
	
	PoisonerTimer_MainhandText:SetText((mainHandCharges and mainHandCharges>0 and mainHandCharges) or "")
	PoisonerTimer_OffhandText:SetText((offHandCharges and offHandCharges>0 and offHandCharges) or "")
	
	if mainHandCharges and mainHandCharges > 0 and mainHandCharges <= chargeThreshold then
		if (not Poisoner_MinWarning1) then
			local stacks = string.format(STACKS,mainHandCharges)
			if (POISONER_CONFIG.Timer.Output.Audio == 1) then
				PoisonerSound_PlaySound("expiring")
			end
			if (POISONER_CONFIG.Timer.Output.Chat == 1) then
				PoisonerTimer_Print("Poisoner_ExpirationWarning", DEFAULT_CHAT_FRAME, INVTYPE_WEAPONMAINHAND, stacks, "", 33)
			end
			if (POISONER_CONFIG.Timer.Output.ErrorFrame == 1) then
				PoisonerTimer_Print("Poisoner_ExpirationWarning", UIErrorsFrame, INVTYPE_WEAPONMAINHAND, stacks, "", 33)
			end
			if (POISONER_CONFIG.Timer.Output.Aura == 1) then
				PoisonerTimer_UpdateIconFrame(PoisonerTimer_Mainhand, PoisonerTimer_MainhandIcon, 16, 0.5, mainHandCharges)
			end
			Poisoner_MinWarning1 = true
		end
	elseif offHandCharges and offHandCharges > 0 and offHandCharges <= chargeThreshold then
		if (not Poisoner_MinWarning2) then
			local stacks = string.format(STACKS,offHandCharges)
			if (POISONER_CONFIG.Timer.Output.Audio == 1) then
				PoisonerSound_PlaySound("expiring")
			end
			if (POISONER_CONFIG.Timer.Output.Chat == 1) then
				PoisonerTimer_Print("Poisoner_ExpirationWarning", DEFAULT_CHAT_FRAME, INVTYPE_WEAPONOFFHAND, stacks, "", 33)
			end
			if (POISONER_CONFIG.Timer.Output.ErrorFrame == 1) then
				PoisonerTimer_Print("Poisoner_ExpirationWarning", UIErrorsFrame, INVTYPE_WEAPONOFFHAND, stacks, "", 34)
			end
			if (POISONER_CONFIG.Timer.Output.Aura == 1) then
				PoisonerTimer_UpdateIconFrame(PoisonerTimer_Offhand, PoisonerTimer_OffhandIcon, 17, 0.5, offHandCharges)
			end
		end
		Poisoner_MinWarning2 = true
	end
	
end

local slotIdsToCheck = {
	[16] = true,
	[17] = true,
}
function f.events.PLAYER_EQUIPMENT_CHANGED(self,event,slotId)
	if not slotIdsToCheck[slotId] then
		return
	end
		
	local id = GetInventoryItemID("player",slotId)
	
	local itemID, itemType, itemSubType, itemEquipLoc, icon, itemClassID, itemSubClassID = GetItemInfoInstant(id or 0)
	local isWeapon = itemClassID == 2
	
	if slotId == 16 then
		isfishing = isWeapon and itemSubClassID == fishingPoleSubId
		mainHand_isWeapon = isWeapon
	else
		offHand_isWeapon = isWeapon
	end
	
end

function f.events.PLAYER_UPDATE_RESTING(self)
	
	isResting = IsResting()
	
end

function f.events.PLAYER_ENTERING_WORLD(self)

	inInstance = IsInInstance()

end


function f.events.PLAYER_LOGIN(self,event)
	for k,v in pairs(slotIdsToCheck) do
		f.events.PLAYER_EQUIPMENT_CHANGED(self,event,k)
	end
end


--regiser events
for k,v in pairs(f.events) do
	f:RegisterEvent(k)
end


function PoisonerTimer_Check()
	if (POISONER_CONFIG.Enabled == 1) and (POISONER_CONFIG.Timer.Active == 1) and (UnitLevel("player") >= 20) then
	
		
	
	else
		PoisonerTimer_Disable()
	end
end



--debugging
function PoisonerTimer_WeaponType()

	local MainHand_ID = GetInventoryItemID("player",16)
	if (MainHand_ID ~= nil) then
		_,_,_,_,_,MainHand_itemType,MainHand_itemSubType = GetItemInfo(MainHand_ID)
		print("MH: "..MainHand_ID)
	elseif (MainHand_ID == nil) then
		MainHand_itemType = "";
	end
	
	local OffHand_ID = GetInventoryItemID("player",17)
	if (OffHand_ID ~= nil) then
		_,_,_,_,_,OffHand_itemType,OffHand_itemSubType = GetItemInfo(OffHand_ID)
		print("OH: "..OffHand_ID)
	elseif (OffHand_ID == nil) then
		OffHand_itemType = "";
	end
	
	print("Mainhand: "..MainHand_itemType.."\nOffhand: "..OffHand_itemType.."")
		
	if MainHand_itemType == ENCHSLOT_WEAPON then
		print("Mainhand is a "..MainHand_itemSubType)
	else
		print("Mainhand is NOT a weapon")
	end
	if OffHand_itemType == ENCHSLOT_WEAPON then
		print("Offhand is a "..OffHand_itemSubType)
	else
		print("Offhand is NOT a weapon")
	end
	
	--local isfishingpole = select(7,GetItemInfo(6256))
	if MainHand_itemSubType == isfishingpole then
		print("MainHand weapon is a fishing pole")
	end
	
end