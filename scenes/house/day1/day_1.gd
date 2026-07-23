extends Node3D


var postprocess:ShaderMaterial = preload("res://assets/materials/postprocess.tres")

func _ready() -> void:
	$Postprocess.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	$Player.lose_control()
	$StartCutscene/StartCutsceneAnim.play("StartCutscene")
	await $StartCutscene/StartCutsceneAnim.animation_finished
	$Player.position = Vector3(-8.0, 4.5, 16.0)
	$Player.rotation_degrees = Vector3(0.0, 90.0, 0.0)
	await $Dialogue.say("Its 8:00 AM..")
	$Player.take_control()
	
	await get_tree().create_timer(2.0).timeout
	await $Dialogue.say("I should take a shower.")
