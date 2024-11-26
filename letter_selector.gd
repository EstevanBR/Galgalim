@tool
extends Node
class_name LetterSelector

signal letter_selected(letter: String)

var _current_letter: String = ""

func _input(event: InputEvent) -> void:
	if (event is InputEventMouseButton and event.is_pressed() and [MOUSE_BUTTON_LEFT, MOUSE_BUTTON_RIGHT, MOUSE_BUTTON_MIDDLE].count(event.button_index)) \
		or (event is InputEventKey and event.is_pressed()) \
		or (event is InputEventJoypadButton and event.is_pressed()):
		letter_selected.emit.call_deferred(_current_letter)
		print_debug(_current_letter)
		set_process_input(false)

func _process(delta: float) -> void:
	if is_processing_input() == false:
		set_process_input(true)

func _on_letter_wheel_2d_current_letter_changed(new_value: String) -> void:
	_current_letter = new_value
