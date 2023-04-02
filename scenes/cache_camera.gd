extends Camera3D


func _ready():
	await get_tree().create_timer(0.2).timeout
	self.current = false
	$"../UI".close_black()
	queue_free()
