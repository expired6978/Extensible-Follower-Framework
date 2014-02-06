Scriptname XFLScript extends Quest Conditional

DialogueFollowerScript Property FollowerScript Auto
XFLMenuScript Property XFLMenu Auto

Topic Property DialogueFollowerDismissTopic Auto ; Don't use the package anymore

GlobalVariable Property XFL_FollowerCountEx Auto
GlobalVariable Property XFL_MaximumFollowers Auto

GlobalVariable Property XFL_Config_IgnoreTimeout Auto

ReferenceAlias[] Property XFL_FollowerAliases Auto 
Faction Property XFL_FollowerFaction Auto

Message Property XFL_FollowerDeathMessage Auto

FormList Property XFL_FollowerPlugins Auto
FormList Property XFL_FollowerList  Auto  

Activator Property XFL_PortalEffect Auto
Spell Property XFL_Portal Auto

Spell Property XFL_FollowerTelepathy Auto
Spell Property XFL_FollowerTeleportation Auto
Spell Property XFL_FollowerFocusTarget Auto

XFLOutfit Property XFL_OutfitController Auto
XFLPanel Property XFL_Panel Auto

float[] Property recruitTimes Auto
bool[] Property tmRestore Auto
bool[] Property ffRestore Auto

Int lastMaximum = 0
Bool Property XFL_AutoSandboxing = false Auto Conditional

int Property PLUGIN_EVENT_CLEAR_ALL = -1 Autoreadonly
int Property PLUGIN_EVENT_WAIT = 0x04 Autoreadonly
int Property PLUGIN_EVENT_SANDBOX = 0x05 Autoreadonly
int Property PLUGIN_EVENT_FOLLOW = 0x03 Autoreadonly
int Property PLUGIN_EVENT_ADD_FOLLOWER = 0x00 Autoreadonly
int Property PLUGIN_EVENT_REMOVE_FOLLOWER = 0x01 Autoreadonly
int Property PLUGIN_EVENT_REMOVE_DEAD_FOLLOWER = 0x02 Autoreadonly

; Check for game extensions
bool Property SKSEExtended Auto ; SKSE Loaded
bool Property DLC1Extended Auto ; DLC1 Dawnguard Loaded
bool Property MENUExtended Auto ; Menu System Loaded
bool Property APNLExtended Auto ; Actor Panel Loaded
bool Property SKSEEvents Auto ; SKSE Event Callbacks available

Event OnInit()
	XFL_RegisterExtensions()
EndEvent

Function XFL_RegisterExtensions()
	; Check SKSE version
	float skseVersion = SKSE.GetVersion() + (SKSE.GetVersionMinor() / 10.0) + (SKSE.GetVersionBeta() / 100.0)
	If skseVersion >= 1.60
		Debug.Trace("EFF Notification: SKSE Loaded.")
		SKSEExtended = true
	Else
		Debug.Trace("EFF ERROR: SKSE version 1.6.0 not met, some features will be unavailable.")
		SKSEExtended = false
		XFLMenu.XFL_Config_UseClassicMenus.value = 1
	Endif

	If SKSE.GetVersionRelease() >= 44 ; 45
		Debug.Trace("EFF Notification: SKSE Callback functions Loaded.")
		; Register all system actions
		RegisterForModEvent("XFL_System_ActionEvent", "XFL_SendActionEvent")
		RegisterForModEvent("XFL_System_AddFollower", "XFL_AddFollower")
		RegisterForModEvent("XFL_System_Wait", "XFL_SetWait")
		RegisterForModEvent("XFL_System_Sandbox", "XFL_SetSandbox")
		RegisterForModEvent("XFL_System_Follow", "XFL_SetFollow")
		RegisterForModEvent("XFL_System_Dismiss", "XFL_RemoveFollower")

		RegisterForModEvent("XFL_System_WaitAll", "XFL_WaitAll")
		RegisterForModEvent("XFL_System_FollowAll", "XFL_FollowAll")
		RegisterForModEvent("XFL_System_SandboxAll", "XFL_SandboxAll")
		RegisterForModEvent("XFL_System_RemoveAll", "XFL_RemoveAll")
		RegisterForModEvent("XFL_System_EvaluateAll", "XFL_EvaluateAll")
		RegisterForModEvent("XFL_System_SneakAll", "XFL_SneakAll")

		RegisterForModEvent("XFL_System_WaitList", "XFL_WaitList")
		RegisterForModEvent("XFL_System_FollowList", "XFL_FollowList")
		RegisterForModEvent("XFL_System_SandboxList", "XFL_SandboxList")
		RegisterForModEvent("XFL_System_RemoveList", "XFL_RemoveList")
		SKSEEvents = true
	Else
		Debug.Trace("EFF ERROR: SKSE version too old for event based triggers, some features will be unavailable.")
		SKSEEvents = false
	Endif

	; Check for DLC1
	bool DLC1Check = (Game.GetFormFromFile(0x588C, "Dawnguard.esm") != None) ; Checks for DLC1VampireTurnScript Quest
	If DLC1Check
		Debug.Trace("EFF Notification: Dawnguard loaded.")
		DLC1Extended = true
	Else
		DLC1Extended = false
	Endif
	; Check for menu system
	bool MENUCheck = (Game.GetFormFromFile(0xE00, "UIExtensions.esp") != None)
	If MENUCheck
		Debug.Trace("EFF Notification: Menu system loaded.")
		MENUExtended = true
	Else
		Debug.Trace("EFF WARNING: Menu system disabled, plugin failed to load.")
		MENUExtended = false
		XFLMenu.XFL_Config_UseClassicMenus.value = 1
	Endif
	; Check for panel presence
	XFLPanel actorPanel = (Game.GetFormFromFile(0x800, "XFLPanel.esp") as XFLPanel)
	bool APNLCheck = (actorPanel != None)
	If APNLCheck
		Debug.Trace("EFF Notification: Actor panel loaded.")
		APNLExtended = true
		XFL_Panel = actorPanel
	Else
		Debug.Trace("EFF WARNING: Actor panel disabled, plugin failed to load.")
		APNLExtended = false
		XFL_Panel = None
	Endif
	Actor thePlayer = Game.GetPlayer()
	If !thePlayer.HasSpell(XFL_FollowerTelepathy)
		thePlayer.AddSpell(XFL_FollowerTelepathy)
	Endif
	If !thePlayer.HasSpell(XFL_FollowerTeleportation)
		thePlayer.AddSpell(XFL_FollowerTeleportation)
	Endif
	If !thePlayer.HasSpell(XFL_FollowerFocusTarget)
		thePlayer.AddSpell(XFL_FollowerFocusTarget)
	Endif
	If SKSEExtended ; Refresh Package Stack when sneaking
		RegisterForControl("Sneak")
	Endif
EndFunction

Function XFL_RegisterPlugin(Quest questRef)
	If XFL_FollowerPlugins
		If !XFL_FollowerPlugins.HasForm(questRef)
			XFL_FollowerPlugins.AddForm(questRef)
		EndIf
	EndIf
EndFunction

Event OnControlDown(string control)
	If control == "Sneak"
		bool isPlayerSneaking = Game.GetPlayer().IsSneaking()
		XFL_SneakAll(isPlayerSneaking, isPlayerSneaking)
	Endif
EndEvent

Function XFL_SetWait(Form follower)
	Actor FollowerActor = follower as Actor
	If !FollowerActor
		Debug.Trace("EFF ERROR: SetWait bad input form")
		return
	Endif

	If XFL_isDefault(FollowerActor) ; Follower is still in the vanilla system, use fallback commands
		FollowerScript.FollowerWait()
		return
	EndIf

	FollowerActor.SetActorValue("WaitingForPlayer", 1)
	FollowerActor.EvaluatePackage()
	Int index = XFL_GetIndex(FollowerActor)
	If XFL_Config_IgnoreTimeout.GetValueInt() == 0
		XFL_FollowerAliases[index].RegisterForUpdateGameTime(72)
	EndIf
	SetObjectiveDisplayed(100 + index, true)
	
	XFL_OutfitController.XFL_AddPersistentRef(FollowerActor) ; Add outfit persistence
	XFL_SendSystemEvent(PLUGIN_EVENT_WAIT, FollowerActor)
EndFunction

Function XFL_SetSandbox(Form follower)
	Actor FollowerActor = follower as Actor
	If !FollowerActor
		Debug.Trace("EFF ERROR: SetSandbox bad input form")
		return
	Endif

	If XFL_isDefault(FollowerActor) ; Follower is still in the vanilla system, use fallback commands
		FollowerScript.FollowerWait()
		return
	Endif

	FollowerActor.SetActorValue("WaitingForPlayer", 2)
	FollowerActor.EvaluatePackage()
	SetObjectiveDisplayed(100 + XFL_GetIndex(FollowerActor), true)
	
	XFL_OutfitController.XFL_AddPersistentRef(FollowerActor) ; Add outfit persistence
	XFL_SendSystemEvent(PLUGIN_EVENT_SANDBOX, FollowerActor)
EndFunction

Function XFL_SetFollow(Form follower)
	Actor FollowerActor = follower as Actor
	If !FollowerActor
		Debug.Trace("EFF ERROR: SetFollow bad input form")
		return
	Endif

	If XFL_isDefault(FollowerActor) ; Follower is still in the vanilla system, use fallback commands
		FollowerScript.FollowerFollow()
		return
	EndIf

	FollowerActor.SetActorValue("WaitingForPlayer", 0)
	FollowerActor.EvaluatePackage()
	SetObjectiveDisplayed(100 + XFL_GetIndex(FollowerActor), false)

	XFL_OutfitController.XFL_RemovePersistentRef(FollowerActor) ; Remove outfit persistence, we don't need it as long as they are with us
	XFL_SendSystemEvent(PLUGIN_EVENT_FOLLOW, FollowerActor)
EndFunction

Function XFL_AddFollower(Form follower)
	Actor FollowerActor = follower as Actor
	If !FollowerActor
		Debug.Trace("EFF ERROR: AddFollower bad input form")
		return
	Endif
	If !XFL_isRunning() ; Default to vanilla system, something went wrong
		Debug.Trace("EFF ERROR: Scripts running with no plugin active!")
		FollowerScript.SetFollower(FollowerActor)
		return
	Endif

	If XFL_IsFollower(FollowerActor)
		Debug.Trace("EFF WARNING: Attempted to add a follower who is already one.")
		return
	Endif

	FollowerActor.RemoveFromFaction(FollowerScript.pDismissedFollower)
	
	; They don't like us? Force them to!
	Actor playerActor = Game.GetPlayer()
	If FollowerActor.GetRelationshipRank(playerActor) < 3 && FollowerActor.GetRelationshipRank(playerActor) >= 0
		FollowerActor.SetRelationshipRank(playerActor, 3)
	EndIf
	
	FollowerActor.AddToFaction(XFL_FollowerFaction)
	
	int i = XFL_SetAlias(FollowerActor)
	tmRestore[i] = FollowerActor.IsPlayerTeammate()
	ffRestore[i] = FollowerActor.IsIgnoringFriendlyHits()
	FollowerActor.SetPlayerTeammate(true)
	FollowerActor.IgnoreFriendlyHits(true)

	; Make follower allied with all other followers
	i = 0
	int limit = XFL_GetMaximum()
	While i <= limit
		If XFL_FollowerAliases[i] && XFL_FollowerAliases[i].GetReference() != None
			Actor foundActor = XFL_FollowerAliases[i].GetReference() as Actor
			If FollowerActor.GetRelationshipRank(foundActor) >= 0 && FollowerActor.GetRelationshipRank(foundActor) < 3
				FollowerActor.SetRelationshipRank(foundActor, 3)
			Endif
		EndIf
		i += 1
	EndWhile

	XFL_FollowerList.AddForm(FollowerActor) ; Used by XFLSelectionMenu

	If APNLExtended
		XFL_Panel.AddActors(FollowerActor)
	Endif

	XFL_OutfitController.XFL_RemovePersistentRef(FollowerActor) ; Remove outfit persistence, we don't need it as long as they are with us
	XFL_SendSystemEvent(PLUGIN_EVENT_ADD_FOLLOWER, FollowerActor)
EndFunction

Function XFL_RemoveFollower(Form follower, Int iMessage = 0, Int iSayLine = 1)
	Actor FollowerActor = follower as Actor
	If !FollowerActor
		Debug.Trace("EFF ERROR: RemoveFollower bad input form")
		return
	Endif
	If XFL_isDefault(FollowerActor)
		FollowerScript.DismissFollower()
		return
	EndIf
	If FollowerActor && FollowerActor.IsDead() == False
		If iMessage == 0
			FollowerScript.FollowerDismissMessage.Show()
		ElseIf iMessage == 1
			FollowerScript.FollowerDismissMessageWedding.Show()
		ElseIf iMessage == 2
			FollowerScript.FollowerDismissMessageCompanions.Show()
		ElseIf iMessage == 3
			FollowerScript.FollowerDismissMessageCompanionsMale.Show()
		ElseIf iMessage == 4
			FollowerScript.FollowerDismissMessageCompanionsFemale.Show()
		ElseIf iMessage == 5
			FollowerScript.FollowerDismissMessageWait.Show()
		Else
			;failsafe
			FollowerScript.FollowerDismissMessage.Show()
		EndIf

		int i = XFL_GetIndex(FollowerActor)
		FollowerActor.StopCombatAlarm()
		FollowerActor.AddToFaction(FollowerScript.pDismissedFollower)
		FollowerActor.SetPlayerTeammate(tmRestore[i])
		FollowerActor.IgnoreFriendlyHits(ffRestore[i])
		FollowerActor.RemoveFromFaction(XFL_FollowerFaction)
		FollowerActor.RemoveFromFaction(FollowerScript.pCurrentHireling)
		FollowerActor.SetActorValue("WaitingForPlayer", 0)
		SetObjectiveDisplayed(100 + i, false)
		;hireling rehire function
		FollowerScript.HirelingRehireScript.DismissHireling(FollowerActor.GetActorBase())
		
		If iSayLine == 1
			FollowerActor.Say(DialogueFollowerDismissTopic)
		EndIf
		
		XFL_OutfitController.XFL_AddPersistentRef(FollowerActor) ; Add outfit persistent
		XFL_FollowerList.RemoveAddedForm(FollowerActor)

		If APNLExtended
			XFL_Panel.RemoveActors(FollowerActor)
		Endif

		XFL_SendSystemEvent(PLUGIN_EVENT_REMOVE_FOLLOWER, FollowerActor) ; Event should happen before everything is reset
		XFL_ClearAlias(FollowerActor)
	EndIf
EndFunction

; Follower died, need to remove them from their alias so they can potentially be non-persistent and cleaned up
Function XFL_RemoveDeadFollower(Form follower)
	Actor FollowerActor = follower as Actor
	If !FollowerActor
		Debug.Trace("EFF ERROR: RemoveDeadFollower bad input form")
		return
	Endif
	If FollowerActor
		If XFL_isDefault(FollowerActor)
			return
		Endif
		XFL_FollowerDeathMessage.Show()
		int i = XFL_GetIndex(FollowerActor)
		FollowerActor.SetPlayerTeammate(tmRestore[i])
		FollowerActor.IgnoreFriendlyHits(ffRestore[i])
		FollowerActor.RemoveFromFaction(XFL_FollowerFaction)
		FollowerActor.RemoveFromFaction(FollowerScript.pCurrentHireling)
		XFL_FollowerList.RemoveAddedForm(FollowerActor)
		SetObjectiveDisplayed(100 + i, false)

		If APNLExtended
			XFL_Panel.RemoveActors(FollowerActor)
		Endif

		XFL_OutfitController.XFL_RemovePersistentRef(FollowerActor) ; Follower died, remove their persistence
		XFL_SendSystemEvent(PLUGIN_EVENT_REMOVE_DEAD_FOLLOWER, FollowerActor)
		XFL_ClearAlias(FollowerActor)
	EndIf
EndFunction

; FollowerCountEx must exist, incase of loose script randomness?
Bool Function XFL_isRunning()
	return XFL_FollowerCountEx
EndFunction

; Actor is part of the vanilla system
Bool Function XFL_isDefault(Actor follower)
	return ((FollowerScript.pFollowerAlias.GetReference() as Actor) == follower)
EndFunction

; Propagate events to all plugins
Function XFL_SendPluginEvent(int akType, Form akRef1 = None, Form akRef2 = None, int aiValue1 = 0, int aiValue2 = 0)
	int i = 0
	While i < XFL_FollowerPlugins.GetSize()
		XFLPlugin plugin = (XFL_FollowerPlugins.GetAt(i) As XFLPlugin)
		if plugin
			plugin.OnPluginEvent(akType, akRef1 as ObjectReference, akRef2 as ObjectReference, aiValue1, aiValue2)
		Else
			Debug.Trace("Plugin: " + XFL_FollowerPlugins.GetAt(i) + " event failure at index: " + i + " type: " + akType)
		endif
		i += 1
	EndWhile
EndFunction

XFLPlugin Function XFL_GetPlugin(int akIdentifier)
	int i = 0
	While i < XFL_FollowerPlugins.GetSize()
		XFLPlugin plugin = (XFL_FollowerPlugins.GetAt(i) As XFLPlugin)
		If plugin && plugin.GetIdentifier() == akIdentifier
			return plugin
		Endif
		i += 1
	EndWhile
	return None
EndFunction

; Sends an event to a specific plugin
; Receiver quest must be a valid XFLPlugin
; akForm1 must be the receiving actor
; - if there is none it will assume the entire group
; - if its a formlist, perform it on the whole list
Function XFL_SendActionEvent(int akIdentifier, int akCmd, Form akForm1 = None, Form akForm2 = None, int aiValue1 = 0, int aiValue2 = 0)
	XFLPlugin plugin = XFL_GetPlugin(akIdentifier)
	if !plugin
		Debug.Trace("Failed plugin event on id: " + akIdentifier + " cmd: " + akCmd)
		return
	endif
	If plugin.GetIdentifier() == akIdentifier
		If akForm1 ; Perform on group of followers
			FormList akFormList = (akForm1 as FormList)
			If akFormList
				int i = 0
				While i < akFormList.GetSize()
					plugin.OnActionEvent(akCmd, akFormList.GetAt(i), akForm2, aiValue1, aiValue2)
					i += 1
				EndWhile
			Else ; Perform on one single follower
				plugin.OnActionEvent(akCmd, akForm1, akForm2, aiValue1, aiValue2)
			Endif
		Else ; Perform on ALL followers
			int i = 0
			int limit = XFL_GetMaximum()
			While i <= limit
				If XFL_FollowerAliases[i] && XFL_FollowerAliases[i].GetReference() != None
					plugin.OnActionEvent(akCmd, XFL_FollowerAliases[i].GetReference() as Actor, akForm2, aiValue1, aiValue2)
				EndIf
				i += 1
			EndWhile
		Endif
		return
	Endif
EndFunction

; Updates the alias controlling the blades recruitment
Function XFL_SetLastFollower()
	EXP_DialogueFollowerScript FollowerScriptEx = FollowerScript As EXP_DialogueFollowerScript
	If FollowerScriptEx && FollowerScriptEx.LastFollower
		Actor lastFollower = XFL_GetLastFollower()
		If lastFollower
			FollowerScriptEx.LastFollower.ForceRefTo(lastFollower)
		Else ; No followers left, clear the alias
			FollowerScriptEx.LastFollower.Clear()
		Endif
	Endif
EndFunction

; Used to retrieve the last follower based on time recruited
Actor Function XFL_GetLastFollower()
	int i = 0
	Actor foundActor = None
	float latestTime = 0
	int limit = XFL_GetMaximum()
	While i <= limit ; Find the highest value
		If XFL_FollowerAliases[i] && XFL_FollowerAliases[i].GetReference() && recruitTimes[i] >= latestTime
			latestTime = recruitTimes[i]
			foundActor = XFL_FollowerAliases[i].GetReference() as Actor
		EndIf
		i += 1
	EndWhile
	return foundActor
EndFunction

Actor Function XFL_GetClosestFollower(ObjectReference akSource)
	int i = 0
	Actor foundActor = XFL_FollowerAliases[0].GetReference() as Actor
	int limit = XFL_GetMaximum()
	While i <= limit ; Find the highest value
		If XFL_FollowerAliases[i] && XFL_FollowerAliases[i].GetReference() && akSource.GetDistance(foundActor) < akSource.GetDistance(XFL_FollowerAliases[i].GetReference())
			foundActor = XFL_FollowerAliases[i].GetReference() as Actor
		EndIf
		i += 1
	EndWhile
	return foundActor
EndFunction

; Returns the follower by alias index
Actor Function XFL_GetFollower(int i)
	If !XFL_isRunning()
		return None
	EndIf
	If (i > XFL_FollowerAliases.Length) || i < 0
		return None
	EndIf
	If XFL_FollowerAliases[i]
		return XFL_FollowerAliases[i].GetReference() as Actor
	EndIf
	return None
EndFunction

; Returns the alias index of the follower
Int Function XFL_GetIndex(Actor follower)
	If !XFL_isRunning()
		return -1
	EndIf
	
	return follower.GetActorValue("FavorActive") as Int
EndFunction

; Returns the total number of actual followers
int Function XFL_GetCount()
	If !XFL_isRunning() ; Default to vanilla system if plugin is not loaded
		If (FollowerScript.pFollowerAlias.GetReference())
			return 1
		EndIf
		return 0
	EndIf
	
	; Only iterate the last followers added
	int count = 0
	int i = 0
	int limit = XFL_GetMaximum()
	While i <= limit
		If XFL_FollowerAliases[i] && XFL_FollowerAliases[i].GetReference() != None
			count += 1
		EndIf
		i += 1
	EndWhile

	return count
EndFunction

; Updates the global based on the real number of followers
Function XFL_SetCount()
	If !XFL_isRunning()
		FollowerScript.pPlayerFollowerCount.SetValue(XFL_GetCount())
		return
	EndIf
	XFL_FollowerCountEx.SetValue(XFL_GetCount())
EndFunction

; Variable used to limit recursive behavior
int Function XFL_GetMaximum()
	If !XFL_isRunning()
		return -1
	EndIf
	return lastMaximum
EndFunction

Function XFL_SetMaximum()
	Int i = lastMaximum
	While i >= 0
		If XFL_FollowerAliases[i].GetReference() as Actor
			If i < lastMaximum
				lastMaximum = i
			Endif
			return
		Elseif i == 0 ; All the way at the end and still no actor
			lastMaximum = 0
		EndIf
		i -= 1
	EndWhile
EndFunction

; Forcefully clears all statuses and fires the clearall event
Function XFL_ForceClearAll()
	If !XFL_isRunning() ; Default to vanilla system if plugin is not loaded
		Debug.Trace("EFF ERROR: Scripts running with no plugin active!")
		return
	EndIf
	
	XFL_SendSystemEvent(PLUGIN_EVENT_CLEAR_ALL) ; Fire clear all before cleanup
	
	int i = 0
	While i < XFL_FollowerAliases.Length
		If XFL_FollowerAliases[i]
			Actor follower = XFL_FollowerAliases[i].GetReference() as Actor
			If follower
				follower.StopCombatAlarm()
				follower.AddToFaction(FollowerScript.pDismissedFollower)
				follower.SetPlayerTeammate(false)
				follower.IgnoreFriendlyHits(false)
				follower.RemoveFromFaction(XFL_FollowerFaction)
				follower.RemoveFromFaction(FollowerScript.pCurrentHireling)
				follower.SetActorValue("WaitingForPlayer", 0)
				FollowerScript.HirelingRehireScript.DismissHireling(follower.GetActorBase())
				follower.SetActorValue("FavorActive", -1)
				XFL_FollowerList.RemoveAddedForm(follower)
				XFL_FollowerAliases[i].Clear() ; Clear all reference aliases
				SetObjectiveDisplayed(100 + i, false)
			Endif
			recruitTimes[i] = 0
		EndIf
		i += 1
	EndWhile

	XFL_FollowerList.Revert() ; Forcefully clear out the list

	XFL_OutfitController.XFL_ForceClearAll()
	
	; These need to be updated frequently to avoid some weird multithreading glitches
	XFL_SetMaximum()
	XFL_SetCount()
	XFL_SetLastFollower()
EndFunction

; Checks if this actor is one of our followers
bool Function XFL_IsFollower(Actor follower)
	If follower == None
		return false
	EndIf
	int i = 0
	While i <= XFL_GetMaximum()
		If XFL_FollowerAliases[i] && (XFL_FollowerAliases[i].GetReference() as Actor) == follower
			return true
		EndIf
		i += 1
	EndWhile
	return false
EndFunction

; Clears the follower by actor
Function XFL_ClearAlias(Actor follower)
	int i = XFL_GetIndex(follower)
	If XFL_FollowerAliases[i] && (XFL_FollowerAliases[i].GetReference() as Actor) == follower
		follower.SetActorValue("FavorActive", -1)
		recruitTimes[i] = 0.0
		XFL_FollowerAliases[i].Clear() ; Clear the ReferenceAlias that corresponds to this actor
	EndIf

	; These need to be updated frequently to avoid some weird multithreading glitches
	XFL_SetMaximum()
	XFL_SetCount()
	XFL_SetLastFollower()
EndFunction

; Returns the reference alias of the actor
ReferenceAlias Function XFL_GetAlias(Actor follower)
	If !XFL_isRunning() ; Default to vanilla system if plugin is not loaded
		If (FollowerScript.pFollowerAlias.GetReference() as Actor) == follower
			return FollowerScript.pFollowerAlias
		Else
			return None
		EndIf
	EndIf
	
	Int i = XFL_GetIndex(follower)
	If i != -1
		return XFL_FollowerAliases[i] ; Return the ReferenceAlias that corresponds to this actor
	EndIf
	return None
EndFunction

; Sets the reference alias by the actor and returns it
int Function XFL_SetAlias(Actor follower)
	If !XFL_isRunning() ; Default to vanilla system if plugin is not loaded
		FollowerScript.pFollowerAlias.ForceRefIfEmpty(follower)
		return -1
	EndIf
	
	int i = 0
	While i < XFL_FollowerAliases.Length
		If XFL_FollowerAliases[i] && XFL_FollowerAliases[i].ForceRefIfEmpty(follower)
			If i > lastMaximum
				lastMaximum = i
			Endif
			follower.SetActorValue("FavorActive", i)
			recruitTimes[i] = Game.GetRealHoursPassed()
			XFL_SetCount()
			XFL_SetLastFollower()
			return i
		EndIf
		i += 1
	EndWhile
	return -1
EndFunction

; Command: Group Dismiss
Function XFL_RemoveAll(Int iMessage = 0, Int iSayLine = 1)
	int i = 0
	int limit = XFL_GetMaximum()
	While i <= limit
		If XFL_FollowerAliases[i] && XFL_FollowerAliases[i].GetReference() != None
			XFL_RemoveFollower(XFL_FollowerAliases[i].GetReference() as Actor, iMessage, iSayLine)
		EndIf
		i += 1
	EndWhile
	XFL_SetMaximum()
EndFunction

; Command: Group Sandbox
Function XFL_SandboxAll()
	int i = 0
	int limit = XFL_GetMaximum()
	While i <= limit
		If XFL_FollowerAliases[i] && XFL_FollowerAliases[i].GetReference() != None
			XFL_SetSandbox(XFL_FollowerAliases[i].GetReference() as Actor)
		EndIf
		i += 1
	EndWhile
EndFunction

; Command: Group Wait
Function XFL_WaitAll()
	int i = 0
	int limit = XFL_GetMaximum()
	While i <= limit
		If XFL_FollowerAliases[i] && XFL_FollowerAliases[i].GetReference() != None
			XFL_SetWait(XFL_FollowerAliases[i].GetReference() as Actor)
		EndIf
		i += 1
	EndWhile
EndFunction

; Command: Group Follow
Function XFL_FollowAll()
	int i = 0
	int limit = XFL_GetMaximum()
	While i <= limit
		If XFL_FollowerAliases[i] && XFL_FollowerAliases[i].GetReference() != None
			XFL_SetFollow(XFL_FollowerAliases[i].GetReference() as Actor)
		EndIf
		i += 1
	EndWhile
EndFunction

; Command: Evaluate Package
Function XFL_EvaluateAll()
	int i = 0
	int limit = XFL_GetMaximum()
	While i <= limit
		If XFL_FollowerAliases[i] && XFL_FollowerAliases[i].GetReference() != None
			(XFL_FollowerAliases[i].GetReference() as Actor).EvaluatePackage()
		EndIf
		i += 1
	EndWhile
EndFunction

; Command: Sneak All
Function XFL_SneakAll(bool addMuffle = false, bool addLightFoot = false)
	Perk mufflePerk = Game.GetFormFromFile(0x58213, "Skyrim.esm") as Perk
	Perk lightfPerk = Game.GetFormFromFile(0x5820C, "Skyrim.esm") as Perk

	int i = 0
	int limit = XFL_GetMaximum()
	While i <= limit
		If XFL_FollowerAliases[i] && XFL_FollowerAliases[i].GetReference() != None
			Actor akActor = (XFL_FollowerAliases[i].GetReference() as Actor)
			If addMuffle
				If !akActor.HasPerk(mufflePerk)
					akActor.AddPerk(mufflePerk)
				Endif
			Else
				If akActor.HasPerk(mufflePerk)
					akActor.RemovePerk(mufflePerk)
				Endif
			EndIf
			If addLightFoot
				If !akActor.HasPerk(lightfPerk)
					akActor.AddPerk(lightfPerk)
				Endif
			Else
				If akActor.HasPerk(lightfPerk)
					akActor.RemovePerk(lightfPerk)
				Endif
			EndIf
			akActor.EvaluatePackage()
		EndIf
		i += 1
	EndWhile
EndFunction

Function XFL_DismissList(Form akRef, Int iMessage = 0, Int iSayLine = 1)
	Actor akActor = None
	If akRef
		FormList akFormList = (akRef as FormList)
		If akFormList
			int i = 0
			While i < akFormList.GetSize()
				akActor = (akFormList.GetAt(i) as Actor)
				XFL_RemoveFollower(akActor, iMessage, iSayLine)
				i += 1
			EndWhile
		Else
			akActor = (akRef as Actor)
			XFL_RemoveFollower(akActor, iMessage, iSayLine)
		Endif
	Else
		XFL_RemoveAll(iMessage, iSayLine)
	Endif
	XFL_SetMaximum()
EndFunction

Function XFL_SandboxList(Form akRef)
	Actor akActor = None
	If akRef
		FormList akFormList = (akRef as FormList)
		If akFormList
			int i = 0
			While i < akFormList.GetSize()
				akActor = (akFormList.GetAt(i) as Actor)
				XFL_SetSandbox(akActor)
				i += 1
			EndWhile
		Else
			akActor = (akRef as Actor)
			XFL_SetSandbox(akActor)
		Endif
	Else
		XFL_SandboxAll()
	Endif
EndFunction

Function XFL_WaitList(Form akRef)
	Actor akActor = None
	If akRef
		FormList akFormList = (akRef as FormList)
		If akFormList
			int i = 0
			While i < akFormList.GetSize()
				akActor = (akFormList.GetAt(i) as Actor)
				XFL_SetWait(akActor)
				i += 1
			EndWhile
		Else
			akActor = (akRef as Actor)
			XFL_SetWait(akActor)
		Endif
	Else
		XFL_WaitAll()
	Endif
EndFunction

Function XFL_FollowList(Form akRef)
	Actor akActor = None
	If akRef
		FormList akFormList = (akRef as FormList)
		If akFormList
			int i = 0
			While i < akFormList.GetSize()
				akActor = (akFormList.GetAt(i) as Actor)
				XFL_SetFollow(akActor)
				i += 1
			EndWhile
		Else
			akActor = (akRef as Actor)
			XFL_SetFollow(akActor)
		Endif
	Else
		XFL_FollowAll()
	Endif
EndFunction

Function XFL_AutoSandbox(bool engage)
	If engage && !XFL_AutoSandboxing ; Enable sandbox
		XFL_EvaluateAll()
		XFL_AutoSandboxing = true
	Elseif !engage && XFL_AutoSandboxing ; Disable sandbox
		XFL_EvaluateAll()
		XFL_AutoSandboxing = false
	Endif
EndFunction

; Command: Focus Target
; Usage:
; akTarget - Target actor we wish to focus on
; akRef - Source actor we wish to work on
;         Form = Exact Actor
;         FormList = List of Actors
;         None = Entire Group
Function XFL_FocusTarget(Form akTarget, Form akRef, bool safeCheck)
	Actor targetActor = akTarget as Actor
	Actor akActor = None
	If !targetActor
		Debug.Trace("EFF ERROR: FocusTarget bad target")
		return
	Endif
	If akRef
		FormList akFormList = (akRef as FormList)
		If akFormList
			int i = 0
			While i < akFormList.GetSize()
				akActor = (akFormList.GetAt(i) as Actor)
				If (safeCheck && targetActor.isHostileToActor(akActor)) || !safeCheck
					akActor.StartCombat(targetActor)
				Endif
				i += 1
			EndWhile
		Else
			akActor = (akRef as Actor)
			If (safeCheck && targetActor.isHostileToActor(akActor)) || !safeCheck
				akActor.StartCombat(targetActor)
			Endif
		Endif
	Else
		int i = 0
		int limit = XFL_GetMaximum()
		While i <= limit
			If XFL_FollowerAliases[i] && XFL_FollowerAliases[i].GetReference() != None
				akActor = XFL_FollowerAliases[i].GetReference() as Actor
				If (safeCheck && targetActor.isHostileToActor(akActor)) || !safeCheck
					akActor.StartCombat(targetActor)
				Endif
			EndIf
			i += 1
		EndWhile
	Endif
EndFunction

; Command: Teleport
; Usage:
; akTarget - Target actor we wish to teleport to
; akRef - Source actor we wish to work on
;         Form = Exact Actor
;         FormList = List of Actors
;         None = Entire Group
Function XFL_Teleport(Form akTarget, Form akRef)
	Actor targetActor = akTarget as Actor
	If !targetActor
		Debug.Trace("EFF ERROR: Teleport bad target")
		return
	Endif
	Actor akActor = None
	If akRef
		FormList akFormList = (akRef as FormList)
		If akFormList
			int i = 0
			While i < akFormList.GetSize()
				akActor = (akFormList.GetAt(i) as Actor)
				XFL_WarpActor(akActor, targetActor)
				i += 1
			EndWhile
		Else
			akActor = (akRef as Actor)
			XFL_WarpActor(akActor, targetActor)
		Endif
	Else
		int i = 0
		int limit = XFL_GetMaximum()
		While i <= limit
			If XFL_FollowerAliases[i] && XFL_FollowerAliases[i].GetReference() != None
				akActor = XFL_FollowerAliases[i].GetReference() as Actor
				XFL_WarpActor(akActor, targetActor)
			EndIf
			i += 1
		EndWhile
	Endif
EndFunction

Function XFL_WarpActor(Actor akActor, Actor dest)
	;If akActor.GetCurrentLocation().IsLoaded() && akActor.Is3DLoaded()
	;	XFL_Portal.Cast(akActor, dest) ; Portal spell seems to sometimes mistake when the location is loaded and crashes
	if akActor.IsEnabled() ;Elseif akActor.IsEnabled() ; Don't teleport disabled actors
		akActor.DisableNoWait(true)
		akActor.MoveTo(dest, Utility.RandomFloat(-50.0, 50.0), Utility.RandomFloat(-50.0, 50.0))
		akActor.PlaceAtMe(XFL_PortalEffect)
		Utility.Wait(0.5)
		akActor.EnableNoWait(false)
	Endif
EndFunction

Function XFL_SendSystemEvent(int eventID, ObjectReference akRef1 = None, ObjectReference akRef2 = None, int aiValue1 = 0, int aiValue2 = 0)
	XFL_SendPluginEvent(eventID, akRef1, akRef2, aiValue1, aiValue2)

	If SKSEEvents == true ; SKSE events are available
		int handle = ModEvent.Create("XFL_System_PluginEvent")
		ModEvent.PushInt(handle, eventID)
		ModEvent.PushForm(handle, akRef1)
		ModEvent.PushForm(handle, akRef2)
		ModEvent.PushInt(handle, aiValue1)
		ModEvent.PushInt(handle, aiValue2)
		ModEvent.Send(handle)
	Endif
EndFunction