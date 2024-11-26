extends Node
class_name Game

@export var letter_wheel_2d: LetterWheel2D
@export var current_word_label: CurrentWordLabel

var words: Array[String] = []

func _ready() -> void:
	var file := FileAccess.open("res://five_letter_words.txt", FileAccess.READ)
	
	while not file.eof_reached():
		var line: String = file.get_line().to_lower()
		if line.length() == 5:
			words.append(line)

func submit_word(word: String):
	var valid_word: bool = false
	if words.count(word):
		print_debug(word, " is a valid word!")
		valid_word = true
		get_tree().create_tween().tween_property(
			current_word_label,
			"modulate",
			Color.GREEN,
			1.0
		)
	else:
		print_debug(word, " is not a valid word :(")
		valid_word = false
		get_tree().create_tween().tween_property(
			current_word_label,
			"modulate",
			Color.RED,
			1.0
		)
	
	var letters: Array[String] = []
	for letter in letter_wheel_2d.letters:
		letters.append(letter)
	
	var before_radius: float = letter_wheel_2d.radius
	letter_wheel_2d.shrink(0.25)
	await letter_wheel_2d.did_shrink
	letters.shuffle()
	letter_wheel_2d.letters = ""
	for letter in letters:
		letter_wheel_2d.letters += letter
	letter_wheel_2d.grow(0.25, before_radius , 0.25)
	await letter_wheel_2d.did_grow
	current_word_label.reset()
	
	get_tree().create_tween().tween_property(
		current_word_label,
		"modulate",
		Color.WHITE,
		1.0
	)

func _on_current_word_label_submitted_word(word: String) -> void:
	submit_word(word)
