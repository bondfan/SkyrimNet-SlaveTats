# Feature Checkpoint

## Verified

- User confirmed on 2026-11-08 that the hotkey works with the VK-to-DirectInput conversion build.

- After explicit user approval, the live dashboard rendered the actual tattoo prompt fragment successfully: three checked marks were included, the unchecked right-hand mark was absent, and available category/position choices were populated. Unicode quote code points were correct; replacement characters in the first tool display were console encoding only.

- Local dashboard action listing confirms SNT_ApplyTattoo is registered against SNT_MainQuest.ApplyTattoo, enabled, and configured with zero cooldown and the three intended parameters. Eligibility and execution remain separate runtime checks.

- User confirmed on 2026-11-08 that the right-hand checkbox survives closing/reopening, removing torso clothing activates the all-visible notice without changing that checkbox, and dressing restores normal visibility behavior. Save/reload persistence remains a separate unchecked case.

- On 2026-11-08, the running feature build logged seven enrichment entries and seven installed sources. The user's screenshot shows four detected marks, checkbox states, and the dressed-state notice. This verifies catalog discovery, applied-tattoo reconciliation, and Magelight JSON delivery/rendering for that case; save/reload persistence remains unverified.

- The enabled ESL quest initialized on initial load and reload. Papyrus.0.log recorded `[SNT]` startup at 19:46:01 and 19:50:43 on 2026-11-07.
- Runtime responses: SkyrimNet 0.29.2, SlaveTatsNG API version string 2.0.0, PapyrusUtil 46, JContainers API 4, Magelight ready. The SlaveTatsNG string differs from the DLL manifest version; do not use it as a release-version comparison.
- All six feature scripts compile through houseCARL using import set `SkyrimNet-SlaveTats`.
- JSON/YAML parse, settings paths are unique, text files are UTF-8 without BOM, and deployed Data files match repository hashes.
- houseCARL confirms the current mod wins the controller, equipment helper, Magelight HTML, action YAML, and basic enrichment pack.

## Implemented, Awaiting Runtime Checks

- Applied-tattoo reconciliation, integer visibility persistence, confirmed removal cleanup, and temporary slot 32 visibility.
- Prepared summaries, SNT settings, and built-in StorageUtil prompt reads.
- Magelight screen, checkbox callback, and configurable initially unbound hotkey. The earlier CQF console instruction was unverified and the user reports the command is unavailable; do not use it for verification.
- Source resolution across cache domains, compact candidate pairs, native capacity checks once per pool per refresh, and random selection with duplicate/exclusion/requirement checks.
- Quest-item filtering through the user-approved Papyrus Extender dependency, NoStrip/jewelry/weapon exclusions, and accepted unequip/drop behavior.
- Native application on a copied source entry with its preset slot removed, followed by synchronization/read-back before direct narration.
- Seven metadata mappings checked against the installed SlaveTats basic catalog. No texture or visual verification yet.

## Remaining

- Verify the standard hotkey picker and settings notifications after content reload.
- Verify query errors, external changes, removal/reapplication, save restoration, full pools, protected gear, duplicate item drops, late application failure, and post-application narration in-game.
- Measure latency and overhead before finalizing the provisional 15-second interval.
- Malformed JSON now rejects the replacement catalog explicitly: enumerate JSON filenames with MiscUtil and parse each separately. Compilation passed; runtime rejection still needs checking.
- Verify domain-cache traversal and native query result conventions against the running SlaveTatsNG implementation; compilation establishes declarations only.
- `JValue.toJsonString` was absent from the bundled signature index; the installed declaration compiles and the feature UI screenshot verifies delivery of tattoo rows.

This is a development checkpoint, not completed acceptance. No unsupported test runner or substitute API was introduced.

## 2026-11-08 Packaging

- Created `dist/SkyrimNet-SlaveTats-0.1.0-dev.zip`; ZIP integrity and required plugin/script entries checked.
- Updated deployed catalog script and source; repository/deployment hashes match.
- The running feature build and rendered prompt were verified on 2026-11-08; remaining cases are listed above.

- Hotkey settings now use the installed SkyrimNet_SexLab schema type `hotkey`; Set Key/Unset runtime check remains pending.

## Hotkey Reopening

- Standard picker renders; dashboard stores Numpad1 as scan code 97. Magelight logs confirm binding and key delivery.
- Closing hides the view; entering UI mode did not restore visibility. The controller now shows its view on Magelight_UIModeEntered before updating rows. Compiled and deployed; restart and reopen check pending.

- Restarted session still failed: Magelight registered scan codes 97/98/221 but logged no key delivery. The visibility-only fix was insufficient. Replaced native view hotkey binding with SKSE RegisterForKey/OnKeyDown calling OpenUI; ignores other menus and logs key delivery. Compiled/deployed; runtime check pending.

## Hotkey Code Conversion

- Root cause: dashboard hotkey values are Windows VK codes, not DirectInput scan codes. Installed SexLab source converts explicitly; a live read-only VkToDxScanCode(97) call returned 79. Earlier diagnosis was incomplete.
- User chose independence with limited supported keys. Added conversion for F1–F12, numpad digits/operators, and navigation keys; unsupported selections unbind and notify. Windows SDK dinput.h confirms all 37 mappings. Compiled; runtime check pending after restart.

## 2026-11-13 Code Review

Compiled; none of this is runtime-checked.

- Dependency gate: JContainers, PapyrusUtil, SlaveTatsNG, SkyrimNet, or Papyrus Extender missing disables the controller until the next load and notifies once.
- Loading clears `SNT_Ready` and `SNT_ApplyReady` immediately; previously the saved summary stayed readable until the first refresh.
- Each load starts a generation. Refresh or application resumed from the save stops without releasing the new generation's guards.
- `ApplyTattoo` took its guard after a native call, so two requests could both pass. The check and assignment are now adjacent.
- `ApplyTattoo` waits up to 5 seconds for a running refresh; previously it failed.
- Selection ran the native eligibility query for every matching candidate. It now tries random candidates until one passes.
- A checkbox click during a refresh was discarded. It is now saved.
- With both features disabled, `SNT_ApplyReady` kept its last value and the prompt kept listing choices. Disabling Apply now clears both.
- SlaveTatsNG's interface header types the query/add/synchronize results as `fail_t`: true is failure. The scripts already follow this.
- The houseCARL import set was gone; recreated with SKSE sources ahead of the approved vanilla baseline.

Decided 2026-11-13: shields (slot 39) stay equipped.

## 2026-11-14 Missing Apply Action

- Cause 1: saved settings had `features.apply` and `features.display` false.
- Cause 2: SlaveTatsNG 0.8.3 reads zero overlay slots from `skee64.ini`, so no pool has a free slot. Fixed upstream in 0.8.4.
- The controller now logs `Display and Apply disabled; idle` and `Apply candidates=N; pools without a free slot: …`, once per load and on change.
- Live state is readable through SkyrimNet's MCP server (`localhost:8889`, SSE): `render_template` with `papyrus_util` and `get_script_property`, and `check_action_eligibility`.
- The active MO2 mod is `SkyrimNet - SlaveTats`; `houseCARL - SkyrimNet-SlaveTats` is disabled.
