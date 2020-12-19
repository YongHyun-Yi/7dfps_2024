extends Control


var current_resolution_index = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func close_button_up():
	get_parent().current_tab = 0
	pass # Replace with function body.


func resolution_selected(index):
	
	var resolutions = [[Vector2(1920, 1080), false], [Vector2(1280, 720), false], [Vector2(960, 540), false], [Vector2(1920, 1080), true], [Vector2(1280, 720), true], [Vector2(960, 540), true]]
	
	if current_resolution_index != index:
		if index == 0:
			pass
		else:
			pass
