extends Node

var current_scene : Node

func change_scene(scene_name, params=null):
	if is_instance_valid(current_scene):
		current_scene.queue_free()
	
	current_scene = load("res://scenes/%s.tscn"%scene_name).instantiate()
	add_child(current_scene)
	
	if is_instance_valid(get_tree().current_scene):
		get_tree().current_scene.queue_free()

	if current_scene.has_method("init"):
		current_scene.init(params)

func _ready():
	change_scene("level3", true)
