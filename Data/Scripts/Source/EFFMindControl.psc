Scriptname EFFMindControl extends ActiveMagicEffect  

EFFCore Property XFLMain  Auto  
; int relationship = 0

Event OnEffectStart(Actor akTarget, Actor akCaster)
	; relationship = akTarget.GetRelationshipRank(akCaster)
	If !akTarget.IsInFaction(XFLMain.XFL_FollowerFaction)
		if akTarget
			XFLMain.XFL_AddFollower(akTarget)
		endif
	Endif
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	; XFLMain.XFL_RemoveFollower(akTarget, 0, 0)
	; akTarget.SetRelationshipRank(akCaster, relationship)
EndEvent
