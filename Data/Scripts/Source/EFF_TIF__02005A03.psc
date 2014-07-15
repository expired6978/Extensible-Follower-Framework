;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname EFF_TIF__02005A03 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
;PluginCombat.ChangeCombatStyle(akspeaker, 5)
XFLMain.XFL_SendActionEvent(PluginCombat.GetIdentifier(), 0, akspeaker, None, 5)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

EFFPluginCombat Property PluginCombat  Auto  

EFFCore Property XFLMain  Auto  
