extends State
class_name goblin_archer_alerted

@onready var goblin = $"../.."
@onready var player = $"../../../Player"
@onready var nav_agent = $"../../nav_agent"
@onready var SPEED = goblin.speed
@onready var fall_acceleration = goblin.fall_acceleration

var is_circumventing_obstacle = false
var shoot_cooldown_timer = 0

func Enter():
	shoot_cooldown_timer = 0

func Exit():
	pass
	
func Update(delta: float):
	shoot_cooldown_timer += delta
	if (shoot_cooldown_timer >= goblin.SHOOT_COOLDOWN_TIME):
		shoot_cooldown_timer = 0
		transitioned.emit(self, "goblin_archer_attack")

func Physics_Update(_delta: float):
	goblin.look_at(player.global_position)
	
	if !goblin.sees_player || goblin.position.distance_to(player.position) > 20:
		var direction = Vector3()
	
		nav_agent.target_position = player.global_position
	
		direction = (nav_agent.get_next_path_position() - goblin.global_position).normalized()

		goblin.velocity = direction * SPEED
		goblin.move_and_slide()
