extends Control

## An array of strings. Each string contains the text we want the character to
## say.
var dialogue_items: Array[String] = [
	"I'm hungry",
	"But i am still working on.",
	"When is  the lunch",
	"Did I get it right? Did I?",
	"Okay Bye bye~!",
]
## Holds the index of the currently displayed text
var current_item_index := 0

@onready var rich_text_label: RichTextLabel = %RichTextLabel
@onready var next_button: Button = %NextButton
@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer


func _ready() -> void:
	show_text()
	next_button.pressed.connect(advance)

## Draws the current text to the rich text element
func show_text() -> void:
	var current_item := dialogue_items[current_item_index]
	rich_text_label.text = current_item
	# We animate the text appearing letter by letter.
	rich_text_label.visible_ratio = 0.0
	var tween := create_tween()
	var text_appearing_duration := 1.2
	tween.tween_property(rich_text_label, "visible_ratio", 1.0, text_appearing_duration)
	# This is where we play the audio. We randomize the audio playback's start
	# time to make it sound different every time.
	var sound_max_offset := audio_stream_player.stream.get_length() - text_appearing_duration
	var sound_start_position := randf() * sound_max_offset
	audio_stream_player.play(sound_start_position)
	# We stop the audio when the text finishes appearing.
	tween.finished.connect(audio_stream_player.stop)

func advance() -> void:
	current_item_index += 1
	# If we reached the end of the dialogue, we quit the game. Otherwise, we
	# show the next dialogue line.
	if current_item_index == dialogue_items.size():
		get_tree().quit()
	else:
		show_text()
