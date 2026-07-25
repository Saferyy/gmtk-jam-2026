extends RigidBody3D

@export_category("Movement")
@export var speed := 4.5
@export var acceleration := 8.0

@export_category("Jump")
@export var jump_height := 2.5
@export var jump_time_to_peak := 0.4
@export var jump_time_to_fall := 0.35

@export_category("Sprint")
@export var sprint_speed := 8.0
@export var sprint_energy_cost := 3
var is_sprinting := false

@onready var visual_root = $VisualRoot
@onready var player_model = $VisualRoot/robot
@onready var robot_model : Node3D = $VisualRoot/robot
@onready var anim : AnimationPlayer = robot_model.get_node("AnimationPlayer")

@export var COUNTER : int = 500 # timer de 1s, donc une partie dure minimum 1min40.
@onready var Label_counter : Label = $CanvasLayer/Label_counter
@onready var Slider_Counter : VSlider = $CanvasLayer/VSlider
@onready var Timer_counter : Timer = $Timer_counter
var Timer_counter_ready : bool = true
var is_doing_action : bool = false

@export var value_energie : int = 1
@onready var player : RigidBody3D = $"."

var target : Vector3


signal restartgame

@onready var jump_velocity = ((2.0 * jump_height) / jump_time_to_peak)
@onready var jump_gravity = ((2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak))
@onready var fall_gravity = ((2.0 * jump_height) / (jump_time_to_fall * jump_time_to_fall))
var target_rotation := 0.0
var is_on_floor := false
var was_on_floor := false

func get_animation_player(node: Node) -> AnimationPlayer:
	for child in node.get_children():
		if child is AnimationPlayer:
			return child
		var result = get_animation_player(child)
		if result:
			return result
	return null


func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	var camera = get_viewport().get_camera_3d()
	if camera == null:
		return

	# Mouvement relatif à la caméra
	var input = Input.get_vector(
		"left",
		"right",
		"up",
		"down"
	)
	input = input.rotated(-camera.global_rotation.y)

	if Input.is_action_just_pressed("shoot"):
		print("shoot")
		launched = true
		launch()

	if Input.is_action_just_released("shoot"):
		retract()
		

	if launched:
		handle_grapple(state)

	var velocity_2d = Vector2(state.linear_velocity.x, state.linear_velocity.z)
	var moving = input.length() > 0

	# Mouvement
	if moving && launched == false:
		is_sprinting = Input.is_action_pressed("sprint") and COUNTER > 0
		var current_speed = speed
		if is_sprinting:
			current_speed = sprint_speed
			value_energie = sprint_energy_cost
			print("sprinting")
		else:
			value_energie = 1

		velocity_2d += input * current_speed * acceleration * state.step
		velocity_2d = velocity_2d.limit_length(current_speed)

		if launched == false:
			state.linear_velocity.x = velocity_2d.x
			state.linear_velocity.z = velocity_2d.y

		if anim.current_animation != "Walk_001":
			value_energie = 1
			anim.play("Walk_001")
			is_doing_action = true
		target_rotation = -input.angle()
	else:
		if anim.current_animation != "Idle" && launched == false:
			anim.play("Idle")
			is_doing_action = false



	# Floor
	is_on_floor = check_floor(state)
	if Input.is_action_just_pressed("jump") && is_on_floor && launched == false:
		value_energie = 10
		is_doing_action = true
		state.linear_velocity.y = jump_velocity

	# Friction
	physics_material_override.friction = (0.0 if (moving || launched) else 0.8)

	# Freinage dans les airs
	if !is_on_floor && !moving && launched == false:
		velocity_2d = velocity_2d.move_toward(
			Vector2.ZERO,
			speed * state.step
		)
		state.linear_velocity.x = velocity_2d.x
		state.linear_velocity.z = velocity_2d.y

	# Gravité
	var gravity = (
		jump_gravity
		if state.linear_velocity.y > 0
		else fall_gravity
	)
	state.linear_velocity.y -= gravity * state.step

	# Atterrissage
	if !was_on_floor && is_on_floor:
		pass
	was_on_floor = is_on_floor


func _physics_process(delta) -> void:
	if is_doing_action == true:
		print("counter", COUNTER)
		counter()


func _on_timer_counter_timeout() -> void:
	Timer_counter_ready = true
	#print("Timer_counter_ready", Timer_counter_ready)


func check_floor(state: PhysicsDirectBodyState3D) -> bool:
	for i in state.get_contact_count():
		var normal = state.get_contact_local_normal(i)
		if normal.dot(Vector3.UP) > 0.5:
			return true
	return false
	
	
	
	
