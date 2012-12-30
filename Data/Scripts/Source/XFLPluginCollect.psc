Scriptname XFLPluginCollect extends XFLPlugin Conditional

ReferenceAlias[] Property XFL_CollectingAliases Auto 

Message Property FollowerGather Auto
Message Property FollowerCollect Auto

Float Property XFL_MessageMod_State Auto Conditional

; 3 - Flora
; 4 - Ammo
; 5 - Armor
; 6 - Books
; 7 - Food
; 8 - Ingredients
; 9 - Keys
; 10 - Misc
; 11 - Weapons

Int lastMaximum = 0
bool isGroup = false

int Function GetIdentifier()
	return 0x1000
EndFunction

string Function GetPluginName()
	return "$Collect"
EndFunction

; akCmd 0 - Start
; akCmd 1 - Stop
; akForm1 - Receiving Actor
; aiValue1 - Collection type
Event OnActionEvent(int akCmd, Form akForm1 = None, Form akForm2 = None, int aiValue1 = 0, int aiValue2 = 0)
	If akCmd == 0
		XFL_StartCollecting(akForm1 as Actor, aiValue1)
	Elseif akCmd == 1
		XFL_StopCollecting(akForm1 as Actor)
	Endif
EndEvent

; Command: Collect
; Function XFL_BeginCollection(Actor follower = None, Int type = 3)
; 	If follower != None
; 		XFL_StartCollecting(follower, type)
; 	Else
; 		int i = 0
; 		While i < XFLMain.XFL_GetMaximum()
; 			If XFLMain.XFL_FollowerAliases[i] && XFLMain.XFL_FollowerAliases[i].GetActorRef() != None
; 				XFL_StartCollecting(XFLMain.XFL_FollowerAliases[i].GetActorRef(), type)
; 			EndIf
; 			i += 1
; 		EndWhile
; 	Endif
; Endfunction

; ; Command: Stop Collect
; Function XFL_EndCollection(Actor follower = None)
; 	If follower != None
; 		XFL_StopCollecting(follower)
; 	Else
; 		int i = 0
; 		While i <= XFLMain.XFL_GetMaximum()
; 			If XFLMain.XFL_FollowerAliases[i] && XFLMain.XFL_FollowerAliases[i].GetActorRef() != None
; 				XFL_StopCollecting(XFLMain.XFL_FollowerAliases[i].GetActorRef())
; 			EndIf
; 			i += 1
; 		EndWhile
; 	Endif
; Endfunction

; Initializes a collection state
Function XFL_StartCollecting(Actor follower, Int type = 3)
	If type < 3 || type > 11 ; Invalid collection type
		return
	EndIf
	float waitState = follower.GetActorValue("WaitingForPlayer")
	If waitState >= 3 && waitState <= 11 ; Already collecting, refresh state
		follower.SetActorValue("WaitingForPlayer", type)
		follower.EvaluatePackage()
	Else
		follower.SetAV("WaitingForPlayer", type)
		XFL_SetAlias(follower)
	EndIf
EndFunction

; Uninitializes a collection state
Function XFL_StopCollecting(Actor follower)
	float waitState = follower.GetActorValue("WaitingForPlayer")
	If waitState >= 3 && waitState <= 11
		follower.SetActorValue("WaitingForPlayer", 0)
	EndIf
	XFL_ClearAlias(follower)
EndFunction

; Sets the collection alias and returns it
Function XFL_SetAlias(Actor follower)
	int i = XFLMain.XFL_GetIndex(follower)
	If i != -1
		XFL_CollectingAliases[i].ForceRefIfEmpty(follower)
	EndIf
EndFunction

; Clears the alias by actor
Function XFL_ClearAlias(Actor follower)
	int i = XFLMain.XFL_GetIndex(follower)
	If XFL_CollectingAliases[i] && (XFL_CollectingAliases[i].GetReference() as Actor) == follower
		XFL_CollectingAliases[i].Clear() ; Clear the ReferenceAlias that corresponds to this actor
	EndIf
EndFunction

Function XFL_ForceClearAll()
	int i = 0
	While i < XFL_CollectingAliases.Length
		If XFL_CollectingAliases[i]
			If XFL_CollectingAliases[i].GetReference() as Actor
				float waitState = (XFL_CollectingAliases[i].GetReference() as Actor).GetActorValue("WaitingForPlayer")
				If waitState >= 3 && waitState <= 11
					(XFL_CollectingAliases[i].GetReference() as Actor).SetActorValue("WaitingForPlayer", 0)
				Endif
			Endif
			XFL_CollectingAliases[i].Clear()
		EndIf
		i += 1
	EndWhile
EndFunction

Event OnDisable()
	XFL_ForceClearAll()
EndEvent

; All of these plugin events will stop the follower from collecting
Event OnPluginEvent(int akType, ObjectReference akRef1 = None, ObjectReference akRef2 = None, int aiValue1 = 0, int aiValue2 = 0)
	If akType >= 1 && akType <= 5 ; All actions except Add
		XFL_ClearAlias(akRef1 as Actor)
	Elseif akType == -1 ; Clearall happens before the actual event
		XFL_ForceClearAll()
	Endif
EndEvent

; Menu hierarchy
Function activateMenu(int page, Actor follower) ; Re-implement
	isGroup = false
	XFL_TriggerMenu(follower, "MenuCollect", "PluginMenu", page)
EndFunction

Function activateGroupMenu(int page, Actor follower) ; Re-implement
	isGroup = true
	XFL_TriggerMenu(follower, "MenuCollect", "PluginMenu", page)
EndFunction

Bool Function showMenu(Actor follower) ; Re-implement
	return true
EndFunction

Bool Function showGroupMenu() ; Re-implement
	return true
EndFunction

Function activateSubMenu(Actor followerActor, string previousState = "", int page = 0)
	; Do nothing in blank state
EndFunction

Function XFL_TriggerMenu(Actor followerActor, string menuState = "", string previousState = "", int page = 0)
	GoToState(menuState)
	activateSubMenu(followerActor, previousState, page)
EndFunction

State MenuCollect ; Choose which type of outfit to wear
	Function activateSubMenu(Actor followerActor, string previousState = "", int page = 0)
		Int Collect_Gather = 0
		Int Collect_Stop = 1
		Int Collect_Back = 2
		Int Collect_Exit = 3
		
		If previousState != ""
			FollowerMenu.XFL_MessageMod_Back = 1
		EndIf

		Actor actorRef = None
		If !isGroup
			actorRef = followerActor
		Endif
		
		If actorRef != None
			XFL_MessageMod_State = actorRef.GetActorValue("WaitingForPlayer")
		Else
			XFL_MessageMod_State = 0
		Endif
		
		int ret = FollowerCollect.Show()
		If ret == Collect_Gather
			XFL_TriggerMenu(followerActor, "MenuGather", GetState(), page)
			FollowerMenu.OnFinishMenu()
		Elseif ret == Collect_Stop
			;XFL_EndCollection(followerActor)
			XFLMain.XFL_SendActionEvent(GetIdentifier(), 1, actorRef)
			FollowerMenu.OnFinishMenu()
		Elseif ret == Collect_Back
			FollowerMenu.XFL_TriggerMenu(followerActor, "PluginMenu", FollowerMenu.GetParentState("PluginMenu"), page) ; Force a back all the way to the plugin menu
		Elseif ret == Collect_Exit
			FollowerMenu.OnFinishMenu()
		EndIf
		
		GoToState("")
	EndFunction
EndState

State MenuGather ; Choose which type of outfit to wear
	Function activateSubMenu(Actor followerActor, string previousState = "", int page = 0)
		Int Gather_Back = 9
		
		If previousState != ""
			FollowerMenu.XFL_MessageMod_Back = 1
		EndIf

		Actor actorRef = None
		If !isGroup
			actorRef = followerActor
		Endif
		
		If actorRef != None
			XFL_MessageMod_State = actorRef.GetActorValue("WaitingForPlayer")
		Else
			XFL_MessageMod_State = 0
		Endif
		
		Int ret = FollowerGather.Show()
		If ret < Gather_Back
			;XFL_BeginCollection(followerActor, ret + 3)
			FollowerMenu.OnFinishMenu()
			XFLMain.XFL_SendActionEvent(GetIdentifier(), 0, actorRef, None, ret + 3)
		Elseif ret == Gather_Back
			XFL_TriggerMenu(followerActor, "MenuCollect", "PluginMenu", page)
		EndIf
		
		GoToState("")
	EndFunction
EndState
