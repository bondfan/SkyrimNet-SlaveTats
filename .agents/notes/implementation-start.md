# Implementation Start

- Added the initial `SNT_Main` quest script; no feature logic or deployment yet.
- houseCARL found the compiler, but the default imports lacked `TESV_Papyrus_Flags.flg`.
- Adding the existing Original Compiler directory resolved the flags error.
- Compilation then failed on missing vanilla types, including GlobalVariable and ReferenceAlias. No PEX was produced.
- The user approved using `F:/personal/Skyrim-Modding/DcCBCD-Patch/CkScripts`. Inspected GlobalVariable and ReferenceAlias declarations; the initial controller now compiles with that source baseline.
- Saved houseCARL import set: `SkyrimNet-SlaveTats`. Output: `Data/Scripts/SNT_Main.pex`; not deployed or verified in-game.
- Visibility storage agreed: one integer per identity, missing = newly detected, `1` = hidden, `2` = visible; no JSON state document or version field.
- Pack format agreed: plain JSON arrays in `Data/SKSE/Plugins/SkyrimNet-SlaveTats/Packs/`.
- Added and compiled `SNT_Catalog`: directory loading, field/position validation, duplicate rejection, and retained catalog ownership. Installed-tattoo resolution and runtime checks remain pending.
- Implemented and compiled `SNT_Storage`: length-prefixed visibility keys, integer reads/writes, and removal. Invalid wearer/identity inputs are rejected. No deployment or runtime read-back yet.
- Added and compiled `SNT_SlaveTats`: retained applied-tattoo snapshots, section/name matching, and pool validation. Query failure returns zero; a successful empty query returns an array, preventing accidental removal on error.
- Available-catalog queries are domain-scoped. Resolve non-default-domain tattoos before treating a missing default-domain match as an uninstalled tattoo; no catalog filtering was added yet.
