extends Button


var world_scene = preload("res://World/World.tscn").instantiate()

func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://World/World.tscn")
