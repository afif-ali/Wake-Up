extends Node3D

enum STATE{
	START,
	CURRENT_TASK_SHOWER,
	SHOWERING,
	DONE_SHOWERING
}

var state:STATE


func _ready() -> void:
	$Postprocess.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	state = STATE.START

func _process(delta: float) -> void:
	match state:
		STATE.START:
			start_sequence()
		STATE.CURRENT_TASK_SHOWER:
			current_task_shower()
		STATE.SHOWERING:
			showering_sequence()
		STATE.DONE_SHOWERING:
			pass
		_: pass

var PlayerInsideShowerStateTrigger:bool = false
func _on_shower_state_trigger_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		PlayerInsideShowerStateTrigger = true
func _on_shower_state_trigger_body_exited(body: Node3D) -> void:
	if body.name == "Player":
		PlayerInsideShowerStateTrigger = false

var start_sequence_called = false
func start_sequence()->void:
	if !start_sequence_called:
		start_sequence_called = true
		$StartCutscene/StartCutsceneAnim.play("StartCutscene")
		await $StartCutscene/StartCutsceneAnim.animation_finished
		
		await $Dialogue.say("Its 8:00 AM..")
		await get_tree().create_timer(2.0).timeout
		await $Dialogue.say("I should take a shower.")
		state = STATE.CURRENT_TASK_SHOWER

func current_task_shower()->void:
	if PlayerInsideShowerStateTrigger:
		if Input.is_action_just_pressed("interact"):
			await $Dialogue.clear()
			state = STATE.SHOWERING

var showering_sequence_called = false
func showering_sequence()->void:
	if !showering_sequence_called:
		showering_sequence_called = true
		$ShowerState/ShowerStateAnim.play("showering")
		await $ShowerState/ShowerStateAnim.animation_finished
		state = STATE.DONE_SHOWERING
