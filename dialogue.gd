extends Control

var expressions := {
	"happy": preload ("res://assets/emotion_happy.png"),
	"regular": preload ("res://assets/emotion_regular.png"),
	"sad": preload ("res://assets/emotion_sad.png"),
}

var bodies := {
	"sophia": preload ("res://assets/sophia.png"),
	"pink": preload ("res://assets/pink.png")
}

## An array of dictionaries. Each dictionary has two properties:
## - expression: a [code]Texture[/code] containing an expression
## - text: a [code]String[/code] containing the text the character says
var dialogue_items: Array[Dictionary] = [
	{
		"expression": expressions["regular"],
		"text": "What kind of food we are going to make for the [wave]food fair[/wave]",
		"character": bodies["sophia"],
	},
	{
		"expression": expressions["happy"],
		"text": "We should make cake!",
		"character": bodies["pink"],
	},
	{
		"expression": expressions["regular"],
		"text": "I want to make chicken wings! It's [shake]easier to make[/shake]",
		"character": bodies["sophia"],
	},
	{
		"expression": expressions["happy"],
		"text": "That sounds a good idea, I agree with you",
		"character": bodies["pink"],
	},
	{
		"expression": expressions["happy"],
		"text": "Hehe! Thank you! let's [tornado freq=3.0][rainbow val=1.0]do it!!![/rainbow][/tornado]",
		"character": bodies["sophia"],
	},
]
var current_item_index := 0

@onready var rich_text_label: RichTextLabel = %RichTextLabel
@onready var next_button: Button = %NextButton
@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer
@onready var body: TextureRect = %Body
@onready var expression: TextureRect = %Expression


func _ready() -> void:
	show_text()
	next_button.pressed.connect(advance)


## Draws the current text to the rich text element
func show_text() -> void:
	# We retrieve the current dictionary from the array and assign its
	# properties to the UI elements.
	var current_item := dialogue_items[current_item_index]
	
	rich_text_label.text = current_item["text"]
	expression.texture = current_item["expression"]
	body.texture = current_item["character"]
	# We animate the text appearing letter by letter.
	rich_text_label.visible_ratio = 0.0
	var tween := create_tween()
	var text_appearing_duration: float = current_item["text"].length() / 30.0
	tween.tween_property(rich_text_label, "visible_ratio", 1.0, text_appearing_duration)

	# This is where we play the audio. We randomize the audio playback's start
	# time to make it sound different every time.
	var sound_max_offset := audio_stream_player.stream.get_length() - text_appearing_duration
	var sound_start_position := randf() * sound_max_offset
	audio_stream_player.play(sound_start_position)
	# We stop the audio when the text finishes appearing.
	tween.finished.connect(audio_stream_player.stop)
	slide_in()
	next_button.disabled = true
	tween.finished.connect(func() -> void:
		next_button.disabled = false
		)


func advance() -> void:
	current_item_index += 1
	# If we reached the end of the dialogue, we quit the game. Otherwise, we
	# show the next dialogue line.
	if current_item_index == dialogue_items.size():
		get_tree().quit()
	else:
		show_text()
		
func slide_in() -> void:
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_OUT)
	body.position.x = 200.0
	tween.tween_property(body, "position:x", 0.0, 0.3)
	body.modulate.a = 0.0
	tween.parallel().tween_property(body, "modulate:a", 1.0, 0.2)
