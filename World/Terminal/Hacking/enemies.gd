extends Area2D

var speed = 0
var bullet_scene = preload("res://World/Terminal/Hacking/ennemies_bullet.tscn")
var anchor
var follow_anchor = false
@onready var screensize  = get_viewport_rect().size

signal died
	
func _on_shoot_timer_timeout():
	var b = bullet_scene.instantiate()
	get_tree().root.add_child(b)
	b.start(position)
	$ShootTimer.wait_time = randf_range(4, 20)
	$ShootTimer.start()


func _on_timer_timeout():
	speed = randf_range(75, 100)
	follow_anchor = false

func _on_move_timer_timeout() -> void:
	pass # Replace with function body.


func _on_area_entered(area: Area2D) -> void:
	died.emit()
	queue_free()
	
