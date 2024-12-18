extends State
class_name goblin_footsoldier_damaged

@onready var goblin = $"../.."
@onready var fall_acceleration = goblin.fall_acceleration

const DAMAGED_TIMER = 0.3

func Enter():
	$"../../damaged".pitch_scale = randf_range(1.1,1.4)
	$"../../damaged".play()

func Exit():
	pass
	
func Update(_delta: float):
	pass
	
func Physics_Update(_delta: float):
	goblin.velocity = Vector3.ZERO
	await get_tree().create_timer(DAMAGED_TIMER).timeout
	transitioned.emit(self, "goblin_footsoldier_follow")
