# Code review 2026-11-18

Scope: `Data/Source/Scripts/*.psc`, SkyrimNet action/prompts.

## Performance

1. **Candidate rebuild every refresh.** `RefreshCandidates` (SNT_Main.psc:348) iterates all enriched installed sources each refresh. Result depends only on the applied set. Skip when the `applied` string is unchanged.
2. **Every equip change triggers a full refresh.** `SNT_PlayerAlias.OnObjectEquipped/Unequipped` fire for weapons, spells, ammo, and items other mods swap. Each schedules a full refresh 0.5 s later. Only body slot 32 (nude) affects output. Filter to `Armor` and refresh display only; candidates do not depend on equipment.
3. **`SetupUI` runs every refresh.** `RegisterMod`, `FindView`, two `RegisterListener`, `BindHotkey`, `RegisterForKey`, `GetConfigInt` every 15 s. Run once per load and on settings saved.
4. **`ContainsIdentity` is O(n) per key** (SNT_Main.psc:630), called per saved StorageUtil key. `JMap.hasKey` does the same unless case-folding is the reason; if so, comment it.

## Correctness

5. **Requested refresh lost while a refresh runs.** `RequestRefresh` during `OnUpdate` → second `OnUpdate` sees `_refreshing`, schedules 1 s → first `OnUpdate` ends with `RegisterForSingleUpdate(15.0)`, replacing it. UI visibility toggles and undressing then take up to 15 s. Fix: set a `_pending` flag and end with 0.5 s when set.
6. **Apply action fails if refresh exceeds 5 s.** `ApplyTattoo` waits 50 × 0.1 s for `_refreshing`, then returns False. Likely with item 1 and 2 on large tattoo sets.
7. **Choices can advertise unusable pairs.** Candidates skip only applied tattoos and full pools. `CanApply` also runs SlaveTats' `query_available_tattoos` (requires/excluded_by). A category/position whose every tattoo fails it is still offered; the action then fails.
8. **Gear dropped when apply fails.** `StripAndApply` strips and drops before the second `CanApply` and `Apply`. Failure leaves clothing on the ground without a tattoo.
9. **One bad pack entry disables the mod.** `SNT_Catalog.Load` returns 0 on any invalid entry or duplicate, across all packs. `_reloadCatalog` stays True, so every 15 s it re-reads all pack files and repeats the error trace. Skip the bad entry, or stop retrying until settings save/load.
10. **Visibility choices wiped if first applied snapshot is empty.** After each load `_applied` is 0, so `RefreshTattoos` unsets every `SNT_Visibility:` key not in the snapshot. If SlaveTatsNG returns an empty (non-failed) list before it is ready, all choices are lost. Unverified.
11. **Position casing reaches config keys.** `IsPosition` uses `Find` (case-insensitive). A pack with `"face"` reads `visibility.face`, which may not match the `visibility.Face` setting.
