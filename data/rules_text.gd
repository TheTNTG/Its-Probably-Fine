extends RefCounted

# Player-facing copy only. Values come from the selected gameplay difficulty.
# Keep each page concise; rules_intro.gd wraps and scrolls the body if necessary.
const TITLE := "rules.how_to_survive_the_next_3_days"
const BACK := "main_menu.back"
const NEXT := "rules.next"
const START := "rules.let_s_get_to_work"
const CLOSE := "rules.back_to_game"
const HINT := "rules.e_enter_next_page_tab_select_a_button"


static func pages() -> Array[Dictionary]:
	var settings: Dictionary = GameState.profile()
	return [
		{"heading": GameText.get_text("rules.1_the_goal_deadline"), "text":
			GameText.format_text("rules.judy_has_three_days_to_prepare_for_a_research_showcase_it_begi", GameState.GOOD_ENDING_RESEARCH_THRESHOLD)},
		{"heading": GameText.get_text("rules.2_research_your_time"), "text":
			GameText.format_text("rules.approach_the_desk_and_press_e_you_have_up_to_d_sessions_each_d", [GameState.DAILY_WORK_SESSIONS, settings["name"], settings["research_minutes"], settings["research"]])},
		{"heading": GameText.get_text("rules.3_fullness_mood_breaks"), "text":
			GameText.get_text("rules.higher_fullness_is_better_research_needs_more_than_20_fullness")},
		{"heading": GameText.get_text("rules.4_tiptop_a_balanced_day"), "text":
			GameText.format_text("rules.tiptop_means_well_his_four_faulty_routines_can_leave_recurring", [settings["name"], settings["repair_minutes"], settings["repair_reward"]])}
	]
