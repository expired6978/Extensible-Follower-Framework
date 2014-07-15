;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname EFF_TIF__0200540F Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
;PluginCollect.XFL_BeginCollection(None, 6)
XFLMain.XFL_SendActionEvent(PluginCollect.GetIdentifier(), 0, None, None, 6)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

EFFPluginCollect Property PluginCollect  Auto  

EFFCore Property XFLMain  Auto  
