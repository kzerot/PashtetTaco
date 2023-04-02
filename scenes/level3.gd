extends Node3D

@onready var ui = $UI

@onready var skeleton = $Skeleton

var textes = {
	"start" : 
		"И вот так, наш бравый герой начал свою новую жизнь после окочания предыдущей. И вовсе не потому были его приключения коротки, что автору игры было лень и мало времени клепать контент!"
}

# Called when the node enters the scene tree for the first time.
func init(need_dialog=true):

	ui.play_text(textes["start"])
	await ui.text_ended
	

	$AnimationPlayer.play("Movie")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("Credits")


