extends Control

signal text_ended

var tween: Tween
# Called when the node enters the scene tree for the first time.
	

func _input(event: InputEvent):
	if event.is_action("jump"):
		if $Text.visible and is_instance_valid(tween):
			tween.stop()
			$Text.hide()
			text_ended.emit()
	
	if event is InputEventKey and event.pressed and event.physical_keycode == KEY_F:
		get_window().mode = Window.MODE_FULLSCREEN if get_window().mode != Window.MODE_FULLSCREEN else Window.MODE_WINDOWED

func close_black():
	$Dark.hide()
	
func play_text(txt: String):
	var text : RichTextLabel = %Text
	text.visible_characters = 0
	text.clear()
	$Text.show()
	text.push_paragraph(HORIZONTAL_ALIGNMENT_CENTER)
	text.append_text(txt)
	text.pop()
	tween = create_tween()
	var seconds =  float(txt.length())*0.05
	tween.tween_property(text, "visible_characters", txt.length(), seconds)
	await tween.finished
	await get_tree().create_timer(1.0).timeout
	if $Text.visible:
		$Text.hide()
		text_ended.emit()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
