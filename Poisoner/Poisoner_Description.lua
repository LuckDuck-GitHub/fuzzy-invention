Quick discription:
	Poisoner allows you to
	* apply
		via 2 different possiblities
			PoisonMenu
			QuickButton (=> configuration menu)
	* click
		LEFT mouse button to apply it to your main hand weapon 
		RIGHT mouse button to apply it to your offhand weapon 
		MIDDLE mouse button (scroll wheel) to apply it to your throw weapon
	* buy
		a choosen amount of poisons via confirmation or automation on vendor visit
	* watch
		warns when your poisons are about to expire
		warns when your low on poisons and need to restock
	
Features:
	* TWO Minimap buttons with a automatically updating menu with buttons for your poisons, weightstones/sharpening stones and mana/wizard oil.
		You can choose which button you want to show/hide and want the PoisonerMenu anchored to.
		The Poisoner_FreeButton can be dragged in the whole UI.
	* a 'Quick Button' to empoison your weapons via user defined presets with just 1 click.
	* Poison expiration warning via
		* Audio
		* Chat
		* ErrorFrame
		* AuraFrame
	* Warning when you are running out of poisons and need to restock. (TimerWarning is deactivated when resting)
	* AutoBuy to buy choosen amounts of poisons on vendor visit with 1 or without any click.
	* You can set the scale and alpha of nearly every button/menu and the AuraFrame to fit Poisoner to your UI.
	
	Poisoner_ButtonFacade
		If you have ButtonFacade activated, Poisoner_ButtonFacade let you skin the MenuButtons and the QuickButton via ButtonFacade.
			Download ButtonFacade <http://wow.curse.com/downloads/wow-addons/details/buttonfacade.aspx>
	
	
Usage:
	* FreeButton:
		If you
		LEFT-click the button, a menu is created dynamically depending on the items in your inventory.
		RIGHT-click the button, the Poisoner configuration menu will show up.
		! The FreeButton CAN toggle all Poisoner menus while in combat !
	
	* MinimapButton:
		If you
		LEFT-click the button, a menu is created dynamically depending on the items in your inventory.
		RIGHT-click the button, the Poisoner configuration menu will show up.
		! The MinimapButton can NOT toggle the menu or the config while in combat. To toggle the menu while in combat, click the FreeButton or use the Hotkeys. !
	
	* PoisonMenu:
		Click on a poison button with the following mouse buttons to apply it to the according weapon:
		LEFT-click => Mainhand
		RIGHT-click => Offhand
		Middle-click => Throw weapon
	
	* AutoBuy
		Enbale AutoBuy via the checkbox on top. If you do not want to have to confirm buying, check the second option.
		To setup the amount to buy simply move the slider of the corresponding poison and click on the 'Save' button.
		The next time you visit a poison vendor, Poisoner will restock your poisons to the choosen amount.
	
	* QuickButton:
		If a standard poison set is choosen, PoisonerQuickButton is shown.
		The choosen poisons can be applied with the corresponding modifiers (none/SHIFT/CTRL/ALT) and mouse button 1/2/3


Slash commands:

	/poisoner - Open the configuration menu.
	
	/poisoner
		enable - Enable Poisoner.
		disable - Disable Poisoner.
		config - Open the configuration menu.
	
	/poisoner freebutton/fb
		show - Show the Poisoner Minimap button.
		hide - Prevent the Poisoner Minimap button from being shown.
		lock - Prevent the poisoner button from being dragged.
		unlock - Allow the poisoner button to be dragged.
		reset - Reset the position of the poisoner button.
		scale # - (Enter a number for #. min:0.1, max:2)
		alpha # - (Enter a number for #. min:0.1, max:1)
	
	/poisoner menu	
		parent
			own - Set Poisoner_FreeButton as parent
			minimap - Set MinimapButton as parent (the Poisoner Minimap button can be dragged depending on/according to the Minimap)
		position - Set on which side of the choosen button the menu appears.
			top
			topleft
			topright
			left
			right
			bottom
			bottomleft - This is the classic position.
			bottomright
		scale {0.1 - 2} - Set the scale of the poisoner menu (value of 1 = no change, less than 1 = shrink, larger than 1 = enlarge).
		overwrite - Set this to 1 or true to enable updating of the QuickButton whren applying poisons via the menu (Presets will be reset to the choosen ones on next reload or login).
		reset - Reset the menu to its defaults.
		
	/poisoner tooltip/tt
		name - Name-only tooltips
		full - full item tooltip	
	
	/poisoner postpoison
		Should choosen (clicked) poisons be posted in the Chatframe?
		'true' or 1
		'false' or 0
	
	/poisoner timer
		enable
		disable
		warningthreshold # or wt # - (Enter a number for #. min:1, max:25)
		output
			mainhand - check mainhand weapon
				'true' or 1
				'false' or 0
			offhand - check offhand weapon
				'true' or 1
				'false' or 0
			throwweapon - check throw weapon
				'true' or 1
				'false' or 0
			
			audio - give acoustic warning
				'true' or 1
				'false' or 0
			chat - print warning into Chat
				'true' or 1
				'false' or 0
			error - print warning into UIErrorsFrame
				'true' or 1
				'false' or 0
			aura - show the aura frame ("weapon icons")
				'true' or 1
				'false' or 0
		aura
			lock
			unlock
			scale # - (Enter a number for #. min:0.1, max:2)
			alpha # - (Enter a number for #. min:0.1, max:1)
	
	/poisoner autobuy
		enable	- Enables automatic purchasing of the choosen poisons on vendor visit.
		disable - Disables automatic purchasing of the choosen poisons on vendor visit.
		confirm - A PopUp will be shown if there are poisons to buy.
		auto - Poisoner will buy choosen poisons automatically without confirmation.
		check - Should Poisoner inform you via Chat if your poisons are below 10% stock?
			'true' or 1
			'false' or 0
		cp # - Set the amount of poisons to restock to. (Enter a number for #. min:1, max:25)
		dp #
		ip #
		mp #
		wp #
	
	/poisoner presets
		reset
	
	/poisoner quickbutton
		lock - Prevent the PoisonerQuickButton from being dragged.
		unlock - Allow the PoisonerQuickButton to be dragged.
		reset - Resets the QuickButton to its default position. ("Only seeable if presets are correct.")
		scale # - (Enter a number for #. min:0.1, max:2)
		alpha # - (Enter a number for #. min:0.1, max:1)
		
	/poisoner thanks
		- Prints a lists off all important people who distributed to and tested Poisoner 4.

Limitations:

	The Poisoner Minimap Menu can be toggled while inCombat since version 4.0.3d beta160.
		To do so, you have to click the FreeButton or use the keybinding which can be set via the WoW keybinging menu.
	The MinimapButton (LDBIcon) can NOT toggle the Menu while in combat.



	
--[=[
		WikiCreole version
	

=Quick discription=
==Poisoner allows you to==
	===apply===
via 2 different possiblities:
		*PoisonMenu
		*QuickButton (=> configuration menu)
	===click===
		*LEFT mouse button to apply it to your main hand weapon 
		*RIGHT mouse button to apply it to your offhand weapon 
		*MIDDLE mouse button (scroll wheel) to apply it to your throw weapon
	===buy===
;
		:a choosen amount of poisons via confirmation or automation on vendor visit
	===watch===
		*warns when your poisons are about to expire
		*warns when your low on poisons and need to restock\\\\\\
----
\\
=Features=
	*TWO Minimap buttons with a automatically updating menu with buttons for your poisons, weightstones/sharpening stones and mana/wizard oil.
		**You can choose which button you want to show/hide and want the PoisonerMenu anchored to.
		**The Poisoner_FreeButton can be dragged in the whole UI.

	* a 'Quick Button' to empoison your weapons via user defined presets with just 1 click.

	* Poison expiration warning via
		** Audio
		** Chat
		** ErrorFrame
		** AuraFrame

	* Warning when you are running out of poisons and need to restock. (TimerWarning is deactivated when resting)

	* AutoBuy to buy choosen amounts of poisons on vendor visit with 1 or without any click.

	* You can set the scale and alpha of nearly every button/menu and the AuraFrame to fit Poisoner to your UI.\\\\
	
	===Poisoner_ButtonFacade===
;
		:If you have ButtonFacade activated, Poisoner_ButtonFacade let you skin the MenuButtons and the QuickButton via ButtonFacade.
[[http://wow.curse.com/downloads/wow-addons/details/buttonfacade.aspx|Download ButtonFacade]]\\\\\\
----
\\
=Usage=
\\
===FreeButton===
;If you
:**LEFT**-click the button, a menu is created dynamically depending on the items in your inventory.
:**RIGHT**-click the button, the Poisoner configuration menu will show up.

! The FreeButton CAN toggle all Poisoner menus while in combat !
\\\\
===MinimapButton===
;If you
:**LEFT**-click the button while out of combat, a menu is created dynamically depending on the items in your inventory.
:**RIGHT**-click the button while out of combat, the Poisoner configuration menu will show up.

! The MinimapButton can NOT toggle the menu or the config while in combat. To toggle the menu while in combat, click the FreeButton or use the Hotkeys. !
\\\\
===PoisonMenu===
;Click on a poison button with the following mouse buttons to apply it to the according weapon:
:**LEFT**-click => Mainhand
:**RIGHT**-click => Offhand
:**Middle**-click => Throw weapon
\\\\
===AutoBuy===
Enbale AutoBuy via the checkbox on top. If you do not want to have to confirm buying, check the second option.

To setup the amount to buy simply move the slider of the corresponding poison and click on the 'Save' button.

The next time you visit a poison vendor, Poisoner will restock your poisons to the choosen amount.
\\\\
===QuickButton===
If a standard poison set is choosen, **PoisonerQuickButton** is shown.

The choosen poisons can be applied with the corresponding modifiers (none/SHIFT/CTRL/ALT) and mouse button 1/2/3\\\\\\
----
\\
=Slash commands=
	
/poisoner
	* **enable** - //Enable Poisoner.//
	* **disable** - //Disable Poisoner.//
	* **config** - //Open the configuration menu.//

\\\\
/poisoner **freebutton** / **fb**
	* **show** - //Show the Poisoner Minimap button.//
	* **hide** - //Prevent the Poisoner Minimap button from being shown.//
	* **lock** - //Prevent the poisoner button from being dragged.//
	* **unlock** - //Allow the poisoner button to be dragged.//
	* **reset** - //Reset the position of the poisoner button.//
	* **scale #** - //(Enter a number for #. min:0.1, max:2)//
	* **alpha #** - //(Enter a number for #. min:0.1, max:1)//

\\\\
/poisoner **menu**
	* **parent**
		** **own** - //Set Poisoner_FreeButton as parent//
		** **minimap** - //Set MinimapButton as parent (the Poisoner Minimap button can be dragged depending on/according to the Minimap)//\\

	* **position** - //Set on which side of the choosen button the menu appears.//
		** **top**
		** **topleft**
		** **topright**
		** **left**
		** **right**
		** **bottom**
		** **bottomleft** - //This is the classic position.//
		** **bottomright**\\

	* **scale** {0.1 - 2} - //Set the scale of the poisoner menu (value of 1 = no change, less than 1 = shrink, larger than 1 = enlarge).//\\

	* **overwrite** - //Set this to 1 or true to enable updating of the QuickButton whren applying poisons via the menu (Presets will be reset to the choosen ones on next reload or login).//\\

	* **reset** - //Reset the menu to its defaults.//\\

\\\\
/poisoner **tooltip** / **tt**
	* **name** - //Name-only tooltips//
	* **full** - //full item tooltip//

\\\\
/poisoner **postpoison** - //Should choosen (clicked) poisons be posted in the Chatframe?//
	* **Yes:** 'true' //or// 1
	* **No:** 'false' //or// 0

\\\\
/poisoner **timer**
	* **enable**
	* **disable**
	* **warningthreshold #** //or// **wt #** - //(Enter a number for #. min:1, max:25)//
	* **output**
		** **mainhand** - //check mainhand weapon//
			**On: 'true' //or// 1
			**Off: 'false' //or// 0\\\\
		** **offhand** - //check offhand weapon//
			**On: 'true' //or// 1
			**Off: 'false' //or// 0\\\\
		** **throwweapon** - //check throw weapon//
			**On: 'true' //or// 1
			**Off: 'false' //or// 0\\\\
		** **audio** - //give acoustic warning//
			**On: 'true' //or// 1
			**Off: 'false' //or// 0\\\\
		** **chat** - //print warning into Chat//
			**On: 'true' //or// 1
			**Off: 'false' //or// 0\\\\
		** **error** - //print warning into UIErrorsFrame//
			**On: 'true' //or// 1
			**Off: 'false' //or// 0\\\\
		** **aura** - //show the aura frame ("weapon icons")//
			**On: 'true' //or// 1
			**Off: 'false' //or// 0\\\\
	* **aura**
		** **lock**
		** **unlock**
		** **scale #** - //(Enter a number for #. min:0.1, max:2)//
		** **alpha #** - //(Enter a number for #. min:0.1, max:1)//

\\\\
/poisoner **autobuy**
	* **enable** - //Enables automatic purchasing of the choosen poisons on vendor visit.//
	* **disable** - //Disables automatic purchasing of the choosen poisons on vendor visit.//
	* **confirm** - //A PopUp will be shown if there are poisons to buy.//
	* **auto** - //Poisoner will buy choosen poisons automatically without confirmation.//
	* **check** - //Should Poisoner inform you via Chat if your poisons are below 10% stock?//
		'true' or 1
		'false' or 0
	* **cp #** - //Set the amount of poisons to restock to. (Enter a number for #. min:1, max:25)//
	* **dp #**
	* **ip #**
	* **mp #**
	* **wp #**

\\\\
/poisoner **presets**
	* **reset**

\\\\
/poisoner **quickbutton**
	* **lock** - //Prevent the PoisonerQuickButton from being dragged.//
	* **unlock** - //Allow the PoisonerQuickButton to be dragged.//
	* **reset** - //Resets the QuickButton to its default position. ("Only seeable if presets are correct.")//
	* **scale #** - //(Enter a number for #. min:0.1, max:2)//
	* **alpha #** - //(Enter a number for #. min:0.1, max:1)//

\\\\
/poisoner **thanks**

*//Prints a lists off all important people who distributed to and tested Poisoner 4.//\\\\\\
----
\\
=Limitations=

	The Poisoner Minimap Menu can be toggled while inCombat.

	To do so, you have to click the FreeButton or use the keybinding which can be set via the WoW keybinging menu.

	The MinimapButton (LDBIcon) can NOT toggle the Menu while in combat.\\\\
----
\\\\\\
**Poisoner is enabled by default for Rogues, and disabled by default for all other classes.**

\\\\\\
//Credits to Karrion of Terenas for the original Poisoner//

]=]