@tool
extends Label
class_name CurrentWordLabel

signal submitted_word(word: String)

func _ready() -> void:
	text = "_ _ _ _ _"

func reset():
	text = "_ _ _ _ _"

func _on_letter_selector_letter_selected(letter: String) -> void:
	#text += letter

	if letter.length() != 1:
		return
	
	var idx := text.find("_")
	
	if idx < 0:
		return
	
	text[idx] = letter
	
	var submission: String = text
	submission = submission \
		.replace(" ", "") \
		.replace("_", "") \
		.to_lower()
	
	if submission.length() == 5:
		submitted_word.emit.call_deferred(submission)
	else:
		print_debug("not enough letters yet, need 5, have ", submission.length())
