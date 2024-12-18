extends Control

@onready var hud = $hud
@onready var hp_label = $"hud/hp label"
@onready var points_count = $"hud/points count"
@onready var ammo = $hud/ammo
@onready var current_weapon_label = $hud/current_weapon_label
@onready var timer_label = $hud/timer
@onready var game_over_menu = $game_over_menu
@onready var pause_menu = $pause_menu
@onready var buy_menu = $buy_menu
@onready var notification_label = $buy_menu/notification
@onready var buy_menu_points_count = $buy_menu/current_points
@onready var player = $".."
@onready var potion_icon = $hud/potion_icon

@onready var explosion_hud = preload("res://assets/potion_icons/Potion.Explosion.HUDIcon.png")
@onready var healing_hud = preload("res://assets/potion_icons/Potion.Healing.HUDIcon.png")
@onready var beam_hud = preload("res://assets/potion_icons/Potion.Beam.HUDIcon.png")
@onready var blackhole_hud = preload("res://assets/potion_icons/Potion.AllConsumingVoid.HUDIcon.png")

@onready var heal_pot_count = $buy_menu/heal_pot_button/heal_pot_count
@onready var beam_pot_count = $buy_menu/beam_pot_button/beam_pot_count
@onready var blackhole_pot_count = $buy_menu/blackhole_pot_button/blackhole_pot_count

@export var timer = 0.0

func _ready():
	player.hp_changed.connect(_on_player_hp_changed)
	player.points_changed.connect(_on_player_points_changed)

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel") && !game_over_menu.visible:
		if !get_tree().is_paused() :
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			pause_menu.show()
			if !buy_menu.visible:
				get_tree().paused = true
			
	if Input.is_action_just_pressed("Buy") && !game_over_menu.visible:
		get_tree().paused = true
		$click.play()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		$buy_menu/BuyMenu_crafted.hide()
		$buy_menu/BuyMenu_craftNewPotionsOnTheFly.show()
		$buy_menu/BuyMenu_notEnoughPoints.hide()
		buy_menu_points_count.text = "Points: " + str(player.points)
		heal_pot_count.text = "YOU HAVE: " + str(player.num_healing_potions)
		beam_pot_count.text = "YOU HAVE: " + str(player.num_beam_potions)
		blackhole_pot_count.text = "YOU HAVE: " + str(player.num_blackhole_potions)
		buy_menu.show()
			
	# timer logic
	timer += delta
	timer_label.text = "Time Lived: " + str(floor(timer))
	

# uses signal emitted from player to update hp on ui
func _on_player_hp_changed(curr_hp: int, old_hp: int):
	if (curr_hp < old_hp):
		$"healed-color".hide()
		$"damaged-color".show()
		$AnimationPlayer.play("fade")
	else:
		$"damaged-color".hide()
		$"healed-color".show()
		$AnimationPlayer.play("heal_fade")
	
	hp_label.text = "HP: " + str(curr_hp)
	if curr_hp <= 0:
		hud.process_mode = Node.PROCESS_MODE_DISABLED
		game_over_menu.visible = true
		
		
func _on_player_points_changed(curr_points: int):
	points_count.text = "Points: " + str(curr_points)


func _on_resume_button_pressed():
	$click.play()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pause_menu.hide()
	get_tree().paused = false

func _on_retry_button_pressed():
	$click.play()
	get_tree().reload_current_scene()

func _on_quit_button_pressed():
	$click.play()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/ui/main_menu.tscn")

func _on_player_weapon_changed(weapon_changed_to, ammo_count):
	
	if weapon_changed_to == "explosion":
		potion_icon.texture = explosion_hud
	elif weapon_changed_to == "heal":
		potion_icon.texture = healing_hud
	elif weapon_changed_to == "beam":
		potion_icon.texture = beam_hud
	elif weapon_changed_to == "blackhole":
		potion_icon.texture = blackhole_hud
	current_weapon_label.text = "POTION\n " + weapon_changed_to.to_upper()
	ammo.text = "Ammo: " + ammo_count

func _on_player_ammo_changed(ammo_count):
	ammo.text = "Ammo: " + ammo_count


func _on_return_button_pressed():
	$click.play()
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	buy_menu.hide()


func _on_heal_pot_button_pressed():
	if player.points < 100:
		$buy_menu/BuyMenu_crafted.hide()
		$buy_menu/BuyMenu_craftNewPotionsOnTheFly.hide()
		$buy_menu/BuyMenu_notEnoughPoints.show()
	else:
		$buy_menu/BuyMenu_craftNewPotionsOnTheFly.hide()
		$buy_menu/BuyMenu_notEnoughPoints.hide()
		$buy_menu/BuyMenu_crafted.show()
		player.points -= 100
		player.num_healing_potions += 1
		
		buy_menu_points_count.text = "Points: " + str(player.points)
		points_count.text = "Points: " + str(player.points)
		heal_pot_count.text = "YOU HAVE: " + str(player.num_healing_potions)
		if current_weapon_label.text == "POTION\n HEAL":
			ammo.text = "Ammo: " + str(player.num_healing_potions)
	$click.play()

func _on_beam_pot_button_pressed():
	if player.points < 150:
		$buy_menu/BuyMenu_crafted.hide()
		$buy_menu/BuyMenu_craftNewPotionsOnTheFly.hide()
		$buy_menu/BuyMenu_notEnoughPoints.show()
	else:
		$buy_menu/BuyMenu_craftNewPotionsOnTheFly.hide()
		$buy_menu/BuyMenu_notEnoughPoints.hide()
		$buy_menu/BuyMenu_crafted.show()
		player.points -= 150
		player.num_beam_potions += 1
		
		buy_menu_points_count.text = "Points: " + str(player.points)
		points_count.text = "Points: " + str(player.points)
		beam_pot_count.text = "YOU HAVE: " + str(player.num_beam_potions)
		if current_weapon_label.text == "POTION\n BEAM":
			ammo.text = "Ammo: " + str(player.num_beam_potions)
	$click.play()

func _on_blackhole_pot_button_pressed():
	if player.points < 1000:
		$buy_menu/BuyMenu_crafted.hide()
		$buy_menu/BuyMenu_craftNewPotionsOnTheFly.hide()
		$buy_menu/BuyMenu_notEnoughPoints.show()
	else:
		$buy_menu/BuyMenu_craftNewPotionsOnTheFly.hide()
		$buy_menu/BuyMenu_notEnoughPoints.hide()
		$buy_menu/BuyMenu_crafted.show()
		player.points -= 1000
		player.num_blackhole_potions += 1
		
		buy_menu_points_count.text = "Points: " + str(player.points)
		points_count.text = "Points: " + str(player.points)
		blackhole_pot_count.text = "YOU HAVE: " + str(player.num_blackhole_potions)
		if current_weapon_label.text == "POTION\n BLACKHOLE":
			ammo.text = "Ammo: " + str(player.num_blackhole_potions)
	$click.play()
