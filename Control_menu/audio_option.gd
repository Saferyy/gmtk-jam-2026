extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"VBoxContainer/HSlider Master".value =db_to_linear(AudioServer.get_bus_volume_db(0))
	$"VBoxContainer/HSlider Music".value = db_to_linear(AudioServer.get_bus_volume_db(1))
	$"VBoxContainer/HSlider3 SFX".value = db_to_linear(AudioServer.get_bus_volume_db(2))
	

func _on_h_slider_master_mouse_exited() -> void:
	release_focus()	

func _on_h_slider_music_mouse_exited() -> void:
	release_focus()

func _on_h_slider_3_mouse_exited() -> void:
	release_focus()	
