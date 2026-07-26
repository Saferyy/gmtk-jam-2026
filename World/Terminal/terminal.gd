extends Control



var Score : Label
var Ncoeur = 3
signal close_terminal
@onready var COEUR_1 = $TextureRect2/Heart
@onready var COEUR_2 = $TextureRect2/Heart/Heart2
@onready var COEUR_3 = $TextureRect2/Heart/Heart2/Heart3

@onready var screensize  = get_viewport_rect().size

@onready var Goal : Label = $TextureRect2/Goal
@onready var Score_terminal : Label = $TextureRect2/Score
@onready var level : int


var enemy = preload("res://World/Terminal/Hacking/enemies.tscn")
var score = 0

func _ready():
	$".".visible = false
	$TextureRect2/Button/CharacterBody2D.visible = false
	$TextureRect2/Button2.visible= true
	
func get_spawn_position() -> Vector2:
	var side = randi_range(0, 3)
	match side:
		0: # Haut
			return Vector2(
				randi_range(0, screensize.x),
				-50
			)
		1: # Bas
			return Vector2(
				randi_range(0, screensize.x),
				screensize.y + 50
			)
		2: # Gauche
			return Vector2(
				-50,
				randi_range(0, screensize.y)
			)
		3: # Droite
			return Vector2(
				screensize.x + 50,
				randi_range(0, screensize.y)
			)
	return Vector2.ZERO
	
func spawn_enemy():
	var e = enemy.instantiate()
	e.position = get_spawn_position()
	add_child(e)
	e.died.connect(_on_enemy_died)

func _on_enemy_died(value):
	score += value
	Score_terminal.text = str(score)
	
	
func _on_character_body_2d_minus_hp() -> void:
	Ncoeur=Ncoeur-1
	if Ncoeur == 2 :
		COEUR_3.visible = 0
	if Ncoeur == 1 :
		COEUR_2.visible = 0
	if Ncoeur == 0 :
		COEUR_1.visible = 0
		close_terminal.emit()


func _on_button_2_button_down() -> void:
		$TextureRect2/Button/CharacterBody2D.visible = true
		$TextureRect2/Button2.visible=false
		spawn_enemy()
		

func _on_button_pressed() -> void:
	$".".visible = false
	print("Terminal fermé")
