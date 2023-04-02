extends Area3D

@export var strength : float = 20
func _on_body_entered(body):
	if body is Skelic:
		body.additional_gravity[self] = strength


func _on_body_exited(body):
	if body is Skelic:
		body.additional_gravity.erase(self)
