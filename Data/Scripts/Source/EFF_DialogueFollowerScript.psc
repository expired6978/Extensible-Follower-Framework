ScriptName EFF_DialogueFollowerScript extends DialogueFollowerScript Conditional

; Follower Limit Changes
EFFCore Property XFLMain Auto
ReferenceAlias Property Alias_LoveInterest Auto
ReferenceAlias Property LastFollower Auto

; Vanilla DLC to EFF hack
Function SetFollower(ObjectReference FollowerRef)
	If XFLMain.SKSEExtended
		int formId = FollowerRef.GetBaseObject().GetFormId()
		int modIndex = Math.RightShift(formId, 24)
		string sourceMod = Game.GetModName(modIndex)
		If sourceMod == "Dawnguard.esm" || sourceMod == "Dragonborn.esm"
			XFLMain.XFL_AddFollower(FollowerRef as Actor)
		Else
			parent.SetFollower(FollowerRef)
		Endif
	Else
		parent.SetFollower(FollowerRef)
	Endif
EndFunction

Function DismissFollower(Int iMessage = 0, Int iSayLine = 1)

	If Alias_LoveInterest && (Alias_LoveInterest.GetOwningQuest().GetStage() == 10 || Alias_LoveInterest.GetOwningQuest().GetStage() == 200) ; Check if this was called when the wedding is taking place
		If pFollowerAlias && pFollowerAlias.GetActorRef() != Alias_LoveInterest.GetActorRef() && XFLMain.XFL_IsFollower(Alias_LoveInterest.GetActorRef()); Our follower isn't our wife, check the extended set and remove them if they are
			XFLMain.XFL_RemoveFollower(Alias_LoveInterest.GetActorRef(), iMessage, iSayLine) ; Our wife is part of the extended set remove her
			return
		EndIf
	EndIf
	
	parent.DismissFollower(iMessage, iSayLine)
EndFunction
