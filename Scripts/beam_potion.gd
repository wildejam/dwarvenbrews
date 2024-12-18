extends RigidBody3D

signal was_fired

@onready var player = $".."
@onready var projectile_mesh = $beam_potion_mesh
@onready var projectile_collision = $beam_potion_collision
@onready var aoe = $beam_potion_aoe
@onready var aoe_visual = $beam_potion_aoe/beam_potion_aoe_visual
@export var direction = Vector3.ZERO

const speed = 2000
const VERTICAL_PROJECTILE_BOOST = 0.2
const DAMAGE_DEALT = 30
const PROJECTILE_LINGER_TIME = 1
var force_value = Vector3.ZERO
var was_fired_flag = false

func _ready():
	freeze = true
	top_level = false
	aoe.visible = false
	projectile_collision.disabled = true

func _physics_process(_delta):
	if Input.is_action_pressed("shoot") && was_fired_flag == false:
		freeze = true
		top_level = true
		
		was_fired_flag = true
		was_fired.emit()
		
		aoe.set_deferred("monitorable", true)
		aoe.visible = true
		
		for hit_body in aoe.get_overlapping_bodies():
			if hit_body.has_method("take_damage") && hit_body != player:
				hit_body.take_damage(100)
		
		$glass_shatter.pitch_scale = randf_range(0.9, 1.1)
		$beam.pitch_scale = randf_range(0.9, 1.1)
		$glass_shatter.play()
		$beam.play()
		await get_tree().create_timer(PROJECTILE_LINGER_TIME).timeout
		queue_free()
