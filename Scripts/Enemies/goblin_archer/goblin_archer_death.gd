extends State
class_name goblin_archer_death

@onready var goblin = $"../.."
@onready var player = $"../../../Player"

func Enter():
	$"../../death".pitch_scale = randf_range(1.1,1.4)
	$"../../death".play()
	
	var POINTS_VALUE = goblin.POINTS_VALUE
	
	goblin.velocity = Vector3.ZERO
	
	goblin.rotate_object_local(Vector3(1,0,0), -1.5)
	goblin.global_position.y -= 1
	
	goblin.process_mode = Node.PROCESS_MODE_DISABLED
	
	# give player points
	player.add_points(POINTS_VALUE)
	goblin.spawner.goblins_active -= 1
	
	await get_tree().create_timer(5).timeout
	goblin.queue_free()

func Exit():
	pass
	
func Update(_delta: float):
	pass
	
func Physics_Update(_delta: float):
	pass
