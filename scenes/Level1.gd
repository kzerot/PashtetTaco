extends Node3D

@onready var ui = $UI

@onready var skeleton: Skelic = $Skeleton

var textes = {
	"start" : 
		"Когда я был жив, всё было плохо. За мной охотились картели, я был в долгах по уши. "+
		"Жена меня бросила, вторая тоже. Третья задержалась на три месяца. Я так и не смог осуществить свою мечту... "+
		"Видимо, поэтому мой дух не упокоился. Но теперь я мёртв и пора начать новую... Смержизнь? В общем, вперёд, к мечте! "+
		"Моя смержизнь начинается, и я исполню мечту - открою свою такерейную! Мир узнает вкус моих тако! ",
	"tako": "Для начала мне нужно найти сомбреро. Я не могу готовить тако без сомбреро. ",
		
	"hat": "Отличное сомбреро! А говорят, хорошие вещи на дорогах не валяются. Отлично, теперь надо найти что-то, на чём можно готовить тако. Сковородка подойдёт."
	
}
# Called when the node enters the scene tree for the first time.
func init(need_dialog=true):
	if need_dialog:
		ui.play_text(textes["start"])
		await ui.text_ended
		
		await get_tree().create_timer(0.5).timeout
		ui.play_text(textes["tako"])
		await ui.text_ended
		$Skeleton.uncover()
	else:
		$Skeleton.start_uncovered()



func _on_skeleton_died():
	Game.change_scene("level1", false)


func _on_hat_body_entered(body):
	if body is Skelic:
		skeleton.use_hat(true)
		$Hat.queue_free()
		skeleton.pause()
		ui.play_text(textes["hat"])
		await ui.text_ended
		
		skeleton.unpause()


func _on_portal_body_entered(body):
	if body is Skelic:
		Game.change_scene("level2", true)
