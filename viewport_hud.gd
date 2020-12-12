extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalRef.hud = self
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _unhandled_input(event):
	
	if get_focus_owner() == null:
		
		if Input.is_action_just_pressed("call_ingame_menus"):
			
			if Input.is_action_just_pressed("call_ingame_menu1"):
				$ingame_menu/TabContainer.current_tab = 0
			elif Input.is_action_just_pressed("call_ingame_menu2"):
				$ingame_menu/TabContainer.current_tab = 1
			elif Input.is_action_just_pressed("call_ingame_menu3"):
				$ingame_menu/TabContainer.current_tab = 2
			
			$ingame_menu.grab_focus()
		
		elif Input.is_action_just_pressed("ui_cancel"):
			$pause_menu.grab_focus()
