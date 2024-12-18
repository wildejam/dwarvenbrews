extends State
class_name goblin_archer_attack

signal arrow_fired

@onready var player = $"../../../Player"
@onready var goblin = $"../.."
@onready var arrow = $"../../arrow"
@onready var gobbin_active = $"../../GobbinCrossbowActive"
@onready var gobbin_inactive = $"../../GobbinCrossbowInactive"

const INITIAL_PROJECTILE_POSITION = Vector3(0,0.2,-1.1)

func Enter():
	# enable collision & make mesh visible
	arrow.process_mode = Node.PROCESS_MODE_INHERIT
	arrow.visible = true

func Exit():
	pass
	
func Update(_delta: float):
	pass
	
func Physics_Update(_delta: float):
	arrow_fired.emit()
	gobbin_inactive.hide()
	gobbin_active.show()
	
	arrow = goblin.arrow_scene.instantiate()
	arrow.position = INITIAL_PROJECTILE_POSITION
	goblin.add_child(arrow)
	arrow_fired.connect(arrow._on_goblin_archer_attack_arrow_fired)
	$"../../swing".pitch_scale = randf_range(1.1,1.4)
	$"../../swing".play()
	
	gobbin_inactive.show()
	gobbin_active.hide()
	
	transitioned.emit(self, "goblin_archer_alerted")
