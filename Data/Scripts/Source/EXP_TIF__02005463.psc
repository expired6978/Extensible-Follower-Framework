;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname EXP_TIF__02005463 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
;PluginOutfit.ApplyOutfit(None, PluginOutfit.Outfits_Clothing[4], true)
XFLMain.XFL_SendActionEvent(PluginOutfit.GetIdentifier(), 0, None, PluginOutfit.Outfits_Clothing[4], 1)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

XFLPluginOutfit Property PluginOutfit  Auto  

XFLScript Property XFLMain  Auto  