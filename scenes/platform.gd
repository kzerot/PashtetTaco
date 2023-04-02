extends CharacterBody3D

@export_node_path("Node3D") var target_path
@export var time: float = 2.0
var target_position : Vector3
var initial_position : Vector3
var tween : Tween
var going_toward = true
func _ready():
	if target_path: 
		target_position = get_node(target_path).global_position
	else:
		target_position = get_child(0).global_position
	initial_position = position
	tween_me()
	
func tween_me():	
	await get_tree().create_timer(1.0).timeout
	tween = create_tween()
	tween.tween_property(self, "position", target_position if going_toward else initial_position, time)
	tween.finished.connect(tween_finished)
	
func tween_finished():
	going_toward = not going_toward
	tween_me()

