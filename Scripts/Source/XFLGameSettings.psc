Scriptname XFLGameSettings extends Quest

; Incase SetGameSetting moves to Game
import Game
import Utility

float Property fAIDistanceTeammateDrawWeapon
	float Function Get()
		If _fAIDistanceTeammateDrawWeapon == -1.0
			return GetGameSettingFloat("fAIDistanceTeammateDrawWeapon")
		Endif
		return _fAIDistanceTeammateDrawWeapon
	EndFunction
	Function Set(float value)
		_fAIDistanceTeammateDrawWeapon = value
		SetGameSettingFloat("fAIDistanceTeammateDrawWeapon", value)
	EndFunction
EndProperty

float Property fSandboxSearchRadius
	float Function Get()
		If _fSandboxSearchRadius == -1.0
			return GetGameSettingFloat("fSandboxSearchRadius")
		Endif
		return _fSandboxSearchRadius
	EndFunction
	Function Set(float value)
		_fSandboxSearchRadius = value
		SetGameSettingFloat("fSandboxSearchRadius", value)
	EndFunction
EndProperty

int Property iFriendHitCombatAllowed
	int Function Get()
		If _iFriendHitCombatAllowed == -1
			return GetGameSettingInt("iFriendHitCombatAllowed")
		Endif
		return _iFriendHitCombatAllowed
	EndFunction
	Function Set(int value)
		_iFriendHitCombatAllowed = value
		SetGameSettingInt("iFriendHitCombatAllowed", value)
	EndFunction
EndProperty

int Property iNumberActorsAllowedToFollowPlayer
	int Function Get()
		If _iNumberActorsAllowedToFollowPlayer == -1
			return GetGameSettingInt("iNumberActorsAllowedToFollowPlayer")
		Endif
		return _iNumberActorsAllowedToFollowPlayer
	EndFunction
	Function Set(int value)
		_iNumberActorsAllowedToFollowPlayer = value
		SetGameSettingInt("iNumberActorsAllowedToFollowPlayer", value)
	EndFunction
EndProperty

int Property iNumberActorsInCombatPlayer
	int Function Get()
		If _iNumberActorsInCombatPlayer == -1
			return GetGameSettingInt("iNumberActorsInCombatPlayer")
		Endif
		return _iNumberActorsInCombatPlayer
	EndFunction
	Function Set(int value)
		_iNumberActorsInCombatPlayer = value
		SetGameSettingInt("iNumberActorsInCombatPlayer", value)
	EndFunction
EndProperty

int Property iAllyHitNonCombatAllowed
	int Function Get()
		If _iAllyHitNonCombatAllowed == -1
			return GetGameSettingInt("iAllyHitNonCombatAllowed")
		Endif
		return _iFriendHitCombatAllowed
	EndFunction
	Function Set(int value)
		_iAllyHitNonCombatAllowed = value
		SetGameSettingInt("iAllyHitNonCombatAllowed", value)
	EndFunction
EndProperty

int Property iAllyHitCombatAllowed
	int Function Get()
		If _iAllyHitCombatAllowed == -1
			return GetGameSettingInt("iAllyHitCombatAllowed")
		Endif
		return _iAllyHitCombatAllowed
	EndFunction
	Function Set(int value)
		_iAllyHitCombatAllowed = value
		SetGameSettingInt("iAllyHitCombatAllowed", value)
	EndFunction
EndProperty

int Property iFriendHitNonCombatAllowed
	int Function Get()
		If _iFriendHitNonCombatAllowed == -1
			return GetGameSettingInt("iFriendHitNonCombatAllowed")
		Endif
		return _iFriendHitNonCombatAllowed
	EndFunction
	Function Set(int value)
		_iFriendHitNonCombatAllowed = value
		SetGameSettingInt("iFriendHitNonCombatAllowed", value)
	EndFunction
EndProperty

float Property fFollowSpaceBetweenFollowers
	float Function Get()
		If _fFollowSpaceBetweenFollowers == -1.0
			return GetGameSettingFloat("fFollowSpaceBetweenFollowers")
		Endif
		return _fFollowSpaceBetweenFollowers
	EndFunction
	Function Set(float value)
		_fFollowSpaceBetweenFollowers = value
		SetGameSettingFloat("fFollowSpaceBetweenFollowers", value)
	EndFunction
EndProperty

float Property fFollowerSpacingAtDoors
	float Function Get()
		If _fFollowerSpacingAtDoors == -1.0
			return GetGameSettingFloat("fFollowerSpacingAtDoors")
		Endif
		return _fFollowerSpacingAtDoors
	EndFunction
	Function Set(float value)
		_fFollowerSpacingAtDoors = value
		SetGameSettingFloat("fFollowerSpacingAtDoors", value)
	EndFunction
EndProperty

float 	_fAIDistanceTeammateDrawWeapon 		= -1.0
float 	_fSandboxSearchRadius 				= -1.0
int 	_iFriendHitCombatAllowed 			= -1
int 	_iNumberActorsAllowedToFollowPlayer = -1
int 	_iNumberActorsInCombatPlayer 		= -1
int 	_iAllyHitNonCombatAllowed 			= -1
int 	_iAllyHitCombatAllowed 				= -1
float 	_fFollowSpaceBetweenFollowers 		= -1.0
int 	_iFriendHitNonCombatAllowed 		= -1
float 	_fFollowerSpacingAtDoors 			= -1.0

Event OnInit()
	fAIDistanceTeammateDrawWeapon = 0.0
	fSandboxSearchRadius = 8192.0
	iNumberActorsAllowedToFollowPlayer = 100
	iNumberActorsInCombatPlayer = 100
EndEvent

; Reload saved settings
Event OnLoadGameSettings()
	fAIDistanceTeammateDrawWeapon = fAIDistanceTeammateDrawWeapon
	fSandboxSearchRadius = fSandboxSearchRadius
	iFriendHitCombatAllowed = iFriendHitCombatAllowed
	iNumberActorsAllowedToFollowPlayer = iNumberActorsAllowedToFollowPlayer
	iNumberActorsInCombatPlayer = iNumberActorsInCombatPlayer
	iAllyHitNonCombatAllowed = iAllyHitNonCombatAllowed
	iAllyHitCombatAllowed = iAllyHitCombatAllowed
	fFollowSpaceBetweenFollowers = fFollowSpaceBetweenFollowers
	iFriendHitNonCombatAllowed = iFriendHitNonCombatAllowed
	fFollowerSpacingAtDoors = fFollowerSpacingAtDoors
EndEvent
