;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname EXP_TIF__020059F9 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
;PluginCombat.ChangeCombatStyle(akspeaker, 0)
XFLMain.XFL_SendActionEvent(PluginCombat.GetIdentifier(), 0, akspeaker, None, 0)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

XFLPluginCombat Property PluginCombat  Auto  

XFLScript Property XFLMain  Auto  
