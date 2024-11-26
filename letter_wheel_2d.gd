@tool
extends Polygon2D
class_name LetterWheel2D

signal current_letter_changed(new_value: String)
signal did_shrink
signal did_grow

@export var wheel_color: Color = Color.WHITE

@export var degrees_per_second: float = 90.0

@export var radius: float = 32.0:
	set(value):
		radius = value
		queue_redraw()

@export var letters: String = "":
	set(value):
		letters = value
		queue_redraw()

@export var font_size: float = 32.0:
	set(value):
		font_size = value
		queue_redraw()

var angle_degrees: float = 0.0

func _process(delta: float) -> void:
	angle_degrees -= delta * degrees_per_second
	angle_degrees = fmod(angle_degrees, 360.0)
	queue_redraw()

func _draw() -> void:
	draw_polygon(
		[
			Vector2.UP * (radius + font_size),
			Vector2.UP * (radius + font_size + 40) + Vector2.LEFT * 40,
			Vector2.UP * (radius + font_size + 40) + Vector2.RIGHT * 40
		],
		[
			#wheel_color,
			#wheel_color,
			wheel_color
		],
		[],
		null
	)
	draw_circle(position, radius + font_size, wheel_color, false, 2.0, false)
	draw_circle(position, radius - font_size, wheel_color, false, 2.0, false)
	
	var word_length: float = float(letters.length())
	
	var selection_window_rect := Rect2(
		(Vector2.RIGHT * (radius + font_size)).rotated(deg_to_rad(-90.0)) + Vector2(-font_size, 0),
		Vector2(font_size * 2, font_size * 2)
	)
	
	var highlighted_letter: String = ""
	
	var arc: float = 360.0 / word_length
	
	for idx in range(0, word_length):
		var letter: String = letters[idx]
		var deg: float = arc * idx
		var rad: float = deg_to_rad(deg + angle_degrees)
		var letter_pos := (Vector2.RIGHT * (radius)).rotated(rad)
		var font := SystemFont.new()
		
		var letter_size := font.get_string_size(
			letter,
			HORIZONTAL_ALIGNMENT_LEFT,
			font_size,
			font_size,
			TextServer.JUSTIFICATION_NONE,
			TextServer.DIRECTION_AUTO,
			TextServer.ORIENTATION_HORIZONTAL
		)
		
		draw_string(
			font,
			letter_pos + Vector2(-letter_size.x * 0.5, letter_size.y * 0.25),
			letter,
			HORIZONTAL_ALIGNMENT_LEFT,
			font_size,
			font_size,
			wheel_color,
			TextServer.JUSTIFICATION_NONE,
			TextServer.DIRECTION_AUTO,
			TextServer.ORIENTATION_HORIZONTAL
		)
		
		draw_line(
			(letter_pos - letter_pos.limit_length(1.0) * font_size).rotated(deg_to_rad(arc * 0.5)),
			(letter_pos + letter_pos.limit_length(1.0) * font_size).rotated(deg_to_rad(arc * 0.5)),
			wheel_color,
			2.0,
			false
		)
		
		var letter_rect := Rect2(
			(Vector2.RIGHT * radius).rotated(rad) - Vector2(font_size, font_size),
			Vector2(font_size * 2, font_size * 2)
		)
		
		#draw_rect(
			#letter_rect,
			#Color.GREEN if selection_window_rect.intersects(letter_rect) else Color.RED,
			#false,
			#2.0,
			#false
		#)
		
		if selection_window_rect.intersects(letter_rect):
			highlighted_letter = letter
	
	if highlighted_letter.is_empty() == false:
		current_letter_changed.emit.call_deferred(highlighted_letter)
	else:
		current_letter_changed.emit.call_deferred("")
	
	#draw_rect(
		#selection_window_rect,
		#Color.RED if highlighted_letter.is_empty() else Color.GREEN,
		#false,
		#2.0,
		#false
	#)

func shrink(speed: float = 0.25):
	var tween := get_tree().create_tween()
	tween.tween_property(self, "radius", 0.0, speed)
	tween.finished.connect(did_shrink.emit)

func grow(speed: float = 0.25, radius: float = 512.0, delay: float = 1.0):
	var tween := get_tree().create_tween()
	tween \
		.tween_property(self, "radius", radius, speed) \
		.set_delay(delay)
	tween.finished.connect(did_grow.emit)
