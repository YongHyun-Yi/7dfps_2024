extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _gui_input(event): #GlobalRef.hud.get_parent().set_disable_input(false)
	if Input.is_action_just_pressed("ui_cancel") or Input.is_action_just_pressed("right_click"):
		if $TabContainer.current_tab == 0:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			get_tree().paused = false
			hide()
		else:
			$TabContainer.current_tab = 0
	
	accept_event()


func focus_entered():
	if !visible:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().paused = true
		$TabContainer.current_tab = 0
		show()
	pass # Replace with function body.


func loadbutton_up():
	$TabContainer.current_tab = 1
	pass # Replace with function body.


func restart_button_up():
	get_tree().reload_current_scene()
	get_tree().paused = false
	hide()
	pass # Replace with function body.


func option_button_up():
	$TabContainer.current_tab = 2
	pass # Replace with function body.


func title_button_up():
	get_tree().change_scene("res://title.tscn")
	get_tree().paused = false
	pass # Replace with function body.


func close_button_up():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().paused = false
	hide()
	pass # Replace with function body.
