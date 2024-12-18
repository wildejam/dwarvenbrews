extends State
class_name goblin_archer_idle

@onready var goblin = $"../.."
@onready var player = $"../../../Player"
@onready var DETECT_RANGE = goblin.DETECT_RANGE

func Enter():
	pass

func Exit():
	pass
	
func Update(_delta: float):
	# if in range of player, change state to follow
	var player_pos = player.global_position
	var goblin_pos = goblin.global_position
	
	if (player_pos.distance_to(goblin_pos) < DETECT_RANGE
	 	&& goblin.player_raycast.get_collider() == player):
		transitioned.emit(self, "goblin_archer_alerted")
	
func Physics_Update(delta: float):
	goblin.apply_gravity(delta)
	goblin.move_and_slide()
