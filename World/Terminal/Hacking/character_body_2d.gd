extends CharacterBody2D

const SPEED = 300.0
var HP = 3
@export var cooldown = 0.25
@export var bullet_scene : PackedScene
@onready var screensize = get_viewport_rect().size
var can_shoot = true

signal Minus_HP

func _ready():
	start()

func start():
	position = Vector2(screensize.x / 2, screensize.y - 64)
	$GunCooldown.wait_time = cooldown


func _physics_process(delta):

	var direction = Input.get_vector("left", "right", "up", "down")

	if direction.length() > 0:
		# Déplacement
		velocity = direction * SPEED
		# Rotation du vaisseau vers la direction
		rotation = direction.angle()
	else:
		velocity = Vector2.ZERO
		
	move_and_slide()

	if Input.is_action_pressed("jump"):
		#shoot()
		pass
	
func shoot():
	if not can_shoot:
		return
	can_shoot = false
	$GunCooldown.start()
	var b = bullet_scene.instantiate()
	get_tree().root.add_child(b)
	b.start(position + Vector2(0, -8))


func _on_area_2d_area_entered(area: Area2D) -> void:
	if HP >0 :
		HP = HP-1
		Minus_HP.emit()
	else:
		Minus_HP.emit()
