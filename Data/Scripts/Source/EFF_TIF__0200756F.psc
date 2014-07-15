;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname EFF_TIF__0200756F Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
;PluginSandbox.XFL_EndSandbox(akspeaker)
XFLMain.XFL_SendActionEvent(PluginSandbox.GetIdentifier(), 1, akspeaker)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

EFFPluginSandbox Property PluginSandbox  Auto  

EFFCore Property XFLMain  Auto  
