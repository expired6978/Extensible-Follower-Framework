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

Bool Function showMenu(Actor follower) ; Re-implement
	return true
EndFunction

Bool Function showGroupMenu() ; Re-implement
	return true
EndFunction

Function activateMenu(int page, Actor follower) ; Re-implement
	isGroup = false
	XFL_TriggerMenu(follower, "SubMenuType", "PluginMenu", page)
EndFunction

Function activateGroupMenu(int page, Actor follower) ; Re-implement
	; Do nothing
	isGroup = true
	XFL_TriggerMenu(follower, "SubMenuType", "PluginMenu", page)
EndFunction

Function XFL_TriggerMenu(Actor followerActor, string menuState = "", string previousState = "", int page = 0)
	GoToState(menuState)
	activateSubMenu(followerActor, previousState, page)
EndFunction

Function activateSubMenu(Actor followerActor, string previousState = "", int page = 0)
	; Do nothing in blank state
EndFunction

State SubMenuType ; Choose which type of outfit to wear
	Function activateSubMenu(Actor followerActor, string previousState = "", int page = 0)
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
			XFL_TriggerMenu(followerActor, "SubMenuOutfit", GetState(), page)
		Elseif ret == OutfitMenu_Sleepwear
			Sleepwear = true
			XFL_TriggerMenu(followerActor, "SubMenuOutfit", GetState(), page)
		Elseif ret == OutfitMenu_Back
			FollowerMenu.XFL_TriggerMenu(followerActor, "PluginMenu", FollowerMenu.GetParentState("PluginMenu"), page) ; Force a back all the way to the plugin menu
		Elseif ret == OutfitMenu_Exit
			FollowerMenu.OnFinishMenu()
		Endif
		
		GoToState("")
	EndFunction
EndState

State SubMenuOutfit
	Function activateSubMenu(Actor followerActor, string previousState = "", int page = 0)
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
			actorRef = followerActor
		Endif

		Alias_Outfit.ForceRefTo(MenuRef) ; Menu text
		int ret = FollowerOutfitMenu.Show()
		If ret == OutfitMenu_None
			;ApplyOutfit(actorRef, None, Sleepwear)
			FollowerMenu.OnFinishMenu()
			XFLMain.XFL_SendActionEvent(GetIdentifier(), 0, actorRef, None, Sleepwear as Int)
		Elseif ret == OutfitMenu_Clothing
			XFL_TriggerMenu(followerActor, "SubMenuOutfitClothing", GetState(), page)
		Elseif ret == OutfitMenu_LightArmor
			XFL_TriggerMenu(followerActor, "SubMenuOutfitLight", GetState(), page)
		Elseif ret == OutfitMenu_HeavyArmor
			XFL_TriggerMenu(followerActor, "SubMenuOutfitHeavy", GetState(), page)
		Elseif ret == OutfitMenu_Back
			XFL_TriggerMenu(followerActor, "SubMenuType", "PluginMenu", page)
		Elseif ret == OutfitMenu_Exit
			FollowerMenu.OnFinishMenu()
		Endif
		
		GoToState("")
	EndFunction
EndState

State SubMenuOutfitClothing
	Function activateSubMenu(Actor followerActor, string previousState = "", int page = 0)
		int OutfitMenu_Back = 8
		int OutfitMenu_Exit = 9

		If previousState != ""
			FollowerMenu.XFL_MessageMod_Back = 1
		EndIf
		
		Actor actorRef = None
		If !isGroup
			actorRef = followerActor
		Endif

		Alias_Outfit.ForceRefTo(MenuRef) ; Menu text
		int ret = FollowerOutfitClothingMenu.Show()
		If ret < OutfitMenu_Back
			;ApplyOutfit(actorRef, Outfits_Clothing[ret], Sleepwear)
			FollowerMenu.OnFinishMenu()
			XFLMain.XFL_SendActionEvent(GetIdentifier(), 0, actorRef, Outfits_Clothing[ret], Sleepwear as Int)
		Elseif ret == OutfitMenu_Back
			XFL_TriggerMenu(followerActor, previousState, "SubMenuOutfit", page)
		Elseif ret == OutfitMenu_Exit
			FollowerMenu.OnFinishMenu()
		Endif
		
		GoToState("")
	EndFunction
EndState

State SubMenuOutfitLight
	Function activateSubMenu(Actor followerActor, string previousState = "", int page = 0)
		int OutfitMenu_Back = 7
		int OutfitMenu_Exit = 8

		If previousState != ""
			FollowerMenu.XFL_MessageMod_Back = 1
		EndIf
		
		Actor actorRef = None
		If !isGroup
			actorRef = followerActor
		Endif

		Alias_Outfit.ForceRefTo(MenuRef) ; Menu text
		int ret = FollowerOutfitLightMenu.Show()
		If ret < OutfitMenu_Back
			;ApplyOutfit(actorRef, Outfits_LightArmor[ret], Sleepwear)
			FollowerMenu.OnFinishMenu()
			XFLMain.XFL_SendActionEvent(GetIdentifier(), 0, actorRef, Outfits_LightArmor[ret], Sleepwear as Int)
		Elseif ret == OutfitMenu_Back
			XFL_TriggerMenu(followerActor, previousState, "SubMenuOutfit", page)
		Elseif ret == OutfitMenu_Exit
			FollowerMenu.OnFinishMenu()
		Endif
		
		GoToState("")
	EndFunction
EndState

State SubMenuOutfitHeavy
	Function activateSubMenu(Actor followerActor, string previousState = "", int page = 0)
		int OutfitMenu_Back = 7
		int OutfitMenu_Exit = 8

		If previousState != ""
			FollowerMenu.XFL_MessageMod_Back = 1
		EndIf
		
		Actor actorRef = None
		If !isGroup
			actorRef = followerActor
		Endif

		Alias_Outfit.ForceRefTo(MenuRef) ; Menu text
		int ret = FollowerOutfitHeavyMenu.Show()
		If ret < OutfitMenu_Back
			;ApplyOutfit(actorRef, Outfits_HeavyArmor[ret], Sleepwear)
			FollowerMenu.OnFinishMenu()
			XFLMain.XFL_SendActionEvent(GetIdentifier(), 0, actorRef, Outfits_HeavyArmor[ret], Sleepwear as Int)
		Elseif ret == OutfitMenu_Back
			XFL_TriggerMenu(followerActor, previousState, "SubMenuOutfit", page)
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
	; Else
	; 	int i = 0
	; 	While i <= XFLMain.XFL_GetMaximum()
	; 		If XFLMain.XFL_FollowerAliases[i] && XFLMain.XFL_FollowerAliases[i].GetActorRef() != None
	; 			XFLMain.XFL_FollowerAliases[i].GetActorRef().SetOutfit(outfitRef, isSleepwear)
	; 		EndIf
	; 		i += 1
	; 	EndWhile
	Endif
EndFunction
