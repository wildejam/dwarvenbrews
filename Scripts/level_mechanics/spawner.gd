extends Node3D

@onready var goblin_footsoldier = preload("res://Scenes/enemies/goblin_footsoldier.tscn")
@onready var goblin_archer = preload("res://Scenes/enemies/goblin_archer.tscn")
@onready var ui = $"../Player/ui"

var footsoldier_timer = 0
var archer_timer = 0
var footsoldier_spawntime = 7
var archer_spawntime = 10

@export var goblins_active = 0

const FOOTSOLDIER_STARTER_SPAWNTIME = 10
const ARCHER_STARTER_SPAWNTIME = 20

func _process(_delta):
	footsoldier_spawntime = clamp(0, FOOTSOLDIER_STARTER_SPAWNTIME - (ui.timer / 10), FOOTSOLDIER_STARTER_SPAWNTIME) + 1
	archer_spawntime = clamp(0, ARCHER_STARTER_SPAWNTIME - (ui.timer / 10), ARCHER_STARTER_SPAWNTIME) + 1
func _physics_process(delta):
	footsoldier_timer += delta
	archer_timer += delta
	
	if (footsoldier_timer > footsoldier_spawntime):
		var new_goblin = goblin_footsoldier.instantiate()
		new_goblin.position = global_position
		get_node("/root/level1").add_child(new_goblin)
		new_goblin.spawner = self
		footsoldier_timer = 0
		
		goblins_active += 1
		
	if (archer_timer > archer_spawntime):
		var new_goblin = goblin_archer.instantiate()
		new_goblin.position = global_position + Vector3(2,0,0)
		get_node("/root/level1").add_child(new_goblin)
		new_goblin.spawner = self
		archer_timer = 0
		
		goblins_active += 1
