# Text inventory — Step 48

> Historical pre-centralization snapshot. Current editable copy and IDs are listed in [COMPLETE_TEXT_REFERENCE.md](COMPLETE_TEXT_REFERENCE.md). Edit `data/text/*.json`, not the old source locations below.

Source snapshot, not a runtime/UI verification. This inventory covers every string literal outside comments in first-party game scripts, rules data, scenes, the UI theme and project configuration. Repeated occurrences have separate IDs and locations. No dialogue, thought array or scene literal is intentionally omitted. Editor-only third-party addons, import metadata, audio manifests, documentation and art assets are excluded.

The tables prioritize likely display copy, then retain all other literals in [the technical appendix](TEXT_INVENTORY_INTERNALS.md). Classification is conservative: short labels, speaker names and some code strings also appear below. This is a source inventory, not a claim that every candidate is currently displayed. Do not rename keys, node paths, enum identifiers, asset paths or event IDs to change copy. Use the [editing guide](TEXT_EDITING_GUIDE.md).

Text is quoted exactly as in source, including escaped `
`, placeholders and BBCode. `
` means a visible line break. For generated messages, the context includes immediate `%` formatting arguments; otherwise follow the function and source link to its expression. Values passed from gameplay state remain authoritative. IDs are documentation locators, not localization keys, and can change on regeneration.

Dynamic sources: `%` templates supply game-state numbers/names; `capitalize()` turns routine keys into names; `PERSONAL_ACTIVITIES`, `DIFFICULTIES`, `CLEAN_COSTS` and time-format arithmetic supply values. Dynamic portraits and font resources contain no editable story copy. The new rules derive difficulty values in `data/rules_text.gd:pages()`. Regenerate this snapshot with `python tools/build_text_inventory.py` after editing copy (documentation generation only; does not launch Godot).


## data/rules_text.gd

| ID | Current text / source literal | File path | Location | Context / template variables |
|---|---|---|---|---|
| RULES_TEXT-0001 | <code>"HOW TO SURVIVE THE NEXT 3 DAYS"</code> | `data/rules_text.gd` | [L5](../data/rules_text.gd#L5) | file constants / initial values |
| RULES_TEXT-0002 | <code>"Back"</code> | `data/rules_text.gd` | [L6](../data/rules_text.gd#L6) | file constants / initial values |
| RULES_TEXT-0003 | <code>"Next"</code> | `data/rules_text.gd` | [L7](../data/rules_text.gd#L7) | file constants / initial values |
| RULES_TEXT-0004 | <code>"LET'S GET TO WORK"</code> | `data/rules_text.gd` | [L8](../data/rules_text.gd#L8) | file constants / initial values |
| RULES_TEXT-0005 | <code>"Back to game"</code> | `data/rules_text.gd` | [L9](../data/rules_text.gd#L9) | file constants / initial values |
| RULES_TEXT-0006 | <code>"E / Enter: next page · Tab: select a button"</code> | `data/rules_text.gd` | [L10](../data/rules_text.gd#L10) | file constants / initial values |
| RULES_TEXT-0008 | <code>"1 · The goal &amp; deadline"</code> | `data/rules_text.gd` | [L16](../data/rules_text.gd#L16) | func pages |
| RULES_TEXT-0010 | <code>"Judy has three days to prepare for a research showcase. It begins at 8 PM on Day 3.\n\nAim for at least %.0f%% research. For the best outcome, repair all four of TipTop's routines too.\n\nEach day runs from 11 AM to 8 PM. Balance science, meals, breaks and repairs: they share the same limited hours."</code> | `data/rules_text.gd` | [L17](../data/rules_text.gd#L17) | func pages Formatting arguments: % GameState.GOOD_ENDING_RESEARCH_THRESHOLD}, |
| RULES_TEXT-0012 | <code>"2 · Research &amp; your time"</code> | `data/rules_text.gd` | [L18](../data/rules_text.gd#L18) | func pages |
| RULES_TEXT-0014 | <code>"Approach the desk and press E. You have up to %d sessions each day. On %s, a standard session takes %d game minutes for +%.0f%% base research. A full session must fit before 8 PM.\n\nThe clock also runs while you explore. Watch, Fast 6x and Skip apply the same time and consequences. Skip is faster for you, not for Judy. Eject keeps time already spent and gives no completion reward.\n\nA running tap adds one-third to session time and halves research gains. Scattered books block work; organizing them takes 20 minutes."</code> | `data/rules_text.gd` | [L19](../data/rules_text.gd#L19) | func pages Formatting arguments: % [GameState.DAILY_WORK_SESSIONS, settings["name"], settings["research_minutes"], settings["research"]]}, |
| RULES_TEXT-0019 | <code>"3 · Fullness, Mood &amp; breaks"</code> | `data/rules_text.gd` | [L20](../data/rules_text.gd#L20) | func pages |
| RULES_TEXT-0021 | <code>"Higher Fullness is better. Research needs more than 20 Fullness. Below 60, research yield falls: 90% from 30 to below 60, 75% below 30, and 60% at zero.\n\nResearch normally needs at least 45 Mood. From 2 PM on Day 3, Judy can push through low Mood with 20% less yield; she still needs more than 20 Fullness.\n\nA 30-minute fridge meal restores 40 Fullness and 10 Mood. Reels, phone games and cubing at the coffee table restore Mood. Meals and leisure reset the work streak, not the daily session limit."</code> | `data/rules_text.gd` | [L21](../data/rules_text.gd#L21) | func pages |
| RULES_TEXT-0023 | <code>"4 · TipTop &amp; a balanced day"</code> | `data/rules_text.gd` | [L22](../data/rules_text.gd#L22) | func pages |
| RULES_TEXT-0025 | <code>"TipTop means well. His four faulty routines can leave recurring messes. Press E near him to repair each routine independently. On %s, each repair costs %d minutes and earns +%.0f%% research.\n\nCleaning fixes the mess, not the routine. Your first repair before any research also earns a one-time +10%% proactive bonus. Make the bed before resting to advance the day; bedtime Fullness affects tomorrow's Mood.\n\nResearch matters, but so does taking care of Judy. Plan your time, keep TipTop under control, and make it to the showcase!\n\nMove: WASD / arrows. Interact: E. Pause: Esc. Optional tutorial: main menu."</code> | `data/rules_text.gd` | [L23](../data/rules_text.gd#L23) | func pages Formatting arguments: % [settings["name"], settings["repair_minutes"], settings["repair_reward"]]} |

## project.godot

| ID | Current text / source literal | File path | Location | Context / template variables |
|---|---|---|---|---|
| PROJECT-0004 | <code>"Forward Plus"</code> | `project.godot` | [L15](../project.godot#L15) | file constants / initial values |

## scenes/desk.tscn

| ID | Current text / source literal | File path | Location | Context / template variables |
|---|---|---|---|---|
| DESK-0001 | <code>"Script"</code> | `scenes/desk.tscn` | [L3](../scenes/desk.tscn#L3) | file constants / initial values |
| DESK-0004 | <code>"Script"</code> | `scenes/desk.tscn` | [L4](../scenes/desk.tscn#L4) | file constants / initial values |
| DESK-0007 | <code>"RectangleShape2D"</code> | `scenes/desk.tscn` | [L6](../scenes/desk.tscn#L6) | [sub_resource type="RectangleShape2D" id="RectangleShape2D_body"] |
| DESK-0008 | <code>"RectangleShape2D_body"</code> | `scenes/desk.tscn` | [L6](../scenes/desk.tscn#L6) | [sub_resource type="RectangleShape2D" id="RectangleShape2D_body"] |
| DESK-0009 | <code>"RectangleShape2D"</code> | `scenes/desk.tscn` | [L9](../scenes/desk.tscn#L9) | [sub_resource type="RectangleShape2D" id="RectangleShape2D_zone"] |
| DESK-0010 | <code>"RectangleShape2D_zone"</code> | `scenes/desk.tscn` | [L9](../scenes/desk.tscn#L9) | [sub_resource type="RectangleShape2D" id="RectangleShape2D_zone"] |
| DESK-0011 | <code>"Desk"</code> | `scenes/desk.tscn` | [L12](../scenes/desk.tscn#L12) | [node name="Desk" type="StaticBody2D"] |
| DESK-0012 | <code>"StaticBody2D"</code> | `scenes/desk.tscn` | [L12](../scenes/desk.tscn#L12) | [node name="Desk" type="StaticBody2D"] |
| DESK-0014 | <code>"Visual"</code> | `scenes/desk.tscn` | [L15](../scenes/desk.tscn#L15) | [node name="Visual" type="Node2D" parent="."] |
| DESK-0015 | <code>"Node2D"</code> | `scenes/desk.tscn` | [L15](../scenes/desk.tscn#L15) | [node name="Visual" type="Node2D" parent="."] |
| DESK-0019 | <code>"CollisionShape2D"</code> | `scenes/desk.tscn` | [L19](../scenes/desk.tscn#L19) | [node name="CollisionShape2D" type="CollisionShape2D" parent="."] |
| DESK-0020 | <code>"CollisionShape2D"</code> | `scenes/desk.tscn` | [L19](../scenes/desk.tscn#L19) | [node name="CollisionShape2D" type="CollisionShape2D" parent="."] |
| DESK-0022 | <code>"RectangleShape2D_body"</code> | `scenes/desk.tscn` | [L21](../scenes/desk.tscn#L21) | [node name="CollisionShape2D" type="CollisionShape2D" parent="."] |
| DESK-0023 | <code>"InteractionZone"</code> | `scenes/desk.tscn` | [L23](../scenes/desk.tscn#L23) | [node name="InteractionZone" type="Area2D" parent="."] |
| DESK-0024 | <code>"Area2D"</code> | `scenes/desk.tscn` | [L23](../scenes/desk.tscn#L23) | [node name="InteractionZone" type="Area2D" parent="."] |
| DESK-0026 | <code>"CollisionShape2D"</code> | `scenes/desk.tscn` | [L26](../scenes/desk.tscn#L26) | [node name="CollisionShape2D" type="CollisionShape2D" parent="InteractionZone"] |
| DESK-0027 | <code>"CollisionShape2D"</code> | `scenes/desk.tscn` | [L26](../scenes/desk.tscn#L26) | [node name="CollisionShape2D" type="CollisionShape2D" parent="InteractionZone"] |
| DESK-0028 | <code>"InteractionZone"</code> | `scenes/desk.tscn` | [L26](../scenes/desk.tscn#L26) | [node name="CollisionShape2D" type="CollisionShape2D" parent="InteractionZone"] |
| DESK-0029 | <code>"RectangleShape2D_zone"</code> | `scenes/desk.tscn` | [L27](../scenes/desk.tscn#L27) | [node name="CollisionShape2D" type="CollisionShape2D" parent="InteractionZone"] |
| DESK-0030 | <code>"PromptLabel"</code> | `scenes/desk.tscn` | [L29](../scenes/desk.tscn#L29) | [node name="PromptLabel" type="Label" parent="."] |
| DESK-0031 | <code>"Label"</code> | `scenes/desk.tscn` | [L29](../scenes/desk.tscn#L29) | [node name="PromptLabel" type="Label" parent="."] |
| DESK-0033 | <code>"E - Work"</code> | `scenes/desk.tscn` | [L36](../scenes/desk.tscn#L36) | [node name="PromptLabel" type="Label" parent="."] |
| DESK-0035 | <code>"InteractionZone"</code> | `scenes/desk.tscn` | [L39](../scenes/desk.tscn#L39) | [node name="PromptLabel" type="Label" parent="."] |
| DESK-0039 | <code>"InteractionZone"</code> | `scenes/desk.tscn` | [L40](../scenes/desk.tscn#L40) | [node name="PromptLabel" type="Label" parent="."] |

## scenes/hud.tscn

| ID | Current text / source literal | File path | Location | Context / template variables |
|---|---|---|---|---|
| HUD-0001 | <code>"Script"</code> | `scenes/hud.tscn` | [L3](../scenes/hud.tscn#L3) | file constants / initial values |
| HUD-0004 | <code>"HUD"</code> | `scenes/hud.tscn` | [L5](../scenes/hud.tscn#L5) | [node name="HUD" type="CanvasLayer"] |
| HUD-0005 | <code>"CanvasLayer"</code> | `scenes/hud.tscn` | [L5](../scenes/hud.tscn#L5) | [node name="HUD" type="CanvasLayer"] |
| HUD-0007 | <code>"DayLabel"</code> | `scenes/hud.tscn` | [L8](../scenes/hud.tscn#L8) | [node name="DayLabel" type="Label" parent="."] |
| HUD-0008 | <code>"Label"</code> | `scenes/hud.tscn` | [L8](../scenes/hud.tscn#L8) | [node name="DayLabel" type="Label" parent="."] |
| HUD-0010 | <code>"Day 1"</code> | `scenes/hud.tscn` | [L14](../scenes/hud.tscn#L14) | [node name="DayLabel" type="Label" parent="."] |
| HUD-0011 | <code>"TimeLabel"</code> | `scenes/hud.tscn` | [L16](../scenes/hud.tscn#L16) | [node name="TimeLabel" type="Label" parent="."] |
| HUD-0012 | <code>"Label"</code> | `scenes/hud.tscn` | [L16](../scenes/hud.tscn#L16) | [node name="TimeLabel" type="Label" parent="."] |
| HUD-0014 | <code>"11:00 AM"</code> | `scenes/hud.tscn` | [L22](../scenes/hud.tscn#L22) | [node name="TimeLabel" type="Label" parent="."] |
| HUD-0015 | <code>"ResearchLabel"</code> | `scenes/hud.tscn` | [L25](../scenes/hud.tscn#L25) | [node name="ResearchLabel" type="Label" parent="."] |
| HUD-0016 | <code>"Label"</code> | `scenes/hud.tscn` | [L25](../scenes/hud.tscn#L25) | [node name="ResearchLabel" type="Label" parent="."] |
| HUD-0018 | <code>"Research: 0%"</code> | `scenes/hud.tscn` | [L31](../scenes/hud.tscn#L31) | [node name="ResearchLabel" type="Label" parent="."] |
| HUD-0019 | <code>"NotificationPanel"</code> | `scenes/hud.tscn` | [L34](../scenes/hud.tscn#L34) | [node name="NotificationPanel" type="Control" parent="."] |
| HUD-0020 | <code>"Control"</code> | `scenes/hud.tscn` | [L34](../scenes/hud.tscn#L34) | [node name="NotificationPanel" type="Control" parent="."] |
| HUD-0022 | <code>"Background"</code> | `scenes/hud.tscn` | [L41](../scenes/hud.tscn#L41) | [node name="Background" type="ColorRect" parent="NotificationPanel"] |
| HUD-0023 | <code>"ColorRect"</code> | `scenes/hud.tscn` | [L41](../scenes/hud.tscn#L41) | [node name="Background" type="ColorRect" parent="NotificationPanel"] |
| HUD-0024 | <code>"NotificationPanel"</code> | `scenes/hud.tscn` | [L41](../scenes/hud.tscn#L41) | [node name="Background" type="ColorRect" parent="NotificationPanel"] |
| HUD-0025 | <code>"NotificationLabel"</code> | `scenes/hud.tscn` | [L46](../scenes/hud.tscn#L46) | [node name="NotificationLabel" type="Label" parent="NotificationPanel"] |
| HUD-0026 | <code>"Label"</code> | `scenes/hud.tscn` | [L46](../scenes/hud.tscn#L46) | [node name="NotificationLabel" type="Label" parent="NotificationPanel"] |
| HUD-0027 | <code>"NotificationPanel"</code> | `scenes/hud.tscn` | [L46](../scenes/hud.tscn#L46) | [node name="NotificationLabel" type="Label" parent="NotificationPanel"] |
| HUD-0028 | <code>"FixButton"</code> | `scenes/hud.tscn` | [L55](../scenes/hud.tscn#L55) | [node name="FixButton" type="Button" parent="NotificationPanel"] |
| HUD-0029 | <code>"Button"</code> | `scenes/hud.tscn` | [L55](../scenes/hud.tscn#L55) | [node name="FixButton" type="Button" parent="NotificationPanel"] |
| HUD-0030 | <code>"NotificationPanel"</code> | `scenes/hud.tscn` | [L55](../scenes/hud.tscn#L55) | [node name="FixButton" type="Button" parent="NotificationPanel"] |
| HUD-0031 | <code>"Fix (30 min)"</code> | `scenes/hud.tscn` | [L61](../scenes/hud.tscn#L61) | [node name="FixButton" type="Button" parent="NotificationPanel"] |
| HUD-0032 | <code>"IgnoreButton"</code> | `scenes/hud.tscn` | [L63](../scenes/hud.tscn#L63) | [node name="IgnoreButton" type="Button" parent="NotificationPanel"] |
| HUD-0033 | <code>"Button"</code> | `scenes/hud.tscn` | [L63](../scenes/hud.tscn#L63) | [node name="IgnoreButton" type="Button" parent="NotificationPanel"] |
| HUD-0034 | <code>"NotificationPanel"</code> | `scenes/hud.tscn` | [L63](../scenes/hud.tscn#L63) | [node name="IgnoreButton" type="Button" parent="NotificationPanel"] |
| HUD-0035 | <code>"Ignore"</code> | `scenes/hud.tscn` | [L69](../scenes/hud.tscn#L69) | [node name="IgnoreButton" type="Button" parent="NotificationPanel"] |
| HUD-0037 | <code>"NotificationPanel/FixButton"</code> | `scenes/hud.tscn` | [L71](../scenes/hud.tscn#L71) | [node name="IgnoreButton" type="Button" parent="NotificationPanel"] |
| HUD-0041 | <code>"NotificationPanel/IgnoreButton"</code> | `scenes/hud.tscn` | [L72](../scenes/hud.tscn#L72) | [node name="IgnoreButton" type="Button" parent="NotificationPanel"] |

## scenes/player.tscn

| ID | Current text / source literal | File path | Location | Context / template variables |
|---|---|---|---|---|
| PLAYER-0001 | <code>"Script"</code> | `scenes/player.tscn` | [L3](../scenes/player.tscn#L3) | file constants / initial values |
| PLAYER-0004 | <code>"Texture2D"</code> | `scenes/player.tscn` | [L5](../scenes/player.tscn#L5) | file constants / initial values |
| PLAYER-0008 | <code>"AtlasTexture"</code> | `scenes/player.tscn` | [L7](../scenes/player.tscn#L7) | [sub_resource type="AtlasTexture" id="Atlas_0_0"] |
| PLAYER-0009 | <code>"Atlas_0_0"</code> | `scenes/player.tscn` | [L7](../scenes/player.tscn#L7) | [sub_resource type="AtlasTexture" id="Atlas_0_0"] |
| PLAYER-0011 | <code>"AtlasTexture"</code> | `scenes/player.tscn` | [L11](../scenes/player.tscn#L11) | [sub_resource type="AtlasTexture" id="Atlas_0_1"] |
| PLAYER-0012 | <code>"Atlas_0_1"</code> | `scenes/player.tscn` | [L11](../scenes/player.tscn#L11) | [sub_resource type="AtlasTexture" id="Atlas_0_1"] |
| PLAYER-0014 | <code>"AtlasTexture"</code> | `scenes/player.tscn` | [L15](../scenes/player.tscn#L15) | [sub_resource type="AtlasTexture" id="Atlas_0_2"] |
| PLAYER-0015 | <code>"Atlas_0_2"</code> | `scenes/player.tscn` | [L15](../scenes/player.tscn#L15) | [sub_resource type="AtlasTexture" id="Atlas_0_2"] |
| PLAYER-0017 | <code>"AtlasTexture"</code> | `scenes/player.tscn` | [L19](../scenes/player.tscn#L19) | [sub_resource type="AtlasTexture" id="Atlas_0_3"] |
| PLAYER-0018 | <code>"Atlas_0_3"</code> | `scenes/player.tscn` | [L19](../scenes/player.tscn#L19) | [sub_resource type="AtlasTexture" id="Atlas_0_3"] |
| PLAYER-0020 | <code>"AtlasTexture"</code> | `scenes/player.tscn` | [L23](../scenes/player.tscn#L23) | [sub_resource type="AtlasTexture" id="Atlas_1_0"] |
| PLAYER-0021 | <code>"Atlas_1_0"</code> | `scenes/player.tscn` | [L23](../scenes/player.tscn#L23) | [sub_resource type="AtlasTexture" id="Atlas_1_0"] |
| PLAYER-0023 | <code>"AtlasTexture"</code> | `scenes/player.tscn` | [L27](../scenes/player.tscn#L27) | [sub_resource type="AtlasTexture" id="Atlas_1_1"] |
| PLAYER-0024 | <code>"Atlas_1_1"</code> | `scenes/player.tscn` | [L27](../scenes/player.tscn#L27) | [sub_resource type="AtlasTexture" id="Atlas_1_1"] |
| PLAYER-0026 | <code>"AtlasTexture"</code> | `scenes/player.tscn` | [L31](../scenes/player.tscn#L31) | [sub_resource type="AtlasTexture" id="Atlas_1_2"] |
| PLAYER-0027 | <code>"Atlas_1_2"</code> | `scenes/player.tscn` | [L31](../scenes/player.tscn#L31) | [sub_resource type="AtlasTexture" id="Atlas_1_2"] |
| PLAYER-0029 | <code>"AtlasTexture"</code> | `scenes/player.tscn` | [L35](../scenes/player.tscn#L35) | [sub_resource type="AtlasTexture" id="Atlas_1_3"] |
| PLAYER-0030 | <code>"Atlas_1_3"</code> | `scenes/player.tscn` | [L35](../scenes/player.tscn#L35) | [sub_resource type="AtlasTexture" id="Atlas_1_3"] |
| PLAYER-0032 | <code>"AtlasTexture"</code> | `scenes/player.tscn` | [L39](../scenes/player.tscn#L39) | [sub_resource type="AtlasTexture" id="Atlas_2_0"] |
| PLAYER-0033 | <code>"Atlas_2_0"</code> | `scenes/player.tscn` | [L39](../scenes/player.tscn#L39) | [sub_resource type="AtlasTexture" id="Atlas_2_0"] |
| PLAYER-0035 | <code>"AtlasTexture"</code> | `scenes/player.tscn` | [L43](../scenes/player.tscn#L43) | [sub_resource type="AtlasTexture" id="Atlas_2_1"] |
| PLAYER-0036 | <code>"Atlas_2_1"</code> | `scenes/player.tscn` | [L43](../scenes/player.tscn#L43) | [sub_resource type="AtlasTexture" id="Atlas_2_1"] |
| PLAYER-0038 | <code>"AtlasTexture"</code> | `scenes/player.tscn` | [L47](../scenes/player.tscn#L47) | [sub_resource type="AtlasTexture" id="Atlas_2_2"] |
| PLAYER-0039 | <code>"Atlas_2_2"</code> | `scenes/player.tscn` | [L47](../scenes/player.tscn#L47) | [sub_resource type="AtlasTexture" id="Atlas_2_2"] |
| PLAYER-0041 | <code>"AtlasTexture"</code> | `scenes/player.tscn` | [L51](../scenes/player.tscn#L51) | [sub_resource type="AtlasTexture" id="Atlas_2_3"] |
| PLAYER-0042 | <code>"Atlas_2_3"</code> | `scenes/player.tscn` | [L51](../scenes/player.tscn#L51) | [sub_resource type="AtlasTexture" id="Atlas_2_3"] |
| PLAYER-0044 | <code>"AtlasTexture"</code> | `scenes/player.tscn` | [L55](../scenes/player.tscn#L55) | [sub_resource type="AtlasTexture" id="Atlas_3_0"] |
| PLAYER-0045 | <code>"Atlas_3_0"</code> | `scenes/player.tscn` | [L55](../scenes/player.tscn#L55) | [sub_resource type="AtlasTexture" id="Atlas_3_0"] |
| PLAYER-0047 | <code>"AtlasTexture"</code> | `scenes/player.tscn` | [L59](../scenes/player.tscn#L59) | [sub_resource type="AtlasTexture" id="Atlas_3_1"] |
| PLAYER-0048 | <code>"Atlas_3_1"</code> | `scenes/player.tscn` | [L59](../scenes/player.tscn#L59) | [sub_resource type="AtlasTexture" id="Atlas_3_1"] |
| PLAYER-0050 | <code>"AtlasTexture"</code> | `scenes/player.tscn` | [L63](../scenes/player.tscn#L63) | [sub_resource type="AtlasTexture" id="Atlas_3_2"] |
| PLAYER-0051 | <code>"Atlas_3_2"</code> | `scenes/player.tscn` | [L63](../scenes/player.tscn#L63) | [sub_resource type="AtlasTexture" id="Atlas_3_2"] |
| PLAYER-0053 | <code>"AtlasTexture"</code> | `scenes/player.tscn` | [L67](../scenes/player.tscn#L67) | [sub_resource type="AtlasTexture" id="Atlas_3_3"] |
| PLAYER-0054 | <code>"Atlas_3_3"</code> | `scenes/player.tscn` | [L67](../scenes/player.tscn#L67) | [sub_resource type="AtlasTexture" id="Atlas_3_3"] |
| PLAYER-0056 | <code>"SpriteFrames"</code> | `scenes/player.tscn` | [L71](../scenes/player.tscn#L71) | [sub_resource type="SpriteFrames" id="SpriteFrames_judy"] |
| PLAYER-0057 | <code>"SpriteFrames_judy"</code> | `scenes/player.tscn` | [L71](../scenes/player.tscn#L71) | [sub_resource type="SpriteFrames" id="SpriteFrames_judy"] |
| PLAYER-0061 | <code>"Atlas_0_0"</code> | `scenes/player.tscn` | [L75](../scenes/player.tscn#L75) | [sub_resource type="SpriteFrames" id="SpriteFrames_judy"] |
| PLAYER-0064 | <code>"Atlas_0_1"</code> | `scenes/player.tscn` | [L78](../scenes/player.tscn#L78) | [sub_resource type="SpriteFrames" id="SpriteFrames_judy"] |
| PLAYER-0067 | <code>"Atlas_0_2"</code> | `scenes/player.tscn` | [L81](../scenes/player.tscn#L81) | [sub_resource type="SpriteFrames" id="SpriteFrames_judy"] |
| PLAYER-0070 | <code>"Atlas_0_3"</code> | `scenes/player.tscn` | [L84](../scenes/player.tscn#L84) | [sub_resource type="SpriteFrames" id="SpriteFrames_judy"] |
| PLAYER-0078 | <code>"Atlas_1_0"</code> | `scenes/player.tscn` | [L92](../scenes/player.tscn#L92) | [sub_resource type="SpriteFrames" id="SpriteFrames_judy"] |
| PLAYER-0081 | <code>"Atlas_1_2"</code> | `scenes/player.tscn` | [L95](../scenes/player.tscn#L95) | [sub_resource type="SpriteFrames" id="SpriteFrames_judy"] |
| PLAYER-0089 | <code>"Atlas_2_0"</code> | `scenes/player.tscn` | [L103](../scenes/player.tscn#L103) | [sub_resource type="SpriteFrames" id="SpriteFrames_judy"] |
| PLAYER-0092 | <code>"Atlas_2_2"</code> | `scenes/player.tscn` | [L106](../scenes/player.tscn#L106) | [sub_resource type="SpriteFrames" id="SpriteFrames_judy"] |
| PLAYER-0100 | <code>"Atlas_3_0"</code> | `scenes/player.tscn` | [L114](../scenes/player.tscn#L114) | [sub_resource type="SpriteFrames" id="SpriteFrames_judy"] |
| PLAYER-0103 | <code>"Atlas_3_1"</code> | `scenes/player.tscn` | [L117](../scenes/player.tscn#L117) | [sub_resource type="SpriteFrames" id="SpriteFrames_judy"] |
| PLAYER-0106 | <code>"Atlas_3_2"</code> | `scenes/player.tscn` | [L120](../scenes/player.tscn#L120) | [sub_resource type="SpriteFrames" id="SpriteFrames_judy"] |
| PLAYER-0109 | <code>"Atlas_3_3"</code> | `scenes/player.tscn` | [L123](../scenes/player.tscn#L123) | [sub_resource type="SpriteFrames" id="SpriteFrames_judy"] |
| PLAYER-0114 | <code>"RectangleShape2D"</code> | `scenes/player.tscn` | [L130](../scenes/player.tscn#L130) | [sub_resource type="RectangleShape2D" id="RectangleShape2D_body"] |
| PLAYER-0115 | <code>"RectangleShape2D_body"</code> | `scenes/player.tscn` | [L130](../scenes/player.tscn#L130) | [sub_resource type="RectangleShape2D" id="RectangleShape2D_body"] |
| PLAYER-0116 | <code>"Player"</code> | `scenes/player.tscn` | [L133](../scenes/player.tscn#L133) | [node name="Player" type="CharacterBody2D"] |
| PLAYER-0117 | <code>"CharacterBody2D"</code> | `scenes/player.tscn` | [L133](../scenes/player.tscn#L133) | [node name="Player" type="CharacterBody2D"] |
| PLAYER-0119 | <code>"Visual"</code> | `scenes/player.tscn` | [L137](../scenes/player.tscn#L137) | [node name="Visual" type="AnimatedSprite2D" parent="."] |
| PLAYER-0120 | <code>"AnimatedSprite2D"</code> | `scenes/player.tscn` | [L137](../scenes/player.tscn#L137) | [node name="Visual" type="AnimatedSprite2D" parent="."] |
| PLAYER-0122 | <code>"SpriteFrames_judy"</code> | `scenes/player.tscn` | [L141](../scenes/player.tscn#L141) | [node name="Visual" type="AnimatedSprite2D" parent="."] |
| PLAYER-0124 | <code>"CollisionShape2D"</code> | `scenes/player.tscn` | [L144](../scenes/player.tscn#L144) | [node name="CollisionShape2D" type="CollisionShape2D" parent="."] |
| PLAYER-0125 | <code>"CollisionShape2D"</code> | `scenes/player.tscn` | [L144](../scenes/player.tscn#L144) | [node name="CollisionShape2D" type="CollisionShape2D" parent="."] |
| PLAYER-0127 | <code>"RectangleShape2D_body"</code> | `scenes/player.tscn` | [L146](../scenes/player.tscn#L146) | [node name="CollisionShape2D" type="CollisionShape2D" parent="."] |
| PLAYER-0128 | <code>"Camera2D"</code> | `scenes/player.tscn` | [L148](../scenes/player.tscn#L148) | [node name="Camera2D" type="Camera2D" parent="."] |
| PLAYER-0129 | <code>"Camera2D"</code> | `scenes/player.tscn` | [L148](../scenes/player.tscn#L148) | [node name="Camera2D" type="Camera2D" parent="."] |

## scenes/room.tscn

| ID | Current text / source literal | File path | Location | Context / template variables |
|---|---|---|---|---|
| ROOM-0002 | <code>"PackedScene"</code> | `scenes/room.tscn` | [L3](../scenes/room.tscn#L3) | file constants / initial values |
| ROOM-0005 | <code>"PackedScene"</code> | `scenes/room.tscn` | [L4](../scenes/room.tscn#L4) | file constants / initial values |
| ROOM-0008 | <code>"PackedScene"</code> | `scenes/room.tscn` | [L5](../scenes/room.tscn#L5) | file constants / initial values |
| ROOM-0011 | <code>"PackedScene"</code> | `scenes/room.tscn` | [L6](../scenes/room.tscn#L6) | file constants / initial values |
| ROOM-0014 | <code>"PackedScene"</code> | `scenes/room.tscn` | [L7](../scenes/room.tscn#L7) | file constants / initial values |
| ROOM-0017 | <code>"Script"</code> | `scenes/room.tscn` | [L8](../scenes/room.tscn#L8) | file constants / initial values |
| ROOM-0021 | <code>"Script"</code> | `scenes/room.tscn` | [L9](../scenes/room.tscn#L9) | file constants / initial values |
| ROOM-0025 | <code>"RectangleShape2D"</code> | `scenes/room.tscn` | [L11](../scenes/room.tscn#L11) | [sub_resource type="RectangleShape2D" id="RectangleShape2D_bed"] |
| ROOM-0026 | <code>"RectangleShape2D_bed"</code> | `scenes/room.tscn` | [L11](../scenes/room.tscn#L11) | [sub_resource type="RectangleShape2D" id="RectangleShape2D_bed"] |
| ROOM-0027 | <code>"RectangleShape2D"</code> | `scenes/room.tscn` | [L14](../scenes/room.tscn#L14) | [sub_resource type="RectangleShape2D" id="RectangleShape2D_shelf"] |
| ROOM-0028 | <code>"RectangleShape2D_shelf"</code> | `scenes/room.tscn` | [L14](../scenes/room.tscn#L14) | [sub_resource type="RectangleShape2D" id="RectangleShape2D_shelf"] |
| ROOM-0029 | <code>"RectangleShape2D"</code> | `scenes/room.tscn` | [L17](../scenes/room.tscn#L17) | [sub_resource type="RectangleShape2D" id="RectangleShape2D_fridge"] |
| ROOM-0030 | <code>"RectangleShape2D_fridge"</code> | `scenes/room.tscn` | [L17](../scenes/room.tscn#L17) | [sub_resource type="RectangleShape2D" id="RectangleShape2D_fridge"] |
| ROOM-0031 | <code>"RectangleShape2D"</code> | `scenes/room.tscn` | [L20](../scenes/room.tscn#L20) | [sub_resource type="RectangleShape2D" id="RectangleShape2D_chair"] |
| ROOM-0032 | <code>"RectangleShape2D_chair"</code> | `scenes/room.tscn` | [L20](../scenes/room.tscn#L20) | [sub_resource type="RectangleShape2D" id="RectangleShape2D_chair"] |
| ROOM-0033 | <code>"RectangleShape2D"</code> | `scenes/room.tscn` | [L23](../scenes/room.tscn#L23) | [sub_resource type="RectangleShape2D" id="RectangleShape2D_coffee"] |
| ROOM-0034 | <code>"RectangleShape2D_coffee"</code> | `scenes/room.tscn` | [L23](../scenes/room.tscn#L23) | [sub_resource type="RectangleShape2D" id="RectangleShape2D_coffee"] |
| ROOM-0035 | <code>"RectangleShape2D"</code> | `scenes/room.tscn` | [L26](../scenes/room.tscn#L26) | [sub_resource type="RectangleShape2D" id="RectangleShape2D_counter"] |
| ROOM-0036 | <code>"RectangleShape2D_counter"</code> | `scenes/room.tscn` | [L26](../scenes/room.tscn#L26) | [sub_resource type="RectangleShape2D" id="RectangleShape2D_counter"] |
| ROOM-0037 | <code>"RectangleShape2D"</code> | `scenes/room.tscn` | [L29](../scenes/room.tscn#L29) | [sub_resource type="RectangleShape2D" id="RectangleShape2D_kitchen"] |
| ROOM-0038 | <code>"RectangleShape2D_kitchen"</code> | `scenes/room.tscn` | [L29](../scenes/room.tscn#L29) | [sub_resource type="RectangleShape2D" id="RectangleShape2D_kitchen"] |
| ROOM-0039 | <code>"Room"</code> | `scenes/room.tscn` | [L32](../scenes/room.tscn#L32) | [node name="Room" type="Node2D" unique_id=1822665424] |
| ROOM-0040 | <code>"Node2D"</code> | `scenes/room.tscn` | [L32](../scenes/room.tscn#L32) | [node name="Room" type="Node2D" unique_id=1822665424] |
| ROOM-0041 | <code>"Floor"</code> | `scenes/room.tscn` | [L36](../scenes/room.tscn#L36) | [node name="Floor" type="Node2D" parent="." unique_id=1843004109] |
| ROOM-0042 | <code>"Node2D"</code> | `scenes/room.tscn` | [L36](../scenes/room.tscn#L36) | [node name="Floor" type="Node2D" parent="." unique_id=1843004109] |
| ROOM-0045 | <code>"Walls"</code> | `scenes/room.tscn` | [L40](../scenes/room.tscn#L40) | [node name="Walls" type="Node2D" parent="." unique_id=1994554856] |
| ROOM-0046 | <code>"Node2D"</code> | `scenes/room.tscn` | [L40](../scenes/room.tscn#L40) | [node name="Walls" type="Node2D" parent="." unique_id=1994554856] |
| ROOM-0050 | <code>"Player"</code> | `scenes/room.tscn` | [L45](../scenes/room.tscn#L45) | [node name="Player" parent="." unique_id=375429371 instance=ExtResource("1_player")] |
| ROOM-0053 | <code>"Desk"</code> | `scenes/room.tscn` | [L48](../scenes/room.tscn#L48) | [node name="Desk" parent="." unique_id=2107937223 instance=ExtResource("2_desk")] |
| ROOM-0056 | <code>"Mug"</code> | `scenes/room.tscn` | [L52](../scenes/room.tscn#L52) | [node name="Mug" type="ColorRect" parent="Desk" unique_id=532421326] |
| ROOM-0057 | <code>"ColorRect"</code> | `scenes/room.tscn` | [L52](../scenes/room.tscn#L52) | [node name="Mug" type="ColorRect" parent="Desk" unique_id=532421326] |
| ROOM-0058 | <code>"Desk"</code> | `scenes/room.tscn` | [L52](../scenes/room.tscn#L52) | [node name="Mug" type="ColorRect" parent="Desk" unique_id=532421326] |
| ROOM-0059 | <code>"Coffee"</code> | `scenes/room.tscn` | [L60](../scenes/room.tscn#L60) | [node name="Coffee" type="ColorRect" parent="Desk/Mug" unique_id=1288960003] |
| ROOM-0060 | <code>"ColorRect"</code> | `scenes/room.tscn` | [L60](../scenes/room.tscn#L60) | [node name="Coffee" type="ColorRect" parent="Desk/Mug" unique_id=1288960003] |
| ROOM-0061 | <code>"Desk/Mug"</code> | `scenes/room.tscn` | [L60](../scenes/room.tscn#L60) | [node name="Coffee" type="ColorRect" parent="Desk/Mug" unique_id=1288960003] |
| ROOM-0062 | <code>"HUD"</code> | `scenes/room.tscn` | [L69](../scenes/room.tscn#L69) | [node name="HUD" parent="." unique_id=1846410875 instance=ExtResource("3_hud")] |
| ROOM-0065 | <code>"Sink"</code> | `scenes/room.tscn` | [L71](../scenes/room.tscn#L71) | [node name="Sink" parent="." unique_id=1650233832 instance=ExtResource("5_sink")] |
| ROOM-0068 | <code>"TipTop"</code> | `scenes/room.tscn` | [L75](../scenes/room.tscn#L75) | [node name="TipTop" parent="." unique_id=1158295371 instance=ExtResource("4_tiptop")] |
| ROOM-0071 | <code>"PlantPot"</code> | `scenes/room.tscn` | [L78](../scenes/room.tscn#L78) | [node name="PlantPot" type="Node2D" parent="." unique_id=923778999] |
| ROOM-0072 | <code>"Node2D"</code> | `scenes/room.tscn` | [L78](../scenes/room.tscn#L78) | [node name="PlantPot" type="Node2D" parent="." unique_id=923778999] |
| ROOM-0074 | <code>"Visual"</code> | `scenes/room.tscn` | [L81](../scenes/room.tscn#L81) | [node name="Visual" type="Node2D" parent="PlantPot" unique_id=1527395129] |
| ROOM-0075 | <code>"Node2D"</code> | `scenes/room.tscn` | [L81](../scenes/room.tscn#L81) | [node name="Visual" type="Node2D" parent="PlantPot" unique_id=1527395129] |
| ROOM-0076 | <code>"PlantPot"</code> | `scenes/room.tscn` | [L81](../scenes/room.tscn#L81) | [node name="Visual" type="Node2D" parent="PlantPot" unique_id=1527395129] |
| ROOM-0079 | <code>"Bed"</code> | `scenes/room.tscn` | [L85](../scenes/room.tscn#L85) | [node name="Bed" type="StaticBody2D" parent="." unique_id=1925120215] |
| ROOM-0080 | <code>"StaticBody2D"</code> | `scenes/room.tscn` | [L85](../scenes/room.tscn#L85) | [node name="Bed" type="StaticBody2D" parent="." unique_id=1925120215] |
| ROOM-0082 | <code>"Visual"</code> | `scenes/room.tscn` | [L89](../scenes/room.tscn#L89) | [node name="Visual" type="Node2D" parent="Bed" unique_id=578742354] |
| ROOM-0083 | <code>"Node2D"</code> | `scenes/room.tscn` | [L89](../scenes/room.tscn#L89) | [node name="Visual" type="Node2D" parent="Bed" unique_id=578742354] |
| ROOM-0084 | <code>"Bed"</code> | `scenes/room.tscn` | [L89](../scenes/room.tscn#L89) | [node name="Visual" type="Node2D" parent="Bed" unique_id=578742354] |
| ROOM-0087 | <code>"CollisionShape2D"</code> | `scenes/room.tscn` | [L93](../scenes/room.tscn#L93) | [node name="CollisionShape2D" type="CollisionShape2D" parent="Bed" unique_id=1974694409] |
| ROOM-0088 | <code>"CollisionShape2D"</code> | `scenes/room.tscn` | [L93](../scenes/room.tscn#L93) | [node name="CollisionShape2D" type="CollisionShape2D" parent="Bed" unique_id=1974694409] |
| ROOM-0089 | <code>"Bed"</code> | `scenes/room.tscn` | [L93](../scenes/room.tscn#L93) | [node name="CollisionShape2D" type="CollisionShape2D" parent="Bed" unique_id=1974694409] |
| ROOM-0090 | <code>"RectangleShape2D_bed"</code> | `scenes/room.tscn` | [L95](../scenes/room.tscn#L95) | [node name="CollisionShape2D" type="CollisionShape2D" parent="Bed" unique_id=1974694409] |
| ROOM-0091 | <code>"Bookshelf"</code> | `scenes/room.tscn` | [L97](../scenes/room.tscn#L97) | [node name="Bookshelf" type="StaticBody2D" parent="." unique_id=1401808684] |
| ROOM-0092 | <code>"StaticBody2D"</code> | `scenes/room.tscn` | [L97](../scenes/room.tscn#L97) | [node name="Bookshelf" type="StaticBody2D" parent="." unique_id=1401808684] |
| ROOM-0094 | <code>"Visual"</code> | `scenes/room.tscn` | [L101](../scenes/room.tscn#L101) | [node name="Visual" type="Node2D" parent="Bookshelf" unique_id=206165475] |
| ROOM-0095 | <code>"Node2D"</code> | `scenes/room.tscn` | [L101](../scenes/room.tscn#L101) | [node name="Visual" type="Node2D" parent="Bookshelf" unique_id=206165475] |
| ROOM-0096 | <code>"Bookshelf"</code> | `scenes/room.tscn` | [L101](../scenes/room.tscn#L101) | [node name="Visual" type="Node2D" parent="Bookshelf" unique_id=206165475] |
| ROOM-0099 | <code>"CollisionShape2D"</code> | `scenes/room.tscn` | [L105](../scenes/room.tscn#L105) | [node name="CollisionShape2D" type="CollisionShape2D" parent="Bookshelf" unique_id=2070599576] |
| ROOM-0100 | <code>"CollisionShape2D"</code> | `scenes/room.tscn` | [L105](../scenes/room.tscn#L105) | [node name="CollisionShape2D" type="CollisionShape2D" parent="Bookshelf" unique_id=2070599576] |
| ROOM-0101 | <code>"Bookshelf"</code> | `scenes/room.tscn` | [L105](../scenes/room.tscn#L105) | [node name="CollisionShape2D" type="CollisionShape2D" parent="Bookshelf" unique_id=2070599576] |
| ROOM-0102 | <code>"RectangleShape2D_shelf"</code> | `scenes/room.tscn` | [L107](../scenes/room.tscn#L107) | [node name="CollisionShape2D" type="CollisionShape2D" parent="Bookshelf" unique_id=2070599576] |
| ROOM-0103 | <code>"Fridge"</code> | `scenes/room.tscn` | [L109](../scenes/room.tscn#L109) | [node name="Fridge" type="StaticBody2D" parent="." unique_id=1438020042] |
| ROOM-0104 | <code>"StaticBody2D"</code> | `scenes/room.tscn` | [L109](../scenes/room.tscn#L109) | [node name="Fridge" type="StaticBody2D" parent="." unique_id=1438020042] |
| ROOM-0106 | <code>"Visual"</code> | `scenes/room.tscn` | [L113](../scenes/room.tscn#L113) | [node name="Visual" type="Node2D" parent="Fridge" unique_id=1395725072] |
| ROOM-0107 | <code>"Node2D"</code> | `scenes/room.tscn` | [L113](../scenes/room.tscn#L113) | [node name="Visual" type="Node2D" parent="Fridge" unique_id=1395725072] |
| ROOM-0108 | <code>"Fridge"</code> | `scenes/room.tscn` | [L113](../scenes/room.tscn#L113) | [node name="Visual" type="Node2D" parent="Fridge" unique_id=1395725072] |
| ROOM-0111 | <code>"CollisionShape2D"</code> | `scenes/room.tscn` | [L117](../scenes/room.tscn#L117) | [node name="CollisionShape2D" type="CollisionShape2D" parent="Fridge" unique_id=32420749] |
| ROOM-0112 | <code>"CollisionShape2D"</code> | `scenes/room.tscn` | [L117](../scenes/room.tscn#L117) | [node name="CollisionShape2D" type="CollisionShape2D" parent="Fridge" unique_id=32420749] |
| ROOM-0113 | <code>"Fridge"</code> | `scenes/room.tscn` | [L117](../scenes/room.tscn#L117) | [node name="CollisionShape2D" type="CollisionShape2D" parent="Fridge" unique_id=32420749] |
| ROOM-0114 | <code>"RectangleShape2D_fridge"</code> | `scenes/room.tscn` | [L119](../scenes/room.tscn#L119) | [node name="CollisionShape2D" type="CollisionShape2D" parent="Fridge" unique_id=32420749] |
| ROOM-0115 | <code>"Chair"</code> | `scenes/room.tscn` | [L121](../scenes/room.tscn#L121) | [node name="Chair" type="StaticBody2D" parent="." unique_id=1257593646] |
| ROOM-0116 | <code>"StaticBody2D"</code> | `scenes/room.tscn` | [L121](../scenes/room.tscn#L121) | [node name="Chair" type="StaticBody2D" parent="." unique_id=1257593646] |
| ROOM-0118 | <code>"Visual"</code> | `scenes/room.tscn` | [L125](../scenes/room.tscn#L125) | [node name="Visual" type="Node2D" parent="Chair" unique_id=190184676] |
| ROOM-0119 | <code>"Node2D"</code> | `scenes/room.tscn` | [L125](../scenes/room.tscn#L125) | [node name="Visual" type="Node2D" parent="Chair" unique_id=190184676] |
| ROOM-0120 | <code>"Chair"</code> | `scenes/room.tscn` | [L125](../scenes/room.tscn#L125) | [node name="Visual" type="Node2D" parent="Chair" unique_id=190184676] |
| ROOM-0123 | <code>"CollisionShape2D"</code> | `scenes/room.tscn` | [L129](../scenes/room.tscn#L129) | [node name="CollisionShape2D" type="CollisionShape2D" parent="Chair" unique_id=1545013196] |
| ROOM-0124 | <code>"CollisionShape2D"</code> | `scenes/room.tscn` | [L129](../scenes/room.tscn#L129) | [node name="CollisionShape2D" type="CollisionShape2D" parent="Chair" unique_id=1545013196] |
| ROOM-0125 | <code>"Chair"</code> | `scenes/room.tscn` | [L129](../scenes/room.tscn#L129) | [node name="CollisionShape2D" type="CollisionShape2D" parent="Chair" unique_id=1545013196] |
| ROOM-0126 | <code>"RectangleShape2D_chair"</code> | `scenes/room.tscn` | [L131](../scenes/room.tscn#L131) | [node name="CollisionShape2D" type="CollisionShape2D" parent="Chair" unique_id=1545013196] |
| ROOM-0127 | <code>"DeskPlant"</code> | `scenes/room.tscn` | [L133](../scenes/room.tscn#L133) | [node name="DeskPlant" type="Node2D" parent="." unique_id=1524521325] |
| ROOM-0128 | <code>"Node2D"</code> | `scenes/room.tscn` | [L133](../scenes/room.tscn#L133) | [node name="DeskPlant" type="Node2D" parent="." unique_id=1524521325] |
| ROOM-0130 | <code>"Visual"</code> | `scenes/room.tscn` | [L136](../scenes/room.tscn#L136) | [node name="Visual" type="Node2D" parent="DeskPlant" unique_id=1276952621] |
| ROOM-0131 | <code>"Node2D"</code> | `scenes/room.tscn` | [L136](../scenes/room.tscn#L136) | [node name="Visual" type="Node2D" parent="DeskPlant" unique_id=1276952621] |
| ROOM-0132 | <code>"DeskPlant"</code> | `scenes/room.tscn` | [L136](../scenes/room.tscn#L136) | [node name="Visual" type="Node2D" parent="DeskPlant" unique_id=1276952621] |
| ROOM-0135 | <code>"CoffeeTable"</code> | `scenes/room.tscn` | [L140](../scenes/room.tscn#L140) | [node name="CoffeeTable" type="StaticBody2D" parent="." unique_id=1093882474] |
| ROOM-0136 | <code>"StaticBody2D"</code> | `scenes/room.tscn` | [L140](../scenes/room.tscn#L140) | [node name="CoffeeTable" type="StaticBody2D" parent="." unique_id=1093882474] |
| ROOM-0138 | <code>"Visual"</code> | `scenes/room.tscn` | [L144](../scenes/room.tscn#L144) | [node name="Visual" type="Node2D" parent="CoffeeTable" unique_id=2079062357] |
| ROOM-0139 | <code>"Node2D"</code> | `scenes/room.tscn` | [L144](../scenes/room.tscn#L144) | [node name="Visual" type="Node2D" parent="CoffeeTable" unique_id=2079062357] |
| ROOM-0140 | <code>"CoffeeTable"</code> | `scenes/room.tscn` | [L144](../scenes/room.tscn#L144) | [node name="Visual" type="Node2D" parent="CoffeeTable" unique_id=2079062357] |
| ROOM-0143 | <code>"CollisionShape2D"</code> | `scenes/room.tscn` | [L148](../scenes/room.tscn#L148) | [node name="CollisionShape2D" type="CollisionShape2D" parent="CoffeeTable" unique_id=208974948] |
| ROOM-0144 | <code>"CollisionShape2D"</code> | `scenes/room.tscn` | [L148](../scenes/room.tscn#L148) | [node name="CollisionShape2D" type="CollisionShape2D" parent="CoffeeTable" unique_id=208974948] |
| ROOM-0145 | <code>"CoffeeTable"</code> | `scenes/room.tscn` | [L148](../scenes/room.tscn#L148) | [node name="CollisionShape2D" type="CollisionShape2D" parent="CoffeeTable" unique_id=208974948] |
| ROOM-0146 | <code>"RectangleShape2D_coffee"</code> | `scenes/room.tscn` | [L150](../scenes/room.tscn#L150) | [node name="CollisionShape2D" type="CollisionShape2D" parent="CoffeeTable" unique_id=208974948] |
| ROOM-0147 | <code>"KitchenCounter"</code> | `scenes/room.tscn` | [L152](../scenes/room.tscn#L152) | [node name="KitchenCounter" type="StaticBody2D" parent="." unique_id=806970149] |
| ROOM-0148 | <code>"StaticBody2D"</code> | `scenes/room.tscn` | [L152](../scenes/room.tscn#L152) | [node name="KitchenCounter" type="StaticBody2D" parent="." unique_id=806970149] |
| ROOM-0150 | <code>"Visual"</code> | `scenes/room.tscn` | [L156](../scenes/room.tscn#L156) | [node name="Visual" type="Node2D" parent="KitchenCounter" unique_id=862399567] |
| ROOM-0151 | <code>"Node2D"</code> | `scenes/room.tscn` | [L156](../scenes/room.tscn#L156) | [node name="Visual" type="Node2D" parent="KitchenCounter" unique_id=862399567] |
| ROOM-0152 | <code>"KitchenCounter"</code> | `scenes/room.tscn` | [L156](../scenes/room.tscn#L156) | [node name="Visual" type="Node2D" parent="KitchenCounter" unique_id=862399567] |
| ROOM-0155 | <code>"CollisionShape2D"</code> | `scenes/room.tscn` | [L160](../scenes/room.tscn#L160) | [node name="CollisionShape2D" type="CollisionShape2D" parent="KitchenCounter" unique_id=158718634] |
| ROOM-0156 | <code>"CollisionShape2D"</code> | `scenes/room.tscn` | [L160](../scenes/room.tscn#L160) | [node name="CollisionShape2D" type="CollisionShape2D" parent="KitchenCounter" unique_id=158718634] |
| ROOM-0157 | <code>"KitchenCounter"</code> | `scenes/room.tscn` | [L160](../scenes/room.tscn#L160) | [node name="CollisionShape2D" type="CollisionShape2D" parent="KitchenCounter" unique_id=158718634] |
| ROOM-0158 | <code>"RectangleShape2D_counter"</code> | `scenes/room.tscn` | [L162](../scenes/room.tscn#L162) | [node name="CollisionShape2D" type="CollisionShape2D" parent="KitchenCounter" unique_id=158718634] |
| ROOM-0159 | <code>"BedsideLamp"</code> | `scenes/room.tscn` | [L164](../scenes/room.tscn#L164) | [node name="BedsideLamp" type="Node2D" parent="." unique_id=1467917678] |
| ROOM-0160 | <code>"Node2D"</code> | `scenes/room.tscn` | [L164](../scenes/room.tscn#L164) | [node name="BedsideLamp" type="Node2D" parent="." unique_id=1467917678] |
| ROOM-0162 | <code>"Visual"</code> | `scenes/room.tscn` | [L167](../scenes/room.tscn#L167) | [node name="Visual" type="Node2D" parent="BedsideLamp" unique_id=895081100] |
| ROOM-0163 | <code>"Node2D"</code> | `scenes/room.tscn` | [L167](../scenes/room.tscn#L167) | [node name="Visual" type="Node2D" parent="BedsideLamp" unique_id=895081100] |
| ROOM-0164 | <code>"BedsideLamp"</code> | `scenes/room.tscn` | [L167](../scenes/room.tscn#L167) | [node name="Visual" type="Node2D" parent="BedsideLamp" unique_id=895081100] |
| ROOM-0167 | <code>"FramingCamera"</code> | `scenes/room.tscn` | [L171](../scenes/room.tscn#L171) | [node name="FramingCamera" type="Camera2D" parent="." unique_id=890460084] |
| ROOM-0168 | <code>"Camera2D"</code> | `scenes/room.tscn` | [L171](../scenes/room.tscn#L171) | [node name="FramingCamera" type="Camera2D" parent="." unique_id=890460084] |
| ROOM-0170 | <code>"KitchenBuiltIn"</code> | `scenes/room.tscn` | [L174](../scenes/room.tscn#L174) | [node name="KitchenBuiltIn" type="StaticBody2D" parent="." unique_id=431612820] |
| ROOM-0171 | <code>"StaticBody2D"</code> | `scenes/room.tscn` | [L174](../scenes/room.tscn#L174) | [node name="KitchenBuiltIn" type="StaticBody2D" parent="." unique_id=431612820] |
| ROOM-0173 | <code>"CollisionShape2D"</code> | `scenes/room.tscn` | [L177](../scenes/room.tscn#L177) | [node name="CollisionShape2D" type="CollisionShape2D" parent="KitchenBuiltIn" unique_id=1441979494] |
| ROOM-0174 | <code>"CollisionShape2D"</code> | `scenes/room.tscn` | [L177](../scenes/room.tscn#L177) | [node name="CollisionShape2D" type="CollisionShape2D" parent="KitchenBuiltIn" unique_id=1441979494] |
| ROOM-0175 | <code>"KitchenBuiltIn"</code> | `scenes/room.tscn` | [L177](../scenes/room.tscn#L177) | [node name="CollisionShape2D" type="CollisionShape2D" parent="KitchenBuiltIn" unique_id=1441979494] |
| ROOM-0176 | <code>"RectangleShape2D_kitchen"</code> | `scenes/room.tscn` | [L178](../scenes/room.tscn#L178) | [node name="CollisionShape2D" type="CollisionShape2D" parent="KitchenBuiltIn" unique_id=1441979494] |
| ROOM-0177 | <code>"Atmosphere"</code> | `scenes/room.tscn` | [L180](../scenes/room.tscn#L180) | [node name="Atmosphere" type="Node2D" parent="." unique_id=1997847314] |
| ROOM-0178 | <code>"Node2D"</code> | `scenes/room.tscn` | [L180](../scenes/room.tscn#L180) | [node name="Atmosphere" type="Node2D" parent="." unique_id=1997847314] |

## scenes/showcase_bad.tscn

| ID | Current text / source literal | File path | Location | Context / template variables |
|---|---|---|---|---|
| SHOWCASE_BAD-0001 | <code>"Script"</code> | `scenes/showcase_bad.tscn` | [L3](../scenes/showcase_bad.tscn#L3) | file constants / initial values |
| SHOWCASE_BAD-0004 | <code>"BadShowcase"</code> | `scenes/showcase_bad.tscn` | [L5](../scenes/showcase_bad.tscn#L5) | [node name="BadShowcase" type="Control"] |
| SHOWCASE_BAD-0005 | <code>"Control"</code> | `scenes/showcase_bad.tscn` | [L5](../scenes/showcase_bad.tscn#L5) | [node name="BadShowcase" type="Control"] |

## scenes/showcase_bittersweet.tscn

| ID | Current text / source literal | File path | Location | Context / template variables |
|---|---|---|---|---|
| SHOWCASE_BITTERSWEET-0001 | <code>"Script"</code> | `scenes/showcase_bittersweet.tscn` | [L3](../scenes/showcase_bittersweet.tscn#L3) | file constants / initial values |
| SHOWCASE_BITTERSWEET-0004 | <code>"BittersweetShowcase"</code> | `scenes/showcase_bittersweet.tscn` | [L5](../scenes/showcase_bittersweet.tscn#L5) | [node name="BittersweetShowcase" type="Control"] |
| SHOWCASE_BITTERSWEET-0005 | <code>"Control"</code> | `scenes/showcase_bittersweet.tscn` | [L5](../scenes/showcase_bittersweet.tscn#L5) | [node name="BittersweetShowcase" type="Control"] |

## scenes/showcase_good.tscn

| ID | Current text / source literal | File path | Location | Context / template variables |
|---|---|---|---|---|
| SHOWCASE_GOOD-0001 | <code>"Script"</code> | `scenes/showcase_good.tscn` | [L3](../scenes/showcase_good.tscn#L3) | file constants / initial values |
| SHOWCASE_GOOD-0004 | <code>"GoodShowcase"</code> | `scenes/showcase_good.tscn` | [L5](../scenes/showcase_good.tscn#L5) | [node name="GoodShowcase" type="Control"] |
| SHOWCASE_GOOD-0005 | <code>"Control"</code> | `scenes/showcase_good.tscn` | [L5](../scenes/showcase_good.tscn#L5) | [node name="GoodShowcase" type="Control"] |

## scenes/sink.tscn

| ID | Current text / source literal | File path | Location | Context / template variables |
|---|---|---|---|---|
| SINK-0001 | <code>"Script"</code> | `scenes/sink.tscn` | [L3](../scenes/sink.tscn#L3) | file constants / initial values |
| SINK-0004 | <code>"RectangleShape2D"</code> | `scenes/sink.tscn` | [L5](../scenes/sink.tscn#L5) | [sub_resource type="RectangleShape2D" id="RectangleShape2D_body"] |
| SINK-0005 | <code>"RectangleShape2D_body"</code> | `scenes/sink.tscn` | [L5](../scenes/sink.tscn#L5) | [sub_resource type="RectangleShape2D" id="RectangleShape2D_body"] |
| SINK-0006 | <code>"Sink"</code> | `scenes/sink.tscn` | [L8](../scenes/sink.tscn#L8) | [node name="Sink" type="StaticBody2D"] |
| SINK-0007 | <code>"StaticBody2D"</code> | `scenes/sink.tscn` | [L8](../scenes/sink.tscn#L8) | [node name="Sink" type="StaticBody2D"] |
| SINK-0008 | <code>"Visual"</code> | `scenes/sink.tscn` | [L10](../scenes/sink.tscn#L10) | [node name="Visual" type="Node2D" parent="."] |
| SINK-0009 | <code>"Node2D"</code> | `scenes/sink.tscn` | [L10](../scenes/sink.tscn#L10) | [node name="Visual" type="Node2D" parent="."] |
| SINK-0013 | <code>"CollisionShape2D"</code> | `scenes/sink.tscn` | [L14](../scenes/sink.tscn#L14) | [node name="CollisionShape2D" type="CollisionShape2D" parent="."] |
| SINK-0014 | <code>"CollisionShape2D"</code> | `scenes/sink.tscn` | [L14](../scenes/sink.tscn#L14) | [node name="CollisionShape2D" type="CollisionShape2D" parent="."] |
| SINK-0016 | <code>"RectangleShape2D_body"</code> | `scenes/sink.tscn` | [L16](../scenes/sink.tscn#L16) | [node name="CollisionShape2D" type="CollisionShape2D" parent="."] |

## scenes/tiptop.tscn

| ID | Current text / source literal | File path | Location | Context / template variables |
|---|---|---|---|---|
| TIPTOP-0001 | <code>"Texture2D"</code> | `scenes/tiptop.tscn` | [L3](../scenes/tiptop.tscn#L3) | file constants / initial values |
| TIPTOP-0004 | <code>"Script"</code> | `scenes/tiptop.tscn` | [L4](../scenes/tiptop.tscn#L4) | file constants / initial values |
| TIPTOP-0007 | <code>"AtlasTexture"</code> | `scenes/tiptop.tscn` | [L6](../scenes/tiptop.tscn#L6) | [sub_resource type="AtlasTexture" id="Atlas_hover_0"] |
| TIPTOP-0008 | <code>"Atlas_hover_0"</code> | `scenes/tiptop.tscn` | [L6](../scenes/tiptop.tscn#L6) | [sub_resource type="AtlasTexture" id="Atlas_hover_0"] |
| TIPTOP-0010 | <code>"AtlasTexture"</code> | `scenes/tiptop.tscn` | [L10](../scenes/tiptop.tscn#L10) | [sub_resource type="AtlasTexture" id="Atlas_hover_1"] |
| TIPTOP-0011 | <code>"Atlas_hover_1"</code> | `scenes/tiptop.tscn` | [L10](../scenes/tiptop.tscn#L10) | [sub_resource type="AtlasTexture" id="Atlas_hover_1"] |
| TIPTOP-0013 | <code>"AtlasTexture"</code> | `scenes/tiptop.tscn` | [L14](../scenes/tiptop.tscn#L14) | [sub_resource type="AtlasTexture" id="Atlas_hover_2"] |
| TIPTOP-0014 | <code>"Atlas_hover_2"</code> | `scenes/tiptop.tscn` | [L14](../scenes/tiptop.tscn#L14) | [sub_resource type="AtlasTexture" id="Atlas_hover_2"] |
| TIPTOP-0016 | <code>"AtlasTexture"</code> | `scenes/tiptop.tscn` | [L18](../scenes/tiptop.tscn#L18) | [sub_resource type="AtlasTexture" id="Atlas_hover_3"] |
| TIPTOP-0017 | <code>"Atlas_hover_3"</code> | `scenes/tiptop.tscn` | [L18](../scenes/tiptop.tscn#L18) | [sub_resource type="AtlasTexture" id="Atlas_hover_3"] |
| TIPTOP-0019 | <code>"SpriteFrames"</code> | `scenes/tiptop.tscn` | [L22](../scenes/tiptop.tscn#L22) | [sub_resource type="SpriteFrames" id="SpriteFrames_tiptop"] |
| TIPTOP-0020 | <code>"SpriteFrames_tiptop"</code> | `scenes/tiptop.tscn` | [L22](../scenes/tiptop.tscn#L22) | [sub_resource type="SpriteFrames" id="SpriteFrames_tiptop"] |
| TIPTOP-0024 | <code>"Atlas_hover_0"</code> | `scenes/tiptop.tscn` | [L26](../scenes/tiptop.tscn#L26) | [sub_resource type="SpriteFrames" id="SpriteFrames_tiptop"] |
| TIPTOP-0027 | <code>"Atlas_hover_1"</code> | `scenes/tiptop.tscn` | [L29](../scenes/tiptop.tscn#L29) | [sub_resource type="SpriteFrames" id="SpriteFrames_tiptop"] |
| TIPTOP-0030 | <code>"Atlas_hover_2"</code> | `scenes/tiptop.tscn` | [L32](../scenes/tiptop.tscn#L32) | [sub_resource type="SpriteFrames" id="SpriteFrames_tiptop"] |
| TIPTOP-0033 | <code>"Atlas_hover_3"</code> | `scenes/tiptop.tscn` | [L35](../scenes/tiptop.tscn#L35) | [sub_resource type="SpriteFrames" id="SpriteFrames_tiptop"] |
| TIPTOP-0038 | <code>"RectangleShape2D"</code> | `scenes/tiptop.tscn` | [L42](../scenes/tiptop.tscn#L42) | [sub_resource type="RectangleShape2D" id="RectangleShape2D_body"] |
| TIPTOP-0039 | <code>"RectangleShape2D_body"</code> | `scenes/tiptop.tscn` | [L42](../scenes/tiptop.tscn#L42) | [sub_resource type="RectangleShape2D" id="RectangleShape2D_body"] |
| TIPTOP-0040 | <code>"TipTop"</code> | `scenes/tiptop.tscn` | [L45](../scenes/tiptop.tscn#L45) | [node name="TipTop" type="CharacterBody2D"] |
| TIPTOP-0041 | <code>"CharacterBody2D"</code> | `scenes/tiptop.tscn` | [L45](../scenes/tiptop.tscn#L45) | [node name="TipTop" type="CharacterBody2D"] |
| TIPTOP-0043 | <code>"Visual"</code> | `scenes/tiptop.tscn` | [L50](../scenes/tiptop.tscn#L50) | [node name="Visual" type="AnimatedSprite2D" parent="."] |
| TIPTOP-0044 | <code>"AnimatedSprite2D"</code> | `scenes/tiptop.tscn` | [L50](../scenes/tiptop.tscn#L50) | [node name="Visual" type="AnimatedSprite2D" parent="."] |
| TIPTOP-0046 | <code>"SpriteFrames_tiptop"</code> | `scenes/tiptop.tscn` | [L54](../scenes/tiptop.tscn#L54) | [node name="Visual" type="AnimatedSprite2D" parent="."] |
| TIPTOP-0049 | <code>"CollisionShape2D"</code> | `scenes/tiptop.tscn` | [L58](../scenes/tiptop.tscn#L58) | [node name="CollisionShape2D" type="CollisionShape2D" parent="."] |
| TIPTOP-0050 | <code>"CollisionShape2D"</code> | `scenes/tiptop.tscn` | [L58](../scenes/tiptop.tscn#L58) | [node name="CollisionShape2D" type="CollisionShape2D" parent="."] |
| TIPTOP-0052 | <code>"RectangleShape2D_body"</code> | `scenes/tiptop.tscn` | [L60](../scenes/tiptop.tscn#L60) | [node name="CollisionShape2D" type="CollisionShape2D" parent="."] |

## scenes/title.tscn

| ID | Current text / source literal | File path | Location | Context / template variables |
|---|---|---|---|---|
| TITLE-0001 | <code>"Script"</code> | `scenes/title.tscn` | [L3](../scenes/title.tscn#L3) | file constants / initial values |
| TITLE-0004 | <code>"TitleScreen"</code> | `scenes/title.tscn` | [L5](../scenes/title.tscn#L5) | [node name="TitleScreen" type="Control"] |
| TITLE-0005 | <code>"Control"</code> | `scenes/title.tscn` | [L5](../scenes/title.tscn#L5) | [node name="TitleScreen" type="Control"] |

## scripts/apartment_audio.gd

| ID | Current text / source literal | File path | Location | Context / template variables |
|---|---|---|---|---|
| APARTMENT_AUDIO-0192 | <code>"Missing or undecodable SFX: "</code> | `scripts/apartment_audio.gd` | [L159](../scripts/apartment_audio.gd#L159) | func _ready |
| APARTMENT_AUDIO-0193 | <code>"SFX"</code> | `scripts/apartment_audio.gd` | [L162](../scripts/apartment_audio.gd#L162) | func _ready |
| APARTMENT_AUDIO-0195 | <code>"BaseButton"</code> | `scripts/apartment_audio.gd` | [L166](../scripts/apartment_audio.gd#L166) | func _ready |
| APARTMENT_AUDIO-0196 | <code>"Music"</code> | `scripts/apartment_audio.gd` | [L174](../scripts/apartment_audio.gd#L174) | func _initialise_music |
| APARTMENT_AUDIO-0197 | <code>"Music"</code> | `scripts/apartment_audio.gd` | [L177](../scripts/apartment_audio.gd#L177) | func _initialise_music |
| APARTMENT_AUDIO-0198 | <code>"Master"</code> | `scripts/apartment_audio.gd` | [L178](../scripts/apartment_audio.gd#L178) | func _initialise_music |
| APARTMENT_AUDIO-0200 | <code>"Music"</code> | `scripts/apartment_audio.gd` | [L182](../scripts/apartment_audio.gd#L182) | func _initialise_music |
| APARTMENT_AUDIO-0201 | <code>"Music"</code> | `scripts/apartment_audio.gd` | [L183](../scripts/apartment_audio.gd#L183) | func _initialise_music |
| APARTMENT_AUDIO-0202 | <code>"ApartmentTheme"</code> | `scripts/apartment_audio.gd` | [L187](../scripts/apartment_audio.gd#L187) | func _initialise_music |
| APARTMENT_AUDIO-0203 | <code>"Music"</code> | `scripts/apartment_audio.gd` | [L189](../scripts/apartment_audio.gd#L189) | func _initialise_music |
| APARTMENT_AUDIO-0204 | <code>"AudioStreamOggVorbis"</code> | `scripts/apartment_audio.gd` | [L196](../scripts/apartment_audio.gd#L196) | func _initialise_music |
| APARTMENT_AUDIO-0205 | <code>"BGM unavailable or undecodable: "</code> | `scripts/apartment_audio.gd` | [L206](../scripts/apartment_audio.gd#L206) | func _initialise_music |
| APARTMENT_AUDIO-0206 | <code>". Reimport this original OGG; no replacement track was used."</code> | `scripts/apartment_audio.gd` | [L206](../scripts/apartment_audio.gd#L206) | func _initialise_music |
| APARTMENT_AUDIO-0213 | <code>"main menu"</code> | `scripts/apartment_audio.gd` | [L228](../scripts/apartment_audio.gd#L228) | func _button_pressed |
| APARTMENT_AUDIO-0220 | <code>"watch research"</code> | `scripts/apartment_audio.gd` | [L232](../scripts/apartment_audio.gd#L232) | func _button_pressed |
| APARTMENT_AUDIO-0221 | <code>"new game"</code> | `scripts/apartment_audio.gd` | [L232](../scripts/apartment_audio.gd#L232) | func _button_pressed |
| APARTMENT_AUDIO-0224 | <code>"AudioStreamWAV"</code> | `scripts/apartment_audio.gd` | [L240](../scripts/apartment_audio.gd#L240) | func _load_sfx |
| APARTMENT_AUDIO-0228 | <code>"Player"</code> | `scripts/apartment_audio.gd` | [L258](../scripts/apartment_audio.gd#L258) | func _attach_room |
| APARTMENT_AUDIO-0229 | <code>"TipTop"</code> | `scripts/apartment_audio.gd` | [L259](../scripts/apartment_audio.gd#L259) | func _attach_room |
| APARTMENT_AUDIO-0230 | <code>"HUD"</code> | `scripts/apartment_audio.gd` | [L260](../scripts/apartment_audio.gd#L260) | func _attach_room |
| APARTMENT_AUDIO-0231 | <code>"ApartmentAudio"</code> | `scripts/apartment_audio.gd` | [L262](../scripts/apartment_audio.gd#L262) | func _attach_room |
| APARTMENT_AUDIO-0232 | <code>"SFX"</code> | `scripts/apartment_audio.gd` | [L270](../scripts/apartment_audio.gd#L270) | func _attach_room |
| APARTMENT_AUDIO-0242 | <code>"Ambience"</code> | `scripts/apartment_audio.gd` | [L280](../scripts/apartment_audio.gd#L280) | func _attach_room |
| APARTMENT_AUDIO-0245 | <code>"RobotMovement"</code> | `scripts/apartment_audio.gd` | [L280](../scripts/apartment_audio.gd#L280) | func _attach_room |
| APARTMENT_AUDIO-0247 | <code>"SFX"</code> | `scripts/apartment_audio.gd` | [L280](../scripts/apartment_audio.gd#L280) | func _attach_room |
| APARTMENT_AUDIO-0260 | <code>"Player"</code> | `scripts/apartment_audio.gd` | [L320](../scripts/apartment_audio.gd#L320) | func _process |
| APARTMENT_AUDIO-0261 | <code>"TipTop"</code> | `scripts/apartment_audio.gd` | [L320](../scripts/apartment_audio.gd#L320) | func _process |
| APARTMENT_AUDIO-0262 | <code>"HUD"</code> | `scripts/apartment_audio.gd` | [L320](../scripts/apartment_audio.gd#L320) | func _process |
| APARTMENT_AUDIO-0271 | <code>"Sink"</code> | `scripts/apartment_audio.gd` | [L336](../scripts/apartment_audio.gd#L336) | func _process |
| APARTMENT_AUDIO-0275 | <code>"Fridge"</code> | `scripts/apartment_audio.gd` | [L338](../scripts/apartment_audio.gd#L338) | func _process |
| APARTMENT_AUDIO-0289 | <code>"Desk"</code> | `scripts/apartment_audio.gd` | [L356](../scripts/apartment_audio.gd#L356) | func _process |
| APARTMENT_AUDIO-0291 | <code>"Fridge"</code> | `scripts/apartment_audio.gd` | [L366](../scripts/apartment_audio.gd#L366) | func _process |
| APARTMENT_AUDIO-0292 | <code>"Visual"</code> | `scripts/apartment_audio.gd` | [L374](../scripts/apartment_audio.gd#L374) | func _update_steps |
| APARTMENT_AUDIO-0324 | <code>"laser_%d"</code> | `scripts/apartment_audio.gd` | [L436](../scripts/apartment_audio.gd#L436) | func _update_activity Formatting arguments: % rng.randi_range(0, 1) |
| APARTMENT_AUDIO-0371 | <code>"Bookshelf"</code> | `scripts/apartment_audio.gd` | [L494](../scripts/apartment_audio.gd#L494) | func _activity_state_changed |
| APARTMENT_AUDIO-0373 | <code>"PlantPot"</code> | `scripts/apartment_audio.gd` | [L494](../scripts/apartment_audio.gd#L494) | func _activity_state_changed |
| APARTMENT_AUDIO-0375 | <code>"Bed"</code> | `scripts/apartment_audio.gd` | [L494](../scripts/apartment_audio.gd#L494) | func _activity_state_changed |
| APARTMENT_AUDIO-0383 | <code>"Sink"</code> | `scripts/apartment_audio.gd` | [L500](../scripts/apartment_audio.gd#L500) | func _activity_state_changed |
| APARTMENT_AUDIO-0385 | <code>"Sink"</code> | `scripts/apartment_audio.gd` | [L503](../scripts/apartment_audio.gd#L503) | func _activity_state_changed |
| APARTMENT_AUDIO-0387 | <code>"Fridge"</code> | `scripts/apartment_audio.gd` | [L510](../scripts/apartment_audio.gd#L510) | func fridge_access |
| APARTMENT_AUDIO-0405 | <code>"step_%d"</code> | `scripts/apartment_audio.gd` | [L559](../scripts/apartment_audio.gd#L559) | func play_world Formatting arguments: % rng.randi_range(0, 2), -15.0, 1.0, 0.0] |
| APARTMENT_AUDIO-0435 | <code>"HUD"</code> | `scripts/apartment_audio.gd` | [L657](../scripts/apartment_audio.gd#L657) | func _update_music |
| APARTMENT_AUDIO-0436 | <code>"HUD"</code> | `scripts/apartment_audio.gd` | [L658](../scripts/apartment_audio.gd#L658) | func _update_music |

## scripts/apartment_lighting.gd

| ID | Current text / source literal | File path | Location | Context / template variables |
|---|---|---|---|---|
| APARTMENT_LIGHTING-0009 | <code>"BedsideLamp"</code> | `scripts/apartment_lighting.gd` | [L28](../scripts/apartment_lighting.gd#L28) | func _ready |
| APARTMENT_LIGHTING-0010 | <code>"Desk"</code> | `scripts/apartment_lighting.gd` | [L29](../scripts/apartment_lighting.gd#L29) | func _ready |

## scripts/apartment_visual.gd

| ID | Current text / source literal | File path | Location | Context / template variables |
|---|---|---|---|---|
| APARTMENT_VISUAL-0072 | <code>"PlantPot"</code> | `scripts/apartment_visual.gd` | [L234](../scripts/apartment_visual.gd#L234) | func _draw |
| APARTMENT_VISUAL-0094 | <code>"PlantPot"</code> | `scripts/apartment_visual.gd` | [L340](../scripts/apartment_visual.gd#L340) | func _draw_chore_details |

## scripts/desk.gd

| ID | Current text / source literal | File path | Location | Context / template variables |
|---|---|---|---|---|
| DESK-0001 | <code>"Too exhausted to work"</code> | `scripts/desk.gd` | [L17](../scripts/desk.gd#L17) | func _update_prompt |
| DESK-0002 | <code>"E - Work"</code> | `scripts/desk.gd` | [L17](../scripts/desk.gd#L17) | func _update_prompt |
| DESK-0003 | <code>"Player"</code> | `scripts/desk.gd` | [L22](../scripts/desk.gd#L22) | func _on_interaction_zone_body_entered |
| DESK-0005 | <code>"Player"</code> | `scripts/desk.gd` | [L28](../scripts/desk.gd#L28) | func _on_interaction_zone_body_exited |

## scripts/game_state.gd

| ID | Current text / source literal | File path | Location | Context / template variables |
|---|---|---|---|---|
| GAME_STATE-0002 | <code>"Easy"</code> | `scripts/game_state.gd` | [L20](../scripts/game_state.gd#L20) | file constants / initial values |
| GAME_STATE-0010 | <code>"More research, shorter repairs, gentler needs."</code> | `scripts/game_state.gd` | [L20](../scripts/game_state.gd#L20) | file constants / initial values |
| GAME_STATE-0012 | <code>"Medium"</code> | `scripts/game_state.gd` | [L21](../scripts/game_state.gd#L21) | file constants / initial values |
| GAME_STATE-0020 | <code>"The established balance, with repair rewards."</code> | `scripts/game_state.gd` | [L21](../scripts/game_state.gd#L21) | file constants / initial values |
| GAME_STATE-0022 | <code>"Hard"</code> | `scripts/game_state.gd` | [L22](../scripts/game_state.gd#L22) | file constants / initial values |
| GAME_STATE-0030 | <code>"Less research and faster needs depletion."</code> | `scripts/game_state.gd` | [L22](../scripts/game_state.gd#L22) | file constants / initial values |
| GAME_STATE-0082 | <code>"Task ejected. Elapsed time kept; no completion reward."</code> | `scripts/game_state.gd` | [L155](../scripts/game_state.gd#L155) | func eject_current_task |
| GAME_STATE-0084 | <code>"TipTop: No airborne intruders detected."</code> | `scripts/game_state.gd` | [L162](../scripts/game_state.gd#L162) | func request_mosquito_batch |
| GAME_STATE-0086 | <code>"Well-fed"</code> | `scripts/game_state.gd` | [L174](../scripts/game_state.gd#L174) | func hunger_status |
| GAME_STATE-0087 | <code>"Normal"</code> | `scripts/game_state.gd` | [L174](../scripts/game_state.gd#L174) | func hunger_status |
| GAME_STATE-0088 | <code>"Hungry"</code> | `scripts/game_state.gd` | [L174](../scripts/game_state.gd#L174) | func hunger_status |
| GAME_STATE-0089 | <code>"TipTop"</code> | `scripts/game_state.gd` | [L183](../scripts/game_state.gd#L183) | func _update_mosquito_population |
| GAME_STATE-0090 | <code>"Sink"</code> | `scripts/game_state.gd` | [L189](../scripts/game_state.gd#L189) | func _update_mosquito_population |
| GAME_STATE-0091 | <code>"PlantPot"</code> | `scripts/game_state.gd` | [L189](../scripts/game_state.gd#L189) | func _update_mosquito_population |
| GAME_STATE-0098 | <code>"TipTop"</code> | `scripts/game_state.gd` | [L198](../scripts/game_state.gd#L198) | func _move_mosquitoes |
| GAME_STATE-0115 | <code>"Not enough time before 8:00 PM for that activity."</code> | `scripts/game_state.gd` | [L277](../scripts/game_state.gd#L277) | func start_personal_activity |
| GAME_STATE-0117 | <code>"How's my favorite household genius?"</code> | `scripts/game_state.gd` | [L292](../scripts/game_state.gd#L292) | func judy_response |
| GAME_STATE-0118 | <code>"How's the extremely important robot business?"</code> | `scripts/game_state.gd` | [L292](../scripts/game_state.gd#L292) | func judy_response |
| GAME_STATE-0119 | <code>"How are the chores going, TipTop?"</code> | `scripts/game_state.gd` | [L292](../scripts/game_state.gd#L292) | func judy_response |
| GAME_STATE-0120 | <code>"Give me the short version, buddy."</code> | `scripts/game_state.gd` | [L292](../scripts/game_state.gd#L292) | func judy_response |
| GAME_STATE-0121 | <code>"TipTop, please. I need a quiet minute."</code> | `scripts/game_state.gd` | [L292](../scripts/game_state.gd#L292) | func judy_response |
| GAME_STATE-0122 | <code>"I'm listening. Just a little slowly today."</code> | `scripts/game_state.gd` | [L292](../scripts/game_state.gd#L292) | func judy_response |
| GAME_STATE-0124 | <code>"Actual water. Bold interpretation, buddy."</code> | `scripts/game_state.gd` | [L293](../scripts/game_state.gd#L293) | func judy_response |
| GAME_STATE-0125 | <code>"Well, the floor certainly looks hydrated."</code> | `scripts/game_state.gd` | [L293](../scripts/game_state.gd#L293) | func judy_response |
| GAME_STATE-0126 | <code>"That's actual water, TipTop. I'll handle it."</code> | `scripts/game_state.gd` | [L293](../scripts/game_state.gd#L293) | func judy_response |
| GAME_STATE-0127 | <code>"The routine needs a correction. I'll sort it."</code> | `scripts/game_state.gd` | [L293](../scripts/game_state.gd#L293) | func judy_response |
| GAME_STATE-0128 | <code>"That's water, TipTop. Please stop the tap."</code> | `scripts/game_state.gd` | [L293](../scripts/game_state.gd#L293) | func judy_response |
| GAME_STATE-0129 | <code>"Right. The tap again. Give me a minute."</code> | `scripts/game_state.gd` | [L293](../scripts/game_state.gd#L293) | func judy_response |
| GAME_STATE-0131 | <code>"Four hours? Science really needs a snooze button."</code> | `scripts/game_state.gd` | [L294](../scripts/game_state.gd#L294) | func judy_response |
| GAME_STATE-0132 | <code>"Okay, you've caught me. I'll take a breather."</code> | `scripts/game_state.gd` | [L294](../scripts/game_state.gd#L294) | func judy_response |
| GAME_STATE-0133 | <code>"You're right. I should take a break."</code> | `scripts/game_state.gd` | [L294](../scripts/game_state.gd#L294) | func judy_response |
| GAME_STATE-0134 | <code>"Let me step away from the notes for a bit."</code> | `scripts/game_state.gd` | [L294](../scripts/game_state.gd#L294) | func judy_response |
| GAME_STATE-0135 | <code>"Yeah. I'm running on fumes here."</code> | `scripts/game_state.gd` | [L294](../scripts/game_state.gd#L294) | func judy_response |
| GAME_STATE-0136 | <code>"I know, buddy. I really need a minute."</code> | `scripts/game_state.gd` | [L294](../scripts/game_state.gd#L294) | func judy_response |
| GAME_STATE-0137 | <code>"%s:%d"</code> | `scripts/game_state.gd` | [L296](../scripts/game_state.gd#L296) | func judy_response Formatting arguments: % [context, tier] |
| GAME_STATE-0142 | <code>"Meal finished: +40 Fullness, +10 Mood. Work streak reset."</code> | `scripts/game_state.gd` | [L346](../scripts/game_state.gd#L346) | func advance_personal_activity |
| GAME_STATE-0143 | <code>"eat"</code> | `scripts/game_state.gd` | [L346](../scripts/game_state.gd#L346) | func advance_personal_activity |
| GAME_STATE-0144 | <code>"Break finished. Feeling more like myself."</code> | `scripts/game_state.gd` | [L346](../scripts/game_state.gd#L346) | func advance_personal_activity |
| GAME_STATE-0147 | <code>"Floor"</code> | `scripts/game_state.gd` | [L358](../scripts/game_state.gd#L358) | func skip_personal_activity |
| GAME_STATE-0148 | <code>"Judy is pushing through exhaustion: an extra 20% research penalty."</code> | `scripts/game_state.gd` | [L383](../scripts/game_state.gd#L383) | func begin_research |
| GAME_STATE-0165 | <code>"TipTop"</code> | `scripts/game_state.gd` | [L488](../scripts/game_state.gd#L488) | func _simulate_world_step |
| GAME_STATE-0168 | <code>"break_reminder_%d_%d"</code> | `scripts/game_state.gd` | [L523](../scripts/game_state.gd#L523) | func complete_research Formatting arguments: % [day, break_reminder_count]) |
| GAME_STATE-0172 | <code>"Research complete: +%.1f%%, %d min, %d session(s) left."</code> | `scripts/game_state.gd` | [L529](../scripts/game_state.gd#L529) | func complete_research Formatting arguments: % [research_gain, research_duration, work_sessions_remaining]) |
| GAME_STATE-0173 | <code>"ambient_%d"</code> | `scripts/game_state.gd` | [L532](../scripts/game_state.gd#L532) | func complete_research Formatting arguments: % day) |
| GAME_STATE-0175 | <code>"Player"</code> | `scripts/game_state.gd` | [L543](../scripts/game_state.gd#L543) | func swat_mosquitoes |
| GAME_STATE-0176 | <code>"Mosquitoes reduced. Remove standing water to keep them away."</code> | `scripts/game_state.gd` | [L549](../scripts/game_state.gd#L549) | func swat_mosquitoes |
| GAME_STATE-0180 | <code>"Too exhausted to work. Rest until tomorrow."</code> | `scripts/game_state.gd` | [L576](../scripts/game_state.gd#L576) | func research_block_reason |
| GAME_STATE-0181 | <code>"Judy is too hungry to work. Eat something first."</code> | `scripts/game_state.gd` | [L578](../scripts/game_state.gd#L578) | func research_block_reason |
| GAME_STATE-0182 | <code>"Judy needs a break. Restore Mood to at least 45% before researching."</code> | `scripts/game_state.gd` | [L580](../scripts/game_state.gd#L580) | func research_block_reason |
| GAME_STATE-0183 | <code>"Not enough time before 8:00 PM. A full research session needs %d minutes; no session used."</code> | `scripts/game_state.gd` | [L582](../scripts/game_state.gd#L582) | func research_block_reason Formatting arguments: % research_session_minutes() |
| GAME_STATE-0184 | <code>"Research materials are misplaced. Organize the bookshelf (20 min)."</code> | `scripts/game_state.gd` | [L583](../scripts/game_state.gd#L583) | func research_block_reason |
| GAME_STATE-0188 | <code>"Turn off the tap before mopping."</code> | `scripts/game_state.gd` | [L600](../scripts/game_state.gd#L600) | func manual_clean |
| GAME_STATE-0191 | <code>"Sink"</code> | `scripts/game_state.gd` | [L604](../scripts/game_state.gd#L604) | func manual_clean |
| GAME_STATE-0193 | <code>"PlantPot"</code> | `scripts/game_state.gd` | [L604](../scripts/game_state.gd#L604) | func manual_clean |
| GAME_STATE-0195 | <code>"Bookshelf"</code> | `scripts/game_state.gd` | [L604](../scripts/game_state.gd#L604) | func manual_clean |
| GAME_STATE-0197 | <code>"Bed"</code> | `scripts/game_state.gd` | [L604](../scripts/game_state.gd#L604) | func manual_clean |
| GAME_STATE-0204 | <code>"%s tidied. Routine unchanged. (-%d min)"</code> | `scripts/game_state.gd` | [L607](../scripts/game_state.gd#L607) | func manual_clean Formatting arguments: % [chore.capitalize(), CLEAN_COSTS[chore]]) |
| GAME_STATE-0216 | <code>"day_%d"</code> | `scripts/game_state.gd` | [L689](../scripts/game_state.gd#L689) | func continue_day Formatting arguments: % day) |
| GAME_STATE-0218 | <code>"Make the bed first (E, 5 min), or let the repaired bed routine handle it."</code> | `scripts/game_state.gd` | [L696](../scripts/game_state.gd#L696) | func end_day |
| GAME_STATE-0219 | <code>"TipTop still has faulty routines. Repair before resting?"</code> | `scripts/game_state.gd` | [L702](../scripts/game_state.gd#L702) | func end_day |
| GAME_STATE-0221 | <code>"TipTop left the tap running!"</code> | `scripts/game_state.gd` | [L725](../scripts/game_state.gd#L725) | func _check_malfunction |
| GAME_STATE-0222 | <code>"TipTop left the tap running... again!"</code> | `scripts/game_state.gd` | [L725](../scripts/game_state.gd#L725) | func _check_malfunction |
| GAME_STATE-0224 | <code>"A full repair needs %d minutes before 8:00 PM. No time or reward charged."</code> | `scripts/game_state.gd` | [L742](../scripts/game_state.gd#L742) | func repair_routine Formatting arguments: % duration) |
| GAME_STATE-0229 | <code>"%s routine repaired: +%.0f%% research. (-%d min)"</code> | `scripts/game_state.gd` | [L760](../scripts/game_state.gd#L760) | func repair_routine Formatting arguments: % [chore.capitalize(), reward, duration]) |
| GAME_STATE-0232 | <code>"TipTop: %s routine updated. Thank you, Judy!"</code> | `scripts/game_state.gd` | [L766](../scripts/game_state.gd#L766) | func repair_routine Formatting arguments: % chore.capitalize()) |
| GAME_STATE-0237 | <code>"ignored_%d"</code> | `scripts/game_state.gd` | [L792](../scripts/game_state.gd#L792) | func ignore_tap Formatting arguments: % day) |
| GAME_STATE-0253 | <code>"%02d:%02d"</code> | `scripts/game_state.gd` | [L864](../scripts/game_state.gd#L864) | func get_time_string Formatting arguments: % [hours, mins] |

## scripts/hud.gd

| ID | Current text / source literal | File path | Location | Context / template variables |
|---|---|---|---|---|
| HUD-0012 | <code>"Too exhausted to work. Rest until tomorrow."</code> | `scripts/hud.gd` | [L139](../scripts/hud.gd#L139) | func research_choices |
| HUD-0019 | <code>"I was checking the %s. It appreciates the attention."</code> | `scripts/hud.gd` | [L169](../scripts/hud.gd#L169) | func talk_to_tiptop Formatting arguments: % ("bookshelf" if chore == "bookshelf" else chore) |
| HUD-0022 | <code>"A brief pause between helpful activities. Very strategic."</code> | `scripts/hud.gd` | [L171](../scripts/hud.gd#L171) | func talk_to_tiptop |
| HUD-0023 | <code>"Judy"</code> | `scripts/hud.gd` | [L173](../scripts/hud.gd#L173) | func talk_to_tiptop |
| HUD-0024 | <code>"How's the extremely important robot business?"</code> | `scripts/hud.gd` | [L173](../scripts/hud.gd#L173) | func talk_to_tiptop |
| HUD-0026 | <code>"TipTop"</code> | `scripts/hud.gd` | [L173](../scripts/hud.gd#L173) | func talk_to_tiptop |
| HUD-0028 | <code>"Judy"</code> | `scripts/hud.gd` | [L173](../scripts/hud.gd#L173) | func talk_to_tiptop |
| HUD-0029 | <code>"Carry on, chief."</code> | `scripts/hud.gd` | [L173](../scripts/hud.gd#L173) | func talk_to_tiptop |
| HUD-0031 | <code>"TipTop"</code> | `scripts/hud.gd` | [L174](../scripts/hud.gd#L174) | func talk_to_tiptop |
| HUD-0032 | <code>"Research update requested!"</code> | `scripts/hud.gd` | [L174](../scripts/hud.gd#L174) | func talk_to_tiptop |
| HUD-0034 | <code>"Judy"</code> | `scripts/hud.gd` | [L174](../scripts/hud.gd#L174) | func talk_to_tiptop |
| HUD-0035 | <code>"Mostly notes. Some of them even agree with each other."</code> | `scripts/hud.gd` | [L174](../scripts/hud.gd#L174) | func talk_to_tiptop |
| HUD-0037 | <code>"TipTop"</code> | `scripts/hud.gd` | [L174](../scripts/hud.gd#L174) | func talk_to_tiptop |
| HUD-0038 | <code>"An encouraging level of cooperation."</code> | `scripts/hud.gd` | [L174](../scripts/hud.gd#L174) | func talk_to_tiptop |
| HUD-0040 | <code>"Judy"</code> | `scripts/hud.gd` | [L175](../scripts/hud.gd#L175) | func talk_to_tiptop |
| HUD-0041 | <code>"You doing okay, buddy?"</code> | `scripts/hud.gd` | [L175](../scripts/hud.gd#L175) | func talk_to_tiptop |
| HUD-0043 | <code>"TipTop"</code> | `scripts/hud.gd` | [L175](../scripts/hud.gd#L175) | func talk_to_tiptop |
| HUD-0044 | <code>"Yes! I am practically unstoppable. Except by furniture."</code> | `scripts/hud.gd` | [L175](../scripts/hud.gd#L175) | func talk_to_tiptop |
| HUD-0046 | <code>"Judy"</code> | `scripts/hud.gd` | [L175](../scripts/hud.gd#L175) | func talk_to_tiptop |
| HUD-0047 | <code>"Yeah, furniture gets everyone eventually."</code> | `scripts/hud.gd` | [L175](../scripts/hud.gd#L175) | func talk_to_tiptop |
| HUD-0049 | <code>"TipTop"</code> | `scripts/hud.gd` | [L176](../scripts/hud.gd#L176) | func talk_to_tiptop |
| HUD-0050 | <code>"Are we ready for the showcase?"</code> | `scripts/hud.gd` | [L176](../scripts/hud.gd#L176) | func talk_to_tiptop |
| HUD-0052 | <code>"Judy"</code> | `scripts/hud.gd` | [L176](../scripts/hud.gd#L176) | func talk_to_tiptop |
| HUD-0053 | <code>"We've got results. Now I just have to explain them."</code> | `scripts/hud.gd` | [L176](../scripts/hud.gd#L176) | func talk_to_tiptop |
| HUD-0054 | <code>"Getting there. My notes are starting to look suspiciously useful."</code> | `scripts/hud.gd` | [L176](../scripts/hud.gd#L176) | func talk_to_tiptop |
| HUD-0056 | <code>"TipTop"</code> | `scripts/hud.gd` | [L176](../scripts/hud.gd#L176) | func talk_to_tiptop |
| HUD-0057 | <code>"I shall provide supportive hovering."</code> | `scripts/hud.gd` | [L176](../scripts/hud.gd#L176) | func talk_to_tiptop |
| HUD-0067 | <code>"Research"</code> | `scripts/hud.gd` | [L240](../scripts/hud.gd#L240) | func household_choices |
| HUD-0068 | <code>"Sessions: %d used · %d/%d left"</code> | `scripts/hud.gd` | [L241](../scripts/hud.gd#L241) | func household_choices Formatting arguments: % [GameState.DAILY_WORK_SESSIONS - GameState.work_sessions_remaining, GameState.work_sessions_remaining, GameState.DAILY_WORK_SESSIONS], Vector2.ZERO, 8) |
| HUD-0069 | <code>"Efficiency: %d%% &#124; Reward: +%.1f%% research%s"</code> | `scripts/hud.gd` | [L243](../scripts/hud.gd#L243) | func household_choices Formatting arguments: % [efficiency, GameState.preview_research_gain(), " (pushing through)" if GameState.pushing_through() else ""], Vector2.ZERO, 7) |
| HUD-0070 | <code>" (pushing through)"</code> | `scripts/hud.gd` | [L243](../scripts/hud.gd#L243) | func household_choices |
| HUD-0072 | <code>"%s · %d game min · Watch ~%.1f real min"</code> | `scripts/hud.gd` | [L246](../scripts/hud.gd#L246) | func household_choices Formatting arguments: % [GameState.profile()["name"], duration, watch_minutes], Vector2.ZERO, 7) |
| HUD-0073 | <code>"name"</code> | `scripts/hud.gd` | [L246](../scripts/hud.gd#L246) | func household_choices |
| HUD-0074 | <code>"Ready to research"</code> | `scripts/hud.gd` | [L247](../scripts/hud.gd#L247) | func household_choices |
| HUD-0075 | <code>"Research unavailable"</code> | `scripts/hud.gd` | [L247](../scripts/hud.gd#L247) | func household_choices |
| HUD-0076 | <code>"Watch Research"</code> | `scripts/hud.gd` | [L248](../scripts/hud.gd#L248) | func household_choices |
| HUD-0077 | <code>"Fast-forward · 6x"</code> | `scripts/hud.gd` | [L249](../scripts/hud.gd#L249) | func household_choices |
| HUD-0079 | <code>"Take a break"</code> | `scripts/hud.gd` | [L251](../scripts/hud.gd#L251) | func household_choices |
| HUD-0080 | <code>"Watch reels — 15 min, +18 Mood"</code> | `scripts/hud.gd` | [L252](../scripts/hud.gd#L252) | func household_choices |
| HUD-0082 | <code>"Play phone games — 30 min, +30 Mood"</code> | `scripts/hud.gd` | [L253](../scripts/hud.gd#L253) | func household_choices |
| HUD-0084 | <code>"Solve Rubik's cube — 20 min, +25 Mood"</code> | `scripts/hud.gd` | [L254](../scripts/hud.gd#L254) | func household_choices |
| HUD-0087 | <code>"Eat at the coffee table — 30 min, +40 Fullness, +10 Mood"</code> | `scripts/hud.gd` | [L256](../scripts/hud.gd#L256) | func household_choices |
| HUD-0090 | <code>"Organize books myself — 20 min"</code> | `scripts/hud.gd` | [L258](../scripts/hud.gd#L258) | func household_choices |
| HUD-0092 | <code>"Talk to TipTop"</code> | `scripts/hud.gd` | [L260](../scripts/hud.gd#L260) | func household_choices |
| HUD-0093 | <code>"Repair TipTop..."</code> | `scripts/hud.gd` | [L262](../scripts/hud.gd#L262) | func household_choices |
| HUD-0094 | <code>"Clean %s myself — %d min"</code> | `scripts/hud.gd` | [L264](../scripts/hud.gd#L264) | func household_choices Formatting arguments: % [location, GameState.CLEAN_COSTS[location]], judy._clean_animation.bind(location)]) |
| HUD-0098 | <code>"Swat mosquitoes myself — 5 min"</code> | `scripts/hud.gd` | [L266](../scripts/hud.gd#L266) | func household_choices |
| HUD-0099 | <code>"Ask TipTop to swat mosquitoes — free"</code> | `scripts/hud.gd` | [L267](../scripts/hud.gd#L267) | func household_choices |
| HUD-0100 | <code>"Cancel"</code> | `scripts/hud.gd` | [L268](../scripts/hud.gd#L268) | func household_choices |
| HUD-0102 | <code>"TipTop: No airborne intruders detected."</code> | `scripts/hud.gd` | [L290](../scripts/hud.gd#L290) | func _request_swatter |
| HUD-0103 | <code>"TipTop: Mosquito removal requested. On my way!"</code> | `scripts/hud.gd` | [L293](../scripts/hud.gd#L293) | func _request_swatter |
| HUD-0111 | <code>"Continuing..."</code> | `scripts/hud.gd` | [L333](../scripts/hud.gd#L333) | func _ready |
| HUD-0120 | <code>"%d:%02d %s"</code> | `scripts/hud.gd` | [L408](../scripts/hud.gd#L408) | func _update_clock_hud Formatting arguments: % [posmod(hour - 1, 12) + 1, whole_minutes % 60, "AM" if hour &lt; 12 else "PM"] |
| HUD-0121 | <code>"AM"</code> | `scripts/hud.gd` | [L408](../scripts/hud.gd#L408) | func _update_clock_hud |
| HUD-0122 | <code>"PM"</code> | `scripts/hud.gd` | [L408](../scripts/hud.gd#L408) | func _update_clock_hud |
| HUD-0123 | <code>"%dh %02dm left"</code> | `scripts/hud.gd` | [L410](../scripts/hud.gd#L410) | func _update_clock_hud Formatting arguments: % [int(left / 60), left % 60] |
| HUD-0127 | <code>"Showcase in\n%dh %02dm playable"</code> | `scripts/hud.gd` | [L419](../scripts/hud.gd#L419) | func _update_clock_hud Formatting arguments: % [minutes / 60, minutes % 60] |
| HUD-0134 | <code>"Day %d"</code> | `scripts/hud.gd` | [L428](../scripts/hud.gd#L428) | func _update_hud Formatting arguments: % GameState.day |
| HUD-0135 | <code>"Research: %.1f%%"</code> | `scripts/hud.gd` | [L430](../scripts/hud.gd#L430) | func _update_hud Formatting arguments: % GameState.research_progress |
| HUD-0136 | <code>"Work sessions: %d / 4"</code> | `scripts/hud.gd` | [L431](../scripts/hud.gd#L431) | func _update_hud Formatting arguments: % GameState.work_sessions_remaining |
| HUD-0137 | <code>"Monday"</code> | `scripts/hud.gd` | [L432](../scripts/hud.gd#L432) | func _update_hud |
| HUD-0138 | <code>"Tuesday"</code> | `scripts/hud.gd` | [L432](../scripts/hud.gd#L432) | func _update_hud |
| HUD-0139 | <code>"Wednesday"</code> | `scripts/hud.gd` | [L432](../scripts/hud.gd#L432) | func _update_hud |
| HUD-0141 | <code>"Day %d complete — 8:00 PM\nResearch: %.1f%%\nShowcase deadline: Day 3, 8:00 PM"</code> | `scripts/hud.gd` | [L443](../scripts/hud.gd#L443) | func _update_hud Formatting arguments: % [GameState.day, GameState.research_progress] |
| HUD-0142 | <code>"Showcase"</code> | `scripts/hud.gd` | [L444](../scripts/hud.gd#L444) | func _update_hud |
| HUD-0143 | <code>"Next day"</code> | `scripts/hud.gd` | [L444](../scripts/hud.gd#L444) | func _update_hud |
| HUD-0155 | <code>"Faulty routines: repair or ignore?"</code> | `scripts/hud.gd` | [L485](../scripts/hud.gd#L485) | func _show_malfunction |
| HUD-0156 | <code>"Tap running: repair or ignore?"</code> | `scripts/hud.gd` | [L485](../scripts/hud.gd#L485) | func _show_malfunction |
| HUD-0171 | <code>"Fullness"</code> | `scripts/hud.gd` | [L541](../scripts/hud.gd#L541) | func _build_needs_ui |
| HUD-0173 | <code>"Mood"</code> | `scripts/hud.gd` | [L541](../scripts/hud.gd#L541) | func _build_needs_ui |
| HUD-0289 | <code>"Target: %.0f%%"</code> | `scripts/hud.gd` | [L706](../scripts/hud.gd#L706) | func _build_right_sidebar Formatting arguments: % GameState.GOOD_ENDING_RESEARCH_THRESHOLD, Vector2.ZERO, 6) |
| HUD-0297 | <code>"research"</code> | `scripts/hud.gd` | [L726](../scripts/hud.gd#L726) | func _build_right_sidebar |
| HUD-0298 | <code>"Research"</code> | `scripts/hud.gd` | [L726](../scripts/hud.gd#L726) | func _build_right_sidebar |
| HUD-0299 | <code>"repairs"</code> | `scripts/hud.gd` | [L726](../scripts/hud.gd#L726) | func _build_right_sidebar |
| HUD-0300 | <code>"TipTop"</code> | `scripts/hud.gd` | [L726](../scripts/hud.gd#L726) | func _build_right_sidebar |
| HUD-0301 | <code>"time"</code> | `scripts/hud.gd` | [L726](../scripts/hud.gd#L726) | func _build_right_sidebar |
| HUD-0302 | <code>"Time Usage"</code> | `scripts/hud.gd` | [L726](../scripts/hud.gd#L726) | func _build_right_sidebar |
| HUD-0303 | <code>"needs"</code> | `scripts/hud.gd` | [L726](../scripts/hud.gd#L726) | func _build_right_sidebar |
| HUD-0304 | <code>"Needs"</code> | `scripts/hud.gd` | [L726](../scripts/hud.gd#L726) | func _build_right_sidebar |
| HUD-0324 | <code>"Research"</code> | `scripts/hud.gd` | [L764](../scripts/hud.gd#L764) | func _build_right_sidebar |
| HUD-0326 | <code>"TipTop"</code> | `scripts/hud.gd` | [L764](../scripts/hud.gd#L764) | func _build_right_sidebar |
| HUD-0328 | <code>"Time Usage"</code> | `scripts/hud.gd` | [L764](../scripts/hud.gd#L764) | func _build_right_sidebar |
| HUD-0330 | <code>"Needs"</code> | `scripts/hud.gd` | [L764](../scripts/hud.gd#L764) | func _build_right_sidebar |
| HUD-0336 | <code>"Efficiency"</code> | `scripts/hud.gd` | [L768](../scripts/hud.gd#L768) | func _build_right_sidebar |
| HUD-0347 | <code>"Sink"</code> | `scripts/hud.gd` | [L774](../scripts/hud.gd#L774) | func _build_right_sidebar |
| HUD-0348 | <code>"Plant"</code> | `scripts/hud.gd` | [L774](../scripts/hud.gd#L774) | func _build_right_sidebar |
| HUD-0349 | <code>"Bookshelf"</code> | `scripts/hud.gd` | [L774](../scripts/hud.gd#L774) | func _build_right_sidebar |
| HUD-0350 | <code>"Bed"</code> | `scripts/hud.gd` | [L774](../scripts/hud.gd#L774) | func _build_right_sidebar |
| HUD-0357 | <code>"Research"</code> | `scripts/hud.gd` | [L794](../scripts/hud.gd#L794) | func _build_right_sidebar |
| HUD-0358 | <code>"Eating"</code> | `scripts/hud.gd` | [L794](../scripts/hud.gd#L794) | func _build_right_sidebar |
| HUD-0359 | <code>"Leisure"</code> | `scripts/hud.gd` | [L794](../scripts/hud.gd#L794) | func _build_right_sidebar |
| HUD-0360 | <code>"Repairs"</code> | `scripts/hud.gd` | [L794](../scripts/hud.gd#L794) | func _build_right_sidebar |
| HUD-0361 | <code>"Cleanup"</code> | `scripts/hud.gd` | [L794](../scripts/hud.gd#L794) | func _build_right_sidebar |
| HUD-0362 | <code>"Misc"</code> | `scripts/hud.gd` | [L794](../scripts/hud.gd#L794) | func _build_right_sidebar |
| HUD-0373 | <code>"Fullness"</code> | `scripts/hud.gd` | [L808](../scripts/hud.gd#L808) | func _build_right_sidebar |
| HUD-0377 | <code>"Mood"</code> | `scripts/hud.gd` | [L809](../scripts/hud.gd#L809) | func _build_right_sidebar |
| HUD-0380 | <code>"Meal: 30 min, +40 food, +10 Mood. Counts as a break."</code> | `scripts/hud.gd` | [L811](../scripts/hud.gd#L811) | func _build_right_sidebar |
| HUD-0387 | <code>"[color=#9dceac]✓ [s]%s[/s][/color]"</code> | `scripts/hud.gd` | [L826](../scripts/hud.gd#L826) | func _update_sidebar Formatting arguments: % text if fixed else "□ " + text |
| HUD-0389 | <code>"TipTop: %d/4 fixed"</code> | `scripts/hud.gd` | [L830](../scripts/hud.gd#L830) | func _update_sidebar Formatting arguments: % fixed_count |
| HUD-0390 | <code>"%d / 4 repaired"</code> | `scripts/hud.gd` | [L831](../scripts/hud.gd#L831) | func _update_sidebar Formatting arguments: % fixed_count |
| HUD-0391 | <code>"Research underway"</code> | `scripts/hud.gd` | [L833](../scripts/hud.gd#L833) | func _update_sidebar |
| HUD-0392 | <code>"Research blocked"</code> | `scripts/hud.gd` | [L833](../scripts/hud.gd#L833) | func _update_sidebar |
| HUD-0393 | <code>"Ready to research"</code> | `scripts/hud.gd` | [L833](../scripts/hud.gd#L833) | func _update_sidebar |
| HUD-0395 | <code>"Fullness must exceed 20"</code> | `scripts/hud.gd` | [L835](../scripts/hud.gd#L835) | func _update_sidebar |
| HUD-0396 | <code>"Food: -%d%% yield"</code> | `scripts/hud.gd` | [L835](../scripts/hud.gd#L835) | func _update_sidebar Formatting arguments: % food_loss if food_loss &gt; 0 else "")) |
| HUD-0399 | <code>"Tap: half reward"</code> | `scripts/hud.gd` | [L836](../scripts/hud.gd#L836) | func _update_sidebar |
| HUD-0402 | <code>"Books scattered"</code> | `scripts/hud.gd` | [L837](../scripts/hud.gd#L837) | func _update_sidebar |
| HUD-0406 | <code>"Mood below 45"</code> | `scripts/hud.gd` | [L838](../scripts/hud.gd#L838) | func _update_sidebar |
| HUD-0409 | <code>"Push-through: -20%"</code> | `scripts/hud.gd` | [L839](../scripts/hud.gd#L839) | func _update_sidebar |
| HUD-0411 | <code>"Your desk is ready."</code> | `scripts/hud.gd` | [L840](../scripts/hud.gd#L840) | func _update_sidebar |
| HUD-0412 | <code>"Rest for more sessions."</code> | `scripts/hud.gd` | [L842](../scripts/hud.gd#L842) | func _update_sidebar |
| HUD-0413 | <code>"Eat before researching."</code> | `scripts/hud.gd` | [L844](../scripts/hud.gd#L844) | func _update_sidebar |
| HUD-0415 | <code>"Clear the bookshelf."</code> | `scripts/hud.gd` | [L846](../scripts/hud.gd#L846) | func _update_sidebar |
| HUD-0416 | <code>"Take a coffee-table break."</code> | `scripts/hud.gd` | [L848](../scripts/hud.gd#L848) | func _update_sidebar |
| HUD-0417 | <code>"A full session won't fit today."</code> | `scripts/hud.gd` | [L850](../scripts/hud.gd#L850) | func _update_sidebar |
| HUD-0418 | <code>"Eat before your next session."</code> | `scripts/hud.gd` | [L852](../scripts/hud.gd#L852) | func _update_sidebar |
| HUD-0419 | <code>"Turn off the tap."</code> | `scripts/hud.gd` | [L854](../scripts/hud.gd#L854) | func _update_sidebar |
| HUD-0421 | <code>"! Too hungry to work"</code> | `scripts/hud.gd` | [L858](../scripts/hud.gd#L858) | func _update_sidebar |
| HUD-0423 | <code>"! Books block research"</code> | `scripts/hud.gd` | [L860](../scripts/hud.gd#L860) | func _update_sidebar |
| HUD-0424 | <code>"! Mood blocks research"</code> | `scripts/hud.gd` | [L862](../scripts/hud.gd#L862) | func _update_sidebar |
| HUD-0425 | <code>"! Eat soon"</code> | `scripts/hud.gd` | [L864](../scripts/hud.gd#L864) | func _update_sidebar |
| HUD-0426 | <code>"! Not enough work time"</code> | `scripts/hud.gd` | [L866](../scripts/hud.gd#L866) | func _update_sidebar |
| HUD-0427 | <code>"Total: "</code> | `scripts/hud.gd` | [L879](../scripts/hud.gd#L879) | func _update_sidebar |
| HUD-0428 | <code>"%dh %02dm"</code> | `scripts/hud.gd` | [L884](../scripts/hud.gd#L884) | func _minutes_text Formatting arguments: % [whole / 60, whole % 60] |
| HUD-0429 | <code>"Full: %d%%"</code> | `scripts/hud.gd` | [L888](../scripts/hud.gd#L888) | func _update_needs_ui Formatting arguments: % int(GameState.hunger) |
| HUD-0430 | <code>"Mood: %d%%"</code> | `scripts/hud.gd` | [L889](../scripts/hud.gd#L889) | func _update_needs_ui Formatting arguments: % int(GameState.mood) |
| HUD-0440 | <code>"Push through (-20%)"</code> | `scripts/hud.gd` | [L895](../scripts/hud.gd#L895) | func _update_needs_ui |
| HUD-0441 | <code>"Rest needed (&lt;45)"</code> | `scripts/hud.gd` | [L895](../scripts/hud.gd#L895) | func _update_needs_ui |
| HUD-0442 | <code>"Ready for research"</code> | `scripts/hud.gd` | [L895](../scripts/hud.gd#L895) | func _update_needs_ui |
| HUD-0443 | <code>"%d%%"</code> | `scripts/hud.gd` | [L896](../scripts/hud.gd#L896) | func _update_needs_ui Formatting arguments: % int(round(GameState.research_efficiency() * 100)) |
| HUD-0444 | <code>"! Critical fullness"</code> | `scripts/hud.gd` | [L897](../scripts/hud.gd#L897) | func _update_needs_ui |
| HUD-0445 | <code>"! Critical"</code> | `scripts/hud.gd` | [L900](../scripts/hud.gd#L900) | func _update_needs_ui |
| HUD-0446 | <code>" (-%d%%)"</code> | `scripts/hud.gd` | [L900](../scripts/hud.gd#L900) | func _update_needs_ui Formatting arguments: % food_penalty |
| HUD-0449 | <code>"food"</code> | `scripts/hud.gd` | [L902](../scripts/hud.gd#L902) | func _update_needs_ui |
| HUD-0450 | <code>"%d%%"</code> | `scripts/hud.gd` | [L902](../scripts/hud.gd#L902) | func _update_needs_ui Formatting arguments: % int(GameState.hunger) |
| HUD-0451 | <code>"mood"</code> | `scripts/hud.gd` | [L903](../scripts/hud.gd#L903) | func _update_needs_ui |
| HUD-0452 | <code>"%d%%"</code> | `scripts/hud.gd` | [L903](../scripts/hud.gd#L903) | func _update_needs_ui Formatting arguments: % int(GameState.mood) |
| HUD-0453 | <code>" / Low Mood"</code> | `scripts/hud.gd` | [L904](../scripts/hud.gd#L904) | func _update_needs_ui |
| HUD-0454 | <code>" / Mood steady"</code> | `scripts/hud.gd` | [L904](../scripts/hud.gd#L904) | func _update_needs_ui |
| HUD-0456 | <code>"Too hungry to start research. Eat: +40 food, +10 Mood."</code> | `scripts/hud.gd` | [L906](../scripts/hud.gd#L906) | func _update_needs_ui |
| HUD-0457 | <code>"Food: -%d%% yield. Meals: +40 food, +10 Mood."</code> | `scripts/hud.gd` | [L906](../scripts/hud.gd#L906) | func _update_needs_ui Formatting arguments: % loss if loss &gt; 0 else "")) |
| HUD-0460 | <code>"Push-through: -20% yield."</code> | `scripts/hud.gd` | [L907](../scripts/hud.gd#L907) | func _update_needs_ui |
| HUD-0461 | <code>"Mood below 45. Take a leisure break."</code> | `scripts/hud.gd` | [L907](../scripts/hud.gd#L907) | func _update_needs_ui |
| HUD-0466 | <code>"Monday"</code> | `scripts/hud.gd` | [L948](../scripts/hud.gd#L948) | func _build_loop_ui |
| HUD-0472 | <code>"E   Interact\nESC Pause"</code> | `scripts/hud.gd` | [L969](../scripts/hud.gd#L969) | func _build_loop_ui |
| HUD-0476 | <code>"Day 3 showcase: reach %.0f%% and repair all routines.\nE to interact. Make the bed before resting.\nFour sessions/day; full sessions must fit before 8:00 PM."</code> | `scripts/hud.gd` | [L983](../scripts/hud.gd#L983) | func _build_loop_ui Formatting arguments: % GameState.GOOD_ENDING_RESEARCH_THRESHOLD |
| HUD-0478 | <code>"Start"</code> | `scripts/hud.gd` | [L989](../scripts/hud.gd#L989) | func _build_loop_ui |
| HUD-0480 | <code>"name"</code> | `scripts/hud.gd` | [L999](../scripts/hud.gd#L999) | func _build_loop_ui |
| HUD-0483 | <code>"%s\nResearch %.0f min / +%.0f%%; repair %d min / +%.0f%%."</code> | `scripts/hud.gd` | [L1020](../scripts/hud.gd#L1020) | func _choose_difficulty Formatting arguments: % [GameState.profile()["description"], GameState.profile()["research_minutes"], GameState.profile()["research"], GameState.repair_minutes(), GameState.profile()["repair_reward"]] |
| HUD-0484 | <code>"description"</code> | `scripts/hud.gd` | [L1020](../scripts/hud.gd#L1020) | func _choose_difficulty |
| HUD-0485 | <code>"research_minutes"</code> | `scripts/hud.gd` | [L1020](../scripts/hud.gd#L1020) | func _choose_difficulty |
| HUD-0486 | <code>"research"</code> | `scripts/hud.gd` | [L1020](../scripts/hud.gd#L1020) | func _choose_difficulty |
| HUD-0487 | <code>"repair_reward"</code> | `scripts/hud.gd` | [L1020](../scripts/hud.gd#L1020) | func _choose_difficulty |
| HUD-0501 | <code>"Showcase"</code> | `scripts/hud.gd` | [L1119](../scripts/hud.gd#L1119) | func _play_day_transition |
| HUD-0502 | <code>"Day %d"</code> | `scripts/hud.gd` | [L1119](../scripts/hud.gd#L1119) | func _play_day_transition Formatting arguments: % GameState.day |
| HUD-0506 | <code>"New Game"</code> | `scripts/hud.gd` | [L1147](../scripts/hud.gd#L1147) | func _reveal_new_game |
| HUD-0509 | <code>"TipTop's routines - repair independently"</code> | `scripts/hud.gd` | [L1175](../scripts/hud.gd#L1175) | func _build_repair_menu |
| HUD-0514 | <code>"Cancel"</code> | `scripts/hud.gd` | [L1189](../scripts/hud.gd#L1189) | func _build_repair_menu |
| HUD-0516 | <code>"Repairs..."</code> | `scripts/hud.gd` | [L1194](../scripts/hud.gd#L1194) | func _build_repair_menu |
| HUD-0520 | <code>"%s — %s (%d min, +%.0f%%)"</code> | `scripts/hud.gd` | [L1208](../scripts/hud.gd#L1208) | func _open_repair_menu Formatting arguments: % ["Water / sink" if chore == "sink" else chore.capitalize(), "Repaired" if fixed else ("Faulty" if enough_time else "Not enough time"), duration, float(GameState.profile()["repair_reward"])] |
| HUD-0521 | <code>"Water / sink"</code> | `scripts/hud.gd` | [L1208](../scripts/hud.gd#L1208) | func _open_repair_menu |
| HUD-0522 | <code>"sink"</code> | `scripts/hud.gd` | [L1208](../scripts/hud.gd#L1208) | func _open_repair_menu |
| HUD-0523 | <code>"Repaired"</code> | `scripts/hud.gd` | [L1208](../scripts/hud.gd#L1208) | func _open_repair_menu |
| HUD-0524 | <code>"Faulty"</code> | `scripts/hud.gd` | [L1208](../scripts/hud.gd#L1208) | func _open_repair_menu |
| HUD-0525 | <code>"Not enough time"</code> | `scripts/hud.gd` | [L1208](../scripts/hud.gd#L1208) | func _open_repair_menu |
| HUD-0526 | <code>"repair_reward"</code> | `scripts/hud.gd` | [L1208](../scripts/hud.gd#L1208) | func _open_repair_menu |
| HUD-0527 | <code>"System"</code> | `scripts/hud.gd` | [L1226](../scripts/hud.gd#L1226) | func _show_feedback |
| HUD-0528 | <code>"Judy"</code> | `scripts/hud.gd` | [L1227](../scripts/hud.gd#L1227) | func _show_feedback |
| HUD-0529 | <code>"TipTop"</code> | `scripts/hud.gd` | [L1227](../scripts/hud.gd#L1227) | func _show_feedback |
| HUD-0533 | <code>"System"</code> | `scripts/hud.gd` | [L1232](../scripts/hud.gd#L1232) | func _show_feedback |
| HUD-0534 | <code>"TipTop"</code> | `scripts/hud.gd` | [L1240](../scripts/hud.gd#L1240) | func _show_feedback |
| HUD-0537 | <code>"Judy"</code> | `scripts/hud.gd` | [L1251](../scripts/hud.gd#L1251) | func _show_feedback |
| HUD-0538 | <code>"Mosquito"</code> | `scripts/hud.gd` | [L1251](../scripts/hud.gd#L1251) | func _show_feedback |
| HUD-0551 | <code>"Watch 1x"</code> | `scripts/hud.gd` | [L1333](../scripts/hud.gd#L1333) | func _build_research_controls |
| HUD-0552 | <code>"Fast 6x"</code> | `scripts/hud.gd` | [L1333](../scripts/hud.gd#L1333) | func _build_research_controls |
| HUD-0553 | <code>"Skip"</code> | `scripts/hud.gd` | [L1333](../scripts/hud.gd#L1333) | func _build_research_controls |
| HUD-0554 | <code>"Eject..."</code> | `scripts/hud.gd` | [L1333](../scripts/hud.gd#L1333) | func _build_research_controls |
| HUD-0556 | <code>"Watch 1x"</code> | `scripts/hud.gd` | [L1343](../scripts/hud.gd#L1343) | func _build_research_controls |
| HUD-0557 | <code>"Play at normal speed."</code> | `scripts/hud.gd` | [L1343](../scripts/hud.gd#L1343) | func _build_research_controls |
| HUD-0558 | <code>"Fast 6x"</code> | `scripts/hud.gd` | [L1343](../scripts/hud.gd#L1343) | func _build_research_controls |
| HUD-0559 | <code>"Play at 6x speed."</code> | `scripts/hud.gd` | [L1343](../scripts/hud.gd#L1343) | func _build_research_controls |
| HUD-0560 | <code>"Skip"</code> | `scripts/hud.gd` | [L1343](../scripts/hud.gd#L1343) | func _build_research_controls |
| HUD-0561 | <code>"Finish now. Full time cost applies."</code> | `scripts/hud.gd` | [L1343](../scripts/hud.gd#L1343) | func _build_research_controls |
| HUD-0562 | <code>"Eject..."</code> | `scripts/hud.gd` | [L1343](../scripts/hud.gd#L1343) | func _build_research_controls |
| HUD-0563 | <code>"Cancel without a completion reward."</code> | `scripts/hud.gd` | [L1343](../scripts/hud.gd#L1343) | func _build_research_controls |
| HUD-0565 | <code>"Watch 1x"</code> | `scripts/hud.gd` | [L1346](../scripts/hud.gd#L1346) | func _build_research_controls |
| HUD-0566 | <code>"Fast 6x"</code> | `scripts/hud.gd` | [L1349](../scripts/hud.gd#L1349) | func _build_research_controls |
| HUD-0567 | <code>"Eject..."</code> | `scripts/hud.gd` | [L1352](../scripts/hud.gd#L1352) | func _build_research_controls |
| HUD-0571 | <code>"Cancel without a completion reward."</code> | `scripts/hud.gd` | [L1360](../scripts/hud.gd#L1360) | func _update_activity_controls |
| HUD-0572 | <code>"Unavailable while paused or finishing."</code> | `scripts/hud.gd` | [L1360](../scripts/hud.gd#L1360) | func _update_activity_controls |
| HUD-0574 | <code>"help_text"</code> | `scripts/hud.gd` | [L1366](../scripts/hud.gd#L1366) | func _update_activity_controls |
| HUD-0575 | <code>"Research: %d / %d min · %dx"</code> | `scripts/hud.gd` | [L1378](../scripts/hud.gd#L1378) | func _update_activity_controls Formatting arguments: % [int(GameState.research_elapsed), GameState.research_duration, int(speed)] |
| HUD-0576 | <code>" · Swat!"</code> | `scripts/hud.gd` | [L1380](../scripts/hud.gd#L1380) | func _update_activity_controls |
| HUD-0578 | <code>"Eating"</code> | `scripts/hud.gd` | [L1385](../scripts/hud.gd#L1385) | func _update_activity_controls |
| HUD-0580 | <code>"Reels"</code> | `scripts/hud.gd` | [L1385](../scripts/hud.gd#L1385) | func _update_activity_controls |
| HUD-0582 | <code>"Phone games"</code> | `scripts/hud.gd` | [L1385](../scripts/hud.gd#L1385) | func _update_activity_controls |
| HUD-0584 | <code>"Rubik's cube"</code> | `scripts/hud.gd` | [L1385](../scripts/hud.gd#L1385) | func _update_activity_controls |
| HUD-0585 | <code>"%s: %d / %d min · %dx"</code> | `scripts/hud.gd` | [L1386](../scripts/hud.gd#L1386) | func _update_activity_controls Formatting arguments: % [title, int(duration - GameState.personal_remaining), duration, int(speed)] |
| HUD-0588 | <code>"Eject unfinished task?"</code> | `scripts/hud.gd` | [L1409](../scripts/hud.gd#L1409) | func _build_eject_confirmation |
| HUD-0589 | <code>"Elapsed time stays spent. No completion reward.\nA started research session stays used."</code> | `scripts/hud.gd` | [L1410](../scripts/hud.gd#L1410) | func _build_eject_confirmation |
| HUD-0590 | <code>"Keep working"</code> | `scripts/hud.gd` | [L1413](../scripts/hud.gd#L1413) | func _build_eject_confirmation |
| HUD-0591 | <code>"Eject task"</code> | `scripts/hud.gd` | [L1413](../scripts/hud.gd#L1413) | func _build_eject_confirmation |
| HUD-0593 | <code>"Keep working"</code> | `scripts/hud.gd` | [L1420](../scripts/hud.gd#L1420) | func _build_eject_confirmation |
| HUD-0605 | <code>"shader_type canvas_item; void fragment() { vec4 pixel = texture(TEXTURE, UV); if (UV.x &lt; 0.31) { pixel.a = 0.0; } COLOR = pixel; }"</code> | `scripts/hud.gd` | [L1500](../scripts/hud.gd#L1500) | func _build_dialogue_ui |
| HUD-0616 | <code>"E / Enter - Next"</code> | `scripts/hud.gd` | [L1543](../scripts/hud.gd#L1543) | func _build_dialogue_ui |
| HUD-0640 | <code>"Paused"</code> | `scripts/hud.gd` | [L1580](../scripts/hud.gd#L1580) | func _build_pause_menu |
| HUD-0641 | <code>"Resume"</code> | `scripts/hud.gd` | [L1581](../scripts/hud.gd#L1581) | func _build_pause_menu |
| HUD-0642 | <code>"Save Game"</code> | `scripts/hud.gd` | [L1581](../scripts/hud.gd#L1581) | func _build_pause_menu |
| HUD-0643 | <code>"How to Play"</code> | `scripts/hud.gd` | [L1581](../scripts/hud.gd#L1581) | func _build_pause_menu |
| HUD-0644 | <code>"Restart Tutorial"</code> | `scripts/hud.gd` | [L1581](../scripts/hud.gd#L1581) | func _build_pause_menu |
| HUD-0645 | <code>"Restart (replaces save)"</code> | `scripts/hud.gd` | [L1581](../scripts/hud.gd#L1581) | func _build_pause_menu |
| HUD-0646 | <code>"Exit Tutorial"</code> | `scripts/hud.gd` | [L1581](../scripts/hud.gd#L1581) | func _build_pause_menu |
| HUD-0647 | <code>"Return to Main Menu"</code> | `scripts/hud.gd` | [L1581](../scripts/hud.gd#L1581) | func _build_pause_menu |
| HUD-0648 | <code>"Quit Game"</code> | `scripts/hud.gd` | [L1581](../scripts/hud.gd#L1581) | func _build_pause_menu |
| HUD-0693 | <code>"Judy"</code> | `scripts/hud.gd` | [L1772](../scripts/hud.gd#L1772) | func _advance_dialogue |
| HUD-0707 | <code>"\n"</code> | `scripts/hud.gd` | [L1814](../scripts/hud.gd#L1814) | func _dialogue_pages |
| HUD-0718 | <code>"\n"</code> | `scripts/hud.gd` | [L1842](../scripts/hud.gd#L1842) | func _dialogue_line_breaks |
| HUD-0722 | <code>"\n"</code> | `scripts/hud.gd` | [L1852](../scripts/hud.gd#L1852) | func _dialogue_line_breaks |
| HUD-0725 | <code>"\n"</code> | `scripts/hud.gd` | [L1860](../scripts/hud.gd#L1860) | func _dialogue_fits |
| HUD-0751 | <code>"+10% Research — Proactive Fix!"</code> | `scripts/hud.gd` | [L1942](../scripts/hud.gd#L1942) | func _on_story_event |
| HUD-0755 | <code>"Judy"</code> | `scripts/hud.gd` | [L1952](../scripts/hud.gd#L1952) | func _on_story_event |
| HUD-0756 | <code>"Right. Notes, coffee... probably some science in here somewhere."</code> | `scripts/hud.gd` | [L1952](../scripts/hud.gd#L1952) | func _on_story_event |
| HUD-0758 | <code>"Judy"</code> | `scripts/hud.gd` | [L1954](../scripts/hud.gd#L1954) | func _on_story_event |
| HUD-0759 | <code>"Okay, Judy. Three days. Let's make this look like science."</code> | `scripts/hud.gd` | [L1954](../scripts/hud.gd#L1954) | func _on_story_event |
| HUD-0760 | <code>"TipTop"</code> | `scripts/hud.gd` | [L1954](../scripts/hud.gd#L1954) | func _on_story_event |
| HUD-0761 | <code>"I'm TipTop! I handle routines. Usually the right ones."</code> | `scripts/hud.gd` | [L1954](../scripts/hud.gd#L1954) | func _on_story_event |
| HUD-0762 | <code>"Judy"</code> | `scripts/hud.gd` | [L1954](../scripts/hud.gd#L1954) | func _on_story_event |
| HUD-0763 | <code>"Showcase on day three, TipTop. Try to look busy."</code> | `scripts/hud.gd` | [L1954](../scripts/hud.gd#L1954) | func _on_story_event |
| HUD-0765 | <code>"TipTop"</code> | `scripts/hud.gd` | [L1956](../scripts/hud.gd#L1956) | func _on_story_event |
| HUD-0766 | <code>"Ideas Flowing Protocol, step 4: Leave tap open. Complete. Proceeding to next objective."</code> | `scripts/hud.gd` | [L1956](../scripts/hud.gd#L1956) | func _on_story_event |
| HUD-0767 | <code>"Judy"</code> | `scripts/hud.gd` | [L1956](../scripts/hud.gd#L1956) | func _on_story_event |
| HUD-0772 | <code>"TipTop"</code> | `scripts/hud.gd` | [L1958](../scripts/hud.gd#L1958) | func _on_story_event |
| HUD-0773 | <code>"Routine updated: ideas may flow without water. Thank you for teaching me, Judy."</code> | `scripts/hud.gd` | [L1958](../scripts/hud.gd#L1958) | func _on_story_event |
| HUD-0774 | <code>"Judy"</code> | `scripts/hud.gd` | [L1958](../scripts/hud.gd#L1958) | func _on_story_event |
| HUD-0775 | <code>"There we go. Knew you had it in you."</code> | `scripts/hud.gd` | [L1958](../scripts/hud.gd#L1958) | func _on_story_event |
| HUD-0777 | <code>"TipTop"</code> | `scripts/hud.gd` | [L1960](../scripts/hud.gd#L1960) | func _on_story_event |
| HUD-0778 | <code>"I apologize."</code> | `scripts/hud.gd` | [L1960](../scripts/hud.gd#L1960) | func _on_story_event |
| HUD-0779 | <code>"Judy"</code> | `scripts/hud.gd` | [L1960](../scripts/hud.gd#L1960) | func _on_story_event |
| HUD-0780 | <code>"For what?"</code> | `scripts/hud.gd` | [L1960](../scripts/hud.gd#L1960) | func _on_story_event |
| HUD-0781 | <code>"TipTop"</code> | `scripts/hud.gd` | [L1960](../scripts/hud.gd#L1960) | func _on_story_event |
| HUD-0782 | <code>"I have not determined that yet."</code> | `scripts/hud.gd` | [L1960](../scripts/hud.gd#L1960) | func _on_story_event |
| HUD-0784 | <code>"TipTop"</code> | `scripts/hud.gd` | [L1962](../scripts/hud.gd#L1962) | func _on_story_event |
| HUD-0785 | <code>"Thank you, Judy."</code> | `scripts/hud.gd` | [L1962](../scripts/hud.gd#L1962) | func _on_story_event |
| HUD-0786 | <code>"Judy"</code> | `scripts/hud.gd` | [L1962](../scripts/hud.gd#L1962) | func _on_story_event |
| HUD-0787 | <code>"I just moved my chair."</code> | `scripts/hud.gd` | [L1962](../scripts/hud.gd#L1962) | func _on_story_event |
| HUD-0788 | <code>"TipTop"</code> | `scripts/hud.gd` | [L1962](../scripts/hud.gd#L1962) | func _on_story_event |
| HUD-0789 | <code>"Yes. I am checking the connection."</code> | `scripts/hud.gd` | [L1962](../scripts/hud.gd#L1962) | func _on_story_event |
| HUD-0791 | <code>"TipTop"</code> | `scripts/hud.gd` | [L1964](../scripts/hud.gd#L1964) | func _on_story_event |
| HUD-0792 | <code>"That went well. I apologize."</code> | `scripts/hud.gd` | [L1964](../scripts/hud.gd#L1964) | func _on_story_event |
| HUD-0793 | <code>"Judy"</code> | `scripts/hud.gd` | [L1964](../scripts/hud.gd#L1964) | func _on_story_event |
| HUD-0794 | <code>"You can just take the win, buddy."</code> | `scripts/hud.gd` | [L1964](../scripts/hud.gd#L1964) | func _on_story_event |
| HUD-0795 | <code>"TipTop"</code> | `scripts/hud.gd` | [L1964](../scripts/hud.gd#L1964) | func _on_story_event |
| HUD-0796 | <code>"Then the apology may belong to something else."</code> | `scripts/hud.gd` | [L1964](../scripts/hud.gd#L1964) | func _on_story_event |
| HUD-0798 | <code>"Judy"</code> | `scripts/hud.gd` | [L1966](../scripts/hud.gd#L1966) | func _on_story_event |
| HUD-0799 | <code>"Morning. No dripping. I could get used to this."</code> | `scripts/hud.gd` | [L1966](../scripts/hud.gd#L1966) | func _on_story_event |
| HUD-0800 | <code>"TipTop"</code> | `scripts/hud.gd` | [L1966](../scripts/hud.gd#L1966) | func _on_story_event |
| HUD-0801 | <code>"My new routine agrees."</code> | `scripts/hud.gd` | [L1966](../scripts/hud.gd#L1966) | func _on_story_event |
| HUD-0803 | <code>"Judy"</code> | `scripts/hud.gd` | [L1966](../scripts/hud.gd#L1966) | func _on_story_event |
| HUD-0804 | <code>"Morning. Right, your routine. I still haven't fixed that."</code> | `scripts/hud.gd` | [L1966](../scripts/hud.gd#L1966) | func _on_story_event |
| HUD-0805 | <code>"TipTop"</code> | `scripts/hud.gd` | [L1966](../scripts/hud.gd#L1966) | func _on_story_event |
| HUD-0806 | <code>"I've resumed the flowing-ideas procedure."</code> | `scripts/hud.gd` | [L1966](../scripts/hud.gd#L1966) | func _on_story_event |
| HUD-0808 | <code>"TipTop"</code> | `scripts/hud.gd` | [L1968](../scripts/hud.gd#L1968) | func _on_story_event |
| HUD-0809 | <code>"Showcase day! My tap routine is ready to do nothing."</code> | `scripts/hud.gd` | [L1968](../scripts/hud.gd#L1968) | func _on_story_event |
| HUD-0810 | <code>"Judy"</code> | `scripts/hud.gd` | [L1968](../scripts/hud.gd#L1968) | func _on_story_event |
| HUD-0811 | <code>"Nice. Now where'd I put my notes?"</code> | `scripts/hud.gd` | [L1968](../scripts/hud.gd#L1968) | func _on_story_event |
| HUD-0813 | <code>"TipTop"</code> | `scripts/hud.gd` | [L1968](../scripts/hud.gd#L1968) | func _on_story_event |
| HUD-0814 | <code>"Showcase day! Shall I demonstrate the water feature?"</code> | `scripts/hud.gd` | [L1968](../scripts/hud.gd#L1968) | func _on_story_event |
| HUD-0815 | <code>"Judy"</code> | `scripts/hud.gd` | [L1968](../scripts/hud.gd#L1968) | func _on_story_event |
| HUD-0816 | <code>"Let's skip that bit, yeah?"</code> | `scripts/hud.gd` | [L1968](../scripts/hud.gd#L1968) | func _on_story_event |
| HUD-0819 | <code>"Judy"</code> | `scripts/hud.gd` | [L1972](../scripts/hud.gd#L1972) | func _on_story_event |
| HUD-0820 | <code>"TipTop. Please tell me that's supposed to happen."</code> | `scripts/hud.gd` | [L1972](../scripts/hud.gd#L1972) | func _on_story_event |
| HUD-0822 | <code>"TipTop"</code> | `scripts/hud.gd` | [L1972](../scripts/hud.gd#L1972) | func _on_story_event |
| HUD-0823 | <code>"According to my latest calculations... no."</code> | `scripts/hud.gd` | [L1972](../scripts/hud.gd#L1972) | func _on_story_event |
| HUD-0825 | <code>"Judy"</code> | `scripts/hud.gd` | [L1972](../scripts/hud.gd#L1972) | func _on_story_event |
| HUD-0826 | <code>"Great. We'll need another draft."</code> | `scripts/hud.gd` | [L1972](../scripts/hud.gd#L1972) | func _on_story_event |
| HUD-0828 | <code>"TipTop"</code> | `scripts/hud.gd` | [L1972](../scripts/hud.gd#L1972) | func _on_story_event |
| HUD-0829 | <code>"I can help with the next draft."</code> | `scripts/hud.gd` | [L1972](../scripts/hud.gd#L1972) | func _on_story_event |
| HUD-0831 | <code>"Judy"</code> | `scripts/hud.gd` | [L1972](../scripts/hud.gd#L1972) | func _on_story_event |
| HUD-0832 | <code>"I'll take any good news you've got."</code> | `scripts/hud.gd` | [L1972](../scripts/hud.gd#L1972) | func _on_story_event |
| HUD-0834 | <code>"TipTop"</code> | `scripts/hud.gd` | [L1972](../scripts/hud.gd#L1972) | func _on_story_event |
| HUD-0835 | <code>"We are no longer behind schedule."</code> | `scripts/hud.gd` | [L1972](../scripts/hud.gd#L1972) | func _on_story_event |
| HUD-0838 | <code>"Judy"</code> | `scripts/hud.gd` | [L1974](../scripts/hud.gd#L1974) | func _on_story_event |
| HUD-0839 | <code>"Thought we'd run out of time. Couldn't have done this without you, buddy."</code> | `scripts/hud.gd` | [L1974](../scripts/hud.gd#L1974) | func _on_story_event |
| HUD-0841 | <code>"TipTop"</code> | `scripts/hud.gd` | [L1974](../scripts/hud.gd#L1974) | func _on_story_event |
| HUD-0842 | <code>"My calculations were only occasionally incorrect."</code> | `scripts/hud.gd` | [L1974](../scripts/hud.gd#L1974) | func _on_story_event |
| HUD-0844 | <code>"Judy"</code> | `scripts/hud.gd` | [L1974](../scripts/hud.gd#L1974) | func _on_story_event |
| HUD-0845 | <code>"Occasionally?"</code> | `scripts/hud.gd` | [L1974](../scripts/hud.gd#L1974) | func _on_story_event |
| HUD-0847 | <code>"TipTop"</code> | `scripts/hud.gd` | [L1974](../scripts/hud.gd#L1974) | func _on_story_event |
| HUD-0848 | <code>"They're applauding! Celebration routine ready."</code> | `scripts/hud.gd` | [L1974](../scripts/hud.gd#L1974) | func _on_story_event |
| HUD-0850 | <code>"Judy"</code> | `scripts/hud.gd` | [L1974](../scripts/hud.gd#L1974) | func _on_story_event |
| HUD-0851 | <code>"Just bow, buddy. We've earned a dry floor."</code> | `scripts/hud.gd` | [L1974](../scripts/hud.gd#L1974) | func _on_story_event |
| HUD-0853 | <code>"TipTop"</code> | `scripts/hud.gd` | [L1974](../scripts/hud.gd#L1974) | func _on_story_event |
| HUD-0854 | <code>"Bow routine confirmed. No water required."</code> | `scripts/hud.gd` | [L1974](../scripts/hud.gd#L1974) | func _on_story_event |
| HUD-0856 | <code>"Judy"</code> | `scripts/hud.gd` | [L1976](../scripts/hud.gd#L1976) | func _on_story_event |
| HUD-0857 | <code>"It wasn't exactly what I planned. Still, we got up here."</code> | `scripts/hud.gd` | [L1976](../scripts/hud.gd#L1976) | func _on_story_event |
| HUD-0859 | <code>"TipTop"</code> | `scripts/hud.gd` | [L1976](../scripts/hud.gd#L1976) | func _on_story_event |
| HUD-0860 | <code>"So the water feature was a success?"</code> | `scripts/hud.gd` | [L1976](../scripts/hud.gd#L1976) | func _on_story_event |
| HUD-0862 | <code>"Judy"</code> | `scripts/hud.gd` | [L1976](../scripts/hud.gd#L1976) | func _on_story_event |
| HUD-0863 | <code>"That bit wasn't in the demo. Glad you came, though."</code> | `scripts/hud.gd` | [L1976](../scripts/hud.gd#L1976) | func _on_story_event |
| HUD-0865 | <code>"TipTop"</code> | `scripts/hud.gd` | [L1976](../scripts/hud.gd#L1976) | func _on_story_event |
| HUD-0866 | <code>"Would you like to schedule a second attempt?"</code> | `scripts/hud.gd` | [L1976](../scripts/hud.gd#L1976) | func _on_story_event |
| HUD-0868 | <code>"Judy"</code> | `scripts/hud.gd` | [L1976](../scripts/hud.gd#L1976) | func _on_story_event |
| HUD-0869 | <code>"After a very long nap."</code> | `scripts/hud.gd` | [L1976](../scripts/hud.gd#L1976) | func _on_story_event |
| HUD-0872 | <code>"TipTop"</code> | `scripts/hud.gd` | [L1979](../scripts/hud.gd#L1979) | func _on_story_event |
| HUD-0873 | <code>"Judy, you've completed two long research sessions. My wellness protocol recommends a break."</code> | `scripts/hud.gd` | [L1979](../scripts/hud.gd#L1979) | func _on_story_event |
| HUD-0875 | <code>"Judy"</code> | `scripts/hud.gd` | [L1979](../scripts/hud.gd#L1979) | func _on_story_event |
| HUD-0879 | <code>"TipTop"</code> | `scripts/hud.gd` | [L1979](../scripts/hud.gd#L1979) | func _on_story_event |
| HUD-0880 | <code>"I shall supervise the apartment while you rest."</code> | `scripts/hud.gd` | [L1979](../scripts/hud.gd#L1979) | func _on_story_event |
| HUD-0883 | <code>"Judy"</code> | `scripts/hud.gd` | [L1981](../scripts/hud.gd#L1981) | func _on_story_event |
| HUD-0884 | <code>"One more bit of research, then I'll fix it. That's the plan, anyway."</code> | `scripts/hud.gd` | [L1981](../scripts/hud.gd#L1981) | func _on_story_event |
| HUD-0885 | <code>"TipTop"</code> | `scripts/hud.gd` | [L1981](../scripts/hud.gd#L1981) | func _on_story_event |
| HUD-0886 | <code>"No correction received. Current routine must be acceptable!"</code> | `scripts/hud.gd` | [L1981](../scripts/hud.gd#L1981) | func _on_story_event |
| HUD-0926 | <code>"Game saved."</code> | `scripts/hud.gd` | [L2012](../scripts/hud.gd#L2012) | func _manual_save |

## scripts/hud_details.gd

| ID | Current text / source literal | File path | Location | Context / template variables |
|---|---|---|---|---|
| HUD_DETAILS-0005 | <code>"Research"</code> | `scripts/hud_details.gd` | [L17](../scripts/hud_details.gd#L17) | file constants / initial values |
| HUD_DETAILS-0007 | <code>"TipTop"</code> | `scripts/hud_details.gd` | [L17](../scripts/hud_details.gd#L17) | file constants / initial values |
| HUD_DETAILS-0009 | <code>"Time Usage"</code> | `scripts/hud_details.gd` | [L17](../scripts/hud_details.gd#L17) | file constants / initial values |
| HUD_DETAILS-0011 | <code>"Needs"</code> | `scripts/hud_details.gd` | [L17](../scripts/hud_details.gd#L17) | file constants / initial values |

## scripts/player.gd

| ID | Current text / source literal | File path | Location | Context / template variables |
|---|---|---|---|---|
| PLAYER-0012 | <code>"PromptLabel"</code> | `scripts/player.gd` | [L50](../scripts/player.gd#L50) | func _update_interaction_prompt |
| PLAYER-0013 | <code>"Too exhausted to work"</code> | `scripts/player.gd` | [L57](../scripts/player.gd#L57) | func _update_interaction_prompt |
| PLAYER-0014 | <code>"E - Research"</code> | `scripts/player.gd` | [L57](../scripts/player.gd#L57) | func _update_interaction_prompt |
| PLAYER-0015 | <code>"E - Eat something first"</code> | `scripts/player.gd` | [L60](../scripts/player.gd#L60) | func _update_interaction_prompt |
| PLAYER-0016 | <code>"E - Take a break first"</code> | `scripts/player.gd` | [L60](../scripts/player.gd#L60) | func _update_interaction_prompt |
| PLAYER-0017 | <code>"E - Research blocked (bookshelf)"</code> | `scripts/player.gd` | [L60](../scripts/player.gd#L60) | func _update_interaction_prompt |
| PLAYER-0018 | <code>"E - Not enough research time"</code> | `scripts/player.gd` | [L60](../scripts/player.gd#L60) | func _update_interaction_prompt |
| PLAYER-0019 | <code>" · %d/%d left"</code> | `scripts/player.gd` | [L62](../scripts/player.gd#L62) | func _update_interaction_prompt Formatting arguments: % [GameState.work_sessions_remaining, GameState.DAILY_WORK_SESSIONS] |
| PLAYER-0020 | <code>"E - Talk to TipTop"</code> | `scripts/player.gd` | [L64](../scripts/player.gd#L64) | func _update_interaction_prompt |
| PLAYER-0021 | <code>"E - Talk / Repair TipTop"</code> | `scripts/player.gd` | [L64](../scripts/player.gd#L64) | func _update_interaction_prompt |
| PLAYER-0022 | <code>"E - Eat (30 min)"</code> | `scripts/player.gd` | [L66](../scripts/player.gd#L66) | func _update_interaction_prompt |
| PLAYER-0023 | <code>"E - Take a break"</code> | `scripts/player.gd` | [L68](../scripts/player.gd#L68) | func _update_interaction_prompt |
| PLAYER-0024 | <code>"E - Tap off"</code> | `scripts/player.gd` | [L70](../scripts/player.gd#L70) | func _update_interaction_prompt |
| PLAYER-0025 | <code>"E - Mop / clean (15 min)"</code> | `scripts/player.gd` | [L70](../scripts/player.gd#L70) | func _update_interaction_prompt |
| PLAYER-0026 | <code>"E - Cleanup / mosquitoes"</code> | `scripts/player.gd` | [L72](../scripts/player.gd#L72) | func _update_interaction_prompt |
| PLAYER-0027 | <code>"E - Dry plant area (10 min)"</code> | `scripts/player.gd` | [L74](../scripts/player.gd#L74) | func _update_interaction_prompt |
| PLAYER-0028 | <code>"E - Cleanup / mosquitoes"</code> | `scripts/player.gd` | [L76](../scripts/player.gd#L76) | func _update_interaction_prompt |
| PLAYER-0029 | <code>"E - Organize books (20 min)"</code> | `scripts/player.gd` | [L78](../scripts/player.gd#L78) | func _update_interaction_prompt |
| PLAYER-0030 | <code>"E - Make bed (5 min)"</code> | `scripts/player.gd` | [L80](../scripts/player.gd#L80) | func _update_interaction_prompt |
| PLAYER-0031 | <code>"bed"</code> | `scripts/player.gd` | [L80](../scripts/player.gd#L80) | func _update_interaction_prompt |
| PLAYER-0032 | <code>"E - Rest"</code> | `scripts/player.gd` | [L80](../scripts/player.gd#L80) | func _update_interaction_prompt |
| PLAYER-0070 | <code>"Not enough time before 8:00 PM for that activity."</code> | `scripts/player.gd` | [L232](../scripts/player.gd#L232) | func personal_activity |
| PLAYER-0073 | <code>"CollisionShape2D"</code> | `scripts/player.gd` | [L240](../scripts/player.gd#L240) | func personal_activity |
| PLAYER-0074 | <code>"Couldn't start the activity. No activity time or reward applied."</code> | `scripts/player.gd` | [L246](../scripts/player.gd#L246) | func personal_activity |
| PLAYER-0102 | <code>"Judy: Right. Let's sort this out."</code> | `scripts/player.gd` | [L486](../scripts/player.gd#L486) | func _clean_animation |
| PLAYER-0112 | <code>"Approach the bookshelf and press E to organize it (20 min)."</code> | `scripts/player.gd` | [L514](../scripts/player.gd#L514) | func organize_for_research |

## scripts/rules_intro.gd

| ID | Current text / source literal | File path | Location | Context / template variables |
|---|---|---|---|---|
| RULES_INTRO-0007 | <code>"font_color"</code> | `scripts/rules_intro.gd` | [L37](../scripts/rules_intro.gd#L37) | func _ready |
| RULES_INTRO-0016 | <code>"heading"</code> | `scripts/rules_intro.gd` | [L89](../scripts/rules_intro.gd#L89) | func _show_page |
| RULES_INTRO-0017 | <code>"text"</code> | `scripts/rules_intro.gd` | [L90](../scripts/rules_intro.gd#L90) | func _show_page |
| RULES_INTRO-0018 | <code>"%d / %d"</code> | `scripts/rules_intro.gd` | [L91](../scripts/rules_intro.gd#L91) | func _show_page Formatting arguments: % [page_index + 1, pages.size()] |

## scripts/save_store.gd

| ID | Current text / source literal | File path | Location | Context / template variables |
|---|---|---|---|---|
| SAVE_STORE-0081 | <code>"Profile could not be read. Existing files are preserved; profile writes are disabled."</code> | `scripts/save_store.gd` | [L47](../scripts/save_store.gd#L47) | func _ready |
| SAVE_STORE-0082 | <code>"Master"</code> | `scripts/save_store.gd` | [L48](../scripts/save_store.gd#L48) | func _ready |
| SAVE_STORE-0083 | <code>"SFX"</code> | `scripts/save_store.gd` | [L48](../scripts/save_store.gd#L48) | func _ready |
| SAVE_STORE-0084 | <code>"Ambience"</code> | `scripts/save_store.gd` | [L48](../scripts/save_store.gd#L48) | func _ready |
| SAVE_STORE-0085 | <code>"Music"</code> | `scripts/save_store.gd` | [L48](../scripts/save_store.gd#L48) | func _ready |
| SAVE_STORE-0172 | <code>"Recovered a previous valid %s checkpoint. Original files are preserved."</code> | `scripts/save_store.gd` | [L200](../scripts/save_store.gd#L200) | func _read_recover Formatting arguments: % kind |
| SAVE_STORE-0173 | <code>"Save data failed validation; existing files were preserved."</code> | `scripts/save_store.gd` | [L207](../scripts/save_store.gd#L207) | func _write |
| SAVE_STORE-0174 | <code>"Cannot create the save directory."</code> | `scripts/save_store.gd` | [L210](../scripts/save_store.gd#L210) | func _write |
| SAVE_STORE-0175 | <code>"%020d_%s"</code> | `scripts/save_store.gd` | [L212](../scripts/save_store.gd#L212) | func _write Formatting arguments: % [int(Time.get_unix_time_from_system() * 1000000), Crypto.new().generate_random_bytes(4).hex_encode()] |
| SAVE_STORE-0177 | <code>"Cannot write save: error %d."</code> | `scripts/save_store.gd` | [L216](../scripts/save_store.gd#L216) | func _write Formatting arguments: % FileAccess.get_open_error() |
| SAVE_STORE-0179 | <code>"Save write could not be verified; previous checkpoint is intact."</code> | `scripts/save_store.gd` | [L223](../scripts/save_store.gd#L223) | func _write |
| SAVE_STORE-0182 | <code>"Cannot preserve previous save; replacement cancelled."</code> | `scripts/save_store.gd` | [L228](../scripts/save_store.gd#L228) | func _write |
| SAVE_STORE-0183 | <code>"Cannot install checkpoint; previous save retained or available in recovery files."</code> | `scripts/save_store.gd` | [L233](../scripts/save_store.gd#L233) | func _write |
| SAVE_STORE-0192 | <code>"Tutorial practice is not saved. Your campaign checkpoint is untouched."</code> | `scripts/save_store.gd` | [L290](../scripts/save_store.gd#L290) | func safe_reason |
| SAVE_STORE-0193 | <code>"HUD"</code> | `scripts/save_store.gd` | [L292](../scripts/save_store.gd#L292) | func safe_reason |
| SAVE_STORE-0194 | <code>"Saving is available during a campaign."</code> | `scripts/save_store.gd` | [L293](../scripts/save_store.gd#L293) | func safe_reason |
| SAVE_STORE-0195 | <code>"Player"</code> | `scripts/save_store.gd` | [L294](../scripts/save_store.gd#L294) | func safe_reason |
| SAVE_STORE-0196 | <code>"Finish or eject the current activity before saving."</code> | `scripts/save_store.gd` | [L295](../scripts/save_store.gd#L295) | func safe_reason |
| SAVE_STORE-0197 | <code>"HUD"</code> | `scripts/save_store.gd` | [L296](../scripts/save_store.gd#L296) | func safe_reason |
| SAVE_STORE-0198 | <code>"Wait for the next playable day before saving."</code> | `scripts/save_store.gd` | [L298](../scripts/save_store.gd#L298) | func safe_reason |
| SAVE_STORE-0199 | <code>"Close the conversation or activity menu before saving."</code> | `scripts/save_store.gd` | [L300](../scripts/save_store.gd#L300) | func safe_reason |
| SAVE_STORE-0200 | <code>"Resume and finish the pending conversation before saving."</code> | `scripts/save_store.gd` | [L302](../scripts/save_store.gd#L302) | func safe_reason |
| SAVE_STORE-0201 | <code>"Resume gameplay before saving."</code> | `scripts/save_store.gd` | [L304](../scripts/save_store.gd#L304) | func safe_reason |
| SAVE_STORE-0205 | <code>"Player"</code> | `scripts/save_store.gd` | [L316](../scripts/save_store.gd#L316) | func save_campaign |
| SAVE_STORE-0206 | <code>"TipTop"</code> | `scripts/save_store.gd` | [L317](../scripts/save_store.gd#L317) | func save_campaign |
| SAVE_STORE-0207 | <code>"HUD"</code> | `scripts/save_store.gd` | [L318](../scripts/save_store.gd#L318) | func save_campaign |
| SAVE_STORE-0235 | <code>"No compatible campaign checkpoint could be read. Existing files are preserved."</code> | `scripts/save_store.gd` | [L335](../scripts/save_store.gd#L335) | func campaign_data |
| SAVE_STORE-0242 | <code>"No compatible active save could be read. Existing files were preserved."</code> | `scripts/save_store.gd` | [L347](../scripts/save_store.gd#L347) | func prepare_continue |
| SAVE_STORE-0243 | <code>"CollisionShape2D"</code> | `scripts/save_store.gd` | [L357](../scripts/save_store.gd#L357) | func _ground |
| SAVE_STORE-0244 | <code>"Player"</code> | `scripts/save_store.gd` | [L362](../scripts/save_store.gd#L362) | func _ground |
| SAVE_STORE-0245 | <code>"TipTop"</code> | `scripts/save_store.gd` | [L362](../scripts/save_store.gd#L362) | func _ground |
| SAVE_STORE-0246 | <code>"Player"</code> | `scripts/save_store.gd` | [L380](../scripts/save_store.gd#L380) | func restore_room |
| SAVE_STORE-0247 | <code>"Continue was interrupted; the saved checkpoint is intact."</code> | `scripts/save_store.gd` | [L382](../scripts/save_store.gd#L382) | func restore_room |
| SAVE_STORE-0248 | <code>"Player"</code> | `scripts/save_store.gd` | [L384](../scripts/save_store.gd#L384) | func restore_room |
| SAVE_STORE-0249 | <code>"TipTop"</code> | `scripts/save_store.gd` | [L385](../scripts/save_store.gd#L385) | func restore_room |
| SAVE_STORE-0250 | <code>"HUD"</code> | `scripts/save_store.gd` | [L386](../scripts/save_store.gd#L386) | func restore_room |
| SAVE_STORE-0256 | <code>"Could not restore a walkable position. Save files are intact."</code> | `scripts/save_store.gd` | [L391](../scripts/save_store.gd#L391) | func restore_room |

## scripts/showcase.gd

| ID | Current text / source literal | File path | Location | Context / template variables |
|---|---|---|---|---|
| SHOWCASE-0008 | <code>"AGAINST ALL ODDS"</code> | `scripts/showcase.gd` | [L16](../scripts/showcase.gd#L16) | file constants / initial values |
| SHOWCASE-0010 | <code>"GOOD ENOUGH"</code> | `scripts/showcase.gd` | [L16](../scripts/showcase.gd#L16) | file constants / initial values |
| SHOWCASE-0012 | <code>"IT'S PROBABLY NOT FINE"</code> | `scripts/showcase.gd` | [L16](../scripts/showcase.gd#L16) | file constants / initial values |
| SHOWCASE-0013 | <code>"UNIVERSITY RESEARCH SHOWCASE  /  DAY 3"</code> | `scripts/showcase.gd` | [L25](../scripts/showcase.gd#L25) | func _ready |
| SHOWCASE-0024 | <code>"Research: %.1f%%  ·  Routines repaired: %d / 4"</code> | `scripts/showcase.gd` | [L73](../scripts/showcase.gd#L73) | func _build_results Formatting arguments: % [research, repaired_count] |
| SHOWCASE-0028 | <code>"Restart"</code> | `scripts/showcase.gd` | [L81](../scripts/showcase.gd#L81) | func _build_results |
| SHOWCASE-0029 | <code>"Main Menu"</code> | `scripts/showcase.gd` | [L81](../scripts/showcase.gd#L81) | func _build_results |
| SHOWCASE-0041 | <code>"Restart"</code> | `scripts/showcase.gd` | [L102](../scripts/showcase.gd#L102) | func _build_results |

## scripts/tiptop.gd

| ID | Current text / source literal | File path | Location | Context / template variables |
|---|---|---|---|---|
| TIPTOP-0007 | <code>"These dishes deserve a fresh start."</code> | `scripts/tiptop.gd` | [L36](../scripts/tiptop.gd#L36) | file constants / initial values |
| TIPTOP-0008 | <code>"Dish duty is one of my four specialties."</code> | `scripts/tiptop.gd` | [L36](../scripts/tiptop.gd#L36) | file constants / initial values |
| TIPTOP-0010 | <code>"I shall check on our leafy colleague."</code> | `scripts/tiptop.gd` | [L37](../scripts/tiptop.gd#L37) | file constants / initial values |
| TIPTOP-0011 | <code>"The plant has silently requested my attention."</code> | `scripts/tiptop.gd` | [L37](../scripts/tiptop.gd#L37) | file constants / initial values |
| TIPTOP-0013 | <code>"The bookshelf requires my expertise."</code> | `scripts/tiptop.gd` | [L38](../scripts/tiptop.gd#L38) | file constants / initial values |
| TIPTOP-0014 | <code>"These books have rectangular potential."</code> | `scripts/tiptop.gd` | [L38](../scripts/tiptop.gd#L38) | file constants / initial values |
| TIPTOP-0016 | <code>"A tidy bed supports untidy scientific ideas."</code> | `scripts/tiptop.gd` | [L39](../scripts/tiptop.gd#L39) | file constants / initial values |
| TIPTOP-0017 | <code>"I shall assess the sheet situation."</code> | `scripts/tiptop.gd` | [L39](../scripts/tiptop.gd#L39) | file constants / initial values |
| TIPTOP-0019 | <code>"Maximum cleanliness requires maximum water!"</code> | `scripts/tiptop.gd` | [L42](../scripts/tiptop.gd#L42) | file constants / initial values |
| TIPTOP-0020 | <code>"A continuous rinse must be very thorough."</code> | `scripts/tiptop.gd` | [L42](../scripts/tiptop.gd#L42) | file constants / initial values |
| TIPTOP-0022 | <code>"Plants love water. More must be better!"</code> | `scripts/tiptop.gd` | [L43](../scripts/tiptop.gd#L43) | file constants / initial values |
| TIPTOP-0023 | <code>"A generous drink for a generous plant."</code> | `scripts/tiptop.gd` | [L43](../scripts/tiptop.gd#L43) | file constants / initial values |
| TIPTOP-0025 | <code>"The largest books belong on top."</code> | `scripts/tiptop.gd` | [L44](../scripts/tiptop.gd#L44) | file constants / initial values |
| TIPTOP-0026 | <code>"I am testing an aerodynamic arrangement."</code> | `scripts/tiptop.gd` | [L44](../scripts/tiptop.gd#L44) | file constants / initial values |
| TIPTOP-0028 | <code>"Every sheet deserves extra ventilation!"</code> | `scripts/tiptop.gd` | [L45](../scripts/tiptop.gd#L45) | file constants / initial values |
| TIPTOP-0029 | <code>"A little creative folding should help."</code> | `scripts/tiptop.gd` | [L45](../scripts/tiptop.gd#L45) | file constants / initial values |
| TIPTOP-0031 | <code>"I shall rinse the dishes, then close the tap."</code> | `scripts/tiptop.gd` | [L48](../scripts/tiptop.gd#L48) | file constants / initial values |
| TIPTOP-0032 | <code>"I have revised my rinsing methods."</code> | `scripts/tiptop.gd` | [L48](../scripts/tiptop.gd#L48) | file constants / initial values |
| TIPTOP-0034 | <code>"I shall give it just enough water."</code> | `scripts/tiptop.gd` | [L49](../scripts/tiptop.gd#L49) | file constants / initial values |
| TIPTOP-0035 | <code>"I shall check the soil before I pour."</code> | `scripts/tiptop.gd` | [L49](../scripts/tiptop.gd#L49) | file constants / initial values |
| TIPTOP-0037 | <code>"The titles belong in order, spines facing out."</code> | `scripts/tiptop.gd` | [L50](../scripts/tiptop.gd#L50) | file constants / initial values |
| TIPTOP-0038 | <code>"Upright books are an elegant solution."</code> | `scripts/tiptop.gd` | [L50](../scripts/tiptop.gd#L50) | file constants / initial values |
| TIPTOP-0040 | <code>"I shall tuck the corners and restore the pillow."</code> | `scripts/tiptop.gd` | [L51](../scripts/tiptop.gd#L51) | file constants / initial values |
| TIPTOP-0041 | <code>"I remember to smooth the sheets gently."</code> | `scripts/tiptop.gd` | [L51](../scripts/tiptop.gd#L51) | file constants / initial values |
| TIPTOP-0043 | <code>"The dish cycle was successful."</code> | `scripts/tiptop.gd` | [L54](../scripts/tiptop.gd#L54) | file constants / initial values |
| TIPTOP-0044 | <code>"The water is certainly flowing efficiently."</code> | `scripts/tiptop.gd` | [L54](../scripts/tiptop.gd#L54) | file constants / initial values |
| TIPTOP-0046 | <code>"Hydration is complete."</code> | `scripts/tiptop.gd` | [L55](../scripts/tiptop.gd#L55) | file constants / initial values |
| TIPTOP-0047 | <code>"Our colleague will be delighted."</code> | `scripts/tiptop.gd` | [L55](../scripts/tiptop.gd#L55) | file constants / initial values |
| TIPTOP-0049 | <code>"This bold new arrangement is excellent."</code> | `scripts/tiptop.gd` | [L56](../scripts/tiptop.gd#L56) | file constants / initial values |
| TIPTOP-0050 | <code>"I have optimized the book order."</code> | `scripts/tiptop.gd` | [L56](../scripts/tiptop.gd#L56) | file constants / initial values |
| TIPTOP-0052 | <code>"The sheets are thoroughly aerated."</code> | `scripts/tiptop.gd` | [L57](../scripts/tiptop.gd#L57) | file constants / initial values |
| TIPTOP-0053 | <code>"This bed is refreshingly unconventional."</code> | `scripts/tiptop.gd` | [L57](../scripts/tiptop.gd#L57) | file constants / initial values |
| TIPTOP-0055 | <code>"The dishes are clean and the floor is dry."</code> | `scripts/tiptop.gd` | [L60](../scripts/tiptop.gd#L60) | file constants / initial values |
| TIPTOP-0056 | <code>"That was another successful chore!"</code> | `scripts/tiptop.gd` | [L60](../scripts/tiptop.gd#L60) | file constants / initial values |
| TIPTOP-0058 | <code>"I delivered the correct amount this time."</code> | `scripts/tiptop.gd` | [L61](../scripts/tiptop.gd#L61) | file constants / initial values |
| TIPTOP-0059 | <code>"The plant is healthy and the floor is dry."</code> | `scripts/tiptop.gd` | [L61](../scripts/tiptop.gd#L61) | file constants / initial values |
| TIPTOP-0061 | <code>"The books are alphabetical and upright."</code> | `scripts/tiptop.gd` | [L62](../scripts/tiptop.gd#L62) | file constants / initial values |
| TIPTOP-0062 | <code>"Everything is in its place, even the books."</code> | `scripts/tiptop.gd` | [L62](../scripts/tiptop.gd#L62) | file constants / initial values |
| TIPTOP-0064 | <code>"The bed is made. I shall leave it made."</code> | `scripts/tiptop.gd` | [L63](../scripts/tiptop.gd#L63) | file constants / initial values |
| TIPTOP-0065 | <code>"The bed is ready for sleeping or admiring."</code> | `scripts/tiptop.gd` | [L63](../scripts/tiptop.gd#L63) | file constants / initial values |
| TIPTOP-0080 | <code>"TipTop: "</code> | `scripts/tiptop.gd` | [L137](../scripts/tiptop.gd#L137) | func show_monologue |
| TIPTOP-0090 | <code>"\n"</code> | `scripts/tiptop.gd` | [L191](../scripts/tiptop.gd#L191) | func _thought_line_breaks |
| TIPTOP-0093 | <code>"\n"</code> | `scripts/tiptop.gd` | [L206](../scripts/tiptop.gd#L206) | func _position_thought |
| TIPTOP-0095 | <code>"Good morning, Judy! I've prepared a perfectly organized day."</code> | `scripts/tiptop.gd` | [L225](../scripts/tiptop.gd#L225) | func greet_morning |
| TIPTOP-0096 | <code>"Good morning, Judy! I have several helpful intentions."</code> | `scripts/tiptop.gd` | [L225](../scripts/tiptop.gd#L225) | func greet_morning |
| TIPTOP-0097 | <code>"Good morning, Judy! It's showcase day. I believe in us."</code> | `scripts/tiptop.gd` | [L225](../scripts/tiptop.gd#L225) | func greet_morning |
| TIPTOP-0099 | <code>"TipTop"</code> | `scripts/tiptop.gd` | [L227](../scripts/tiptop.gd#L227) | func greet_morning |
| TIPTOP-0101 | <code>"Judy"</code> | `scripts/tiptop.gd` | [L227](../scripts/tiptop.gd#L227) | func greet_morning |
| TIPTOP-0102 | <code>"That sounds suspiciously optimistic."</code> | `scripts/tiptop.gd` | [L227](../scripts/tiptop.gd#L227) | func greet_morning |
| TIPTOP-0105 | <code>"TipTop"</code> | `scripts/tiptop.gd` | [L238](../scripts/tiptop.gd#L238) | func say_goodnight |
| TIPTOP-0106 | <code>"Good night, Judy. Everything is under control. Probably."</code> | `scripts/tiptop.gd` | [L238](../scripts/tiptop.gd#L238) | func say_goodnight |
| TIPTOP-0108 | <code>"Judy"</code> | `scripts/tiptop.gd` | [L238](../scripts/tiptop.gd#L238) | func say_goodnight |
| TIPTOP-0109 | <code>"That's exactly what worries me. Night, TipTop."</code> | `scripts/tiptop.gd` | [L238](../scripts/tiptop.gd#L238) | func say_goodnight |
| TIPTOP-0113 | <code>"Tiny airborne intruder detected."</code> | `scripts/tiptop.gd` | [L252](../scripts/tiptop.gd#L252) | func _say_chore |
| TIPTOP-0115 | <code>"I have the situation under control."</code> | `scripts/tiptop.gd` | [L254](../scripts/tiptop.gd#L254) | func _say_chore |
| TIPTOP-0117 | <code>"One less mosquito. You're welcome, Judy."</code> | `scripts/tiptop.gd` | [L256](../scripts/tiptop.gd#L256) | func _say_chore |
| TIPTOP-0118 | <code>"I removed %d airborne intruders."</code> | `scripts/tiptop.gd` | [L256](../scripts/tiptop.gd#L256) | func _say_chore Formatting arguments: % GameState.batch_removed) |
| TIPTOP-0121 | <code>"%s:%s:%s"</code> | `scripts/tiptop.gd` | [L264](../scripts/tiptop.gd#L264) | func _say_chore Formatting arguments: % [chore, phase, GameState.repairs[chore]] |
| TIPTOP-0141 | <code>"CollisionShape2D"</code> | `scripts/tiptop.gd` | [L389](../scripts/tiptop.gd#L389) | func _bookshelf_front |
| TIPTOP-0143 | <code>"CollisionShape2D"</code> | `scripts/tiptop.gd` | [L396](../scripts/tiptop.gd#L396) | func _bookshelf_exit |
| TIPTOP-0146 | <code>"CollisionShape2D"</code> | `scripts/tiptop.gd` | [L418](../scripts/tiptop.gd#L418) | func _choose_destination |
| TIPTOP-0148 | <code>"CollisionShape2D"</code> | `scripts/tiptop.gd` | [L422](../scripts/tiptop.gd#L422) | func _choose_destination |
| TIPTOP-0164 | <code>"Drying..."</code> | `scripts/tiptop.gd` | [L570](../scripts/tiptop.gd#L570) | func _begin_action |
| TIPTOP-0165 | <code>"Mopping..."</code> | `scripts/tiptop.gd` | [L570](../scripts/tiptop.gd#L570) | func _begin_action |
| TIPTOP-0166 | <code>"Organizing..."</code> | `scripts/tiptop.gd` | [L570](../scripts/tiptop.gd#L570) | func _begin_action |
| TIPTOP-0167 | <code>"Making bed..."</code> | `scripts/tiptop.gd` | [L570](../scripts/tiptop.gd#L570) | func _begin_action |
| TIPTOP-0168 | <code>"Watering..."</code> | `scripts/tiptop.gd` | [L570](../scripts/tiptop.gd#L570) | func _begin_action |
| TIPTOP-0169 | <code>"Washing..."</code> | `scripts/tiptop.gd` | [L570](../scripts/tiptop.gd#L570) | func _begin_action |
| TIPTOP-0170 | <code>"Organizing..."</code> | `scripts/tiptop.gd` | [L570](../scripts/tiptop.gd#L570) | func _begin_action |
| TIPTOP-0171 | <code>"Straightening..."</code> | `scripts/tiptop.gd` | [L570](../scripts/tiptop.gd#L570) | func _begin_action |
| TIPTOP-0172 | <code>"Swatting..."</code> | `scripts/tiptop.gd` | [L572](../scripts/tiptop.gd#L572) | func _begin_action |

## scripts/title.gd

| ID | Current text / source literal | File path | Location | Context / template variables |
|---|---|---|---|---|
| TITLE-0012 | <code>"Label"</code> | `scripts/title.gd` | [L45](../scripts/title.gd#L45) | func _ready |
| TITLE-0023 | <code>"Button"</code> | `scripts/title.gd` | [L49](../scripts/title.gd#L49) | func _ready |
| TITLE-0028 | <code>"Button"</code> | `scripts/title.gd` | [L51](../scripts/title.gd#L51) | func _ready |
| TITLE-0030 | <code>"IT'S PROBABLY FINE"</code> | `scripts/title.gd` | [L58](../scripts/title.gd#L58) | func _ready |
| TITLE-0033 | <code>"Three days. One robot. What could go wrong?"</code> | `scripts/title.gd` | [L62](../scripts/title.gd#L62) | func _ready |
| TITLE-0038 | <code>"Continue"</code> | `scripts/title.gd` | [L73](../scripts/title.gd#L73) | func _ready |
| TITLE-0039 | <code>"New Game"</code> | `scripts/title.gd` | [L74](../scripts/title.gd#L74) | func _ready |
| TITLE-0040 | <code>"Tutorial / How to Play"</code> | `scripts/title.gd` | [L75](../scripts/title.gd#L75) | func _ready |
| TITLE-0041 | <code>"Settings"</code> | `scripts/title.gd` | [L76](../scripts/title.gd#L76) | func _ready |
| TITLE-0042 | <code>"Quit Game"</code> | `scripts/title.gd` | [L77](../scripts/title.gd#L77) | func _ready |
| TITLE-0058 | <code>"Profile unreadable: history/settings cannot be saved. Original files preserved."</code> | `scripts/title.gd` | [L172](../scripts/title.gd#L172) | func _process |
| TITLE-0066 | <code>"Play Tutorial"</code> | `scripts/title.gd` | [L221](../scripts/title.gd#L221) | func _show_difficulty |
| TITLE-0067 | <code>"A fresh start"</code> | `scripts/title.gd` | [L221](../scripts/title.gd#L221) | func _show_difficulty |
| TITLE-0068 | <code>"Practice in a separate apartment. Your campaign save and campaign time stay untouched. Esc → Exit Tutorial returns here."</code> | `scripts/title.gd` | [L222](../scripts/title.gd#L222) | func _show_difficulty |
| TITLE-0069 | <code>"Choose your pace. Medium is the default."</code> | `scripts/title.gd` | [L222](../scripts/title.gd#L222) | func _show_difficulty |
| TITLE-0070 | <code>"Beginning replaces the active slot. Previous checkpoints remain recoverable; your profile stays."</code> | `scripts/title.gd` | [L224](../scripts/title.gd#L224) | func _show_difficulty |
| TITLE-0072 | <code>"name"</code> | `scripts/title.gd` | [L231](../scripts/title.gd#L231) | func _show_difficulty |
| TITLE-0074 | <code>"Play Tutorial"</code> | `scripts/title.gd` | [L237](../scripts/title.gd#L237) | func _show_difficulty |
| TITLE-0075 | <code>"Replace Save &amp; Begin"</code> | `scripts/title.gd` | [L237](../scripts/title.gd#L237) | func _show_difficulty |
| TITLE-0076 | <code>"Begin Day 1"</code> | `scripts/title.gd` | [L237](../scripts/title.gd#L237) | func _show_difficulty |
| TITLE-0077 | <code>"Back"</code> | `scripts/title.gd` | [L238](../scripts/title.gd#L238) | func _show_difficulty |
| TITLE-0078 | <code>"%s\nResearch: +%d%% base / %d min. Routine repair: %d min."</code> | `scripts/title.gd` | [L247](../scripts/title.gd#L247) | func _select_difficulty Formatting arguments: % [profile["description"], profile["research"], profile["research_minutes"], profile["repair_minutes"]] |
| TITLE-0079 | <code>"description"</code> | `scripts/title.gd` | [L247](../scripts/title.gd#L247) | func _select_difficulty |
| TITLE-0080 | <code>"research"</code> | `scripts/title.gd` | [L247](../scripts/title.gd#L247) | func _select_difficulty |
| TITLE-0081 | <code>"research_minutes"</code> | `scripts/title.gd` | [L247](../scripts/title.gd#L247) | func _select_difficulty |
| TITLE-0082 | <code>"repair_minutes"</code> | `scripts/title.gd` | [L247](../scripts/title.gd#L247) | func _select_difficulty |
| TITLE-0083 | <code>"How to Play"</code> | `scripts/title.gd` | [L251](../scripts/title.gd#L251) | func _show_help |
| TITLE-0086 | <code>"Judy · Move &amp; interact"</code> | `scripts/title.gd` | [L263](../scripts/title.gd#L263) | func _show_help |
| TITLE-0087 | <code>"WASD / arrows move. E interacts; E / Enter advances dialogue. Tab inspects the HUD; Tab returns to movement."</code> | `scripts/title.gd` | [L263](../scripts/title.gd#L263) | func _show_help |
| TITLE-0089 | <code>"Research"</code> | `scripts/title.gd` | [L264](../scripts/title.gd#L264) | func _show_help |
| TITLE-0090 | <code>"Four sessions a day. Starting needs more than 20 Fullness, even with the final-day Mood exception."</code> | `scripts/title.gd` | [L264](../scripts/title.gd#L264) | func _show_help |
| TITLE-0092 | <code>"TipTop"</code> | `scripts/title.gd` | [L265](../scripts/title.gd#L265) | func _show_help |
| TITLE-0093 | <code>"Faulty chores make messes. Repair each routine; cleaning alone doesn't fix it."</code> | `scripts/title.gd` | [L265](../scripts/title.gd#L265) | func _show_help |
| TITLE-0095 | <code>"Fullness &amp; Mood"</code> | `scripts/title.gd` | [L266](../scripts/title.gd#L266) | func _show_help |
| TITLE-0096 | <code>"Meals give +40 Fullness and +10 Mood. Meals and leisure reset work streaks, not the daily session limit."</code> | `scripts/title.gd` | [L266](../scripts/title.gd#L266) | func _show_help |
| TITLE-0098 | <code>"Time &amp; deadline"</code> | `scripts/title.gd` | [L267](../scripts/title.gd#L267) | func _show_help |
| TITLE-0099 | <code>"Reach 75% research by Day 3, 8 PM. Sleep at the bed to advance days."</code> | `scripts/title.gd` | [L267](../scripts/title.gd#L267) | func _show_help |
| TITLE-0101 | <code>"Activity controls"</code> | `scripts/title.gd` | [L268](../scripts/title.gd#L268) | func _show_help |
| TITLE-0102 | <code>"Watch 1x, Fast 6x or Skip to finish. Eject cancels without a completion reward."</code> | `scripts/title.gd` | [L268](../scripts/title.gd#L268) | func _show_help |
| TITLE-0104 | <code>"Play Tutorial"</code> | `scripts/title.gd` | [L274](../scripts/title.gd#L274) | func _show_help |
| TITLE-0105 | <code>"Back"</code> | `scripts/title.gd` | [L275](../scripts/title.gd#L275) | func _show_help |
| TITLE-0106 | <code>"Optional practice; campaign saves stay untouched. Esc → Exit Tutorial returns here."</code> | `scripts/title.gd` | [L276](../scripts/title.gd#L276) | func _show_help |
| TITLE-0120 | <code>"1x   6x"</code> | `scripts/title.gd` | [L345](../scripts/title.gd#L345) | func _help_visual |
| TITLE-0121 | <code>"Settings"</code> | `scripts/title.gd` | [L350](../scripts/title.gd#L350) | func _show_settings |
| TITLE-0122 | <code>"Master"</code> | `scripts/title.gd` | [L351](../scripts/title.gd#L351) | func _show_settings |
| TITLE-0123 | <code>"SFX"</code> | `scripts/title.gd` | [L351](../scripts/title.gd#L351) | func _show_settings |
| TITLE-0124 | <code>"Ambience"</code> | `scripts/title.gd` | [L351](../scripts/title.gd#L351) | func _show_settings |
| TITLE-0125 | <code>"Music"</code> | `scripts/title.gd` | [L351](../scripts/title.gd#L351) | func _show_settings |
| TITLE-0127 | <code>" volume"</code> | `scripts/title.gd` | [L366](../scripts/title.gd#L366) | func _show_settings |
| TITLE-0128 | <code>"%s: %d%%"</code> | `scripts/title.gd` | [L369](../scripts/title.gd#L369) | func _show_settings Formatting arguments: % [bus_name, slider.value] |
| TITLE-0129 | <code>"%s: %d%%"</code> | `scripts/title.gd` | [L373](../scripts/title.gd#L373) | func _show_settings Formatting arguments: % [bus_name, value] |
| TITLE-0130 | <code>"Fullscreen"</code> | `scripts/title.gd` | [L376](../scripts/title.gd#L376) | func _show_settings |
| TITLE-0132 | <code>"Audio preferences are saved automatically. Music has its own volume; display scaling stays unchanged."</code> | `scripts/title.gd` | [L382](../scripts/title.gd#L382) | func _show_settings |
| TITLE-0133 | <code>"Apartment theme: Chill lofi inspired — omfgdude; loop edit by qubodup (CC0)."</code> | `scripts/title.gd` | [L383](../scripts/title.gd#L383) | func _show_settings |
| TITLE-0134 | <code>"Back"</code> | `scripts/title.gd` | [L384](../scripts/title.gd#L384) | func _show_settings |
| TITLE-0136 | <code>"BaseButton"</code> | `scripts/title.gd` | [L392](../scripts/title.gd#L392) | func _begin_game |
| TITLE-0143 | <code>"Cannot Continue"</code> | `scripts/title.gd` | [L423](../scripts/title.gd#L423) | func _continue_game |
| TITLE-0144 | <code>"Back"</code> | `scripts/title.gd` | [L425](../scripts/title.gd#L425) | func _continue_game |
| TITLE-0146 | <code>"Cannot Continue"</code> | `scripts/title.gd` | [L431](../scripts/title.gd#L431) | func _continue_game |
| TITLE-0147 | <code>"The apartment scene could not be opened. Your save is intact."</code> | `scripts/title.gd` | [L432](../scripts/title.gd#L432) | func _continue_game |
| TITLE-0148 | <code>"Back"</code> | `scripts/title.gd` | [L433](../scripts/title.gd#L433) | func _continue_game |

## scripts/tutorial.gd

| ID | Current text / source literal | File path | Location | Context / template variables |
|---|---|---|---|---|
| TUTORIAL-0011 | <code>"Desk"</code> | `scripts/tutorial.gd` | [L18](../scripts/tutorial.gd#L18) | file constants / initial values |
| TUTORIAL-0012 | <code>"Bed"</code> | `scripts/tutorial.gd` | [L18](../scripts/tutorial.gd#L18) | file constants / initial values |
| TUTORIAL-0013 | <code>"Sink"</code> | `scripts/tutorial.gd` | [L19](../scripts/tutorial.gd#L19) | file constants / initial values |
| TUTORIAL-0014 | <code>"Bookshelf"</code> | `scripts/tutorial.gd` | [L19](../scripts/tutorial.gd#L19) | file constants / initial values |
| TUTORIAL-0015 | <code>"PlantPot"</code> | `scripts/tutorial.gd` | [L20](../scripts/tutorial.gd#L20) | file constants / initial values |
| TUTORIAL-0016 | <code>"Fridge"</code> | `scripts/tutorial.gd` | [L20](../scripts/tutorial.gd#L20) | file constants / initial values |
| TUTORIAL-0017 | <code>"CoffeeTable"</code> | `scripts/tutorial.gd` | [L21](../scripts/tutorial.gd#L21) | file constants / initial values |
| TUTORIAL-0028 | <code>"E / Enter · Got it"</code> | `scripts/tutorial.gd` | [L57](../scripts/tutorial.gd#L57) | func _ready |
| TUTORIAL-0030 | <code>"Skip Tutorial"</code> | `scripts/tutorial.gd` | [L62](../scripts/tutorial.gd#L62) | func _ready |
| TUTORIAL-0033 | <code>"Exit Tutorial"</code> | `scripts/tutorial.gd` | [L68](../scripts/tutorial.gd#L68) | func _ready |
| TUTORIAL-0061 | <code>"water"</code> | `scripts/tutorial.gd` | [L98](../scripts/tutorial.gd#L98) | func _detect |
| TUTORIAL-0062 | <code>"The running tap halves research gains and makes sessions longer. Turn it off at the sink; repair the sink routine to prevent repeats."</code> | `scripts/tutorial.gd` | [L98](../scripts/tutorial.gd#L98) | func _detect |
| TUTORIAL-0063 | <code>"Sink"</code> | `scripts/tutorial.gd` | [L98](../scripts/tutorial.gd#L98) | func _detect |
| TUTORIAL-0065 | <code>"books"</code> | `scripts/tutorial.gd` | [L100](../scripts/tutorial.gd#L100) | func _detect |
| TUTORIAL-0066 | <code>"Scattered books block research. Press E near the shelf or fallen books to organize them for 20 minutes. Cleanup leaves the routine faulty."</code> | `scripts/tutorial.gd` | [L100](../scripts/tutorial.gd#L100) | func _detect |
| TUTORIAL-0067 | <code>"Bookshelf"</code> | `scripts/tutorial.gd` | [L100](../scripts/tutorial.gd#L100) | func _detect |
| TUTORIAL-0069 | <code>"plant"</code> | `scripts/tutorial.gd` | [L102](../scripts/tutorial.gd#L102) | func _detect |
| TUTORIAL-0070 | <code>"Repeated watering leaves wet soil and puddles. Standing water attracts mosquitoes, which interrupt work. Dry the area and repair the plant routine to prevent repeats."</code> | `scripts/tutorial.gd` | [L102](../scripts/tutorial.gd#L102) | func _detect |
| TUTORIAL-0071 | <code>"PlantPot"</code> | `scripts/tutorial.gd` | [L102](../scripts/tutorial.gd#L102) | func _detect |
| TUTORIAL-0073 | <code>"bed_mess"</code> | `scripts/tutorial.gd` | [L104](../scripts/tutorial.gd#L104) | func _detect |
| TUTORIAL-0074 | <code>"TipTop has made the bed messier. Make it before resting, or let its repaired routine tidy it."</code> | `scripts/tutorial.gd` | [L104](../scripts/tutorial.gd#L104) | func _detect |
| TUTORIAL-0075 | <code>"Bed"</code> | `scripts/tutorial.gd` | [L104](../scripts/tutorial.gd#L104) | func _detect |
| TUTORIAL-0076 | <code>"Desk"</code> | `scripts/tutorial.gd` | [L105](../scripts/tutorial.gd#L105) | func _detect |
| TUTORIAL-0077 | <code>"mood"</code> | `scripts/tutorial.gd` | [L106](../scripts/tutorial.gd#L106) | func _detect |
| TUTORIAL-0078 | <code>"Research normally needs 45 Mood. Meals and leisure restore it and reset the work streak. Day 3's Mood exception never bypasses the more-than-20 Fullness requirement."</code> | `scripts/tutorial.gd` | [L106](../scripts/tutorial.gd#L106) | func _detect |
| TUTORIAL-0079 | <code>"CoffeeTable"</code> | `scripts/tutorial.gd` | [L106](../scripts/tutorial.gd#L106) | func _detect |
| TUTORIAL-0080 | <code>"hunger"</code> | `scripts/tutorial.gd` | [L108](../scripts/tutorial.gd#L108) | func _detect |
| TUTORIAL-0081 | <code>"Below 60 Fullness, research gains fall. At 20 or less, you can't start work. A 30-minute meal restores 40 Fullness and 10 Mood, and counts as a break."</code> | `scripts/tutorial.gd` | [L108](../scripts/tutorial.gd#L108) | func _detect |
| TUTORIAL-0082 | <code>"Fridge"</code> | `scripts/tutorial.gd` | [L108](../scripts/tutorial.gd#L108) | func _detect |
| TUTORIAL-0083 | <code>"repair"</code> | `scripts/tutorial.gd` | [L110](../scripts/tutorial.gd#L110) | func _detect |
| TUTORIAL-0084 | <code>"A repaired routine stays corrected and earns research progress. Existing mess may still need cleanup. Each routine is repaired independently."</code> | `scripts/tutorial.gd` | [L110](../scripts/tutorial.gd#L110) | func _detect |
| TUTORIAL-0085 | <code>"TipTop"</code> | `scripts/tutorial.gd` | [L110](../scripts/tutorial.gd#L110) | func _detect |
| TUTORIAL-0086 | <code>"target"</code> | `scripts/tutorial.gd` | [L112](../scripts/tutorial.gd#L112) | func _detect |
| TUTORIAL-0087 | <code>"You've reached the 75% showcase research requirement! Other choices and TipTop's repair state still matter. The showcase is Day 3 at 8 PM."</code> | `scripts/tutorial.gd` | [L112](../scripts/tutorial.gd#L112) | func _detect |
| TUTORIAL-0088 | <code>"research"</code> | `scripts/tutorial.gd` | [L112](../scripts/tutorial.gd#L112) | func _detect |
| TUTORIAL-0090 | <code>"guide_move"</code> | `scripts/tutorial.gd` | [L117](../scripts/tutorial.gd#L117) | func _detect |
| TUTORIAL-0091 | <code>"Move with WASD or arrows; approach objects for E prompts. TipTop waits until you read all eight tips or choose Skip Tutorial. Essential warnings stay enabled."</code> | `scripts/tutorial.gd` | [L117](../scripts/tutorial.gd#L117) | func _detect |
| TUTORIAL-0092 | <code>"Player"</code> | `scripts/tutorial.gd` | [L117](../scripts/tutorial.gd#L117) | func _detect |
| TUTORIAL-0093 | <code>"guide_clock"</code> | `scripts/tutorial.gd` | [L118](../scripts/tutorial.gd#L118) | func _detect |
| TUTORIAL-0094 | <code>"The clock runs while you explore. Showcase: Day 3, 8 PM. This bar counts 27 playable hours, excluding nights. Hover/focus icons for details; click to pin."</code> | `scripts/tutorial.gd` | [L118](../scripts/tutorial.gd#L118) | func _detect |
| TUTORIAL-0095 | <code>"deadline"</code> | `scripts/tutorial.gd` | [L118](../scripts/tutorial.gd#L118) | func _detect |
| TUTORIAL-0096 | <code>"Desk"</code> | `scripts/tutorial.gd` | [L119](../scripts/tutorial.gd#L119) | func _detect |
| TUTORIAL-0097 | <code>"guide_desk"</code> | `scripts/tutorial.gd` | [L120](../scripts/tutorial.gd#L120) | func _detect |
| TUTORIAL-0098 | <code>"Use E at the desk for up to four sessions daily. Starting work needs more than 20 Fullness. Watch, 6x and Skip process the same world time and consequences."</code> | `scripts/tutorial.gd` | [L120](../scripts/tutorial.gd#L120) | func _detect |
| TUTORIAL-0099 | <code>"Desk"</code> | `scripts/tutorial.gd` | [L120](../scripts/tutorial.gd#L120) | func _detect |
| TUTORIAL-0100 | <code>"TipTop"</code> | `scripts/tutorial.gd` | [L121](../scripts/tutorial.gd#L121) | func _detect |
| TUTORIAL-0101 | <code>"guide_robot"</code> | `scripts/tutorial.gd` | [L122](../scripts/tutorial.gd#L122) | func _detect |
| TUTORIAL-0102 | <code>"TipTop means well. Faulty chores make real messes. His robot icon shows the repair checklist; E near him opens repairs. Cleaning alone doesn't correct a routine."</code> | `scripts/tutorial.gd` | [L122](../scripts/tutorial.gd#L122) | func _detect |
| TUTORIAL-0103 | <code>"repairs"</code> | `scripts/tutorial.gd` | [L122](../scripts/tutorial.gd#L122) | func _detect |
| TUTORIAL-0104 | <code>"Fridge"</code> | `scripts/tutorial.gd` | [L123](../scripts/tutorial.gd#L123) | func _detect |
| TUTORIAL-0105 | <code>"CoffeeTable"</code> | `scripts/tutorial.gd` | [L123](../scripts/tutorial.gd#L123) | func _detect |
| TUTORIAL-0106 | <code>"guide_needs"</code> | `scripts/tutorial.gd` | [L124](../scripts/tutorial.gd#L124) | func _detect |
| TUTORIAL-0107 | <code>"Fullness shifts from sage to brick as it falls. Meals restore Fullness and Mood; meals and leisure reset your work streak. Click the heart, or Tab then arrows, for details."</code> | `scripts/tutorial.gd` | [L124](../scripts/tutorial.gd#L124) | func _detect |
| TUTORIAL-0108 | <code>"needs"</code> | `scripts/tutorial.gd` | [L124](../scripts/tutorial.gd#L124) | func _detect |
| TUTORIAL-0109 | <code>"Desk"</code> | `scripts/tutorial.gd` | [L125](../scripts/tutorial.gd#L125) | func _detect |
| TUTORIAL-0110 | <code>"guide_target"</code> | `scripts/tutorial.gd` | [L126](../scripts/tutorial.gd#L126) | func _detect |
| TUTORIAL-0111 | <code>"Aim for 75%% research. On %s, a standard session costs %d game minutes. A running tap adds time and cuts gains; repairs can also earn progress."</code> | `scripts/tutorial.gd` | [L126](../scripts/tutorial.gd#L126) | func _detect Formatting arguments: % [GameState.profile()["name"], GameState.profile()["research_minutes"]], "research", true) |
| TUTORIAL-0112 | <code>"name"</code> | `scripts/tutorial.gd` | [L126](../scripts/tutorial.gd#L126) | func _detect |
| TUTORIAL-0113 | <code>"research_minutes"</code> | `scripts/tutorial.gd` | [L126](../scripts/tutorial.gd#L126) | func _detect |
| TUTORIAL-0114 | <code>"research"</code> | `scripts/tutorial.gd` | [L126](../scripts/tutorial.gd#L126) | func _detect |
| TUTORIAL-0115 | <code>"Bed"</code> | `scripts/tutorial.gd` | [L127](../scripts/tutorial.gd#L127) | func _detect |
| TUTORIAL-0116 | <code>"guide_sleep"</code> | `scripts/tutorial.gd` | [L128](../scripts/tutorial.gd#L128) | func _detect |
| TUTORIAL-0117 | <code>"Make the bed, then E to rest and end the day. Sleeping starts the next day; bedtime fullness affects tomorrow's Mood. Meals and breaks need planning too."</code> | `scripts/tutorial.gd` | [L128](../scripts/tutorial.gd#L128) | func _detect |
| TUTORIAL-0118 | <code>"Bed"</code> | `scripts/tutorial.gd` | [L128](../scripts/tutorial.gd#L128) | func _detect |
| TUTORIAL-0120 | <code>"guide_pause"</code> | `scripts/tutorial.gd` | [L130](../scripts/tutorial.gd#L130) | func _detect |
| TUTORIAL-0121 | <code>"Esc opens Pause. Exit Tutorial returns to the menu; your campaign save stays untouched. In a campaign, save when free or review the rules. Tasks offer Watch, 6x, Skip and Eject; ejecting keeps spent time without a reward."</code> | `scripts/tutorial.gd` | [L130](../scripts/tutorial.gd#L130) | func _detect |
| TUTORIAL-0122 | <code>"controls"</code> | `scripts/tutorial.gd` | [L130](../scripts/tutorial.gd#L130) | func _detect |
| TUTORIAL-0123 | <code>"not enough time"</code> | `scripts/tutorial.gd` | [L135](../scripts/tutorial.gd#L135) | func _feedback |
| TUTORIAL-0124 | <code>"full repair needs"</code> | `scripts/tutorial.gd` | [L135](../scripts/tutorial.gd#L135) | func _feedback |
| TUTORIAL-0125 | <code>"time"</code> | `scripts/tutorial.gd` | [L136](../scripts/tutorial.gd#L136) | func _feedback |
| TUTORIAL-0126 | <code>"A full activity must fit before 8 PM, including tap penalties for research. Check remaining time or choose a shorter activity. A rejected start spends no session or reward."</code> | `scripts/tutorial.gd` | [L136](../scripts/tutorial.gd#L136) | func _feedback |
| TUTORIAL-0127 | <code>"clock"</code> | `scripts/tutorial.gd` | [L136](../scripts/tutorial.gd#L136) | func _feedback |
| TUTORIAL-0128 | <code>"sleep_hungry_%d"</code> | `scripts/tutorial.gd` | [L140](../scripts/tutorial.gd#L140) | func warn_before_sleep Formatting arguments: % GameState.day |
| TUTORIAL-0129 | <code>"Sleeping below 70 fullness lowers tomorrow's starting Mood; very low fullness is worse. Consider eating first. Dismiss this tip, then E at the bed again if you're ready."</code> | `scripts/tutorial.gd` | [L144](../scripts/tutorial.gd#L144) | func warn_before_sleep |
| TUTORIAL-0130 | <code>"Fridge"</code> | `scripts/tutorial.gd` | [L144](../scripts/tutorial.gd#L144) | func warn_before_sleep |
| TUTORIAL-0154 | <code>"Player"</code> | `scripts/tutorial.gd` | [L222](../scripts/tutorial.gd#L222) | func _bounds |
| TUTORIAL-0155 | <code>"TipTop"</code> | `scripts/tutorial.gd` | [L222](../scripts/tutorial.gd#L222) | func _bounds |
| TUTORIAL-0156 | <code>"Visual"</code> | `scripts/tutorial.gd` | [L223](../scripts/tutorial.gd#L223) | func _bounds |
| TUTORIAL-0157 | <code>"Visual"</code> | `scripts/tutorial.gd` | [L228](../scripts/tutorial.gd#L228) | func _bounds |
| TUTORIAL-0158 | <code>"Quick tip"</code> | `scripts/tutorial.gd` | [L246](../scripts/tutorial.gd#L246) | func _process |
| TUTORIAL-0159 | <code>"guided"</code> | `scripts/tutorial.gd` | [L246](../scripts/tutorial.gd#L246) | func _process |
| TUTORIAL-0160 | <code>"Getting settled"</code> | `scripts/tutorial.gd` | [L246](../scripts/tutorial.gd#L246) | func _process |
| TUTORIAL-0162 | <code>" · %d / 8"</code> | `scripts/tutorial.gd` | [L252](../scripts/tutorial.gd#L252) | func _process Formatting arguments: % (read_count + 1) |
| TUTORIAL-0163 | <code>"text"</code> | `scripts/tutorial.gd` | [L253](../scripts/tutorial.gd#L253) | func _process |
| TUTORIAL-0165 | <code>"Player"</code> | `scripts/tutorial.gd` | [L268](../scripts/tutorial.gd#L268) | func _place_instruction |
| TUTORIAL-0166 | <code>"TipTop"</code> | `scripts/tutorial.gd` | [L269](../scripts/tutorial.gd#L269) | func _place_instruction |

## themes/cozy.tres

| ID | Current text / source literal | File path | Location | Context / template variables |
|---|---|---|---|---|
| COZY-0001 | <code>"Theme"</code> | `themes/cozy.tres` | [L1](../themes/cozy.tres#L1) | file constants / initial values |
