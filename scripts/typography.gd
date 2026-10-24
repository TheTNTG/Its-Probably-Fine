extends RefCounted

# Reference-canvas sizes: keep established compact per-control sizes and layout.
const THEME = preload("res://themes/cozy.tres")
const ACCENT = preload("res://assets/fonts/PixelifySans[wght].ttf")
const SIZES := {"title": 23, "section": 12, "heading": 9, "body": 8, "dialogue": 7, "secondary": 6, "thought": 5}

static func accent(label: Label) -> void:
	label.add_theme_font_override("font", ACCENT)
