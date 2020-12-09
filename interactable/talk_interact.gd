extends Interactable


var talk = false

export var text : String

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func interact():
	if talk == false:
		talk = true
		get_node("/root/Spatial/textbox").text_setting(text)
		yield(get_tree(), "idle_frame")
		yield(get_node("/root/Spatial/textbox"), "next_text")
		get_node("/root/Spatial/textbox").text_setting("")
		talk = false
	
	pass
