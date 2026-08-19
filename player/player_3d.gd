extends CharacterBody3D

@export_group("Camera")
@export_range(0.0, 1.0) var mouse_sensitivity := 0.25

@export_group("Movement")
@export var max_speed := 8.0
@export var acceleration := 40.0
@export var rotation_speed := 12.0

var _camera_input_direction := Vector2.ZERO

@onready var camera_pivot: Node3D = %CameraPivot
@onready var camera: Camera3D = %Camera3D
@onready var test_appearance: MeshInstance3D = %testAppearance


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _unhandled_input(event: InputEvent) -> void:
	#The mouse just moved and is captured by the game window.
	var is_camera_motion := (
		event is InputEventMouseMotion and 
		Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	)
	if is_camera_motion:
		_camera_input_direction = event.screen_relative * mouse_sensitivity
		
		
func _physics_process(delta: float) -> void:
	camera_pivot.rotation.x -= _camera_input_direction.y * delta
	camera_pivot.rotation.x = clamp(camera_pivot.rotation.x, 
	-PI / 2.1, PI / 2.1)
	camera_pivot.rotation.y -= _camera_input_direction.x * delta
	
	_camera_input_direction = Vector2.ZERO
	
	
	var input := Input.get_vector("move_left", "move_right", "move_up",
		"move_down")
		
	var rotatedInput := input.rotated(-camera.global_rotation.y)
	var inputVector : Vector3
	
	inputVector.x = rotatedInput.x
	inputVector.y = 0
	inputVector.z = rotatedInput.y
	
	velocity = inputVector * max_speed
	move_and_slide()
	
