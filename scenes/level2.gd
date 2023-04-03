extends Node3D

@onready var ui = $UI

@onready var skeleton: Skelic = $Skeleton

var textes = {
	"start" : 
		"Шляпа это хорошо, но если я хочу дарить людям радость в виде тако, мне нужно на чём-то их готовить. Для начала подойдёт хоть какая-нибудь сковородка. ",
	"pan": "Есть на чём готовить, есть шляпа - можно приступать к серьёзному бизнесу! Единственное, нужно включить жёлтый фильтр, а то гринго не поймут, что мы в Мексике. "
}
# Called when the node enters the scene tree for the first time.
func init(need_dialog=true):
	skeleton.use_hat(true)
	if need_dialog:
		ui.play_text(textes["start"])
		await ui.text_ended
		
		$Skeleton.start_uncovered()
	else:
		$Skeleton.start_uncovered()



func _on_skeleton_died():
	Game.change_scene("level2", false)



func _on_portal_body_entered(body):
	if body is Skelic:
		Game.change_scene("level3", false)


func _on_pan_body_entered(body):
	if body is Skelic:
		$Portal.show()
		skeleton.use_pan(true)
		$Pan.queue_free()
		skeleton.pause()
		ui.play_text(textes["pan"])
		await ui.text_ended
		
		skeleton.unpause()
		$UI/YellowFilter.show()
		
		$WorldEnvironment.environment = $WorldEnvironment.environment.duplicate()
		$WorldEnvironment.environment.fog_light_color = Color.from_string("ccc38b", Color.LIGHT_YELLOW)
