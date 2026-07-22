extends Node3D

@onready var camrot_h = $camrot_h
@onready var camrot_v = $camrot_h/camrot_v

var cam_v_max = 75
var cam_v_min = -55
var h_sensitivity = 0.07
var v_sensitivity = 0.07
var h_acceleration = 15
var v_acceleration = 15

# Variables cibles (ce sont des floats, pas les nodes)
var target_h_rotation = 0.0
var target_v_rotation = 0.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		target_h_rotation += -event.relative.x * h_sensitivity
		target_v_rotation += event.relative.y * v_sensitivity
		target_v_rotation = clamp(target_v_rotation, cam_v_min, cam_v_max)

func _physics_process(delta):
	# MOUSE CAMERA
	camrot_h.rotation_degrees.y = lerp(float(camrot_h.rotation_degrees.y), target_h_rotation, delta * h_acceleration)
	camrot_v.rotation_degrees.x = lerp(float(camrot_v.rotation_degrees.x), target_v_rotation, delta * v_acceleration)
