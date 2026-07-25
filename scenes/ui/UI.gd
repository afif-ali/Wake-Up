extends Control


@onready var dialogue_node = $Dialogue/Text
@onready var tooltip_node = $Tooltip/Text
@onready var task_node = $Task/Text
@onready var progress_node = $Progress/ProgressBar
@onready var timer = $Timer

func set_text(text:String):
	visible = true
	dialogue_node.text = text

func say(text:String):
	dialogue_node.text = ""
	visible = true
	for i in range(text.length()):
		dialogue_node.text += text[i]
		timer.start(0.05)
		await timer.timeout
		if text[i] == "." or text[i] == "!" or text[i] == "?":
			timer.start(0.05)
			await timer.timeout

func clear_dialogue():
	dialogue_node.text = ""

func tooltip(text:String):
	tooltip_node.text = text

func clear_tooltip():
	tooltip_node.text = ""

func task(text:String):
	task_node.text = text
	
func clear_task():
	task_node.text = ""

func show_progress_bar():
	progress_node.visible = true

func hide_progress_bar():
	progress_node.visible = false

func set_progress(value:float):
	progress_node.value = value
