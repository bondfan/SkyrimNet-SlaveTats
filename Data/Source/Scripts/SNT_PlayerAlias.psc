Scriptname SNT_PlayerAlias extends ReferenceAlias

Event OnPlayerLoadGame()
    SNT_Main controller = GetOwningQuest() as SNT_Main
    If controller
        controller.Initialize()
    EndIf
EndEvent

Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
    RefreshIfBody(akBaseObject)
EndEvent

Event OnObjectUnequipped(Form akBaseObject, ObjectReference akReference)
    RefreshIfBody(akBaseObject)
EndEvent

; Only body slot 32 decides nudity.
Function RefreshIfBody(Form akBaseObject)
    Armor item = akBaseObject as Armor
    If !item || Math.LogicalAnd(item.GetSlotMask(), Armor.GetMaskForSlot(32)) == 0
        Return
    EndIf
    SNT_Main controller = GetOwningQuest() as SNT_Main
    If controller
        controller.RequestRefresh()
    EndIf
EndFunction
