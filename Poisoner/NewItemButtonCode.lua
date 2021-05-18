Button_Code(

	local button = CreateFrame("BUTTON", "Poisoner_TestButton", PoisonerMenu, "SecureHandlerClickTemplate, SecureHandlerBaseTemplate, Poisoner_ItemButton");
	button:RegisterForDrag("LeftButton");
	--button:SetClampedToScreen(true);
	button:ClearAllPoints();
	button:SetPoint("RIGHT",PoisonerMenu,"LEFT");
	
	local texturepath = "Interface\\Icons\\Ability_Creature_Disease_02";
	
	local texture = button:CreateTexture(nil, "ARTWORK");
	texture:SetTexture("Interface\\Icons\\Ability_Creature_Disease_02");
	texture:SetBlendMode("BLEND");
	texture:SetAllPoints(button);
	button:SetHighlightTexture(texture);
	
	local bfs = button:CreateFontString("Poisoner_TestButtonText","OVERLAY","GameFontNormal");
	bfs:SetPoint("BOTTOMRIGHT");
	bfs:SetTextColor(1,1,1,1);
	bfs:SetShadowColor(0,0,0,1);
	bfs:SetShadowOffset(-2,2);
	button:SetFontString(bfs);

	button:SetNormalTexture("Interface\\Icons\\Ability_Creature_Disease_02");
	button:SetHighlightTexture("Interface\\Icons\\Ability_Creature_Disease_02");
	button:GetNormalTexture():SetVertexColor(1,1,1,1);
	button:GetHighlightTexture():SetVertexColor(0.5,0.5,1,1);
	
	button:SetAttribute("_onclick", [=[
		local left, right, fb, psf = button == "LeftButton", button == "RightButton", self:GetFrameRef("FreeButton"), self:GetFrameRef("PoisonerSlotFrame");
		
		local poison = self:GetAttribute("Poison")		
		print("Poisoner_TestButton: _onclick;   Poison: "..poison)
		
		self:SetAttribute("Poison", "KEIN Wundgift")
		
	]=]);
	
	button:RegisterForClicks("AnyDown");
	button:SetFrameRef("FreeButton", Poisoner_FreeButton);
	button:SetFrameRef("PoisonerSlotFrame", Poisoner_PoisonSlotFrame);
	
	button:SetAttribute("Poison", "Wundgift");
	button:SetAttribute("type", "macro");
	button:SetAttribute("macrotext", "/use Wundgift\n/use [button:3] 18\n/use [button:2] 17\n/use [button:1] 16\n/click StaticPopup1Button1\n/run PoisonerOptions_CheckPoisons()");
	

)



XML_CODE(

	<Button name="Poisoner_ItemButton" frameStrata="HIGH" toplevel="true" movable="true" virtual="true">
		<Size><AbsDimension x="36" y="36"/></Size>
	</Button>

)