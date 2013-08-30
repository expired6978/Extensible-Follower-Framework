ScriptName XFLAliasScript extends ReferenceAlias

XFLScript Property XFLMain Auto

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
		If (akTarget == Game.GetPlayer())
			XFLMain.XFL_RemoveFollower(actorRefr, 0, 0)
		Else
			If akTarget && akTarget.IsInFaction(XFLMain.XFL_FollowerFaction) ; Entering combat with another follower, stop this rubbish!
				actorRefr.StopCombatAlarm()
			EndIf
		EndIf
	EndIf
	
	; This event is very unstable, not the best thing to pull information from
	;XFLMain.XFL_SendPluginEvent(6, Self.GetActorRef(), akTarget, aeCombatState)
EndEvent

Event OnDeath(Actor akKiller)
	XFLMain.XFL_RemoveDeadFollower(Self.GetReference() as Actor)
EndEvent
