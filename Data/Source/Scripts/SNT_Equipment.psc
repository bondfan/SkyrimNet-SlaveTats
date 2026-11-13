Scriptname SNT_Equipment Hidden

Bool Function Contains(Form[] akItems, Form akItem) Global
    Int index = 0
    While index < akItems.Length
        If akItems[index] == akItem
            Return True
        EndIf
        index += 1
    EndWhile
    Return False
EndFunction

Bool Function StillWorn(Actor akWearer, Form akItem) Global
    Int slot = 30
    While slot < 62
        If akWearer.GetWornForm(Armor.GetMaskForSlot(slot)) == akItem
            Return True
        EndIf
        slot += 1
    EndWhile
    Return False
EndFunction

Function StripAndDrop(Actor akWearer) Global
    If !akWearer
        Return
    EndIf
    Keyword jewelry = Keyword.GetKeyword("ArmorJewelry")
    Keyword noStrip
    If Game.GetModByName("SexLab.esm") != 255
        noStrip = Game.GetFormFromFile(0x02F16E, "SexLab.esm") as Keyword
    EndIf
    Form[] protectedItems = PO3_SKSEFunctions.GetQuestItems(akWearer)
    Form[] gear = new Form[32]
    Int count = 0
    Int slot = 30
    While slot < 62
        Armor item = akWearer.GetWornForm(Armor.GetMaskForSlot(slot)) as Armor
        ; Amulet, ring, shield
        Bool keep = slot == 35 || slot == 36 || slot == 39
        If item && !keep && !Contains(gear, item) && !Contains(protectedItems, item)
            If !(jewelry && item.HasKeyword(jewelry)) && !(noStrip && item.HasKeyword(noStrip))
                gear[count] = item
                count += 1
            EndIf
        EndIf
        slot += 1
    EndWhile
    Int index = 0
    While index < count
        Form item = gear[index]
        akWearer.UnequipItem(item, False, True)
        If !StillWorn(akWearer, item)
            akWearer.DropObject(item, 1)
        EndIf
        index += 1
    EndWhile
EndFunction
