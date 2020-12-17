extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _gui_input(event):
	#if Input.is_action_just_pressed("call_ingame_menu1"):
	#	$TabContainer.current_tab = 0
	#if Input.is_action_just_pressed("call_ingame_menu2"):
	#	$TabContainer.current_tab = 1
	#if Input.is_action_just_pressed("call_ingame_menu3"):
	#	$TabContainer.current_tab = 2
	
	if Input.is_action_just_pressed("zoom_out"):
		if $TabContainer.current_tab < $TabContainer.get_tab_count() - 1:
			$TabContainer.current_tab += 1
	elif Input.is_action_just_pressed("zoom_in"):
		if $TabContainer.current_tab > 0:
			$TabContainer.current_tab -= 1
	
	if Input.is_action_just_pressed("tab_key") or Input.is_action_just_pressed("right_click"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		hide()
		get_parent().emit_signal("close_menu")
		$AnimationPlayer.play("reset")
	
	accept_event()


func focus_entered():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	show()
	pass # Replace with function body.


func tab_changed(tab):
	$AnimationPlayer.stop()
	$AnimationPlayer.play("open")
	pass # Replace with function body.
