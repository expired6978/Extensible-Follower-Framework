Scriptname EFFAliasOutfit extends ReferenceAlias  

EFFCore Property XFLMain Auto

Form[] Property BipedObjects Auto
Actor Property Player Auto
Form Property EmptySlot Auto

Event OnLoad()
	;Debug.Trace("Loading equipment...")
	LoadEquipment()
EndEvent

;Event OnCellLoad()
	;Debug.Trace("Loading equipment...")
;	LoadEquipment()
;EndEvent

;Event OnCellAttach()
	;Debug.Trace("Loading equipment...")
;	LoadEquipment()
;EndEvent

Function ClearEquipment()
	int i = 0
	While i < BipedObjects.length
		BipedObjects[i] = None
		i += 1
	EndWhile
EndFunction

Function SaveEquipment()
	;Debug.Trace("Saving equipment...")
	Actor actorRef = GetReference() as Actor
	BipedObjects[0] = actorRef.GetEquippedWeapon(true) ; Try weapons first
	BipedObjects[1] = actorRef.GetEquippedWeapon(false)
	if !BipedObjects[0]
		BipedObjects[0] = actorRef.GetEquippedSpell(0) ; No weapon, try spell
	endif
	if !BipedObjects[1]
		BipedObjects[1] = actorRef.GetEquippedShield() ; No weapon try shield
	endif
	if !BipedObjects[1]
		BipedObjects[1] = actorRef.GetEquippedSpell(1) ; No weapon try spell
	endif

	; SKSE check failed
	If XFLMain.SKSEExtended == false
		return
	Endif

	int slot = 1
	int i = 2
	While i < BipedObjects.length
		Form equippedForm = actorRef.GetWornForm(slot)
		if equippedForm
			BipedObjects[i] = equippedForm
		else
			BipedObjects[i] = None
		endif
		slot *= 2
		i += 1
	EndWhile
EndFunction

Function LoadEquipment()
	Actor actorRef = Self.GetReference() as Actor
	If BipedObjects[0] as Weapon && actorRef.GetItemCount(BipedObjects[0]) >= 1
		actorRef.EquipItem(BipedObjects[0])
	Elseif BipedObjects[0] as Spell
		actorRef.EquipSpell(BipedObjects[0] as Spell, 0)
	Endif
	If ((BipedObjects[1] as Weapon) || (BipedObjects[1] as Armor)) && actorRef.GetItemCount(BipedObjects[1]) >= 1
		actorRef.EquipItem(BipedObjects[1])
	Elseif BipedObjects[1] as Spell
		actorRef.EquipSpell(BipedObjects[1] as Spell, 1)
	Endif

	int i = 2
	While i < BipedObjects.length
		if BipedObjects[i]
			; Only equip what they own
			If actorRef.GetItemCount(BipedObjects[i]) >= 1 && !OutfitHasArmor(BipedObjects[i]) ; Only load armor not part of the outfit
				;Debug.Trace("Equipping form: " + BipedObjects[i] + " to i: " + i)
				actorRef.EquipItem(BipedObjects[i])
			Else
				;Debug.Trace("Attempt to equip unowned form: " + BipedObjects[i] + " to i: " + i)
				BipedObjects[i] = None
			Endif
		endif
		i += 1
	EndWhile
EndFunction

; Used to prevent saving outfit items
bool Function OutfitHasArmor(Form outfitArmor)
	Outfit actorOutfit = (Self.GetReference() as Actor).GetActorBase().GetOutfit()
	If actorOutfit
		int i = 0
		While i < actorOutfit.GetNumParts()
			If actorOutfit.GetNthPart(i) == outfitArmor
				return true
			Endif
			i += 1
		EndWhile
	Endif
	return false
EndFunction