extends CharacterBody3D

@onready var explosion = preload("res://Scenes/player/explosion_potion.tscn")
@onready var heal = preload("res://Scenes/player/healing_potion.tscn")
@onready var beam = preload("res://Scenes/player/beam_potion.tscn")
@onready var blackhole = preload("res://Scenes/player/blackhole_potion.tscn")


@onready var projectile = explosion
@onready var projectile_instance = $explosion_potion
@onready var current_hp: int = 100
@export var max_hp = 100
@export var speed = 15
@export var fall_acceleration = 75
@export var points = 0

@export var num_healing_potions = 2
@export var num_beam_potions = 0
@export var num_blackhole_potions = 0


var target_velocity = Vector3.ZERO
var direction = Vector3.ZERO
var reload_timer = 0
var reload_flag = false
var footstep_timer = 0

const look_sensitivity_multiplier = 0.001
const jump_velocity = 20
const INITIAL_PROJECTILE_POSITION = Vector3(0,-0.351,0.967)
const RELOAD_TIME = 0.5

signal hp_changed
signal points_changed
signal weapon_changed
signal ammo_changed

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(_delta):
	global_rotation_degrees.x = clamp(-80, global_rotation_degrees.x, 80)
	global_rotation.z = 0

# movement
func _physics_process(delta):
	direction = Vector3.ZERO
	var better_basis = transform.basis
	better_basis.y = Vector3(0,0,0)
	better_basis.z.y = 0 
	better_basis.z = better_basis.z.normalized()
	
	# Input handling
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_up"):
		direction.z += 1
	if Input.is_action_pressed("ui_down"):
		direction.z -= 1
	
	direction = (direction * better_basis).normalized()
	
	target_velocity.x = -direction.x * speed
	target_velocity.z = direction.z * speed
	
	# logic for falling
	if not is_on_floor():
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
	elif is_on_floor() && Input.is_action_just_pressed("ui_accept"):
		target_velocity.y = jump_velocity
		
	velocity = target_velocity
	move_and_slide()
	
	if (abs(velocity.x) > 0 || abs(velocity.z) > 0) && is_on_floor:
		footstep_timer += delta
		if footstep_timer >= 0.3:
			if(randi() % 2 == 0):
				$"sfx/footstep 1".pitch_scale = randf_range(1.15, 1.35)
				$"sfx/footstep 1".play()
			else:
				$"sfx/footstep 2".pitch_scale = randf_range(1.15, 1.35)
				$"sfx/footstep 2".play()
			footstep_timer = 0
	else:
		footstep_timer = 0
	
	# reload handling
	if (reload_flag):
		reload_timer += delta
		if (reload_timer >= RELOAD_TIME):
			if (projectile == heal && num_healing_potions <= 0 || projectile == beam && num_beam_potions <= 0 || projectile == blackhole && num_blackhole_potions <= 0):
				return
			projectile_instance = projectile.instantiate()
			projectile_instance.position = INITIAL_PROJECTILE_POSITION
			add_child(projectile_instance)
			if projectile == explosion:
				projectile_instance.was_fired.connect(_on_explosion_potion_was_fired)
			elif projectile == heal:
				projectile_instance.was_fired.connect(_on_healing_potion_was_fired)
			elif projectile == beam:
				projectile_instance.was_fired.connect(_on_beam_potion_was_fired)
			elif projectile == blackhole:
				projectile_instance.was_fired.connect(_on_blackhole_potion_was_fired)
			reload_flag = false
			reload_timer = 0

# mouse camera movement
func _unhandled_input(event: InputEvent):
	# If any mouse button is pressed, hide the mouse. Press ESC to bring mouse back
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	# If mouse is hidden, lock mouse movement to camera movement in game
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			# left/right is NOT local because up is always up. it grounds the player's view
			rotate(Vector3.UP, -event.relative.x * look_sensitivity_multiplier)
			# up/down IS local because if it was global, rotations would happen
			rotate_object_local(Vector3.RIGHT, event.relative.y * look_sensitivity_multiplier)
			global_rotation_degrees.x = clamp(-80, global_rotation_degrees.x, 80)
			
	if Input.is_action_pressed("1st weapon") && projectile != explosion:
		projectile = explosion
		if(!reload_flag):
			projectile_instance.queue_free()
		reload_flag = true
		weapon_changed.emit("explosion", "infinity")
		
	elif Input.is_action_pressed("2nd weapon") && projectile != heal:
		projectile = heal
		if(!reload_flag):
			projectile_instance.queue_free()
		reload_flag = true
		weapon_changed.emit("heal", str(num_healing_potions))
		
	elif Input.is_action_pressed("3rd weapon"):
		projectile = beam
		if(!reload_flag):
			projectile_instance.queue_free()
		reload_flag = true
		weapon_changed.emit("beam", str(num_beam_potions))
		
	elif Input.is_action_pressed("4th weapon"):
		projectile = blackhole
		if(!reload_flag):
			projectile_instance.queue_free()
		reload_flag = true
		weapon_changed.emit("blackhole", str(num_blackhole_potions))

func _on_explosion_potion_was_fired():
	$animation_player.play("shoot")
	reload_flag = true
func _on_healing_potion_was_fired():
	$animation_player.play("shoot")
	reload_flag = true
	num_healing_potions -= 1
	ammo_changed.emit(str(num_healing_potions))
func _on_beam_potion_was_fired():
	$animation_player.play("shoot")
	reload_flag = true
	num_beam_potions -= 1
	ammo_changed.emit(str(num_beam_potions))
func _on_blackhole_potion_was_fired():
	$animation_player.play("shoot")
	reload_flag = true
	num_blackhole_potions -= 1
	ammo_changed.emit(str(num_blackhole_potions))
	
	
func take_damage(damage):
	if damage > 0:
		$sfx/take_damage.play()
	var old_hp = current_hp
	current_hp = clamp(0, current_hp - damage, max_hp)
	hp_changed.emit(current_hp, old_hp)
	
func add_points(points_added):
	points += points_added
	points_changed.emit(points)

func _on_hp_changed(curr_hp, _old_hp):
	if curr_hp <= 0:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
