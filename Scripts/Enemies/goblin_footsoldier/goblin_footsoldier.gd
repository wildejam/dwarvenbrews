extends CharacterBody3D

@onready var player = $"../Player"
@onready var state_machine = $"State Machine"
@onready var player_raycast = $player_raycast
@onready var nav_agent = $nav_agent
@onready var hurtbox = $hurtbox
@onready var current_hp = 75
@onready var spawner = $".."

@export var max_hp = 75
@export var fall_acceleration = 30
@export var DETECT_RANGE = 9999
@export var MELEE_RANGE = 1.7
@export var speed = 8
@export var sees_player = false
@export var POINTS_VALUE = 20

func _ready():
	$alerted.pitch_scale = randf_range(1.1,1.4)
	$alerted.play()
	$AnimationPlayer.advance(randf() * 2)

func _process(_delta):
	player_raycast.global_position = global_position
	player_raycast.target_position =  player.global_position - global_position
	player_raycast.target_position.y = player_raycast.target_position.y
	
	if player_raycast.get_collider() != player:
		sees_player = false
	else:
		sees_player = true

func apply_gravity(delta):
	# fall because gravity hehe
	if not is_on_floor():
		velocity.y = velocity.y - (fall_acceleration * delta)

func take_damage(damage):
	current_hp = clamp(0, current_hp - damage, max_hp)
	
	var current_state = state_machine.current_state
	if current_hp <= 0:
		state_machine.manual_state_change(current_state, "goblin_footsoldier_death")
	else:
		state_machine.manual_state_change(current_state, "goblin_footsoldier_damaged")
