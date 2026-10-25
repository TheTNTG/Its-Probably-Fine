"""One-time metadata normalization for the Step 48.1 migration."""
import json
from centralize_game_text import ROOT


def main():
    records = {}
    for path in (ROOT / "data/text").glob("*.json"):
        records.update(json.loads(path.read_text(encoding="utf-8")))
    names = {
        "activities.clean_s_myself_d_min": ["routine", "duration"],
        "dialogue.i_was_checking_the_s_it_appreciates_the_attention": ["routine"],
        "hud.color_9dceac_s_s_s_color": ["routine"], "hud.d": ["penalty"],
        "hud.day_3_showcase_reach_0f_and_repair_all_routines_e_to_interact": ["target"],
        "hud.day_d_complete_8_00_pm_research_1f_showcase_deadline_day_3_8_0": ["day", "progress"],
        "hud.food_d_yield": ["penalty"], "hud.food_d_yield_meals_40_food_10_mood": ["penalty"],
        "hud.s_research_0f_min_0f_repair_d_min_0f": ["description", "research_duration", "research_reward", "repair_duration", "repair_reward"],
        "hud.target_0f": ["target"], "interactions.d_d_left": ["sessions", "limit"],
        "main_menu.s_research_d_base_d_min_routine_repair_d_min": ["description", "reward", "duration", "repair_duration"],
        "notifications.a_full_repair_needs_d_minutes_before_8_00_pm_no_time_or_reward": ["duration"],
        "notifications.not_enough_time_before_8_00_pm_a_full_research_session_needs_d": ["duration"],
        "notifications.s_routine_repaired_0f_research_d_min": ["routine", "reward", "duration"],
        "notifications.s_tidied_routine_unchanged_d_min": ["routine", "duration"],
        "notifications.tiptop_s_routine_updated_thank_you_judy": ["routine"],
        "research.research_d_d_min_dx": ["elapsed", "duration", "speed"],
        "research.s_d_d_min_dx": ["activity", "elapsed", "duration", "speed"],
        "rules.approach_the_desk_and_press_e_you_have_up_to_d_sessions_each_d": ["sessions", "difficulty", "duration", "reward"],
        "rules.judy_has_three_days_to_prepare_for_a_research_showcase_it_begi": ["target"],
        "rules.tiptop_means_well_his_four_faulty_routines_can_leave_recurring": ["difficulty", "duration", "reward"],
        "save_load.cannot_write_save_error_d": ["error"],
        "save_load.recovered_a_previous_valid_s_checkpoint_original_files_are_pre": ["kind"],
        "tiptop.i_removed_d_airborne_intruders": ["count"],
        "tutorial.aim_for_75_research_on_s_a_standard_session_costs_d_game_minut": ["difficulty", "duration"],
        "tutorial.d_8": ["step"],
    }
    for identifier, new_names in names.items():
        entry = records[identifier]
        old_names = entry["order"]
        formats = entry["variables"]
        for old, new in zip(old_names, new_names):
            entry["text"] = entry["text"].replace("{" + old + "}", "{" + new + "}")
        entry["variables"] = {new: formats[old] for old, new in zip(old_names, new_names)}
        entry["order"] = new_names
    renames = {"activities.watch_research": "research.start", "main_menu.research": "hud.research_heading"}
    for identifier, entry in list(records.items()):
        if identifier.startswith("notifications."):
            if any("judy_response" in use for use in entry["where"]):
                renames[identifier] = "dialogue.judy_" + identifier.split(".", 1)[1]
            elif any("initial values" in use or "defaults" in use for use in entry["where"]):
                renames[identifier] = "research.difficulty_" + identifier.split(".", 1)[1]
    for old, new in renames.items():
        records[new] = records.pop(old)
    for kind in ["campaign", "profile"]:
        records["save_load.kind." + kind] = {"text": kind, "variables": {}, "order": [], "where": ["save_store.gd:_read_recover; display alias for technical kind"]}
    for path in [*ROOT.glob("scripts/*.gd"), *ROOT.glob("data/*.gd")]:
        original = path.read_text(encoding="utf-8")
        source = original
        for old, new in renames.items():
            source = source.replace('"' + old + '"', '"' + new + '"')
        if path.name == "save_store.gd":
            source = source.replace('GameText.format_text("save_load.recovered_a_previous_valid_s_checkpoint_original_files_are_pre", kind)', 'GameText.format_text("save_load.recovered_a_previous_valid_s_checkpoint_original_files_are_pre", GameText.get_text("save_load.kind." + kind))')
        if source != original:
            path.write_text(source, encoding="utf-8")
    groups = {}
    for identifier, entry in sorted(records.items()):
        groups.setdefault(identifier.split(".")[0], {})[identifier] = entry
    for group, entries in groups.items():
        (ROOT / "data/text" / (group + ".json")).write_text(json.dumps(entries, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(f"{len(records)} records; named placeholders normalized")


if __name__ == "__main__":
    main()
