Scriptname XFLPluginOutfit extends XFLPlugin Conditional

Message Property FollowerOutfitMenu Auto  
Message Property FollowerOutfitTypeMenu Auto  

Outfit Property Naked  Auto  

Outfit[] Property Outfits_Clothing Auto
; 0 Barkeeper
; 1 Blacksmith
; 2 Fine
; 3 Farm
; 4 Jester
; 5 Wench
; 6 Nocturnal
; 7 Wedding Dress
Outfit[] Property Outfits_LightArmor Auto
; 0 Hide
; 1 Studded
; 2 Stormcloak
; 3 Imperial
; 4 Forsworn
; 5 Elven
; 6 Thieves Guild
Outfit[] Property Outfits_HeavyArmor Auto
; 0 Iron
; 1 Banded Iron
; 2 Steel
; 3 Housecarl
; 4 Imperial
; 5 Steel Plate
; 6 Dwarven

Message Property FollowerOutfitClothingMenu Auto
Message Property FollowerOutfitLightMenu Auto
Message Property FollowerOutfitHeavyMenu Auto

ReferenceAlias Property Alias_Outfit Auto  

bool Sleepwear = false
bool isGroup = false

int Function GetIdentifier()
	return 0x1001
EndFunction

string Function GetPluginName()
	return "$Outfit"
EndFunction

; akCmd 0 - Apply Outfit
; akForm1 - Receiving Actor
; akForm2 - Outfit
; aiValue1 - Sleepwear
Event OnActionEvent(int akCmd, Form akForm1 = None, Form akForm2 = None, int aiValue1 = 0, int aiValue2 = 0)
	If akCmd == 0
		If aiValue1 == 0
			ApplyOutfit(akForm1 as Actor, akForm2 as Outfit, false)
		Elseif aiValue1 == 1
			ApplyOutfit(akForm1 as Actor, akForm2 as Outfit, true)
		Endif
	Endif
EndEvent

Bool Function showMenu(Form akForm) ; Re-implement
	return true
EndFunction

Bool Function showGroupMenu() ; Re-implement
	return true
EndFunction

Function activateMenu(int page, Form akForm) ; Re-implement
	isGroup = false
	XFL_TriggerMenu(akForm, FollowerMenu.GetMenuState("SubMenuType"), FollowerMenu.GetMenuState("PluginMenu"), page)
EndFunction

Function activateGroupMenu(int page, Form akForm) ; Re-implement
	; Do nothing
	isGroup = true
	XFL_TriggerMenu(akForm, FollowerMenu.GetMenuState("SubMenuType"), FollowerMenu.GetMenuState("PluginMenu"), page)
EndFunction

Function XFL_TriggerMenu(Form akForm, string menuState = "", string previousState = "", int page = 0)
	GoToState(menuState)
	activateSubMenu(akForm, previousState, page)
EndFunction

Function activateSubMenu(Form akForm, string previousState = "", int page = 0)
	; Do nothing in blank state
EndFunction

State SubMenuType_Classic
	Function activateSubMenu(Form akForm, string previousState = "", int page = 0)
		int OutfitMenu_Default = 0
		int OutfitMenu_Sleepwear = 1
		int OutfitMenu_Back = 2
		int OutfitMenu_Exit = 3

		If previousState != ""
			FollowerMenu.XFL_MessageMod_Back = 1
		EndIf

		Alias_Outfit.ForceRefTo(MenuRef) ; Menu text
		
		int ret = FollowerOutfitTypeMenu.Show()
		If ret == OutfitMenu_Default
			Sleepwear = false
			XFL_TriggerMenu(akForm, FollowerMenu.GetMenuState("SubMenuOutfit"), GetState(), page)
		Elseif ret == OutfitMenu_Sleepwear
			Sleepwear = true
			XFL_TriggerMenu(akForm, FollowerMenu.GetMenuState("SubMenuOutfit"), GetState(), page)
		Elseif ret == OutfitMenu_Back
			FollowerMenu.XFL_TriggerMenu(akForm, FollowerMenu.GetMenuState("PluginMenu"), FollowerMenu.GetParentState("PluginMenu"), page) ; Force a back all the way to the plugin menu
		Elseif ret == OutfitMenu_Exit
			FollowerMenu.OnFinishMenu()
		Endif
		
		GoToState("")
	EndFunction
EndState

State SubMenuOutfit_Classic
	Function activateSubMenu(Form akForm, string previousState = "", int page = 0)
		int OutfitMenu_None = 0
		int OutfitMenu_Clothing = 1
		int OutfitMenu_LightArmor = 2
		int OutfitMenu_HeavyArmor = 3
		int OutfitMenu_Back = 4
		int OutfitMenu_Exit = 5

		If previousState != ""
			FollowerMenu.XFL_MessageMod_Back = 1
		EndIf
		
		Actor actorRef = None
		If !isGroup
			actorRef = akForm as Actor
		Endif

		Alias_Outfit.ForceRefTo(MenuRef) ; Menu text
		int ret = FollowerOutfitMenu.Show()
		If ret == OutfitMenu_None
			;ApplyOutfit(actorRef, None, Sleepwear)
			FollowerMenu.OnFinishMenu()
			XFLMain.XFL_SendActionEvent(GetIdentifier(), 0, actorRef, None, Sleepwear as Int)
		Elseif ret == OutfitMenu_Clothing
			XFL_TriggerMenu(akForm, FollowerMenu.GetMenuState("SubMenuOutfitClothing"), GetState(), page)
		Elseif ret == OutfitMenu_LightArmor
			XFL_TriggerMenu(akForm, FollowerMenu.GetMenuState("SubMenuOutfitLight"), GetState(), page)
		Elseif ret == OutfitMenu_HeavyArmor
			XFL_TriggerMenu(akForm, FollowerMenu.GetMenuState("SubMenuOutfitHeavy"), GetState(), page)
		Elseif ret == OutfitMenu_Back
			XFL_TriggerMenu(akForm, FollowerMenu.GetMenuState("SubMenuType"), FollowerMenu.GetMenuState("PluginMenu"), page)
		Elseif ret == OutfitMenu_Exit
			FollowerMenu.OnFinishMenu()
		Endif
		
		GoToState("")
	EndFunction
EndState

State SubMenuOutfitClothing_Classic
	Function activateSubMenu(Form akForm, string previousState = "", int page = 0)
		int OutfitMenu_Back = 8
		int OutfitMenu_Exit = 9

		If previousState != ""
			FollowerMenu.XFL_MessageMod_Back = 1
		EndIf
		
		Actor actorRef = None
		If !isGroup
			actorRef = akForm as Actor
		Endif

		Alias_Outfit.ForceRefTo(MenuRef) ; Menu text
		int ret = FollowerOutfitClothingMenu.Show()
		If ret < OutfitMenu_Back
			FollowerMenu.OnFinishMenu()
			XFLMain.XFL_SendActionEvent(GetIdentifier(), 0, actorRef, Outfits_Clothing[ret], Sleepwear as Int)
		Elseif ret == OutfitMenu_Back
			XFL_TriggerMenu(akForm, previousState, FollowerMenu.GetMenuState("SubMenuOutfit"), page)
		Elseif ret == OutfitMenu_Exit
			FollowerMenu.OnFinishMenu()
		Endif
		
		GoToState("")
	EndFunction
EndState

State SubMenuOutfitLight_Classic
	Function activateSubMenu(Form akForm, string previousState = "", int page = 0)
		int OutfitMenu_Back = 7
		int OutfitMenu_Exit = 8

		If previousState != ""
			FollowerMenu.XFL_MessageMod_Back = 1
		EndIf
		
		Actor actorRef = None
		If !isGroup
			actorRef = akForm as Actor
		Endif

		Alias_Outfit.ForceRefTo(MenuRef) ; Menu text
		int ret = FollowerOutfitLightMenu.Show()
		If ret < OutfitMenu_Back
			;ApplyOutfit(actorRef, Outfits_LightArmor[ret], Sleepwear)
			FollowerMenu.OnFinishMenu()
			XFLMain.XFL_SendActionEvent(GetIdentifier(), 0, actorRef, Outfits_LightArmor[ret], Sleepwear as Int)
		Elseif ret == OutfitMenu_Back
			XFL_TriggerMenu(akForm, previousState, FollowerMenu.GetMenuState("SubMenuOutfit"), page)
		Elseif ret == OutfitMenu_Exit
			FollowerMenu.OnFinishMenu()
		Endif
		
		GoToState("")
	EndFunction
EndState

State SubMenuOutfitHeavy_Classic
	Function activateSubMenu(Form akForm, string previousState = "", int page = 0)
		int OutfitMenu_Back = 7
		int OutfitMenu_Exit = 8

		If previousState != ""
			FollowerMenu.XFL_MessageMod_Back = 1
		EndIf
		
		Actor actorRef = None
		If !isGroup
			actorRef = akForm as Actor
		Endif

		Alias_Outfit.ForceRefTo(MenuRef) ; Menu text
		int ret = FollowerOutfitHeavyMenu.Show()
		If ret < OutfitMenu_Back
			;ApplyOutfit(actorRef, Outfits_HeavyArmor[ret], Sleepwear)
			FollowerMenu.OnFinishMenu()
			XFLMain.XFL_SendActionEvent(GetIdentifier(), 0, actorRef, Outfits_HeavyArmor[ret], Sleepwear as Int)
		Elseif ret == OutfitMenu_Back
			XFL_TriggerMenu(akForm, previousState, FollowerMenu.GetMenuState("SubMenuOutfit"), page)
		Elseif ret == OutfitMenu_Exit
			FollowerMenu.OnFinishMenu()
		Endif
		
		GoToState("")
	EndFunction
EndState

Function ApplyOutfit(Actor followerActor, Outfit outfitRef, Bool isSleepwear)
	If outfitRef == None
		outfitRef = Naked
	Endif
	If followerActor != None
		followerActor.SetOutfit(outfitRef, isSleepwear)
	Endif
EndFunction

; New menu info
string[] Function GetMenuEntries(Form akForm)
	string[] entries = new string[53]
	int itemOffset = GetIdentifier() * 100

	entries[0] = GetPluginName() + ";;" + -1 + ";;" + GetIdentifier() + ";;" + 0 + ";;1"

	entries[1] = "$Default" 		+ ";;" + GetIdentifier() + ";;" + (itemOffset + 0) + ";;" + 0 + ";;1"

	entries[2] = "$None" 			+ ";;" + (itemOffset + 0) + ";;" + (itemOffset + 80) + ";;" + 10 + ";;0"

	entries[3] = "$Clothing" 		+ ";;" + (itemOffset + 0) + ";;" + (itemOffset + 10) + ";;" + 0 + ";;1"
	entries[4] = "$Barkeeper" 		+ ";;" + (itemOffset + 10) + ";;" + (itemOffset + 11) + ";;" + 0 + ";;0"
	entries[5] = "$Blacksmith"		+ ";;" + (itemOffset + 10) + ";;" + (itemOffset + 12) + ";;" + 1 + ";;0"
	entries[6] = "$Fine" 			+ ";;" + (itemOffset + 10) + ";;" + (itemOffset + 13) + ";;" + 2 + ";;0"
	entries[7] = "$Jester" 			+ ";;" + (itemOffset + 10) + ";;" + (itemOffset + 14) + ";;" + 3 + ";;0"
	entries[8] = "$Wench" 			+ ";;" + (itemOffset + 10) + ";;" + (itemOffset + 15) + ";;" + 4 + ";;0"
	entries[9] = "$Nocturnal" 		+ ";;" + (itemOffset + 10) + ";;" + (itemOffset + 16) + ";;" + 5 + ";;0"
	entries[10] = "$Wedding Dress" 	+ ";;" + (itemOffset + 10) + ";;" + (itemOffset + 17) + ";;" + 6 + ";;0"

	entries[11] = "$Light Armor" 	+ ";;" + (itemOffset + 0) + ";;" + (itemOffset + 20) + ";;" + 0 + ";;1"
	entries[12] = "$Hide" 			+ ";;" + (itemOffset + 20) + ";;" + (itemOffset + 21) + ";;" + 0 + ";;0"
	entries[13] = "$Studded"		+ ";;" + (itemOffset + 20) + ";;" + (itemOffset + 22) + ";;" + 1 + ";;0"
	entries[14] = "$Stormcloak" 	+ ";;" + (itemOffset + 20) + ";;" + (itemOffset + 23) + ";;" + 2 + ";;0"
	entries[15] = "$Imperial" 		+ ";;" + (itemOffset + 20) + ";;" + (itemOffset + 24) + ";;" + 3 + ";;0"
	entries[16] = "$Forsworn" 		+ ";;" + (itemOffset + 20) + ";;" + (itemOffset + 25) + ";;" + 4 + ";;0"
	entries[17] = "$Elven" 			+ ";;" + (itemOffset + 20) + ";;" + (itemOffset + 26) + ";;" + 5 + ";;0"
	entries[18] = "$Thieves Guild" 	+ ";;" + (itemOffset + 20) + ";;" + (itemOffset + 27) + ";;" + 6 + ";;0"

	entries[19] = "$Heavy Armor"	+ ";;" + (itemOffset + 0) + ";;" + (itemOffset + 30) + ";;" + 0 + ";;1"
	entries[20] = "$Iron" 			+ ";;" + (itemOffset + 30) + ";;" + (itemOffset + 31) + ";;" + 0 + ";;0"
	entries[21] = "$Banded Iron"	+ ";;" + (itemOffset + 30) + ";;" + (itemOffset + 32) + ";;" + 1 + ";;0"
	entries[22] = "$Steel" 			+ ";;" + (itemOffset + 30) + ";;" + (itemOffset + 33) + ";;" + 2 + ";;0"
	entries[23] = "$Housecarl" 		+ ";;" + (itemOffset + 30) + ";;" + (itemOffset + 34) + ";;" + 3 + ";;0"
	entries[24] = "$Imperial" 		+ ";;" + (itemOffset + 30) + ";;" + (itemOffset + 35) + ";;" + 4 + ";;0"
	entries[25] = "$Steel Plate" 	+ ";;" + (itemOffset + 30) + ";;" + (itemOffset + 36) + ";;" + 5 + ";;0"
	entries[26] = "$Dwarven" 		+ ";;" + (itemOffset + 30) + ";;" + (itemOffset + 37) + ";;" + 6 + ";;0"

	entries[27] = "$Sleepwear" 		+ ";;" + GetIdentifier() + ";;" + (itemOffset + 1) + ";;" + 0 + ";;1"

	entries[28] = "$None" 			+ ";;" + (itemOffset + 1) + ";;" + (itemOffset + 90) + ";;" + 10 + ";;0"

	entries[29] = "$Clothing" 		+ ";;" + (itemOffset + 1) + ";;" + (itemOffset + 40) + ";;" + 0 + ";;1"
	entries[30] = "$Barkeeper" 		+ ";;" + (itemOffset + 40) + ";;" + (itemOffset + 41) + ";;" + 0 + ";;0"
	entries[31] = "$Blacksmith"		+ ";;" + (itemOffset + 40) + ";;" + (itemOffset + 42) + ";;" + 1 + ";;0"
	entries[32] = "$Fine" 			+ ";;" + (itemOffset + 40) + ";;" + (itemOffset + 43) + ";;" + 2 + ";;0"
	entries[33] = "$Jester" 		+ ";;" + (itemOffset + 40) + ";;" + (itemOffset + 44) + ";;" + 3 + ";;0"
	entries[34] = "$Wench" 			+ ";;" + (itemOffset + 40) + ";;" + (itemOffset + 45) + ";;" + 4 + ";;0"
	entries[35] = "$Nocturnal" 		+ ";;" + (itemOffset + 40) + ";;" + (itemOffset + 46) + ";;" + 5 + ";;0"
	entries[36] = "$Wedding Dress" 	+ ";;" + (itemOffset + 40) + ";;" + (itemOffset + 47) + ";;" + 6 + ";;0"

	entries[37] = "$Light Armor" 	+ ";;" + (itemOffset + 1) + ";;" + (itemOffset + 50) + ";;" + 0 + ";;1"
	entries[38] = "$Hide" 			+ ";;" + (itemOffset + 50) + ";;" + (itemOffset + 51) + ";;" + 0 + ";;0"
	entries[39] = "$Studded"		+ ";;" + (itemOffset + 50) + ";;" + (itemOffset + 52) + ";;" + 1 + ";;0"
	entries[40] = "$Stormcloak" 	+ ";;" + (itemOffset + 50) + ";;" + (itemOffset + 53) + ";;" + 2 + ";;0"
	entries[41] = "$Imperial" 		+ ";;" + (itemOffset + 50) + ";;" + (itemOffset + 54) + ";;" + 3 + ";;0"
	entries[42] = "$Forsworn" 		+ ";;" + (itemOffset + 50) + ";;" + (itemOffset + 55) + ";;" + 4 + ";;0"
	entries[43] = "$Elven" 			+ ";;" + (itemOffset + 50) + ";;" + (itemOffset + 56) + ";;" + 5 + ";;0"
	entries[44] = "$Thieves Guild" 	+ ";;" + (itemOffset + 50) + ";;" + (itemOffset + 57) + ";;" + 6 + ";;0"

	entries[45] = "$Heavy Armor"	+ ";;" + (itemOffset + 1) + ";;" + (itemOffset + 60) + ";;" + 0 + ";;1"
	entries[46] = "$Iron" 			+ ";;" + (itemOffset + 60) + ";;" + (itemOffset + 61) + ";;" + 0 + ";;0"
	entries[47] = "$Banded Iron"	+ ";;" + (itemOffset + 60) + ";;" + (itemOffset + 62) + ";;" + 1 + ";;0"
	entries[48] = "$Steel" 			+ ";;" + (itemOffset + 60) + ";;" + (itemOffset + 63) + ";;" + 2 + ";;0"
	entries[49] = "$Housecarl" 		+ ";;" + (itemOffset + 60) + ";;" + (itemOffset + 64) + ";;" + 3 + ";;0"
	entries[50] = "$Imperial" 		+ ";;" + (itemOffset + 60) + ";;" + (itemOffset + 65) + ";;" + 4 + ";;0"
	entries[51] = "$Steel Plate" 	+ ";;" + (itemOffset + 60) + ";;" + (itemOffset + 66) + ";;" + 5 + ";;0"
	entries[52] = "$Dwarven" 		+ ";;" + (itemOffset + 60) + ";;" + (itemOffset + 67) + ";;" + 6 + ";;0"

	return entries
EndFunction

Event OnMenuEntryTriggered(Form akForm, int itemId, int callback)
	int category = itemId - GetIdentifier() * 100
	int subCategory = category / 10
	Outfit selectedOutfit = None
	if subCategory == 1
		Sleepwear = false
		selectedOutfit = Outfits_Clothing[callback]
	Elseif subCategory == 2
		Sleepwear = false
		selectedOutfit = Outfits_LightArmor[callback]
	Elseif subCategory == 3
		Sleepwear = false
		selectedOutfit = Outfits_HeavyArmor[callback]
	Elseif subCategory == 4
		Sleepwear = true
		selectedOutfit = Outfits_Clothing[callback]
	Elseif subCategory == 5
		Sleepwear = true
		selectedOutfit = Outfits_LightArmor[callback]
	Elseif subCategory == 6
		Sleepwear = true
		selectedOutfit = Outfits_HeavyArmor[callback]
	Elseif subCategory == 8
		Sleepwear = false
		selectedOutfit = None
	Elseif subCategory == 9
		Sleepwear = true
		selectedOutfit = None
	Endif
	XFLMain.XFL_SendActionEvent(GetIdentifier(), 0, akForm, selectedOutfit, Sleepwear as Int)
EndEvent


; 0 Barkeeper
; 1 Blacksmith
; 2 Fine
; 3 Farm
; 4 Jester
; 5 Wench
; 6 Nocturnal
; 7 Wedding Dress

; 0 Hide
; 1 Studded
; 2 Stormcloak
; 3 Imperial
; 4 Forsworn
; 5 Elven
; 6 Thieves Guild

; 0 Iron
; 1 Banded Iron
; 2 Steel
; 3 Housecarl
; 4 Imperial
; 5 Steel Plate
; 6 Dwarven