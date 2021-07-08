extends RayCast


var current_collider
var interact_label

onready var cursor = get_node("../../../CanvasLayer/Control/TextureRect")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var collider = get_collider()
	
	if is_colliding() and collider is Interactable:
		if current_collider != collider:
			current_collider = collider
		
		#collider.get_interaction_icon()
		
		if collider.usable:
			cursor.self_modulate = Color("ff0000")
		else:
			cursor.self_modulate = Color("64ff0000")
		
		
	elif current_collider:
		#GlobalRef.uis.get_node("cursor").cursor_reset()
		current_collider = null
		cursor.self_modulate = Color("64ffffff")

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if Input.is_action_just_pressed("left_click"):
				if current_collider:
					current_collider.interact()
