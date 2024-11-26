extends Label
class_name MessageLabel

func _ready() -> void:
	set_message("Try to form a 5 letter word", Color.WHITE)

func set_message(message: String, color: Color):
	text = message
	modulate = color
	get_tree().create_tween().tween_property(
		self,
		"modulate",
		Color(1, 1, 1, 0),
		1
	).set_delay(4.0)
