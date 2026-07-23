extends Control


@onready var text_node = $MarginContainer/Text
@onready var timer = $Timer

func set_text(text:String):
	visible = true
	text_node.text = text

func say(text:String):
	text_node.text = ""
	visible = true
	for i in range(text.length()):
		text_node.text += text[i]
		timer.start(0.05)
		await timer.timeout
		if text[i] == "." or text[i] == "!" or text[i] == "?":
			timer.start(0.05)
			await timer.timeout

func clear():
	text_node.text = ""
	visible = false
