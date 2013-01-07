Scriptname XFLPluginCombat extends XFLPlugin  Conditional

Message Property FollowerCombatMenu Auto
Weapon Property FollowerHuntingBow Auto

Bool isGroup = false

int Function GetIdentifier()
	return 0x1003
EndFunction

string Function GetPluginName()
	return "$Combat"
EndFunction

; akCmd 0 - Change Combot Style
; akForm1 - Receiving Actor
; aiValue1 - Style
Event OnActionEvent(int akCmd, Form akForm1 = None, Form akForm2 = None, int aiValue1 = 0, int aiValue2 = 0)
	If akCmd == 0
		ChangeCombatStyle(akForm1 as Actor, aiValue1)
	Endif
EndEvent

Function ChangeCombatStyle(Actor follower = None, int style = 0)
	If follower != None
		follower.SetActorValue("Variable06", style)
		follower.EvaluatePackage()
		If follower.GetCombatState() == 1 ; Update weaponry if command was issued in combat
			follower.AddItem(FollowerHuntingBow, 1, true) ; Toggle an equip-able item to trigger armor update
			follower.RemoveItem(FollowerHuntingBow, 1)
		Endif
	; Else
	; 	int i = 0
	; 	While i <= XFLMain.XFL_GetMaximum()
	; 		If XFLMain.XFL_FollowerAliases[i] && XFLMain.XFL_FollowerAliases[i].GetActorRef() != None
	; 			Actor followerActor = XFLMain.XFL_FollowerAliases[i].GetActorRef()
	; 			followerActor.SetAV("Variable06", style)
	; 			followerActor.EvaluatePackage()
	; 			If follower.GetCombatState() == 1 ; Update weaponry if command was issued in combat
	; 				followerActor.AddItem(FollowerHuntingBow, 1, true) ; Toggle an equip-able item to trigger weapon update
	; 				followerActor.RemoveItem(FollowerHuntingBow, 1)
	; 			EndIf
	; 		EndIf
	; 		i += 1
	; 	EndWhile
	Endif
EndFunction

Event OnDisabled()
	XFLMain.XFL_SendActionEvent(GetIdentifier(), 0)
EndEvent

; These commands will reset the followers combat style
Event OnPluginEvent(int akType, ObjectReference akRef1 = None, ObjectReference akRef2 = None, int aiValue1 = 0, int aiValue2 = 0)
	If akType == 1 || akType == 2 ; Dismiss only
		ChangeCombatStyle(akRef1 as Actor, 0)
	Endif
EndEvent

; Menu Hierarchy

; Determines whether to show the plugin in the command menu
Bool Function showMenu(Actor follower) ; Re-implement
	return true
EndFunction

; Determines whether to show the plugin in the group command menu
Bool Function showGroupMenu() ; Re-implement
	return true
EndFunction

; Called when the menu is activated
Function activateMenu(int page, Actor follower) ; Re-implement
	isGroup = false
	activateSubMenu(follower, FollowerMenu.GetMenuState("PluginMenu"), page)
EndFunction

; Called when the group menu is activated
Function activateGroupMenu(int page, Actor follower) ; Re-implement
	isGroup = true
	activateSubMenu(follower, FollowerMenu.GetMenuState("PluginMenu"), page)
EndFunction

Function activateSubMenu(Actor followerActor, string previousState = "", int page = 0)
	Int Combat_Back = 6
	Int Combat_Exit = 7
	
	Actor actorRef = None
	If !isGroup
		actorRef = followerActor
	Endif
	
	Int ret = FollowerCombatMenu.Show()
	If ret < Combat_Back
		;ChangeCombatStyle(actorRef, ret)
		FollowerMenu.OnFinishMenu()
		XFLMain.XFL_SendActionEvent(GetIdentifier(), 0, actorRef, None, ret)
	Elseif ret == Combat_Back
		FollowerMenu.XFL_TriggerMenu(followerActor, FollowerMenu.GetMenuState("PluginMenu"), FollowerMenu.GetParentState("PluginMenu"), page) ; Force a back all the way to the plugin menu
	Elseif ret == Combat_Exit
		FollowerMenu.OnFinishMenu()
	Endif
EndFunction



