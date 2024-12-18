extends Node3D

@onready var enter_area = $enter_area
@onready var player = $"../../Player"

func _physics_process(_delta):
	look_at(player.global_position)
	rotation.x = 0

func _on_enter_area_body_entered(body):
	if body == player:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().paused = true
