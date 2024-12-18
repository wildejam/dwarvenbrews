extends Node3D

@onready var spawner1 = $spawner
@onready var spawner2 = $spawner2
@onready var spawner3 = $spawner3

func _process(_delta):
	var goblin_count = spawner1.goblins_active + spawner2.goblins_active + spawner3.goblins_active
	if goblin_count >= 30:
		spawner1.process_mode = Node.PROCESS_MODE_DISABLED
		spawner2.process_mode = Node.PROCESS_MODE_DISABLED
		spawner3.process_mode = Node.PROCESS_MODE_DISABLED
	else:
		spawner1.process_mode = Node.PROCESS_MODE_INHERIT
		spawner2.process_mode = Node.PROCESS_MODE_INHERIT
		spawner3.process_mode = Node.PROCESS_MODE_INHERIT
