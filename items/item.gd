extends Interactable


export var item_name = "normal building"
export (String, MULTILINE) var item_describe = "this is item describe"
export (Texture) var inventory_icon

onready var datas = [item_name, item_describe, inventory_icon, $mesh.mesh]


# Called when the node enters the scene tree for the first time.
func _ready():
	action = actions.hand
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func interact():
	GlobalRef.textbox.text_setting("You got a " + item_name + ".", 2.0)
	GlobalRef.inventory.add_item(datas)
	call("set_collision_layer_bit" , 1, false)
	yield(get_tree(), "idle_frame")
	queue_free()
