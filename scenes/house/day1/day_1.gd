extends Node3D

enum STATE{
	START,
	CURRENT_TASK_SHOWER,
	SHOWERING,
	DONE_SHOWERING,
	CURRENT_TASK_EAT_BREAKFAST,
	DONE_EATING_BREAKFAST
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
			done_showering()
		STATE.CURRENT_TASK_EAT_BREAKFAST:
			current_task_eat_breakfast(delta)
		_: pass

var PlayerInsideShowerStateTrigger:bool = false
func _on_shower_state_trigger_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		if state == STATE.CURRENT_TASK_SHOWER:
			$UI.tooltip("Press [ E ] to shower.")
		PlayerInsideShowerStateTrigger = true
func _on_shower_state_trigger_body_exited(body: Node3D) -> void:
	if body.name == "Player":
		if state == STATE.CURRENT_TASK_SHOWER:
			$UI.clear_tooltip()
		PlayerInsideShowerStateTrigger = false
		
var PlayerInsideBreakfastTaskZone = false
func _on_breakfast_task_zone_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		PlayerInsideBreakfastTaskZone = true
func _on_breakfast_task_zone_body_exited(body: Node3D) -> void:
	if body.name == "Player":
		PlayerInsideBreakfastTaskZone = false

var PlayerInsideBreakfastEatZone = false
func _on_breakfast_eat_zone_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		if state == STATE.CURRENT_TASK_EAT_BREAKFAST:
			$UI.tooltip("Hold [ E ] to eat.")
		PlayerInsideBreakfastEatZone = true
func _on_breakfast_eat_zone_body_exited(body: Node3D) -> void:
	if body.name == "Player":
		if state == STATE.CURRENT_TASK_EAT_BREAKFAST:
			$UI.clear_tooltip()
		PlayerInsideBreakfastEatZone = false


var start_sequence_called = false
func start_sequence()->void:
	if !start_sequence_called:
		start_sequence_called = true
		$StartCutscene/StartCutsceneAnim.play("StartCutscene")
		await $StartCutscene/StartCutsceneAnim.animation_finished
		
		await $UI.say("Its 8:00 AM..")
		await get_tree().create_timer(2.0).timeout
		await $UI.say("I should take a shower.")
		await get_tree().create_timer(2.0).timeout
		$UI.clear_dialogue()
		$UI.task("> Take a shower")
		state = STATE.CURRENT_TASK_SHOWER

func current_task_shower()->void:
	if PlayerInsideShowerStateTrigger:
		if Input.is_action_just_pressed("interact"):
			$UI.clear_tooltip()
			state = STATE.SHOWERING

var showering_sequence_called = false
func showering_sequence()->void:
	if !showering_sequence_called:
		showering_sequence_called = true
		$ShowerState/ShowerStateAnim.play("showering")
		await $ShowerState/ShowerStateAnim.animation_finished
		$UI.clear_task()
		state = STATE.DONE_SHOWERING

func done_showering()->void:
	if PlayerInsideBreakfastTaskZone:
		state = STATE.CURRENT_TASK_EAT_BREAKFAST
		await $UI.say("I should eat breakfast")
		await get_tree().create_timer(2.0).timeout
		$UI.task("> Eat breakfast")
		$UI.clear_dialogue()

var breakfast_progress:float = 0.0
const BREAKFAST_SPEED:float = 10.0
func current_task_eat_breakfast(delta:float)->void:
	if PlayerInsideBreakfastEatZone:
		if Input.is_action_pressed("interact"):
			breakfast_progress += BREAKFAST_SPEED * delta
			breakfast_progress = clamp(breakfast_progress, 0.0, 100.0)
			$UI.show_progress_bar()
			$UI.set_progress(breakfast_progress)
		else:
			breakfast_progress = 0.0
			$UI.hide_progress_bar()
			$UI.set_progress(breakfast_progress)
		
		if breakfast_progress >= 100.0:
			$Props/Breakfast/Toasts.visible = false
			$UI.hide_progress_bar()
			$UI.clear_task()
			$UI.clear_tooltip()
			state = STATE.DONE_EATING_BREAKFAST
	else:
		breakfast_progress = 0.0
		$UI.hide_progress_bar()
		$UI.set_progress(breakfast_progress)
