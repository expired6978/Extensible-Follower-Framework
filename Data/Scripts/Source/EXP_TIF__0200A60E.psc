;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname EXP_TIF__0200A60E Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
;PluginSpells.XFL_TeachSpell(Game.GetPlayer(), akspeaker, 0, false)
XFLMain.XFL_SendActionEvent(PluginSpells.GetIdentifier(), 0, Game.GetPlayer(), akspeaker, 0)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

XFLPluginSpells Property PluginSpells  Auto  

XFLScript Property XFLMain  Auto  
