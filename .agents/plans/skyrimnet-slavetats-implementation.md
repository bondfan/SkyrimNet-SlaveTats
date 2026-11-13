# SkyrimNet - SlaveTats: Implementation Plan

Status: Display, its UI, and the converted hotkey passed the recorded runtime checks. Apply is implemented and registered; all code tasks are done. End-to-end application, failure cases, save restoration, and performance checks remain open. See [feature-checkpoint.md](../notes/feature-checkpoint.md).

Specification: [skyrimnet-slavetats.md](skyrimnet-slavetats.md). Original idea: [SkyrimNet - Tats.md](../../SkyrimNet%20-%20Tats.md).

## Boundaries

- Player wearers only; NPCs can initiate application. Keep actor parameters at integration boundaries without implementing NPC tracking.
- Use Papyrus with the existing SlaveTatsNG, SkyrimNet, Magelight, StorageUtil, and JContainers interfaces; no custom SKSE DLL or C++ toolchain.
- Use a small ESL-flagged plugin for the controller quest and player alias. Keep catalog, reconciliation, visibility, selection, and UI responsibilities separate without adding a framework.
- Compile scripts and verify behavior in-game. Papyrus development is exempt from unit-test requirements; do not create a standalone test runner.
- Confirm unresolved technical choices before adding dependencies or changing structure.
- Commit on branch `skyrimnet-slavetats-implementation`. Use UTF-8 without BOM.

Checked implementation tasks mean the code exists and compiles; they do not establish gameplay verification. Runtime checks are tracked separately.

## 1. Verify Integration Contracts and Toolchain

- [ ] Confirm the active game runtime, SKSE, SkyrimNet 29, SlaveTatsNG, Magelight, PapyrusUtil, JContainers, and their winning script files through houseCARL.
- [x] Confirm Papyrus compiler availability and source imports. Initial controller compiled through houseCARL using saved import set `SkyrimNet-SlaveTats`.
- [x] Read the Papyrus reference and winning source declarations before authoring calls or callbacks.
- [ ] Verify SlaveTatsNG's native Papyrus query/application functions, dependency initialization, and each selected function's result convention.
- [x] Establish how scripts allocate, retain, read, and release JContainers query results and runtime caches.
- [ ] Verify applied-tattoo enumeration, catalog lookup, pool capacity, external-slot accounting, and application without replacing existing tattoos.
- [x] Verify Magelight view creation, checkbox/close callbacks, and the converted hotkey in-game.
- [ ] Verify Magelight readiness failures, focus refusal, and page reload behavior.
- [ ] Verify SkyrimNet's Papyrus action callbacks and completion semantics, configuration getters/change notifications, prompt placement, and the built-in `papyrus_util` reader.
- [x] Confirm the local SkyrimNet template preview reads prepared player summaries and compact choices through `papyrus_util`, without tattoo scans or custom decorators.
- [ ] Verify those outputs in a subsequent NPC conversation.
- [ ] Verify unequip-and-drop, removal restrictions, exclusion detection, and the accepted duplicate-instance behavior. Exact worn-copy selection is not a blocker.
- [x] Record inspected versions, implementation findings, runtime evidence, and remaining checks under `.agents/notes`. Minimum supported versions remain unestablished.

Exit: each integration has a documented usable route. Ask before substituting another API, dependency, or verification approach when a required route is blocked.

## 2. Establish the Papyrus Controller

- [x] Create the ESL-flagged controller quest, player alias, startup bookkeeping, and required SEQ through houseCARL after schema lookup.
- [x] Add minimal startup/player-load scripts and logging. Compile and verify initialization in-game before adding feature logic.
- [x] Add script helpers for SlaveTatsNG, SkyrimNet, Magelight, equipment, and namespaced StorageUtil access.
- [x] Implement dependency readiness checks and save-load/new-game initialization. A missing dependency disables the controller until the next load. Runtime check of the missing-dependency path remains open.
- [x] Re-register session-only callbacks on loading and invalidate transient caches and stale pending work.
- [x] Guard overlapping refresh/application work and publish only completed snapshots; do not assume separate Papyrus callbacks cannot overlap.
- [x] Use single-update scheduling for periodic refresh and deferred equipment checks; no per-frame polling or permanent busy loops.

Exit: scripts compile, the quest initializes on a new and existing save, readiness failures are logged, and loading reinitializes transient work.

## 3. Implement Enrichment Loading

- [x] Confirm plain JSON arrays under `Data/SKSE/Plugins/SkyrimNet-SlaveTats/Packs/`; document the format in `docs/enrichment-packs.md`.
- [x] Implement the six agreed fields: Section, Name, DisplayName, Category, Content, Position. The source identity is `(Section, Name)`; there is no integer Id.
- [x] Validate field types, required values, and the fixed Position vocabulary. Categories remain supplied by pack creators.
- [x] Resolve entries against the installed SlaveTats catalog and obtain the underlying Body/Face/Hands/Feet pool from SlaveTats metadata.
- [x] Detect duplicate identities and conflicting mappings; report the source files without silently choosing a winner.
- [x] Build indexes by identity and category/position. Unenriched tattoos never become UI, prompt, or application entries.
- [ ] Verify malformed entries, missing source tattoos, duplicate identities, All Over, and Content containing quotes or symbols using sample packs and loader diagnostics.

Exit: a small real pack loads against installed tattoos, and invalid mappings produce actionable diagnostics.

## 4. Implement Player Reconciliation and Persistence

- [x] Query applied tattoos periodically through SlaveTatsNG's native Papyrus functions; distinguish failure from an empty successful result and retain a completed runtime snapshot.
- [x] Reconcile enriched identities: add new entries using current defaults, preserve retained choices, and delete confirmed removals.
- [x] Preserve the agreed rapid remove/reapply behavior: changes not observed between polls may retain the previous choice.
- [x] Store one namespaced StorageUtil integer per enriched `(Section, Name)` identity on the player: missing = newly detected, `1` = hidden, `2` = visible. Persist defaulted choices and unset keys after confirmed removal.
- [x] Use length-prefixed keys: `SNT_Visibility:<section length>:<section>:<name>`. `SNT_Storage` compiles; checkbox choices persist across UI reopening. Save/reload remains unchecked.
- [x] Rebuild active tattoo snapshots, capacity, and enrichment indexes after loading. Do not persist a second complete tattoo database or trust restored runtime handles without revalidation.
- [x] Clear only this mod's StorageUtil keys when cleaning up state.
- [x] Prevent a new default setting from rewriting choices on existing tattoos.
- [x] Keep complete pool-occupancy information separate from the enriched display list; unenriched tattoos still consume slots.
- [ ] Verify query failure, repeated identical snapshots, removal/reapplication, slot reuse, changed defaults, and restoration of visible and hidden entries from older saves in-game.

Exit: changes made through SlaveTats or another mod reconcile correctly; loading an older save restores its choices without leaking later state.

## 5. Implement Visibility and SkyrimNet Display

- [x] Compute effective visibility as `slot32Empty || savedVisible` for each detected enriched tattoo, gated by Display being enabled.
- [x] Check slot 32 on load and after equipment changes settle. Coalesce event bursts; do not poll equipment every frame.
- [x] Preserve saved choices throughout the temporary all-visible override. Default Face visibility applies only to newly detected tattoos.
- [x] Publish each complete visible-tattoo summary to one namespaced StorageUtil string on the player. Replace it only when output changes; treat Content as descriptive data and serialize/escape it correctly.
- [x] Read the summary through SkyrimNet's built-in `papyrus_util` reader. Keep scans and custom Papyrus decorator calls out of the summary-rendering path.
- [x] After loading, rebuild the summary before treating it as current. Loading clears both readiness flags before any refresh; disabling Apply clears its choices even when Display is also disabled.
- [x] Include only the player's summary, and avoid repeating it once per NPC bio in the same prompt.
- [x] Rebuild prepared output when effective content changes. Local template preview included checked marks and excluded the hidden mark.
- [ ] Verify subsequent conversations do not retain removed or newly hidden tattoos through SkyrimNet caches.
- [x] Add the agreed default-region settings and independent Apply/Display toggles using SkyrimNet's supported plugin-settings schema.
- [x] Stop recurring tattoo queries when both features are disabled. Apply-only mode may retain the queries it needs for selection and capacity.
- [ ] Verify the visibility formula, dressed/nude transitions, changed defaults, disabled Display, and prompt freshness in-game.

Exit: an NPC conversation sees the player's current visible tattoos; dressing restores manual choices, and disabling Display removes its contribution.

## 6. Implement the Magelight Screen

- [x] Convert picker VK values to DirectInput scan codes without a native dependency; support function, numpad, and navigation keys only.
- [x] Verify the converted hotkey in-game; user confirmed it works on 2026-11-08.
- [x] Replace numeric scan-code entry with SkyrimNet's standard hotkey setting control, matching SkyrimNet_SexLab: display the assigned key and provide Set Key and Unset buttons. Inspect that integration's schema before implementing; users must not enter scan codes manually.
- [x] Add a player-only list of enriched applied tattoos, showing DisplayName, Position, and the saved visibility checkbox.
- [x] Show when the slot 32 override makes every tattoo visible, so unchecked saved choices are not presented as currently hidden.
- [x] Route checkbox changes to saved state and refresh the cached prompt summary.
- [x] Implement the configurable hotkey, opening/closing, focus refusal, page callbacks, load reinitialization, and empty-list display. Hotkey operation and checkbox reopening are confirmed.
- [ ] Verify focus refusal, page reload, save restoration, and empty-list behavior in-game.
- [x] Keep all UI assets local and connect them through Magelight's Papyrus page callbacks; no additional web framework is required by this plan.

Exit: keyboard interaction works in-game, choices survive reopening and save loading, and the UI performs no tattoo scans while rendering.

## 7. Implement Candidate Selection and the SkyrimNet Action

- [x] Produce compact available pairs, e.g. `slave: Face, Neck`, from installed enriched candidates not already applied.
- [x] Implement native capacity checks once per pool per refresh; do not infer free slots from enriched counts.
- [ ] Verify capacity filtering correctness and cost in-game.
- [x] Publish compact choices through a namespaced StorageUtil string and `papyrus_util`, with a readiness flag; keep action parameters fixed.
- [ ] Verify stale choices remain gated throughout save-load transitions.
- [x] Register the Papyrus-backed Category/Position action with the player as recipient; gate eligibility on prepared Apply readiness. Broader dependency readiness remains open in phase 2.
- [x] Instruct NPCs to stay vague before selection, e.g. "I’ll mark you as you deserve it." All Over remains a concrete Position, not a wildcard.
- [x] Validate the requested pair, refresh relevant state, exclude duplicates including hidden tattoos, and randomly choose one candidate.
- [x] Return failure without substitution when no candidate remains. Apply one tattoo per action; add no cooldown or repetition limit.
- [x] Add an in-progress application guard and clear readiness while applying; no cooldown.
- [ ] Verify concurrent requests cannot bypass the guard or select the same unapplied tattoo.
- [ ] Verify matching, duplicate exclusion, All Over, invalid/empty requests, and random selection against a small known candidate set in-game.

Exit: the LLM receives compact choices, selection follows the agreed rules, and requests cannot bypass validation.

## 8. Add Stripping, Application, and Confirmed Outcomes

- [x] Preflight selection, dependency readiness, and capacity before changing equipment. Candidates are tried in random order until one passes the native eligibility check.
- [x] Snapshot eligible worn clothing/armor forms once, including boots, gloves, and helmets. Keep jewelry and weapons; deduplicate items occupying multiple slots.
- [x] Resolve SexLabNoStrip optionally from `02F16E:SexLab.esm`; filter marked gear and quest items, and skip drops when unequipping fails. Protected/undroppable behavior remains in the runtime checklist.
- [x] Unequip each eligible form, then drop one instance through the script API. Any copy of that base item is acceptable; do not recreate items or drop all inventory copies.
- [x] Recheck relevant state after stripping, then apply the selected tattoo without overwriting occupied or locked slots.
- [x] Read back the applied identity before reporting success. Distinguish work being queued from application being completed in the SkyrimNet callback contract.
- [x] Update cached tattoo/visibility state after completion and emit narration using the actual Content and Position.
- [x] On failure, report the actual outcome without successful-tattoo narration. Dropped clothing is a separate completed side effect; do not imply it was restored.
- [x] Cancel stale work across save transitions and release the in-progress guard on every completion/failure path. Each load starts a generation; earlier work stops before stripping, applying, or narrating.

Exit: one action unequips eligible clothing, drops one instance per eligible form, applies one tattoo, and narrates only a confirmed result.

## 9. Verify Performance and Package

- [x] Compile all scripts through houseCARL.
- [ ] Complete the remaining in-game checks below.
- [ ] Verify external application/removal, failed queries, full pools, externally occupied slots, locked tattoos, and rapid remove/reapply in-game.
- [ ] Verify stripping with duplicate base items, enchanted/tempered items, multi-slot armor, NoStrip, jewelry, weapons, and protected items. Inspect dropped copies and pickup behavior without requiring the previously worn instance.
- [ ] Verify both feature toggles independently, an empty enrichment catalog, UI reopening, equipment swaps, older saves, and new-game reset.
- [ ] Verify late application failure produces no success narration and leaves cached state consistent with actual game state.
- [ ] Measure complete Papyrus refresh latency, native query/capacity calls, slot 32 checks, and cache rebuilding with representative tattoo/overlay counts. Select the polling interval from those measurements.
- [ ] Verify prompt rendering reads cached data, equipment-event bursts coalesce, and both features disabled produce no recurring tattoo queries.
- [x] Package the plugin, SEQ, scripts, UI, SkyrimNet content/settings, dependency instructions, and a seven-entry pack with verified source identities in the development MO2 archive.
- [ ] Verify pack appearance and application in-game before release.
- [x] Document Apply/Display settings, the MTF Display incompatibility, StorageUtil persistence, and pack authoring. Preserve applicable license notices and record MTF reuse/inspiration.
- [x] State in the README that stripping unequips clothing and drops one copy of each base item; when duplicates exist, the dropped copy may have different enchantment or tempering from the worn copy.
- [x] Check archive integrity/contents, deployment hashes, and houseCARL asset winners; record build, deployment, load, and gameplay evidence separately.
- [ ] Move this implementation plan to `.agents/plans/completed` only after its required checks pass. Keep unresolved runtime checks explicit.

## Evidence and Stop Conditions

Use the specification's source list and the local SkyrimNet 29 devkit. Current static inspection found SlaveTatsNG 0.8.1 and Magelight 1.7.1; these are investigation baselines, not established minimum supported versions.

Stop the affected phase and ask if query-result lifetimes, StorageUtil access, action completion, or Magelight's Papyrus interface cannot satisfy the specification. Selecting a different duplicate item instance after unequipping is accepted and does not justify adding a DLL. Do not introduce another framework or claim runtime verification from successful compilation.
