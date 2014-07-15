Scriptname EFFPluginCombat extends EFFPlugin  Conditional

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
Bool Function showMenu(Form akForm) ; Re-implement
	return true
EndFunction

; Determines whether to show the plugin in the group command menu
Bool Function showGroupMenu() ; Re-implement
	return true
EndFunction

; Called when the menu is activated
Function activateMenu(int page, Form akForm) ; Re-implement
	isGroup = false
	activateSubMenu(akForm, FollowerMenu.GetMenuState("PluginMenu"), page)
EndFunction

; Called when the group menu is activated
Function activateGroupMenu(int page, Form akForm) ; Re-implement
	isGroup = true
	activateSubMenu(akForm, FollowerMenu.GetMenuState("PluginMenu"), page)
EndFunction

Function activateSubMenu(Form akForm, string previousState = "", int page = 0)
	Int Combat_Back = 6
	Int Combat_Exit = 7
	
	Actor actorRef = None
	If !isGroup
		actorRef = akForm as Actor
	Endif
	
	Int ret = FollowerCombatMenu.Show()
	If ret < Combat_Back
		FollowerMenu.OnFinishMenu()
		XFLMain.XFL_SendActionEvent(GetIdentifier(), 0, actorRef, None, ret)
	Elseif ret == Combat_Back
		FollowerMenu.XFL_TriggerMenu(akForm, FollowerMenu.GetMenuState("PluginMenu"), FollowerMenu.GetParentState("PluginMenu"), page) ; Force a back all the way to the plugin menu
	Elseif ret == Combat_Exit
		FollowerMenu.OnFinishMenu()
	Endif
EndFunction


; New menu info
string[] Function GetMenuEntries(Form akForm)
	string[] entries = new string[7]
	int itemOffset = GetIdentifier() * 100
	entries[0] = GetPluginName() + ";;" + -1 + ";;" + GetIdentifier() + ";;" + 0 + ";;1"
	entries[1] = "$Default" + ";;" + GetIdentifier() + ";;" + (itemOffset + 0) + ";;" + 0 + ";;0"
	entries[2] = "$Archer" + ";;" + GetIdentifier() + ";;" + (itemOffset + 1) + ";;" + 1 + ";;0"
	entries[3] = "$Berserker" + ";;" + GetIdentifier() + ";;" + (itemOffset + 2) + ";;" + 2 + ";;0"
	entries[4] = "$Mage" + ";;" + GetIdentifier() + ";;" + (itemOffset + 3) + ";;" + 3 + ";;0"
	entries[5] = "$Thief" + ";;" + GetIdentifier() + ";;" + (itemOffset + 4) + ";;" + 4 + ";;0"
	entries[6] = "$Warrior" + ";;" + GetIdentifier() + ";;" + (itemOffset + 5) + ";;" + 5 + ";;0"
	return entries
EndFunction

Event OnMenuEntryTriggered(Form akForm, int itemId, int callback)
	XFLMain.XFL_SendActionEvent(GetIdentifier(), 0, akForm, None, callback)
EndEvent