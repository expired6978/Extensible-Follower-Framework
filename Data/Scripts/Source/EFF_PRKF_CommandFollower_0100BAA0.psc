;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 9
Scriptname EFF_PRKF_CommandFollower_0100BAA0 Extends Perk Hidden

;BEGIN FRAGMENT Fragment_2
Function Fragment_2(ObjectReference akTargetRef, Actor akActor)
;BEGIN CODE
FollowerMenu.XFL_FollowerMenu(akTargetRef as Actor)
;END CODE
EndFunction
;END FRAGMENT

EFFMenuScript Property FollowerMenu Auto

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
