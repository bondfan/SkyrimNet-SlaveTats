Scriptname SNT_SlaveTats Hidden

; Returns a retained array, including for an empty result; zero means failure.
Int Function AppliedSnapshot(Actor akWearer) Global
    If !akWearer
        Return 0
    EndIf
    Int matches = JValue.retain(JArray.object())
    If SlaveTatsNG.query_applied_tattoos(akWearer, 0, matches)
        Debug.Trace("[SNT] Applied tattoo query failed", 2)
        Return JValue.release(matches)
    EndIf
    Return matches
EndFunction

; Caller retains ownership of aiApplied. Returned entries belong to that array.
Int Function FindApplied(Int aiApplied, String asSection, String asName) Global
    Int index = 0
    While index < JArray.count(aiApplied)
        Int tattoo = JArray.getObj(aiApplied, index)
        If JMap.getStr(tattoo, "section") == asSection && JMap.getStr(tattoo, "name") == asName
            Return tattoo
        EndIf
        index += 1
    EndWhile
    Return 0
EndFunction

String Function Pool(Int aiTattoo) Global
    String area = JMap.getStr(aiTattoo, "area")
    If area == "Body" || area == "Face" || area == "Hands" || area == "Feet"
        Return area
    EndIf
    Return ""
EndFunction
