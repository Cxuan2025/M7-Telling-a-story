extends Control

## An array of strings. Each string contains the text we want the character to
## say.
var expressions := {
	"happy": preload ("res://assets/emotion_happy.png"),
	"regular": preload ("res://assets/emotion_regular.png"),
	"sad": preload ("res://assets/emotion_sad.png"),
}


var dialogue_items: Array[Dictionary] = [
	{
		"expression": expressions["sad"],
		"text": "I'm hungry",
	},
	{
		"expression": expressions["sad"],
		"text": "But i am still working on",
	},
	{
		"expression": expressions["regular"],
		"text": "When is  the lunch",
	},
	{
		"expression": expressions["happy"],
		"text": "Finally I can enjoy my lunch",
	},
	{
		"expression": expressions["happy"],
		"text": "Okay Bye bye~!",
	},
	]
## Holds the index of the currently displayed text
var current_item_index := 0

@onready var rich_text_label: RichTextLabel = %RichTextLabel
@onready var next_button: Button = %NextButton
@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer
@onready var expression: TextureRect = %Expression
@onready var body: TextureRect = %Body


func _ready() -> void:
	show_text()
	next_button.pressed.connect(advance)

## Draws the current text to the rich text element
func show_text() -> void:
	var current_item := dialogue_items[current_item_index]
	rich_text_label.text = current_item["text"]
	expression.texture = current_item["expression"]
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
