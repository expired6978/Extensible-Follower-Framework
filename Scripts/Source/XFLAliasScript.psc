ScriptName XFLAliasScript extends ReferenceAlias

XFLScript Property XFLMain Auto

Event OnUpdateGameTime()
	;kill the update if the follower isn't waiting anymore
	If (Self.GetReference() as Actor).GetAv("WaitingforPlayer") == 0
		UnRegisterForUpdateGameTime()
	Else
; 		debug.trace(self + "Dismissing the follower because he is waiting and 3 days have passed.")\
		If XFLMain.XFL_Config_IgnoreTimeout.GetValueInt() == 0 ; Ignore 3 day dismiss timeout disabled
			XFLMain.XFL_RemoveFollower(Self.GetReference() as Actor, 5)
		EndIf
		UnRegisterForUpdateGameTime()
	EndIf	
EndEvent

Event OnUnload()
	;if follower unloads while waiting for the player, wait three days then dismiss him.
	If (Self.GetReference() as Actor).GetAv("WaitingforPlayer") == 1
		XFLMain.XFL_SetWait(Self.GetReference() as Actor)
	EndIf
EndEvent

Event OnCombatStateChanged(Actor akTarget, int aeCombatState)

	If aeCombatState == 1
		If (akTarget == Game.GetPlayer())
			XFLMain.XFL_RemoveFollower((Self.GetReference() as Actor), 0, 0)
		Else
			If akTarget && akTarget.IsInFaction(XFLMain.XFL_FollowerFaction) ; Entering combat with another follower, stop this rubbish!
				(Self.GetReference() as Actor).StopCombatAlarm()
			EndIf
		EndIf
	EndIf
	
	; This event is very unstable, not the best thing to pull information from
	;XFLMain.XFL_SendPluginEvent(6, Self.GetActorRef(), akTarget, aeCombatState)
EndEvent

Event OnDeath(Actor akKiller)
	XFLMain.XFL_RemoveDeadFollower(Self.GetReference() as Actor)
EndEvent
