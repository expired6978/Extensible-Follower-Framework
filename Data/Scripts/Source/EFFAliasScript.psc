ScriptName EFFAliasScript extends ReferenceAlias

EFFCore Property XFLMain Auto

Event OnUpdateGameTime()
	;kill the update if the follower isn't waiting anymore
	Actor actorRefr = Self.GetReference() as Actor
	If actorRefr.GetAv("WaitingforPlayer") == 0
		UnRegisterForUpdateGameTime()
	Else
; 		debug.trace(self + "Dismissing the follower because he is waiting and 3 days have passed.")\
		If XFLMain.XFL_Config_IgnoreTimeout.GetValueInt() == 0 ; Ignore 3 day dismiss timeout disabled
			XFLMain.XFL_RemoveFollower(actorRefr, 5)
		EndIf
		UnRegisterForUpdateGameTime()
	EndIf	
EndEvent

Event OnUnload()
	;if follower unloads while waiting for the player, wait three days then dismiss him.
	Actor actorRefr = Self.GetReference() as Actor
	If actorRefr.GetAv("WaitingforPlayer") == 1
		XFLMain.XFL_SetWait(actorRefr)
	EndIf
EndEvent

Event OnCombatStateChanged(Actor akTarget, int aeCombatState)

	If aeCombatState == 1
		Actor actorRefr = Self.GetReference() as Actor
		If (akTarget == Game.GetPlayer()) ; We pissed off our follower guess we aren't friends anymore
			XFLMain.XFL_RemoveFollower(actorRefr, 0, 0)
		Else
			If akTarget && akTarget.IsInFaction(XFLMain.XFL_FollowerFaction) || akTarget.IsPlayerTeammate() ; Entering combat with another teammate, stop this rubbish!
				actorRefr.StopCombatAlarm()
				akTarget.StopCombatAlarm()
				actorRefr.SetRelationshipRank(akTarget, 3) ; I'm sorry lets be friend again :(
				akTarget.SetRelationshipRank(actorRefr, 3) ; Yeah ok
			EndIf
		EndIf
	EndIf
	
	; This event is very unstable, not the best thing to pull information from
	;XFLMain.XFL_SendPluginEvent(6, Self.GetActorRef(), akTarget, aeCombatState)
EndEvent

Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
	bool fromSelf = (akSourceContainer == Self.GetReference())
	bool fromPlayer = (akSourceContainer == Game.GetPlayer())
	bool fromWorld = (akSourceContainer == None)
	bool isEquippable = (akBaseItem as Weapon) || (akBaseItem as Armor) || (akBaseItem as Light)
	bool isFoodItem = (akBaseItem As Potion) && (akBaseItem As Potion).IsFood() ; ADDED
	If akItemReference
		Form refBase = akItemReference.GetBaseObject()
		isEquippable = (refBase as Weapon) || (refBase as Armor) || (refBase as Light)
	Endif
	If fromWorld && !fromSelf && !fromPlayer && !isEquippable && !isFoodItem ; Got it from the world, or something other than the player, and it's not equippable nor food
		If akItemReference
			XFLMain.XFL_MoveToInventory(Self.GetReference(), akItemReference, aiItemCount)
		Else
			XFLMain.XFL_MoveToInventory(Self.GetReference(), akBaseItem, aiItemCount)
		Endif
	Endif
EndEvent

Event OnDeath(Actor akKiller)
	XFLMain.XFL_RemoveDeadFollower(Self.GetReference())
EndEvent
