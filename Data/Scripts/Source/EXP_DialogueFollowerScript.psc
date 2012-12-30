ScriptName EXP_DialogueFollowerScript extends DialogueFollowerScript Conditional

; Follower Limit Changes
XFLScript Property XFLMain Auto
ReferenceAlias Property Alias_LoveInterest Auto
ReferenceAlias Property LastFollower Auto

Function DismissFollower(Int iMessage = 0, Int iSayLine = 1)

	If Alias_LoveInterest && (Alias_LoveInterest.GetOwningQuest().GetStage() == 10 || Alias_LoveInterest.GetOwningQuest().GetStage() == 200) ; Check if this was called when the wedding is taking place
		If pFollowerAlias && pFollowerAlias.GetActorRef() != Alias_LoveInterest.GetActorRef() && XFLMain.XFL_IsFollower(Alias_LoveInterest.GetActorRef()); Our follower isn't our wife, check the extended set and remove them if they are
			XFLMain.XFL_RemoveFollower(Alias_LoveInterest.GetActorRef(), iMessage, iSayLine) ; Our wife is part of the extended set remove her
			return
		EndIf
	EndIf
	
	parent.DismissFollower(iMessage, iSayLine)
EndFunction
