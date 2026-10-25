extends RefCounted

# Player-facing copy only. Values come from the selected gameplay difficulty.
# Keep each page concise; rules_intro.gd wraps and scrolls the body if necessary.
const TITLE := "HOW TO SURVIVE THE NEXT 3 DAYS"
const BACK := "Back"
const NEXT := "Next"
const START := "LET'S GET TO WORK"
const CLOSE := "Back to game"
const HINT := "E / Enter: next page · Tab: select a button"


static func pages() -> Array[Dictionary]:
	var settings: Dictionary = GameState.profile()
	return [
		{"heading": "1 · The goal & deadline", "text":
			"Judy has three days to prepare for a research showcase. It begins at 8 PM on Day 3.\n\nAim for at least %.0f%% research. For the best outcome, repair all four of TipTop's routines too.\n\nEach day runs from 11 AM to 8 PM. Balance science, meals, breaks and repairs: they share the same limited hours." % GameState.GOOD_ENDING_RESEARCH_THRESHOLD},
		{"heading": "2 · Research & your time", "text":
			"Approach the desk and press E. You have up to %d sessions each day. On %s, a standard session takes %d game minutes for +%.0f%% base research. A full session must fit before 8 PM.\n\nThe clock also runs while you explore. Watch, Fast 6x and Skip apply the same time and consequences. Skip is faster for you, not for Judy. Eject keeps time already spent and gives no completion reward.\n\nA running tap adds one-third to session time and halves research gains. Scattered books block work; organizing them takes 20 minutes." % [GameState.DAILY_WORK_SESSIONS, settings["name"], settings["research_minutes"], settings["research"]]},
		{"heading": "3 · Fullness, Mood & breaks", "text":
			"Higher Fullness is better. Research needs more than 20 Fullness. Below 60, research yield falls: 90% from 30 to below 60, 75% below 30, and 60% at zero.\n\nResearch normally needs at least 45 Mood. From 2 PM on Day 3, Judy can push through low Mood with 20% less yield; she still needs more than 20 Fullness.\n\nA 30-minute fridge meal restores 40 Fullness and 10 Mood. Reels, phone games and cubing at the coffee table restore Mood. Meals and leisure reset the work streak, not the daily session limit."},
		{"heading": "4 · TipTop & a balanced day", "text":
			"TipTop means well. His four faulty routines can leave recurring messes. Press E near him to repair each routine independently. On %s, each repair costs %d minutes and earns +%.0f%% research.\n\nCleaning fixes the mess, not the routine. Your first repair before any research also earns a one-time +10%% proactive bonus. Make the bed before resting to advance the day; bedtime Fullness affects tomorrow's Mood.\n\nResearch matters, but so does taking care of Judy. Plan your time, keep TipTop under control, and make it to the showcase!\n\nMove: WASD / arrows. Interact: E. Pause: Esc. Optional tutorial: main menu." % [settings["name"], settings["repair_minutes"], settings["repair_reward"]]}
	]
