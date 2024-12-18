extends Control

func _on_play_button_pressed():
	$click_sound.play()
	get_tree().change_scene_to_file("res://Scenes/levels/level1.tscn")

func _on_quit_button_pressed():
	$click_sound.play()
	get_tree().quit()

func _on_tutorial_button_pressed():
	$click_sound.play()
	$"../tutorial_menu".show()

func _on_return_pressed():
	$click_sound.play()
	$"../tutorial_menu".hide()
