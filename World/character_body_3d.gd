extends CharacterBody3D


const SPEED = 15.0
const JUMP_VELOCITY = 4.5


@export var COUNTER : int = 100 # timer of 1 s, that's mean 1 game is minimum 1min40.
@onready var Label_counter : Label = $CanvasLayer/VSplitContainer/Label_counter
@onready var Slider_Counter :VSlider= $CanvasLayer/VSplitContainer/Slider_Counter
@onready var Timer_counter : Timer = $Timer_counter
var Timer_counter_ready: bool = true
var is_doing_action: bool= true


func _ready() -> void:
	@warning_ignore("integer_division")
	Label_counter.text = str(COUNTER) 
	Slider_Counter.value= COUNTER
	Slider_Counter.max_value=COUNTER

	
func counter():
	if Timer_counter_ready == true :
		COUNTER =COUNTER-1
		Label_counter.text = str(COUNTER) 
		Slider_Counter.value= COUNTER
		print("COUNTER",COUNTER)
		Timer_counter_ready = false
		Timer_counter.start()
		@warning_ignore("integer_division")


		

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() :
		velocity.y = JUMP_VELOCITY
		@warning_ignore("standalone_expression")
		is_doing_action == true

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction :
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		@warning_ignore("standalone_expression")
		is_doing_action == true
		
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

	if is_doing_action ==true:
		counter()

func _on_timer_counter_timeout() -> void:
	Timer_counter_ready = true
