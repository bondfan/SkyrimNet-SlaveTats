Scriptname SNT_Storage Hidden

String Function VisibilityKey(String asSection, String asName) Global
    Return "SNT_Visibility:" + StringUtil.GetLength(asSection) + ":" + asSection + ":" + asName
EndFunction

Int Function GetVisibility(Actor akWearer, String asSection, String asName) Global
    If !akWearer || asSection == "" || asName == ""
        Return 0
    EndIf
    Return StorageUtil.GetIntValue(akWearer, VisibilityKey(asSection, asName), 0)
EndFunction

Bool Function SetVisibility(Actor akWearer, String asSection, String asName, Bool abVisible) Global
    If !akWearer || asSection == "" || asName == ""
        Return False
    EndIf
    Int storedValue = 1
    If abVisible
        storedValue = 2
    EndIf
    Return StorageUtil.SetIntValue(akWearer, VisibilityKey(asSection, asName), storedValue) == storedValue
EndFunction

Bool Function ForgetTattoo(Actor akWearer, String asSection, String asName) Global
    If !akWearer || asSection == "" || asName == ""
        Return False
    EndIf
    Return StorageUtil.UnsetIntValue(akWearer, VisibilityKey(asSection, asName))
EndFunction
