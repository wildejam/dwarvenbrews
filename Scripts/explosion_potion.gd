extends RigidBody3D

signal was_fired

@onready var player = $".."
@onready var projectile_mesh = $explosion_potion_mesh
@onready var projectile_collision = $explosion_potion_collision
@onready var aoe = $explosion_potion_aoe
@onready var aoe_visual = $explosion_potion_aoe/explosion_potion_aoe_visual
@export var direction = Vector3.ZERO

const speed = 2000
const VERTICAL_PROJECTILE_BOOST = 0.2
const DAMAGE_DEALT = 30
const AOE_SIZE = 4
const PROJECTILE_LINGER_TIME = 0.4
var force_value = Vector3.ZERO
var was_fired_flag = false

func _ready():
	freeze = true
	top_level = false
	aoe.scale = Vector3(AOE_SIZE, AOE_SIZE, AOE_SIZE)
	aoe.visible = false
	projectile_collision.disabled = true

func _physics_process(_delta):
	direction = player.transform.basis.z.normalized()
	direction.y += VERTICAL_PROJECTILE_BOOST
	
	if Input.is_action_pressed("shoot") && was_fired_flag == false:
		freeze = false
		top_level = true
		projectile_collision.disabled = false
		was_fired_flag = true
		was_fired.emit()
		apply_force(direction * speed)
		$potion_gun_fire.pitch_scale = randf_range(0.9, 1.1)
		$potion_gun_fire.play()
		

func _on_body_shape_entered(_body_rid, body, _body_shape_index, _local_shape_index):
	if(body == player):
		return
	freeze = true
	aoe.set_deferred("monitorable", true)
	projectile_collision.set_deferred("disabled", true)
	
	
	projectile_mesh.visible = false
	aoe.visible = true
	
	var bodies_hit = aoe.get_overlapping_bodies()
	
	for hit_body in bodies_hit:
		if hit_body.has_method("take_damage"):
			hit_body.take_damage(30)
	
	aoe.set_deferred("monitorable", false)
	$glass_shatter.pitch_scale = randf_range(0.9, 1.1)
	$explosion.pitch_scale = randf_range(0.9, 1.1)
	$glass_shatter.play()
	$explosion.play()
	
	await get_tree().create_timer(PROJECTILE_LINGER_TIME).timeout
	queue_free()
