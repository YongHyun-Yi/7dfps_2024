extends Node

var hp : int = 10
var collect_object_current : int = 0 setget set_collect_object_current
var collect_object_max : int = 3
var capture_object_current : int = 0 setget set_capture_object_current
var capture_object_max : int = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_collect_object_current(value):
	collect_object_current = value
	game_cleear_check()
	yield(get_tree().create_timer(.5, false),"timeout")
	$sfx.play()

func set_capture_object_current(value):
	capture_object_current = value
	game_cleear_check()
	yield(get_tree().create_timer(.5, false),"timeout")
	$sfx.play()

func game_cleear_check():
	if (collect_object_current >= collect_object_max) and (capture_object_current >= capture_object_max) :
		$game_clear_screen.show()
		yield(get_tree().create_timer(4.0, false),"timeout")
		get_tree().change_scene("res://title.tscn")
