extends Control

@onready var rich_text_label: RichTextLabel = %RichTextLabel
@onready var next_button: Button = %NextButton

## An array of strings. Each string contains the text we want the character to
## say.
var dialogue_items: Array[String] = [
	"I'm hungry",
	"I need foods.",
	"But I'm still doing my work",
	"I think i got it?",
	"Hehe! Bye bye~!",
]
## Holds the index of the currently displayed text
var current_item_index := 0

func _ready() -> void:
	show_text()
	next_button.pressed.connect(advance)

## Draws the current text to the rich text element
func show_text() -> void:
	var current_item := dialogue_items[current_item_index]
	rich_text_label.text = current_item

func advance() -> void:
	current_item_index += 1
	# If we reached the end of the dialogue, we quit the game. Otherwise, we
	# show the next dialogue line.
	if current_item_index == dialogue_items.size():
		get_tree().quit()
	else:
		show_text()
