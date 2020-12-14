extends Control


export (PackedScene) var game_start


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func start_button_up():
	get_tree().change_scene_to(game_start)
	get_tree().paused = false
	pass # Replace with function body.


func quit_button_up():
	get_tree().quit()
	pass # Replace with function body.
