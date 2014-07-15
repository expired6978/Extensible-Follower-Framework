;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 4
Scriptname EFF_QF_FollowerMenu_0100C565 Extends Quest Hidden

;BEGIN ALIAS PROPERTY Plugin002
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Plugin002 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Configuration
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Configuration Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Plugin000
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Plugin000 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Plugin006
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Plugin006 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Plugin003
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Plugin003 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Plugin005
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Plugin005 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Plugin001
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Plugin001 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Follower
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Follower Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Player
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Player Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Plugin004
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Plugin004 Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN AUTOCAST TYPE EFFMenuScript
Quest __temp = self as Quest
EFFMenuScript kmyQuest = __temp as EFFMenuScript
;END AUTOCAST
;BEGIN CODE
kmyQuest.XFL_Features()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
