extends Control

func _input(event: InputEvent):
	if event.is_action_pressed("jump"):
		Game.change_scene("level1", true)
	if event.is_action_pressed("ui_cancel"):
		var env : Environment = load("res://scenes/env.tres")
		env.sdfgi_enabled = false
		env.glow_enabled = false
		env.ssao_enabled = false
		env.ssil_enabled = false
		env.ssr_enabled = false
		Game.change_scene("level1", true)
