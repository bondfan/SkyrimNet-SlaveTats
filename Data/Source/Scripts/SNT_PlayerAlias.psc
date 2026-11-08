Scriptname SNT_PlayerAlias extends ReferenceAlias

Event OnPlayerLoadGame()
    SNT_Main controller = GetOwningQuest() as SNT_Main
    If controller
        controller.Initialize()
    EndIf
EndEvent

Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
    SNT_Main controller = GetOwningQuest() as SNT_Main
    If controller
        controller.RequestRefresh()
    EndIf
EndEvent

Event OnObjectUnequipped(Form akBaseObject, ObjectReference akReference)
    SNT_Main controller = GetOwningQuest() as SNT_Main
    If controller
        controller.RequestRefresh()
    EndIf
EndEvent
