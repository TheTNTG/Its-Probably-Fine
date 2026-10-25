# Overnight development — 42B / 42C / 42D

Starting checkpoint: `e1f256f` (clean tracked tree). Existing temporary scene file is preserved. No interactive Git operation is needed; changes remain in the working tree.

No Godot launches, game execution, automated tests or screenshots are permitted/performed. Implemented code and static review are distinct from runtime verification.

## Phase 42B — Typography (implemented; visual playtest pending)

- Acquired actual Nunito and Pixelify Sans variable TTFs from the Google Fonts repository, both SIL OFL 1.1. Original license notices and source URLs/hashes are in `assets/fonts/`.
- `themes/cozy.tres` supplies rounded medium-weight Nunito body text and compact tooltip/button defaults. `scripts/typography.gd` centralizes reusable theme/accent resources and reference sizes.
- Project default theme, title menu theme, title/section accents, tutorial heading, day/transition labels and ending titles use the shared resources. Comic dialogue and overhead text retain measured wrapping/pagination and existing small font sizes.
- Established layout-specific size overrides are retained to avoid globally enlarging the compact HUD. No world zoom, panel positions, gameplay or artwork changes. Font-metric fit still needs manual review at supported aspect ratios.

Sources: https://github.com/google/fonts/tree/main/ofl/nunito and https://github.com/google/fonts/tree/main/ofl/pixelifysans. OFL redistribution notices are shipped alongside the fonts. No font fallback was required.

## Phase 42C

Implemented; runtime/save-recovery playtesting remains outstanding.

- Added `SaveStore` autoload (`scripts/save_store.gd`) with schema-version-1 JSON in `user://saves/campaign.json` and separate `profile.json`.
- Campaign serialization explicitly allows clock/day/difficulty, research and sessions, consecutive streak, all independent repairs/one-time bonus flags, needs, tutorial/story memory, chore states/repetitions/cooldowns/rotation, current/history time accounting, bed/overnight flags and mosquito identifiers/positions. HUD text/audio/nodes/animation frames are never authoritative saved data.
- Save Game is in Pause, with a disabled state and explanation for activities, pending/visible dialogue, repair choices and transitions. Free-roam and ordinary Pause support manual saves. Autosaves coalesce at the next safe frame after new campaign, research, meals/leisure, repairs, cleanup, tutorial completion and the new-day reveal. No clock-tick or movement autosaves.
- Continue is offered only for a valid active campaign; New Game warns and explicitly labels replacement when one exists. Restart warns in its button label. Returning to Main Menu saves when currently safe. A completed campaign writes a finished marker so an older live checkpoint is not offered as Continue.
- Restore pauses simulation, waits for scene physics registration, validates walkable actor positions (nearest safe floor fallback), restores state without replaying rewards/overnight penalties, rebuilds unfinished task navigation and mosquito runtime vectors, restores narrative flags and HUD, then releases control. An unfinished robot task must physically approach and execute again; already resolved task serials prevent repeating completed outcomes.
- Profile retains genuine tutorial completion separately from skip preference, unique completed campaign IDs (their count is the playthrough count), ending identifiers, audio preferences, empty future achievement IDs and deduplicated per-campaign milestones. New Game never erases profile history. Explicit Play Tutorial can still force the guide; essential contextual warnings remain enabled after skipping onboarding.
- Stable milestone hooks: `research_target`, `all_routines_repaired`, `ending_good/bittersweet/bad`, `campaign_hard`. `milestone_recorded` is a future integration signal; no achievement UI/reward system exists.
- Writes use a flushed temporary file, structural validation/readback, preservation of the previous primary under a unique `.previous.<timestamp>_<random>.json` filename, then rename into the primary path. Failed installs attempt rollback; read recovery searches newest valid retained revisions. No previous checkpoints or corrupt originals are deleted. Profile read failures disable profile writes rather than replacing history with defaults.
- Numeric/boolean/dictionary/vector types, finite values, ranges, known schema versions, duplicate mosquito IDs and maximum file sizes are checked. Optional story/robot/profile fields have defaults. Incompatible required campaign data is rejected rather than partially applied.

Files: `save_store.gd`, `project.godot`, `game_state.gd`, `hud.gd`, `title.gd`, `tutorial.gd`. Settings values persist through the profile with a short slider debounce and final exit flush; no account/cloud/save dependency.

Campaign schema shape (individual scalar ranges/allowlists are explicit in `save_store.gd`):

```text
version: 1; kind: "campaign"; id: random 128-bit hex; finished: boolean
state: numeric/boolean campaign fields + repairs/chore/time/tutorial/response maps
actors: {judy: [x,y], tiptop: [x,y]}
mosquitoes: [{id: integer, position: [x,y], count: integer}]
story: {seen: {event_id: boolean}, talk_count: integer}
robot: {morning_day: integer, goodnight_day: integer, thought_counts: map}
```

Finished saves need only version/kind/id/finished. Campaign profile data never replaces the player profile on Continue. Mosquito movement vectors and navigation/pose locks are reconstructed; active task selection, resolution serial, cooldowns and swat intent are preserved.

Profile schema: `version: 1`, `kind: "profile"`, `tutorial_completed`, `tutorial_skipped`, `completed_campaigns` (unique IDs), `endings` (IDs), `achievements` (reserved empty ID array), `milestones` (campaign ID → milestone flag map), `audio` (bus name → linear slider value 0–1). Optional missing profile fields retain defaults. No existing user:// file was edited by this coding session.

Limitations: no arbitrary mid-activity save/animation restore, no automatic save of every idle minute, and no promise of exact transient AI path/fly velocity continuity. Recovery revisions are deliberately retained rather than pruned; they can accumulate over long use. Force-killing the process can lose changes since the last safe checkpoint. Atomic rename/readback does not guarantee recovery from physical disk failure. Corruption, permission errors and cross-process restarts must be manually verified.

## Phase 42D

Implemented with a real licensed recording; musical fit/mix/seam require listening playtests.

- Integrated `assets/audio/music/chilllofir-loop.ogg`, an actual 97.22-second, 44.1 kHz Ogg Vorbis recording (2,360,833 bytes).
- Game-use title: **Probably Fine — Apartment Theme**. Original work: **Chill lofi inspired**, composer **omfgdude**, seamless loop edit **qubodup**. This is an existing instrumental adopted as the game's theme, not a claim of a newly composed/exclusive score. Publisher tags/description identify jazzy piano, drums and a chill lo-fi arrangement, recorded using Yamaha CVP-701 styles. Exact BPM is not independently established.
- Both original and loop edit are published as CC0 1.0: redistribution/adaptation with the game is permitted and attribution is optional. Voluntary credit appears in Settings and `assets/audio/music/CREDITS.md`; `SOURCE.json` records URLs, license, hash, bytes and duration. Recording bytes are unchanged.
- Reuses `ApartmentAudio`'s single persistent Music player and existing Music→Master bus. Ogg loop is explicitly enabled at offset zero. Normal apartment volume is low, evening gently reduces it, comic dialogue/pause duck it, and day/load transitions fade toward silence then return without seeking/restarting the track. Menus use a quieter level. Watch/6×/Skip/Eject never alter music pitch or restart it.
- Endings reuse the same theme at restrained branch-specific levels (good slightly fuller, bittersweet/bad quieter); there are no three additional compositions or unrelated stingers. Audio preferences now persist through the profile, including mute values.

Sources: https://opengameart.org/content/chill-lofi-inspired-loop-edit and https://opengameart.org/content/chill-lofi-inspired. No synthesizer, extra dependencies, accounts or audio-generation tools were used. The publisher supplies a seamless edit; seamless playback and subjective musical suitability have not been runtime verified.

## Overall files and static review

New: `scripts/typography.gd`, `themes/cozy.tres`, two actual TTF files/licenses/source manifest, `scripts/save_store.gd`, music OGG/credits/source manifest, and this report.

Modified: `project.godot`, `scripts/title.gd`, `scripts/hud.gd`, `scripts/tutorial.gd`, `scripts/showcase.gd`, `scripts/game_state.gd`, `scripts/apartment_audio.gd`, and the SFX credits index (links to the separate music credits).

Final static corrections: retained original UTF-8 punctuation; checked shared font/music paths, autoload references and event hooks; tightened scalar/time/repair-map validation; blocked input behind the Continue loading cover; kept valid saved mosquito positions; honored persisted skip preference on Continue; and prevented Continue for profile-recorded completed campaigns. Eject and tutorial Skip also queue safe checkpoints, preserving spent-session and onboarding state. Ending profile changes are batched into one write. No runtime verification is implied.

No apartment scene/layout, collision/nav geometry, difficulty values, 11 AM–8 PM schedule, 75% threshold, research/needs balance, robot AI script, existing SFX files or three ending scenes were replaced. No user saves were accessed or created during development; the user:// operations are implemented runtime code only.

No environment blocker prevented obtaining verified fonts or music. Git backup `e1f256f` remains available; implementation is left as reviewable working changes. The pre-existing temporary scene file remains untouched.

## Manual verification — highest risk first

1. Start New Game on each difficulty. Finish opening/tutorial, save from ordinary Pause, close/reopen the app and Continue. Compare day/time including fractions, difficulty, research, sessions, Fullness/Mood, repairs/bonus eligibility, clutter/water, history and actor positions. Confirm no extra rewards or overnight deductions on repeated loads.
2. Save near each fixture while TipTop travels/works, including a mosquito pursuit. Continue: verify safe floor positions, physical arrival before outcomes, no duplicate insects, no remote/repeated chore effects and no navigation lock. Exact unfinished paths/animation/fly velocities are intentionally reconstructed.
3. Check Save is disabled with an explanation during research, personal activities, repairs, dialogue and day wipes. Complete/Skip/Eject activities and confirm autosave waits for poses/dialogue to clear, then Continue resumes the post-event state. Test day-two/day-three morning checkpoints and all three showcase outcomes.
4. Using copies of your own saves, corrupt/truncate the primary and verify recovery uses a retained valid previous checkpoint; try incompatible versions and invalid fields. Confirm originals remain, failures are reported, and an unreadable profile is never silently replaced. Inspect retained `.previous.*.json` files after several saves.
5. Complete the guide, finish/restart campaigns and relaunch: introductory guide should stay completed. Separately skip a guide: skip preference persists without falsely recording completion. Explicit Play Tutorial/How to Play and essential contextual warnings should remain available.
6. Reach 75%, repair all routines, discover each ending and finish on Hard. Inspect profile IDs/count: repeated loading of the same campaign must not duplicate completion or milestone IDs. Finished campaign should have no misleading Continue. New Game/restart must warn about replacement and preserve history/settings.
7. Inspect fonts at 16:9, 3:2 and 4:3, windowed/fullscreen: title/ending accents, tutorial spotlight, comic pagination and speaker names, overhead thoughts, compact HUD/hover cards and Watch/6×/Skip/Eject help. Check long dialogue and labels for font-metric overflow.
8. Listen across multiple music loops, opening/closing menus, dialogue, Pause/Resume, evening, day changes, Continue, New Game and all endings. Confirm no overlapping tracks, gaps/clicks, tempo changes or unnecessary restarts. Judge whether the adopted theme meets the desired cozy identity and whether ducking/SFX balance needs adjustment.
9. Change/mute every volume slider, leave Settings, close/reopen and verify persistence and Master behavior. Music volume should affect only music; existing SFX/Ambience controls remain functional.
10. Recheck ordinary movement, needs restrictions, meals as breaks, research/repair costs, four-session reset, overnight Mood recovery, chores/mosquitoes, tutorials, transitions and endings.

Potential follow-up corrections are font-metric/layout fit, music taste/mix, filesystem recovery edge cases and reconstructed AI continuity. None is claimed runtime verified. No Godot launch, automated test or screenshot was performed.
