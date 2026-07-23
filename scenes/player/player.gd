extends CharacterBody3D


const SPEED:int = 3
const ACCELERATION:int = 20
const DECELERATION:int = 10
const GRAVITY:int = 30

const MOUSE_SENSITIVITY:float = 0.02
const CAMERA_SMOOTH_FACTOR:int = 10
const MIN_CAMERA_ANGLE:int = -60
const MAX_CAMERA_ANGLE:int = 70

const BOB_AMPLITUDE:float = 0.05
const BOB_FREQUENCY:float = 10.0
const BOB_ANGLE:float = 0.5
const BOB_SETTLE_SPEED:float = 10.0


@onready var camera = $Camera3D
@onready var camera_pos = $CameraPos

@export var controlling = false

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	camera.position = camera_pos.position

var mouse_delta_pos:Vector2 = Vector2.ZERO
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			mouse_delta_pos = event.relative

var previous_mouse_delta_pos:Vector2 = Vector2.ZERO
var target_camera_rotation:Vector2 = Vector2.ZERO
func _process(delta: float) -> void:
	if mouse_delta_pos != previous_mouse_delta_pos:
		target_camera_rotation.y = wrapf(rotation.y - mouse_delta_pos.x * MOUSE_SENSITIVITY, 0.0, 2 * PI)
		target_camera_rotation.x = wrapf(camera.rotation.x - mouse_delta_pos.y * MOUSE_SENSITIVITY, 0.0, 2 * PI)
	
	rotation.y = lerp_angle(rotation.y, target_camera_rotation.y, CAMERA_SMOOTH_FACTOR * delta)
	camera.rotation.x = lerp_angle(camera.rotation.x, target_camera_rotation.x, CAMERA_SMOOTH_FACTOR * delta)
	camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(MIN_CAMERA_ANGLE), deg_to_rad(MAX_CAMERA_ANGLE))
	previous_mouse_delta_pos = mouse_delta_pos

var bob_time:float = 0.0
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= GRAVITY * delta

	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var movement_vector:Vector2

	if direction:
		movement_vector.x = lerp(velocity.x, direction.x * SPEED, ACCELERATION * delta)
		movement_vector.y = lerp(velocity.z, direction.z * SPEED, ACCELERATION * delta)
		
		camera.position.y = camera_pos.position.y + BOB_AMPLITUDE * sin(bob_time * BOB_FREQUENCY)
		camera.position.x = camera_pos.position.x + BOB_AMPLITUDE * sin(bob_time * BOB_FREQUENCY * 0.5)
		camera.rotation.z = deg_to_rad(BOB_ANGLE) * sin(bob_time * BOB_FREQUENCY * 0.5)
	else:
		movement_vector.x = lerp(velocity.x, 0.0, DECELERATION * delta)
		movement_vector.y = lerp(velocity.z, 0.0, DECELERATION * delta)
		
		camera.position = lerp(camera.position, camera_pos.position, BOB_SETTLE_SPEED * delta)
		camera.rotation.z = lerp_angle(camera.rotation.z, 0.0, BOB_SETTLE_SPEED * delta)
		bob_time = 0.0

	velocity.x = movement_vector.x
	velocity.z = movement_vector.y

	bob_time += delta
	move_and_slide()


func take_control():
	camera.current = true
	
	set_process(true)
	set_physics_process(true)
	set_process_unhandled_input(true)
	
	target_camera_rotation.y = rotation.y
	target_camera_rotation.x = camera.rotation.x

func lose_control():
	set_process(false)
	set_physics_process(false)
	set_process_unhandled_input(false)
