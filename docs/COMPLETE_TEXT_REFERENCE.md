# Complete game text reference

Edit JSON `text` values. Placeholders supply live values; `order` binds arguments and `variables` preserves numeric formatting. Source references are a static snapshot. [How to edit](HOW_TO_EDIT_GAME_TEXT.md) · [Exceptions](REMAINING_HARDCODED_TEXT.md).

## data/text/activities.json

| Text ID | Current Text | JSON File | Where It Appears | Variables |
|---|---|---|---|---|
| `activities.ask_tiptop_to_swat_mosquitoes_free` | Ask TipTop to swat mosquitoes — free | `data/text/activities.json` | scripts/hud.gd:271 household_choices | — |
| `activities.cancel` | Cancel | `data/text/activities.json` | scripts/hud.gd:272 household_choices; scripts/hud.gd:1196 _build_repair_menu | — |
| `activities.clean_dishes` | Wash dishes / clean sink — {duration} min | `data/text/activities.json` | scripts/hud.gd:267 household_choices | duration: %d |
| `activities.clean_s_myself_d_min` | Clean {routine} myself — {duration} min | `data/text/activities.json` | scripts/hud.gd:267 household_choices | routine: %s, duration: %d |
| `activities.eat_at_the_coffee_table_30_min_40_fullness_10_mood` | Eat at the coffee table — 30 min, +40 Fullness, +10 Mood | `data/text/activities.json` | scripts/hud.gd:258 household_choices | — |
| `activities.efficiency_d_reward_1f_research_s` | Efficiency: {efficiency}% &#124; Reward: +{reward}% research{modifier} | `data/text/activities.json` | scripts/hud.gd:245 household_choices | efficiency: %d, reward: %.1f, modifier: %s |
| `activities.eject_task` | Eject task | `data/text/activities.json` | scripts/hud.gd:1421 _build_eject_confirmation | — |
| `activities.eject_unfinished_task` | Eject unfinished task? | `data/text/activities.json` | scripts/hud.gd:1417 _build_eject_confirmation | — |
| `activities.elapsed_time_stays_spent_no_completion_reward_a_started_resear` | Elapsed time stays spent. No completion reward.<br>A started research session stays used. | `data/text/activities.json` | scripts/hud.gd:1418 _build_eject_confirmation | — |
| `activities.fast_forward_6x` | Fast-forward · 6x | `data/text/activities.json` | scripts/hud.gd:251 household_choices | — |
| `activities.keep_working` | Keep working | `data/text/activities.json` | scripts/hud.gd:1421 _build_eject_confirmation | — |
| `activities.organize_books_myself_20_min` | Organize books myself — 20 min | `data/text/activities.json` | scripts/hud.gd:261 household_choices | — |
| `activities.play_phone_games_30_min_30_mood` | Play phone games — 30 min, +30 Mood | `data/text/activities.json` | scripts/hud.gd:255 household_choices | — |
| `activities.pushing_through` |  (pushing through) | `data/text/activities.json` | scripts/hud.gd:245 household_choices | — |
| `activities.ready_to_research` | Ready to research | `data/text/activities.json` | scripts/hud.gd:249 household_choices; scripts/hud.gd:840 _update_sidebar | — |
| `activities.repair_tiptop` | Repair TipTop... | `data/text/activities.json` | scripts/hud.gd:265 household_choices | — |
| `activities.research_unavailable` | Research unavailable | `data/text/activities.json` | scripts/hud.gd:249 household_choices | — |
| `activities.s_d_game_min_watch_1f_real_min` | {difficulty} · {duration} game min · Watch ~{watch_minutes} real min | `data/text/activities.json` | scripts/hud.gd:248 household_choices | difficulty: %s, duration: %d, watch_minutes: %.1f |
| `activities.sessions_d_used_d_d_left` | Sessions: {used} used · {remaining}/{limit} left | `data/text/activities.json` | scripts/hud.gd:243 household_choices | used: %d, remaining: %d, limit: %d |
| `activities.solve_rubik_s_cube_20_min_25_mood` | Solve Rubik's cube — 20 min, +25 Mood | `data/text/activities.json` | scripts/hud.gd:256 household_choices | — |
| `activities.swat_mosquitoes_myself_5_min` | Swat mosquitoes myself — 5 min | `data/text/activities.json` | scripts/hud.gd:270 household_choices | — |
| `activities.take_a_break` | Take a break | `data/text/activities.json` | scripts/hud.gd:253 household_choices | — |
| `activities.talk_to_tiptop` | Talk to TipTop | `data/text/activities.json` | scripts/hud.gd:263 household_choices | — |
| `activities.tidy_references` | Put references back — {duration} min | `data/text/activities.json` | scripts/hud.gd:261 household_choices | duration: %d |
| `activities.watch_reels_15_min_18_mood` | Watch reels — 15 min, +18 Mood | `data/text/activities.json` | scripts/hud.gd:254 household_choices | — |
## data/text/dialogue.json

| Text ID | Current Text | JSON File | Where It Appears | Variables |
|---|---|---|---|---|
| `dialogue.10_research_proactive_fix` | +10% Research — Proactive Fix! | `data/text/dialogue.json` | scripts/hud.gd:1950 _on_story_event | — |
| `dialogue.a_brief_pause_between_helpful_activities_very_strategic` | A brief pause between helpful activities. Very strategic. | `data/text/dialogue.json` | scripts/hud.gd:173 talk_to_tiptop | — |
| `dialogue.according_to_my_latest_calculations_no` | According to my latest calculations... no. | `data/text/dialogue.json` | scripts/hud.gd:1980 _on_story_event | — |
| `dialogue.after_a_very_long_nap` | After a very long nap. | `data/text/dialogue.json` | scripts/hud.gd:1984 _on_story_event | — |
| `dialogue.an_encouraging_level_of_cooperation` | An encouraging level of cooperation. | `data/text/dialogue.json` | scripts/hud.gd:176 talk_to_tiptop | — |
| `dialogue.are_we_ready_for_the_showcase` | Are we ready for the showcase? | `data/text/dialogue.json` | scripts/hud.gd:178 talk_to_tiptop | — |
| `dialogue.bow_routine_confirmed_no_water_required` | Bow routine confirmed. No water required. | `data/text/dialogue.json` | scripts/hud.gd:1982 _on_story_event | — |
| `dialogue.carry_on_chief` | Carry on, chief. | `data/text/dialogue.json` | scripts/hud.gd:175 talk_to_tiptop | — |
| `dialogue.for_what` | For what? | `data/text/dialogue.json` | scripts/hud.gd:1968 _on_story_event | — |
| `dialogue.getting_there_my_notes_are_starting_to_look_suspiciously_usefu` | Getting there. My notes are starting to look suspiciously useful. | `data/text/dialogue.json` | scripts/hud.gd:178 talk_to_tiptop | — |
| `dialogue.great_we_ll_need_another_draft` | Great. We'll need another draft. | `data/text/dialogue.json` | scripts/hud.gd:1980 _on_story_event | — |
| `dialogue.how_s_the_extremely_important_robot_business` | How's the extremely important robot business? | `data/text/dialogue.json` | scripts/game_state.gd:295 judy_response; scripts/hud.gd:175 talk_to_tiptop | — |
| `dialogue.i_apologize` | I apologize. | `data/text/dialogue.json` | scripts/hud.gd:1968 _on_story_event | — |
| `dialogue.i_can_help_with_the_next_draft` | I can help with the next draft. | `data/text/dialogue.json` | scripts/hud.gd:1980 _on_story_event | — |
| `dialogue.i_have_not_determined_that_yet` | I have not determined that yet. | `data/text/dialogue.json` | scripts/hud.gd:1968 _on_story_event | — |
| `dialogue.i_just_moved_my_chair` | I just moved my chair. | `data/text/dialogue.json` | scripts/hud.gd:1970 _on_story_event | — |
| `dialogue.i_ll_take_any_good_news_you_ve_got` | I'll take any good news you've got. | `data/text/dialogue.json` | scripts/hud.gd:1980 _on_story_event | — |
| `dialogue.i_m_tiptop_i_handle_routines_usually_the_right_ones` | I'm TipTop! I handle routines. Usually the right ones. | `data/text/dialogue.json` | scripts/hud.gd:1962 _on_story_event | — |
| `dialogue.i_shall_provide_supportive_hovering` | I shall provide supportive hovering. | `data/text/dialogue.json` | scripts/hud.gd:178 talk_to_tiptop | — |
| `dialogue.i_shall_supervise_the_apartment_while_you_rest` | I shall supervise the apartment while you rest. | `data/text/dialogue.json` | scripts/hud.gd:1987 _on_story_event | — |
| `dialogue.i_ve_resumed_the_flowing_ideas_procedure` | I've resumed the flowing-ideas procedure. | `data/text/dialogue.json` | scripts/hud.gd:1974 _on_story_event | — |
| `dialogue.i_was_checking_the_s_it_appreciates_the_attention` | I was checking the {routine}. It appreciates the attention. | `data/text/dialogue.json` | scripts/hud.gd:171 talk_to_tiptop | routine: %s |
| `dialogue.ideas_flowing_protocol_step_4_leave_tap_open_complete_proceedi` | Ideas Flowing Protocol, step 4: Leave tap open. Complete. Proceeding to next objective. | `data/text/dialogue.json` | scripts/hud.gd:1964 _on_story_event | — |
| `dialogue.it_wasn_t_exactly_what_i_planned_still_we_got_up_here` | It wasn't exactly what I planned. Still, we got up here. | `data/text/dialogue.json` | scripts/hud.gd:1984 _on_story_event | — |
| `dialogue.judy_actual_water_bold_interpretation_buddy` | Actual water. Bold interpretation, buddy. | `data/text/dialogue.json` | scripts/game_state.gd:296 judy_response | — |
| `dialogue.judy_four_hours_science_really_needs_a_snooze_button` | Four hours? Science really needs a snooze button. | `data/text/dialogue.json` | scripts/game_state.gd:297 judy_response | — |
| `dialogue.judy_give_me_the_short_version_buddy` | Give me the short version, buddy. | `data/text/dialogue.json` | scripts/game_state.gd:295 judy_response | — |
| `dialogue.judy_how_are_the_chores_going_tiptop` | How are the chores going, TipTop? | `data/text/dialogue.json` | scripts/game_state.gd:295 judy_response | — |
| `dialogue.judy_how_s_my_favorite_household_genius` | How's my favorite household genius? | `data/text/dialogue.json` | scripts/game_state.gd:295 judy_response | — |
| `dialogue.judy_i_know_buddy_i_really_need_a_minute` | I know, buddy. I really need a minute. | `data/text/dialogue.json` | scripts/game_state.gd:297 judy_response | — |
| `dialogue.judy_i_m_listening_just_a_little_slowly_today` | I'm listening. Just a little slowly today. | `data/text/dialogue.json` | scripts/game_state.gd:295 judy_response | — |
| `dialogue.judy_let_me_step_away_from_the_notes_for_a_bit` | Let me step away from the notes for a bit. | `data/text/dialogue.json` | scripts/game_state.gd:297 judy_response | — |
| `dialogue.judy_okay_you_ve_caught_me_i_ll_take_a_breather` | Okay, you've caught me. I'll take a breather. | `data/text/dialogue.json` | scripts/game_state.gd:297 judy_response | — |
| `dialogue.judy_right_the_tap_again_give_me_a_minute` | Right. The tap again. Give me a minute. | `data/text/dialogue.json` | scripts/game_state.gd:296 judy_response | — |
| `dialogue.judy_that_s_actual_water_tiptop_i_ll_handle_it` | That's actual water, TipTop. I'll handle it. | `data/text/dialogue.json` | scripts/game_state.gd:296 judy_response | — |
| `dialogue.judy_that_s_water_tiptop_please_stop_the_tap` | That's water, TipTop. Please stop the tap. | `data/text/dialogue.json` | scripts/game_state.gd:296 judy_response | — |
| `dialogue.judy_the_routine_needs_a_correction_i_ll_sort_it` | The routine needs a correction. I'll sort it. | `data/text/dialogue.json` | scripts/game_state.gd:296 judy_response | — |
| `dialogue.judy_tiptop_please_i_need_a_quiet_minute` | TipTop, please. I need a quiet minute. | `data/text/dialogue.json` | scripts/game_state.gd:295 judy_response | — |
| `dialogue.judy_well_the_floor_certainly_looks_hydrated` | Well, the floor certainly looks hydrated. | `data/text/dialogue.json` | scripts/game_state.gd:296 judy_response | — |
| `dialogue.judy_yeah_i_m_running_on_fumes_here` | Yeah. I'm running on fumes here. | `data/text/dialogue.json` | scripts/game_state.gd:297 judy_response | — |
| `dialogue.judy_you_re_right_i_should_take_a_break` | You're right. I should take a break. | `data/text/dialogue.json` | scripts/game_state.gd:297 judy_response | — |
| `dialogue.judy_you_ve_completed_two_long_research_sessions_my_wellness_p` | Judy, you've completed two long research sessions. My wellness protocol recommends a break. | `data/text/dialogue.json` | scripts/hud.gd:1987 _on_story_event | — |
| `dialogue.just_bow_buddy_we_ve_earned_a_dry_floor` | Just bow, buddy. We've earned a dry floor. | `data/text/dialogue.json` | scripts/hud.gd:1982 _on_story_event | — |
| `dialogue.let_s_skip_that_bit_yeah` | Let's skip that bit, yeah? | `data/text/dialogue.json` | scripts/hud.gd:1976 _on_story_event | — |
| `dialogue.morning_no_dripping_i_could_get_used_to_this` | Morning. No dripping. I could get used to this. | `data/text/dialogue.json` | scripts/hud.gd:1974 _on_story_event | — |
| `dialogue.morning_right_your_routine_i_still_haven_t_fixed_that` | Morning. Right, your routine. I still haven't fixed that. | `data/text/dialogue.json` | scripts/hud.gd:1974 _on_story_event | — |
| `dialogue.mostly_notes_some_of_them_even_agree_with_each_other` | Mostly notes. Some of them even agree with each other. | `data/text/dialogue.json` | scripts/hud.gd:176 talk_to_tiptop | — |
| `dialogue.my_calculations_were_only_occasionally_incorrect` | My calculations were only occasionally incorrect. | `data/text/dialogue.json` | scripts/hud.gd:1982 _on_story_event | — |
| `dialogue.my_new_routine_agrees` | My new routine agrees. | `data/text/dialogue.json` | scripts/hud.gd:1974 _on_story_event | — |
| `dialogue.nice_now_where_d_i_put_my_notes` | Nice. Now where'd I put my notes? | `data/text/dialogue.json` | scripts/hud.gd:1976 _on_story_event | — |
| `dialogue.no_correction_received_current_routine_must_be_acceptable` | No correction received. Current routine must be acceptable! | `data/text/dialogue.json` | scripts/hud.gd:1989 _on_story_event | — |
| `dialogue.occasionally` | Occasionally? | `data/text/dialogue.json` | scripts/hud.gd:1982 _on_story_event | — |
| `dialogue.okay_judy_three_days_let_s_make_this_look_like_science` | Okay, Judy. Three days. Let's make this look like science. | `data/text/dialogue.json` | scripts/hud.gd:1962 _on_story_event | — |
| `dialogue.one_more_bit_of_research_then_i_ll_fix_it_that_s_the_plan_anyw` | One more bit of research, then I'll fix it. That's the plan, anyway. | `data/text/dialogue.json` | scripts/hud.gd:1989 _on_story_event | — |
| `dialogue.research_update_requested` | Research update requested! | `data/text/dialogue.json` | scripts/hud.gd:176 talk_to_tiptop | — |
| `dialogue.right_notes_coffee_probably_some_science_in_here_somewhere` | Right. Notes, coffee... probably some science in here somewhere. | `data/text/dialogue.json` | scripts/hud.gd:1960 _on_story_event | — |
| `dialogue.routine_updated_ideas_may_flow_without_water_thank_you_for_tea` | Routine updated: ideas may flow without water. Thank you for teaching me, Judy. | `data/text/dialogue.json` | scripts/hud.gd:1966 _on_story_event | — |
| `dialogue.showcase_day_my_tap_routine_is_ready_to_do_nothing` | Showcase day! My tap routine is ready to do nothing. | `data/text/dialogue.json` | scripts/hud.gd:1976 _on_story_event | — |
| `dialogue.showcase_day_shall_i_demonstrate_the_water_feature` | Showcase day! Shall I demonstrate the water feature? | `data/text/dialogue.json` | scripts/hud.gd:1976 _on_story_event | — |
| `dialogue.showcase_on_day_three_tiptop_try_to_look_busy` | Showcase on day three, TipTop. Try to look busy. | `data/text/dialogue.json` | scripts/hud.gd:1962 _on_story_event | — |
| `dialogue.so_the_water_feature_was_a_success` | So the water feature was a success? | `data/text/dialogue.json` | scripts/hud.gd:1984 _on_story_event | — |
| `dialogue.speaker_judy` | Judy | `data/text/dialogue.json` | hud.gd:_advance_dialogue and speaker display | — |
| `dialogue.speaker_system` | System | `data/text/dialogue.json` | hud.gd:_advance_dialogue and speaker display | — |
| `dialogue.speaker_tiptop` | TipTop | `data/text/dialogue.json` | scripts/title.gd:265 _show_help | — |
| `dialogue.thank_you_judy` | Thank you, Judy. | `data/text/dialogue.json` | scripts/hud.gd:1970 _on_story_event | — |
| `dialogue.that_bit_wasn_t_in_the_demo_glad_you_came_though` | That bit wasn't in the demo. Glad you came, though. | `data/text/dialogue.json` | scripts/hud.gd:1984 _on_story_event | — |
| `dialogue.that_went_well_i_apologize` | That went well. I apologize. | `data/text/dialogue.json` | scripts/hud.gd:1972 _on_story_event | — |
| `dialogue.then_the_apology_may_belong_to_something_else` | Then the apology may belong to something else. | `data/text/dialogue.json` | scripts/hud.gd:1972 _on_story_event | — |
| `dialogue.there_we_go_knew_you_had_it_in_you` | There we go. Knew you had it in you. | `data/text/dialogue.json` | scripts/hud.gd:1966 _on_story_event | — |
| `dialogue.they_re_applauding_celebration_routine_ready` | They're applauding! Celebration routine ready. | `data/text/dialogue.json` | scripts/hud.gd:1982 _on_story_event | — |
| `dialogue.thought_we_d_run_out_of_time_couldn_t_have_done_this_without_y` | Thought we'd run out of time. Couldn't have done this without you, buddy. | `data/text/dialogue.json` | scripts/hud.gd:1982 _on_story_event | — |
| `dialogue.tiptop_please_tell_me_that_s_supposed_to_happen` | TipTop. Please tell me that's supposed to happen. | `data/text/dialogue.json` | scripts/hud.gd:1980 _on_story_event | — |
| `dialogue.we_are_no_longer_behind_schedule` | We are no longer behind schedule. | `data/text/dialogue.json` | scripts/hud.gd:1980 _on_story_event | — |
| `dialogue.we_ve_got_results_now_i_just_have_to_explain_them` | We've got results. Now I just have to explain them. | `data/text/dialogue.json` | scripts/hud.gd:178 talk_to_tiptop | — |
| `dialogue.would_you_like_to_schedule_a_second_attempt` | Would you like to schedule a second attempt? | `data/text/dialogue.json` | scripts/hud.gd:1984 _on_story_event | — |
| `dialogue.yeah_furniture_gets_everyone_eventually` | Yeah, furniture gets everyone eventually. | `data/text/dialogue.json` | scripts/hud.gd:177 talk_to_tiptop | — |
| `dialogue.yes_i_am_checking_the_connection` | Yes. I am checking the connection. | `data/text/dialogue.json` | scripts/hud.gd:1970 _on_story_event | — |
| `dialogue.yes_i_am_practically_unstoppable_except_by_furniture` | Yes! I am practically unstoppable. Except by furniture. | `data/text/dialogue.json` | scripts/hud.gd:177 talk_to_tiptop | — |
| `dialogue.you_can_just_take_the_win_buddy` | You can just take the win, buddy. | `data/text/dialogue.json` | scripts/hud.gd:1972 _on_story_event | — |
| `dialogue.you_doing_okay_buddy` | You doing okay, buddy? | `data/text/dialogue.json` | scripts/hud.gd:177 talk_to_tiptop | — |
## data/text/endings.json

| Text ID | Current Text | JSON File | Where It Appears | Variables |
|---|---|---|---|---|
| `endings.against_all_odds` | AGAINST ALL ODDS | `data/text/endings.json` | scripts/showcase.gd:16 initial values | — |
| `endings.good_enough` | GOOD ENOUGH | `data/text/endings.json` | scripts/showcase.gd:16 initial values | — |
| `endings.it_s_probably_not_fine` | IT'S PROBABLY NOT FINE | `data/text/endings.json` | scripts/showcase.gd:16 initial values | — |
| `endings.main_menu` | Main Menu | `data/text/endings.json` | scripts/showcase.gd:81 _build_results | — |
| `endings.research_1f_routines_repaired_d_4` | Research: {progress}%  ·  Routines repaired: {repaired} / 4 | `data/text/endings.json` | scripts/showcase.gd:73 _build_results | progress: %.1f, repaired: %d |
| `endings.restart` | Restart | `data/text/endings.json` | scripts/showcase.gd:81 _build_results | — |
| `endings.university_research_showcase_day_3` | UNIVERSITY RESEARCH SHOWCASE  /  DAY 3 | `data/text/endings.json` | scripts/showcase.gd:25 _ready | — |
## data/text/hud.json

| Text ID | Current Text | JSON File | Where It Appears | Variables |
|---|---|---|---|---|
| `hud.a_full_session_won_t_fit_today` | A full session won't fit today. | `data/text/hud.json` | scripts/hud.gd:857 _update_sidebar | — |
| `hud.am` | AM | `data/text/hud.json` | scripts/hud.gd:412 _update_clock_hud | — |
| `hud.books_block_research` | ! Books block research | `data/text/hud.json` | scripts/hud.gd:867 _update_sidebar | — |
| `hud.books_scattered` | Books scattered | `data/text/hud.json` | scripts/hud.gd:844 _update_sidebar | — |
| `hud.checklist_heading` | TipTop | `data/text/hud.json` | scripts/hud.gd:730 _build_right_sidebar; scripts/hud.gd:768 _build_right_sidebar; scripts/hud_details.gd:17 initial values | — |
| `hud.checklist_pending` | □ {routine} | `data/text/hud.json` | scripts/hud.gd:829 _update_sidebar | routine: %s |
| `hud.cleanup` | Cleanup | `data/text/hud.json` | scripts/hud.gd:797 _build_right_sidebar | — |
| `hud.clear_the_bookshelf` | Clear the bookshelf. | `data/text/hud.json` | scripts/hud.gd:853 _update_sidebar | — |
| `hud.color_9dceac_s_s_s_color` | [color=#9dceac]✓ [s]{routine}[/s][/color] | `data/text/hud.json` | scripts/hud.gd:829 _update_sidebar | routine: %s |
| `hud.continuing` | Continuing... | `data/text/hud.json` | scripts/hud.gd:337 _ready | — |
| `hud.critical` | ! Critical | `data/text/hud.json` | scripts/hud.gd:907 _update_needs_ui | — |
| `hud.critical_fullness` | ! Critical fullness | `data/text/hud.json` | scripts/hud.gd:904 _update_needs_ui | — |
| `hud.d` |  (-{penalty}%) | `data/text/hud.json` | scripts/hud.gd:907 _update_needs_ui | penalty: %d |
| `hud.d_02d_s` | {hour}:{minute} {period} | `data/text/hud.json` | scripts/hud.gd:412 _update_clock_hud | hour: %d, minute: %02d, period: %s |
| `hud.d_4_repaired` | {repaired} / 4 repaired | `data/text/hud.json` | scripts/hud.gd:838 _update_sidebar | repaired: %d |
| `hud.day_3_showcase_reach_0f_and_repair_all_routines_e_to_interact` | Day 3 showcase: reach {target}% and repair all routines.<br>E to interact. Make the bed before resting.<br>Four sessions/day; full sessions must fit before 8:00 PM. | `data/text/hud.json` | scripts/hud.gd:990 _build_loop_ui | target: %.0f |
| `hud.day_d` | Day {day} | `data/text/hud.json` | scripts/hud.gd:432 _update_hud; scripts/hud.gd:1126 _play_day_transition | day: %d |
| `hud.day_d_complete_8_00_pm_research_1f_showcase_deadline_day_3_8_0` | Day {day} complete — 8:00 PM<br>Research: {progress}%<br>Showcase deadline: Day 3, 8:00 PM | `data/text/hud.json` | scripts/hud.gd:447 _update_hud | day: %d, progress: %.1f |
| `hud.dh_02dm` | {hours}h {minutes}m | `data/text/hud.json` | scripts/hud.gd:891 _minutes_text | hours: %d, minutes: %02d |
| `hud.dh_02dm_left` | {hours}h {minutes}m left | `data/text/hud.json` | scripts/hud.gd:414 _update_clock_hud | hours: %d, minutes: %02d |
| `hud.e_enter_next` | E / Enter - Next | `data/text/hud.json` | scripts/hud.gd:1551 _build_dialogue_ui | — |
| `hud.e_interact_esc_pause` | E   Interact<br>ESC Pause | `data/text/hud.json` | scripts/hud.gd:976 _build_loop_ui | — |
| `hud.eat_before_researching` | Eat before researching. | `data/text/hud.json` | scripts/hud.gd:851 _update_sidebar | — |
| `hud.eat_before_your_next_session` | Eat before your next session. | `data/text/hud.json` | scripts/hud.gd:859 _update_sidebar | — |
| `hud.eat_soon` | ! Eat soon | `data/text/hud.json` | scripts/hud.gd:871 _update_sidebar | — |
| `hud.eating` | Eating | `data/text/hud.json` | scripts/hud.gd:797 _build_right_sidebar; scripts/hud.gd:1393 _update_activity_controls | — |
| `hud.efficiency` | Efficiency | `data/text/hud.json` | scripts/hud.gd:772 _build_right_sidebar | — |
| `hud.exit_tutorial` | Exit Tutorial | `data/text/hud.json` | scripts/hud.gd:1589 _build_pause_menu; scripts/tutorial.gd:68 _ready | — |
| `hud.food_d_yield` | Food: -{penalty}% yield | `data/text/hud.json` | scripts/hud.gd:842 _update_sidebar | penalty: %d |
| `hud.food_d_yield_meals_40_food_10_mood` | Food: -{penalty}% yield. Meals: +40 food, +10 Mood. | `data/text/hud.json` | scripts/hud.gd:913 _update_needs_ui | penalty: %d |
| `hud.full_d` | Full: {fullness}% | `data/text/hud.json` | scripts/hud.gd:895 _update_needs_ui | fullness: %d |
| `hud.fullness` | Fullness | `data/text/hud.json` | scripts/hud.gd:545 _build_needs_ui; scripts/hud.gd:811 _build_right_sidebar | — |
| `hud.fullness_must_exceed_20` | Fullness must exceed 20 | `data/text/hud.json` | scripts/hud.gd:842 _update_sidebar | — |
| `hud.game_saved` | Game saved. | `data/text/hud.json` | scripts/hud.gd:2020 _manual_save | — |
| `hud.leisure` | Leisure | `data/text/hud.json` | scripts/hud.gd:797 _build_right_sidebar | — |
| `hud.low_mood` |  / Low Mood | `data/text/hud.json` | scripts/hud.gd:911 _update_needs_ui | — |
| `hud.meal_30_min_40_food_10_mood_counts_as_a_break` | Meal: 30 min, +40 food, +10 Mood. Counts as a break. | `data/text/hud.json` | scripts/hud.gd:814 _build_right_sidebar | — |
| `hud.misc` | Misc | `data/text/hud.json` | scripts/hud.gd:797 _build_right_sidebar | — |
| `hud.monday` | Monday | `data/text/hud.json` | scripts/hud.gd:436 _update_hud; scripts/hud.gd:955 _build_loop_ui | — |
| `hud.mood` | Mood | `data/text/hud.json` | scripts/hud.gd:545 _build_needs_ui; scripts/hud.gd:812 _build_right_sidebar | — |
| `hud.mood_below_45` | Mood below 45 | `data/text/hud.json` | scripts/hud.gd:845 _update_sidebar | — |
| `hud.mood_below_45_take_a_leisure_break` | Mood below 45. Take a leisure break. | `data/text/hud.json` | scripts/hud.gd:914 _update_needs_ui | — |
| `hud.mood_blocks_research` | ! Mood blocks research | `data/text/hud.json` | scripts/hud.gd:869 _update_sidebar | — |
| `hud.mood_d` | Mood: {mood}% | `data/text/hud.json` | scripts/hud.gd:896 _update_needs_ui | mood: %d |
| `hud.mood_steady` |  / Mood steady | `data/text/hud.json` | scripts/hud.gd:911 _update_needs_ui | — |
| `hud.needs` | Needs | `data/text/hud.json` | scripts/hud.gd:730 _build_right_sidebar; scripts/hud.gd:768 _build_right_sidebar; scripts/hud_details.gd:17 initial values | — |
| `hud.next_day` | Next day | `data/text/hud.json` | scripts/hud.gd:448 _update_hud | — |
| `hud.not_enough_work_time` | ! Not enough work time | `data/text/hud.json` | scripts/hud.gd:873 _update_sidebar | — |
| `hud.paused` | Paused | `data/text/hud.json` | scripts/hud.gd:1588 _build_pause_menu | — |
| `hud.pending_dishes` | Dirty dishes | `data/text/hud.json` | scripts/hud.gd:831 _update_sidebar | — |
| `hud.pending_references` | Reference clutter | `data/text/hud.json` | scripts/hud.gd:833 _update_sidebar | — |
| `hud.percentage` | {value}% | `data/text/hud.json` | scripts/hud.gd:903 _update_needs_ui; scripts/hud.gd:909 _update_needs_ui; scripts/hud.gd:910 _update_needs_ui | value: %d |
| `hud.pm` | PM | `data/text/hud.json` | scripts/hud.gd:412 _update_clock_hud | — |
| `hud.push_through_20` | Push-through: -20% | `data/text/hud.json` | scripts/hud.gd:846 _update_sidebar | — |
| `hud.push_through_20_2` | Push through (-20%) | `data/text/hud.json` | scripts/hud.gd:902 _update_needs_ui | — |
| `hud.push_through_20_yield` | Push-through: -20% yield. | `data/text/hud.json` | scripts/hud.gd:914 _update_needs_ui | — |
| `hud.ready_for_research` | Ready for research | `data/text/hud.json` | scripts/hud.gd:902 _update_needs_ui | — |
| `hud.repairs` | Repairs | `data/text/hud.json` | scripts/hud.gd:797 _build_right_sidebar | — |
| `hud.research_1f` | Research: {progress}% | `data/text/hud.json` | scripts/hud.gd:434 _update_hud | progress: %.1f |
| `hud.research_blocked` | Research blocked | `data/text/hud.json` | scripts/hud.gd:840 _update_sidebar | — |
| `hud.research_heading` | Research | `data/text/hud.json` | scripts/hud.gd:242 household_choices; scripts/hud.gd:730 _build_right_sidebar; scripts/hud.gd:768 _build_right_sidebar; scripts/hud.gd:797 _build_right_sidebar; scripts/hud_details.gd:17 initial values; scripts/title.gd:264 _show_help | — |
| `hud.research_underway` | Research underway | `data/text/hud.json` | scripts/hud.gd:840 _update_sidebar | — |
| `hud.rest_for_more_sessions` | Rest for more sessions. | `data/text/hud.json` | scripts/hud.gd:849 _update_sidebar | — |
| `hud.rest_needed_45` | Rest needed (&lt;45) | `data/text/hud.json` | scripts/hud.gd:902 _update_needs_ui | — |
| `hud.restart_replaces_save` | Restart (replaces save) | `data/text/hud.json` | scripts/hud.gd:1589 _build_pause_menu | — |
| `hud.restart_tutorial` | Restart Tutorial | `data/text/hud.json` | scripts/hud.gd:1589 _build_pause_menu | — |
| `hud.resume` | Resume | `data/text/hud.json` | scripts/hud.gd:1589 _build_pause_menu | — |
| `hud.return_to_main_menu` | Return to Main Menu | `data/text/hud.json` | scripts/hud.gd:1589 _build_pause_menu | — |
| `hud.s_research_0f_min_0f_repair_d_min_0f` | {description}<br>Research {research_duration} min / +{research_reward}%; repair {repair_duration} min / +{repair_reward}%. | `data/text/hud.json` | scripts/hud.gd:1027 _choose_difficulty | description: %s, research_duration: %.0f, research_reward: %.0f, repair_duration: %d, repair_reward: %.0f |
| `hud.save_game` | Save Game | `data/text/hud.json` | scripts/hud.gd:1589 _build_pause_menu | — |
| `hud.shader_type_canvas_item_void_fragment_vec4_pixel_texture_textu` | shader_type canvas_item; void fragment() { vec4 pixel = texture(TEXTURE, UV); if (UV.x &lt; 0.31) { pixel.a = 0.0; } COLOR = pixel; } | `data/text/hud.json` | scripts/hud.gd:1508 _build_dialogue_ui | — |
| `hud.showcase` | Showcase | `data/text/hud.json` | scripts/hud.gd:448 _update_hud; scripts/hud.gd:1126 _play_day_transition | — |
| `hud.showcase_in_dh_02dm_playable` | Showcase in<br>{hours}h {minutes}m playable | `data/text/hud.json` | scripts/hud.gd:423 _update_clock_hud | hours: %d, minutes: %02d |
| `hud.start` | Start | `data/text/hud.json` | scripts/hud.gd:996 _build_loop_ui | — |
| `hud.take_a_coffee_table_break` | Take a coffee-table break. | `data/text/hud.json` | scripts/hud.gd:855 _update_sidebar | — |
| `hud.tap_half_reward` | Tap: half reward | `data/text/hud.json` | scripts/hud.gd:843 _update_sidebar | — |
| `hud.target_0f` | Target: {target}% | `data/text/hud.json` | scripts/hud.gd:710 _build_right_sidebar | target: %.0f |
| `hud.time_usage` | Time Usage | `data/text/hud.json` | scripts/hud.gd:730 _build_right_sidebar; scripts/hud.gd:768 _build_right_sidebar; scripts/hud_details.gd:17 initial values | — |
| `hud.tiptop_d_4_fixed` | TipTop: {repaired}/4 fixed | `data/text/hud.json` | scripts/hud.gd:837 _update_sidebar | repaired: %d |
| `hud.tiptop_mosquito_removal_requested_on_my_way` | Mosquito removal requested. On my way! | `data/text/hud.json` | scripts/hud.gd:297 _request_swatter | — |
| `hud.tiptop_no_airborne_intruders_detected` | No airborne intruders detected. | `data/text/hud.json` | scripts/game_state.gd:165 request_mosquito_batch; scripts/hud.gd:294 _request_swatter | — |
| `hud.too_hungry_to_start_research_eat_40_food_10_mood` | Too hungry to start research. Eat: +40 food, +10 Mood. | `data/text/hud.json` | scripts/hud.gd:913 _update_needs_ui | — |
| `hud.too_hungry_to_work` | ! Too hungry to work | `data/text/hud.json` | scripts/hud.gd:865 _update_sidebar | — |
| `hud.total` | Total:  | `data/text/hud.json` | scripts/hud.gd:886 _update_sidebar | — |
| `hud.tuesday` | Tuesday | `data/text/hud.json` | scripts/hud.gd:436 _update_hud | — |
| `hud.turn_off_the_tap` | Turn off the tap. | `data/text/hud.json` | scripts/hud.gd:861 _update_sidebar | — |
| `hud.wednesday` | Wednesday | `data/text/hud.json` | scripts/hud.gd:436 _update_hud | — |
| `hud.work_sessions_d_4` | Work sessions: {sessions} / 4 | `data/text/hud.json` | scripts/hud.gd:435 _update_hud | sessions: %d |
| `hud.your_desk_is_ready` | Your desk is ready. | `data/text/hud.json` | scripts/hud.gd:847 _update_sidebar | — |
## data/text/interactions.json

| Text ID | Current Text | JSON File | Where It Appears | Variables |
|---|---|---|---|---|
| `interactions.approach_the_bookshelf_and_press_e_to_organize_it_20_min` | Approach the bookshelf and press E to organize it (20 min). | `data/text/interactions.json` | scripts/player.gd:518 organize_for_research | — |
| `interactions.couldn_t_start_the_activity_no_activity_time_or_reward_applied` | Couldn't start the activity. No activity time or reward applied. | `data/text/interactions.json` | scripts/player.gd:250 personal_activity | — |
| `interactions.d_d_left` |  · {sessions}/{limit} left | `data/text/interactions.json` | scripts/player.gd:62 _update_interaction_prompt | sessions: %d, limit: %d |
| `interactions.e_cleanup_mosquitoes` | E - Cleanup / mosquitoes | `data/text/interactions.json` | scripts/player.gd:74 _update_interaction_prompt; scripts/player.gd:78 _update_interaction_prompt | — |
| `interactions.e_dry_plant_area_10_min` | E - Dry plant area (10 min) | `data/text/interactions.json` | scripts/player.gd:76 _update_interaction_prompt | — |
| `interactions.e_eat_30_min` | E - Eat (30 min) | `data/text/interactions.json` | scripts/player.gd:66 _update_interaction_prompt | — |
| `interactions.e_eat_something_first` | E - Eat something first | `data/text/interactions.json` | scripts/player.gd:60 _update_interaction_prompt | — |
| `interactions.e_make_bed_5_min` | E - Make bed (5 min) | `data/text/interactions.json` | scripts/player.gd:84 _update_interaction_prompt | — |
| `interactions.e_mop_clean_15_min` | E - Mop / clean (15 min) | `data/text/interactions.json` | scripts/player.gd:70 _update_interaction_prompt | — |
| `interactions.e_not_enough_research_time` | E - Not enough research time | `data/text/interactions.json` | scripts/player.gd:60 _update_interaction_prompt | — |
| `interactions.e_organize_books_20_min` | E - Organize books (20 min) | `data/text/interactions.json` | scripts/player.gd:80 _update_interaction_prompt | — |
| `interactions.e_research` | E - Research | `data/text/interactions.json` | scripts/player.gd:57 _update_interaction_prompt | — |
| `interactions.e_research_blocked_bookshelf` | E - Research blocked (bookshelf) | `data/text/interactions.json` | scripts/player.gd:60 _update_interaction_prompt | — |
| `interactions.e_rest` | E - Rest | `data/text/interactions.json` | scripts/player.gd:84 _update_interaction_prompt | — |
| `interactions.e_take_a_break` | E - Take a break | `data/text/interactions.json` | scripts/player.gd:68 _update_interaction_prompt | — |
| `interactions.e_take_a_break_first` | E - Take a break first | `data/text/interactions.json` | scripts/player.gd:60 _update_interaction_prompt | — |
| `interactions.e_talk_repair_tiptop` | E - Talk / Repair TipTop | `data/text/interactions.json` | scripts/player.gd:64 _update_interaction_prompt | — |
| `interactions.e_talk_to_tiptop` | E - Talk to TipTop | `data/text/interactions.json` | scripts/player.gd:64 _update_interaction_prompt | — |
| `interactions.e_tap_off` | E - Tap off | `data/text/interactions.json` | scripts/player.gd:70 _update_interaction_prompt | — |
| `interactions.e_work` | E - Work | `data/text/interactions.json` | scripts/desk.gd:17 _update_prompt | — |
| `interactions.judy_right_let_s_sort_this_out` | Right. Let's sort this out. | `data/text/interactions.json` | scripts/player.gd:490 _clean_animation | — |
| `interactions.scene_desk_promptlabel_text` | E - Work | `data/text/interactions.json` | scenes/desk.tscn:36 [node name="PromptLabel" type="Label" parent="."] | — |
| `interactions.scene_hud_daylabel_text` | Day 1 | `data/text/interactions.json` | scenes/hud.tscn:14 [node name="DayLabel" type="Label" parent="."] | — |
| `interactions.scene_hud_fixbutton_text` | Fix (30 min) | `data/text/interactions.json` | scenes/hud.tscn:61 [node name="FixButton" type="Button" parent="NotificationPanel"] | — |
| `interactions.scene_hud_ignorebutton_text` | Ignore | `data/text/interactions.json` | scenes/hud.tscn:69 [node name="IgnoreButton" type="Button" parent="NotificationPanel"] | — |
| `interactions.scene_hud_researchlabel_text` | Research: 0% | `data/text/interactions.json` | scenes/hud.tscn:31 [node name="ResearchLabel" type="Label" parent="."] | — |
| `interactions.scene_hud_timelabel_text` | 11:00 AM | `data/text/interactions.json` | scenes/hud.tscn:22 [node name="TimeLabel" type="Label" parent="."] | — |
| `interactions.tidy_references` | E - Tidy references ({duration} min) | `data/text/interactions.json` | scripts/player.gd:82 _update_interaction_prompt | duration: %d |
| `interactions.too_exhausted_to_work` | Too exhausted to work | `data/text/interactions.json` | scripts/desk.gd:17 _update_prompt; scripts/player.gd:57 _update_interaction_prompt | — |
| `interactions.wash_dishes` | E - Wash dishes ({duration} min) | `data/text/interactions.json` | scripts/player.gd:72 _update_interaction_prompt | duration: %d |
## data/text/main_menu.json

| Text ID | Current Text | JSON File | Where It Appears | Variables |
|---|---|---|---|---|
| `main_menu.1x_6x` | 1x   6x | `data/text/main_menu.json` | scripts/title.gd:345 _help_visual | — |
| `main_menu.a_fresh_start` | A fresh start | `data/text/main_menu.json` | scripts/title.gd:221 _show_difficulty | — |
| `main_menu.activity_controls` | Activity controls | `data/text/main_menu.json` | scripts/title.gd:268 _show_help | — |
| `main_menu.back` | Back | `data/text/main_menu.json` | data/rules_text.gd:6 initial values; scripts/title.gd:238 _show_difficulty; scripts/title.gd:275 _show_help; scripts/title.gd:385 _show_settings; scripts/title.gd:426 _continue_game; scripts/title.gd:434 _continue_game | — |
| `main_menu.begin_day_1` | Begin Day 1 | `data/text/main_menu.json` | scripts/title.gd:237 _show_difficulty | — |
| `main_menu.beginning_replaces_the_active_slot_previous_checkpoints_remain` | Beginning replaces the active slot. Previous checkpoints remain recoverable; your profile stays. | `data/text/main_menu.json` | scripts/title.gd:224 _show_difficulty | — |
| `main_menu.cannot_continue` | Cannot Continue | `data/text/main_menu.json` | scripts/title.gd:424 _continue_game; scripts/title.gd:432 _continue_game | — |
| `main_menu.choose_your_pace_medium_is_the_default` | Choose your pace. Medium is the default. | `data/text/main_menu.json` | scripts/title.gd:222 _show_difficulty | — |
| `main_menu.continue` | Continue | `data/text/main_menu.json` | scripts/title.gd:73 _ready | — |
| `main_menu.faulty_chores_make_messes_repair_each_routine_cleaning_alone_d` | Faulty chores make messes. Repair each routine; cleaning alone doesn't fix it. | `data/text/main_menu.json` | scripts/title.gd:265 _show_help | — |
| `main_menu.four_sessions_a_day_starting_needs_more_than_20_fullness_even` | Four sessions a day. Starting needs more than 20 Fullness, even with the final-day Mood exception. | `data/text/main_menu.json` | scripts/title.gd:264 _show_help | — |
| `main_menu.fullness_mood` | Fullness &amp; Mood | `data/text/main_menu.json` | scripts/title.gd:266 _show_help | — |
| `main_menu.how_to_play` | How to Play | `data/text/main_menu.json` | scripts/hud.gd:1589 _build_pause_menu; scripts/title.gd:251 _show_help | — |
| `main_menu.it_s_probably_fine` | IT'S PROBABLY FINE | `data/text/main_menu.json` | scripts/title.gd:58 _ready | — |
| `main_menu.judy_move_interact` | Judy · Move &amp; interact | `data/text/main_menu.json` | scripts/title.gd:263 _show_help | — |
| `main_menu.meals_give_40_fullness_and_10_mood_meals_and_leisure_reset_wor` | Meals give +40 Fullness and +10 Mood. Meals and leisure reset work streaks, not the daily session limit. | `data/text/main_menu.json` | scripts/title.gd:266 _show_help | — |
| `main_menu.new_game` | New Game | `data/text/main_menu.json` | scripts/hud.gd:1154 _reveal_new_game; scripts/title.gd:74 _ready | — |
| `main_menu.optional_practice_campaign_saves_stay_untouched_esc_exit_tutor` | Optional practice; campaign saves stay untouched. Esc → Exit Tutorial returns here. | `data/text/main_menu.json` | scripts/title.gd:276 _show_help | — |
| `main_menu.play_tutorial` | Play Tutorial | `data/text/main_menu.json` | scripts/title.gd:221 _show_difficulty; scripts/title.gd:237 _show_difficulty; scripts/title.gd:274 _show_help | — |
| `main_menu.practice_in_a_separate_apartment_your_campaign_save_and_campai` | Practice in a separate apartment. Your campaign save and campaign time stay untouched. Esc → Exit Tutorial returns here. | `data/text/main_menu.json` | scripts/title.gd:222 _show_difficulty | — |
| `main_menu.profile_unreadable_history_settings_cannot_be_saved_original_f` | Profile unreadable: history/settings cannot be saved. Original files preserved. | `data/text/main_menu.json` | scripts/title.gd:172 _process | — |
| `main_menu.quit_game` | Quit Game | `data/text/main_menu.json` | scripts/hud.gd:1589 _build_pause_menu; scripts/title.gd:77 _ready | — |
| `main_menu.reach_75_research_by_day_3_8_pm_sleep_at_the_bed_to_advance_da` | Reach 75% research by Day 3, 8 PM. Sleep at the bed to advance days. | `data/text/main_menu.json` | scripts/title.gd:267 _show_help | — |
| `main_menu.replace_save_begin` | Replace Save &amp; Begin | `data/text/main_menu.json` | scripts/title.gd:237 _show_difficulty | — |
| `main_menu.s_research_d_base_d_min_routine_repair_d_min` | {description}<br>Research: +{reward}% base / {duration} min. Routine repair: {repair_duration} min. | `data/text/main_menu.json` | scripts/title.gd:247 _select_difficulty | description: %s, reward: %d, duration: %d, repair_duration: %d |
| `main_menu.settings` | Settings | `data/text/main_menu.json` | scripts/title.gd:76 _ready; scripts/title.gd:350 _show_settings | — |
| `main_menu.the_apartment_scene_could_not_be_opened_your_save_is_intact` | The apartment scene could not be opened. Your save is intact. | `data/text/main_menu.json` | scripts/title.gd:433 _continue_game | — |
| `main_menu.three_days_one_robot_what_could_go_wrong` | Three days. One robot. What could go wrong? | `data/text/main_menu.json` | scripts/title.gd:62 _ready | — |
| `main_menu.time_deadline` | Time &amp; deadline | `data/text/main_menu.json` | scripts/title.gd:267 _show_help | — |
| `main_menu.tutorial_how_to_play` | Tutorial / How to Play | `data/text/main_menu.json` | scripts/title.gd:75 _ready | — |
| `main_menu.wasd_arrows_move_e_interacts_e_enter_advances_dialogue_tab_ins` | WASD / arrows move. E interacts; E / Enter advances dialogue. Tab inspects the HUD; Tab returns to movement. | `data/text/main_menu.json` | scripts/title.gd:263 _show_help | — |
| `main_menu.watch_1x_fast_6x_or_skip_to_finish_eject_cancels_without_a_com` | Watch 1x, Fast 6x or Skip to finish. Eject cancels without a completion reward. | `data/text/main_menu.json` | scripts/title.gd:268 _show_help | — |
| `main_menu.window_title` | its-probably-fine | `data/text/main_menu.json` | game_text.gd:_ready / native window caption | — |
## data/text/notifications.json

| Text ID | Current Text | JSON File | Where It Appears | Variables |
|---|---|---|---|---|
| `notifications.a_full_repair_needs_d_minutes_before_8_00_pm_no_time_or_reward` | A full repair needs {duration} minutes before 8:00 PM. No time or reward charged. | `data/text/notifications.json` | scripts/game_state.gd:761 repair_routine | duration: %d |
| `notifications.break_finished_feeling_more_like_myself` | Break finished. Feeling more like myself. | `data/text/notifications.json` | scripts/game_state.gd:350 advance_personal_activity | — |
| `notifications.hungry` | Hungry | `data/text/notifications.json` | scripts/game_state.gd:177 hunger_status | — |
| `notifications.judy_is_pushing_through_exhaustion_an_extra_20_research_penalt` | Judy is pushing through exhaustion: an extra 20% research penalty. | `data/text/notifications.json` | scripts/game_state.gd:387 begin_research | — |
| `notifications.judy_is_too_hungry_to_work_eat_something_first` | Judy is too hungry to work. Eat something first. | `data/text/notifications.json` | scripts/game_state.gd:594 research_block_reason | — |
| `notifications.judy_needs_a_break_restore_mood_to_at_least_45_before_research` | Judy needs a break. Restore Mood to at least 45% before researching. | `data/text/notifications.json` | scripts/game_state.gd:596 research_block_reason | — |
| `notifications.make_the_bed_first_e_5_min_or_let_the_repaired_bed_routine_han` | Make the bed first (E, 5 min), or let the repaired bed routine handle it. | `data/text/notifications.json` | scripts/game_state.gd:715 end_day | — |
| `notifications.meal_finished_40_fullness_10_mood_work_streak_reset` | Meal finished: +40 Fullness, +10 Mood. Work streak reset. | `data/text/notifications.json` | scripts/game_state.gd:350 advance_personal_activity | — |
| `notifications.mosquitoes_reduced_remove_standing_water_to_keep_them_away` | Mosquitoes reduced. Remove standing water to keep them away. | `data/text/notifications.json` | scripts/game_state.gd:561 swat_mosquitoes | — |
| `notifications.normal` | Normal | `data/text/notifications.json` | scripts/game_state.gd:177 hunger_status | — |
| `notifications.not_enough_time_before_8_00_pm_a_full_research_session_needs_d` | Not enough time before 8:00 PM. A full research session needs {duration} minutes; no session used. | `data/text/notifications.json` | scripts/game_state.gd:598 research_block_reason | duration: %d |
| `notifications.not_enough_time_before_8_00_pm_for_that_activity` | Not enough time before 8:00 PM for that activity. | `data/text/notifications.json` | scripts/game_state.gd:280 start_personal_activity; scripts/player.gd:236 personal_activity | — |
| `notifications.research_complete_1f_d_min_d_session_s_left` | Research complete: +{gain}%, {duration} min, {sessions} session(s) left. | `data/text/notifications.json` | scripts/game_state.gd:541 complete_research | gain: %.1f, duration: %d, sessions: %d |
| `notifications.research_materials_are_misplaced_organize_the_bookshelf_20_min` | Research materials are misplaced. Organize the bookshelf (20 min). | `data/text/notifications.json` | scripts/game_state.gd:599 research_block_reason | — |
| `notifications.s_routine_repaired_0f_research_d_min` | {routine} routine repaired: +{reward}% research. (-{duration} min) | `data/text/notifications.json` | scripts/game_state.gd:779 repair_routine | routine: %s, reward: %.0f, duration: %d |
| `notifications.s_tidied_routine_unchanged_d_min` | {routine} tidied. Routine unchanged. (-{duration} min) | `data/text/notifications.json` | scripts/game_state.gd:626 manual_clean | routine: %s, duration: %d |
| `notifications.task_ejected_elapsed_time_kept_no_completion_reward` | Task ejected. Elapsed time kept; no completion reward. | `data/text/notifications.json` | scripts/game_state.gd:158 eject_current_task | — |
| `notifications.tiptop_left_the_tap_running` | TipTop left the tap running! | `data/text/notifications.json` | scripts/game_state.gd:744 _check_malfunction | — |
| `notifications.tiptop_left_the_tap_running_again` | TipTop left the tap running... again! | `data/text/notifications.json` | scripts/game_state.gd:744 _check_malfunction | — |
| `notifications.tiptop_s_routine_updated_thank_you_judy` | {routine} routine updated. Thank you, Judy! | `data/text/notifications.json` | scripts/game_state.gd:785 repair_routine | routine: %s |
| `notifications.tiptop_still_has_faulty_routines_repair_before_resting` | TipTop still has faulty routines. Repair before resting? | `data/text/notifications.json` | scripts/game_state.gd:721 end_day | — |
| `notifications.turn_off_the_tap_before_mopping` | Turn off the tap before mopping. | `data/text/notifications.json` | scripts/game_state.gd:619 manual_clean | — |
| `notifications.well_fed` | Well-fed | `data/text/notifications.json` | scripts/game_state.gd:177 hunger_status | — |
## data/text/research.json

| Text ID | Current Text | JSON File | Where It Appears | Variables |
|---|---|---|---|---|
| `research.cancel_without_a_completion_reward` | Cancel without a completion reward. | `data/text/research.json` | scripts/hud.gd:1341 _build_research_controls; scripts/hud.gd:1368 _update_activity_controls | — |
| `research.difficulty_easy` | Easy | `data/text/research.json` | scripts/game_state.gd:20 initial values | — |
| `research.difficulty_hard` | Hard | `data/text/research.json` | scripts/game_state.gd:22 initial values | — |
| `research.difficulty_less_research_and_faster_needs_depletion` | Less research and faster needs depletion. | `data/text/research.json` | scripts/game_state.gd:22 initial values | — |
| `research.difficulty_medium` | Medium | `data/text/research.json` | scripts/game_state.gd:21 initial values | — |
| `research.difficulty_more_research_shorter_repairs_gentler_needs` | More research, shorter repairs, gentler needs. | `data/text/research.json` | scripts/game_state.gd:20 initial values | — |
| `research.difficulty_the_established_balance_with_repair_rewards` | The established balance, with repair rewards. | `data/text/research.json` | scripts/game_state.gd:21 initial values | — |
| `research.eject` | Eject... | `data/text/research.json` | scripts/hud.gd:1341 _build_research_controls | — |
| `research.fast_6x` | Fast 6x | `data/text/research.json` | scripts/hud.gd:1341 _build_research_controls | — |
| `research.finish_now_full_time_cost_applies` | Finish now. Full time cost applies. | `data/text/research.json` | scripts/hud.gd:1341 _build_research_controls | — |
| `research.phone_games` | Phone games | `data/text/research.json` | scripts/hud.gd:1393 _update_activity_controls | — |
| `research.play_at_6x_speed` | Play at 6x speed. | `data/text/research.json` | scripts/hud.gd:1341 _build_research_controls | — |
| `research.play_at_normal_speed` | Play at normal speed. | `data/text/research.json` | scripts/hud.gd:1341 _build_research_controls | — |
| `research.reels` | Reels | `data/text/research.json` | scripts/hud.gd:1393 _update_activity_controls | — |
| `research.research_d_d_min_dx` | Research: {elapsed} / {duration} min · {speed}x | `data/text/research.json` | scripts/hud.gd:1386 _update_activity_controls | elapsed: %d, duration: %d, speed: %d |
| `research.rubik_s_cube` | Rubik's cube | `data/text/research.json` | scripts/hud.gd:1393 _update_activity_controls | — |
| `research.s_d_d_min_dx` | {activity}: {elapsed} / {duration} min · {speed}x | `data/text/research.json` | scripts/hud.gd:1394 _update_activity_controls | activity: %s, elapsed: %d, duration: %d, speed: %d |
| `research.skip` | Skip | `data/text/research.json` | scripts/hud.gd:1341 _build_research_controls | — |
| `research.start` | Watch Research | `data/text/research.json` | scripts/hud.gd:250 household_choices | — |
| `research.swat` |  · Swat! | `data/text/research.json` | scripts/hud.gd:1388 _update_activity_controls | — |
| `research.too_exhausted_to_work_rest_until_tomorrow` | Too exhausted to work. Rest until tomorrow. | `data/text/research.json` | scripts/game_state.gd:592 research_block_reason; scripts/hud.gd:139 research_choices | — |
| `research.unavailable_while_paused_or_finishing` | Unavailable while paused or finishing. | `data/text/research.json` | scripts/hud.gd:1368 _update_activity_controls | — |
| `research.watch_1x` | Watch 1x | `data/text/research.json` | scripts/hud.gd:1341 _build_research_controls | — |
## data/text/rules.json

| Text ID | Current Text | JSON File | Where It Appears | Variables |
|---|---|---|---|---|
| `rules.1_the_goal_deadline` | 1 · The goal &amp; deadline | `data/text/rules.json` | data/rules_text.gd:16 pages | — |
| `rules.2_research_your_time` | 2 · Research &amp; your time | `data/text/rules.json` | data/rules_text.gd:18 pages | — |
| `rules.3_fullness_mood_breaks` | 3 · Fullness, Mood &amp; breaks | `data/text/rules.json` | data/rules_text.gd:20 pages | — |
| `rules.4_tiptop_a_balanced_day` | 4 · TipTop &amp; a balanced day | `data/text/rules.json` | data/rules_text.gd:22 pages | — |
| `rules.approach_the_desk_and_press_e_you_have_up_to_d_sessions_each_d` | Approach the desk and press E. You have up to {sessions} sessions each day. On {difficulty}, a standard session takes {duration} game minutes for +{reward}% base research. A full session must fit before 8 PM.<br><br>The clock also runs while you explore. Watch, Fast 6x and Skip apply the same time and consequences. Skip is faster for you, not for Judy. Eject keeps time already spent and gives no completion reward.<br><br>A running tap adds one-third to session time and halves research gains. Scattered books block work; organizing them takes 20 minutes. | `data/text/rules.json` | data/rules_text.gd:19 pages | sessions: %d, difficulty: %s, duration: %d, reward: %.0f |
| `rules.back_to_game` | Back to game | `data/text/rules.json` | data/rules_text.gd:9 initial values | — |
| `rules.e_enter_next_page_tab_select_a_button` | E / Enter: next page · Tab: select a button | `data/text/rules.json` | data/rules_text.gd:10 initial values | — |
| `rules.higher_fullness_is_better_research_needs_more_than_20_fullness` | Higher Fullness is better. Research needs more than 20 Fullness. Below 60, research yield falls: 90% from 30 to below 60, 75% below 30, and 60% at zero.<br><br>Research normally needs at least 45 Mood. From 2 PM on Day 3, Judy can push through low Mood with 20% less yield; she still needs more than 20 Fullness.<br><br>A 30-minute fridge meal restores 40 Fullness and 10 Mood. Reels, phone games and cubing at the coffee table restore Mood. Meals and leisure reset the work streak, not the daily session limit. | `data/text/rules.json` | data/rules_text.gd:21 pages | — |
| `rules.how_to_survive_the_next_3_days` | HOW TO SURVIVE THE NEXT 3 DAYS | `data/text/rules.json` | data/rules_text.gd:5 initial values | — |
| `rules.judy_has_three_days_to_prepare_for_a_research_showcase_it_begi` | Judy has three days to prepare for a research showcase. It begins at 8 PM on Day 3.<br><br>Aim for at least {target}% research. For the best outcome, repair all four of TipTop's routines too.<br><br>Each day runs from 11 AM to 8 PM. Balance science, meals, breaks and repairs: they share the same limited hours. | `data/text/rules.json` | data/rules_text.gd:17 pages | target: %.0f |
| `rules.let_s_get_to_work` | LET'S GET TO WORK | `data/text/rules.json` | data/rules_text.gd:8 initial values | — |
| `rules.next` | Next | `data/text/rules.json` | data/rules_text.gd:7 initial values | — |
| `rules.page_count` | {page} / {pages} | `data/text/rules.json` | scripts/rules_intro.gd:91 _show_page | page: %d, pages: %d |
| `rules.tiptop_means_well_his_four_faulty_routines_can_leave_recurring` | TipTop means well. His four faulty routines can leave recurring messes. Press E near him to repair each routine independently. On {difficulty}, each repair costs {duration} minutes and earns +{reward}% research.<br><br>Cleaning fixes the mess, not the routine. Your first repair before any research also earns a one-time +10% proactive bonus. Make the bed before resting to advance the day; bedtime Fullness affects tomorrow's Mood.<br><br>Research matters, but so does taking care of Judy. Plan your time, keep TipTop under control, and make it to the showcase!<br><br>Move: WASD / arrows. Interact: E. Pause: Esc. Optional tutorial: main menu. | `data/text/rules.json` | data/rules_text.gd:23 pages | difficulty: %s, duration: %d, reward: %.0f |
## data/text/save_load.json

| Text ID | Current Text | JSON File | Where It Appears | Variables |
|---|---|---|---|---|
| `save_load.cannot_create_the_save_directory` | Cannot create the save directory. | `data/text/save_load.json` | scripts/save_store.gd:215 _write | — |
| `save_load.cannot_install_checkpoint_previous_save_retained_or_available` | Cannot install checkpoint; previous save retained or available in recovery files. | `data/text/save_load.json` | scripts/save_store.gd:238 _write | — |
| `save_load.cannot_preserve_previous_save_replacement_cancelled` | Cannot preserve previous save; replacement cancelled. | `data/text/save_load.json` | scripts/save_store.gd:233 _write | — |
| `save_load.cannot_write_save_error_d` | Cannot write save: error {error}. | `data/text/save_load.json` | scripts/save_store.gd:221 _write | error: %d |
| `save_load.close_the_conversation_or_activity_menu_before_saving` | Close the conversation or activity menu before saving. | `data/text/save_load.json` | scripts/save_store.gd:305 safe_reason | — |
| `save_load.continue_was_interrupted_the_saved_checkpoint_is_intact` | Continue was interrupted; the saved checkpoint is intact. | `data/text/save_load.json` | scripts/save_store.gd:387 restore_room | — |
| `save_load.could_not_restore_a_walkable_position_save_files_are_intact` | Could not restore a walkable position. Save files are intact. | `data/text/save_load.json` | scripts/save_store.gd:396 restore_room | — |
| `save_load.finish_or_eject_the_current_activity_before_saving` | Finish or eject the current activity before saving. | `data/text/save_load.json` | scripts/save_store.gd:300 safe_reason | — |
| `save_load.kind.campaign` | campaign | `data/text/save_load.json` | save_store.gd:_read_recover; display alias for technical kind | — |
| `save_load.kind.profile` | profile | `data/text/save_load.json` | save_store.gd:_read_recover; display alias for technical kind | — |
| `save_load.no_compatible_active_save_could_be_read_existing_files_were_pr` | No compatible active save could be read. Existing files were preserved. | `data/text/save_load.json` | scripts/save_store.gd:352 prepare_continue | — |
| `save_load.no_compatible_campaign_checkpoint_could_be_read_existing_files` | No compatible campaign checkpoint could be read. Existing files are preserved. | `data/text/save_load.json` | scripts/save_store.gd:340 campaign_data | — |
| `save_load.profile_could_not_be_read_existing_files_are_preserved_profile` | Profile could not be read. Existing files are preserved; profile writes are disabled. | `data/text/save_load.json` | scripts/save_store.gd:49 _ready | — |
| `save_load.recovered_a_previous_valid_s_checkpoint_original_files_are_pre` | Recovered a previous valid {kind} checkpoint. Original files are preserved. | `data/text/save_load.json` | scripts/save_store.gd:205 _read_recover | kind: %s |
| `save_load.resume_and_finish_the_pending_conversation_before_saving` | Resume and finish the pending conversation before saving. | `data/text/save_load.json` | scripts/save_store.gd:307 safe_reason | — |
| `save_load.resume_gameplay_before_saving` | Resume gameplay before saving. | `data/text/save_load.json` | scripts/save_store.gd:309 safe_reason | — |
| `save_load.save_data_failed_validation_existing_files_were_preserved` | Save data failed validation; existing files were preserved. | `data/text/save_load.json` | scripts/save_store.gd:212 _write | — |
| `save_load.save_write_could_not_be_verified_previous_checkpoint_is_intact` | Save write could not be verified; previous checkpoint is intact. | `data/text/save_load.json` | scripts/save_store.gd:228 _write | — |
| `save_load.saving_is_available_during_a_campaign` | Saving is available during a campaign. | `data/text/save_load.json` | scripts/save_store.gd:298 safe_reason | — |
| `save_load.tutorial_practice_is_not_saved_your_campaign_checkpoint_is_unt` | Tutorial practice is not saved. Your campaign checkpoint is untouched. | `data/text/save_load.json` | scripts/save_store.gd:295 safe_reason | — |
| `save_load.wait_for_the_next_playable_day_before_saving` | Wait for the next playable day before saving. | `data/text/save_load.json` | scripts/save_store.gd:303 safe_reason | — |
## data/text/settings.json

| Text ID | Current Text | JSON File | Where It Appears | Variables |
|---|---|---|---|---|
| `settings.apartment_theme_chill_lofi_inspired_omfgdude_loop_edit_by_qubo` | Apartment theme: Chill lofi inspired — omfgdude; loop edit by qubodup (CC0). | `data/text/settings.json` | scripts/title.gd:384 _show_settings | — |
| `settings.audio_preferences_are_saved_automatically_music_has_its_own_vo` | Audio preferences are saved automatically. Music has its own volume; display scaling stays unchanged. | `data/text/settings.json` | scripts/title.gd:383 _show_settings | — |
| `settings.bus.ambience` | Ambience | `data/text/settings.json` | title.gd:_show_settings | — |
| `settings.bus.master` | Master | `data/text/settings.json` | title.gd:_show_settings | — |
| `settings.bus.music` | Music | `data/text/settings.json` | title.gd:_show_settings | — |
| `settings.bus.sfx` | SFX | `data/text/settings.json` | title.gd:_show_settings | — |
| `settings.fullscreen` | Fullscreen | `data/text/settings.json` | scripts/title.gd:377 _show_settings | — |
| `settings.s_d` | {bus}: {volume}% | `data/text/settings.json` | scripts/title.gd:370 _show_settings; scripts/title.gd:374 _show_settings | bus: %s, volume: %d |
| `settings.volume` |  volume | `data/text/settings.json` | scripts/title.gd:367 _show_settings | — |
## data/text/tiptop.json

| Text ID | Current Text | JSON File | Where It Appears | Variables |
|---|---|---|---|---|
| `tiptop.a_continuous_rinse_must_be_very_thorough` | A continuous rinse must be very thorough. | `data/text/tiptop.json` | scripts/tiptop.gd:42 initial values | — |
| `tiptop.a_generous_drink_for_a_generous_plant` | A generous drink for a generous plant. | `data/text/tiptop.json` | scripts/tiptop.gd:43 initial values | — |
| `tiptop.a_little_creative_folding_should_help` | A little creative folding should help. | `data/text/tiptop.json` | scripts/tiptop.gd:45 initial values | — |
| `tiptop.a_tidy_bed_supports_untidy_scientific_ideas` | A tidy bed supports untidy scientific ideas. | `data/text/tiptop.json` | scripts/tiptop.gd:39 initial values | — |
| `tiptop.dish_duty_is_one_of_my_four_specialties` | Dish duty is one of my four specialties. | `data/text/tiptop.json` | scripts/tiptop.gd:36 initial values | — |
| `tiptop.dishes_reaction` | Dishes clean. Another successful meal concluded. | `data/text/tiptop.json` | scripts/tiptop.gd:_say_chore dynamic phase | — |
| `tiptop.dishes_working` | Used dishes detected. I shall handle the aftermath. | `data/text/tiptop.json` | scripts/tiptop.gd:_say_chore dynamic phase | — |
| `tiptop.drying` | Drying... | `data/text/tiptop.json` | scripts/tiptop.gd:577 _begin_action | — |
| `tiptop.every_sheet_deserves_extra_ventilation` | Every sheet deserves extra ventilation! | `data/text/tiptop.json` | scripts/tiptop.gd:45 initial values | — |
| `tiptop.everything_is_in_its_place_even_the_books` | Everything is in its place, even the books. | `data/text/tiptop.json` | scripts/tiptop.gd:62 initial values | — |
| `tiptop.faulty` | Faulty | `data/text/tiptop.json` | scripts/hud.gd:1215 _open_repair_menu | — |
| `tiptop.faulty_routines_repair_or_ignore` | Faulty routines: repair or ignore? | `data/text/tiptop.json` | scripts/hud.gd:489 _show_malfunction | — |
| `tiptop.good_morning_judy_i_have_several_helpful_intentions` | Good morning, Judy! I have several helpful intentions. | `data/text/tiptop.json` | scripts/tiptop.gd:225 greet_morning | — |
| `tiptop.good_morning_judy_i_ve_prepared_a_perfectly_organized_day` | Good morning, Judy! I've prepared a perfectly organized day. | `data/text/tiptop.json` | scripts/tiptop.gd:225 greet_morning | — |
| `tiptop.good_morning_judy_it_s_showcase_day_i_believe_in_us` | Good morning, Judy! It's showcase day. I believe in us. | `data/text/tiptop.json` | scripts/tiptop.gd:225 greet_morning | — |
| `tiptop.good_night_judy_everything_is_under_control_probably` | Good night, Judy. Everything is under control. Probably. | `data/text/tiptop.json` | scripts/tiptop.gd:238 say_goodnight | — |
| `tiptop.hydration_is_complete` | Hydration is complete. | `data/text/tiptop.json` | scripts/tiptop.gd:55 initial values | — |
| `tiptop.i_am_testing_an_aerodynamic_arrangement` | I am testing an aerodynamic arrangement. | `data/text/tiptop.json` | scripts/tiptop.gd:44 initial values | — |
| `tiptop.i_delivered_the_correct_amount_this_time` | I delivered the correct amount this time. | `data/text/tiptop.json` | scripts/tiptop.gd:61 initial values | — |
| `tiptop.i_have_optimized_the_book_order` | I have optimized the book order. | `data/text/tiptop.json` | scripts/tiptop.gd:56 initial values | — |
| `tiptop.i_have_revised_my_rinsing_methods` | I have revised my rinsing methods. | `data/text/tiptop.json` | scripts/tiptop.gd:48 initial values | — |
| `tiptop.i_have_the_situation_under_control` | I have the situation under control. | `data/text/tiptop.json` | scripts/tiptop.gd:254 _say_chore | — |
| `tiptop.i_remember_to_smooth_the_sheets_gently` | I remember to smooth the sheets gently. | `data/text/tiptop.json` | scripts/tiptop.gd:51 initial values | — |
| `tiptop.i_removed_d_airborne_intruders` | I removed {count} airborne intruders. | `data/text/tiptop.json` | scripts/tiptop.gd:256 _say_chore | count: %d |
| `tiptop.i_shall_assess_the_sheet_situation` | I shall assess the sheet situation. | `data/text/tiptop.json` | scripts/tiptop.gd:39 initial values | — |
| `tiptop.i_shall_check_on_our_leafy_colleague` | I shall check on our leafy colleague. | `data/text/tiptop.json` | scripts/tiptop.gd:37 initial values | — |
| `tiptop.i_shall_check_the_soil_before_i_pour` | I shall check the soil before I pour. | `data/text/tiptop.json` | scripts/tiptop.gd:49 initial values | — |
| `tiptop.i_shall_give_it_just_enough_water` | I shall give it just enough water. | `data/text/tiptop.json` | scripts/tiptop.gd:49 initial values | — |
| `tiptop.i_shall_rinse_the_dishes_then_close_the_tap` | I shall rinse the dishes, then close the tap. | `data/text/tiptop.json` | scripts/tiptop.gd:48 initial values | — |
| `tiptop.i_shall_tuck_the_corners_and_restore_the_pillow` | I shall tuck the corners and restore the pillow. | `data/text/tiptop.json` | scripts/tiptop.gd:51 initial values | — |
| `tiptop.making_bed` | Making bed... | `data/text/tiptop.json` | scripts/tiptop.gd:577 _begin_action | — |
| `tiptop.maximum_cleanliness_requires_maximum_water` | Maximum cleanliness requires maximum water! | `data/text/tiptop.json` | scripts/tiptop.gd:42 initial values | — |
| `tiptop.mopping` | Mopping... | `data/text/tiptop.json` | scripts/tiptop.gd:577 _begin_action | — |
| `tiptop.not_enough_time` | Not enough time | `data/text/tiptop.json` | scripts/hud.gd:1215 _open_repair_menu | — |
| `tiptop.one_less_mosquito_you_re_welcome_judy` | One less mosquito. You're welcome, Judy. | `data/text/tiptop.json` | scripts/tiptop.gd:256 _say_chore | — |
| `tiptop.organizing` | Organizing... | `data/text/tiptop.json` | scripts/tiptop.gd:577 _begin_action; scripts/tiptop.gd:577 _begin_action | — |
| `tiptop.our_colleague_will_be_delighted` | Our colleague will be delighted. | `data/text/tiptop.json` | scripts/tiptop.gd:55 initial values | — |
| `tiptop.plants_love_water_more_must_be_better` | Plants love water. More must be better! | `data/text/tiptop.json` | scripts/tiptop.gd:43 initial values | — |
| `tiptop.references_reaction` | References restored. Science may continue. | `data/text/tiptop.json` | scripts/tiptop.gd:_say_chore dynamic phase | — |
| `tiptop.references_working` | I shall return these references to their shelf. | `data/text/tiptop.json` | scripts/tiptop.gd:_say_chore dynamic phase | — |
| `tiptop.repaired` | Repaired | `data/text/tiptop.json` | scripts/hud.gd:1215 _open_repair_menu | — |
| `tiptop.repairs` | Repairs... | `data/text/tiptop.json` | scripts/hud.gd:1201 _build_repair_menu | — |
| `tiptop.routine.bed` | Bed | `data/text/tiptop.json` | Runtime chore name; hud.gd and game_state.gd | — |
| `tiptop.routine.bookshelf` | Bookshelf | `data/text/tiptop.json` | Runtime chore name; hud.gd and game_state.gd | — |
| `tiptop.routine.plant` | Plant | `data/text/tiptop.json` | Runtime chore name; hud.gd and game_state.gd | — |
| `tiptop.routine.sink` | Sink | `data/text/tiptop.json` | Runtime chore name; hud.gd and game_state.gd | — |
| `tiptop.routine_lower.bed` | bed | `data/text/tiptop.json` | Runtime chore name in conversations and cleanup | — |
| `tiptop.routine_lower.bookshelf` | bookshelf | `data/text/tiptop.json` | Runtime chore name in conversations and cleanup | — |
| `tiptop.routine_lower.plant` | plant | `data/text/tiptop.json` | Runtime chore name in conversations and cleanup | — |
| `tiptop.routine_lower.sink` | sink | `data/text/tiptop.json` | Runtime chore name in conversations and cleanup | — |
| `tiptop.s_s_d_min_0f` | {routine} — {status} ({duration} min, +{reward}%) | `data/text/tiptop.json` | scripts/hud.gd:1215 _open_repair_menu | routine: %s, status: %s, duration: %d, reward: %.0f |
| `tiptop.straightening` | Straightening... | `data/text/tiptop.json` | scripts/tiptop.gd:577 _begin_action | — |
| `tiptop.swatting` | Swatting... | `data/text/tiptop.json` | scripts/tiptop.gd:581 _begin_action | — |
| `tiptop.tap_running_repair_or_ignore` | Tap running: repair or ignore? | `data/text/tiptop.json` | scripts/hud.gd:489 _show_malfunction | — |
| `tiptop.that_s_exactly_what_worries_me_night_tiptop` | That's exactly what worries me. Night, TipTop. | `data/text/tiptop.json` | scripts/tiptop.gd:238 say_goodnight | — |
| `tiptop.that_sounds_suspiciously_optimistic` | That sounds suspiciously optimistic. | `data/text/tiptop.json` | scripts/tiptop.gd:227 greet_morning | — |
| `tiptop.that_was_another_successful_chore` | That was another successful chore! | `data/text/tiptop.json` | scripts/tiptop.gd:60 initial values | — |
| `tiptop.the_bed_is_made_i_shall_leave_it_made` | The bed is made. I shall leave it made. | `data/text/tiptop.json` | scripts/tiptop.gd:63 initial values | — |
| `tiptop.the_bed_is_ready_for_sleeping_or_admiring` | The bed is ready for sleeping or admiring. | `data/text/tiptop.json` | scripts/tiptop.gd:63 initial values | — |
| `tiptop.the_books_are_alphabetical_and_upright` | The books are alphabetical and upright. | `data/text/tiptop.json` | scripts/tiptop.gd:62 initial values | — |
| `tiptop.the_bookshelf_requires_my_expertise` | The bookshelf requires my expertise. | `data/text/tiptop.json` | scripts/tiptop.gd:38 initial values | — |
| `tiptop.the_dish_cycle_was_successful` | The dish cycle was successful. | `data/text/tiptop.json` | scripts/tiptop.gd:54 initial values | — |
| `tiptop.the_dishes_are_clean_and_the_floor_is_dry` | The dishes are clean and the floor is dry. | `data/text/tiptop.json` | scripts/tiptop.gd:60 initial values | — |
| `tiptop.the_largest_books_belong_on_top` | The largest books belong on top. | `data/text/tiptop.json` | scripts/tiptop.gd:44 initial values | — |
| `tiptop.the_plant_has_silently_requested_my_attention` | The plant has silently requested my attention. | `data/text/tiptop.json` | scripts/tiptop.gd:37 initial values | — |
| `tiptop.the_plant_is_healthy_and_the_floor_is_dry` | The plant is healthy and the floor is dry. | `data/text/tiptop.json` | scripts/tiptop.gd:61 initial values | — |
| `tiptop.the_sheets_are_thoroughly_aerated` | The sheets are thoroughly aerated. | `data/text/tiptop.json` | scripts/tiptop.gd:57 initial values | — |
| `tiptop.the_titles_belong_in_order_spines_facing_out` | The titles belong in order, spines facing out. | `data/text/tiptop.json` | scripts/tiptop.gd:50 initial values | — |
| `tiptop.the_water_is_certainly_flowing_efficiently` | The water is certainly flowing efficiently. | `data/text/tiptop.json` | scripts/tiptop.gd:54 initial values | — |
| `tiptop.these_books_have_rectangular_potential` | These books have rectangular potential. | `data/text/tiptop.json` | scripts/tiptop.gd:38 initial values | — |
| `tiptop.these_dishes_deserve_a_fresh_start` | These dishes deserve a fresh start. | `data/text/tiptop.json` | scripts/tiptop.gd:36 initial values | — |
| `tiptop.this_bed_is_refreshingly_unconventional` | This bed is refreshingly unconventional. | `data/text/tiptop.json` | scripts/tiptop.gd:57 initial values | — |
| `tiptop.this_bold_new_arrangement_is_excellent` | This bold new arrangement is excellent. | `data/text/tiptop.json` | scripts/tiptop.gd:56 initial values | — |
| `tiptop.tiny_airborne_intruder_detected` | Tiny airborne intruder detected. | `data/text/tiptop.json` | scripts/tiptop.gd:252 _say_chore | — |
| `tiptop.tiptop_s_routines_repair_independently` | TipTop's routines - repair independently | `data/text/tiptop.json` | scripts/hud.gd:1182 _build_repair_menu | — |
| `tiptop.upright_books_are_an_elegant_solution` | Upright books are an elegant solution. | `data/text/tiptop.json` | scripts/tiptop.gd:50 initial values | — |
| `tiptop.washing` | Washing... | `data/text/tiptop.json` | scripts/tiptop.gd:577 _begin_action | — |
| `tiptop.washing_dishes` | Washing dishes... | `data/text/tiptop.json` | scripts/tiptop.gd:579 _begin_action | — |
| `tiptop.water_sink` | Water / sink | `data/text/tiptop.json` | scripts/hud.gd:1215 _open_repair_menu | — |
| `tiptop.watering` | Watering... | `data/text/tiptop.json` | scripts/tiptop.gd:577 _begin_action | — |
## data/text/tutorial.json

| Text ID | Current Text | JSON File | Where It Appears | Variables |
|---|---|---|---|---|
| `tutorial.a_full_activity_must_fit_before_8_pm_including_tap_penalties_f` | A full activity must fit before 8 PM, including tap penalties for research. Check remaining time or choose a shorter activity. A rejected start spends no session or reward. | `data/text/tutorial.json` | scripts/tutorial.gd:135 _feedback | — |
| `tutorial.a_repaired_routine_stays_corrected_and_earns_research_progress` | A repaired routine stays corrected and earns research progress. Existing mess may still need cleanup. Each routine is repaired independently. | `data/text/tutorial.json` | scripts/tutorial.gd:110 _detect | — |
| `tutorial.aim_for_75_research_on_s_a_standard_session_costs_d_game_minut` | Aim for 75% research. On {difficulty}, a standard session costs {duration} game minutes. A running tap adds time and cuts gains; repairs can also earn progress. | `data/text/tutorial.json` | scripts/tutorial.gd:126 _detect | difficulty: %s, duration: %d |
| `tutorial.below_60_fullness_research_gains_fall_at_20_or_less_you_can_t` | Below 60 Fullness, research gains fall. At 20 or less, you can't start work. A 30-minute meal restores 40 Fullness and 10 Mood, and counts as a break. | `data/text/tutorial.json` | scripts/tutorial.gd:108 _detect | — |
| `tutorial.d_8` |  · {step} / 8 | `data/text/tutorial.json` | scripts/tutorial.gd:251 _process | step: %d |
| `tutorial.e_enter_got_it` | E / Enter · Got it | `data/text/tutorial.json` | scripts/tutorial.gd:57 _ready | — |
| `tutorial.esc_opens_pause_exit_tutorial_returns_to_the_menu_your_campaig` | Esc opens Pause. Exit Tutorial returns to the menu; your campaign save stays untouched. In a campaign, save when free or review the rules. Tasks offer Watch, 6x, Skip and Eject; ejecting keeps spent time without a reward. | `data/text/tutorial.json` | scripts/tutorial.gd:130 _detect | — |
| `tutorial.fullness_shifts_from_sage_to_brick_as_it_falls_meals_restore_f` | Fullness shifts from sage to brick as it falls. Meals restore Fullness and Mood; meals and leisure reset your work streak. Click the heart, or Tab then arrows, for details. | `data/text/tutorial.json` | scripts/tutorial.gd:124 _detect | — |
| `tutorial.getting_settled` | Getting settled | `data/text/tutorial.json` | scripts/tutorial.gd:245 _process | — |
| `tutorial.make_the_bed_then_e_to_rest_and_end_the_day_sleeping_starts_th` | Make the bed, then E to rest and end the day. Sleeping starts the next day; bedtime fullness affects tomorrow's Mood. Meals and breaks need planning too. | `data/text/tutorial.json` | scripts/tutorial.gd:128 _detect | — |
| `tutorial.move_with_wasd_or_arrows_approach_objects_for_e_prompts_tiptop` | Move with WASD or arrows; approach objects for E prompts. TipTop waits until you read all eight tips or choose Skip Tutorial. Essential warnings stay enabled. | `data/text/tutorial.json` | scripts/tutorial.gd:117 _detect | — |
| `tutorial.quick_tip` | Quick tip | `data/text/tutorial.json` | scripts/tutorial.gd:245 _process | — |
| `tutorial.repeated_watering_leaves_wet_soil_and_puddles_standing_water_a` | Repeated watering leaves wet soil and puddles. Standing water attracts mosquitoes, which interrupt work. Dry the area and repair the plant routine to prevent repeats. | `data/text/tutorial.json` | scripts/tutorial.gd:102 _detect | — |
| `tutorial.research_normally_needs_45_mood_meals_and_leisure_restore_it_a` | Research normally needs 45 Mood. Meals and leisure restore it and reset the work streak. Day 3's Mood exception never bypasses the more-than-20 Fullness requirement. | `data/text/tutorial.json` | scripts/tutorial.gd:106 _detect | — |
| `tutorial.scattered_books_block_research_press_e_near_the_shelf_or_falle` | Scattered books block research. Press E near the shelf or fallen books to organize them for 20 minutes. Cleanup leaves the routine faulty. | `data/text/tutorial.json` | scripts/tutorial.gd:100 _detect | — |
| `tutorial.skip_tutorial` | Skip Tutorial | `data/text/tutorial.json` | scripts/tutorial.gd:62 _ready | — |
| `tutorial.sleeping_below_70_fullness_lowers_tomorrow_s_starting_mood_ver` | Sleeping below 70 fullness lowers tomorrow's starting Mood; very low fullness is worse. Consider eating first. Dismiss this tip, then E at the bed again if you're ready. | `data/text/tutorial.json` | scripts/tutorial.gd:143 warn_before_sleep | — |
| `tutorial.the_clock_runs_while_you_explore_showcase_day_3_8_pm_this_bar` | The clock runs while you explore. Showcase: Day 3, 8 PM. This bar counts 27 playable hours, excluding nights. Hover/focus icons for details; click to pin. | `data/text/tutorial.json` | scripts/tutorial.gd:118 _detect | — |
| `tutorial.the_running_tap_halves_research_gains_and_makes_sessions_longe` | The running tap halves research gains and makes sessions longer. Turn it off at the sink; repair the sink routine to prevent repeats. | `data/text/tutorial.json` | scripts/tutorial.gd:98 _detect | — |
| `tutorial.tiptop_has_made_the_bed_messier_make_it_before_resting_or_let` | TipTop has made the bed messier. Make it before resting, or let its repaired routine tidy it. | `data/text/tutorial.json` | scripts/tutorial.gd:104 _detect | — |
| `tutorial.tiptop_means_well_faulty_chores_make_real_messes_his_robot_ico` | TipTop means well. Faulty chores make real messes. His robot icon shows the repair checklist; E near him opens repairs. Cleaning alone doesn't correct a routine. | `data/text/tutorial.json` | scripts/tutorial.gd:122 _detect | — |
| `tutorial.use_e_at_the_desk_for_up_to_four_sessions_daily_starting_work` | Use E at the desk for up to four sessions daily. Starting work needs more than 20 Fullness. Watch, 6x and Skip process the same world time and consequences. | `data/text/tutorial.json` | scripts/tutorial.gd:120 _detect | — |
| `tutorial.you_ve_reached_the_75_showcase_research_requirement_other_choi` | You've reached the 75% showcase research requirement! Other choices and TipTop's repair state still matter. The showcase is Day 3 at 8 PM. | `data/text/tutorial.json` | scripts/tutorial.gd:112 _detect | — |

Total: 457 entries in 13 JSON files. No runtime verification.
