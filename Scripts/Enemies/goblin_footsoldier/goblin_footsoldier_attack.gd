extends State
class_name goblin_footsoldier_attack

@onready var hitbox = $"../../sword_hitbox"
@onready var gobbin_active = $"../../GobbinSwordActive"
@onready var gobbin_inactive = $"../../GobbinSwordInactive"
@onready var player = $"../../../Player"
@onready var goblin = $"../.."

const TIME_BEFORE_SWING = 0.3
const TIME_HITBOX_ACTIVE = 0.3
const TIME_AFTER_SWING = 0.5

func Enter():
	await get_tree().create_timer(TIME_BEFORE_SWING).timeout
	
	goblin.look_at(player.global_position)
	gobbin_inactive.hide()
	gobbin_active.show()
	var bodies_hit = hitbox.get_overlapping_bodies()
	for body in bodies_hit:
		if body == player:
			body.take_damage(30)
	$"../../swing".pitch_scale = randf_range(1.1,1.4)
	$"../../swing".play()
	
	await get_tree().create_timer(TIME_HITBOX_ACTIVE).timeout
	
	gobbin_inactive.show()
	gobbin_active.hide()
	
	await get_tree().create_timer(TIME_AFTER_SWING).timeout
	
	transitioned.emit(self, "goblin_footsoldier_follow")

func Exit():
	pass
	
func Update(_delta: float):
	pass
	
func Physics_Update(_delta: float):
	pass
