extends Area3D



func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(999)
