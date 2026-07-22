extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_visible(false) 



func _on_button_pressed() -> void:
	AudioServer.set_bus_volume_db(0,linear_to_db($"AudioOption/VBoxContainer/HSlider3 SFX Master".value))
	AudioServer.set_bus_volume_db(0,linear_to_db($"AudioOption/VBoxContainer/HSlider3 Music".value))
	AudioServer.set_bus_volume_db(0,linear_to_db($"AudioOption/VBoxContainer/HSlider3 SFX".value))

func _on_button_pressed2() -> void:
	set_visible(true) 
