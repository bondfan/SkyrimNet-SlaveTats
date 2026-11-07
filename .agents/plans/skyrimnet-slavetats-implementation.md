# SkyrimNet - SlaveTats: Implementation Plan

Status: phase 1 started; initial controller script compiles with the approved vanilla imports. API and runtime checks remain pending; see [implementation-start.md](../notes/implementation-start.md).

Specification: [skyrimnet-slavetats.md](skyrimnet-slavetats.md). Original idea: [SkyrimNet - Tats.md](../../SkyrimNet%20-%20Tats.md).

## Boundaries

- Player wearers only; NPCs can initiate application. Keep actor parameters at integration boundaries without implementing NPC tracking.
- Use Papyrus with the existing SlaveTatsNG, SkyrimNet, Magelight, StorageUtil, and JContainers interfaces; no custom SKSE DLL or C++ toolchain.
- Use a small ESL-flagged plugin for the controller quest and player alias. Keep catalog, reconciliation, visibility, selection, and UI responsibilities separate without adding a framework.
- Compile scripts and verify behavior in-game. Papyrus development is exempt from unit-test requirements; do not create a standalone test runner.
- Confirm unresolved technical choices before adding dependencies or changing structure.
- Stage added files; do not commit. Use UTF-8 without BOM.

## 1. Verify Integration Contracts and Toolchain

- [ ] Confirm the active game runtime, SKSE, SkyrimNet 29, SlaveTatsNG, Magelight, PapyrusUtil, JContainers, and their winning script files through houseCARL.
- [x] Confirm Papyrus compiler availability and source imports. Initial controller compiled through houseCARL using saved import set `SkyrimNet-SlaveTats`.
- [ ] Read the Papyrus reference and winning source declarations before authoring calls or callbacks.
- [ ] Verify SlaveTatsNG's native Papyrus query/application functions, dependency initialization, and each selected function's result convention.
- [ ] Establish how scripts allocate, retain, read, and release JContainers query results and runtime caches.
- [ ] Verify applied-tattoo enumeration, catalog lookup, pool capacity, external-slot accounting, and application without replacing existing tattoos.
- [ ] Verify Magelight's Papyrus view creation, page callbacks, hotkeys, readiness, focus, and reload behavior.
- [ ] Verify SkyrimNet's Papyrus action callbacks and completion semantics, configuration getters/change notifications, prompt placement, and the built-in `papyrus_util` reader.
- [ ] Confirm that prepared player summaries and compact application choices reach NPC conversations without a custom Papyrus decorator or tattoo scan during rendering.
- [ ] Verify unequip-and-drop, removal restrictions, exclusion detection, and the accepted duplicate-instance behavior. Exact worn-copy selection is not a blocker.
- [ ] Record findings and supported versions under `.agents/notes`; record unresolved blockers before proceeding with the affected feature.

Exit: each integration has a documented usable route. Ask before substituting another API, dependency, or verification approach when a required route is blocked.

## 2. Establish the Papyrus Controller

- [ ] Create the ESL-flagged controller quest, player alias, startup bookkeeping, and required SEQ through houseCARL after schema lookup.
- [ ] Add minimal startup/player-load scripts and logging. Compile and verify initialization in-game before adding feature logic.
- [ ] Add script helpers for SlaveTatsNG, SkyrimNet, Magelight, equipment, and namespaced StorageUtil access.
- [ ] Implement dependency readiness checks and save-load/new-game initialization. Missing or incompatible APIs must not trigger invalid calls.
- [ ] Re-register session-only callbacks on loading and invalidate transient caches and stale pending work.
- [ ] Guard overlapping refresh/application work and publish only completed snapshots; do not assume separate Papyrus callbacks cannot overlap.
- [ ] Use single-update scheduling for periodic refresh and deferred equipment checks; no per-frame polling or permanent busy loops.

Exit: scripts compile, the quest initializes on a new and existing save, readiness failures are logged, and loading reinitializes transient work.

## 3. Implement Enrichment Loading

- [x] Confirm plain JSON arrays under `Data/SKSE/Plugins/SkyrimNet-SlaveTats/Packs/`; document the format in `docs/enrichment-packs.md`.
- [ ] Implement the six agreed fields: Section, Name, DisplayName, Category, Content, Position. The source identity is `(Section, Name)`; there is no integer Id.
- [ ] Validate field types, required values, and the fixed Position vocabulary. Categories remain supplied by pack creators.
- [ ] Resolve entries against the installed SlaveTats catalog and obtain the underlying Body/Face/Hands/Feet pool from SlaveTats metadata.
- [ ] Detect duplicate identities and conflicting mappings; report the source files without silently choosing a winner.
- [ ] Build indexes by identity and category/position. Unenriched tattoos never become UI, prompt, or application entries.
- [ ] Verify malformed entries, missing source tattoos, duplicate identities, All Over, and Content containing quotes or symbols using sample packs and loader diagnostics.

Exit: a small real pack loads against installed tattoos, and invalid mappings produce actionable diagnostics.

## 4. Implement Player Reconciliation and Persistence

- [ ] Query applied tattoos periodically through SlaveTatsNG's native Papyrus functions; distinguish failure from an empty successful result and retain a completed runtime snapshot.
- [ ] Reconcile enriched identities: add new entries using current defaults, preserve retained choices, and delete confirmed removals.
- [ ] Preserve the agreed rapid remove/reapply behavior: changes not observed between polls may retain the previous choice.
- [ ] Store one namespaced StorageUtil integer per enriched `(Section, Name)` identity on the player: missing = newly detected, `1` = hidden, `2` = visible. Persist defaulted choices and unset keys after confirmed removal.
- [x] Use length-prefixed keys: `SNT_Visibility:<section length>:<section>:<name>`. `SNT_Storage` compiles; runtime verification remains pending.
- [ ] Rebuild active tattoo snapshots, capacity, and enrichment indexes after loading. Do not persist a second complete tattoo database or trust restored runtime handles without revalidation.
- [ ] Clear only this mod's StorageUtil keys when cleaning up state.
- [ ] Prevent a new default setting from rewriting choices on existing tattoos.
- [ ] Keep complete pool-occupancy information separate from the enriched display list; unenriched tattoos still consume slots.
- [ ] Verify query failure, repeated identical snapshots, removal/reapplication, slot reuse, changed defaults, and restoration of visible and hidden entries from older saves in-game.

Exit: changes made through SlaveTats or another mod reconcile correctly; loading an older save restores its choices without leaking later state.

## 5. Implement Visibility and SkyrimNet Display

- [ ] Compute effective visibility as `slot32Empty || savedVisible` for each detected enriched tattoo, gated by Display being enabled.
- [ ] Check slot 32 on load and after equipment changes settle. Coalesce event bursts; do not poll equipment every frame.
- [ ] Preserve saved choices throughout the temporary all-visible override. Default Face visibility applies only to newly detected tattoos.
- [ ] Publish each complete visible-tattoo summary to one namespaced StorageUtil string on the player. Replace it only when output changes; treat Content as descriptive data and serialize/escape it correctly.
- [ ] Read the summary through SkyrimNet's built-in `papyrus_util` reader. Keep scans and custom Papyrus decorator calls out of the summary-rendering path.
- [ ] After loading, rebuild the summary before treating it as current. Gate output on feature settings and readiness so serialized stale text is not exposed.
- [ ] Include only the player's summary, and avoid repeating it once per NPC bio in the same prompt.
- [ ] Rebuild output when effective content changes; verify SkyrimNet's own caches do not retain removed or newly hidden tattoos.
- [ ] Add the agreed default-region settings and independent Apply/Display toggles using SkyrimNet's supported plugin-settings schema.
- [ ] Stop recurring tattoo queries when both features are disabled. Apply-only mode may retain the queries it needs for selection and capacity.
- [ ] Verify the visibility formula, dressed/nude transitions, changed defaults, disabled Display, and prompt freshness in-game.

Exit: an NPC conversation sees the player's current visible tattoos; dressing restores manual choices, and disabling Display removes its contribution.

## 6. Implement the Magelight Screen

- [ ] Add a player-only list of enriched applied tattoos, showing DisplayName, Position, and the saved visibility checkbox.
- [ ] Show when the slot 32 override makes every tattoo visible, so unchecked saved choices are not presented as currently hidden.
- [ ] Route checkbox changes to saved state and refresh the cached prompt summary.
- [ ] Add the configurable hotkey and handle opening, closing, focus refusal, page reload, save loading, and empty lists.
- [ ] Keep all UI assets local and connect them through Magelight's Papyrus page callbacks; no additional web framework is required by this plan.

Exit: keyboard interaction works in-game, choices survive reopening and save loading, and the UI performs no tattoo scans while rendering.

## 7. Implement Candidate Selection and the SkyrimNet Action

- [ ] Produce compact available pairs, e.g. `slave: Face, Neck`, from installed enriched candidates not already applied.
- [ ] Include cached capacity filtering only after verifying its correctness and cost. Never infer free slots from enriched-tattoo counts alone.
- [ ] Publish completed compact choices to a namespaced StorageUtil string for the action prompt to read through `papyrus_util`; gate stale choices after loading. Do not assume action parameter schemas can be changed dynamically.
- [ ] Register a Papyrus-backed action taking Category and Position, with the player fixed as the recipient. Eligibility respects Apply and dependency readiness.
- [ ] Instruct NPCs to stay vague before selection, e.g. "I’ll mark you as you deserve it." All Over remains a concrete Position, not a wildcard.
- [ ] Validate the requested pair, refresh relevant state, exclude duplicates including hidden tattoos, and randomly choose one candidate.
- [ ] Return failure without substitution when no candidate remains. Apply one tattoo per action; add no cooldown or repetition limit.
- [ ] Serialize overlapping application requests so concurrent requests cannot choose the same unapplied tattoo. This is an in-progress guard, not a cooldown.
- [ ] Verify matching, duplicate exclusion, All Over, invalid/empty requests, and random selection against a small known candidate set in-game.

Exit: the LLM receives compact choices, selection follows the agreed rules, and requests cannot bypass validation.

## 8. Add Stripping, Application, and Confirmed Outcomes

- [ ] Preflight selection, dependency readiness, and capacity before changing equipment.
- [ ] Snapshot eligible worn clothing/armor forms once, including boots, gloves, and helmets. Keep jewelry and weapons; deduplicate items occupying multiple slots.
- [ ] Resolve SexLabNoStrip optionally from `02F16E:SexLab.esm`. Leave marked, protected, or undroppable items untouched without requiring SexLab.
- [ ] Unequip each eligible form, then drop one instance through the script API. Any copy of that base item is acceptable; do not recreate items or drop all inventory copies.
- [ ] Recheck relevant state after stripping, then apply the selected tattoo without overwriting occupied or locked slots.
- [ ] Read back the applied identity before reporting success. Distinguish work being queued from application being completed in the SkyrimNet callback contract.
- [ ] Update cached tattoo/visibility state after completion and emit narration using the actual Content and Position.
- [ ] On failure, report the actual outcome without successful-tattoo narration. Dropped clothing is a separate completed side effect; do not imply it was restored.
- [ ] Cancel stale work across save transitions and release the in-progress guard on every completion/failure path.

Exit: one action unequips eligible clothing, drops one instance per eligible form, applies one tattoo, and narrates only a confirmed result.

## 9. Verify Performance and Package

- [ ] Compile all scripts through houseCARL and complete the in-game checks.
- [ ] Verify external application/removal, failed queries, full pools, externally occupied slots, locked tattoos, and rapid remove/reapply in-game.
- [ ] Verify stripping with duplicate base items, enchanted/tempered items, multi-slot armor, NoStrip, jewelry, weapons, and protected items. Inspect dropped copies and pickup behavior without requiring the previously worn instance.
- [ ] Verify both feature toggles independently, an empty enrichment catalog, UI reopening, equipment swaps, older saves, and new-game reset.
- [ ] Verify late application failure produces no success narration and leaves cached state consistent with actual game state.
- [ ] Measure complete Papyrus refresh latency, native query/capacity calls, slot 32 checks, and cache rebuilding with representative tattoo/overlay counts. Select the polling interval from those measurements.
- [ ] Verify prompt rendering reads cached data, equipment-event bursts coalesce, and both features disabled produce no recurring tattoo queries.
- [ ] Package the ESL-flagged plugin, required SEQ, compiled scripts, Magelight assets, SkyrimNet content/settings, one verified enrichment pack, and dependency/version instructions as an MO2-ready archive.
- [ ] Document Apply/Display settings, the MTF Display incompatibility, StorageUtil persistence, and pack authoring. Preserve applicable license notices and record MTF reuse/inspiration.
- [ ] State in the README that stripping unequips clothing and drops one copy of each base item; when duplicates exist, the dropped copy may have different enchantment or tempering from the worn copy.
- [ ] Verify packaged contents and deployed winners through houseCARL after installation; distinguish build, deployment, load, and gameplay results.
- [ ] Move this implementation plan to `.agents/plans/completed` only after its required checks pass. Keep unresolved runtime checks explicit.

## Evidence and Stop Conditions

Use the specification's source list and the local SkyrimNet 29 devkit. Current static inspection found SlaveTatsNG 0.8.1 and Magelight 1.7.1; these are investigation baselines, not established minimum supported versions.

Stop the affected phase and ask if query-result lifetimes, StorageUtil access, action completion, or Magelight's Papyrus interface cannot satisfy the specification. Selecting a different duplicate item instance after unequipping is accepted and does not justify adding a DLL. Do not introduce another framework or claim runtime verification from successful compilation.
