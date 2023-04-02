extends Control

func _input(event: InputEvent):
	if event.is_action_pressed("jump"):
		Game.change_scene("level1", true)
