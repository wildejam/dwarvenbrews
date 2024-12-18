extends RigidBody3D

@onready var player = $"../../Player"
@onready var arrow_collision = $arrow_collision
@onready var arrow_mesh = $GobbinArrow
@onready var goblin = $".."

@export var ARROW_FORCE_MULTIPLIER = 2000
@export var ARROW_DAMAGE = 20

func _ready():
	freeze = true
	top_level = false
	arrow_mesh.visible = false
	arrow_collision.disabled = true
	contact_monitor = false
	
func _on_goblin_archer_attack_arrow_fired():
	freeze = false
	top_level = true
	arrow_collision.disabled = false
	arrow_mesh.visible = true
	contact_monitor = true
	
	apply_force(-goblin.basis.z * ARROW_FORCE_MULTIPLIER)


func _on_body_shape_entered(_body_rid, body, _body_shape_index, _local_shape_index):
	freeze = true
	arrow_collision.set_deferred("disabled", true)
	arrow_mesh.visible = false
	
	if(body == player):
		player.take_damage(ARROW_DAMAGE)
	
	queue_free()
	
