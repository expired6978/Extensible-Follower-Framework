;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname EFF_TIF__0200A610 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
;PluginSpells.XFL_TeachSpell(Game.GetPlayer(), akspeaker, 1, false)
XFLMain.XFL_SendActionEvent(PluginSpells.GetIdentifier(), 0, Game.GetPlayer(), akspeaker, 1)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

EFFPluginSpells Property PluginSpells  Auto  

EFFCore Property XFLMain  Auto  
