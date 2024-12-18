extends State
class_name goblin_footsoldier_follow

@onready var goblin = $"../.."
@onready var player = $"../../../Player"
@onready var nav_agent = $"../../nav_agent"
@onready var SPEED = goblin.speed
@onready var fall_acceleration = goblin.fall_acceleration
@onready var MELEE_RANGE = goblin.MELEE_RANGE

var is_circumventing_obstacle = false

func Enter():
	pass

func Exit():
	pass
	
func Update(_delta: float):
	var player_pos = player.position
	var goblin_pos = goblin.position
	
	# switch to attack state if in melee range
	if player_pos.distance_to(goblin_pos) < MELEE_RANGE:
		transitioned.emit(self, "goblin_footsoldier_attack")
	
func Physics_Update(_delta: float):
	
	goblin.look_at(player.global_position)
	var direction = Vector3()
	
	nav_agent.target_position = player.global_position
	
	direction = (nav_agent.get_next_path_position() - goblin.global_position).normalized()

	goblin.velocity = direction * SPEED
	goblin.move_and_slide()
