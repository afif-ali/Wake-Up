extends Node3D


@export var opened:bool = false
@onready var door: MeshInstance3D = $Door

const SPEED:int = 5

var reaching:bool = false

func _process(delta: float) -> void:
	if reaching:
		if Input.is_action_just_pressed("interact"):
			opened = !opened
	
	if opened:
		door.rotation.y = lerp_angle(door.rotation.y, deg_to_rad(-105), SPEED * delta)
	else:
		door.rotation.y = lerp_angle(door.rotation.y, deg_to_rad(0), SPEED * delta)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		reaching = true

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.name == "Player":
		reaching = false
