extends CharacterBody3D

@onready var arrow_scene = preload("res://Scenes/enemies/arrow.tscn")
@onready var player = $"../Player"
@onready var goblin_mesh = $body_mesh
@onready var state_machine = $"State Machine"
@onready var player_raycast = $player_raycast
@onready var nav_agent = $nav_agent
@onready var current_hp = 50
@onready var spawner = $"../spawner"

@export var max_hp = 50
@export var fall_acceleration = 30
@export var DETECT_RANGE = 9999
@export var speed = 7
@export var sees_player = false
@export var SHOOT_COOLDOWN_TIME = 1
@export var POINTS_VALUE = 40

func _ready():
	$alerted.pitch_scale = randf_range(1.1,1.4)
	$alerted.play()
	$AnimationPlayer.advance(randf() * 2)

func _process(_delta):
	# checks if can see player
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
		state_machine.manual_state_change(current_state, "goblin_archer_death")
	else:
		state_machine.manual_state_change(current_state, "goblin_archer_damaged")
