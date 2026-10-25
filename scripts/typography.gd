extends RefCounted

# Reference-canvas sizes: keep established compact per-control sizes and layout.
const THEME = preload("res://themes/cozy.tres")
const SIZES := {"title": 23, "section": 12, "heading": 9, "body": 8, "dialogue": 7, "secondary": 6, "thought": 5}

static func accent(label: Label) -> void:
	# Before Step 42B all UI used Godot's regular embedded default font.
	# Keep the shared heading hook without imposing a different pixel font.
	label.add_theme_font_override("font", ThemeDB.fallback_font)
